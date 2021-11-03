# gxb2_battle_simulator
Battle simulator for GxB2

## Principles
 1. No modification/distribution of the decompiled code (just soft link them).
 1. For private use only.
 1. Avoid external dependencies if possible.
 1. Both `EN` and `CN` for `tables.lua`.
 1. Only `EN` for the other files.

## To-do list
- [x] PvP
- [x] EvE
- [x] PvE
- [ ] [Multithreading](http://lualanes.github.io/lanes/)
- [ ] [EA](https://en.wikipedia.org/wiki/Evolutionary_algorithm)

## Examples
### Symlinks
Currently we only need to link 4 directories: `app`, `base`, `data`, and `lib`. E.g.:    
`ln -s <DECOMPILED CODE/src/app> <HERE/app>`

### PvP
`lua gxb2_battle.lua`

### EvE
`lua sports.lua`

### PvE
`lua PvE.lua`

## [Troubleshooting](https://en.wikipedia.org/wiki/Do_it_yourself)
