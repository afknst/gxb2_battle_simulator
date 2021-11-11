require("preload")

local teams = require("teams")

local M = 100
local SEEDS = get_seeds(M)

local TA = teams[1]

local Mika = {
    girls = {{
		name = "Mika",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		--antique = "Black Magic Hat",
		antique = "Thorn's Heart P1",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Neph = {
    girls = {{
		name = "Nephilim",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Vivian = {
    girls = {{
		name = "Vivian",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Fenrir = {
    girls = {{
		name = "Fenrir",
		pos = 1,
		potentials = {1, 3, 1, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Rogue = {
    girls = {{
		name = "Rogue",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		--antique = "Thorn's Heart",
		--antique = "Seal Sword·Human", --Anti-Warrior
		--antique = "Sealed Heart·Human", --Anti-Mage
		antique = "Key to Heaven",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Diana = {
    girls = {{
		name = "Diana",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
		--antique = "Thorn's Heart P1",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Estel = {
    girls = {{
		name = "Estel",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Kratos = {
    girls = {{
		name = "Kratos",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
		--antique = "Fusion Umbrella",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Sivney = {
    girls = {{
		name = "Sivney",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local SivneyD = {
    girls = {{
		name = "Sivney",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local VeraA = {
    girls = {{
		name = "Vera",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local VeraD = {
    girls = {{
		name = "Vera",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Blair = {
    girls = {{
		name = "Blair",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local VH = {
    girls = {{
		name = "Von Helsing",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local VHD = {
    girls = {{
		name = "Von Helsing",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Angelica = {
    girls = {{
		name = "Angelica",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local AngelicaD = {
    girls = {{
		name = "Angelica",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local BlairD = {
    girls = {{
		name = "Blair",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Apate = {
    girls = {{
		name = "Apate",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Joan = {
    girls = {{
		name = "Joan",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Kassy = {
    girls = {{
		name = "Kassy",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Krystal = {
    girls = {{
		name = "Krystal",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Aurora = {
    girls = {{
		name = "Aurora",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local AuroraNB = {
    girls = {{
		name = "Aurora",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Neutron Blades",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Hexa = {
    girls = {{
		name = "Hexa",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Alice = {
    girls = {{
		name = "Alice",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Mio = {
    girls = {{
		name = "Mio",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Phoenix = {
    girls = {{
		name = "Phoenix",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Teresa = {
    girls = {{
		name = "Teresa",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		--potentials = {2, 2, 3, 2, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		--antique = "Black Magic Hat",
		antique = "Neutron Blades",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}

local Trinity = {
    girls = {{
		name = "Trinity",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local TrinityD = {
    girls = {{
		name = "Trinity",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Holly = {
    girls = {{
		name = "Holly",
		pos = 1,
		potentials = {1, 3, 3, 1, 2},
		excursion = 1,
		equip = {1065, 2066, 3065, 4066}, --5656
		--equip = {1066, 2166, 3066, 4166}, --6C6C
		core = "DJ6HP",
		antique = "Black Magic Hat",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}
local Succuba = {
    girls = {{
		name = "Succuba",
		pos = 1,
		potentials = {2, 2, 3, 2, 2},
		excursion = 2,
		equip = {1066, 2066, 3066, 4066}, --6666
		core = "DJ6Atk",
		antique = "Thorn's Heart",
	}},
	servant = {
        name = "Deerling",
        lv = 1,
        UC = 0,
        skills = {0,0,0,0},
    },
    guild_skills = GUILD_1ST_PAGE,
}

-- For Energy, Add update Energy at this line in BattleCreateReport.lua
--for k, v in ipairs(xyd.Battle.teamA) do
	--v:updateEnergy(300)
		
local team = AuroraNB

io.write(team.girls[1].name.." "..team.girls[1].antique.." ".."\n\t")
team.god_skills = {98765000}
-- add to skill6.lua
-- ,["98765000"]={98765000,"","","",-1,"",0,28,1,1,"","",2,"","","9876500|9876501|9876502","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}
-- add to effect.lua
--,["9876500"]={9876500,1028,"atkP",0.3,99,1},["9876501"]={9876501,1008,"crit",800,99,1},["9876502"]={9876502,1009,"critTime",800,99,1}
-- Change god_skills = data.god_skills to god_skills = tA.god_skills
-- Might need to add --self.paramsMaxRound = 9999 for Vivian, to roughly take into account retries.

print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009315, 7009329, 7009337, 7009341}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009316, 7009316, 7009316, 7009316}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009317, 7009330, 7009338, 7009342}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009318, 7009318, 7009318, 7009320}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009319, 7009331, 7009339, 7009343}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009318, 7009332, 7009340, 7009344}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009320, 7009320, 7009320, 7009320}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009321, 7009321, 7009321, 7009321}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009322, 7009322, 7009322, 7009322}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009323, 7009327, 7009324, 7009341}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009324, 7009333, 7009330, 7009334}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009325, 7009334, 7009334, 7009334}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009326, 7009335, 7009331, 7009321}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009327, 7009336, 7009323, 7009345}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009328, 7009328, 7009328, 7009328}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009346}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009347}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009348}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009349}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009350}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009351}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009352}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009353}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009354}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009355}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009356}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009357}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009358}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009359}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009360}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009361}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009362, 7009362}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009363, 7009375}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009364, 7009364}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009365, 7009365}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009366, 7009366}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009367, 7009376}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009368, 7009377}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009369, 7009377}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009370, 7009370}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009371, 7009378}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009372, 7009378}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009372, 7009372}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009373, 7009373}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009374, 7009374}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009379, 7009379, 7009396, 7009396}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009380, 7009380, 7009397, 7009397}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009381, 7009390, 7009398, 7009404}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009382, 7009382, 7009382, 7009382}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009383, 7009383, 7009383, 7009383}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009384, 7009391, 7009392, 7009405}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009385, 7009392, 7009399, 7009399}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009386, 7009386, 7009400, 7009400}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009387, 7009387, 7009387, 7009387}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009388, 7009393, 7009401, 7009401}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009385, 7009394, 7009402, 7009406}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009388, 7009385, 7009402, 7009402}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009385, 7009385, 7009394, 7009394}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009389, 7009395, 7009403, 7009407}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009408}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009409}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009410}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009411}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009412}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009413}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009414}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009415}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009416}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009417}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009418}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009419}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009420}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009421}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009422}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009423}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009424, 7009424}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009425, 7009437}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009426, 7009426}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009427, 7009427}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009428, 7009428}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009429, 7009438}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009430, 7009439}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009431, 7009439}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009432, 7009432}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009433, 7009440}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009434, 7009440}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009434, 7009434}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009435, 7009435}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009436, 7009436}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009441, 7009441, 7009458, 7009458}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009442, 7009442, 7009459, 7009459}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009443, 7009452, 7009460, 7009466}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009444, 7009444, 7009444, 7009444}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009445, 7009445, 7009445, 7009445}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009446, 7009453, 7009454, 7009467}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009447, 7009454, 7009461, 7009461}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009448, 7009448, 7009462, 7009462}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009449, 7009449, 7009449, 7009449}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009450, 7009455, 7009463, 7009463}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009447, 7009456, 7009464, 7009468}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009450, 7009447, 7009464, 7009464}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009447, 7009447, 7009456, 7009456}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009451, 7009457, 7009465, 7009469}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009470}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009471}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009472}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009473}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009474}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009475}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009476}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009477}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009478}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009479}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009480}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009481}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009482}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009483}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009484}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009485}, pos = {1}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009486, 7009486}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009487, 7009499}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009488, 7009488}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009489, 7009489}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009490, 7009490}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009491, 7009500}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009492, 7009501}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009493, 7009501}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009494, 7009494}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009495, 7009502}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009496, 7009502}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009496, 7009496}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009497, 7009497}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009498, 7009498}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009503, 7009503, 7009520, 7009520}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009504, 7009504, 7009521, 7009521}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009505, 7009514, 7009522, 7009528}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009506, 7009506, 7009506, 7009506}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009507, 7009507, 7009507, 7009507}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009508, 7009515, 7009516, 7009529}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009509, 7009516, 7009523, 7009523}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009510, 7009510, 7009524, 7009524}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009511, 7009511, 7009511, 7009511}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009512, 7009517, 7009525, 7009525}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009509, 7009518, 7009526, 7009530}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009512, 7009509, 7009526, 7009526}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009509, 7009509, 7009518, 7009518}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009513, 7009519, 7009527, 7009531}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009548, 7009548}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009549, 7009561}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009550, 7009550}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009551, 7009551}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009552, 7009552}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009553, 7009562}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009554, 7009563}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009555, 7009563}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009556, 7009556}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009557, 7009564}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009558, 7009564}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009558, 7009558}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009559, 7009559}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009560, 7009560}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009565, 7009565, 7009582, 7009582}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009566, 7009566, 7009583, 7009583}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009567, 7009576, 7009584, 7009590}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009568, 7009568, 7009568, 7009568}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009569, 7009569, 7009569, 7009569}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009570, 7009577, 7009578, 7009591}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009571, 7009578, 7009585, 7009585}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009572, 7009572, 7009586, 7009586}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009573, 7009573, 7009573, 7009573}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009574, 7009579, 7009587, 7009587}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009571, 7009580, 7009588, 7009592}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009574, 7009571, 7009588, 7009588}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009571, 7009571, 7009580, 7009580}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009575, 7009581, 7009589, 7009593}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009565, 7009565, 7009582, 7009582, 7009582}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009565, 7009565, 7009582, 7009582, 7009582}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009565, 7009565, 7009582, 7009582, 7009582}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009566, 7009566, 7009583, 7009583, 7009583}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009567, 7009576, 7009584, 7009590, 7009590}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009568, 7009568, 7009568, 7009568, 7009568}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009569, 7009569, 7009569, 7009569, 7009569}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009570, 7009577, 7009578, 7009591, 7009591}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009571, 7009578, 7009585, 7009585, 7009585}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009572, 7009572, 7009586, 7009586, 7009586}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009573, 7009573, 7009573, 7009573, 7009573}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009574, 7009579, 7009587, 7009587, 7009587}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009571, 7009580, 7009588, 7009592, 7009592}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009574, 7009571, 7009588, 7009588, 7009588}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009573, 7009573, 7009573, 7009573, 7009573}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009574, 7009571, 7009588, 7009588, 7009588}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009610, 7009610}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009611, 7009623}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009612, 7009612}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009613, 7009613}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009614, 7009614}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009615, 7009624}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009616, 7009625}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009617, 7009625}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009618, 7009618}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009619, 7009626}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009620, 7009626}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009620, 7009620}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009621, 7009621}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009622, 7009622}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009627, 7009627, 7009644, 7009644}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009628, 7009628, 7009645, 7009645}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009629, 7009638, 7009646, 7009652}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009630, 7009630, 7009630, 7009630}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009631, 7009631, 7009631, 7009631}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009632, 7009639, 7009640, 7009653}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009640, 7009647, 7009647}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009634, 7009634, 7009648, 7009648}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009635, 7009635, 7009635, 7009635}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009636, 7009641, 7009649, 7009649}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009642, 7009650, 7009654}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009636, 7009633, 7009650, 7009650}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009633, 7009642, 7009642}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009637, 7009643, 7009651, 7009655}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009627, 7009627, 7009644, 7009644, 7009644}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009628, 7009628, 7009645, 7009645, 7009645}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009629, 7009638, 7009646, 7009652, 7009646}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009630, 7009630, 7009630, 7009630, 7009630}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009631, 7009631, 7009631, 7009631, 7009631}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009632, 7009639, 7009640, 7009653, 7009653}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009640, 7009647, 7009647, 7009647}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009634, 7009634, 7009648, 7009648, 7009648}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009635, 7009635, 7009635, 7009635, 7009635}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009636, 7009641, 7009649, 7009649, 7009649}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009642, 7009650, 7009654, 7009654}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009636, 7009633, 7009650, 7009650, 7009650}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009633, 7009633, 7009642, 7009642, 7009642}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009637, 7009643, 7009651, 7009655, 7009655}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009628, 7009628, 7009645, 7009645, 7009645}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009635, 7009635, 7009635, 7009635, 7009635}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009656, 7009656}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009657, 7009669}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009658, 7009658}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009659, 7009659}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009660, 7009660}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009661, 7009670}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009662, 7009671}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009663, 7009671}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009664, 7009664}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009665, 7009672}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009666, 7009672}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009666, 7009666}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009667, 7009667}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009668, 7009668}, pos = {1, 2}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009673, 7009673, 7009690, 7009690}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009674, 7009674, 7009691, 7009691}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009675, 7009684, 7009692, 7009698}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009676, 7009676, 7009676, 7009676}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009677, 7009677, 7009677, 7009677}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009678, 7009685, 7009686, 7009699}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009679, 7009686, 7009693, 7009693}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009680, 7009680, 7009694, 7009694}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009681, 7009681, 7009681, 7009681}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009682, 7009687, 7009695, 7009695}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009679, 7009688, 7009696, 7009700}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009682, 7009679, 7009696, 7009696}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009679, 7009679, 7009688, 7009688}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009683, 7009689, 7009697, 7009701}, pos = {1, 2, 3, 4}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009702, 7009702, 7009717, 7009717, 7009717}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009703, 7009703, 7009718, 7009718, 7009705}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009704, 7009714, 7009719, 7009727, 7009719}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009705, 7009705, 7009705, 7009705, 7009705}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009706, 7009706, 7009720, 7009720, 7009720}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009707, 7009715, 7009721, 7009728, 7009732}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009708, 7009708, 7009722, 7009729, 7009729}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009709, 7009709, 7009723, 7009723, 7009723}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009710, 7009710, 7009710, 7009710, 7009733}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009711, 7009711, 7009724, 7009729, 7009729}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009712, 7009716, 7009725, 7009730, 7009707}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009711, 7009712, 7009725, 7009725, 7009725}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009712, 7009712, 7009716, 7009716, 7009716}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")
print("\tWin rate: "..(fight(PvE_params(team, {str = { 7009713, 7009708, 7009726, 7009731, 7009734}, pos = {1, 2, 3, 4, 5}}), SEEDS, false)).wins or "")