require("preload")

local teams = require("teams")

local M = 10
local SEEDS = get_seeds(M)

local TA = teams[1]

local TB = {
    str = {
        89099,
        89102,
        89100,
        89092,
        89090,
        89094
    },
    pos = {1, 2, 3, 4, 5, 6},
}

local PARAMS = PvE_params(TA, TB)
print_girls(PARAMS)
local report = fight(PARAMS, SEEDS, true)

print(get_report(report))
