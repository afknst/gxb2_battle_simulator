import sys

import pexpect
import numpy as np

NUM = 3
INITS = np.random.randint(2**23, size=NUM)
CHILDS = [pexpect.spawn('lua -i -l preload') for _ in range(NUM)]

for i in range(NUM):
    CHILDS[i].logfile = sys.stdout.buffer
for i in range(NUM):
    CHILDS[i].expect('>')

for i in range(NUM):
    CHILDS[i].sendline(f'init({INITS[i]}, {i})')
for i in range(NUM):
    CHILDS[i].expect('>')

for i in range(NUM):
    CHILDS[i].sendline('require("gxb2_battle")')
for i in range(NUM):
    CHILDS[i].expect('>')

for i in range(NUM):
    CHILDS[i].close()
