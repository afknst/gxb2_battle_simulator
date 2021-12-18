local BattleCreateReport = class("BattleCreateReport")
local AttackUnit = xyd.Battle.getRequire("ReportAttackUnit")
local RecordUnit = xyd.Battle.getRequire("RecordUnit")
local BaseGod = xyd.Battle.getRequire("ReportBaseGod")
local GroupBuffTable = xyd.tables.groupBuffTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local battleEvent = xyd.Battle.getRequire("battle_event_controller")
--local cjson = require("cjson")
local SkillTable = xyd.tables.skillTable
local DressEffectTable = xyd.tables.senpaiDressEffectTable
local TimeDressEffectTable = xyd.tables.TimeCloisterDressEffectTable
local BattleChallengeTable = xyd.tables.battleChallengeTable
local battleChallengeCheck = xyd.Battle.getRequire("battle_challenge_check")
local GetTarget_ = xyd.Battle.getRequire("GetTarget")

function BattleCreateReport:ctor(params)
	self.battleType = params.battle_type or xyd.ReportBattleType.NORMAL
	--self.battleType = xyd.ReportBattleType.DUNGEON
	--self.battleType = xyd.ReportBattleType.TRIAL_NEW
	--self.battleType = xyd.ReportBattleType.TIME_CLOISTER
	--self.battleType = xyd.ReportBattleType.GOVERN_TEAM
	--self.battleType = xyd.ReportBattleType.ARENA_ALL_SERVER
	self.herosA = params.herosA
	self.herosB = params.herosB
	self.petA_ = params.petA
	self.petB_ = params.petB
	self.guildSkillsA = params.guildSkillsA
	self.guildSkillsB = params.guildSkillsB
	self.godSkills = params.god_skills or {}
	self.dressGodSkills = {}
	self.battleID = params.battleID
	xyd.Battle.dressAttrsA = params.dressAttrsA or {}
	xyd.Battle.dressAttrsB = params.dressAttrsB or {}
	xyd.Battle.godPosSkill = {}
	self.weather = params.weather
	self.richManEffects = params.effects
	self.isBattleEnded_ = false
	self.report_ = nil
	self.isWin_ = 0
	self.isAllDie_ = false
	xyd.Battle.has_random = params.has_random
	xyd.Battle.isSweep = params.isSweep or false
	self.paramsMaxRound = params.maxRound

	self:sortHerosPos(self.herosA)
	self:sortHerosPos(self.herosB)

	self.purpose = params.purpose
	self.randomSeed = params.random_seed
	xyd.Battle.randomSeed = tonumber(self.randomSeed)
	xyd.Battle.battleEvent = nil

	battleEvent:reg_evt()
	self:addGodSubSkill()
end

function BattleCreateReport:sortHerosPos(heros)
	table.sort(heros, function (a, b)
		return a.pos < b.pos
	end)
end

function BattleCreateReport:addGodSubSkill()
	if self.godSkills then
		local skills = {}

		for _, skill in ipairs(self.godSkills) do
			if skill > 0 then
				local subSkills = SkillTable:getSubSkills(skill)

				if not self:checkGodInitFighterSkills(skill) then
					table.insert(skills, skill)
				end

				if #subSkills > 0 then
					for _, subSkill in ipairs(subSkills) do
						if not self:checkGodInitFighterSkills(subSkill) then
							table.insert(skills, subSkill)
						end
					end
				end
			end
		end

		self.godSkills = skills
	end
end

function BattleCreateReport:checkGodInitFighterSkills(skillId)
	if SkillTable:trigger(skillId) == xyd.TriggerType.GOD_INIT_FIGHTER_SKILL then
		for i = 1, 3 do
			local targetIndex = SkillTable:getTargets(skillId, i)
			local poses = GetTarget_:godInitFighterPos(targetIndex)

			for k, v in ipairs(poses) do
				if not xyd.Battle.godPosSkill[v] then
					xyd.Battle.godPosSkill[v] = {}
				end

				local effects = SkillTable:getEffect(skillId, i)

				for k1, v1 in ipairs(effects) do
					table.insert(xyd.Battle.godPosSkill[v], v1)
				end
			end
		end

		return true
	end
end

function BattleCreateReport:run()
	self:setupConfig()
	self:init()
end

function BattleCreateReport:setupConfig()
	xyd.Battle.hasAllInited = false
	xyd.Battle.teamA = {}
	xyd.Battle.teamB = {}
	xyd.Battle.team = {}
	xyd.Battle.teamPet = {}
	xyd.Battle.recordUnit = nil
	xyd.Battle.recordUnits = {}
	xyd.Battle.fighterQueue = {}
	xyd.Battle.passiveQueue = {}
	xyd.Battle.groupBuffA = {}
	xyd.Battle.groupBuffB = {}
	xyd.Battle.globalBuff = {}
	xyd.Battle.round = 0
	xyd.Battle.ackSpeedFlag = false
	xyd.Battle.atkDFlag = false
	xyd.Battle.atkDTarget = nil
	xyd.Battle.fireTarget = nil
	xyd.Battle.crystalTarget = nil
	xyd.Battle.lastSameAtkHurtBuff = nil
	xyd.Battle.curRoundFigthers = {}
	xyd.Battle.curRoundDie = {}
	xyd.Battle.god = nil
	xyd.Battle.isCure = false
	xyd.Battle.isJustCrystal = false
	xyd.Battle.roundHarm = {}
	xyd.Battle.shareHarmBuffs = {}
	xyd.Battle.atkTimes = {
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	}
	xyd.Battle.useGodPasRound = 0
	xyd.Battle.energySkillTargets = {}
	xyd.Battle.energySkillHarms = {}
	xyd.Battle.puGongSkillTargets = {}
	xyd.Battle.puGongSkillHarms = {}
	xyd.Battle.puGongNormalSkillTargets = {}
	xyd.Battle.crystalTargets = {}
	xyd.Battle.crystalEndTargets = {}
	xyd.Battle.bloodTargets = {}
	xyd.Battle.justUseSkillTarget = nil
	xyd.Battle.justRemoveExileRound = {
		0,
		0,
		0,
		0,
		0,
		0
	}
	xyd.Battle.needRemoveBuffs = {}
	xyd.Battle.ckAttackRound = {
		0,
		0
	}
	xyd.Battle.teamDieCount = {
		0,
		0
	}
	xyd.Battle.lastDebuff = nil
	xyd.Battle.lastHurtBuff = nil
	xyd.Battle.hurtByReceiveBuffs = {}
	xyd.Battle.friendHurtTargets = {}
	xyd.Battle.normalSkillTargets = {}
	xyd.Battle.allHarmShareBuffs = {}
	xyd.Battle.randomUseData = {}
	xyd.Battle.preHitTargets = {}
	xyd.Battle.purposes = {}
	xyd.Battle.oneSkillHarmRecord = 0
	xyd.Battle.attackNum = 0
	xyd.Battle.selfControlTimes = 0
	xyd.Battle.enemyControlTimes = 0

	math.randomseed(self.randomSeed)

	xyd.Battle.initRandomSeed = self.randomSeed
end

function BattleCreateReport:init()
	self:setupBasicData()

	xyd.Battle.hasAllInited = true

	self:startBattle()
end

function BattleCreateReport:setupBasicData()
	self:setFormation()
	self:updateFighters()
	self:setDressGodSkill()
	self:getAttrDump(true)
	self:initGod()
	self:getAttrDump(false)
	self:initPets()
end

function BattleCreateReport:getAttrDump(isBefore)
	if not isBefore then
		reportLog2("**********************************")
		reportLog2("**********************************")
	end

	for k, v in ipairs(xyd.Battle.team) do
		reportLog2("------------------------------------")
		reportLog2("pos: " .. v:getPos())
		reportLog2("hp:  " .. v:getHpLimit())
		reportLog2("atk: " .. v:getAD())
		reportLog2("arm: " .. v:getHujia())
		reportLog2("spd: " .. v:getAckSpeed())
		reportLog2("crit:" .. v:getCrit())
		reportLog2("uncrit: " .. v:getUnCrit())
		reportLog2("critTime:" .. v:getCritTime())
		reportLog2("trueAtk:" .. v:getTrueAtk())
		reportLog2("brk: " .. v:getDHuJia())
		reportLog2("free:" .. v:getFree())
		reportLog2("hit: " .. v:getAttrByType(xyd.BUFF_HIT))
		reportLog2("miss:" .. v:getShanBi())
	end
end

function BattleCreateReport:setDressGodSkill()
	if #xyd.Battle.dressAttrsA ~= 3 or #xyd.Battle.dressAttrsB ~= 3 then
		return
	end

	for i = 1, 3 do
		local absNum = math.abs(xyd.Battle.dressAttrsA[i] - xyd.Battle.dressAttrsB[i])
		local needId = DressEffectTable:getSkillId(absNum, i)

		if self.battleType == xyd.ReportBattleType.TIME_CLOISTER then
			needId = TimeDressEffectTable:getSkillId(absNum, i)
		end

		if needId ~= 0 then
			table.insert(self.dressGodSkills, needId)
		end
	end
end

function BattleCreateReport:setFormation()
	local petAInfo = self:getPetInfo(xyd.TeamType.A)

	for k, hero in ipairs(self.herosA) do
		hero:setPetInfo(petAInfo)

		if not hero.status or hero.status.hp and hero.status.hp > 0 then
			hero:setGuildInfo(self.guildSkillsA)

			local fighter = self:newFighter(hero, xyd.TeamType.A, hero.pos)

			table.insert(xyd.Battle.teamA, fighter)
			table.insert(xyd.Battle.team, fighter)
		end
	end

	local petBInfo = self:getPetInfo(xyd.TeamType.B)

	for k, hero in ipairs(self.herosB) do
		hero:setPetInfo(petBInfo)

		if not hero.status or hero.status.hp and hero.status.hp > 0 then
			hero:setGuildInfo(self.guildSkillsB)

			local fighter = self:newFighter(hero, xyd.TeamType.B, hero.pos + xyd.TEAM_B_POS_BASIC)

			table.insert(xyd.Battle.teamB, fighter)
			table.insert(xyd.Battle.team, fighter)
		end
	end

	if self.petA_ then
		local fighter = self:newFighter(self.petA_, xyd.TeamType.A, 13)

		table.insert(xyd.Battle.teamPet, fighter)
	end

	if self.petB_ then
		local fighter = self:newFighter(self.petB_, xyd.TeamType.B, 14)

		table.insert(xyd.Battle.teamPet, fighter)
	end
end

function BattleCreateReport:getPetInfo(teamType)
	local pet = nil

	if teamType == xyd.TeamType.A then
		pet = self.petA_
	else
		pet = self.petB_
	end

	if pet then
		return pet:getPetInfo()
	end

	return {}
end

function BattleCreateReport:newFighter(hero, teamType, index)
	local class = hero:className()
	local fighter = xyd.Battle.requireFighter(class).new()

	fighter:populateWithHero(hero)
	fighter:setTeamType(teamType)
	fighter:setPos(index)

	if hero.status then
		fighter.status = hero.status
	end

	if hero.change_attr then
		fighter.change_attr = hero.change_attr
	end

	if hero.is_npc then
		fighter.is_npc = hero.is_npc
	end

	return fighter
end

function BattleCreateReport:updateFighters()
	self:updateInitAttrByType()
	self:setupGlobalBuffs()

	for k, v in ipairs(xyd.Battle.teamA) do
		--v:updateEnergy(300)
		if v.status then
			local status = v.status

			v:addInitBuffs(status.buffs)
			v:setupHpLimit()

			if tonumber(status.true_hp) and tonumber(status.true_hp) >= 0 then
				v:updateHp(tonumber(status.true_hp))
			else
				v:updateHp(v:getHpLimit() * status.hp / xyd.PERCENT_BASE)
			end

			if status.mp and status.mp >= 0 then
				v:updateEnergy(status.mp)
			end
		else
			v:addInitBuffs()
			v:setupHpLimit()
			v:updateHp(v:getHpLimit())
		end

		v:updateMaxHpP()
	end

	local teamB = self:getTeamB()

	for k, v in ipairs(teamB) do
		if v.status then
			local status = v.status

			v:addInitBuffs(status.buffs)
			v:setupHpLimit()

			if tonumber(status.true_hp) and tonumber(status.true_hp) >= 0 then
				v:updateHp(tonumber(status.true_hp))
			else
				v:updateHp(v:getHpLimit() * status.hp / xyd.PERCENT_BASE)
			end

			if status.mp and status.mp >= 0 then
				v:updateEnergy(status.mp)
			end
		else
			v:addInitBuffs()
			v:setupHpLimit()
			v:updateHp(v:getHpLimit())
		end

		v:updateMaxHpP()

		if self.battleType == xyd.ReportBattleType.GUILD_BOSS then
			v:setCanHeal(false)
		end
	end
end

function BattleCreateReport:getTeamB()
	local teamB = {}

	for k, v in pairs(xyd.Battle.teamB) do
		table.insert(teamB, v)
	end

	table.sort(teamB, function (data1, data2)
		return data1:getPos() < data1:getPos()
	end)

	return teamB
end

function BattleCreateReport:initPets()
	for _, v in ipairs(xyd.Battle.teamPet) do
		v:addInitBuffs()
	end
end

function BattleCreateReport:updateInitAttrByType()
	if self.battleType ~= xyd.ReportBattleType.ARENA_ALL_SERVER then
		return
	end

	for k, v in ipairs(xyd.Battle.teamA) do
		if v.change_attr then
			v.hero_:updateInitAttr(v.change_attr)
		end
	end

	local teamB = self:getTeamB()

	for k, v in ipairs(teamB) do
		if v.change_attr then
			v.hero_:updateInitAttr(v.change_attr)
		end
	end
end

function BattleCreateReport:getFighterByPos(team, pos)
	for i, v in ipairs(team) do
		if v:getPos() == pos then
			return v
		end
	end
end

function BattleCreateReport:setupGlobalBuffs()
	for k, v in ipairs(xyd.Battle.teamA) do
		v:setupBattleAttrInfo()
	end

	for k, v in ipairs(xyd.Battle.teamB) do
		v:setupBattleAttrInfo()
	end

	self:addGroupBuffs()
	self:addRichManBuffs()
end

function BattleCreateReport:addGroupBuffs()
	local effectsA, posA = self:getGroupBuffs(xyd.Battle.teamA)
	local effectsB, posB = self:getGroupBuffs(xyd.Battle.teamB)

	local function newBuff(target, effectID, index)
		local params = {
			effectID = effectID,
			index = index
		}
		local buff = BuffManager:newBuff(params)

		buff:setIsHit()

		return buff
	end

	for i, id in ipairs(effectsA) do
		local buff = newBuff(self, id, 1)

		if buff:isHit() then
			buff:calculate()

			buff.globalBuffPos = xyd.splitToNumber(posA[i], "|")

			self:clearAttrCache(xyd.Battle.teamA, buff)
			table.insert(xyd.Battle.groupBuffA, buff)
		end
	end

	for i, id in ipairs(effectsB) do
		local buff = newBuff(self, id, 1)

		if buff:isHit() then
			buff:calculate()

			local tmpPos = xyd.splitToNumber(posB[i], "|")

			for i, _ in ipairs(tmpPos) do
				tmpPos[i] = tmpPos[i] + xyd.TEAM_B_POS_BASIC
			end

			buff.globalBuffPos = tmpPos

			self:clearAttrCache(xyd.Battle.teamB, buff)
			table.insert(xyd.Battle.groupBuffB, buff)
		end
	end
end

function BattleCreateReport:clearAttrCache(team, buff)
	for k, v in ipairs(team) do
		local actual_buff = buff:getActualBuff()

		v:clearAttrCache(actual_buff)
	end
end

function BattleCreateReport:getGroupBuffs(team)
	local groups = {}

	for _, fighter in ipairs(team) do
		local addNum = 1

		if fighter.is_npc then
			addNum = 2
		end

		groups[fighter:getGroup()] = (groups[fighter:getGroup()] or 0) + addNum
	end

	for i = 1, 6 do
		if not groups[i] then
			groups[i] = 0
		end
	end

	local id = GroupBuffTable:getBuffIdByGroupIds(groups)
	local effect = {}
	local pos = {}

	if id > 0 then
		effect = GroupBuffTable:getEffect(id)
		pos = GroupBuffTable:getStand(id)
	end

	return effect, pos
end

function BattleCreateReport:addRichManBuffs()
	if not self.richManEffects or not next(self.richManEffects) then
		return
	end

	local function newBuff(target, effectID)
		local params = {
			effectID = effectID
		}
		local buff = BuffManager:newBuff(params)

		buff:setYongJiu(true)

		buff.isHit_ = true

		return buff
	end

	for _, effectInfo in ipairs(self.richManEffects) do
		local effectID = tonumber(effectInfo.effect_id)
		local effectNum = tonumber(effectInfo.effect_num)
		local buff = newBuff(self, effectID)

		buff:calculate()

		buff.finalNum_ = buff.finalNum_ * effectNum

		self:clearAttrCache(xyd.Battle.teamA, buff)
		table.insert(xyd.Battle.groupBuffA, buff)
	end
end

function BattleCreateReport:initGod()
	local god = BaseGod.new()
	local skills = {}

	for k, v in ipairs(self.godSkills) do
		table.insert(skills, v)
	end

	for k, v in ipairs(self.dressGodSkills) do
		table.insert(skills, v)
	end

	god:setInfo({
		skills = skills
	})
	god:setTeamType(xyd.TeamType.A)
	god:setPos(15)
	god:addInitBuffs()

	xyd.Battle.god = god
end

function BattleCreateReport:startBattle()
	local round = self:getMaxRound()

	for i = 1, round do
		local flag = self:mainLoop()

		if not flag then
			break
		end
	end

	self:battleEnd()
end

function BattleCreateReport:calculatePurpose()
	if self.purpose and #self.purpose > 0 then
		local maxFriendTotalHurted = 0

		for i, v in ipairs(xyd.Battle.teamA) do
			if maxFriendTotalHurted < v.totalHarmToEnd then
				maxFriendTotalHurted = v.totalHarmToEnd
			end
		end

		xyd.Battle.purposes.maxFriendTotalHurted = maxFriendTotalHurted
	end
end

function BattleCreateReport:battleEnd()
	self:calculatePurpose()
	self:writeReport()
end

function BattleCreateReport:mainLoop()
	xyd.Battle.curRoundFigthers = {}
	xyd.Battle.petChooseFriends = {}
	xyd.Battle.petChooseEnemys = {}
	xyd.Battle.ackSpeedFlag = false
	xyd.Battle.round = xyd.Battle.round + 1

	self:petRound()

	if xyd.Battle.round > 1 then
		self:updateAllBuffs()
	else
		self:useGodPasSkill({
			xyd.TriggerType.ROUND_AFTER_DOT,
			xyd.TriggerType.ODD_ROUND,
			xyd.TriggerType.ROUND_BEGIN
		})
		self:useBattleStartSkill()
	end

	local isEnd, isReborn = self:checkEnds()

	if isEnd then
		self.isBattleEnded_ = true

		return
	elseif not isEnd and isReborn then
		return true
	end

	self:addRoundPetEnergy()

	local teamABeginAttack = false
	local fighter = self:getNextFighter()

	while fighter do
		if fighter:canAttack() then
			if not teamABeginAttack and fighter:getTeamType() == xyd.TeamType.A then
				self:useGodPasSkill({
					xyd.TriggerType.TEAMA_START_ATTACK
				})

				teamABeginAttack = true
			end

			local pos = fighter:getPos()

			if not xyd.Battle.atkTimes[pos] then
				xyd.Battle.atkTimes[pos] = 0
			end

			xyd.Battle.atkTimes[pos] = xyd.Battle.atkTimes[pos] + 1
		end

		local isEnergySkill = fighter:singleLoop()

		if isEnergySkill and not fighter:isPet() then
			self:addPetEnergy(fighter)
		end

		local isEnd, isReborn = self:checkEnds()

		if not isEnd then
			if not isReborn then
				fighter = self:getNextFighter()
			else
				break
			end
		else
			break
		end
	end

	local round = self:getMaxRound()

	if round <= xyd.Battle.round then
		self:checkHpWin()

		self.isBattleEnded_ = true

		return
	end

	if self.isBattleEnded_ then
		return false
	end

	return true
end

function BattleCreateReport:getMaxRound()
	if self.paramsMaxRound then
		return self.paramsMaxRound
	end

	local round = xyd.Battle.maxRound

	if self.battleType == xyd.ReportBattleType.SPORTS_MEETING or self.battleType == xyd.ReportBattleType.ARENA_ALL_SERVER or self.battleType == xyd.ReportBattleType.ARENA_TEAM or self.battleType == xyd.ReportBattleType.ARENA_NORMAL or self.battleType == xyd.ReportBattleType.ARENA_TOP or self.battleType == xyd.ReportBattleType.GUILD_WAR or self.battleType == xyd.ReportBattleType.ARENA_CHOSEN_BET then
		round = xyd.Battle.maxSportMeetingRound
	end

	return round
end

function BattleCreateReport:useBattleStartSkill()
	local function createAttackUnit(noPasSkill)
		local params = {
			skillID = 0,
			notTrigPasSkill = noPasSkill
		}
		local curUnit = AttackUnit.new(params)
		local recordUnit = RecordUnit.new({
			skillID = 0,
			unit = curUnit
		})
		xyd.Battle.recordUnit = recordUnit

		table.insert(xyd.Battle.recordUnits, recordUnit)

		return curUnit
	end

	local unit, unit2, lastBaseFighter = nil

	if xyd.Battle.round == 1 then
		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() then
				local skillIDs = v:getPasSkillByType(xyd.TriggerType.BEFORE_BATTLE_START)

				if next(skillIDs) then
					unit = unit or createAttackUnit(false)

					v:usePasSkill(xyd.TriggerType.BEFORE_BATTLE_START, unit)
				end
			end
		end

		if xyd.Battle.god then
			unit = unit or createAttackUnit(false)

			xyd.Battle.god:usePasSkill(xyd.TriggerType.BEFORE_BATTLE_START, unit)
		end

		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() then
				lastBaseFighter = v
				local skillIDs = v:getPasSkillByType(xyd.TriggerType.BATTLE_START)

				if next(skillIDs) then
					unit = unit or createAttackUnit(false)

					v:usePasSkill(xyd.TriggerType.BATTLE_START, unit)
				end

				skillIDs = v:getPasSkillByType(xyd.TriggerType.BATTLE_START_WITHOUT_PASSKILL)

				if next(skillIDs) then
					unit2 = unit2 or createAttackUnit(true)

					v:usePasSkill(xyd.TriggerType.BATTLE_START_WITHOUT_PASSKILL, unit2)
				end

				if xyd.checkWeiWeiAn(v) then
					unit = unit or createAttackUnit(false)

					v:usePasSkill(xyd.TriggerType.WEIWEAN_ROUND_BEGIN, unit)
				end

				unit = unit or createAttackUnit(false)

				v:usePasSkill(xyd.TriggerType.ROUND_BEGIN_WITH_ARTIFACT, unit)
			end
		end
	end
end

function BattleCreateReport:useGodPasSkill(triggerTypes)
	if xyd.Battle.god then
		local function createAttackUnit()
			local params = {
				skillID = 0,
				fighter = xyd.Battle.god
			}
			local curUnit = AttackUnit.new(params)
			local recordUnit = RecordUnit.new({
				skillID = 0,
				fighter = xyd.Battle.god,
				unit = curUnit
			})
			xyd.Battle.recordUnit = recordUnit

			table.insert(xyd.Battle.recordUnits, recordUnit)

			return curUnit
		end

		local unit = nil

		for _, triggerType in ipairs(triggerTypes) do
			local skillIDs = xyd.Battle.god:getPasSkillByType(triggerType)

			if next(skillIDs) then
				unit = unit or createAttackUnit()

				xyd.Battle.god:usePasSkill(triggerType, unit)
			end
		end
	end
end

function BattleCreateReport:petRound()
	for _, fighter in ipairs(xyd.Battle.teamPet) do
		self:petUseBattleStartSkill(fighter)
		fighter:singleLoop()

		local isEnd, isReborn = self:checkEnds()

		if isEnd or isReborn then
			break
		end
	end
end

function BattleCreateReport:petUseBattleStartSkill(fighter)
	local function createAttackUnit(noPasSkill)
		local params = {
			skillID = 0,
			notTrigPasSkill = noPasSkill
		}
		local curUnit = AttackUnit.new(params)
		local recordUnit = RecordUnit.new({
			skillID = 0,
			unit = curUnit
		})
		xyd.Battle.recordUnit = recordUnit

		table.insert(xyd.Battle.recordUnits, recordUnit)

		return curUnit
	end

	local unit = nil

	if xyd.Battle.round == 1 then
		unit = unit or createAttackUnit(false)

		fighter:usePasSkill(xyd.TriggerType.BATTLE_START, unit)
	end
end

function BattleCreateReport:addPetEnergy(fighter)
	local pet = self:getPetByType(fighter:getTeamType())

	if pet then
		pet:updateEnergyBy2(xyd.Battle.PET_RE_MP)
	end
end

function BattleCreateReport:addRoundPetEnergy()
	for _, fighter in ipairs(xyd.Battle.teamPet) do
		fighter:updateEnergyBy2(xyd.Battle.PET_ROUND_RE_MP)
	end
end

function BattleCreateReport:getPetByType(teamType)
	local pet = nil

	for _, fighter in ipairs(xyd.Battle.teamPet) do
		if fighter:getTeamType() == teamType then
			pet = fighter

			break
		end
	end

	return pet
end

function BattleCreateReport:updateAllBuffs()
	local function createAttackUnit()
		local params = {
			skillID = 0,
			fighter = nil
		}
		local curUnit = AttackUnit.new(params)
		local recordUnit = RecordUnit.new({
			skillID = 0,
			unit = curUnit
		})
		xyd.Battle.recordUnit = recordUnit

		table.insert(xyd.Battle.recordUnits, recordUnit)

		return curUnit
	end

	local unit = createAttackUnit()

	for i, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:usePasSkill(xyd.TriggerType.ROUND_END_BEFORE_DEBUFF_CLEAN, unit)
		end
	end

	for i, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:usePasSkill(xyd.TriggerType.ROUND_END_USE_DEBUFF_CLEAN, unit)
		end
	end

	for i, v in ipairs(xyd.Battle.teamA) do
		if not v:isDeath() then
			v:updateBuffCount(unit)
		end
	end

	for i, v in ipairs(xyd.Battle.teamB) do
		if not v:isDeath() then
			v:updateBuffCount(unit)
		end
	end

	for i, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:usePasSkill(xyd.TriggerType.ROUND_END_AFTER_COUNT, unit)
		end
	end

	if xyd.Battle.god then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_END, unit)

		for i = #xyd.Battle.god.buffs_, 1, -1 do
			local buff = xyd.Battle.god.buffs_[i]

			if buff then
				buff:excuteAfterRound(unit)
			end
		end

		xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_END_AFTER_COUNT, unit)

		if xyd.Battle.isCure then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.CURE_LATER, unit)
		end

		if next(xyd.Battle.crystalEndTargets) then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.CRYSTAL_END, unit)
		end

		if next(xyd.Battle.crystalTargets) then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.FRIEND_CRYSTAL, unit)
		end

		if xyd.Battle.round % 2 == 1 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ODD_ROUND, unit)
		else
			xyd.Battle.god:usePasSkill(xyd.TriggerType.EVEN_ROUND, unit)
		end

		if xyd.Battle.round <= 3 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.FIRST_TWO_ROUND_END, unit)
		end

		if xyd.Battle.round > 3 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_END_AFTER_3, unit)
		end

		if xyd.Battle.round >= 6 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_BEGIN_AFTER_6, unit)
		end

		if xyd.Battle.round % 4 == 0 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_PASS_4, unit)
		end

		xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_BEGIN, unit)
	end

	local count = 0
	local hasNewDie = true
	local dieFighter = {}

	while count <= xyd.Battle.MAX_TEAM_NUM and hasNewDie do
		count = count + 1
		hasNewDie = false

		for i, v in ipairs(xyd.Battle.teamA) do
			if not dieFighter[v:getPos()] and v:isDeath() and v:getDieRound() == 0 then
				v:die(unit)

				dieFighter[v:getPos()] = true
			end
		end

		for i, v in ipairs(xyd.Battle.teamB) do
			if not dieFighter[v:getPos()] and v:isDeath() and v:getDieRound() == 0 then
				v:die(unit)

				dieFighter[v:getPos()] = true
			end
		end

		for i, v in ipairs(xyd.Battle.team) do
			if v:isDeath() and not dieFighter[v:getPos()] then
				hasNewDie = true

				break
			end
		end
	end

	for i, v in ipairs(xyd.Battle.teamA) do
		if (v:canReborn() or v:apateSpecialReborn()) and v:getDieRound() ~= xyd.Battle.round then
			v:updateRebornBuff(unit)
		end
	end

	for i, v in ipairs(xyd.Battle.teamB) do
		if (v:canReborn() or v:apateSpecialReborn()) and v:getDieRound() ~= xyd.Battle.round then
			v:updateRebornBuff(unit)
		end
	end

	count = 0
	hasNewDie = true

	while count <= xyd.Battle.MAX_TEAM_NUM and hasNewDie do
		count = count + 1
		hasNewDie = false

		for i, v in ipairs(xyd.Battle.teamA) do
			if not dieFighter[v:getPos()] and v:isDeath() and v:getDieRound() == 0 then
				v:die(unit)

				dieFighter[v:getPos()] = true
			end
		end

		for i, v in ipairs(xyd.Battle.teamB) do
			if not dieFighter[v:getPos()] and v:isDeath() and v:getDieRound() == 0 then
				v:die(unit)

				dieFighter[v:getPos()] = true
			end
		end

		for i, v in ipairs(xyd.Battle.team) do
			if v:isDeath() and not dieFighter[v:getPos()] then
				hasNewDie = true

				break
			end
		end
	end

	local unit2 = createAttackUnit()

	for i, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() and xyd.checkWeiWeiAn(v) then
			v:usePasSkill(xyd.TriggerType.WEIWEAN_ROUND_BEGIN, unit2)
		end
	end

	for i, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:usePasSkill(xyd.TriggerType.ROUND_BEGIN_AFTER_ONE, unit2)
			v:usePasSkill(xyd.TriggerType.ROUND_BEGIN_WITH_ARTIFACT, unit2)
		end
	end

	xyd.Battle.isCure = false
	xyd.Battle.curRoundDie = {}
	xyd.Battle.passiveQueue = {}
	xyd.Battle.roundHarm = {}
	xyd.Battle.crystalEndTargets = {}
	xyd.Battle.crystalTargets = {}
end

function BattleCreateReport:CheckAlive(team)
	local hasAlive = false

	for i, v in ipairs(team) do
		if not v:isDeath() then
			hasAlive = true

			break
		end
	end

	return hasAlive
end

function BattleCreateReport:getNextFighter()
	if not xyd.Battle.ackSpeedFlag then
		self:createFighterQueue()
	end

	local fighter = nil

	while not fighter and next(xyd.Battle.passiveQueue) do
		fighter = xyd.Battle.passiveQueue[1]

		if fighter:isDeath() then
			fighter = nil
		end

		table.remove(xyd.Battle.passiveQueue, 1)
	end

	while not fighter and next(xyd.Battle.fighterQueue) do
		xyd.Battle.atkDFlag = false
		fighter = xyd.Battle.fighterQueue[1]

		if fighter:isDeath() then
			fighter = nil
		else
			table.insert(xyd.Battle.curRoundFigthers, fighter:getPos())
		end

		table.remove(xyd.Battle.fighterQueue, 1)
	end

	return fighter
end

function BattleCreateReport:createFighterQueue()
	if xyd.Battle.ackSpeedFlag then
		return
	end

	xyd.Battle.ackSpeedFlag = true
	local fighters = {}

	for i, v in ipairs(xyd.Battle.teamA) do
		if not v:isDeath() and xyd.arrayIndexOf(xyd.Battle.curRoundFigthers, v:getPos()) < 0 then
			table.insert(fighters, v)
		end
	end

	for i, v in ipairs(xyd.Battle.teamB) do
		if not v:isDeath() and xyd.arrayIndexOf(xyd.Battle.curRoundFigthers, v:getPos()) < 0 then
			table.insert(fighters, v)
		end
	end

	table.sort(fighters, function (a, b)
		if a:getAckSpeed() ~= b:getAckSpeed() then
			return b:getAckSpeed() < a:getAckSpeed()
		elseif a:getPos() ~= b:getPos() then
			return a:getPos() < b:getPos()
		end
	end)

	xyd.Battle.fighterQueue = fighters
end

function BattleCreateReport:checkEnds()
	if self.isBattleEnded_ then
		return true
	end

	local function checkAlive(team)
		local hasAlive = false

		for i, v in ipairs(team) do
			if not v:isDeath() and not next(v.isExile_) then
				hasAlive = true

				break
			end
		end

		return hasAlive
	end

	local function checkReborn(team)
		local canReborn = false

		for i, v in ipairs(team) do
			if v:canReborn() then
				canReborn = true

				break
			end
		end

		return canReborn
	end

	local hasAliveA = checkAlive(xyd.Battle.teamA)
	local hasAliveB = checkAlive(xyd.Battle.teamB)
	local canRebornA = checkReborn(xyd.Battle.teamA)
	local canRebornB = checkReborn(xyd.Battle.teamB)

	if (hasAliveA or canRebornA) and not hasAliveB and not canRebornB then
		self.isBattleEnded_ = true
		self.isWin_ = 1

		return true
	elseif (hasAliveB or canRebornB) and not hasAliveA and not canRebornA then
		self.isBattleEnded_ = true

		return true
	elseif not hasAliveA and not canRebornA and not hasAliveB and not canRebornB then
		self.isWin_ = self:checkAllDeadWin()
		self.isAllDie_ = true
		self.isBattleEnded_ = true

		return true
	elseif not hasAliveA and canRebornA or not hasAliveB and canRebornB then
		return false, true
	end

	return false
end

function BattleCreateReport:checkAllDeadWin()
	if self.battleType == xyd.ReportBattleType.TRAIL or self.battleType == xyd.ReportBattleType.FRIEND_BOSS or self.battleType == xyd.ReportBattleType.DUNGEON or self.battleType == xyd.ReportBattleType.GOVERN_TEAM or self.battleType == xyd.ReportBattleType.TRIAL_NEW or self.battleType == xyd.ReportBattleType.MONTHLY_HIKE or self.battleType == xyd.ReportBattleType.SKY_ISLAND then
		return 1
	end

	return 0
end

function BattleCreateReport:checkHpWin()
	local function getAliveNum(team)
		local num = 0

		for i, v in ipairs(team) do
			if not v:isDeath() then
				num = num + 1
			end
		end

		return num
	end

	if self.battleType == xyd.ReportBattleType.ARENA_ALL_SERVER then
		self.isWin_ = 0
		local AliveA = getAliveNum(xyd.Battle.teamA)
		local AliveB = getAliveNum(xyd.Battle.teamB)

		if AliveB < AliveA then
			self.isWin_ = 1
		elseif AliveA < AliveB then
			self.isWin_ = 0
		else
			local totalHpA = self:getTotalHp(xyd.Battle.teamA)
			local totalHpB = self:getTotalHp(xyd.Battle.teamB)

			if totalHpB < totalHpA then
				self.isWin_ = 1
			else
				self.isWin_ = 0
			end
		end
	end
end

function BattleCreateReport:getTotalHp(team)
	local totalHp = 0

	for _, v in ipairs(team) do
		totalHp = totalHp + v:getHp()
	end

	return totalHp
end

function BattleCreateReport:getReturnPurpose()
	if self.purpose and #self.purpose > 0 then
		local purposes = {}

		for k, v in ipairs(self.purpose) do
			local purposeType = BattleChallengeTable:getType(v)
			local purposeParams = BattleChallengeTable:getParams(v)
			local isOk = 0
			local battleReport = {
				battle_report = self.report_,
				enemy_total_harm = self:getEnemyTotalHarm(),
				status = self:getStatus(),
				is_win = self:isWin()
			}

			if purposeType == xyd.PurposeType.BLOOD_POSION_FIRE then
				if xyd.Battle.purposes.hasBlood and xyd.Battle.purposes.hasPoision and xyd.Battle.purposes.hasFire then
					isOk = 1
				end
			elseif purposeType == xyd.PurposeType.SELF_ONE_HERO_HURTED then
				if xyd.Battle.purposes.maxFriendTotalHurted and purposeParams <= xyd.Battle.purposes.maxFriendTotalHurted then
					isOk = 1
				end
			elseif purposeType == xyd.PurposeType.CONTROL_TIMES then
				if xyd.Battle.purposes.controlEnemyTimes and purposeParams <= xyd.Battle.purposes.controlEnemyTimes then
					isOk = 1
				end
			elseif battleChallengeCheck:check(v, battleReport) then
				isOk = 1
			end

			table.insert(purposes, isOk)
		end

		return purposes
	else
		return nil
	end
end

function BattleCreateReport:writeReport()
	if xyd.Battle.isSweep then
		return
	end

	if self.report_ then
		return self.report_
	end

	self.report_ = {
		info = {
			battle_id = self.battleID
		}
	}

	self:updateEndStatus()

	local function getFighterData(fighter)
		local hero = fighter.hero_

		if fighter.oldHero_ then
			hero = fighter.oldHero_
		end

		local params = {
			table_id = fighter:getTableID(),
			pos = hero.pos,
			grade = hero:getGrade(),
			level = hero:getLevel(),
			awake = hero:getAwake(),
			isMonster = hero:isMonster(),
			initMp = fighter:getInitMp(),
			skin_id = hero:getSkin(),
			show_skin = hero:getShowSkin(),
			is_vowed = hero:isVowed(),
			equips = hero:getEquips(),
			love_point = hero:getLove(),
			potentials = hero:getPotential(),
			skill_index = hero:getEquipSkillIndex(),
			ex_skills = hero:getExSkills(),
			travel = hero:getTravelBuff(),
			ver = hero:getVer()
		}

		if fighter.status then
			params.status = fighter.status
		end

		return params
	end

	self.report_.total_round = xyd.Battle.round
	self.report_.hurts = {}
	self.report_.teamA = {}
	self.report_.battle_type = self.battleType
	self.report_.guildSkillsA = self.guildSkillsA
	self.report_.guildSkillsB = self.guildSkillsB
	self.report_.dressAttrsA = xyd.Battle.dressAttrsA
	self.report_.dressAttrsB = xyd.Battle.dressAttrsB
	self.report_.random_seed_2 = xyd.Battle.initRandomSeed
	self.report_.god_skills = self.godSkills
	self.report_.die_info = self:getDieInfo()
	self.report_.die_round = {}
	self.report_.hp = {}
	self.report_.atk_times = xyd.Battle.atkTimes
	self.report_.self_control_times = xyd.Battle.selfControlTimes
	self.report_.enemy_control_times = xyd.Battle.enemyControlTimes

	for i, v in ipairs(xyd.Battle.teamA) do
		table.insert(self.report_.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos()
		})
		table.insert(self.report_.teamA, getFighterData(v))

		if v:isDeath() then
			table.insert(self.report_.die_round, {
				pos = v:getPos(),
				round = v:getDieRound()
			})
		end

		table.insert(self.report_.hp, {
			pos = v:getPos(),
			hp = math.ceil(100 * v:getHpPercent()),
			true_hp = math.ceil(v:getHp())
		})
	end

	self.report_.teamB = {}

	for i, v in ipairs(xyd.Battle.teamB) do
		table.insert(self.report_.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos()
		})
		table.insert(self.report_.teamB, getFighterData(v))

		if v:isDeath() then
			table.insert(self.report_.die_round, {
				pos = v:getPos(),
				round = v:getDieRound()
			})
		end

		table.insert(self.report_.hp, {
			pos = v:getPos(),
			hp = math.ceil(100 * v:getHpPercent()),
			true_hp = math.ceil(v:getHp())
		})
	end

	if self.petA_ then
		self.report_.petA = self.petA_:toParams()
	end

	if self.petB_ then
		self.report_.petB = self.petB_:toParams()
	end

	if xyd.Battle.god then
		local god = xyd.Battle.god

		table.insert(self.report_.hurts, {
			pos = god:getPos(),
			hurt = god.hurt_,
			heal = god.heal_
		})
	end

	for i, v in ipairs(xyd.Battle.teamPet) do
		table.insert(self.report_.hurts, {
			hurt = v.hurt_,
			heal = v.heal_,
			pos = v:getPos()
		})
	end

	self.report_.isWin = self.isWin_
	self.report_.frames = {}

	for i = 1, #xyd.Battle.recordUnits do
		local unit = xyd.Battle.recordUnits[i]
		local params = unit:getRecords()

		table.insert(self.report_.frames, params)
	end

	if xyd.Battle.has_random and xyd.Battle.has_random == 1 then
		self.report_.random_log = cjson.encode(xyd.Battle.randomUseData)
		self.report_.random_seed = self.randomSeed
	end

	self.report_.purposes = self:getReturnPurpose()

	return self.report_
end

function BattleCreateReport:getReport()
	return self.report_
end

function BattleCreateReport:updateEndStatus()
	for i, v in ipairs(xyd.Battle.teamA) do
		if v:canReborn() then
			v:battleEndReborn()
		end
	end

	for i, v in ipairs(xyd.Battle.teamB) do
		if v:canReborn() then
			v:battleEndReborn()
		end
	end
end

function BattleCreateReport:isWin()
	return self.isWin_
end

function BattleCreateReport:isAllDie()
	if self.isAllDie_ then
		return self.isAllDie_
	end

	local function checkAlive(team)
		local hasAlive = false

		for i, v in ipairs(team) do
			if not v:isDeath() then
				hasAlive = true

				break
			end
		end

		return hasAlive
	end

	local function checkReborn(team)
		local canReborn = false

		for i, v in ipairs(team) do
			if v:canReborn() then
				canReborn = true

				break
			end
		end

		return canReborn
	end

	local hasAliveA = checkAlive(xyd.Battle.teamA)
	local hasAliveB = checkAlive(xyd.Battle.teamB)
	local canRebornA = checkReborn(xyd.Battle.teamA)
	local canRebornB = checkReborn(xyd.Battle.teamB)

	if not hasAliveA and not canRebornA and not hasAliveB and not canRebornB then
		self.isAllDie_ = true
	end

	return self.isAllDie_
end

function BattleCreateReport:getTotalHarm()
	local totalHarm = 0

	for i, v in ipairs(xyd.Battle.teamA) do
		totalHarm = totalHarm + v.hurt_
	end

	if self.battleType == xyd.ReportBattleType.TRIAL_NEW or self.battleType == xyd.ReportBattleType.ICE_SECRET_BOSS or self.battleType == xyd.ReportBattleType.LIMIT_GACHA_BOSS or self.battleType == xyd.ReportBattleType.SKY_ISLAND then
		if self.petA_ then
			totalHarm = totalHarm + xyd.Battle.teamPet[1].hurt_
		end

		if xyd.Battle.god then
			totalHarm = totalHarm + xyd.Battle.god.hurt_
		end
	end

	return totalHarm
end

function BattleCreateReport:getEnemyTotalHarm()
	local totalHarm = 0

	for i, v in ipairs(xyd.Battle.teamB) do
		totalHarm = totalHarm + v.hurt_
	end

	if (self.battleType == xyd.ReportBattleType.TRIAL_NEW or self.battleType == xyd.ReportBattleType.ICE_SECRET_BOSS or self.battleType == xyd.ReportBattleType.LIMIT_GACHA_BOSS or self.battleType == xyd.ReportBattleType.SKY_ISLAND) and self.petB_ then
		local pet = self:getPetByType(xyd.TeamType.B)
		totalHarm = totalHarm + pet.hurt_
	end

	return totalHarm
end

function BattleCreateReport:getRound()
	return #xyd.Battle.recordUnits
end

function BattleCreateReport:getStatus()
	local statusA = {}
	local statusB = {}

	for k, hero in ipairs(self.herosA) do
		local fighter = self:getFighterByPos(xyd.Battle.team, hero.pos)
		local status = {}

		if fighter then
			status = {
				pos = hero.pos,
				true_hp = math.ceil(fighter:getHp()),
				hp = math.ceil(100 * math.floor(fighter:getHp()) / math.floor(fighter:getHpLimit())),
				mp = fighter:getEnergy()
			}
		else
			status = hero.status
		end

		table.insert(statusA, status)
	end

	for k, hero in ipairs(self.herosB) do
		local fighter = self:getFighterByPos(xyd.Battle.team, hero.pos + xyd.TEAM_B_POS_BASIC)
		local status = {}

		if fighter then
			status = {
				pos = hero.pos,
				true_hp = math.ceil(fighter:getHp()),
				hp = math.ceil(100 * math.floor(fighter:getHp()) / math.floor(fighter:getHpLimit())),
				mp = fighter:getEnergy()
			}
		else
			status = hero.status
		end

		table.insert(statusB, status)
	end

	local result = {
		status_a = statusA,
		status_b = statusB
	}

	return result
end

function BattleCreateReport:getDieInfo()
	local dieInfo = {}

	for k, hero in ipairs(self.herosA) do
		local fighter = self:getFighterByPos(xyd.Battle.team, hero.pos)

		if fighter and fighter:isDeath() then
			table.insert(dieInfo, fighter:getPos())
		elseif hero.status and hero.status.hp == 0 then
			table.insert(dieInfo, hero.pos)
		end
	end

	for k, hero in ipairs(self.herosB) do
		local fighter = self:getFighterByPos(xyd.Battle.team, hero.pos + xyd.TEAM_B_POS_BASIC)

		if fighter and fighter:isDeath() then
			table.insert(dieInfo, fighter:getPos())
		elseif hero.status and hero.status.hp == 0 then
			table.insert(dieInfo, hero.pos + xyd.TEAM_B_POS_BASIC)
		end
	end

	return dieInfo
end

function BattleCreateReport:getSaveData()
	local function getFighterData(fighter)
		local hero = fighter.hero_

		if fighter.oldHero_ then
			hero = fighter.oldHero_
		end

		local params = {
			table_id = fighter:getTableID(),
			pos = hero.pos,
			grade = hero:getGrade(),
			level = hero:getLevel(),
			awake = hero:getAwake(),
			isMonster = hero:isMonster(),
			skin_id = hero:getSkin(),
			show_skin = hero:getShowSkin(),
			is_vowed = hero:isVowed(),
			equips = hero:getEquips(),
			love_point = hero:getLove(),
			potentials = hero:getPotential(),
			skill_index = hero:getEquipSkillIndex(),
			ex_skills = hero:getExSkills(),
			travel = hero:getTravelBuff(),
			ver = hero:getVer()
		}

		if fighter.status then
			params.status = fighter.status
		end

		return params
	end

	local params = {
		info = {
			battle_id = self.battleID
		},
		hurts = self.report_ and self.report_.hurts or {},
		die_info = self.report_ and self.report_.die_info or {},
		isWin = self.isWin_,
		battle_type = self.battleType,
		teamA = {},
		guildSkillsA = self.guildSkillsA,
		guildSkillsB = self.guildSkillsB,
		dressAttrsA = xyd.Battle.dressAttrsA,
		dressAttrsB = xyd.Battle.dressAttrsB,
		random_seed = self.randomSeed,
		god_skills = self.godSkills,
		total_round = xyd.Battle.round,
		battle_version = xyd.tables.miscTable:getNumber("battle_version", "value") or 0
	}

	for i, v in ipairs(xyd.Battle.teamA) do
		table.insert(params.teamA, getFighterData(v))
	end

	params.teamB = {}

	for i, v in ipairs(xyd.Battle.teamB) do
		table.insert(params.teamB, getFighterData(v))
	end

	if self.petA_ then
		params.petA = self.petA_:toParams()
	end

	if self.petB_ then
		params.petB = self.petB_:toParams()
	end

	return params
end

return BattleCreateReport
