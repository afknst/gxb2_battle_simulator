require("preload")

local M = 10
local SEEDS = get_seeds(M)

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
local Test2 = {
	girls = {
		{
			name = "Holly",
			pos = 1,
			potentials = { 1, 1, 3, 1, 2 },
			travel = 2105,
			gear_skill = 3,
			equips = { 1269, 2269, 3269, 4269, 5750, 6718, 7178 },
		},
		{
			name = "Aurora",
			pos = 2,
			potentials = { 3, 1, 3, 3, 2 },
			travel = 2703,
			gear_skill = 0,
			equips = { 1366, 2366, 3366, 4366, 5754, 6718, 0 },
		},
		{
			name = "Monica",
			pos = 3,
			potentials = { 1, 3, 3, 1, 2 },
			travel = 3004,
			gear_skill = 3,
			equips = { 1569, 2569, 3569, 4569, 5754, 6724, 7204 },
		},
		{
			name = "Angelica",
			pos = 4,
			potentials = { 2, 2, 3, 2, 2 },
			travel = 3002,
			gear_skill = 3,
			equips = { 1369, 2369, 3369, 4369, 5756, 64423, 7195 },
		},
		{
			name = "Angelica",
			pos = 5,
			potentials = { 2, 2, 3, 2, 2 },
			travel = 3002,
			gear_skill = 3,
			equips = { 1369, 2369, 3369, 4369, 5756, 6448, 0 },
		},
		{
			name = "Monica",
			pos = 6,
			potentials = { 1, 3, 3, 1, 2 },
			travel = 3004,
			gear_skill = 3,
			equips = { 1568, 2568, 3568, 4568, 5750, 6724, 0 },
		},
	},
	servant = {
		name = "Deerling",
		UC = 100,
	},
	guild_skills = GUILD_1ST_PAGE,
}

local PARAMS = PvP_params(Test1, Test2)

print_girls(PARAMS)

local report = fight(PARAMS, SEEDS, true)

print(get_report(report))
