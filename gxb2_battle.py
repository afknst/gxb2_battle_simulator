#!/usr/bin/python3
# Pls run 'python3 gxb2_battle.py'
# This is a python wrapper for the lua emulator. Since Lua doesn't have native multiple
# process support, we use python3 wrapper to make it run on multiple CPUs (Cores) in
# parallel.
# 
# teams are located in 'teams' directory, one team each file. Each file should and only contain
# contents like this:
# 
'''
local Test1 = {
	girls = {
		{
			name = "Holly",
			pos = 1,
			potentials = { 1, 1, 3, 1, 2 },
			travel = 3001,
			gear_skill = 3,
			equips = { 1269, 2269, 3269, 4269, 5750, 67183, 7202 },
		},
		{
			name = "Von Helsing",
			pos = 2,
			potentials = { 2, 2, 3, 2, 2 },
			travel = 2703,
			gear_skill = 0,
			equips = { 1366, 2366, 3366, 4366, 5749, 6448, 7174 },
		},
		{
			name = "Izanami",
			pos = 3,
			potentials = { 3, 1, 3, 3, 2 },
			travel = 3004,
			gear_skill = 3,
			equips = { 1569, 2569, 3569, 4569, 5754, 67303, 7191 },
		},
		{
			name = "Sivney",
			pos = 4,
			potentials = { 1, 3, 3, 1, 2 },
			travel = 3001,
			gear_skill = 3,
			equips = { 1569, 2569, 3569, 4569, 5750, 67243, 7211 },
		},
		{
			name = "Monica",
			pos = 5,
			potentials = { 1, 3, 3, 1, 2 },
			travel = 3001,
			gear_skill = 3,
			equips = { 1569, 2569, 3569, 4569, 5750, 67243, 7218 },
		},
		{
			name = "Angelica",
			pos = 6,
			potentials = { 2, 2, 3, 2, 2 },
			travel = 3002,
			gear_skill = 3,
			equips = { 1369, 2369, 3369, 4369, 5756, 64423, 7212 },
		},
	},
	servant = {
		name = "Kraken",
		UC = 100,
	},
	guild_skills = GUILD_1ST_PAGE,
}
'''

import optparse
import multiprocessing
from multiprocessing import Process
import time
import os
import sys

multiprocessing.set_start_method('fork')

# Number of CPU Cores, we start N - 1 processes by default (N is number of of cores).
NR_CPUs = multiprocessing.cpu_count()

debug = print
usage_str = '''
Emulator wrapper.
Usage: %s [options]
Valid options:
    -c, --cpus      max cores to use in parallel, number of cores minus 1 by default.
    -b, --battle    battle times for each team pair, 50 by default
    -d, --dir       the directory where team files are stored, "./teams" by default.
'''

def get_team_name(file):
    f = open(file, "r")
    line = f.readline()
    fields = line.split()
    f.close()
    return fields[1]

# create the lua script file and return its name
def create_lua_pvp_script(file1, file2, nr_battles):
    file_name = "pvp_%d.lua" % os.getpid()
    fo = open(file_name, "w")
    fo.write('require("preload")\n')
    fo.write('\n')
    fo.write('local M = %d\n' % nr_battles)
    fo.write('local SEEDS = get_seeds(M)\n')
    fo.write('\n')
    for file in [file1, file2]:
        fi = open(file, "r")
        for line in fi:
            fo.write(line)
        fi.close

    team1 = get_team_name(file1)
    team2 = get_team_name(file2)
    fo.write("local PARAMS = PvP_params(%s, %s)\n" % (team1, team2))
    fo.write("\n")
    fo.write('save(get_girl_params(PARAMS), "result_%s_VS_%s.log")\n' % (team1, team2))
    fo.write("\n")
    fo.write("local report = fight(PARAMS, SEEDS, true)\n")
    fo.write("\n")
    fo.write('save(get_report(report), "result_%s_VS_%s.log")\n' % (team1, team2))
    fo.flush()
    fo.close()
    return file_name

def process_team_pair_fight(file1, file2, nr_battles):
    filename = create_lua_pvp_script(file1, file2, nr_battles)
    os.system("lua %s" % filename)
    sys.exit(0)

def main():
    p = optparse.OptionParser(usage_str)
    p.add_option('-c', '--cpus',
                dest='nr_cpus',
                help="max cores to run in parallel.",
                default=str(NR_CPUs - 1))
    p.add_option('-b', '--battle',
                dest='nr_battles',
                help="tattle times for team pairs.",
                default=str(50))

    p.add_option("-d", "--dir",
                dest="team_dir",
                help="the directory where team files are stored.",
                default="./teams")

    options, cmds = p.parse_args()
    nr_cpus = int(options.nr_cpus)
    if nr_cpus == 0:
        nr_cpus = 1

    nr_battles = int(options.nr_battles)
    if nr_battles == 0:
        nr_battles = 1

    file_dirs = os.listdir(options.team_dir)
    conf_files = []
    for fd in file_dirs:
        if os.path.isfile(options.team_dir + "/" + fd):
            conf_files.append(options.team_dir + "/" + fd)
    if not conf_files:
        print("no team files found, exit")
        sys.exit(1)

    conf_files_copy = []
    for fd in conf_files:
        conf_files_copy.append(fd)

    processes = []
    for fd1 in conf_files:
        for fd2 in conf_files_copy:
            p = Process(target=process_team_pair_fight, args=(fd1,fd2, nr_battles,))
            processes.append(p)
            p.start()
            if len(processes) == nr_cpus:
                while 1:
                    terminated = []
                    for p in processes:
                        if p.exitcode != None:
                            terminated.append(p)
                            p.join()
                    if terminated:
                        for p in terminated:
                            processes.remove(p)
                        break  # break the  while loop
                    else:
                        # all processes are busy, wait a while, then check again
                        time.sleep(0.1)
    for p in processes:
        p.join()

    # clear existing pvp_<pid>.lua
    os.system("rm -f pvp_*.lua")

main()
