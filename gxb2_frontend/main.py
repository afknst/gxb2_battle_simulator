import asyncio
import shlex
import socket
import subprocess
import logging
from pathlib import Path
from typing import Dict
from time import sleep

import aiohttp
import numpy as np

log_file = Path("./Gxb2.log")
log_file.unlink(missing_ok=True)
logging.basicConfig(filename=log_file, level=logging.INFO)


def debug(msg: str):
    if logging.DEBUG >= logging.root.level:
        logging.debug(msg)


def info(msg: str):
    if logging.INFO >= logging.root.level:
        logging.info(msg)


def get_free_ports(n=7):
    socks = []
    ports = []
    for _ in range(n):
        sock = socket.socket()
        sock.bind(("localhost", 0))
        ports.append(sock.getsockname()[1])
        socks.append(sock)

    for sock in socks:
        sock.close()
    return ports


class Worker:

    def __init__(self, port: int, process: subprocess.Popen, mode="PvP"):
        self.port = port
        self.process = process
        self.mode = mode
        self.url = f"http://localhost:{port}/{mode}"
        self.task: asyncio.Task = None
        self.res = None
        self.session: aiohttp.ClientSession = None

    def set_session(self, session: aiohttp.ClientSession):
        self.session = session

    def is_busy(self):
        if self.task is None:
            return False
        if self.task.done():
            self.res = self.task.result()
            self.task = None
            debug(f"DONE: {self.port}")
            return False
        return True

    async def execute(self, data: dict):
        debug(f"STARTED: {self.port}")
        timeout = aiohttp.ClientTimeout(total=len(data["seeds"]) * 3)

        try:
            async with self.session.post(
                    self.url,
                    json=data,
                    timeout=timeout,
            ) as resp:
                debug(f"GOT: {self.port} {resp.status}")
                if resp.status == 200:
                    resp_data = await resp.json()
                    return resp_data
                return None
        except Exception as e:  # pylint: disable=broad-except
            info(e)
            return None

    async def post(self, data: dict):
        assert not self.is_busy()
        self.task = asyncio.create_task(self.execute(data))
        debug(f"CREATED: {self.port}")

    def terminate(self):
        self.process.terminate()


class GxB2:

    def __init__(self, n=7, mode="PvP", rng=None):
        self.n = n
        self.mode = mode
        self.rng = np.random.default_rng(rng)
        self.workers: Dict[int, Worker] = {}
        self.is_busy: Dict[int, bool] = {}
        self.session = aiohttp.ClientSession()
        self.start_servers()

    def start_servers(self):
        for port in get_free_ports(self.n):
            self.add_worker(port)
        sleep(1)

    def add_worker(self, port: int):
        cmd = f"luajit -e \'require(\"server\")({port})\'"
        process = subprocess.Popen(
            shlex.split(cmd),
            cwd=Path("../gxb2_backend/"),
        )
        worker = Worker(port, process, self.mode)
        worker.set_session(self.session)
        self.workers[port] = worker
        self.is_busy[port] = False

    def close_servers(self):
        for worker in self.workers.values():
            worker.terminate()
        self.workers = {}
        self.is_busy = {}

    async def close(self):
        self.close_servers()
        await self.session.close()

    def check(self):
        for port, worker in self.workers.items():
            self.is_busy[port] = worker.is_busy()

    def restart(self):
        self.close_servers()
        self.start_servers()

    def restart_one(self, port):
        info(f"RESTART: {port}")
        self.workers[port].terminate()
        del self.workers[port]
        del self.is_busy[port]
        self.add_worker(port)

    def get_seeds(self, size=1):
        return self.rng.integers(2**23, size=size)

    async def post(self, data: dict):
        while True:
            self.check()
            for port, is_busy in self.is_busy.items():
                if not is_busy:
                    debug(f"POSTED: {port}")
                    await self.workers[port].post(data)
                    return port
            await asyncio.sleep(0.5)

    async def fight(self, tA: dict, tB: dict, size: int):
        while True:
            port = await self.post({
                "seeds": self.get_seeds(size=size).tolist(),
                "tA": tA,
                "tB": tB,
            })
            worker = self.workers[port]
            await worker.task
            self.check()
            if worker.res is None:
                self.restart_one(port)
                continue
            debug(f"FINISHED: {port}")
            return np.mean(worker.res["wins"])


async def main():
    G = GxB2()
    NUM = 10
    TA = {
        "girls": [
            {
                "name": "Lord Dracula",
                "lv": 330,
                "star": 15,
                "love_point": 100,
                "ex_skills": [5, 5, 5, 5],
                "pos": 1,
                "excursion": 3,
                "potentials": [3, 2, 3, 1, 1],
                "gear_skill": 1,
                "core": "PINK3 Heal Received/HP",
                "antique": "Sacred Vial P3"
            },
        ],
        "servant": {
            "name": "Deerling",
            "UC": 100,
        }
    }
    TB = {
        "girls": [{
            "name": "Vera",
            "lv": 330,
            "star": 15,
            "love_point": 100,
            "ex_skills": [5, 5, 5, 5],
            "pos": 3,
            "excursion": 3,
            "potentials": [3, 1, 2, 2, 3],
            "gear_skill": 2,
            "core": "PINK3 Heal Received/HP",
            "antique": "Eternal Dawn P3"
        }],
        "servant": {
            "name": "Hunter",
            "UC": 80,
        }
    }

    TASKS: list[asyncio.Task] = []

    for _ in range(7):
        TASKS.append(asyncio.create_task(G.fight(TA, TB, NUM)))

    for TASK in TASKS:
        await TASK
        print(TASK.result())

    await G.close()


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
