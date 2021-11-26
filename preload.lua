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

function put(t0, pos)
    local t1 = clone(t0)
    t1.pos = pos
    return t1
end

function girl_params(t0)
    assert(t0.pos)
    --assert(t0.name)
    assert(t0.potentials)
    --assert(t0.excursion)

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
    t0.travel = t0.travel or (3000 + t0.excursion)

    -- EQUIPMENT
    -- Demonic: 1065, 2065, 3065, 4065
    -- Angelic: 1066, 2066, 3066, 4066
    -- Class: 1c6p, 2c6p, 3c6p, 4c6p (c: class, p: star+6)
    t0.gear_star = t0.gear_star or 3
    local class = xyd.tables.partnerTable:getJob(t0.table_id)
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

function sports_params(TA, TB)
    local data = {}
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
    local data = {}
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

function PvE_params(tA, tB, quiet)
    local data = {}
    data.battle_type = xyd.ReportBattleType.NORMAL
    --data.battle_type = xyd.ReportBattleType.GUILD_BOSS
    --data.battle_type = xyd.ReportBattleType.TRIAL_NEW

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

    local msg = ""
    for i = 1, #strB do
        local hero = ReportHero.new()

        hero:populateWithTableID(strB[i], {
            pos = posB[i],
        })
        if i == 1 then
            msg = msg .. hero:getLevel() .. " "
        end
        msg = msg .. (hero:getName() or " ") .. " "
        table.insert(herosB, hero)
    end
    if not quiet then
        print(msg)
    end

    local petA, petB = nil, nil

    local data_petA = pet_params(tA.servant)
    if tostring(data_petA) ~= "" and data_petA.pet_id ~= nil then
        local pet = ReportPet.new()
        pet:populate(data_petA)
        petA = pet
    end

    return {
        battle_type = data.battle_type,
        herosA = herosA,
        herosB = herosB,
        petA = petA,
        petB = petB,
        guildSkillsA = tA.guild_skills,
        guildSkillsB = tB.guild_skills or {},
        god_skills = tA.god_skills or {},
        weather = tA.weather or {},
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
        print("Attacker: " .. pet_name .. " UC" .. reporter.petA_.exLevel_)
    end
    for k, hero in ipairs(reporter.herosA) do
        print(hero:getName())
        print("HP:", hero.totalAttrs_.hp)
        print("ATK:", hero.totalAttrs_.atk)
        print("ARM:", hero.totalAttrs_.arm)
        print("SPD:", hero.totalAttrs_.spd)
    end
    if reporter.petB_ then
        local pet_name = xyd.tables.petTable:getName(reporter.petB_.petID_)
        print("\nDefender: " .. pet_name .. " UC" .. reporter.petB_.exLevel_)
    end
    for k, hero in ipairs(reporter.herosB) do
        print(hero:getName())
        print("HP:", hero.totalAttrs_.hp)
        print("ATK:", hero.totalAttrs_.atk)
        print("ARM:", hero.totalAttrs_.arm)
        print("SPD:", hero.totalAttrs_.spd)
    end
end

function get_sig(params)
    local res = range(14, "")
    for i = 1, #params.herosA do
        res[params.herosA[i].pos] = params.herosA[i]:getName()
    end
    for i = 1, #params.herosB do
        res[params.herosB[i].pos + 6] = params.herosB[i]:getName()
    end
    if params.petA and params.petA.petID_ then
        res[13] = xyd.tables.petTable:getName(params.petA.petID_)
    end
    if params.petB and params.petB.petID_ then
        res[14] = xyd.tables.petTable:getName(params.petB.petID_)
    end
    return res
end

function fight(params, seeds, verbose, msg)
    local M = #seeds
    local report = {
        M = M,
        sig = get_sig(params),
        hurts = {},
        wins = 0,
        rounds = 0,
        seeds = seeds,
        total = 0,
        peak = 0,
    }

    for i = 1, M do
        local seed = seeds[i]
        local ri = createReport(params, seed)
        local total = 0

        report.wins = report.wins + ri.isWin
        report.rounds = report.rounds + ri.total_round

        for j = 1, #ri.hurts do
            local hj = ri.hurts[j]
            if j <= 6 then
                total = total + hj.hurt
            end

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

        report.total = report.total + total
        if report.peak < total then
            report.peak = total
        end

        if verbose then
            local win_msg = ""
            if msg then
                win_msg = win_msg .. "[" .. msg .. "]"
            else
                win_msg = win_msg .. "[" .. seed .. "]"
            end

            if ri.isWin == 1 then
                win_msg = win_msg
                    .. "\tWIN\t"
                    .. ri.total_round
                    .. " Rounds\t"
                    .. i
                    .. "/"
                    .. M
                    .. "\t"
                    .. round_n(total)
            else
                win_msg = win_msg
                    .. "\tLOSE\t"
                    .. ri.total_round
                    .. " Rounds\t"
                    .. i
                    .. "/"
                    .. M
                    .. "\t"
                    .. round_n(total)
            end
            print(win_msg)
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
    report.total = report.total / M
    -- if verbose then
    --     print("Average rounds:", report.rounds)
    --     print("Win rate:", report.wins)
    -- end
    return report
end

function get_report(report)
    local width = 15
    local log = repeat_char("=", 3 * width) .. "\n"
    local s = fixed_length("ROUNDS", width) .. fixed_length(report.rounds, width)

    log = log .. s

    s = fixed_length("WIN RATE", width)
        .. fixed_length(("%.4g"):format(report.wins), width)
        .. "\n"
        .. fixed_length("TOTAL", width)
        .. fixed_length(round_n(report.total), width)
        .. "\n"
        .. fixed_length("PEAK", width)
        .. fixed_length(round_n(report.peak), width)
        .. "\n"
        .. repeat_char("-", 3 * width)
        .. "\n"
        .. fixed_length("NAME", width)
        .. fixed_length("DMG", width)
        .. fixed_length("HEAL", width)
        .. "\n"
    log = log .. "\n" .. s

    for i = 1, #report.hurts do
        if i == 15 then
            break
        end
        local hi = report.hurts[i]
        s = fixed_length(report.sig[i], width)
            .. fixed_length(round_n(hi.hurt), width)
            .. fixed_length(round_n(hi.heal), width)
        if i == 6 or i == 12 then
            s = s .. "\n" .. repeat_char("-", 3 * width)
        end
        log = log .. "\n" .. s
    end

    return log .. "\n" .. repeat_char("=", 3 * width) .. "\n\n"
end
