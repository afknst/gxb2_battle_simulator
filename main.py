import sys
import sqlite3
from pathlib import Path

import pexpect
import numpy as np
import pandas as pd

DB = Path("./data.sqlite3")
TABLE = 'TEST'
CONN = sqlite3.connect(DB)
ENTRIES = ", ".join([
    "id INTEGER PRIMARY KEY",
    "win INTEGER",
])
C = CONN.cursor()
C.execute(f"CREATE TABLE IF NOT EXISTS {TABLE} ({ENTRIES});")
DB_CODE = f'submit("INSERT INTO {TABLE} VALUES (NULL, " .. report.isWin .. ");")'


class GxB2:
    def __init__(self, n=3, rng=None):
        if rng is None:
            rng = np.random.default_rng()
        else:
            rng = np.random.default_rng(rng)
        self.n = n
        self.rng = rng
        self.fin = [False] * n
        self.lua = [pexpect.spawn('lua -i -l preload') for _ in range(n)]
        self.send([f'init({rng.integers(2**23)}, {_})' for _ in range(n)])
        self.wait()

    def set_logfile(self, file):
        for lua in self.lua:
            lua.logfile = file

    def check(self):
        for i in range(self.n):
            if not self.fin[i]:
                if not self.lua[i].expect(['>', pexpect.TIMEOUT], timeout=0.1):
                    self.fin[i] = True

    def wait(self):
        while not np.all(self.fin):
            self.check()

    def send_string(self, lua_code: str):
        sent = [False] * self.n

        while not np.all(sent):
            for i in range(self.n):
                if not sent[i]:
                    if self.fin[i]:
                        self.lua[i].sendline(lua_code)
                        sent[i] = True
                        self.fin[i] = False
                    else:
                        self.check()

    def send_list(self, lua_code: list, ordered=True):
        if ordered:
            sent = [False] * self.n
            while not np.all(sent):
                for i in range(self.n):
                    if not sent[i]:
                        if self.fin[i]:
                            self.lua[i].sendline(lua_code[i])
                            sent[i] = True
                            self.fin[i] = False
                        else:
                            self.check()
        else:
            for code in lua_code:
                sent = False
                while not sent:
                    self.check()
                    for i in range(self.n):
                        if self.fin[i]:
                            self.lua[i].sendline(code)
                            sent = True
                            self.fin[i] = False
                            break

    def send(self, lua_code, ordered=True):
        if isinstance(lua_code, str):
            self.send_string(lua_code)
        elif isinstance(lua_code, list):
            if len(lua_code) != self.n:
                ordered = False
            self.send_list(lua_code, ordered=ordered)

    def seeds(self, M):
        return self.rng.integers(2**23, size=M)

    def fight(self, M):
        lua_code = [
            f'report = createReport(params, {_}); {DB_CODE}'
            for _ in self.seeds(M)
        ]
        self.send(lua_code, ordered=False)

    def close(self):
        self.wait()
        for lua in self.lua:
            lua.close()


if __name__ == '__main__':
    G = GxB2()
    G.set_logfile(sys.stdout.buffer)
    G.send('params = require("gxb2_battle")')
    G.fight(100)
    G.close()

    T = pd.read_sql(f"SELECT * FROM {TABLE}", CONN)
    T.info()
    print(np.mean(T.win))
