import sys

import pexpect
import numpy as np


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

    def send(self, lua_code):
        sent = [False] * self.n

        if isinstance(lua_code, str):
            lua_code = [lua_code] * self.n

        while not np.all(sent):
            for i in range(self.n):
                if not sent[i]:
                    if self.fin[i]:
                        self.lua[i].sendline(lua_code[i])
                        sent[i] = True
                        self.fin[i] = False
                    else:
                        self.check()

    def close(self):
        self.wait()
        for lua in self.lua:
            lua.close()


if __name__ == '__main__':
    G = GxB2()
    G.set_logfile(sys.stdout.buffer)
    G.send('main = require("gxb2_battle")')
    G.send('main()')
    G.send('main()')
    G.send('main()')
    G.close()
