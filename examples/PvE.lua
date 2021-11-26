require("preload") --https://docs.google.com/spreadsheets/d/1FAw5ttUYoRXvshwFc5CHJQ8h1PDOE38T8grP-Ri1Rag/edit#gid=1463175644

local teams = require("teams")

local M = 20
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

local GB61 = {
    str = {
        4113
    },
    pos = {1},
}
local Sanct = {
    str = {
        88001
    },
    pos = {1},
}
local EoT = {
    str = {
        30065
    },
    pos = {1},
}
local PWAngelica = {
    str = {
        9065
    },
    pos = {1},
}
local PWKassy = {
    str = {
        9066
    },
    pos = {1},
}
local PWFrexie = {
    str = {
        9067
    },
    pos = {1},
}
local PWNeph = {
    str = {
        9068
    },
    pos = {1},
}

local TeamSS = {
    girls = {
		{name = "Apate", pos = 1, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Kassy", pos = 2, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 2, core = "Attack/Attack", antique = "P3 Thorn's Heart",},
		{name = "Sivney", pos = 3, potentials = {3,3,3,3,2}, excursion = 1, gear_skill = 3, core = "Speed/HP", antique = "P3 Thorn's Heart",},
		{name = "Izanami", pos = 4, potentials = {2,2,3,2,2}, excursion = 1, gear_skill = 3, core = "Speed/HP", antique = "P3 Neutron Blades",},
		{name = "Kassy", pos = 5, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 2, core = "Attack/Attack", antique = "P3 Thorn's Heart",},
		{name = "Angelica", pos = 6, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",}},
    servant = {
        name = "Hunter",
        UC = 100,
    },
    guild_skills = GUILD_1ST_PAGE,
}
local SalaSS = {
    girls = {{
		name = "Apate",
		pos = 1,
		potentials = {2, 2, 2, 2, 2},
		excursion = 2,
		equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "Attack/Attack",
		antique = "Soul Destruction",
	},{
		name = "Angelica",
		pos = 2,
		potentials = {2, 2, 2, 2, 2},
		excursion = 2,
		gear_skill = 3,
		core = "Attack/Attack",
		antique = "The Wings of Icarus P3",
	},{
		name = "Kassy",
		pos = 3,
		potentials = {2, 2, 2, 2, 2},
		excursion = 2,
		gear_skill = 3,
		core = "Attack/Attack",
		antique = "Fate Crystal P2",
	},{
		name = "Linky",
		pos = 4,
		lv = 250,
		awake = 0,
		potentials = {0, 0, 0, 0, 0},
		excursion = 1,
		equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "HP/HP",
		antique = "Queen's Crown",
	},{
		name = "Sivney",
		pos = 5,
		lv = 250,
		awake = 0,
		potentials = {0, 0, 0, 0, 0},
		excursion = 1,
		gear_skill = 3,
		core = "HP/HP",
		antique = "Yume Lantern",
	},{
		name = "Izanami",
		pos = 6,
		potentials = {3, 3, 3, 3, 2},
		excursion = 4,
		gear_skill = 3,
		core = "Speed/HP",
		antique = "Fate Crystal P2",
	}},
    servant = {
        name = "Deerling",
        UC = 70,
    },
    guild_skills = GUILD_1ST_PAGE,
}

local SalaGB = {
    girls = {{
		name = "Angelica",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		gear_skill = 3,
		core = "Attack/Attack",
		antique = "The Wings of Icarus P3",
	},{
		name = "Blair",
		pos = 2,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		gear_skill = 3,
		core = "Attack/Attack",
		antique = "Soul Destruction",
	},{
		name = "Kassy",
		pos = 3,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		gear_skill = 3,
		core = "Attack/Attack",
		antique = "Fate Crystal P2",
	},{
		name = "Kassy",
		pos = 4,
		lv = 250,
		awake = 0,
		potentials = {0, 0, 0, 0, 0},
		excursion = 1,
		equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "HP/HP",
		antique = "Queen's Crown",
	},{
		name = "Sivney",
		pos = 5,
		lv = 250,
		awake = 0,
		potentials = {0, 0, 0, 0, 0},
		excursion = 1,
		gear_skill = 2,
		core = "HP/HP",
		antique = "Yume Lantern",
	},{
		name = "Frexie",
		pos = 6,
		potentials = {1, 1, 3, 0, 0},
		excursion = 1,
		gear_star = 6,
		core = "HP/HP",
		antique = "Fate Crystal P2",
	}},
    servant = {
        name = "Deerling",
        UC = 70,
    },
    guild_skills = GUILD_1ST_PAGE,
}
local FipiaraGB = {
    girls = {{name = "Angelica", pos = 1, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1369,2369,3369,4369,5749,64423,7212}},{name = "Angelica", pos = 2, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1369,2369,3369,4369,5701,6706,7195}},{name = "Frexie", pos = 3, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1466,2466,3466,4466,5651,64601,7207}},{name = "Kassy", pos = 4, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1466,2466,3466,4466,5651,64362,0}},{name = "Kassy", pos = 5, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1469,2469,3469,4469,5641,64483,0}},{name = "Sivney", pos = 6, potentials = {3,3,3,3,2}, travel = 3002, gear_skill = 0, equips = {1569,2569,3569,4569,5754,64362,7211}}},
    servant = {
        name = "Hunter",
        UC = 100,
    },
    guild_skills = GUILD_1ST_PAGE,
}

local TeamSanct = {
    girls = {
		{name = "Angelica", pos = 1, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Diana", pos = 2, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 Thorn's Heart",},
		{name = "Sivney", pos = 3, potentials = {3,3,3,3,2}, excursion = 1, gear_skill = 3, core = "Speed/HP", antique = "P3 Fate Crystal",},
		{name = "Izanami", pos = 4, potentials = {2,2,3,2,2}, excursion = 1, gear_skill = 3, core = "Speed/HP", antique = "P3 Neutron Blades",},
		{name = "Kassy", pos = 5, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 2, core = "Attack/Attack", antique = "P3 Fate Crystal",},
		{name = "Angelica", pos = 6, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",}},
    servant = {
        name = "Hunter",
        UC = 100,
    },
    guild_skills = GUILD_1ST_PAGE,
	god_skills = {11001,11002,11301,11601}, -- Dual Blade, Immunity, Multicast
}
local SalaSanct = {
    girls = {
		{name = "Angelica", pos = 1, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 3, equips = {1369,2369,3369,4369,5749,64423,7212}},
		{name = "Diana", pos = 2, potentials = {2,2,3,2,2}, travel = 3002, gear_skill = 0, equips = {1266,2066,3066,4066,5749,64481,0}},
		{name = "Sivney", pos = 3, potentials = {1,0,0,0,0}, travel = 0, gear_skill = 3, core = "Speed/HP", antique = "P2 Fate Crystal",},
		{name = "Izanami", pos = 4, potentials = {3,1,3,3,2}, travel = 3004, gear_skill = 3, core = "Speed/HP", antique = "Neutron Blades",},
		{name = "Kassy", pos = 5, potentials = {3,1,3,3,2}, travel = 0, gear_skill = 3, core = "Speed/HP", antique = "P2 Fate Crystal",},
		{name = "Kassy", pos = 6, potentials = {0,0,0,0,0}, travel = 2301, gear_skill = 3, core = "Speed/HP", antique = "P2 Fate Crystal",}},
    servant = {
        name = "Deerling",
        UC = 70,
    },
    guild_skills = GUILD_1ST_PAGE,
	god_skills = {11001,11002,11301,11601}, -- Dual Blade, Immunity, Multicast
}
local FipiaraSanct = {
    girls = {
{name = "Diana", pos = 1, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 3, equips = {1269,2269,3269,4269,5749,64483,0},},
{name = "Sivney", pos = 2, potentials = {3,3,3,3,2,}, travel = 3001, gear_skill = 3, equips = {1569,2569,3569,4569,5754,64362,7211},},
{name = "Izanami", pos = 3, potentials = {2,2,3,2,2,}, travel = 3001, gear_skill = 3, equips = {1569,2569,3569,4569,5754,64781,7191},},
{name = "Angelica", pos = 4, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 3, equips = {1369,2369,3369,4369,5749,64423,7212},},
{name = "Kassy", pos = 5, potentials = {2,2,3,2,2,}, travel = 2903, gear_skill = 2, equips = {1469,2469,3469,4469,5641,6706,0},},
{name = "Angelica", pos = 6, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 3, equips = {1369,2369,3369,4369,5701,6706,7195}}},
    servant = { name = "Hunter", UC = 100, lv = 180 },
    guild_skills = GUILD_1ST_PAGE,
	god_skills = {11001,11002,11301,11601}, -- Dual Blade, Immunity, Multicast
}

local TeamEoT = {
    girls = {
		{name = "Angelica", pos = 1, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Angelica", pos = 2, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Linky", pos = 3, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 3, core = "Attack/Attack", antique = "P3 Fate Crystal",},
		{name = "Frexie", pos = 4, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 3, core = "Speed/Attack", antique = "P3 Fate Crystal",},
		{name = "Kassy", pos = 5, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 Fate Crystal",},
		{name = "Sivney", pos = 6, potentials = {2,2,3,2,2}, excursion = 4, gear_skill = 3, core = "Speed/Attack", antique = "P3 Fate Crystal",}},
    servant = {
        name = "Hunter",
        UC = 100,
    },
    guild_skills = GUILD_1ST_PAGE,
}

local TeamPW = {
    girls = {
		{name = "Angelica", pos = 1, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Angelica", pos = 2, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 The Wings of Icarus",},
		{name = "Linky", pos = 3, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 3, core = "Attack/Attack", antique = "P3 Fate Crystal",},
		{name = "Frexie", pos = 4, potentials = {2,2,3,2,2}, excursion = 3, gear_skill = 3, core = "Speed/Attack", antique = "P3 Fate Crystal",},
		{name = "Kassy", pos = 5, potentials = {2,2,3,2,2}, excursion = 2, gear_skill = 3, core = "Attack/Attack", antique = "P3 Fate Crystal",},
		{name = "Sivney", pos = 6, potentials = {2,2,3,2,2}, excursion = 4, gear_skill = 3, core = "Speed/Attack", antique = "P3 Fate Crystal",}},
    servant = {
        name = "Hunter",
        UC = 100,
    },
	god_skills = {20210005,20210010,20210015,20210020,20210025,20210030,20210034,20210038,20210042,20210047,20210052,20210056,20210062,20210069,20210074,20210079,20210087,20210095,20210082,20210090,20210098,20210103,20210111,20210106,20210114}, -- All
    guild_skills = GUILD_1ST_PAGE,
}

--local PARAMS = PvE_params(TeamSS, {str = { 40060 }, pos = {1}}) -- SS
--local PARAMS = PvE_params(SalaSS, {str = { 40060 }, pos = {1}}) -- SS
--PARAMS.weather = {200801} doesn't seem to work

--local PARAMS = PvE_params(SalaGB, GB61)
--local PARAMS = PvE_params(FipiaraGB, GB61)

--local PARAMS = PvE_params(TeamSanct, Sanct)
--local PARAMS = PvE_params(SalaSanct, Sanct)
local PARAMS = PvE_params(FipiaraSanct, Sanct)

--local PARAMS = PvE_params(TeamEoT, EoT)

--local PARAMS = PvE_params(TeamPW, PWFrexie)

print_girls(PARAMS)

local report = fight(PARAMS, SEEDS, true)

print(get_report(report))

-- Add to preload: weather = tA.weather or {},
--Security Squad weather
--Sunny							No effect
--Sandstorm		200101			Chaos Lord got his Block rate boosted by 100%
--Light Rain	200201			Girls from Human and Fairy faction got their ATK boosted by 100%, girls from Monster and Ghost Faction got their ATK reduced by 50%
--Thunderstorm	200301			Bleeding & Poisoning & Burning damage taken by all characters increases by 200%.
--Snow			200401			Chaos Lord got his armor boosted by 100%
--Blackout		200501			Girls from Demon and Ghost faction got their ATK boosted by 100%, girls from Angel and Fairy Faction got their ATK reduced by 50%
--Mist			200601			Girls from Angel and Monster faction got their ATK boosted by 100%, girls from Demon and Human Faction got their ATK reduced by 50%
--Gloomy		200701,200702	Chaos Lord receives 30% additional damage when he has more than 50% HP; he has 100% additional Armor when his HP is lower than 50%.
--Storm			200801			The damage dealt to the enemies will be increased by 30%, but the heal effect of your Girls will be reduced by 75%
--Cloudy		200901			During battle, all damage received by enemies will increase by 50% during odd number rounds and reduce by 50% during even number rounds.
--Blizzard		201001,201002	When the Basic Attacks or Active skills of your girls don't trigger Crit, the damage will be reduced by 30%; But if they do, the damage will be increased by 30%



--Sanctuary skills
--Quench			11101			Increases your girls' Attack by 10%
--Heart Drilling	10301,10302		When battle starts, all enemies take random DoT lasting for 3 rounds. DoT (Bleeding & Poisoning & Burning) taken by the enemies increases by 25%.
--Dual Blade		11001,11002		Allies' Basic Attack damage increases by 100%. Whenever an ally performs a Basic Attack, there is 50% chance to perform an additional Basic Attack.
--Potency Evocation	10101			Increases Crit by 25%, Crit Damage by 25% to all your girls.
--Way of Shura		10801			When a girl takes damage, she has 75% chance to counterattack, dealing (100% of Attack) Damage, must hit.
--Overgrowth		11201			Increases your girls' Maximum Hp by 20%
--Cloudy Storm		10701,10703		Allies' HP healing amount will be increased by 25%. All enemies' HP healing amount will be decreased by 75%...
--Unified Body		10901,10902		Your girls gain 25% Damage Reduce Rate. Whenever a girl takes damage, it will have 50% chance to distribute evenly among all allies.
--Immunity			11301			Increases your girls' Control Immune by 40%
--Shields Up		11401			Increases your girls' Block rate by 30%
--Dreadnought		11501,11502		Increases the Armor of Girls in Front-line by 25%, and allows them to receive 200% Healing amount when healed
--Multicast			11601			Your girls has a 25% chance to trigger their Active Skills again
--Evil Ritual		10201			When battle starts, your girls have 90% HP and 200 Energy.
--Blood Thirst		11701			Heals your Girls for 15% of attack damage they dealt
--Sanctuary			11801			Allows your girls to immune from a lethal damage (can stack with the same type of effect girls get from antiques)