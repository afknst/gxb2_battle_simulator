function Vector4() end
function reportLog2() end

UnityEngine = { SystemInfo = {} }
XYDDef = { isH5 = function() end }
xyd = {}

require("utilities")
require("app.common.enums")
require("app.common.storage.Global")
require("app.common.Battle")
require("app.common.event")
require("app.common.utils")
require("base.functions")
xyd.lang = "en_en"
xyd.Global.init()

xyd.ModelManager = require("app.models.ModelManager")
xyd.ModelManager.get()
xyd.TableManager = require("app.common.tables.TableManager")
xyd.TableManager.get()
require("tables")

function girl_params(t0)
	assert(t0.pos)
	assert(t0.potentials)

	t0.gear_skill = t0.gear_skill or 0
	t0.lv = t0.lv or 330

	local ind = 3
	if t0.star then
		if t0.star <= 5 then
			ind = 1
			t0.awake = 0
			t0.grade = t0.star
		elseif t0.star <= 9 then
			ind = 2
			t0.awake = 0
			t0.grade = 6
		else
			t0.awake = t0.star - 10
			t0.grade = 6
		end
	else
		t0.awake = t0.awake or 5
		t0.grade = t0.grade or 6
	end

	t0.table_id = t0.id or assert(xyd.tables.partnerTable:getTableIDByName(assert(t0.name)))[ind]
	t0.ver = xyd.tables.partnerTable:getVer(t0.table_id)
	t0.love_point = t0.love_point or 100
	if t0.love_point <= 100 then
		t0.is_vowed = 0
	else
		t0.is_vowed = 1
	end
	t0.ex_skills = t0.ex_skills or { 5, 5, 5, 5 }
	t0.travel = t0.travel or (3000 + assert(t0.excursion))

	-- EQUIPMENT
	-- Demonic: 1065, 2065, 3065, 4065
	-- Angelic: 1066, 2066, 3066, 4066
	-- Class: 1c6p, 2c6p, 3c6p, 4c6p (c: class, p: star+6)
	t0.gear_star = t0.gear_star or 3
	local class = assert(xyd.tables.partnerTable:getJob(t0.table_id))
	local prefix = 100 * class + t0.gear_star
	t0.equips = t0.equips
		or {
			1066 + prefix,
			2066 + prefix,
			3066 + prefix,
			4066 + prefix,
			assert(CORES[t0.core]) or 0,
			assert(ANTIQUES[t0.antique]) or 0,
			t0.skin or 0,
		}
	t0.skill_index = t0.gear_skill
	return t0
end

function pet_params(t0)
	assert(t0.name)
	assert(t0.UC)
	t0.pet_id = assert(SERVANTS[t0.name])
	t0.grade = 4
	t0.lv = t0.lv or 180
	local aura_lv = 30 + 5 * math.floor(t0.UC / 25)
	t0.skills = t0.skills or { aura_lv, aura_lv, aura_lv, aura_lv }
	t0.ex_lv = t0.UC
	t0.ver = xyd.tables.petTable:getVer(t0.pet_id)
	return t0
end

local ReportHero = import("lib.battle.ReportHero")
local ReportPet = import("lib.battle.ReportPet")
local BattleCreateReport = import("lib.battle.BattleCreateReport")

function battle_opponents(id)
	local data = {}
	data.str = xyd.tables.battleTable:getMonsters(id)
	data.pos = xyd.tables.battleTable:getStands(id)
	return data
end

function Test_opponents(stage)
	local id = xyd.tables.towerTable:getBattleID(stage)
	return battle_opponents(id)
end

function OCE_opponents(season)
	local _start = (season % 2) * 25 + 1
	local _end = _start + 24
	local opponents = {}
	for i = _start, _end do
		local id = xyd.tables.oldBuildingStageTable:getBattleId(i)
		local floor = xyd.tables.oldBuildingStageTable:getFloor(i)
		if not opponents[floor] then
			opponents[floor] = {}
		end
		table.insert(opponents[floor], battle_opponents(id))
	end
	return opponents
end

function EvE_params(tA, tB)
	local strA = tA.str
	local posA = tA.pos

	local strB = tB.str
	local posB = tB.pos

	local herosA = {}
	local herosB = {}

	for i = 1, #strA do
		local hero = ReportHero.new()

		hero:populateWithTableID(strA[i], {
			pos = posA[i],
		})
		print(hero:getName())
		table.insert(herosA, hero)
	end

	for i = 1, #strB do
		local hero = ReportHero.new()

		hero:populateWithTableID(strB[i], {
			pos = posB[i],
		})
		print(hero:getName())
		table.insert(herosB, hero)
	end

	return {
		battle_type = xyd.ReportBattleType.NORMAL,
		herosA = herosA,
		herosB = herosB,
		guildSkillsA = {},
		guildSkillsB = {},
		god_skills = {},
		battleID = 0,
		random_seed = 0,
	}
end

function PvP_params(tA, tB)
	local herosA = {}
	local herosB = {}

	for i = 1, #tA.girls do
		local hero = ReportHero.new()
		local ai = girl_params(tA.girls[i])

		if ai.isMonster then
			hero:populateWithTableID(ai.table_id, ai)
		else
			hero:populate(ai)
		end
		table.insert(herosA, hero)
	end

	for i = 1, #tB.girls do
		local hero = ReportHero.new()
		local bi = girl_params(tB.girls[i])

		if bi.isMonster then
			hero:populateWithTableID(bi.table_id, bi)
		else
			hero:populate(bi)
		end
		table.insert(herosB, hero)
	end

	local petA, petB = nil, nil

	local data_petA = pet_params(tA.servant)
	if tostring(data_petA) ~= "" and data_petA.pet_id ~= nil then
		local pet = ReportPet.new()
		pet:populate(data_petA)
		petA = pet
	end

	local data_petB = pet_params(tB.servant)
	if tostring(data_petB) ~= "" and data_petB.pet_id ~= nil then
		local pet = ReportPet.new()
		pet:populate(data_petB)
		petB = pet
	end

	return {
		battle_type = xyd.ReportBattleType.ARENA_NORMAL,
		herosA = herosA,
		herosB = herosB,
		petA = petA,
		petB = petB,
		guildSkillsA = tA.guild_skills or GUILD_FULL,
		guildSkillsB = tB.guild_skills or GUILD_FULL,
		god_skills = {},
		battleID = 0,
		random_seed = 0,
	}
end

function PvE_params(tA, tB, type)
	local strB = tB.str
	local posB = tB.pos or { 1, 2, 3, 4, 5, 6 }

	local herosA = {}
	local herosB = {}

	for i = 1, #tA.girls do
		local hero = ReportHero.new()
		local ai = girl_params(tA.girls[i])

		if ai.isMonster then
			hero:populateWithTableID(ai.table_id, ai)
		else
			hero:populate(ai)
		end
		table.insert(herosA, hero)
	end

	local petA, petB = nil, nil

	local data_petA = pet_params(tA.servant)
	if tostring(data_petA) ~= "" and data_petA.pet_id ~= nil then
		local pet = ReportPet.new()
		pet:populate(data_petA)
		petA = pet
	end

	return {
		battle_type = type or xyd.ReportBattleType.NORMAL,
		herosA = herosA,
		herosB = herosB,
		petA = petA,
		petB = petB,
		guildSkillsA = tA.guild_skills,
		guildSkillsB = tB.guild_skills or {},
		god_skills = tA.god_skills or tB.god_skills or {},
		weather = tA.weather or {},
		battleID = 0,
		random_seed = 0,
	}
end

function createReport(params, random_seed)
	params.random_seed = random_seed
	params.isSweep = true
	local reporter = BattleCreateReport.new(params)
	reporter:run()

	local report = {
		seed = random_seed,
		isWin = reporter:isWin(),
		total_round = xyd.Battle.round,
		total = reporter:getTotalHarm(),
		hurts = {},
		die_round = {},
		die_info = reporter:getDieInfo(),
		hp = {},
	}

	for i, v in ipairs(xyd.Battle.teamA) do
		table.insert(report.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos(),
		})

		if v:isDeath() then
			table.insert(report.die_round, {
				pos = v:getPos(),
				round = v:getDieRound(),
			})
		end

		table.insert(report.hp, {
			pos = v:getPos(),
			hp = math.ceil(100 * v:getHpPercent()),
			true_hp = math.ceil(v:getHp()),
		})
	end

	for i, v in ipairs(xyd.Battle.teamB) do
		table.insert(report.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos(),
		})

		if v:isDeath() then
			table.insert(report.die_round, {
				pos = v:getPos(),
				round = v:getDieRound(),
			})
		end

		table.insert(report.hp, {
			pos = v:getPos(),
			hp = math.ceil(100 * v:getHpPercent()),
			true_hp = math.ceil(v:getHp()),
		})
	end

	for i, v in ipairs(xyd.Battle.teamPet) do
		table.insert(report.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos(),
		})
	end

	if xyd.Battle.god then
		local god = xyd.Battle.god

		table.insert(report.hurts, {
			pos = god:getPos(),
			hurt = god.hurt_,
			heal = god.heal_,
		})
	end

	return report
end

function get_win_rates_report(params, seeds)
	params.isSweep = true
	local wins = {}
	local hp = {}

	for k = 1, #seeds do
		params.random_seed = seeds[k]
		local reporter = BattleCreateReport.new(params)
		reporter:run()

		wins[k] = reporter:isWin()
		hp[k] = {}
		for i, v in ipairs(xyd.Battle.teamA) do
			hp[k][v:getPos()] = v:getHpPercent()
		end
		for i, v in ipairs(xyd.Battle.teamB) do
			hp[k][v:getPos()] = v:getHpPercent()
		end
	end

	return {
		wins = wins,
		hp = hp,
	}
end

function get_dmg_report(params, seeds)
	params.isSweep = true
	local dmg = {}

	for k = 1, #seeds do
		params.random_seed = seeds[k]
		local reporter = BattleCreateReport.new(params)
		reporter:run()

		dmg[k] = reporter:getTotalHarm()
	end

	return dmg
end

function PvP_fight(raw_params)
	local params = PvP_params(raw_params.tA, raw_params.tB)
	return get_win_rates_report(params, raw_params.seeds)
end
