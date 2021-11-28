# gxb2_battle_simulator
Battle simulator for GxB2.  
You'll need the original code of the game to make the simulator work. See [#2](https://github.com/afknst/gxb2_battle_simulator/issues/2) for more details.  
Currently we only need 4 directories: `app`, `base`, `data`, and `lib`.  
To create a soft link, for example: `ln -s <DECOMPILED CODE/src/app> <HERE/app>`

## Principles
 1. No modification/distribution of the decompiled code (simply soft link them).
 1. For private use only.
 1. ~~Avoid external dependencies if possible.~~ (I lied...)
 1. Both `EN` and `CN` for `tables.lua`.
 1. Only `EN` for the other files.

## To-do list
- [x] PvP
- [x] EvE
- [x] PvE
- [x] Multiprocessing ([#6](https://github.com/afknst/gxb2_battle_simulator/issues/6))
- [ ] [EA](https://en.wikipedia.org/wiki/Evolutionary_algorithm) ([#5](https://github.com/afknst/gxb2_battle_simulator/issues/5))

## Dependencies
[Lua](https://www.lua.org) and [cjson](https://www.kyne.com.au/~mark/software/lua-cjson.php) is required by the original code.   
For multiprocessing, we use a [Python](https://www.python.org) wrapper with the following packages: [pexpect](https://github.com/pexpect/pexpect) and [numpy](https://numpy.org).

We may use these packages as well in the future: [sqlite](https://www.sqlite.org/index.html), [lsqlite3](http://lua.sqlite.org/index.cgi/ticket), and [pandas](https://pandas.pydata.org).  

## Examples
Copy the scripts you want to run from [`examples`](https://github.com/afknst/gxb2_battle_simulator/blob/main/examples) to the project's home directory, or create your own script.

### PvP
`lua PvP.lua`

### EvE
`lua sports.lua`

### PvE
`lua PvE.lua`

### Multiprocessing
`python main.py`

## Troubleshooting
Please refer to the [issues](https://github.com/afknst/gxb2_battle_simulator/issues) page.  
You can also post a new issue if people haven't mentioned the problem before.