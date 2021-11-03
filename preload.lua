function Vector4() return end
function reportLog2() return end

UnityEngine = {SystemInfo = {}}
XYDDef = {isH5 = function() return end}
xyd = {}

date = os.date("[%Y_%m_%d][%H_%M_%S]")

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

function repeat_char(char, times)
    local s = ""
    for i = 1, times do
        s = s..char
    end
    return s
end

function save(_string, _file)
    local output = assert(io.open(_file, "a"))
    io.output(output)
    io.write(_string)
    io.close(output)
end

function put(t0, pos)
    local t1 = clone(t0)
    t1.pos = pos
    return t1
end

function switch(c0)
    return {
        type = c0.type,
        teamA = c0.teamB,
        teamB = c0.teamA,
        petA = c0.petB,
        petB = c0.petA,
        guildSkillsA = c0.guildSkillsB,
        guildSkillsB = c0.guildSkillsA,
    }
end

function girl_params(t0)
    assert(t0.pos)
    assert(t0.name)
    assert(t0.potentials)
    assert(t0.excursion)

    t0.gear_skill = t0.gear_skill or 0
    t0.lv = t0.lv or 330
    t0.grade = t0.grade or 6
    t0.table_id = assert(GIRLS_10[t0.name])
    t0.awake = t0.awake or 5
    t0.ver = xyd.tables.partnerTable:getVer(t0.table_id)
    t0.love_point = t0.love_point or 100
    if t0.love_point <= 100 then
        t0.is_vowed = 0
    else
        t0.is_vowed = 1
    end
    t0.ex_skills = t0.ex_skills or {5, 5, 5, 5}
    t0.travel = t0.travel or (3000 + t0.excursion)

    -- EQUIPMENT
    -- Demonic: 1065, 2065, 3065, 4065
    -- Angelic: 1066, 2066, 3066, 4066
    -- Class: 1c6p, 2c6p, 3c6p, 4c6p (c: class, p: star+6)
    t0.gear_star = t0.gear_star or 3
    local class = xyd.tables.partnerTable:getJob(t0.table_id)
    local prefix = 100 * class + t0.gear_star
    t0.equips = t0.equips or {
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
    t0.lv = 180
    local aura_lv = 30 + 5 * math.floor(t0.UC / 25)
    t0.skills = {aura_lv, aura_lv, aura_lv, aura_lv}
    t0.ex_lv = t0.UC
    t0.ver = xyd.tables.petTable:getVer(t0.pet_id)
    return t0
end

local ReportHero = import("lib.battle.ReportHero")
local ReportPet = import("lib.battle.ReportPet")
local BattleCreateReport = import("lib.battle.BattleCreateReport")


function sports_params(TA, TB)
    data = {}
    data.battle_type = xyd.ReportBattleType.NORMAL

    local strA = TA.str
    local posA = TA.pos

    local strB = TB.str
    local posB = TB.pos

    local herosA = {}
    local herosB = {}

    for i = 1, #strA do
        local hero = ReportHero.new()

        hero:populateWithTableID(strA[i], {
            pos = posA[i]
        })
        print(hero:getName())
        table.insert(herosA, hero)
    end

    for i = 1, #strB do
        local hero = ReportHero.new()

        hero:populateWithTableID(strB[i], {
            pos = posB[i]
        })
        print(hero:getName())
        table.insert(herosB, hero)
    end

    return {
        battle_type = data.battle_type,
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
    data = {}
    data.battle_type = xyd.ReportBattleType.ARENA_NORMAL

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

    local petA, petB = nil

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
        battle_type = data.battle_type,
        herosA = herosA,
        herosB = herosB,
        petA = petA,
        petB = petB,
        guildSkillsA = tA.guild_skills,
        guildSkillsB = tB.guild_skills or {},
        god_skills = data.god_skills or {},
        battleID = 0,
        random_seed = 0,
    }
end

function createReport(params, random_seed)
    params.random_seed = random_seed
    local reporter = BattleCreateReport.new(params)
    reporter:run()
    return reporter:getReport()
end

function print_girls(params)
    local reporter = BattleCreateReport.new(params)
    reporter:setupConfig()
    reporter:setupBasicData()
    if reporter.petA_ then
        local pet_name = xyd.tables.petTable:getName(reporter.petA_.petID_)
        print("Attacker: "..pet_name.." UC"..reporter.petA_.exLevel_)
    end
    for k, hero in ipairs(reporter.herosA) do
        print(hero:getName())
        print("HP:", hero.totalAttrs_.hp)
        print("ATK:", hero.totalAttrs_.atk)
        print("ARM:", hero.totalAttrs_.arm)
        print("SPD:", hero.totalAttrs_.spd)
    end
    if reporter.petB_ then
        pet_name = xyd.tables.petTable:getName(reporter.petB_.petID_)
        print("\nDefender: "..pet_name.." UC"..reporter.petB_.exLevel_)
    end
    for k, hero in ipairs(reporter.herosB) do
        print(hero:getName())
        print("HP:", hero.totalAttrs_.hp)
        print("ATK:", hero.totalAttrs_.atk)
        print("ARM:", hero.totalAttrs_.arm)
        print("SPD:", hero.totalAttrs_.spd)
    end
end

function get_seeds(M)
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()
    local seeds = {}
    for i = 1, M do
        seeds[i] = math.random(1, os.time())
    end
    return seeds
end

function round_m(num)
    local m = num / 1e6
    return (m - m%0.01).."m"
end

function fight(params, seeds, verbose, msg)
    local M = #seeds
    local report = {
        M = M,
        hurts = {},
        wins = 0,
        rounds = 0,
        seeds = seeds,
    }

    for i = 1, M do
        local seed = seeds[i]
        local ri = createReport(params, seed)
        report.wins = report.wins + ri.isWin
        report.rounds = report.rounds + ri.total_round
        if verbose then
            local win_msg = ""
            if msg then
                win_msg = win_msg.."["..msg.."]"
            else
                win_msg = win_msg.."["..seed.."]"
            end
            if ri.isWin == 1 then
                win_msg = win_msg.."\tWIN\t"..ri.total_round.." Rounds\t"..i.."/"..M
            else
                win_msg = win_msg.."\tLOSE\t"..ri.total_round.." Rounds\t"..i.."/"..M
            end
            print(win_msg)
        end
        for j = 1, #ri.hurts do
            local hj = ri.hurts[j]
            if report.hurts[hj.pos] then
                report.hurts[hj.pos].heal = report.hurts[hj.pos].heal + hj.heal
                report.hurts[hj.pos].hurt = report.hurts[hj.pos].hurt + hj.hurt
            else
                report.hurts[hj.pos] = {
                    heal = hj.heal,
                    hurt = hj.hurt,
                }
            end
        end
    end
    for pos, hurts in ipairs(report.hurts) do
        hurts.hurt = hurts.hurt / M
        hurts.heal = hurts.heal / M
        -- if verbose then
        --     print(pos, round_m(hurts.hurt), round_m(hurts.heal))
        -- end
    end
    report.rounds = report.rounds / M
    report.wins = report.wins / M
    -- if verbose then
    --     print("Average rounds:", report.rounds)
    --     print("Win rate:", report.wins)
    -- end
    return report
end

function get_report(report, _print)
    local log = repeat_char("=", 30).."\n"
    local s = "Rounds: "..report.rounds

    log = log..s
    if _print then print(s) end

    s = "Win rate: "..report.wins.."\n"..repeat_char("-", 30).."\nDMG\t\tHEAL\n"
    log = log.."\n"..s
    if _print then print(s) end

    for i = 1, #report.hurts do
        local hi = report.hurts[i]
        s = round_m(hi.hurt).."\t\t"..round_m(hi.heal)
        if i == 6 or i == 12 then
            s = s.."\n"..repeat_char("-", 30)
        end
        log = log.."\n"..s
        if _print then print(s) end
    end

    return log.."\n"..repeat_char("=", 30).."\n\n"
end
