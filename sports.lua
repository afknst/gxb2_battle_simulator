require("preload")

local M = 500
local SEEDS = get_seeds(M)

local TA = {
    str = {
        89096,
        89083,
        89087,
        89100,
        89093,
        89105,
    },
    pos = {1, 2, 3, 4, 5, 6},
}

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

local PARAMS = sports_params(TA, TB)
print_girls(PARAMS)
local report = fight(PARAMS, SEEDS, true)

print(get_report(report))
