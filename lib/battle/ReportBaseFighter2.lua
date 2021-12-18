local ReportBaseFighter = class("ReportBaseFighter")
local AttackUnit = xyd.Battle.getRequire("ReportAttackUnit")
local RecordUnit = xyd.Battle.getRequire("RecordUnit")
local GetTarget_ = xyd.Battle.getRequire("GetTarget")
local SkillTable = xyd.tables.skillTable
local BuffTable = xyd.tables.dBuffTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local Hero = xyd.Battle.getRequire("ReportHero")
local EffectTable = xyd.tables.effectTable
local BattleTriggerTable = xyd.tables.battleTriggerTable
local battle_event = xyd.Battle.getRequire("battle_event")
local GroupTable = xyd.tables.groupTable
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_sqrt = math.sqrt

function ReportBaseFighter:ctor(params)
	self.energy_ = 0

	self:init()
end

function ReportBaseFighter:init()
	self.___attrCache = {}
	self.___ackSpeed = nil
	self.buffs_ = {}
	self.unitSkills_ = nil

	self:updateTeamCache()

	self.isStun_ = {}
	self.isForbid_ = {}
	self.isDot_ = {}
	self.isHot_ = {}
	self.isHeal_ = {}
	self.isIce_ = {}
	self.isStone_ = {}
	self.isMindControl_ = {}
	self.addHurtTargets_ = {}
	self.cImpresses_ = {}
	self.rImpresses_ = {}
	self.fImpresses_ = {}
	self.oImpresses_ = {}
	self.bImpresses_ = {}
	self.isTransform_ = {}
	self.isFreeHarm_ = {}
	self.isRevive_ = {}
	self.isAtkUnable_ = {}
	self.isRemoveControl_ = {}
	self.isFireLess_ = {}
	self.isBloodLess_ = {}
	self.isFireDecDmg_ = {}
	self.hasInfRevive_ = false
	self.infRebornTimes_ = 0
	self.hurt_ = 0
	self.heal_ = 0
	self.hasReviveTimes_ = 0
	self.noReviveDie_ = false
	self.hasReviveMaxTime_ = false
	self.infRebornMaxTimes_ = -1
	self.pasSkills_ = nil
	self.dieRound_ = 0
	self.killer = nil
	self.dieRoundWithReborn_ = 0
	self.initMp_ = 0
	self.maxHpP_ = 0
	self.canHeal_ = true
	self.isPassiveQuene_ = false
	self.isEnergyQueue_ = false
	self.isRandomPugong_ = false
	self.justReviveFromInf_ = false
	self.debuffCleanLimitRound_ = 0
	self.debuffCleanLimitTimes_ = 0
	self.master_ = nil
	self.fenshen_ = {}
	self.globalBuffs_ = {}
	self.hasDieHit_ = false
	self.aggressions_ = {}
	self.hurtForEnergy_ = {}
	self.isEat_ = {}
	self.isEatFreeHarm_ = {}
	self.isExceptDotShield_ = {}
	self.isFrighten_ = {}
	self.isCrystal_ = {}
	self.isCrystallize_ = {}
	self.decDmgShield = {}
	self.freeShield = {}
	self.isMarkHurtSkillLB_ = {}
	self.isMarkHurtPasLB = {}
	self.curRoundTotalHarm_ = 0
	self.curRoundTotalCritHarm_ = 0
	self.blockTimes_ = 0
	self.hitTimes_ = 0
	self.totalHarm_ = 0
	self.totalHarmToEnd = 0
	self.enemyDieNum_ = 0
	self.equipHealRound = 0
	self.isImmControlTimes_ = {}
	self.isTear_ = {}
	self.isMissLimit2_ = {}
	self.isXTimeShield_ = {}
	self.isAtkDebuff_ = {}
	self.isVanity_ = {}
	self.isExile_ = {}
	self.isDecDmgNAdd_ = {}
	self.isCritTimeBlood_ = {}
	self.isDecDmgBlood_ = {}
	self.isDotB_ = {}
	self.isCritTimeLimit_ = {}
	self.atkedMore50 = -1
	self.atkedLess50 = -1
	self.isExtraNoCritHarm_ = {}
	self.isImmenu_ = {}
	self.isReflect_ = {}
	self.isReduceDot_ = {}
	self.isHalfHpArm_ = {}
	self.isHalfHpDmg_ = {}
	self.isHalfHpDecP_ = {}
	self.isAllDmgB_ = {}
	self.isRoundDmgB_ = {}
	self.isDecDmgShieldLimit8_ = {}
	self.isHurtShieldLimit1_ = {}
	self.isHurtShieldLimit2_ = {}
	self.isHurtShieldLimit3_ = {}
	self.isYxControlRemove_ = {}
	self.isFreeLimit1_ = {}
	self.isAtkPLimit3_ = {}
	self.isHealBLimit1_ = {}
	self.isCritTimeLimit3_ = {}
	self.isXHurtDebuffRemove_ = {}
	self.isDecHurt_ = {}
	self.isSuperDecHurt_ = {}
	self.isRoundReflect_ = {}
	self.isNoHarm_ = {}
	self.isNoDebuff_ = {}
	self.isReviveFirstTwoEnemy_ = {}
	self.isSeal_ = {}
	self.isHurtMaxHpLimit_ = {}
	self.isDecHurtLess_ = {}
	self.isForbidUnableClean_ = {}
	self.isMoonShadow_ = {}
	self.isStarMoon_ = {}
	self.isFragranceGet_ = {}
	self.isFragranceAtk_ = {}
	self.isFragranceDecDmg_ = {}
	self.isMarkFriendHurtLB_ = {}
	self.isControlReduce_ = {}
	self.isGetAbsorbShield_ = {}
	self.isGetHealCurse_ = {}
	self.isGetLight_ = {}
	self.selectEnemy = nil
	self.isAtkRandomTime_ = {}
	self.isMarkAddHurtFreeArm_ = {}
	self.isMarkAddHurt_ = {}
	self.isWulieerSeal_ = {}
	self.isGetLeaf_ = {}
	self.isGetThorns_ = {}
	self.isExchangeSpd_ = {}
	self.isForceSeal_ = {}
	self.isTargetChange_ = {}
	self.isAllHarmShare_ = {}
	self.isFullEnergyHurt_ = {}
	self.isApateRevive_ = {}
	self.isMarkApate_ = {}
	self.isReduceSpd_ = {}
	self.isSpdSteal_ = {}
	self.hasAbsorbDamage = false
	self.isAbsorbDamage_ = {}
	self.isXifengSpd_ = {}
	self.buffRidicule_ = nil
	self.buffOutBreak_ = nil
	self.commonExHurtBuffs_ = {}
	self.triggerTimes_ = {}
	self.recordBuffLists_ = {}
	self.harmFreeUnit = {}
	self.hurtedUnits_ = {}
	self.blockHealUnit = nil
	self.blockHealBuff = nil
	self.isFirstLow50_ = false
	self.weiweianLinkHero_ = nil
	self.roundHarm = {}
end

function ReportBaseFighter:setTeamType(teamType)
	self.teamType_ = teamType

	self:updateTeamCache()
end

function ReportBaseFighter:getTeamType()
	return self.teamType_
end

function ReportBaseFighter:updateTeamCache()
	self.selfTeam_ = self.teamType_ == xyd.TeamType.A and xyd.Battle.teamA or xyd.Battle.teamB
	self.sideTeam_ = self.teamType_ ~= xyd.TeamType.A and xyd.Battle.teamA or xyd.Battle.teamB
	self.targetTeam_ = self:isAttackFriend() and self.selfTeam_ or self.sideTeam_
end

function ReportBaseFighter:isPet()
	return false
end

function ReportBaseFighter:isGod()
	return false
end

function ReportBaseFighter:isAttackFriend()
	return false
end

function ReportBaseFighter:isBackTarget()
	local pos = self:getPos()
	local team = self:getTeamType()

	if team == xyd.TeamType.B then
		pos = pos - xyd.TEAM_B_POS_BASIC
	end

	if xyd.DEFAULT_FRONT_NUM < pos and pos <= xyd.DEFAULT_FRONT_NUM + xyd.DEFAULT_BACK_NUM then
		return true
	end

	return false
end

function ReportBaseFighter:getPos()
	return self.fighterIndex
end

function ReportBaseFighter:setPos(pos)
	self.fighterIndex = pos
end

function ReportBaseFighter:setupBattleAttrInfo()
	self.hero_:getBattleAttr()
end

function ReportBaseFighter:setCanHeal(flag)
	self.canHeal_ = flag
end

function ReportBaseFighter:canHeal()
	return self.canHeal_
end

function ReportBaseFighter:updateHp(value)
	self:setHp(value)
end

function ReportBaseFighter:setHp(value)
	self.hp_ = math_min(value, self:getHpLimit())
	self.hp_ = math_max(self.hp_, 0)
end

function ReportBaseFighter:getHp()
	return self.hp_
end

function ReportBaseFighter:updateMaxHpP()
	if self.maxHpP_ > 80 then
		return
	end

	local val = math_floor(xyd.PERCENT_BASE * self:getHp() / self:getHpLimit())

	if self.maxHpP_ < val then
		self.maxHpP_ = val
	end
end

function ReportBaseFighter:updateEnergyByAttack(unit)
	local energy = xyd.PUGONG_RE_MP
	local hitEnergyBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_HIT_ENERGY_CHANGE)

	if next(hitEnergyBuffs) then
		energy = hitEnergyBuffs[1].finalNumArray_[1]
	end

	self:addEnergy(energy, unit)
end

function ReportBaseFighter:addEnergy(value, unit, isClearEnergy)
	local addNum = value

	if addNum > 0 and self:getBuffByName(xyd.BUFF_GOD_CONTROL_ENERGY) then
		addNum = addNum * 0.5
	end

	local holdBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_HOLD)

	if holdBuffs and next(holdBuffs) then
		return
	end

	self:setEnergy(self.energy_ + addNum, unit, isClearEnergy)
end

function ReportBaseFighter:canControlBuffAdd(buff)
	local holdBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_HOLD)

	if holdBuffs and next(holdBuffs) then
		return false
	end

	local name = buff:getName()
	local actualName = BuffTable:actualBuff(name)

	if actualName ~= "" and actualName ~= nil then
		name = actualName
	end

	local firstControlBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_FIRST_CONTROL_FREE)

	if firstControlBuffs and next(firstControlBuffs) then
		if self.firstControlName then
			if self.firstControlName == xyd.BUFF_MARK_CRYSTAL and name == xyd.BUFF_CRYSTALLIZE then
				return false
			end

			if self.firstControlName == name then
				return false
			end
		else
			self.firstControlName = name

			return false
		end
	end

	return true
end

function ReportBaseFighter:updateEnergyByHarm(isCrit, unit, isClearEnergy)
	if self:isDeath() then
		return
	end

	local mp = xyd.HARM_RE_MP

	if isCrit then
		mp = xyd.HARM_CRIT_MP
	end

	if self:isHurtForEnergy() then
		local buff = self:getBuffByName(xyd.BUFF_HURT_FOR_ENERGY)
		mp = (buff:getFinalNum() + 1) * mp
	end

	return self:addEnergy(mp, unit, isClearEnergy)
end

function ReportBaseFighter:updateEnergy(value, unit)
	return self:setEnergy(value, unit)
end

function ReportBaseFighter:setEnergy(value, unit, isClearEnergy)
	self.energy_ = math_max(value, 0)

	self:applyFullEnergyHurt(unit)

	if isClearEnergy then
		self.energy_ = self:getResistEnergy(self.energy_)
		local clearEnergyBuff = BuffManager:newBuff({
			skillID = 1314000,
			target = self
		})
		clearEnergyBuff.name_ = xyd.BUFF_ENERGY

		clearEnergyBuff:writeRecord(self, xyd.BUFF_ON)
		unit:recordBuffs(self, {
			clearEnergyBuff
		})
	end

	self:setUnitPosEp()
end

function ReportBaseFighter:setUnitPosEp()
	if xyd.Battle.recordUnit then
		xyd.Battle.recordUnit:setUnitEp(self:getPos(), self.energy_)
	end
end

function ReportBaseFighter:getEnergy()
	return self.energy_
end

function ReportBaseFighter:applyFullEnergyHurt(unit)
	local canChangeEnergy = true
	local holdEnergyBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_HOLD)

	if holdEnergyBuffs and next(holdEnergyBuffs) then
		canChangeEnergy = false
	end

	if self.energy_ >= 100 and self:isFullEnergyHurt() then
		local needRecord = {}

		for _, buff in ipairs(self.isFullEnergyHurt_) do
			local num = 0

			if canChangeEnergy then
				local harmNum = -buff:getFinalNum() * (self.energy_ - self:getResistEnergy(self.energy_)) * buff.fighter:getAD()
				local addHarmRate = 1 + self:getExtraHarmRate(unit)
				addHarmRate = addHarmRate + self:getExtraRoundHarm(buff)
				num = harmNum
				num = num * addHarmRate
				num = num * buff.target:getSuperDecHurtRate(buff)
				num = self:getShieldHarm(num, unit, false, true)
			end

			buff:setRecordNum(num)
			buff.fighter:recordData(-num, 0)
			self:updateHpByHarm(num, unit, true, false, false, buff)
			buff:writeRecord(self, xyd.BUFF_OFF)

			if not self:isDeath() then
				self:checkHpPasSkill(unit)
			end

			table.insert(needRecord, buff)
		end

		if canChangeEnergy then
			self.energy_ = self:getResistEnergy(self.energy_)
			local clearEnergyBuff = BuffManager:newBuff({
				skillID = 1314000,
				target = self
			})
			clearEnergyBuff.name_ = xyd.BUFF_ENERGY

			clearEnergyBuff:writeRecord(self, xyd.BUFF_ON)
			table.insert(needRecord, clearEnergyBuff)
		end

		self:setUnitPosEp()
		unit:recordPasBuffs(self, needRecord)
		self:removeBuffs(self.isFullEnergyHurt_)
	end
end

function ReportBaseFighter:addInitBuffs(effects, addBuffs)
	local pasSkills = self:getPasSkill()
	local foreverSkills = pasSkills[xyd.TriggerType.FOREVER] or {}
	local dieSkills = pasSkills[xyd.TriggerType.SELF_DIE] or {}

	for _, skillID in ipairs(dieSkills) do
		if SkillTable:getTargets(skillID, 1) == 1 then
			if self.hasInfRevive_ then
				break
			end

			local unit = self:createAttackUnit(skillID, true)
			local datas = unit:getUnitDatas()

			for _, data in ipairs(datas) do
				if self.hasInfRevive_ then
					break
				end

				local hitBuffs = data.hitBuffs

				for i = #hitBuffs, 1, -1 do
					local buff = hitBuffs[i]

					if buff:getName() == xyd.BUFF_REVIVE_INF then
						data.target.hasInfRevive_ = true
					elseif buff:getName() == xyd.BUFF_REVIVE_INF_NUM then
						data.target.infRebornMaxTimes_ = buff:getFinalNum()
					end
				end
			end
		end
	end

	for _, skillID in ipairs(foreverSkills) do
		if SkillTable:trigger(skillID) == xyd.TriggerType.FOREVER then
			local isAttrPas = SkillTable:attrPas(skillID) == 1
			local unit = self:createAttackUnit(skillID, true)
			local datas = unit:getUnitDatas()

			for _, data in ipairs(datas) do
				local hitBuffs = data.hitBuffs

				for i = #hitBuffs, 1, -1 do
					local buff = hitBuffs[i]

					if isAttrPas and not buff:checkIsPassNoAttr() then
						table.remove(hitBuffs, i)
					else
						buff:setYongJiu(true)
					end
				end

				local target = data.target

				target:addBuffs(hitBuffs, unit)
			end
		end
	end

	if effects and next(effects) then
		local function newBuff(target, effectID, index)
			local params = {
				effectID = effectID,
				fighter = self.fighter,
				target = target,
				skillID = self.skillID,
				index = index
			}
			local buff = BuffManager:newBuff(params)

			buff:setIsHit()

			return buff
		end

		local buffs = {}

		for _, id in ipairs(effects) do
			local buff = newBuff(self, id, 1)

			if buff:isHit() then
				buff:setYongJiu(true)
				buff:calculate()
				table.insert(buffs, buff)
			end
		end

		self:addBuffs(buffs)
	end

	if addBuffs and next(addBuffs) then
		self:addBuffs(addBuffs)
	end
end

function ReportBaseFighter:populateWithHero(hero)
	self.partnerID_ = hero:getTableID()
	self.hero_ = hero

	self:initMp()

	self.level_ = hero:getLevel()
	self.energySkillID_ = hero:getSkillID(xyd.SKILL_INDEX.Energy)
end

function ReportBaseFighter:getTableID()
	return self.partnerID_
end

function ReportBaseFighter:getHeroTableID()
	local tableID = nil

	if self:isMonster() then
		tableID = self.hero_:getPartnerLink()
	else
		tableID = self:getTableID()
	end

	return tableID
end

function ReportBaseFighter:getLevel()
	return self.hero_:getLevel()
end

function ReportBaseFighter:initHp()
	self:setupHpLimit()

	self.hp_ = self:getHpLimit()
end

function ReportBaseFighter:initMp()
	self.energy_ = self.hero_:getEnergyBase()
	self.initMp_ = self.energy_
end

function ReportBaseFighter:getInitMp()
	return self.initMp_
end

function ReportBaseFighter:setupHpLimit()
	self.hpLimit_ = self:getHeroHp()
end

function ReportBaseFighter:changeHpLimit(hpLimit, needUpdateHp)
	self.hpLimit_ = hpLimit

	if needUpdateHp and self:getHpLimit() < self:getHp() then
		self:setHp(self:getHpLimit())
	end
end

function ReportBaseFighter:getHpLimit()
	return self.hpLimit_
end

function ReportBaseFighter:getHpPercent()
	return self:getHp() / self:getHpLimit()
end

function ReportBaseFighter:getAckSpeed()
	if not self.___ackSpeed then
		self.___ackSpeed = self:getAttrByType(xyd.BUFF_SPD)

		if self:isExchangeSpd() then
			for _, buff in ipairs(self.isExchangeSpd_) do
				self.___ackSpeed = self.___ackSpeed + buff:getFinalNum()
			end
		end

		if next(self.isReduceSpd_) then
			for _, buff in ipairs(self.isReduceSpd_) do
				self.___ackSpeed = self.___ackSpeed - buff:getFinalNum()
			end
		end

		if next(self.isSpdSteal_) then
			for _, buff in ipairs(self.isSpdSteal_) do
				self.___ackSpeed = self.___ackSpeed + buff:getFinalNum()
			end
		end

		if next(self.isXifengSpd_) then
			for _, buff in ipairs(self.isXifengSpd_) do
				self.___ackSpeed = self.___ackSpeed + buff:getFinalNum()
			end
		end
	end

	self.___ackSpeed = math_max(self.___ackSpeed, 0)

	return self.___ackSpeed
end

function ReportBaseFighter:recordData(harm, cure)
	if self.preNoAddHarm and self.preNoAddHarm == harm then
		self.preNoAddHarm = nil

		return
	end

	self.preNoAddHarm = nil
	self.hurt_ = self.hurt_ + math.ceil(harm or 0)
	self.heal_ = self.heal_ + math.floor(cure or 0)
end

function ReportBaseFighter:singleLoop()
	local isEnergySkill = self:beginAttack()

	return isEnergySkill
end

function ReportBaseFighter:beginAttack()
	local isEnergySkill = false

	if not self:canAttack() then
		return
	end

	if xyd.Battle.recordUnit and xyd.Battle.recordUnit.mainUnit and xyd.Battle.god and self:getPos() > 6 and self:getPos() <= 12 then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_ATTACK_BEFORE, xyd.Battle.recordUnit.mainUnit)
	end

	if xyd.Battle.recordUnit and xyd.Battle.recordUnit.mainUnit and self:getCurrentSkill() == self:getEnergySkillID() then
		self:usePasSkill(xyd.TriggerType.BEFORE_SELF_ENERGY_SKILL_2, xyd.Battle.recordUnit.mainUnit)
	end

	local skillID = self:getCurrentSkill()

	if self:checkEnergySkill() and self:checkEnergySkillLimit() then
		local skillID = self:getEnergySubSkill()[1]
		local unit = self:createAttackUnit(skillID, false, nil, true)

		self:usePasSkill(xyd.TriggerType.ENERGY_SKILL_HOLD, unit)

		local xCanSkillBuff = self:getTeamACanSkillBuff()

		if xCanSkillBuff then
			xCanSkillBuff:addNoCheckId(self:getEnergySkillID())
			xCanSkillBuff:addPartnerSkillTimes()
		end
	end

	if not skillID then
		return
	end

	xyd.Battle.oneSkillHarmRecord = 0
	xyd.Battle.preHitTargets = {}
	local unit = self:createAttackUnit(skillID, false, nil, true)

	self:usePasSkill(xyd.TriggerType.BEFORE_SELF_ENERGY_SKILL, unit)

	if skillID == self:getEnergySkillID() then
		if self.isEnergyQueue_ == false and self:isEnergySkillCostEnergy(skillID) then
			self:updateEnergy(0, unit)
		end

		isEnergySkill = true
		xyd.Battle.justUseSkillTarget = self
		local xCanSkillBuff = self:getTeamACanSkillBuff()

		if xCanSkillBuff then
			xCanSkillBuff:addPartnerSkillTimes(skillID)
		end
	end

	self:usePasSkill(xyd.TriggerType.SELF_ATTACK, unit)
	self:applyUnit(unit)
	self:usePasSkill(xyd.TriggerType.SELF_ATTACK_AFTER, unit)

	if not self:isPet() then
		self:addHurt(self.addHurtTargets_, unit)
	end

	if isEnergySkill == true then
		self:checkExEnergyHurt(unit)
		self:usePasSkill(xyd.TriggerType.SELF_AFTER_SKILL, unit)
	end

	self:checkExHurt(unit)
	self:checkNewRound(unit)

	if not self:isPet() then
		self:checkEnergyPas(isEnergySkill, unit)
	end

	local evt = battle_event:instance()

	evt:emit(xyd.BATTLE_EVENT_UNIT_FINISH, self, nil, unit)
	self:removeBuffAfterAttackUnit(unit)
	self:resetData()

	return isEnergySkill
end

function ReportBaseFighter:getTeamACanSkillBuff()
	if xyd.Battle.god and self:getPos() <= 6 then
		local xCanSkillBuffs = xyd.Battle.god:getBuffsByName(xyd.BUFF_X_CAN_SKILL)

		if next(xCanSkillBuffs) then
			return xCanSkillBuffs[1]
		end
	end
end

function ReportBaseFighter:removeBuffAfterAttackUnit(unit)
	if not next(xyd.Battle.needRemoveBuffs) then
		return
	end

	for _, buff in ipairs(xyd.Battle.needRemoveBuffs) do
		buff:writeRecord(buff.target, xyd.BUFF_OFF)
	end

	unit:recordBuffs(self, xyd.Battle.needRemoveBuffs)
	self:removeBuffs(xyd.Battle.needRemoveBuffs)

	xyd.Battle.needRemoveBuffs = {}
end

function ReportBaseFighter:checkEnergyPas(isEnergySkill, unit)
	if not isEnergySkill then
		return
	end

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:usePasSkill(xyd.TriggerType.ROUND_SKILL, unit)
		end
	end
end

function ReportBaseFighter:resetData()
	self.curRoundTotalHarm_ = 0
	self.curRoundTotalCritHarm_ = 0
	xyd.Battle.curRoundDie = {}

	if self.isRandomPugong_ then
		self.pugongID_ = nil
	end

	self.addHurtTargets_ = {}
	xyd.Battle.roundHarm = {}
end

function ReportBaseFighter:createAttackUnit(skillID, isPas, unit, isNeedRecord, ifNoPas, ifNoBlock)
	local params = {
		skillID = skillID,
		fighter = self,
		isPas = isPas,
		unit = unit,
		rebornTimes = self.infRebornTimes_,
		totalHarm = self.curRoundTotalHarm_,
		totalCritHarm = self.curRoundTotalCritHarm_,
		isNeedRecord = isNeedRecord,
		notTrigPasSkill = ifNoPas,
		ifNoBlock = ifNoBlock
	}

	if unit then
		params.totalHarm = unit.totalHarm_
		params.totalCritHarm = unit.totalCritHarm_
		params.totalReflectHarm = unit.totalReflectHarm_
		params.totalPosHarm = unit.totalPosHarm_
		params.dieTarget = unit.dieTarget
	end

	local curUnit = AttackUnit.new(params)

	if isNeedRecord then
		local recordUnit = RecordUnit.new({
			skillID = skillID,
			fighter = self,
			unit = curUnit
		})
		xyd.Battle.recordUnit = recordUnit

		table.insert(xyd.Battle.recordUnits, recordUnit)
	end

	return curUnit
end

function ReportBaseFighter:getPasHpPercent()
	local res = nil

	if next(self:getPasSkillByType(xyd.TriggerType.ENEMY_HP_LESS_25)) then
		res = 0.25
	elseif next(self:getPasSkillByType(xyd.TriggerType.ENEMY_HP_LESS_30)) then
		res = 0.3
	elseif next(self:getPasSkillByType(xyd.TriggerType.ENEMY_HP_LESS_35)) then
		res = 0.35
	end

	return res
end

function ReportBaseFighter:applyUnit(unit)
	local datas = unit:getUnitDatas()
	local canRemp = false
	local canHarmRemp = {}
	local totalHarm = 0
	local totalCure = 0
	local totalCritHarm = 0
	local isCrit = false
	local isMiss = false
	local isBlock = false
	local targets = {}
	local hasSelect = {}
	local pasHpPercent = self:getPasHpPercent()
	local tmpFragranceGetBuffs = {}

	for _, v in ipairs(self.isFragranceGet_) do
		table.insert(tmpFragranceGetBuffs, v)
	end

	xyd.Battle.puGongSkillTargets = {}
	xyd.Battle.puGongSkillHarms = {}
	xyd.Battle.puGongNormalSkillTargets = {}
	xyd.Battle.energySkillTargets = {}
	xyd.Battle.energySkillHarms = {}
	xyd.Battle.friendHurtTargets = {}
	xyd.Battle.normalSkillTargets = {}
	xyd.Battle.lastJumpTarget = nil

	for _, data in ipairs(datas) do
		local target = data.target

		if not target:isDeath() then
			if target:getTeamType() ~= self:getTeamType() and not data.isMiss then
				canRemp = true
			end

			isMiss = data.isMiss or isMiss
			isBlock = data.isBlock or isBlock
			local tmpHarm, tmpCure, tmpIsCrit, recordBuffs, tmpIsHarm, inHarmTargetList = target:applyBuffHarmsByTarget(data, unit)
			local hpPercent = target:getHp() / target:getHpLimit()
			totalHarm = totalHarm + (tmpHarm or 0)
			totalCure = totalCure + (tmpCure or 0)
			isCrit = tmpIsCrit or isCrit

			if isCrit then
				totalCritHarm = totalCritHarm + (tmpHarm or 0)
			end

			if not data.noTriggerPas and (tmpHarm or 0) > 0 and not hasSelect[target] and target:hasAttackedHurtSkill() then
				table.insert(targets, {
					target = target,
					type_ = xyd.TriggerType.SELF_ATTACKED
				})

				hasSelect[target] = true
			end

			if tmpIsCrit and not hasSelect[target] and target:hasCritedHurtSkill() then
				table.insert(targets, {
					target = target,
					type_ = xyd.TriggerType.SELF_CRITED
				})

				hasSelect[target] = true
			end

			if pasHpPercent and not target:isDeath() and target:getTeamType() ~= self:getTeamType() and hpPercent < pasHpPercent then
				if self:isPugongSkill(unit.skillID) then
					table.insert(xyd.Battle.puGongSkillTargets, target)

					xyd.Battle.puGongSkillHarms[target:getPos()] = tmpHarm or 0
				else
					table.insert(xyd.Battle.energySkillTargets, target)

					xyd.Battle.energySkillHarms[target:getPos()] = tmpHarm or 0
				end
			end

			if inHarmTargetList and tmpIsHarm and self:getTeamType() ~= target:getTeamType() and (not target:isDeath() or target.hasInfRevive_) then
				table.insert(xyd.Battle.friendHurtTargets, target)

				local evt = battle_event:instance()

				evt:emit(xyd.BATTLE_EVENT_NORMAL_OR_SKILL_ATTACKED, self, target, unit)

				if self:isPugongSkill(unit.skillID) then
					table.insert(xyd.Battle.puGongNormalSkillTargets, target)
				else
					table.insert(xyd.Battle.normalSkillTargets, target)
				end
			end
		end

		if self:getTeamType() ~= target:getTeamType() then
			xyd.Battle.lastJumpTarget = target
		end
	end

	self.addHurtTargets_ = targets

	self:recordData(totalHarm, totalCure)

	if canRemp and self:isPugongSkill(unit.skillID) then
		self:usePasSkill(xyd.TriggerType.SELF_PUGONG_BEFORE_ENERGY_CHANGE, unit)
		self:updateEnergyByAttack(unit)
	end

	self.curRoundTotalHarm_ = totalHarm
	self.curRoundTotalCritHarm_ = totalCritHarm
	unit.totalHarm_ = totalHarm
	unit.totalCritHarm_ = totalCritHarm

	if unit.fighter:getTeamType() == xyd.TeamType.A and (not xyd.Battle.purposes.maxUnitHarm or xyd.Battle.purposes.maxUnitHarm < unit.totalHarm_) then
		xyd.Battle.purposes.maxUnitHarm = unit.totalHarm_
	end

	self:triggerSelfInAction(unit, isCrit, isMiss, isBlock)
	self:checkHarmAfterRound(unit)

	xyd.Battle.attackNum = xyd.Battle.attackNum + 1

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			v:triggerOthersInAction(unit, totalHarm, totalCure, isCrit, isMiss, isBlock)
		end
	end

	if xyd.Battle.attackNum >= 10 then
		xyd.Battle.attackNum = 0
	end

	if totalHarm > 0 then
		self:usePasSkill(xyd.TriggerType.SELF_ATTACK_WITH_HARM, unit)

		if isCrit then
			self:usePasSkill(xyd.TriggerType.SELF_ATTACK_WITH_CRIT, unit)
		end
	end

	if xyd.Battle.god then
		xyd.Battle.god:triggerOthersInAction(unit, totalHarm, totalCure, isCrit, isMiss, isBlock)
	end

	if not self:isPet() then
		self:checkControlBuff(unit)
	end

	if xyd.Battle.god and xyd.Battle.isCure then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.CURE_LATER, unit)
	end

	self:checkCrystalPas(unit)
	self:countShareHarmBuffs(unit)
	self:calculateAllharmShare(unit)

	if #self.fenshen_ > 0 then
		for _, v in ipairs(self.fenshen_) do
			if not v:isDeath() then
				self:useFenShenPasSkill(v, xyd.TriggerType.MASTER_ATTACK, unit)
			end
		end
	end

	self:addExtraJumpSkill(unit, tmpFragranceGetBuffs)
	self:CKAtackOver(unit)

	if unit.skillID == self:getEnergySkillID() then
		self:usePasSkill(xyd.TriggerType.SELF_AFTER_SKILL_2, unit)
	end

	self:excuteBuffAfterAttack(unit)
	self:checkJustDieAndCleanDBuff(unit)
	self:checkCleanAllControlBuff(unit)

	xyd.Battle.isCure = false
end

function ReportBaseFighter:checkCrystalPas(unit)
	if xyd.Battle.isJustCrystal then
		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() then
				local isFriend = v:getTeamType() == self:getTeamType()

				if isFriend then
					v:usePasSkill(xyd.TriggerType.ENEMY_CRYSTAL, unit)
				end
			end
		end

		if xyd.Battle.god and self:getTeamType() == xyd.TeamType.B then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.FRIEND_CRYSTAL, unit)

			xyd.Battle.crystalTargets = {}
		end

		xyd.Battle.isJustCrystal = false
	end
end

function ReportBaseFighter:CKAtackOver(unit)
	local job = self:getJob()

	if job == xyd.HeroJob.CK then
		local friendTeam = self.selfTeam_

		for _, v in ipairs(friendTeam) do
			if not v:isDeath() and not v:isExile() then
				if xyd.Battle.ckAttackRound[self:getTeamType()] ~= xyd.Battle.round then
					v:usePasSkill(xyd.TriggerType.SELF_TEAM_CK_ATTACK_FIRST_TIME, unit)
				end

				v:usePasSkill(xyd.TriggerType.SELF_TEAM_CK_ATTACK, unit)
			end
		end

		xyd.Battle.ckAttackRound[self:getTeamType()] = xyd.Battle.round
	end
end

function ReportBaseFighter:countShareHarmBuffs(unit)
	if #xyd.Battle.shareHarmBuffs <= 0 then
		return
	end

	local buffs = xyd.Battle.shareHarmBuffs

	self:harmShareCalculate(unit, buffs)

	xyd.Battle.shareHarmBuffs = {}
end

function ReportBaseFighter:calculateAllharmShare(unit)
	if #xyd.Battle.allHarmShareBuffs <= 0 then
		return
	end

	local buffs = xyd.Battle.allHarmShareBuffs

	self:harmShareCalculate(unit, buffs)

	xyd.Battle.allHarmShareBuffs = {}
end

function ReportBaseFighter:harmShareCalculate(unit, buffs)
	local recordBuffs = {}
	local targets = {}

	for _, buff in ipairs(buffs) do
		local target = buff.target
		local num = buff:getFinalNum()

		if target and not target:isDeath() then
			target:updateHpByHarm(num, unit, false, false, false, buff)
			buff:writeRecord(target, xyd.BUFF_WORK)
			table.insert(recordBuffs, buff)
			table.insert(targets, target)

			if buff.fighter then
				buff.fighter:recordData(-num, 0)
			end

			if target:isFreeHarm() and num < 0 then
				target:delFreeHarmBuffCount(recordBuffs, unit)
			end
		end
	end

	unit:recordPasBuffs(nil, recordBuffs)

	for _, target in ipairs(targets) do
		if not target:isDeath() then
			target:checkHpPasSkill(unit)
		end
	end
end

function ReportBaseFighter:addExtraJumpSkill(unit, tmpFragranceGetBuffs)
	if #self.commonExHurtBuffs_ > 0 then
		local lastJumpSkillID = nil

		for key, commonExHurtBuff in ipairs(self.commonExHurtBuffs_) do
			lastJumpSkillID = commonExHurtBuff:getFinalNum()
			local ifNoPas = true
			local curUnit = self:useOneJumpSkill(nil, commonExHurtBuff:getFinalNum(), unit, ifNoPas, false)

			commonExHurtBuff:writeRecord(nil, xyd.BUFF_OFF)
		end

		unit:recordBuffs(self, self.commonExHurtBuffs_)
		self:removeBuffs(self.commonExHurtBuffs_)

		if lastJumpSkillID and self:isAddHurtCostEnergy(lastJumpSkillID) then
			self:updateEnergy(0, unit)
		end
	end

	local sunArrowBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_SUN_ARROW)

	if sunArrowBuffs and next(sunArrowBuffs) then
		local num = 1

		for _, sunArrowBuff in ipairs(sunArrowBuffs) do
			if sunArrowBuff:canAttack() then
				local ifNoBlock = true

				if num == 1 then
					ifNoBlock = false
				end

				num = num + 1
				local lastJumpSkillID = sunArrowBuff:getFinalNum()
				local ifNoPas = true
				local curUnit = self:useOneJumpSkill(nil, lastJumpSkillID, unit, ifNoPas, ifNoBlock)
			end
		end
	end

	if unit.skillID == self:getEnergySkillID() then
		if #self.aggressions_ > 0 then
			for key, aggressionBuff in ipairs(self.aggressions_) do
				local ifNoBlock = true

				if key == 1 then
					ifNoBlock = false
				end

				local curUnit = self:useOneJumpPasSkill(nil, aggressionBuff:getFinalNum(), unit, false, ifNoBlock)

				aggressionBuff:writeRecord(nil, xyd.BUFF_OFF)
			end

			unit:recordBuffs(self, self.aggressions_)
			self:removeBuffs(self.aggressions_)
		end

		if #tmpFragranceGetBuffs > 0 and #self.isFragranceAtk_ > 0 then
			local tmpRecordBuffs = {}
			local skillID = self.isFragranceAtk_[1]:getFinalNum()

			for key, fragranceGetBuff in ipairs(tmpFragranceGetBuffs) do
				local ifNoBlock = true

				if key == 1 then
					ifNoBlock = false
				end

				local curUnit = self:useOneJumpPasSkill(nil, skillID, unit, false, ifNoBlock)

				fragranceGetBuff:writeRecord(nil, xyd.BUFF_OFF)
				table.insert(tmpRecordBuffs, fragranceGetBuff)
			end

			for _, fragranceDecDmgBuff in ipairs(self.isFragranceDecDmg_) do
				fragranceDecDmgBuff:writeRecord(nil, xyd.BUFF_OFF)
				table.insert(tmpRecordBuffs, fragranceDecDmgBuff)
			end

			unit:recordBuffs(self, tmpRecordBuffs)
			self:removeBuffs(tmpFragranceGetBuffs)
			self:removeBuffs(self.isFragranceDecDmg_)
		end

		self:removeBuffs(self.isFragranceAtk_)

		if #self.isMarkHurtSkillLB_ > 0 and #xyd.Battle.energySkillTargets > 0 then
			for _, markSkill in ipairs(self.isMarkHurtSkillLB_) do
				local curUnit = self:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)

				markSkill:writeRecord(nil, xyd.BUFF_OFF)
			end

			unit:recordBuffs(self, self.isMarkHurtSkillLB_)
			self:removeBuffs(self.isMarkHurtSkillLB_)
		end

		if #self.isAtkRandomTime_ > 0 and #xyd.Battle.normalSkillTargets > 0 then
			local lastJumpSkillID = nil
			local markSkill = self.isAtkRandomTime_[1]
			local times = markSkill:getFinalNum()
			local extraSkillID = self:getEnergySubSkill()[1]
			lastJumpSkillID = extraSkillID

			for i = 1, times do
				if self:canAttack() then
					local ifNoBlock = false
					local curUnit = self:useOneJumpPasSkill(nil, extraSkillID, unit, false, ifNoBlock)
				end
			end

			markSkill:writeRecord(nil, xyd.BUFF_OFF)
			unit:recordBuffs(self, self.isAtkRandomTime_)
			self:removeBuffs(self.isAtkRandomTime_)

			if lastJumpSkillID and self:isAddHurtCostEnergy(lastJumpSkillID) then
				self:updateEnergy(0, unit)
			end
		end

		local nuolisiAddBuff = self:getBuffByName(xyd.BUFF_NUOLISI_ADD_RATE)

		if nuolisiAddBuff then
			nuolisiAddBuff:addExtraJumpSkill(unit)
		end

		local luobiPreCombolBuff = self:getBuffByName(xyd.BUFF_LUOBI_PRE_COMBOL)

		if luobiPreCombolBuff then
			luobiPreCombolBuff:addExtraJumpSkill(unit)
		end

		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() and v:canAttack() and v:getTeamType() == self:getTeamType() and #v.isMarkAddHurt_ > 0 then
				for _, markSkill in ipairs(v.isMarkAddHurt_) do
					local curUnit = v:canAttack() and v:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)

					markSkill:writeRecord(nil, xyd.BUFF_OFF)
				end

				unit:recordBuffs(v, v.isMarkAddHurt_)
				v:removeBuffs(v.isMarkAddHurt_)
			end
		end
	else
		if #self.isMarkHurtPasLB > 0 and #xyd.Battle.puGongSkillTargets > 0 then
			for _, markSkill in ipairs(self.isMarkHurtPasLB) do
				local curUnit = self:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)

				markSkill:writeRecord(nil, xyd.BUFF_OFF)
			end

			unit:recordBuffs(self, self.isMarkHurtPasLB)
			self:removeBuffs(self.isMarkHurtPasLB)
		end

		if #self.isMarkApate_ > 0 and #xyd.Battle.puGongNormalSkillTargets > 0 then
			for _, markSkill in ipairs(self.isMarkApate_) do
				local curUnit = self:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)

				markSkill:writeRecord(nil, xyd.BUFF_OFF)
			end

			unit:recordBuffs(self, self.isMarkApate_)
			self:removeBuffs(self.isMarkApate_)
		end
	end

	if #self.isMarkAddHurtFreeArm_ > 0 then
		local markSkill = self.isMarkAddHurtFreeArm_[1]
		local curUnit = self:canAttack() and self:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)

		markSkill:writeRecord(nil, xyd.BUFF_OFF)
		unit:recordBuffs(self, self.isMarkAddHurtFreeArm_)
		self:removeBuffs(self.isMarkAddHurtFreeArm_, nil, unit)
	end

	if #xyd.Battle.friendHurtTargets > 0 then
		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() and v:canAttack() and v:getTeamType() == self:getTeamType() and #v.isMarkFriendHurtLB_ > 0 and #xyd.Battle.friendHurtTargets > 0 then
				for _, markSkill in ipairs(v.isMarkFriendHurtLB_) do
					if _ == 1 then
						v:useOneJumpPasSkill(nil, markSkill:getFinalNum(), unit)
					end

					markSkill:writeRecord(nil, xyd.BUFF_OFF)
				end

				unit:recordBuffs(v, v.isMarkFriendHurtLB_)
				v:removeBuffs(v.isMarkFriendHurtLB_)
			end
		end
	end
end

function ReportBaseFighter:checkCleanAllControlBuff(unit)
	local recordBuffs = {}

	for _, v in ipairs(xyd.Battle.team) do
		if v and not v:isDeath() and v:isRemoveControl() then
			v:cleanAllControlBuffs(unit, recordBuffs)
			v:removeBuffs(v.isRemoveControl_)
			unit:recordPasBuffs(v, recordBuffs)

			recordBuffs = {}
		end
	end
end

function ReportBaseFighter:checkJustDieAndCleanDBuff(unit)
	local datas = unit:getUnitDatas()
	local recordBuffs = {}

	for _, data in ipairs(datas) do
		local target = data.target

		if target and target:ifJustReviveFromInf() then
			target:cleanAllDebuff(unit, recordBuffs)
			target:setJustReviveFromInf(false)
			unit:recordBuffs(target, recordBuffs)

			recordBuffs = {}
		end
	end
end

function ReportBaseFighter:checkExEnergyHurt(unit)
	local buff = self:getBuffByName(xyd.BUFF_FREE_SKILL)

	if buff then
		if self.isEnergyQueue_ == false then
			table.insert(xyd.Battle.passiveQueue, self)

			self.isEnergyQueue_ = true
		else
			self.isEnergyQueue_ = false
		end
	else
		self.isEnergyQueue_ = false

		self:removeBuffs({
			buff
		})
	end

	return false
end

function ReportBaseFighter:checkExHurt(unit)
	local buff = self:getBuffByName(xyd.BUFF_EX_HURT)

	if buff then
		self:removeBuffs({
			buff
		})

		if not self.isPassiveQuene_ then
			table.insert(xyd.Battle.passiveQueue, self)

			self.isPassiveQuene_ = true
		else
			self.isPassiveQuene_ = false
		end
	else
		self.isPassiveQuene_ = false
	end
end

function ReportBaseFighter:checkNewRound(unit)
	if self:getBuffByName(xyd.BUFF_NEW_ROUND) then
		local hasDieA = false
		local hasDieB = false

		for _, v in ipairs(xyd.Battle.curRoundDie) do
			if v:getTeamType() == xyd.TeamType.A then
				hasDieA = true
			else
				hasDieB = true
			end
		end

		if self:getTeamType() == xyd.TeamType.A and hasDieB or self:getTeamType() == xyd.TeamType.B and hasDieA then
			table.insert(xyd.Battle.passiveQueue, self)
		end

		self:removeBuffByName(xyd.BUFF_NEW_ROUND)
	end

	local enemy = self:enemyHasBuff(unit, xyd.BUFF_ATK_D)

	if enemy then
		xyd.Battle.atkDTarget = enemy
		xyd.Battle.atkDFlag = true
		local buff = enemy:getBuffByName(xyd.BUFF_ATK_D)
		local num = buff:getFinalNum()
		local fighters = GetTarget_.S32(enemy, num)

		for _, fighter in ipairs(fighters) do
			table.insert(xyd.Battle.passiveQueue, fighter)
		end

		enemy:removeBuffByName(xyd.BUFF_ATK_D)
	end
end

function ReportBaseFighter:enemyHasBuff(unit, buffName)
	local datas = unit:getUnitDatas()

	for _, data in ipairs(datas) do
		if data.target:getBuffByName(buffName) then
			return data.target
		end
	end
end

function ReportBaseFighter:hasAttackedHurtSkill()
	local skillIDs = self:getPasSkillByType(xyd.TriggerType.SELF_ATTACKED)

	return #skillIDs > 0
end

function ReportBaseFighter:hasCritedHurtSkill()
	local skillIDs = self:getPasSkillByType(xyd.TriggerType.SELF_CRITED)

	return #skillIDs > 0
end

function ReportBaseFighter:checkCanAddHurt(effectID, target, fighter)
	local flag = false

	if not target:canAttack() then
		return flag
	end

	if target:isSeal() then
		return flag
	end

	if target:isForceSeal() then
		return flag
	end

	if EffectTable:buff(effectID) == "addHurtd" and fighter:getHujia() < target:getHujia() or EffectTable:buff(effectID) == xyd.BUFF_ADD_HURT then
		flag = true
	end

	return flag
end

function ReportBaseFighter:addHurt(targets, unit)
	table.sort(targets, function (a, b)
		if a.target:getPos() ~= b.target:getPos() then
			return a.target:getPos() < b.target:getPos()
		end
	end)

	for _, item in ipairs(targets) do
		local target = item.target
		local type_ = item.type_

		if not target:isDeath() then
			local skillIDs = target:getPasSkillByType(type_)
			skillIDs = self:sortAddHurtSkills(skillIDs)

			for _, skillID in ipairs(skillIDs) do
				local effects = SkillTable:getEffect(skillID, 1)
				local flag = false
				local isJump = SkillTable:jump(skillID)

				if isJump >= 1 then
					for _, id in ipairs(effects) do
						if self:checkCanAddHurt(id, target, unit.fighter) then
							flag = true

							break
						end
					end
				end

				if flag then
					local curUnit = target:useOneJumpPasSkill(type_, skillID, unit)
				end
			end
		end
	end
end

function ReportBaseFighter:sortAddHurtSkills(skillIDs)
	local tmpIDs = {}
	local jumpIDs = {}

	for _, skillID in ipairs(skillIDs) do
		local isJump = SkillTable:jump(skillID)

		if isJump >= 1 then
			table.insert(jumpIDs, skillID)
		else
			table.insert(tmpIDs, skillID)
		end
	end

	tmpIDs = xyd.arrayMerge(tmpIDs, jumpIDs)

	return tmpIDs
end

function ReportBaseFighter:checkSelfDie(unit, harmBuff)
	if self:isDeath() and self:getDieRound() == 0 then
		self:die(unit, harmBuff)
	end
end

function ReportBaseFighter:applySpecialUnit(unit)
	local datas = unit:getUnitDatas()
	local isAttackMiss = true

	for _, data in ipairs(datas) do
		local target = data.target
		local harm, cure, isCrit, recordBuffs, isHarm = target:applyBuffHarmsByTarget(data, unit)

		if #recordBuffs > 0 then
			isAttackMiss = false
		end

		if not data.isMiss then
			self:recordData(harm, cure)
		end
	end

	return isAttackMiss
end

function ReportBaseFighter:applyBuffHarmsByTarget(data, unit, noRecord)
	local fighter = unit.fighter
	local isMiss = data.isMiss
	local isBlock = data.isBlock
	local hitBuffs = data.hitBuffs
	local missBuffs = data.missBuffs
	local inHarmTargetList = true
	local noTriggerPas = data.noTriggerPas
	local isDead = self:isDeath()

	if isBlock then
		self:usePasSkill(xyd.TriggerType.SELF_SHANBI, unit)
	end

	local harm, cure, recordBuffs, status, inHarmTargetList = self:applyBuffHarm(unit, hitBuffs, noRecord)

	if self:isDeath() then
		if not isDead then
			fighter:usePasSkill(xyd.TriggerType.SELF_KILL_ENEMY, unit)
			fighter:usePasSkill(xyd.TriggerType.FIRST_SELF_KILL_ENEMY, unit)
		end
	else
		if harm > 0 then
			unit.totalPosHarm_[self:getPos()] = unit.totalPosHarm_[self:getPos()] + harm

			if not noTriggerPas then
				xyd.Battle.lastAttacker = fighter

				self:usePasSkill(xyd.TriggerType.SELF_ATTACKED, unit)
			end

			if self:isGetThorns() then
				self:usePasSkill(xyd.TriggerType.SELF_ATTACKED_WITH_THORNS, unit)
			end

			if fighter and unit.skillID == fighter:getEnergySkillID() and not fighter:isPet() then
				self:usePasSkill(xyd.TriggerType.SELF_ATTACKED_SKILL_H, unit)
			end
		end

		if status.isCrit then
			self:usePasSkill(xyd.TriggerType.SELF_CRITED, unit)
		end

		if status.isControl then
			self:usePasSkill(xyd.TriggerType.SELF_CONTROLED, unit)

			local isEnemy = self:getTeamType() == xyd.TeamType.B

			if isEnemy then
				xyd.Battle.enemyControlTimes = xyd.Battle.enemyControlTimes + 1

				if xyd.Battle.god and xyd.Battle.enemyControlTimes == 6 then
					xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_CONTROLED_6, unit)
				end
			else
				xyd.Battle.selfControlTimes = xyd.Battle.selfControlTimes + 1
			end
		end

		if status.isBlock then
			self:usePasSkill(xyd.TriggerType.SELF_BLOCK, unit)

			self.blockTimes_ = self.blockTimes_ + 1

			if self.blockTimes_ == 3 then
				self:usePasSkill(xyd.TriggerType.BLOCK_THREE_TIMES, unit)

				self.blockTimes_ = 0
			end
		end

		self:checkHpPasSkill(unit)
	end

	self:checkStatusSkill(unit, status)

	return harm, cure, status.isCrit, recordBuffs, status.isHarm, inHarmTargetList
end

function ReportBaseFighter:checkStatusSkill(unit, status)
	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local vIsFriend = v:getTeamType() == self:getTeamType()

			if status.isIce and not vIsFriend then
				v:usePasSkill(xyd.TriggerType.ENEMY_ICE, unit)
			end

			if status.isStone and not vIsFriend then
				v:usePasSkill(xyd.TriggerType.ENEMY_STONE, unit)
			end

			if status.isBlood and not vIsFriend then
				v:usePasSkill(xyd.TriggerType.ENEMY_BLOOD, unit)
			end

			if status.isStun then
				v:usePasSkill(xyd.TriggerType.STUN, unit)
			end

			if status.isFire then
				xyd.Battle.fireTarget = self

				if vIsFriend then
					v:usePasSkill(xyd.TriggerType.FRIEND_BURNT, unit)
				else
					v:usePasSkill(xyd.TriggerType.ENEMY_BURNT, unit)
				end
			end

			if status.isFrighten and not vIsFriend then
				v:usePasSkill(xyd.TriggerType.ENEMY_FRIGHTEN, unit)
			end

			if status.isCrystall then
				xyd.Battle.isJustCrystal = true
			end

			if status.isControl then
				if not vIsFriend then
					v:usePasSkill(xyd.TriggerType.ENEMY_CONTROLED, unit)
				else
					local job = self:getJob()

					if job == xyd.HeroJob.YX then
						v:usePasSkill(xyd.TriggerType.SELF_TEAM_YX_CONTROLLED, unit)
					end
				end
			end

			if status.hasDebuff then
				local job = self:getJob()

				if vIsFriend and job == xyd.HeroJob.YX then
					v:usePasSkill(xyd.TriggerType.SELF_TEAM_YX_DEBUFF, unit)
				end
			end

			if status.isDot then
				v:usePasSkill(xyd.TriggerType.DOT, unit)
			end
		end
	end

	xyd.Battle.bloodTargets = {}

	if xyd.Battle.god then
		if self:getTeamType() == xyd.TeamType.B and status.isControl then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_CONTROLED, unit)
		end

		if self:getTeamType() == xyd.TeamType.A and status.isFire then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.FRIEND_BURNT, unit)
		end

		if status.isStun then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.STUN, unit)
		end
	end
end

function ReportBaseFighter:checkHpPasSkill(unit)
	if self:isPet() then
		return
	end

	local skillID = unit.skillID
	local fighter = unit.fighter
	local isPugongSkill = false
	local isEnergySkill = false
	local isFriend = false

	if fighter and fighter.hero_ ~= nil and skillID then
		isPugongSkill = fighter:isPugongSkill(skillID)
		isEnergySkill = skillID == fighter:getEnergySkillID()
		isFriend = fighter:getTeamType() == self:getTeamType()
	end

	local percent = self:getHp() / self:getHpLimit()

	if percent < 0.8 and self.maxHpP_ >= 0.8 * xyd.PERCENT_BASE then
		self:usePasSkill(xyd.TriggerType.SELF_HP_LESS_80, unit)
	end

	if percent < 0.5 and self.maxHpP_ >= 0.5 * xyd.PERCENT_BASE then
		self:usePasSkill(xyd.TriggerType.SELF_HP_LESS_50, unit)
	end

	if percent < 0.5 and self.maxHpP_ >= 0.5 * xyd.PERCENT_BASE and (isEnergySkill or isPugongSkill) and not isFriend then
		self:usePasSkill(xyd.TriggerType.XIFENG_HP_LESS_50, unit)
	end

	if percent < 0.3 and self.maxHpP_ >= 0.3 * xyd.PERCENT_BASE then
		self:usePasSkill(xyd.TriggerType.SELF_HP_LESS_30, unit)

		if not self.isUnder30PerHP then
			self.isUnder30PerHP = true

			self:usePasSkill(xyd.TriggerType.SELF_HP_LESS_30_UNLIMIT, unit)
		end
	else
		self.isUnder30PerHP = false
	end

	if xyd.Battle.god and percent < 0.5 and not self.isFirstLow50_ and self:getTeamType() == xyd.TeamType.B then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_HP_LESS_50_FIRST, unit)
	end
end

function ReportBaseFighter:recordRoundHarm(pos, harm)
	if not self.roundHarm[xyd.Battle.round] then
		self.roundHarm[xyd.Battle.round] = harm
	else
		self.roundHarm[xyd.Battle.round] = self.roundHarm[xyd.Battle.round] + harm
	end

	xyd.Battle.roundHarm[pos] = (xyd.Battle.roundHarm[pos] or 0) + harm
end

function ReportBaseFighter:checkHarmAfterRound(unit)
	if self:isPet() or self:isGod() then
		return
	end

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() and v:getTeamType() ~= self:getTeamType() and xyd.Battle.roundHarm[v:getPos()] then
			local delHpP = xyd.Battle.roundHarm[v:getPos()] / v:getHpLimit()

			if delHpP >= 0.5 then
				v:usePasSkill(xyd.TriggerType.SELF_ATTACKED_HP_MORE_50, unit)
			else
				v:usePasSkill(xyd.TriggerType.SELF_ATTACKED_HP_LESS_50, unit)
			end
		end
	end

	local hasReflected = {}
	local datas = unit:getUnitDatas()

	for _, data in ipairs(datas) do
		local target = data.target

		if target:getTeamType() ~= self:getTeamType() then
			if xyd.Battle.roundHarm[target:getPos()] then
				if not target:isDeath() then
					if target:getHp() / target:getHpLimit() > 0.5 and target.atkedMore50 ~= xyd.Battle.round then
						target.atkedMore50 = xyd.Battle.round

						target:usePasSkill(xyd.TriggerType.SELF_ATTACKED_AFTER_HP_MORE_50, unit)
					elseif target:getHp() / target:getHpLimit() <= 0.5 and target.atkedLess50 ~= xyd.Battle.round then
						target.atkedLess50 = xyd.Battle.round

						target:usePasSkill(xyd.TriggerType.SELF_ATTACKED_AFTER_HP_LESS_50, unit)
					end

					if not hasReflected[target:getPos()] and target:isReflect() and not target:isSeal() and not target:isForceSeal() then
						local delBuff = target.isReflect_[1]

						delBuff:writeRecord(nil, xyd.BUFF_REMOVE)
						unit:recordBuffs(self, {
							delBuff
						})
						target:removeBuffs({
							delBuff
						}, nil, unit)
						target:usePasSkill(xyd.TriggerType.SELF_ATTACKED_WITH_REFLECT, unit)

						hasReflected[target:getPos()] = true
					end
				end

				local job = target:getJob()
				local jobStr = xyd.HeroJobStr[tonumber(job)]
				local targetFriends = target.selfTeam_

				for _, v in ipairs(targetFriends) do
					if not v:isDeath() and jobStr then
						v:usePasSkill(xyd.TriggerType["SELF_TEAM_" .. jobStr .. "_ATTACKED"], unit)
					end
				end
			end

			if not hasReflected[target:getPos()] and target:isRoundReflect() then
				target:usePasSkill(xyd.TriggerType.SELF_ROUND_REFLECT_ATTACKED, unit)

				hasReflected[target:getPos()] = true
			end
		end
	end

	xyd.Battle.roundHarm = {}
end

function ReportBaseFighter:die(unit, harmBuff)
	self.dieRoundWithReborn_ = xyd.Battle.round
	self.killer = unit.fighter

	if harmBuff then
		self.killer = harmBuff.fighter
	end

	if self:isEat() then
		self:removeBuffs(self.buffs_, {
			xyd.BUFF_EAT
		})
		self:removeGlobalBuffs()
		table.insert(xyd.Battle.curRoundDie, self)

		self.dieRound_ = xyd.Battle.round
		self.energy_ = 0

		self:setUnitPosEp()

		return
	end

	if self:hasRebornInf() then
		self.infRebornTimes_ = self.infRebornTimes_ + 1

		self:setHp(1)
		self:usePasSkill(xyd.TriggerType.SELF_DIE, unit)
		self:updateInfRebornBuff(unit)

		if self.infRebornMaxTimes_ ~= -1 and self.infRebornMaxTimes_ < self.infRebornTimes_ then
			self.hasReviveMaxTime_ = true
		end

		return
	end

	self.enemyDieNum_ = 0

	self:usePasSkill(xyd.TriggerType.SELF_DIE, unit)

	local evt = battle_event:instance()

	evt:emit(xyd.BATTLE_EVENT_DIE, unit, self)

	unit.dieTarget = self

	for _, v in ipairs(xyd.Battle.team) do
		if v ~= self and not v:isDeath() then
			if v:getTeamType() == self:getTeamType() then
				v:usePasSkill(xyd.TriggerType.FRIEND_DIE, unit)
				v:removeXifengSpdWhenXifengDie(self, unit)
			else
				v:usePasSkill(xyd.TriggerType.ENEMY_DIE, unit)

				v.enemyDieNum_ = v.enemyDieNum_ + 1

				if v.enemyDieNum_ % 2 == 0 then
					v:usePasSkill(xyd.TriggerType.ENEMY_DIE_2, unit)
				end

				v:removeStarMoonWhenWeiWeiAnDie(self, unit)
			end

			v:usePasSkill(xyd.TriggerType.DIE, unit)
		end
	end

	if xyd.Battle.god and self:getTeamType() == xyd.TeamType.B then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_DIE, unit)

		xyd.Battle.god.enemyDieNum_ = xyd.Battle.god.enemyDieNum_ + 1

		if xyd.Battle.god.enemyDieNum_ % 2 == 0 then
			xyd.Battle.god:usePasSkill(xyd.TriggerType.ENEMY_DIE_2, unit)
		end
	end

	for _, v in ipairs(xyd.Battle.team) do
		if v ~= self and next(v.isApateRevive_) then
			for i, buff in ipairs(v.isApateRevive_) do
				buff.delayNum_ = buff.delayNum_ - 1

				buff:setRecordNum(buff.delayNum_)
				buff:writeRecord(v, xyd.BUFF_WORK)
			end

			unit:recordPasBuffs(v, v.isApateRevive_)
		end
	end

	local xifengHealTarget = nil

	if next(self.isReduceSpd_) then
		xifengHealTarget = GetTarget_.S14(self)[1]
	end

	if xifengHealTarget ~= nil then
		for _, buff in ipairs(self.isReduceSpd_) do
			local healPEffectID = buff:getFinalNum(2)
			local healBuff = BuffManager:newBuff({
				effectID = healPEffectID,
				skillID = buff.skillID,
				target = xifengHealTarget,
				fighter = buff.fighter
			})

			healBuff:calculate()

			local num = healBuff:getFinalNum()
			num = num * healBuff.target:getExtraHealRate()
			num = healBuff.target:blockHeal(num, unit, healBuff)

			healBuff.target:updateHpByHeal(num, unit)
			healBuff:setRecordNum(num)
			healBuff.fighter:recordData(0, num)
			healBuff:writeRecord(xifengHealTarget, xyd.BUFF_WORK)
			unit:recordPasBuffs(xifengHealTarget, {
				healBuff
			})
		end
	end

	local spdExchangeBuff = self:getBuffByName(xyd.BUFF_EXCHANGE_SPD)

	if spdExchangeBuff ~= nil then
		local target = spdExchangeBuff.target

		for i = #target.buffs_, 1, -1 do
			local theBuff = target.buffs_[i]

			if theBuff.target == self and theBuff.name_ == xyd.BUFF_EXCHANGE_SPD then
				theBuff:writeRecord(target, xyd.BUFF_REMOVE)
				target:removeBuffs({
					target.buffs_[i]
				})
				unit:recordPasBuffs(target, {
					theBuff
				})
			end
		end
	end

	self:removeBuffs(self.buffs_, {
		xyd.BUFF_REVIVE,
		xyd.BUFF_APATE_REVIVE,
		xyd.BUFF_YUJI_UNLIMITED_REVIVE
	})
	self:removeGlobalBuffs()
	table.insert(xyd.Battle.curRoundDie, self)

	self.dieRound_ = xyd.Battle.round
	self.energy_ = 0

	self:setUnitPosEp()
end

function ReportBaseFighter:removeXifengSpdWhenXifengDie(dieFighter, unit)
	local needRemove = {}
	local needRecord = {}

	if dieFighter.hero_ and xyd.arrayIndexOf({
		53014,
		653021,
		753014
	}, dieFighter:getHeroTableID()) > 0 and next(self.isXifengSpd_) then
		for _, buff in ipairs(self.isXifengSpd_) do
			if buff.fighter == dieFighter then
				table.insert(needRemove, buff)
				table.insert(needRecord, buff)
				buff:writeRecord(self, xyd.BUFF_REMOVE)
			end
		end
	end

	unit:recordPasBuffs(self, needRecord)
	self:removeBuffs(needRemove)
end

function ReportBaseFighter:removeStarMoonWhenWeiWeiAnDie(dieFighter, unit)
	local needRemove = {}
	local needRecord = {}

	if dieFighter.hero_ and xyd.arrayIndexOf({
		51013,
		651020,
		751013
	}, dieFighter:getHeroTableID()) > 0 and self:isStarMoon() then
		for _, buff in ipairs(self.isStarMoon_) do
			if buff.fighter == dieFighter then
				table.insert(needRemove, buff)
				table.insert(needRecord, buff)
				buff:writeRecord(self, xyd.BUFF_REMOVE)
			end
		end
	end

	unit:recordPasBuffs(self, needRecord)
	self:removeBuffs(needRemove)
end

function ReportBaseFighter:getDieRound()
	return self.dieRound_
end

function ReportBaseFighter:getLoseSealHp()
	local loseHp = 0
	local hpLoseSeals = self:getBuffsByNameAndFighter(xyd.BUFF_HP_LOSE_SEAL)

	if next(hpLoseSeals) then
		loseHp = hpLoseSeals[1].loseHp
	end

	local mayaHpLoseSeals = self:getBuffsByNameAndFighter(xyd.BUFF_MAYA_HP_LOSE_SEAL)

	if next(mayaHpLoseSeals) then
		local mayaHpPercent = 0

		for k, v in ipairs(mayaHpLoseSeals) do
			mayaHpPercent = mayaHpPercent + v.finalNumArray_[1]
		end

		if mayaHpLoseSeals[1].finalNumArray_[2] < mayaHpPercent then
			mayaHpPercent = mayaHpLoseSeals[1].finalNumArray_[2]
		end

		loseHp = loseHp + mayaHpPercent * self:getHpLimit()
	end

	return loseHp
end

function ReportBaseFighter:blockHeal(num, unit, buff)
	local recordBuffs = {}

	local function saveAndDelBuff(buff, on)
		buff:writeRecord(self, on)
		table.insert(recordBuffs, buff)
	end

	local loseHp = self:getLoseSealHp()

	if loseHp > 0 and self:getHp() + num > self:getHpLimit() - self:getLoseSealHp() then
		num = self:getHpLimit() - self:getLoseSealHp() - self:getHp()

		if num < 0 then
			num = 0
		end
	end

	local result = num

	if buff and buff.fighter and not buff.fighter:isPet() and result > 0 then
		if self.blockHealUnit == nil or self.blockHealUnit ~= unit then
			if self:isGetHealCurse() then
				local delBuff = self.isGetHealCurse_[1]
				local params = {
					effectID = delBuff:getFinalNum(),
					fighter = delBuff.fighter,
					target = self
				}
				local newBuff = BuffManager:newBuff(params)
				local addHarmRate = 1 + self:getExtraHarmRate(unit, true)
				newBuff.isHit_ = 1

				newBuff:calculate()

				newBuff.finalNum_ = -newBuff.finalNum_ * num * addHarmRate
				newBuff.finalNum_ = self:getShieldHarm(newBuff.finalNum_, unit, false, false, delBuff.fighter, true)

				self:updateHpByHarm(newBuff.finalNum_, unit, false, false, false, newBuff)
				delBuff.fighter:recordData(-newBuff.finalNum_, 0)
				saveAndDelBuff(newBuff, xyd.BUFF_WORK)
				saveAndDelBuff(delBuff, xyd.BUFF_OFF)

				local cleanBuffs = self:getBuffByName(xyd.BUFF_HEAL_CURSE_CLEAN_HURT)

				if cleanBuffs then
					local params2 = {
						effectID = cleanBuffs.finalNum_,
						fighter = delBuff.fighter,
						target = self
					}
					local newBuff2 = BuffManager:newBuff(params2)
					newBuff2.isHit_ = 1

					newBuff2:calculate()
					self:updateHpByHarm(newBuff2.finalNum_, unit, false, false, false, newBuff2)
					delBuff.fighter:recordData(-newBuff2.finalNum_, 0)
					saveAndDelBuff(newBuff2, xyd.BUFF_WORK)
				end

				self:removeBuffs({
					delBuff
				})

				result = 0

				if self:isFreeHarm() and newBuff.finalNum_ < 0 then
					self:delFreeHarmBuffCount(recordBuffs, unit)
				end

				self.blockHealUnit = unit
				self.blockHealBuff = newBuff
			end
		else
			local params = {
				effectID = self.blockHealBuff.effectID,
				fighter = self.blockHealBuff.fighter,
				target = self.blockHealBuff.target
			}
			local newBuff = BuffManager:newBuff(params)
			local addHarmRate = 1 + self:getExtraHarmRate(unit, true)
			newBuff.isHit_ = 1

			newBuff:calculate()

			newBuff.finalNum_ = -newBuff.finalNum_ * num * addHarmRate
			newBuff.finalNum_ = self:getShieldHarm(newBuff.finalNum_, unit, false, false, self.blockHealBuff.target, true)

			self:updateHpByHarm(newBuff.finalNum_, unit, false, false, false, newBuff)
			saveAndDelBuff(newBuff, xyd.BUFF_WORK)

			result = 0

			if self:isFreeHarm() and newBuff.finalNum_ < 0 then
				self:delFreeHarmBuffCount(recordBuffs, unit)
			end
		end
	end

	unit:recordBuffs(self, recordBuffs)

	return result
end

function ReportBaseFighter:getShieldHarm(num, unit, isRate, isImpress, buffFighter, isHealCurse, buff)
	local result = num
	local needRecordBuffs = {}
	local needRemoveBuffs = {}
	local absorbFixDamageBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_ABSORB_FIX_DAMAGE)

	if result < 0 and absorbFixDamageBuffs and #absorbFixDamageBuffs > 0 and not isHealCurse then
		local abBuff = absorbFixDamageBuffs[1]
		local absorbDamageNum = abBuff:getFinalNum()

		if absorbDamageNum < math_abs(result) then
			abBuff:writeRecord(nil, xyd.BUFF_OFF)
			table.insert(needRecordBuffs, abBuff)
			table.insert(needRemoveBuffs, abBuff)
		else
			abBuff:updateFinalNum(absorbDamageNum + result)
		end

		result = math.min(0, absorbDamageNum + result)
	end

	if not isRate then
		if result < 0 and self:isHurtShieldLimit1() and not isHealCurse then
			local tmpBuff = self.isHurtShieldLimit1_[1]
			result = math.min(0, self:getHpLimit() * tmpBuff:getFinalNum() + result)

			tmpBuff:writeRecord(nil, xyd.BUFF_OFF)
			table.insert(needRecordBuffs, tmpBuff)
			table.insert(needRemoveBuffs, tmpBuff)
		end

		if result < 0 and self:isHurtShieldLimit2() and not isHealCurse then
			local tmpBuff = self.isHurtShieldLimit2_[1]
			result = math.min(0, self:getHpLimit() * tmpBuff:getFinalNum() + result)

			tmpBuff:writeRecord(nil, xyd.BUFF_OFF)
			table.insert(needRecordBuffs, tmpBuff)
			table.insert(needRemoveBuffs, tmpBuff)
		end

		if result < 0 and self:isHurtShieldLimit3() and not isHealCurse then
			local tmpBuff = self.isHurtShieldLimit3_[1]
			result = math.min(0, self:getHpLimit() * tmpBuff:getFinalNum() + result)

			tmpBuff:writeRecord(nil, xyd.BUFF_OFF)
			table.insert(needRecordBuffs, tmpBuff)
			table.insert(needRemoveBuffs, tmpBuff)
		end

		if result < 0 and self:isHurtMaxHpLimit() then
			local tmpRate = self.isHurtMaxHpLimit_[1]:getFinalNum()
			result = math.max(-self:getHpLimit() * tmpRate, result)
			result = math.min(0, result)
		end

		if result < 0 and self:isNoHarm() then
			result = 0
		end
	end

	local hurtMaxHpLimitBBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_HURT_MAX_HP_LIMIT_B)

	if result < 0 and next(hurtMaxHpLimitBBuffs) then
		local tmpRate = hurtMaxHpLimitBBuffs[1]:getFinalNum()

		if self:getHpLimit() < -self:getHpLimit() * tmpRate - result then
			result = result + self:getHpLimit()
		else
			result = math.max(-self:getHpLimit() * tmpRate, result)
		end

		result = math.min(0, result)
	end

	local attacker = buffFighter or unit.fighter

	if attacker then
		local mistletoeBuffs = attacker:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

		if mistletoeBuffs and next(mistletoeBuffs) then
			local mistletoeMaxHpLimitBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_MAX_HP_LIMIT)
			local skillID = unit.skillID

			if mistletoeMaxHpLimitBuffs and next(mistletoeMaxHpLimitBuffs) and (attacker:isEnergySkill(skillID) or attacker:isPugongSkill(skillID) or isImpress) then
				local mBuff = mistletoeMaxHpLimitBuffs[1]
				local maxHurtRate = mBuff:getFinalNum() or 1
				local maxHurt = math.max(-self:getHpLimit() * maxHurtRate, result)
				result = maxHurt
			end
		end
	end

	result = self:newShareHarm(result, unit, attacker)

	if not isHealCurse then
		if not isImpress and unit and not unit:isPasSkill() and unit.fighter and not unit.fighter:isPet() and result < 0 and self:isGetAbsorbShield() and (not buff or buff:getName() ~= xyd.BUFF_SUN_ARROW_SHOOT) then
			if self:isGetThorns() then
				self:usePasSkill(xyd.TriggerType.SELF_ATTACKED_WITH_THORNS, unit)
			end

			unit.totalAttackHarm_[self:getPos()] = unit.totalAttackHarm_[self:getPos()] + result
			result = 0
		end

		if result < 0 and self:isAllHarmShare() then
			local fighter = nil

			if buffFighter then
				fighter = buffFighter
			elseif unit then
				fighter = unit.fighter
			end

			result = self:initShareBuff(result, fighter, xyd.BUFF_ALL_HARM_SHARE)
		end
	end

	unit:recordBuffs(self, needRecordBuffs)
	self:removeBuffs(needRemoveBuffs, nil, unit)

	return result
end

function ReportBaseFighter:getSuperDecHurtRate(buff)
	local rate = 1

	if self:isAbsorbDamage() then
		local tmpRate = self:getBuffTotalNumByGroup(self.isAbsorbDamage_)

		if -tmpRate - self:getAllHarmDec() <= -1 then
			return 0
		end
	end

	if BuffTable:getIsHpChange(buff:getName()) ~= 1 then
		return 1
	end

	if buff.fighter:getBuffByName(xyd.BUFF_GOD_CONTROL_ENERGY) and buff.fighter:getEnergy() == 0 then
		return 0
	end

	if self:isSuperDecHurt() then
		local tmpRate = self:getBuffTotalNumByGroup(self.isSuperDecHurt_)
		rate = rate * (1 - tmpRate)
	end

	if buff:isDot() then
		return rate
	end

	local invisibleBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_INVISIBLE)

	if next(invisibleBuffs) then
		rate = rate * 0.5
	end

	if self:isHalfHpDecP() then
		local tmpRate = self:getBuffTotalNumByGroup(self.isHalfHpDecP_)
		rate = rate * (1 - tmpRate)
	end

	local lubanBBuffs = self:getBuffsByName(xyd.BUFF_LUBAN_HURT_B)

	if next(lubanBBuffs) then
		rate = rate * (1 + lubanBBuffs[1].finalNumArray_[1])
	end

	local lubanCBuffs = self:getBuffsByName(xyd.BUFF_LUBAN_HURT_C)

	if next(lubanCBuffs) then
		rate = rate * (1 + lubanCBuffs[1].finalNumArray_[1])
	end

	return rate
end

function ReportBaseFighter:newShareHarm(finalNum, unit, attacker)
	if not attacker then
		return finalNum
	end

	local kawenMarkBuffs = attacker:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK, self)
	local resultNum = finalNum

	if next(kawenMarkBuffs) then
		resultNum = kawenMarkBuffs[1]:shareHarm(self, resultNum, unit, attacker)
	end

	return resultNum
end

function ReportBaseFighter:getDecHurtNum()
	local num = 0
	local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_DEC_HURT_NUM)

	for _, buff in ipairs(buffs) do
		num = num + buff:getFinalNum()
	end

	return num
end

function ReportBaseFighter:getExtraHarmRate(unit, isRate, fighter_)
	local result = 0
	local fighter = fighter_

	if unit and unit.fighter then
		fighter = fighter or unit.fighter
	end

	if self:isGetLeaf() then
		local tmpRate = self:getBuffTotalNumByGroup(self.isGetLeaf_)
		result = result + tmpRate
	end

	if fighter then
		local cBuffs = fighter:getBuffsByName(xyd.BUFF_ALL_DMG_C)
		local tmpRate = 0

		if next(cBuffs) then
			tmpRate = fighter:getBuffTotalNumByGroup(cBuffs)
		end

		local cBuffs40 = fighter:getBuffsByNameAndFighter(xyd.BUFF_ALL_DMG_C_40)
		local c40 = 0

		if next(cBuffs40) then
			c40 = fighter:getBuffTotalNumByGroup(cBuffs40)
		end

		if c40 < -0.4 then
			c40 = -0.4
		end

		tmpRate = tmpRate + c40
		local luobiBuffs = fighter:getBuffsByName(xyd.BUFF_LUOBI_HP)

		if next(luobiBuffs) then
			tmpRate = tmpRate + luobiBuffs[1]:getHarmRate()
		end

		if fighter:isGetLeaf() then
			tmpRate = tmpRate - fighter:getBuffTotalNumByGroup(fighter.isGetLeaf_, 2)
		end

		result = result + tmpRate
	end

	if isRate then
		result = result - self:getAllHarmDec()

		if self:isDecHurt() then
			local tmpRate = self:getBuffTotalNumByGroup(self.isDecHurt_)
			result = result + tmpRate
		end
	else
		if self:isHalfHpDmg() then
			local tmpRate = self:getBuffTotalNumByGroup(self.isHalfHpDmg_)
			result = result + tmpRate
		end

		if fighter and fighter:isAllDmgB() then
			local tmpRate = fighter:getBuffTotalNumByGroup(fighter.isAllDmgB_)
			result = result + tmpRate
		end

		if self:isDecDmgShieldLimit8() then
			local tmpRate = self:getBuffTotalNumByGroup(self.isDecDmgShieldLimit8_)
			result = result - tmpRate
		end

		if self:isDecHurt() then
			local tmpRate = self:getBuffTotalNumByGroup(self.isDecHurt_)
			result = result + tmpRate
		end

		if self:isAbsorbDamage() then
			local tmpRate = self:getBuffTotalNumByGroup(self.isAbsorbDamage_)
			result = result - tmpRate
		end

		local rImpressesTreatBlockBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_TREATMENT_BLOCK)
		local rImpressesHpLimitBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_HP_LIMIT)

		if rImpressesTreatBlockBuffs and next(rImpressesTreatBlockBuffs) and (rImpressesHpLimitBuffs and next(rImpressesHpLimitBuffs) or self.rImpresses_ and next(self.rImpresses_)) then
			result = result + self:getBuffTotalNumByGroup(rImpressesTreatBlockBuffs, 2)
		end

		result = result - self:getAllHarmDec()
	end

	return math.max(result, -1)
end

function ReportBaseFighter:getExtraRoundHarm(buff)
	local res = 0

	if buff.fighter and buff.fighter:isRoundDmgB() then
		local round = xyd.Battle.round
		res = round % 2 == 1 and 0.5 or -0.5
	end

	return res
end

function ReportBaseFighter:applyLeafBuffHarm(unit)
	local getLeafBuffs = self:getBuffsByName(xyd.BUFF_GET_LEAF)

	if not next(getLeafBuffs) then
		return
	end

	local params2 = {
		effectID = getLeafBuffs[1].finalNumArray_[3],
		fighter = getLeafBuffs[1].fighter,
		target = self
	}
	local newBuff2 = BuffManager:newBuff(params2)
	newBuff2.isHit_ = 1

	newBuff2:calculate()
	self:updateHpByHarm(newBuff2.finalNum_, unit, false, false, false, newBuff2)
	getLeafBuffs[1].fighter:recordData(-newBuff2.finalNum_, 0)
	newBuff2:writeRecord(self, xyd.BUFF_WORK)
	unit:recordBuffs(self, {
		newBuff2
	})
end

function ReportBaseFighter:triggerSelfInAction(unit, isCrit, isMiss, isBlock)
	local addHarmRate = 1 + self:getExtraHarmRate(unit)
	local isPugongOrSkill = false

	if self:isPugongSkill(unit.skillID) then
		self:usePasSkill(xyd.TriggerType.SELF_PUGONG, unit)

		isPugongOrSkill = true
	elseif unit.skillID == self:getEnergySkillID() then
		self:usePasSkill(xyd.TriggerType.SELF_SKILL, unit)

		isPugongOrSkill = true
	end

	if isPugongOrSkill then
		self:applyLeafBuffHarm(unit)
	end

	if isBlock then
		self:usePasSkill(xyd.TriggerType.SELF_ATTACK_SHANBI, unit)
	end

	if isCrit then
		self:usePasSkill(xyd.TriggerType.SELF_CRIT, unit)

		if xyd.Battle.round <= 2 then
			self:usePasSkill(xyd.TriggerType.SELF_CRIT_FIRST_TWO_ROUND, unit)
		end
	end

	if next(self.bImpresses_) and not self:isPugongSkill(unit.skillID) and not self:isDeath() then
		local bBuff = self.bImpresses_[1]
		addHarmRate = 1
		addHarmRate = addHarmRate + self:getExtraRoundHarm(bBuff)
		local num = bBuff:getFinalNum()
		num = num * addHarmRate
		num = self:getShieldHarm(num, unit, true, true, bBuff.fighter)

		bBuff:setRecordNum(num)
		bBuff.fighter:recordData(-num, 0)
		self:updateHpByHarm(num, unit, true, false, false, bBuff)
		bBuff:writeRecord(self, xyd.BUFF_WORK)
		unit:recordBuffs(self, {
			bBuff
		})
		self:checkHpPasSkill(unit)
	end

	self:usePasSkill(xyd.TriggerType.SELF_ROUND, unit)
end

function ReportBaseFighter:triggerOthersInAction(unit, harm, cure, isCrit, isMiss, isBlock)
	local fighter = unit.fighter
	local fighterIsFriend = fighter:getTeamType() == self:getTeamType()
	local targetIsFriend = fighter:getTeamType() ~= self:getTeamType()
	local fighterIsPet = fighter:isPet()
	local fighterJob = fighter:getJob()

	if isBlock then
		if targetIsFriend then
			self:usePasSkill(xyd.TriggerType.FRIEND_SHANBI, unit)
		else
			self:usePasSkill(xyd.TriggerType.ENEMY_SHANBI, unit)
		end

		if fighterIsFriend then
			self:usePasSkill(xyd.TriggerType.FRIEND_ATTACK_SHANBI, unit)
		else
			self:usePasSkill(xyd.TriggerType.ENEMY_ATTACK_SHANBI, unit)
		end
	end

	if fighter:isPugongSkill(unit.skillID) then
		if fighterIsFriend then
			self:usePasSkill(xyd.TriggerType.FRIEND_PUGONG, unit)

			if fighter ~= self then
				self:usePasSkill(xyd.TriggerType.ONLY_FRIEND_PUGONG, unit)
			end

			if fighterJob == xyd.HeroJob.YX then
				self:usePasSkill(xyd.TriggerType.SELF_TEAM_YX_PUGONG, unit)
			end
		else
			self:usePasSkill(xyd.TriggerType.ENEMY_PUGONG, unit)
		end
	elseif unit.skillID == fighter:getEnergySkillID() then
		if fighterIsFriend then
			if not fighterIsPet then
				self:usePasSkill(xyd.TriggerType.FRIEND_SKILL_H, unit)

				if fighterJob == xyd.HeroJob.FS then
					self:usePasSkill(xyd.TriggerType.SELF_TEAM_FS_SKILL, unit)
				end

				if fighter ~= self then
					self:usePasSkill(xyd.TriggerType.FRIEND_SKILL_WITHOUT_SELF_H, unit)
				end
			end

			self:usePasSkill(xyd.TriggerType.FRIEND_SKILL, unit)
		elseif not fighterIsPet then
			self:usePasSkill(xyd.TriggerType.ENEMY_SKILL, unit)
		end

		if harm > 0 and not fighterIsPet then
			if targetIsFriend then
				self:usePasSkill(xyd.TriggerType.FRIEND_ATTACKED_SKILL_H, unit)
			else
				self:usePasSkill(xyd.TriggerType.ENEMY_ATTACKED_SKILL_H, unit)
			end
		end
	end

	if harm > 0 and isCrit then
		if fighterIsFriend then
			self:usePasSkill(xyd.TriggerType.FRIEND_CRIT, unit)
			self:usePasSkill(xyd.TriggerType.ENEMY_CRITED, unit)
		else
			self:usePasSkill(xyd.TriggerType.ENEMY_CRIT, unit)
			self:usePasSkill(xyd.TriggerType.FRIEND_CRITED, unit)
		end
	end

	if harm > 0 and targetIsFriend then
		self:usePasSkill(xyd.TriggerType.FRIEND_ATTACKED, unit)

		if not fighterIsPet and self:isMoonShadow() then
			if self.debuffCleanLimitRound_ ~= xyd.Battle.round then
				self.debuffCleanLimitRound_ = xyd.Battle.round
				self.debuffCleanLimitTimes_ = 0
			end

			self:usePasSkill(xyd.TriggerType.MOONSHADOW_FRIEND_ATTACKED, unit)
		end
	elseif harm > 0 then
		self:usePasSkill(xyd.TriggerType.ENEMY_ATTACKED, unit)
	end

	if fighterIsFriend and fighter ~= self and not fighterIsPet and self:canAttack() then
		self:usePasSkill(xyd.TriggerType.FRIEND_ATTACK, unit)
	end

	if not fighterIsFriend then
		self:usePasSkill(xyd.TriggerType.ENEMY_ATTACK_LATER, unit)
	end

	if xyd.Battle.attackNum >= 10 then
		self:usePasSkill(xyd.TriggerType.TOTAL_ATTACK_NUM_TEN, unit)
	end
end

function ReportBaseFighter:checkIsGuoJia()
	if self.hero_ and xyd.arrayIndexOf({
		55003,
		655014,
		755004
	}, self:getHeroTableID()) > 0 then
		return true
	end

	return false
end

function ReportBaseFighter:useFenShenPasSkill(v, pasType, unit)
	if pasType <= 0 or unit:isPasSkill() and not BattleTriggerTable:isDiePasSkill(pasType) and not BattleTriggerTable:isHpPasSkill(pasType) and not BattleTriggerTable:isCanUseByPasSkill(pasType) then
		return
	end

	if xyd.Battle.atkDFlag then
		return
	end

	local skillIDs = v:getPasSkillByType(pasType)

	if #skillIDs <= 0 or not next(skillIDs) then
		return
	end

	for _, skillID in ipairs(skillIDs) do
		local isJump = SkillTable:jump(skillID)

		if isJump >= 1 then
			if v:canAttack() then
				table.insert(self.addHurtTargets_, {
					target = v,
					type_ = pasType
				})
			end
		else
			v:usePasSkill(type, unit)
		end
	end
end

function ReportBaseFighter:usePasSkill(pasType, unit)
	if pasType <= 0 then
		return
	end

	if pasType == xyd.TriggerType.SELF_CONTROLED and self:getTeamType() == xyd.TeamType.B then
		if not xyd.Battle.purposes.controlEnemyTimes then
			xyd.Battle.purposes.controlEnemyTimes = 0
		end

		xyd.Battle.purposes.controlEnemyTimes = xyd.Battle.purposes.controlEnemyTimes + 1
	end

	if (unit:notUsePasSkill() or unit:isPasSkill()) and not BattleTriggerTable:isDiePasSkill(pasType) and not BattleTriggerTable:isHpPasSkill(pasType) and not BattleTriggerTable:isCanUseByPasSkill(pasType) then
		return
	end

	if xyd.Battle.atkDFlag then
		return
	end

	if self:isExile() then
		return
	end

	local triggerTimes = self.triggerTimes_[tostring(pasType)] or 0
	local limitTime = BattleTriggerTable:getLimitTimes(pasType)

	if limitTime > 0 and limitTime <= triggerTimes then
		return
	end

	if limitTime > 0 then
		self.triggerTimes_[tostring(pasType)] = triggerTimes + 1
	end

	local skillIDs = self:getPasSkillByType(pasType)

	if pasType ~= xyd.TriggerType.FOREVER and pasType ~= xyd.TriggerType.SELF_DIE and pasType ~= xyd.TriggerType.ENERGY_SKILL_HOLD and self:isSeal() then
		local tmpSkills = {}

		for _, skillID in ipairs(skillIDs) do
			if SkillTable:isUnSeal(skillID) ~= 0 then
				table.insert(tmpSkills, skillID)
			end

			skillIDs = tmpSkills
		end
	end

	if pasType ~= xyd.TriggerType.SELF_DIE and self:isForceSeal() then
		return
	end

	if #skillIDs <= 0 or not next(skillIDs) then
		return
	end

	for _, skillID in ipairs(skillIDs) do
		local flag = true

		if pasType == xyd.TriggerType.FRIEND_SKILL_WITHOUT_SELF_H then
			local subSkills = SkillTable:getSubSkills(skillID)

			if #subSkills > 0 and not self:canAttack() then
				flag = false
			end
		end

		if pasType == xyd.TriggerType.MASTER_ATTACK or pasType == xyd.TriggerType.SELF_ATTACKED or pasType == xyd.TriggerType.SELF_CRITED then
			local isJump = SkillTable:jump(skillID)

			if isJump >= 1 then
				flag = false
			else
				local effects = SkillTable:getEffect(skillID, 1)

				for _, id in ipairs(effects) do
					local buffName = EffectTable:buff(id)

					if buffName == "addHurtd" and (not self:canAttack() or self:getHujia() <= unit.fighter:getHujia()) or buffName == xyd.BUFF_ADD_HURT and not self:canAttack() then
						flag = false

						break
					end
				end
			end
		elseif BattleTriggerTable:isDiePasSkill(pasType) then
			self:useDieSkill(skillID, unit)

			flag = false
		end

		local preEffect = SkillTable:getPreEffect(skillID)

		if preEffect and preEffect ~= 0 then
			flag = false
			local buffName = EffectTable:buff(preEffect)
			local buffs = self:getBuffListByName(buffName)

			for _, buff in ipairs(buffs) do
				if buff.effectID == preEffect then
					flag = true

					break
				end
			end
		end

		if flag then
			self:useOnePasSkill(pasType, skillID, unit)
		end
	end
end

function ReportBaseFighter:useOnePasSkill(pasType, skillID, unit)
	local isJump = SkillTable:jump(skillID)
	local specialUnit = self:createAttackUnit(skillID, true, unit)

	if isJump < 1 or self:isDeath() then
		local datas = specialUnit:getUnitDatas()

		for _, data in ipairs(datas) do
			local target = data.target

			if not target:isDeath() then
				local harm, cure, isCrit, recordBuffs, isHarm = target:applyBuffHarmsByTarget(data, specialUnit, true)

				self:recordData(harm, cure)
			end
		end
	end
end

function ReportBaseFighter:useOneJumpPasSkill(pasType, skillID, unit, ifNoPas, ifNoBlock)
	local specialUnit = self:createAttackUnit(skillID, true, unit, true, ifNoPas, ifNoBlock)
	local isAttackMiss = self:applySpecialUnit(specialUnit)

	if isAttackMiss then
		table.removebyvalue(xyd.Battle.recordUnits, xyd.Battle.recordUnit)

		xyd.Battle.recordUnit = xyd.Battle.recordUnits[#xyd.Battle.recordUnits]

		return nil
	end

	if specialUnit then
		self:calculateAllharmShare(specialUnit)
	end

	return specialUnit
end

function ReportBaseFighter:useOneJumpSkill(triggerType, skillID, unit, ifNoPas, ifNoBlock)
	local isPass = SkillTable:isPass(skillID) == 1
	local specialUnit = self:createAttackUnit(skillID, isPass, unit, true, ifNoPas, ifNoBlock)
	local isAttackMiss = self:applySpecialUnit(specialUnit)

	if isAttackMiss then
		table.removebyvalue(xyd.Battle.recordUnits, xyd.Battle.recordUnit)

		xyd.Battle.recordUnit = xyd.Battle.recordUnits[#xyd.Battle.recordUnits]

		return nil
	end

	if specialUnit then
		self:calculateAllharmShare(specialUnit)
	end

	return specialUnit
end

function ReportBaseFighter:useDieSkill(skillID, unit)
	local specialUnit = self:createAttackUnit(skillID, true, unit)
	local datas = specialUnit:getUnitDatas()

	for _, data in ipairs(datas) do
		local target = data.target
		local hitBuffs = data.hitBuffs
		local harm, cure, recordBuffs, status = target:applyBuffHarm(specialUnit, hitBuffs, true)

		self:recordData(harm, cure)

		if status.isControl then
			target:usePasSkill(xyd.TriggerType.SELF_CONTROLED, unit)
		end

		if not target:isDeath() then
			target:checkHpPasSkill(unit)
			target:checkStatusSkill(unit, status)
		end
	end
end

function ReportBaseFighter:reborn(unit, isApateReborn)
	if not isApateReborn and (not self.isRevive_[self.hasReviveTimes_] or self.isRevive_[self.hasReviveTimes_]:getName() ~= xyd.BUFF_REVIVE_INF) then
		self.hasReviveTimes_ = self.hasReviveTimes_ + 1
	end

	if self.hasReviveTimes_ ~= 0 and self.hasReviveTimes_ == #self.isRevive_ then
		self.noReviveDie_ = true
	end

	self.dieRound_ = 0
	self.killer = nil

	for i = #self.isRevive_, 1, -1 do
		local buff = self.isRevive_[i]

		if self:checkRebornUnlimited(buff) then
			self.hasReviveTimes_ = 0
			self.noReviveDie_ = false
		end
	end

	self:removeBuffs(self.buffs_)
	self:addInitBuffs()

	if xyd.Battle.god then
		xyd.Battle.god:addForverBuffs(self, unit)
	end

	xyd.Battle.rebornFighter = self

	self:usePasSkill(xyd.TriggerType.AFTER_REBORN, unit)

	if xyd.Battle.god then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.AFTER_REBORN, unit)
	end
end

function ReportBaseFighter:getPasSkillByType(trigger)
	local pasSkills = self:getPasSkill()

	return pasSkills[trigger] or {}
end

function ReportBaseFighter:applyBuffHarm(unit, hitBuffs, noRecord)
	local harm = 0
	local cure = 0
	local isCrit = false
	local isClearEnergy = false
	local isBlock = false
	local isHurt = false
	local isControl_ = false
	local remove_ = {}
	local recordBuffs = {}
	local fighter = unit.fighter
	local status = {}
	local canReflect = false
	local reflectRate = 1
	local baseAddHarmRate = 1 + self:getExtraHarmRate(unit)
	local tmpHurtShieldLimit3 = #self.isHurtShieldLimit3_
	local tmpReduceSpd = #self.isReduceSpd_
	local hasFullEnergyHurt = false
	local inHarmTargetList = true

	if fighter and not fighter:isPet() and not fighter:isGod() and (fighter:isPugongSkill(unit.skillID) or unit.skillID == fighter:getEnergySkillID()) then
		local num = 0

		if self:isRoundReflect() then
			canReflect = true
			num = self.isRoundReflect_[1]:getFinalNum()
		elseif self:isReflect() then
			canReflect = true
			num = self.isReflect_[1]:getFinalNum()
		end

		reflectRate = 1 - num
	end

	local function saveAndDelBuff(buff, on)
		buff:writeRecord(self, on)
		table.insert(recordBuffs, buff)
	end

	if self:checkHurtShield(unit, hitBuffs, recordBuffs) then
		local buff = BuffManager:newBuff({
			target = self
		})
		buff.isHit_ = true
		buff.name_ = xyd.BUFF_HURT_0
		buff.finalNum_ = 0
		buff.fighter = fighter
		hitBuffs = {
			buff
		}
	end

	for i = 1, #hitBuffs do
		local buff = hitBuffs[i]

		if buff:getName() == xyd.BUFF_HURT_DMG_H_LIMIT15 then
			buff:calculate()
		end

		local num = buff:getFinalNum()
		local curHp = self:getHp()
		local roundExtraHarm = self:getExtraRoundHarm(buff)
		local addHarmRate = baseAddHarmRate + roundExtraHarm

		if (buff:isDamage() or buff:getName() == xyd.BUFF_OVER_FLOW or buff:getName() == xyd.BUFF_SUCK_REAL_BLOOD) and not self:isDeath() then
			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			if buff:getName() ~= xyd.BUFF_REAL_HURT then
				if buff.fighter ~= unit.fighter then
					addHarmRate = addHarmRate - baseAddHarmRate + 1 + self:getExtraHarmRate(unit, false, buff.fighter)
				end

				num = num * addHarmRate
			end

			--num = self:getShieldHarm(num, unit, nil, , , , buff)
			num = self:getShieldHarm(num, unit, false, false, nil, false, buff)
			harm = harm - num

			buff:setRecordNum(num)

			if buff:canAddEnergy() then
				isHurt = true

				if buff:isCrit() then
					isCrit = true
				end
			end

			buff:delCount()
			self:usePasSkill(xyd.TriggerType.SELF_BEFOR_HURTED, unit)

			local shareBuff = self:getBuffByName(xyd.BUFF_HURT_SHARE)

			if shareBuff then
				num = self:initShareBuff(num, buff.fighter, xyd.BUFF_HURT_SHARE)

				buff:setRecordNum(num)
				self:removeBuffs({
					shareBuff
				})
				shareBuff:writeRecord(self, xyd.BUFF_OFF)
				table.insert(recordBuffs, shareBuff)
			end

			self:updateHpByHarm(num, unit, false, false, false, buff)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			if buff:isCrit() then
				status.isCrit = true
			end

			if buff:isBlock() then
				isBlock = true
				status.isBlock = true
			end

			if buff:getName() == xyd.BUFF_OVER_FLOW and self:isDeath() then
				self:applyOverFlowHarm(curHp + num, buff.fighter)
			end

			if buff:getName() == xyd.BUFF_SUCK_REAL_BLOOD then
				local srbgBuffs = fighter:getBuffsByNameAndFighter(xyd.BUFF_SUCK_REAL_BLOOD_GET)

				if next(srbgBuffs) then
					for _, srbgBuff in ipairs(srbgBuffs) do
						srbgBuff:writeRecord(fighter, xyd.BUFF_REMOVE)
						table.insert(recordBuffs, srbgBuff)
					end

					self:removeBuffs(srbgBuffs)
				end
			end

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_HURT_0 then
			saveAndDelBuff(buff, xyd.BUFF_WORK)
		elseif buff:getName() == xyd.BUFF_EAT then
			harm = harm - curHp

			unit.fighter:usePasSkill(xyd.TriggerType.EAT_ENEMY, unit)
			self:updateHpByDeath(harm, unit)
			saveAndDelBuff(buff, xyd.BUFF_WORK)
		elseif buff:getName() == xyd.BUFF_EAT_FREEHARM then
			buff.delayNum_ = EffectTable:num(buff.effectID)

			saveAndDelBuff(buff, xyd.BUFF_OFF)
		elseif buff:getName() == xyd.BUFF_APATE_REVIVE then
			buff.delayNum_ = 4
			buff.leftCount_ = 4

			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_ROUND_REFLECT_HURT then
			num = unit.totalReflectHarm_[fighter:getPos()]
			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_REFLECT then
			num = unit.totalReflectHarm_[fighter:getPos()]
			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, true)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_HURT_BY_RECEIVE then
			num = num * unit.totalPosHarm_[fighter:getPos()]

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(-num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_CRIT_HURT then
			num = num * unit.totalCritHarm_

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(-num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_INJURED then
			num = num * unit.totalHarm_

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(-num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif (buff:getName() == xyd.BUFF_HURT_MAX_H or buff:getName() == xyd.BUFF_HURT_MAX_M or buff:getName() == xyd.BUFF_HURT_MAX_H_LIMIT15 or buff:getName() == xyd.BUFF_HURT_MAX_H_LIMIT or buff:getName() == xyd.BUFF_HURT_MAX_H_LIMIT25 or buff:getName() == xyd.BUFF_HURT_DMG_H_LIMIT15 or buff:getName() == xyd.BUFF_HURT_NOW_H_LIMIT15 or buff:getName() == xyd.BUFF_HURT_MAX_H_LIMIT15_BLOOD or buff:getName() == xyd.BUFF_HURT_MAX_H_LIMIT15_TEAR or buff:getName() == xyd.BUFF_HURT_MAX_HP) and not self:isDeath() then
			local specialAddHarmRate = 1 + self:getExtraHarmRate(unit, true)

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * specialAddHarmRate
			num = self:getShieldHarm(num, unit, true)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_ENERGY_HURT then
			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit, false)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_SPD_GAP_HURT then
			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_PHURT_SKILL_L_B or buff:getName() == xyd.BUFF_PHURT_PAS_L_B then
			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_HURT_ATK then
			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_FIRE_EXPLOADED then
			local allHarm = self:calAllFireDmg(recordBuffs)
			allHarm = math.max(allHarm, -buff.fighter:getAD() * 25)

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + allHarm * (1 - reflectRate)
				allHarm = allHarm * reflectRate
			end

			allHarm = allHarm * addHarmRate
			allHarm = self:getShieldHarm(allHarm, unit)

			buff:setRecordNum(allHarm)

			harm = harm - allHarm

			self:updateHpByHarm(allHarm, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_WORK)

			status.isHarm = true
		elseif buff:isHeal() and not self:isDeath() then
			if buff:isSiphonAttr() then
				buff:setRecordNum(num * unit.totalHarm_)

				num = num * unit.totalHarm_
			end

			if buff:getName() == xyd.BUFF_CRIT_SIPHON then
				buff:setRecordNum(num * unit.totalCritHarm_)

				num = num * unit.totalCritHarm_
			end

			num = num * buff.target:getExtraHealRate()
			num = self:blockHeal(num, unit, buff)
			cure = cure + num

			buff:delCount()
			self:updateHpByHeal(num, unit)
			buff:setRecordNum(num)

			if buff:getCount() <= 0 then
				saveAndDelBuff(buff, xyd.BUFF_WORK)
			else
				saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
			end
		elseif buff:isHot() and not self:isDeath() then
			num = num * buff.target:getExtraHealRate()
			num = self:blockHeal(num, unit, buff)
			cure = cure + num

			buff:delCount()
			self:updateHpByHeal(num, unit)
			buff:setRecordNum(num)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:isDot() and not self:isDeath() then
			num = num * (1 + self:getTearRate() + self:getDotAddHarmRate())

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)
			harm = harm - num

			if fighter:isDeath() or buff:getName() == xyd.BUFF_DOT_TWINS then
				buff:delCount()
			end

			buff:setRecordNum(num)

			status.isDot = true

			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)

			status.isHarm = true
		elseif buff:isFree() and not self:isDeath() then
			saveAndDelBuff(buff, xyd.BUFF_WORK)
		elseif buff:getName() == xyd.BUFF_ENERGY then
			buff:delCount()

			if num < 0 and buff.fighter:getTeamType() ~= buff.target:getTeamType() then
				num = num - self:getResistEnergy(num)
			end

			self:addEnergy(num, unit)
		elseif buff:checkIsPet() and not self:isDeath() then
			if buff:getName() == xyd.BUFF_M_HURT then
				isHurt = true
			else
				status.isDot = true
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)
			local exBuffHarmRate = self:getPetExBuffHarmRate(buff.fighter)
			num = num * (1 + exBuffHarmRate)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			buff:changePetBuffName()
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_EXLODED then
			local len = self:exlodedBuffs(unit, recordBuffs)
			buff.finalNum_ = buff.finalNum_ * (1 + len)
			num = buff.finalNum_

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit)

			buff:setRecordNum(num)

			harm = harm - num

			buff:delCount()
			self:updateHpByHarm(num, unit, false)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)

			status.isHarm = true
		elseif buff:getName() == xyd.BUFF_TRANSFORM_BK then
			self:transformBk(buff, unit)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_DEC_FIRE then
			self:changeFireCount(buff:getFinalNum(), recordBuffs)
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_ADD_FIRE then
			self:changeFireCount(buff:getFinalNum(), recordBuffs)
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_EXCEPT_DOT_SHIELD_REMOVE then
			self:removeAllBuffByName(xyd.BUFF_EXCEPT_DOT_SHIELD)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_DEBUFF_CLEAN then
			self:cleanMultiDebuff(unit, recordBuffs, 1)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_DEBUFF_CLEAN_2_LIMIT then
			if fighter and fighter.debuffCleanLimitTimes_ < buff:getFinalNum() then
				fighter.debuffCleanLimitTimes_ = fighter.debuffCleanLimitTimes_ + 1

				self:cleanMultiDebuff(unit, recordBuffs, 2)
			end

			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_CLEAR then
			self:cleanMultiBuff(unit, recordBuffs, 1)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_DEBUFF_TRANS_ALL then
			self:transDebuff(unit, recordBuffs, num)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_CONTROL_REMOVE then
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:isControlNew() and not self:isDeath() and buff:getName() ~= xyd.BUFF_RIDICULE and buff:getName() ~= xyd.BUFF_TELEISHA_SEAL and buff:getName() ~= xyd.BUFF_ALL_TARGET_CHANGE then
			self:delSpecialBuffCount(buff)

			if buff:getCount() > 0 then
				saveAndDelBuff(buff, xyd.BUFF_ON)
			end
		elseif buff:getName() == xyd.BUFF_EXCHANGE_SPD then
			self:exchangeSpeed(buff, recordBuffs)
		elseif buff:getName() == xyd.BUFF_SPD_STEAL then
			self:spdSteal(buff, recordBuffs)
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_DEBUFF_TRANS_ONE then
			self:transMultiDebuff(unit, recordBuffs, num)
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_CLEAR_ENERGY then
			isClearEnergy = true

			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_HURT_SHIELD_LIMIT3 then
			if tmpHurtShieldLimit3 < 3 then
				tmpHurtShieldLimit3 = tmpHurtShieldLimit3 + 1

				saveAndDelBuff(buff, xyd.BUFF_ON)
			end
		elseif buff:getName() == xyd.BUFF_REDUCE_SPD then
			if tmpReduceSpd < 5 then
				tmpReduceSpd = tmpReduceSpd + 1

				saveAndDelBuff(buff, xyd.BUFF_ON)
			else
				local minBuff = buff
				local minNum = buff:getFinalNum()

				for _, buff_ in ipairs(self.isReduceSpd_) do
					if buff_:getFinalNum() < minNum then
						minNum = buff_:getFinalNum()
						minBuff = buff_
					end
				end

				if minBuff ~= buff then
					saveAndDelBuff(buff, xyd.BUFF_ON)
					saveAndDelBuff(minBuff, xyd.BUFF_OFF)
					self:removeBuffs({
						minBuff
					})
				end
			end
		elseif buff:getName() == xyd.BUFF_ABSORB_DAMAGE then
			if not self.hasAbsorbDamage then
				saveAndDelBuff(buff, xyd.BUFF_ON)
			end
		elseif buff:getName() == xyd.BUFF_XIFENG_SPD then
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_FULL_ENERGY_HURT and not self:isDeath() then
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)

			hasFullEnergyHurt = true
		elseif buff:getName() == xyd.BUFF_APATE_HURT then
			saveAndDelBuff(buff, xyd.BUFF_WORK)
		elseif buff:getName() == xyd.BUFF_OUT_BREAK then
			self.buffOutBreak_ = buff

			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_RIDICULE and not self:isDeath() then
			self:delSpecialBuffCount(buff)

			if buff:getCount() > 0 then
				if self.buffRidicule_ then
					saveAndDelBuff(self.buffRidicule_, xyd.BUFF_REMOVE)
				end

				self.buffRidicule_ = buff

				saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
			end
		elseif buff:getName() == xyd.BUFF_YUNMU_DIE then
			if self:isRidicule() then
				saveAndDelBuff(self.buffRidicule_, xyd.BUFF_REMOVE)

				self.buffRidicule_ = nil
			end
		elseif buff:getName() == xyd.BUFF_LOCK_TARGET then
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_FANHEXING_DIE1 then
			local lockBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_LOCK_TARGET, buff.fighter)

			if next(lockBuffs) then
				saveAndDelBuff(lockBuffs[1], xyd.BUFF_REMOVE)
				self:removeBuffs(lockBuffs)
			end
		elseif buff:getName() == xyd.BUFF_FANHEXING_DIE2 then
			local oldBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS, buff.fighter)

			if next(oldBuffs) then
				for _, oldBuff in ipairs(oldBuffs) do
					saveAndDelBuff(oldBuff, xyd.BUFF_OFF)
				end

				self:removeBuffs(oldBuffs)
			end
		elseif buff:getName() == xyd.BUFF_CLEAN_WITHOUT_DOT then
			self:changeDebuffWithoutDOT(unit, recordBuffs, buff)
			saveAndDelBuff(buff, xyd.BUFF_ON)
		elseif buff:getName() == xyd.BUFF_TRUE_VAMPIRE then
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif buff:getName() == xyd.BUFF_MAYA_HP_LOSE_SEAL_FX then
			saveAndDelBuff(buff, xyd.BUFF_WORK)
		elseif buff:getName() == xyd.BUFF_ABSORB_FIX_DAMAGE then
			buff:setRecordNum(0)
			saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
		elseif not self:isDeath() or buff:getName() == xyd.BUFF_REVIVE and not self.noReviveDie_ then
			if buff:getName() == xyd.BUFF_REVIVE_INF then
				self:cleanAllDebuff(unit, recordBuffs)
			end

			if buff:hasFx() then
				saveAndDelBuff(buff, xyd.BUFF_ON_WORK)
			else
				saveAndDelBuff(buff, xyd.BUFF_ON)
			end

			if buff:getName() == xyd.BUFF_SUCK_REAL_BLOOD_GET then
				self:usePasSkill(xyd.TriggerType.GET_SUCK_REAL_BLOOD, unit)
			end
		end

		buff:excuteBuff(unit, recordBuffs, status)

		inHarmTargetList = buff.inHarmTargetList

		self:recordBuffStatus(status, buff)
	end

	for i = #hitBuffs, 1, -1 do
		local buff = hitBuffs[i]

		if buff:getCount() <= 0 or self:isDeath() and buff:getName() ~= xyd.BUFF_REVIVE and buff:getName() ~= xyd.BUFF_APATE_REVIVE then
			table.remove(hitBuffs, i)
		end
	end

	if not self:isDeath() and not unit:isPasSkill() and unit.fighter and not unit.fighter:isPet() and self:isGetAbsorbShield() and unit.totalAttackHarm_[self:getPos()] < 0 then
		local delBuff = self.isGetAbsorbShield_[1]
		local params = {
			effectID = delBuff:getFinalNum(),
			fighter = delBuff.fighter,
			target = self
		}
		local newBuff = BuffManager:newBuff(params)
		newBuff.isHit_ = 1

		newBuff:calculate()

		newBuff.finalNum_ = newBuff:getFinalNum() * -unit.totalAttackHarm_[self:getPos()]
		unit.totalAttackHarm_[self:getPos()] = 0

		self:updateHpByHeal(newBuff:getFinalNum(), unit)
		delBuff.fighter:recordData(0, newBuff:getFinalNum())
		saveAndDelBuff(newBuff, xyd.BUFF_WORK)
		saveAndDelBuff(delBuff, xyd.BUFF_OFF)
		self:removeBuffs({
			delBuff
		}, nil, unit)
	end

	if status.isCrit and next(self.cImpresses_) and not self:isDeath() then
		for i = #self.cImpresses_, 1, -1 do
			local buff = self.cImpresses_[i]

			if not buff then
				break
			end

			local addHarmRate = baseAddHarmRate + self:getExtraRoundHarm(buff)
			local num = buff:getFinalNum()

			if canReflect then
				unit.totalReflectHarm_[self:getPos()] = unit.totalReflectHarm_[self:getPos()] + num * (1 - reflectRate)
				num = num * reflectRate
			end

			num = num * addHarmRate
			num = self:getShieldHarm(num, unit, false, true, buff.fighter)

			buff:setRecordNum(num)
			buff.fighter:recordData(-num, 0)
			buff:delCount()
			self:updateHpByHarm(num, unit, true, false, false, buff)
			saveAndDelBuff(buff, xyd.BUFF_OFF)

			if self:isDeath() then
				break
			end
		end

		self:removeBuffs(self.cImpresses_)
	end

	if self:isExceptDotShield() and harm > 0 then
		local buff = self.isExceptDotShield_[1]

		buff:writeRecord(self, xyd.BUFF_ON)
		table.insert(recordBuffs, self.isExceptDotShield_[1])
	end

	unit:recordBuffs(self, recordBuffs)
	self:addBuffs(hitBuffs, unit)

	if self:isFreeHarm() and harm > 0 then
		self:delFreeHarmBuffCount(recordBuffs, unit, true)
	end

	if isHurt or isClearEnergy then
		self:updateEnergyByHarm(isCrit, unit, isClearEnergy)
	end

	if not isHurt and hasFullEnergyHurt then
		self:applyFullEnergyHurt(unit)
	end

	if cure > 0 then
		xyd.Battle.isCure = true
	end

	self:composeSiphonHpBuff(unit)

	return harm, cure, recordBuffs, status, inHarmTargetList
end

function ReportBaseFighter:getResistEnergy(num)
	local resists = self:getBuffsByName(xyd.BUFF_ENERGY_RESIST)
	local totalPercent = 0

	if next(resists) then
		for k, v in ipairs(resists) do
			totalPercent = totalPercent + v.finalNumArray_[1]
		end
	end

	local luobiMarks = self:getBuffsByName(xyd.BUFF_LUOBI_MARK)

	if next(luobiMarks) then
		for k, v in ipairs(luobiMarks) do
			totalPercent = totalPercent + v.finalNumArray_[1]
		end
	end

	if xyd.Battle.god and self:getTeamType() == xyd.TeamType.B then
		local bossStorms = xyd.Battle.god:getBuffsByNameAndFighter(xyd.BUFF_BOSS_STORM)

		for k, v in ipairs(bossStorms) do
			totalPercent = totalPercent + v.finalNumArray_[1]
		end
	end

	totalPercent = math_min(totalPercent, 1)

	return num * totalPercent
end

function ReportBaseFighter:composeSiphonHpBuff(unit)
	local buffs_ = unit:getBuffsRecord()
	local recordBuffs = {}
	local removeBuffIndex = {}

	for i = 1, #buffs_ do
		local buff = buffs_[i]

		if buff.name == xyd.BUFF_SIPHON_HP then
			local key = buff.f_pos .. "_" .. buff.pos

			if recordBuffs[key] ~= nil then
				recordBuffs[key].value = recordBuffs[key].value + buff.value
				removeBuffIndex[i] = true
			else
				recordBuffs[key] = buff
			end
		end
	end

	for i = #buffs_, 1, -1 do
		if removeBuffIndex[i] then
			table.remove(buffs_, i)
		end
	end
end

function ReportBaseFighter:calAllFireDmg(recordBuffs)
	local harm = 0
	local needRemove = {}

	for _, buff in ipairs(self.buffs_) do
		if buff:isFire() then
			harm = harm + buff:getFinalNum() * buff:getCount()

			table.insert(needRemove, buff)
			buff:writeRecord(self, xyd.BUFF_REMOVE)
			table.insert(recordBuffs, buff)
		end
	end

	self:removeBuffs(needRemove)

	return harm
end

function ReportBaseFighter:delSpecialBuffCount(buff)
	if self:isControlReduce() and buff:isControlNew() then
		buff:delCount()
	end
end

function ReportBaseFighter:recordBuffStatus(status, buff)
	local name = buff:getName()

	if buff:isControlNew() then
		status.isControl = true
	end

	if buff:isDebuff() then
		status.hasDebuff = true
	end

	if name == xyd.BUFF_STUN then
		status.isStun = true
	elseif name == xyd.BUFF_ICE then
		status.isIce = true
	elseif name == xyd.BUFF_FORBID then
		status.isForbid = true
	elseif name == xyd.BUFF_STONE then
		status.isStone = true
	elseif name == xyd.BUFF_DOT_BLOOD then
		status.isBlood = true

		if xyd.arrayIndexOf(xyd.Battle.bloodTargets, self) < 0 then
			table.insert(xyd.Battle.bloodTargets, self)
		end

		if self:getTeamType() == xyd.TeamType.B then
			xyd.Battle.purposes.hasBlood = 1
		end
	elseif name == xyd.BUFF_DOT_POISON or name == xyd.BUFF_M_DOT_POISON then
		if self:getTeamType() == xyd.TeamType.B then
			xyd.Battle.purposes.hasPoision = 1
		end
	elseif name == xyd.BUFF_DOT_FIRE or name == xyd.BUFF_DOT_FIRE_MAX_HP then
		status.isFire = true

		if self:getTeamType() == xyd.TeamType.B then
			xyd.Battle.purposes.hasFire = 1
		end
	elseif name == xyd.BUFF_FRIGHTEN then
		status.isFrighten = true
	elseif name == xyd.BUFF_CRYSTALLIZE or name == xyd.BUFF_CRYSTALL then
		status.isCrystall = true

		if xyd.arrayIndexOf(xyd.Battle.crystalTargets, self) < 0 and self:getTeamType() == xyd.TeamType.A then
			table.insert(xyd.Battle.crystalTargets, self)
		end
	end
end

function ReportBaseFighter:delFreeHarmBuffCount(recordBuffs, unit)
	local roundFreeHarmBuff = self:getBuffsByName(xyd.BUFF_ROUND_FREE_HARM)

	if next(roundFreeHarmBuff) then
		return
	end

	if xyd.arrayIndexOf(self.harmFreeUnit, unit) > 0 then
		return
	else
		table.insert(self.harmFreeUnit, unit)
	end

	local len = #self.isFreeHarm_
	local buff = self.isFreeHarm_[len]
	buff.finalNum_ = buff.finalNum_ - 1

	if buff.finalNum_ <= 0 then
		self:removeBuffs({
			buff
		})
		buff:writeRecord(self, xyd.BUFF_OFF)
	else
		buff:writeRecord(self, xyd.BUFF_WORK)
	end

	unit:recordPasBuffs(nil, {
		buff
	})

	if #self.isFreeHarm_ == 0 then
		self:usePasSkill(xyd.TriggerType.NO_FREE_HARM, unit)
	end
end

function ReportBaseFighter:transformBk(buff, unit)
	self:removeBuffs(self.buffs_, nil, unit)

	local fighter = buff.fighter
	self.master_ = fighter

	table.insert(fighter.fenshen_, self)

	local hero = Hero.new()

	hero:populateByHero(buff:getFinalNum(), self.hero_)

	self.oldHero_ = self.hero_
	self.hero_ = hero
	self.pasSkills_ = nil
	self.pugongID_ = nil

	self:updateHp(self:getHpLimit())

	local skillIDs = fighter:getPasSkillByType(xyd.TriggerType.FENSHEN_CREATE)
	local buffs = {}

	for _, skillID in ipairs(skillIDs) do
		local specialUnit = fighter:createAttackUnit(skillID, true, unit)
		local datas = specialUnit:getUnitDatas()

		for _, data in ipairs(datas) do
			local hitBuffs = data.hitBuffs
			buffs = xyd.arrayMerge(buffs, hitBuffs)
		end
	end

	if #buffs > 0 then
		self:addGlobalBuffs(buffs)
	end

	self.globalBuffs_ = xyd.arrayMerge(self.globalBuffs_, buffs)
end

function ReportBaseFighter:checkHurtShield(unit, hitBuffs, recordBuffs)
	local isShield = false

	for i = #hitBuffs, 1, -1 do
		local buff = hitBuffs[i]
		local isDeath_ = self:isDeath()

		if (buff:isDamage() or buff:getName() == xyd.BUFF_OVER_FLOW) and not isDeath_ then
			local shieldBuff = self:getBuffByName(xyd.BUFF_SHIELD)

			if shieldBuff then
				isShield = true
				shieldBuff.finalNum_ = shieldBuff.finalNum_ - 1

				if shieldBuff:getFinalNum() <= 0 then
					self:removeBuffs({
						shieldBuff
					})
					shieldBuff:writeRecord(self, xyd.BUFF_OFF)
					table.insert(recordBuffs, shieldBuff)
				end

				break
			end
		end
	end

	return isShield
end

function ReportBaseFighter:applyOverFlowHarm(harm, fighter)
	if math_abs(harm) > 0 then
		self:initShareBuff(harm, fighter, xyd.BUFF_HURT_SHARE)
	end
end

function ReportBaseFighter:initShareBuff(totalHarm, fighter, buffName)
	local function newBuff(target, num)
		local params = {
			target = target,
			fighter = fighter
		}
		local buff = BuffManager:newBuff(params)
		buff.isHit_ = true
		buff.name_ = buffName
		buff.preName_ = buffName
		buff.finalNum_ = num
		buff.skillID = 0

		return buff
	end

	local alive = {}

	for _, v in ipairs(self.selfTeam_) do
		if not v:isDeath() then
			table.insert(alive, v)
		end
	end

	local aliveNum = #alive

	if aliveNum <= 0 then
		aliveNum = 1
	end

	local num = math_ceil(totalHarm / aliveNum)
	local buffRecords = xyd.Battle.shareHarmBuffs

	if buffName == xyd.BUFF_ALL_HARM_SHARE then
		buffRecords = xyd.Battle.allHarmShareBuffs
	end

	for _, v in ipairs(alive) do
		if v ~= self then
			local buff = newBuff(v, num)

			table.insert(buffRecords, buff)
		end
	end

	return num
end

function ReportBaseFighter:checkControlBuff(unit)
	if self:getFree() < 1 or self:canAttack() and not self:isPugongOnly() then
		return
	end

	self:clearControlBuff(unit)
end

function ReportBaseFighter:checkBuffIsForceControl(buff)
	local name = buff:getName()

	if name == xyd.BUFF_STUN or name == xyd.BUFF_STONE or name == xyd.BUFF_ICE or name == xyd.BUFF_FORBID or name == xyd.BUFF_FRIGHTEN or name == xyd.BUFF_CRYSTALL or name == xyd.BUFF_CRYSTALLIZE or name == xyd.BUFF_WULIEER_SEAL then
		return true
	end

	return false
end

function ReportBaseFighter:isControl(name)
	if BuffTable:getDebuffType(name) == 3 then
		return true
	end

	return false
end

function ReportBaseFighter:clearControlBuff(unit)
	local buffRecords = unit:getBuffsRecord()

	for i = #buffRecords, 1, -1 do
		local record = buffRecords[i]

		if record.pos == self:getPos() and self:isControl(record.name) then
			table.remove(buffRecords, i)
			self:removeBuffByName(record.name)
		end
	end
end

function ReportBaseFighter:updateHpByDeath(harm, unit)
	if harm < 0 then
		self:recordRoundHarm(self:getPos(), -harm)
	end

	self:updateHp(0)
	self:checkSelfDie(unit)
end

function ReportBaseFighter:updateHpByHarm(harm, unit, isImpress, isDot, cannotReflect, harmBuff)
	local harmFighter = nil

	if harmBuff then
		harmFighter = harmBuff.fighter
	end

	if self:getHp() <= 0 then
		return
	end

	if not isDot and self:isExceptDotShield() then
		return
	end

	local tmpHarm = harm
	local needRemove = {}

	for _, buff in ipairs(self.isEatFreeHarm_) do
		if tmpHarm >= 0 then
			break
		end

		if buff.delayNum_ <= 0 then
			tmpHarm = tmpHarm + buff:getFinalNum()
			buff.finalNum_ = math.max(0, tmpHarm)

			if buff.finalNum_ <= 0 then
				table.insert(needRemove, buff)
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	if tmpHarm >= 0 then
		return
	end

	if harm < 0 then
		self:recordRoundHarm(self:getPos(), -harm)

		self.hitTimes_ = self.hitTimes_ + 1
	end

	local hp = self:getHp()
	local nextHp = hp + harm

	if nextHp <= 0 then
		local evt = battle_event:instance()

		evt:emit(xyd.BATTLE_EVENT_PRE_FREE_HARM, harmFighter or unit.fighter, self, unit)
	end

	if nextHp <= 0 and not self.hasDieHit_ then
		self.hasDieHit_ = true

		self:usePasSkill(xyd.TriggerType.DIE_HIT, unit)
		self:usePasSkill(xyd.TriggerType.ENEMY_DIE_HIT, unit)
	end

	local roundFreeHarmBuff = self:getBuffsByName(xyd.BUFF_ROUND_FREE_HARM)

	if next(roundFreeHarmBuff) then
		local f = harmFighter or unit.lastFighter or unit.fighter

		if f then
			f.preNoAddHarm = -harm
		end

		return
	end

	if nextHp <= 0 and self:isReviveFirstTwoEnemy() then
		local hpRate = self.isReviveFirstTwoEnemy_[1]:getFinalNum()

		self:updateHp(hpRate * self:getHpLimit())

		xyd.Battle.teamDieCount[self:getTeamType()] = xyd.Battle.teamDieCount[self:getTeamType()] + 1

		return
	end

	if xyd.arrayIndexOf(self.harmFreeUnit, unit) > 0 or self:isFreeHarm() then
		if isImpress then
			if self:isFreeHarm() then
				local buff = self.isFreeHarm_[#self.isFreeHarm_]
				buff.finalNum_ = buff.finalNum_ - 1

				if buff.finalNum_ <= 0 then
					self:removeBuffs({
						buff
					})
					buff:writeRecord(self, xyd.BUFF_OFF)

					if #self.isFreeHarm_ == 0 then
						self:usePasSkill(xyd.TriggerType.NO_FREE_HARM, unit)
					end
				else
					buff:writeRecord(self, xyd.BUFF_WORK)
				end

				unit:recordPasBuffs(nil, {
					buff
				})

				return
			end
		else
			return
		end
	end

	if self:isXTimeShield() then
		local num = self.isXTimeShield_[1].finalNum_

		if num < self.hitTimes_ then
			self.hitTimes_ = 0

			return
		end
	end

	if not cannotReflect then
		self:initHurtByReceive(harm, unit)

		if #xyd.Battle.hurtByReceiveBuffs > 0 then
			self:countHurtByReceiveBuffs(unit)
		end
	end

	self:addTotalHarm(-harm, unit, nextHp)

	xyd.Battle.oneSkillHarmRecord = xyd.Battle.oneSkillHarmRecord - harm
	nextHp = self:getHp() + harm

	if self:isDeath() then
		return
	end

	self:updateHp(nextHp)
	self:checkSelfDie(unit, harmBuff)

	if not self:isDeath() and harm < 0 then
		if xyd.arrayIndexOf(self.hurtedUnits_, unit) <= 0 then
			table.insert(self.hurtedUnits_, unit)

			if not harmBuff or harmBuff:getName() ~= xyd.BUFF_HEAL_CURSE then
				self:usePasSkill(xyd.TriggerType.HURTED, unit)

				if unit.fighter and unit.fighter:getPos() <= 12 and unit.fighter:getHpPercent() < self:getHpPercent() then
					self:usePasSkill(xyd.TriggerType.HURTED_BY_LOWER_HP, unit)
				end
			end

			local evt = battle_event:instance()

			evt:emit(xyd.BATTLE_EVENT_HURTED, harmFighter or unit.fighter, self, unit)
		elseif isImpress then
			if not harmBuff or harmBuff:getName() ~= xyd.BUFF_HEAL_CURSE then
				self:usePasSkill(xyd.TriggerType.HURTED, unit)

				if unit.fighter and unit.fighter:getPos() <= 12 and unit.fighter:getHpPercent() < self:getHpPercent() then
					self:usePasSkill(xyd.TriggerType.HURTED_BY_LOWER_HP, unit)
				end
			end

			local evt = battle_event:instance()

			evt:emit(xyd.BATTLE_EVENT_HURTED, harmFighter or unit.fighter, self, unit)
		end
	end
end

function ReportBaseFighter:initHurtByReceive(harm, unit)
	local function newBuff(target, num)
		local params = {
			target = target,
			fighter = self
		}
		local buff = BuffManager:newBuff(params)
		buff.isHit_ = true
		buff.name_ = xyd.BUFF_HURT_BY_RECEIVE
		buff.preName_ = xyd.BUFF_HURT_BY_RECEIVE
		buff.finalNum_ = num

		return buff
	end

	local target = nil
	local num = 0

	for _, v in ipairs(self.targetTeam_) do
		if target then
			break
		end

		if v:isStarMoon() then
			for _, buff in ipairs(v.isStarMoon_) do
				if buff.fighter == self then
					target = v
					num = buff.finalNum_

					break
				end
			end
		end
	end

	if target then
		num = target:getShieldHarm(num * harm, unit, false, false, self)
		local buff = newBuff(target, num)
		buff.finalNum_ = buff:calculateFinalNum(xyd.BUFF_HURT_BY_RECEIVE, num, false)

		table.insert(xyd.Battle.hurtByReceiveBuffs, buff)
	end
end

function ReportBaseFighter:countHurtByReceiveBuffs(unit)
	local buffs = xyd.Battle.hurtByReceiveBuffs
	xyd.Battle.hurtByReceiveBuffs = {}
	local recordBuffs = {}
	local targets = {}

	for _, buff in ipairs(buffs) do
		local target = buff.target
		local num = buff:getFinalNum()

		if target and not target:isDeath() and target ~= self then
			local addHarmRate = 1 + target:getExtraHarmRate(unit)
			num = num * addHarmRate

			buff:updateFinalNum(num)
			target:updateHpByHarm(num, unit, true, false, true, buff)
			buff:writeRecord(target, xyd.BUFF_WORK)
			buff.fighter:recordData(-num, 0)
			table.insert(recordBuffs, buff)
			table.insert(targets, target)
		end
	end

	unit:recordPasBuffs(nil, recordBuffs)

	for _, target in ipairs(targets) do
		if not target:isDeath() then
			target:checkHpPasSkill(unit)
		end
	end
end

function ReportBaseFighter:addTotalHarm(harm, unit, nextHp)
	self.totalHarm_ = self.totalHarm_ + harm
	self.totalHarmToEnd = self.totalHarmToEnd + harm

	if self:isXHurtDebuffRemove() then
		local num = self.isXHurtDebuffRemove_[1]:getFinalNum()

		if num <= self.totalHarm_ / self:getHpLimit() and not self:isDeath() and nextHp > 0 then
			local recordBuffs = {}
			self.totalHarm_ = 0

			self:cleanAllDebuff(unit, recordBuffs)
			unit:recordBuffs(self, recordBuffs)
			self:usePasSkill(xyd.TriggerType.SELF_REMOVE_BUFF_RESET, unit)
		end
	end
end

function ReportBaseFighter:updateHpByHeal(value, unit, noTrigger)
	self:updateHpDirect(value, unit)

	if not noTrigger then
		local evt = battle_event:instance()

		evt:emit(xyd.BATTLE_EVENT_HEAL, self, unit, value)
	end
end

function ReportBaseFighter:updateHpDirect(value, unit)
	if self:getHp() == 0 then
		return
	end

	local hp = self:getHp()

	self:updateHp(hp + value)
	self:updateMaxHpP()
end

function ReportBaseFighter:isCreatingUnits()
	if not self.unitSkills_ or self.unitSkills_:isEmptyQueue() then
		return false
	end

	return true
end

function ReportBaseFighter:checkEnergySkillLimit()
	local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_LIMIT)

	if buffs and next(buffs) then
		return true
	else
		return false
	end
end

function ReportBaseFighter:getCurrentSkill()
	if self:checkEnergySkill() then
		if self:checkEnergySkillLimit() then
			return
		else
			return self:getEnergySkillID()
		end
	end

	if self:isFrighten() then
		return
	end

	return self:getPugongID()
end

function ReportBaseFighter:getEnergySkillID()
	return self.energySkillID_
end

function ReportBaseFighter:getEnergySubSkill()
	local energySkill = self:getEnergySkillID()
	local subSkills = SkillTable:getSubSkills(energySkill)

	if #subSkills > 0 then
		return subSkills
	end

	return {}
end

function ReportBaseFighter:getPugongID()
	if xyd.Battle.atkDFlag then
		return self:getMindControlSkill2()
	end

	if #self.isMindControl_ > 0 then
		return self:getMindControlSkill()
	end

	local buff = self:getBuffByName("changeCombat", true)
	local ids = self.hero_:getSkillID(xyd.SKILL_INDEX.Pugong)
	local id = ids[1]

	if #ids > 1 then
		id = xyd.randomSelects(ids, 1)[1]
	end

	if not self.pugongID_ then
		if buff then
			local effectID = buff:getTableID()
			local nums = EffectTable:num(effectID, true)

			if #nums == 1 then
				id = nums[1]
			elseif #nums > 1 then
				self.isRandomPugong_ = true
				id = xyd.randomSelects(nums, 1)[1]
			end
		end

		self.pugongID_ = id
	elseif buff == nil then
		self.pugongID_ = id
	end

	return self.pugongID_
end

function ReportBaseFighter:getMindControlSkill()
	return 100001605
end

function ReportBaseFighter:getMindControlSkill2()
	return 200000601
end

function ReportBaseFighter:isEnergySkillCostEnergy(skillID)
	local isCost = SkillTable:isCostEnergy(skillID)

	return isCost == 0
end

function ReportBaseFighter:isAddHurtCostEnergy(skillID)
	local isCost = SkillTable:isCostEnergy(skillID)

	return isCost == 2
end

function ReportBaseFighter:isAddHurtNeedEnergy(skillID)
	if skillID <= 0 then
		return false
	end

	local isCost = SkillTable:isCostEnergy(skillID)

	return isCost >= 2
end

function ReportBaseFighter:isPugongSkill(skillID)
	if skillID then
		if skillID == self.pugongID_ or skillID == self:getMindControlSkill() then
			return true
		end

		local tableID = self:getTableID()

		if self:isGod() then
			return false
		end

		if self:isMonster() then
			tableID = xyd.tables.monsterTable:getPartnerLink(tableID)
		end

		local pugongIDs = xyd.tables.partnerTable:getAllPugongIDs(tableID)

		if not pugongIDs or #pugongIDs == 0 then
			return false
		end

		if xyd.arrayIndexOf(pugongIDs, skillID) > 0 then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isEnergySkill(skillID)
	if skillID and skillID == self.energySkillID_ then
		return true
	end

	return false
end

function ReportBaseFighter:getPasSkill()
	if self.pasSkills_ == nil then
		local skills = self.hero_:getPasSkill()
		local pasSkills = {}

		for i = 1, #skills do
			local trigger = SkillTable:trigger(skills[i])

			if not pasSkills[trigger] then
				pasSkills[trigger] = {}
			end

			table.insert(pasSkills[trigger], skills[i])
		end

		self.pasSkills_ = pasSkills
	end

	return self.pasSkills_
end

function ReportBaseFighter:addPasSkill(skills)
	local pasSkills = self:getPasSkill()

	for _, skillID in ipairs(skills) do
		local trigger = SkillTable:trigger(skillID)

		if not pasSkills[trigger] then
			pasSkills[trigger] = {}
		end

		table.insert(pasSkills[trigger], skillID)
	end
end

function ReportBaseFighter:getGroup()
	return self.hero_:getGroup()
end

function ReportBaseFighter:canAttack()
	if next(self.isStun_) then
		return false
	end

	if next(self.isIce_) then
		return false
	end

	if next(self.isStone_) then
		return false
	end

	if next(self.isAtkUnable_) then
		return false
	end

	if next(self.isCrystal_) then
		return false
	end

	if next(self.isCrystallize_) then
		return false
	end

	if next(self.isExile_) then
		return false
	end

	if next(self.isForceSeal_) then
		return false
	end

	local teleishaSealBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_SEAL)

	if next(teleishaSealBuffs) then
		return false
	end

	local enemys = self.targetTeam_ or {}
	local alives = GetTarget_.aliveTargets(enemys)

	if not next(alives) then
		return false
	end

	return true
end

function ReportBaseFighter:getFireEnemyNum()
	local num = 0

	for _, v in ipairs(self.sideTeam_) do
		if v:isDotFire() then
			num = num + 1
		end
	end

	return num
end

function ReportBaseFighter:isFireDecDmg()
	return next(self.isFireDecDmg_)
end

function ReportBaseFighter:isFireLess()
	return next(self.isFireLess_)
end

function ReportBaseFighter:isBloodLess()
	return next(self.isBloodLess_)
end

function ReportBaseFighter:isImmControlTimes()
	if next(self.isImmControlTimes_) then
		local flag = false

		for _, buff in ipairs(self.isImmControlTimes_) do
			if buff.finalNum_ > 0 then
				flag = true
				buff.finalNum_ = buff.finalNum_ - 1

				break
			end
		end

		return flag
	end

	return false
end

function ReportBaseFighter:isExile()
	return next(self.isExile_)
end

function ReportBaseFighter:isImmenu()
	return next(self.isImmenu_)
end

function ReportBaseFighter:isReflect()
	return next(self.isReflect_)
end

function ReportBaseFighter:isHalfHpDmg()
	return next(self.isHalfHpDmg_) and self:getHp() / self:getHpLimit() >= 0.5
end

function ReportBaseFighter:isHalfHpDecP()
	return next(self.isHalfHpDecP_) and self:getHp() / self:getHpLimit() < 0.5
end

function ReportBaseFighter:isAllDmgB()
	return next(self.isAllDmgB_)
end

function ReportBaseFighter:isRoundDmgB()
	return next(self.isRoundDmgB_)
end

function ReportBaseFighter:isHalfHpArm()
	return next(self.isHalfHpArm_) and self:getHp() / self:getHpLimit() < 0.5
end

function ReportBaseFighter:isReduceDot()
	return next(self.isReduceDot_)
end

function ReportBaseFighter:isExtraNoCritHarm()
	return next(self.isExtraNoCritHarm_)
end

function ReportBaseFighter:isStun()
	return next(self.isStun_)
end

function ReportBaseFighter:isDecDmgShieldLimit8()
	return next(self.isDecDmgShieldLimit8_)
end

function ReportBaseFighter:isFreeLimit1()
	return next(self.isFreeLimit1_)
end

function ReportBaseFighter:isDecHurt()
	return next(self.isDecHurt_)
end

function ReportBaseFighter:isSuperDecHurt()
	return next(self.isSuperDecHurt_)
end

function ReportBaseFighter:isRoundReflect()
	return next(self.isRoundReflect_)
end

function ReportBaseFighter:isXHurtDebuffRemove()
	return next(self.isXHurtDebuffRemove_)
end

function ReportBaseFighter:isAtkPLimit3()
	return next(self.isAtkPLimit3_)
end

function ReportBaseFighter:isHealBLimit1()
	return next(self.isHealBLimit1_)
end

function ReportBaseFighter:isCritTimeLimit3()
	return next(self.isCritTimeLimit3_)
end

function ReportBaseFighter:isYxControlRemove()
	return next(self.isYxControlRemove_)
end

function ReportBaseFighter:isHurtShieldLimit1()
	return next(self.isHurtShieldLimit1_)
end

function ReportBaseFighter:isHurtShieldLimit2()
	return next(self.isHurtShieldLimit2_)
end

function ReportBaseFighter:isHurtShieldLimit3()
	return next(self.isHurtShieldLimit3_)
end

function ReportBaseFighter:isNoHarm()
	return next(self.isNoHarm_)
end

function ReportBaseFighter:isSeal()
	local teleshaSealBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_SEAL)

	return next(self.isSeal_) or next(self.isWulieerSeal_) or next(teleshaSealBuffs)
end

function ReportBaseFighter:isForceSeal()
	return next(self.isForceSeal_)
end

function ReportBaseFighter:isAllHarmShare()
	return next(self.isAllHarmShare_)
end

function ReportBaseFighter:isTargetChange()
	return next(self.isTargetChange_)
end

function ReportBaseFighter:isMoonShadow()
	return next(self.isMoonShadow_)
end

function ReportBaseFighter:isStarMoon()
	return next(self.isStarMoon_)
end

function ReportBaseFighter:isFragranceGet()
	return next(self.isFragranceGet_)
end

function ReportBaseFighter:isFragranceAtk()
	return next(self.isFragranceAtk_)
end

function ReportBaseFighter:isFragranceDecDmg()
	return next(self.isFragranceDecDmg_)
end

function ReportBaseFighter:isDecHurtLess()
	return next(self.isDecHurtLess_)
end

function ReportBaseFighter:isHurtMaxHpLimit()
	return next(self.isHurtMaxHpLimit_)
end

function ReportBaseFighter:isNoDebuff()
	return next(self.isNoDebuff_)
end

function ReportBaseFighter:isReviveFirstTwoEnemy()
	return next(self.isReviveFirstTwoEnemy_) and xyd.Battle.teamDieCount[self:getTeamType()] < 2
end

function ReportBaseFighter:isEat()
	return next(self.isEat_)
end

function ReportBaseFighter:isEatFreeHarm()
	return next(self.isEatFreeHarm_)
end

function ReportBaseFighter:isExceptDotShield()
	return next(self.isExceptDotShield_)
end

function ReportBaseFighter:isFrighten()
	return next(self.isFrighten_)
end

function ReportBaseFighter:isIce()
	return next(self.isIce_)
end

function ReportBaseFighter:isStone()
	return next(self.isStone_)
end

function ReportBaseFighter:isRemoveControl()
	return next(self.isRemoveControl_)
end

function ReportBaseFighter:isForbidUnableClean()
	return next(self.isForbidUnableClean_)
end

function ReportBaseFighter:isControlReduce()
	return next(self.isControlReduce_)
end

function ReportBaseFighter:isGetAbsorbShield()
	return next(self.isGetAbsorbShield_)
end

function ReportBaseFighter:isGetHealCurse()
	return next(self.isGetHealCurse_)
end

function ReportBaseFighter:isGetLight()
	return next(self.isGetLight_)
end

function ReportBaseFighter:isAtkRandomTime()
	return next(self.isAtkRandomTime_)
end

function ReportBaseFighter:isDotFire()
	for _, buff in ipairs(self.isDot_) do
		if buff:getName() == xyd.BUFF_DOT_FIRE or buff:getName() == xyd.BUFF_DOT_FIRE_MAX_HP or buff:getName() == xyd.BUFF_M_DOT_FIRE then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isTear()
	return next(self.isTear_)
end

function ReportBaseFighter:isDotPoison()
	for _, buff in ipairs(self.isDot_) do
		if buff:getName() == xyd.BUFF_DOT_POISON or buff:getName() == xyd.BUFF_M_DOT_POISON then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isDotBlood()
	for _, buff in ipairs(self.isDot_) do
		if buff:getName() == xyd.BUFF_DOT_BLOOD or buff:getName() == xyd.BUFF_M_DOT_BLOOD then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isIceLess()
	if self:getBuffByName("iceless") then
		return true
	end

	return false
end

function ReportBaseFighter:isStoneLess()
	if self:getBuffByName("stoneless") then
		return true
	end

	return false
end

function ReportBaseFighter:isStunLess()
	if self:getBuffByName("stunless") then
		return true
	end

	return false
end

function ReportBaseFighter:isForbidLess()
	if self:getBuffByName("forbidless") then
		return true
	end

	return false
end

function ReportBaseFighter:isPugongOnly()
	if next(self.isForbid_) then
		return true
	end

	if next(self.isForbidUnableClean_) then
		return true
	end

	local xCanSkillBuff = self:getTeamACanSkillBuff()

	if xCanSkillBuff and not xCanSkillBuff:canSkill() then
		return true
	end

	return false
end

function ReportBaseFighter:isTransform()
	if next(self.isTransform_) then
		return true
	end

	return false
end

function ReportBaseFighter:isFreeHarm()
	if next(self.isFreeHarm_) then
		return true
	end

	return false
end

function ReportBaseFighter:isXTimeShield()
	if next(self.isXTimeShield_) then
		return true
	end

	return false
end

function ReportBaseFighter:isHurtForEnergy()
	if next(self.hurtForEnergy_) then
		return true
	end

	return false
end

function ReportBaseFighter:getUnitDatas(skillID, unit)
	local selectType = 0
	local targets = GetTarget_[selectType](self, skillID, unit)

	return targets
end

function ReportBaseFighter:isGetLeaf()
	if next(self.isGetLeaf_) then
		return true
	end

	return false
end

function ReportBaseFighter:isGetThorns()
	if next(self.isGetThorns_) then
		return true
	end

	return false
end

function ReportBaseFighter:isExchangeSpd()
	if next(self.isExchangeSpd_) then
		return true
	end

	return false
end

function ReportBaseFighter:isFullEnergyHurt()
	if next(self.isFullEnergyHurt_) then
		return true
	end

	return false
end

function ReportBaseFighter:isAbsorbDamage()
	if next(self.isAbsorbDamage_) then
		return true
	end

	return false
end

function ReportBaseFighter:getAttrByType(attrType, isRate)
	if not self.___attrCache[attrType] then
		local basic = self.hero_:getBattleAttr(attrType)

		if isRate and basic == 0 then
			basic = 1
		end

		local abs, percent = self:getBuffAttrChange(attrType)
		local result = math_max(1 + percent, 0) * basic + abs
		local factor = BuffTable:getFactor(attrType)

		if factor > 0 then
			result = result / factor
		end

		self.___attrCache[attrType] = math_max(result, 0)
	end

	return self.___attrCache[attrType]
end

function ReportBaseFighter:getHeroHp()
	return self:getAttrByType(xyd.BUFF_HP)
end

function ReportBaseFighter:getEnergyRate()
	return 1
end

function ReportBaseFighter:getAD(params)
	local final = 0
	local extraDel = 0
	local extraAdd = 0

	if next(self.isAtkDebuff_) then
		local cnt = self:getBuffCount()
		local num = self.isAtkDebuff_[1].finalNum_
		extraDel = -num * cnt
	end

	if next(self.isVanity_) then
		local cnt = #self.isVanity_
		local num = self.isVanity_[1].finalNum_
		extraAdd = num * cnt
	end

	extraAdd = extraAdd + self:getBuffTotalNumByGroup(self.isAtkPLimit3_)
	final = self:getAttrByType(xyd.BUFF_ATK) * (1 - extraDel + extraAdd)

	if xyd.Battle.round > 15 then
		final = final * (1 + (xyd.Battle.round - 15) * 0.2)
	end

	local fateWheelBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_FATE_WHEEL)

	if next(fateWheelBuffs) then
		final = final * (1 + fateWheelBuffs[1].finalNumArray_[1])
	end

	if self:getBuffByName(xyd.BUFF_GOD_CONTROL_ENERGY) and self:getEnergy() > 50 then
		final = final * 0.8
	end

	local mistletoeNewBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

	if next(mistletoeNewBuffs) then
		local decRate = math.max(0, self:getBuffTotalNumByGroup(mistletoeNewBuffs, 1))
		decRate = math.max(0, 1 - decRate)
		final = final * decRate
	end

	local exchangeAtkBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_EXCHANGE_ATK)

	if next(exchangeAtkBuffs) then
		local addNum = self:getBuffTotalNumByGroup(exchangeAtkBuffs)
		final = final + addNum
	end

	if xyd.Battle.god and (not params or not params.exceptEnemySteal) then
		local enemyStealAtkBuff = xyd.Battle.god:getBuffsByName(xyd.BUFF_ENEMY_STEAL_ATK)

		if next(enemyStealAtkBuff) then
			final = final + enemyStealAtkBuff[1]:getPosStealAtk(self)
		end
	end

	local hpPercentAtkBuff = self:getBuffsByNameAndFighter(xyd.BUFF_HP_PERCENT_ATK)

	if next(hpPercentAtkBuff) then
		local addNum = hpPercentAtkBuff[1]:getAtkRate()
		final = final * addNum
	end

	return math.max(0, final)
end

function ReportBaseFighter:getBuffCount()
	local cnt = 0

	for _, buff in ipairs(self.buffs_) do
		if buff:isBuff() then
			cnt = cnt + 1
		end
	end

	return cnt
end

function ReportBaseFighter:getAllHarmDec()
	local num = self:getAttrByType(xyd.BUFF_ALL_HARM_DEC)
	local feisinaWeak = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

	if next(feisinaWeak) then
		local dec = self:getBuffTotalNumByGroup(feisinaWeak, 1)
		num = num - dec
	end

	local magicShoot = self:getBuffsByNameAndFighter(xyd.BUFF_MAGIC_SHOOT)

	if next(magicShoot) then
		local dec = self:getBuffTotalNumByGroup(magicShoot, 2)
		num = num - dec
	end

	local allHarmDecDec = self:getBuffsByNameAndFighter(xyd.BUFF_ALL_HARM_DEC_ChANGE)

	if next(allHarmDecDec) then
		local add = 0

		for k, v in ipairs(allHarmDecDec) do
			add = add + v.recordFinalNum
		end

		num = num + add
	end

	local luobiHp = self:getBuffsByNameAndFighter(xyd.BUFF_LUOBI_HP)

	if next(luobiHp) then
		num = num + luobiHp[1]:getDefRate()
	end

	num = math_max(0, num)

	return math_min(num, 0.7)
end

function ReportBaseFighter:getHujia()
	local rate = 1

	if self:isHalfHpArm() then
		local addRate = self:getBuffTotalNumByGroup(self.isHalfHpArm_)
		rate = rate + addRate
	end

	local mistletoeBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE)

	if next(mistletoeBuffs) then
		local decRate = self:getBuffTotalNumByGroup(mistletoeBuffs, 1)
		rate = rate - decRate
	end

	local feisinaWeak = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

	if next(feisinaWeak) then
		local decRate = self:getBuffTotalNumByGroup(feisinaWeak, 1)
		rate = rate - decRate
	end

	if rate < 0 then
		rate = 0
	end

	return self:getAttrByType(xyd.BUFF_ARM) * rate
end

function ReportBaseFighter:getReduceDot()
	return self:getBuffTotalNumByGroup(self.isReduceDot_) or 0
end

function ReportBaseFighter:getShanBi()
	local shanbi = self:getAttrByType(xyd.BUFF_MISS)
	local missDelta = self:getBuffTotalNumByGroup(self.isMissLimit2_) or 0
	shanbi = shanbi - missDelta
	local mistletoeBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE)

	if next(mistletoeBuffs) then
		local decShanbi = self:getBuffTotalNumByGroup(mistletoeBuffs, 2)
		shanbi = shanbi - decShanbi
	end

	local feisinaWeak = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

	if next(feisinaWeak) then
		local decShanbi = self:getBuffTotalNumByGroup(feisinaWeak, 1)
		shanbi = shanbi - decShanbi
	end

	if shanbi < 0 then
		shanbi = 0
	end

	return shanbi
end

function ReportBaseFighter:getAvoidHurt()
	local missRate = self:getAttrByType(xyd.BUFF_AVOID_HURT)
	local feisinaMiss = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_MISS)

	if next(feisinaMiss) then
		local decShanbi = feisinaMiss[1]:getFinalNum()
		missRate = missRate + decShanbi
	end

	local feisinaWeak = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

	if next(feisinaWeak) then
		local decShanbi = self:getBuffTotalNumByGroup(feisinaWeak, 1)
		missRate = missRate - decShanbi
	end

	if missRate < 0 then
		missRate = 0
	end

	return missRate
end

function ReportBaseFighter:getCritDefRate()
	local num = self:getAttrByType(xyd.BUFF_CRIT_DEF, true)

	return math_max(0, num - 1)
end

function ReportBaseFighter:isRestraint(attacker, defender)
	if attacker:isGod() then
		return false
	end

	local attackerGroupID = attacker:getGroup()
	local acteeGroupID = defender:getGroup()
	local attackerRestraintID = GroupTable:getRestraintGroup(attackerGroupID)

	if attackerRestraintID == acteeGroupID then
		return true
	end

	return false
end

function ReportBaseFighter:getMingZhong(attacker, defender)
	local num = self:getAttrByType(xyd.BUFF_HIT)

	if self:isRestraint(attacker, defender) then
		num = num + 0.15
	end

	local extraAdd = 0
	local trueVampireBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TRUE_VAMPIRE)

	if next(trueVampireBuffs) then
		extraAdd = extraAdd + self:getBuffTotalNumByGroup(trueVampireBuffs, 3)
	end

	num = num + extraAdd
	num = math_max(num, 0)

	return num
end

function ReportBaseFighter:getMingZhongHarmRate(attacker, defender)
	local mingZhong = self:getMingZhong(attacker, defender)
	local rate = mingZhong * 0.003 * 100
	rate = math_min(rate, 0.45)

	return rate
end

function ReportBaseFighter:getCrit(defender)
	local extraAdd = 0
	local trueVampireBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TRUE_VAMPIRE)

	if next(trueVampireBuffs) then
		extraAdd = extraAdd + self:getBuffTotalNumByGroup(trueVampireBuffs, 1)
	end

	local crit = self:getAttrByType(xyd.BUFF_CRIT)
	crit = crit + extraAdd
	local noCritBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_NO_CRIT)

	if next(noCritBuffs) then
		crit = 0
	end

	if defender then
		local kawenMarkBuffs = defender:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK, self)

		for k, v in ipairs(kawenMarkBuffs) do
			crit = crit + v.finalNumArray_[1]
		end
	end

	local invisibleBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_INVISIBLE)

	if next(invisibleBuffs) then
		crit = crit + 1
	end

	return crit
end

function ReportBaseFighter:isOutBreak(skillID)
	if not self.buffOutBreak_ then
		return false
	end

	if skillID then
		if self:isPugongSkill(skillID) or self:isEnergySkill(skillID) or skillID == 5201510 or skillID == 65202210 or skillID == 75201510 or skillID == 752015011 or skillID == 752015012 or skillID == 752015013 or skillID == 752015014 or skillID == 752015015 or skillID == 75201511 or skillID == 75201512 or skillID == 75201513 or skillID == 75201514 or skillID == 75201515 then
			return true
		else
			return false
		end
	else
		return true
	end
end

function ReportBaseFighter:isRidicule()
	if self.buffRidicule_ then
		return true
	else
		return false
	end
end

function ReportBaseFighter:getUnCrit()
	return self:getAttrByType(xyd.BUFF_UNCRIT)
end

function ReportBaseFighter:getTargetHurtNum(attacker)
	local multiExRate = 0
	local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS, attacker)

	if next(buffs) then
		multiExRate = self:getBuffTotalNumByGroup(buffs, 1)
	end

	return multiExRate
end

function ReportBaseFighter:getTargetCritTime(attacker)
	local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS, attacker)
	local multiExRate = 0

	if next(buffs) then
		multiExRate = self:getBuffTotalNumByGroup(buffs, 2)
	end

	return multiExRate
end

function ReportBaseFighter:getCritTime(defender)
	local crit = self:getAttrByType(xyd.BUFF_CRIT_TIME)
	local multiExRate = 0
	multiExRate = multiExRate + self:getBuffTotalNumByGroup(self.isCritTimeBlood_)
	multiExRate = multiExRate + self:getBuffTotalNumByGroup(self.isCritTimeLimit3_)

	if self.buffOutBreak_ then
		multiExRate = multiExRate + self:getBuffTotalNumByGroup({
			self.buffOutBreak_
		})
	end

	local critAddTimes = self:getBuffsByName(xyd.BUFF_CRIT_ADD_CRIT_TIME)

	for k, v in ipairs(critAddTimes) do
		multiExRate = multiExRate + v.finalNumArray_[1] * self:getCrit(defender)
	end

	if defender then
		local kawenMarkBuffs = defender:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK, self)

		for k, v in ipairs(kawenMarkBuffs) do
			multiExRate = multiExRate + v.finalNumArray_[2]
		end
	end

	crit = crit + multiExRate

	if crit > 1.5 then
		crit = 1.5
	end

	return crit
end

function ReportBaseFighter:getExtraHealRate()
	local rate = self:getHealB()

	if xyd.Battle.round > 15 then
		rate = rate * (1 - (xyd.Battle.round - 15) * 0.2)
	end

	return math_max(rate, 0)
end

function ReportBaseFighter:getHealB()
	local num = self:getAttrByType(xyd.BUFF_HEAL_B, true)
	num = num + self:getBuffTotalNumByGroup(self.isHealBLimit1_)
	local rImpressesTreatBlockBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_TREATMENT_BLOCK)
	local rImpressesHpLimitBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_HP_LIMIT)

	if rImpressesTreatBlockBuffs and next(rImpressesTreatBlockBuffs) and (rImpressesHpLimitBuffs and next(rImpressesHpLimitBuffs) or self.rImpresses_ and next(self.rImpresses_)) then
		num = num - self:getBuffTotalNumByGroup(rImpressesTreatBlockBuffs, 1)
	end

	local mistletoeNewBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

	if next(mistletoeNewBuffs) then
		local decRate = math.max(0, self:getBuffTotalNumByGroup(mistletoeNewBuffs, 2))
		num = num - decRate
	end

	local magicShootBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_MAGIC_SHOOT)

	if next(magicShootBuffs) then
		local decRate = math.max(0, self:getBuffTotalNumByGroup(magicShootBuffs, 1))
		num = num - decRate
	end

	local timeRuleBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TIME_RULE)

	if next(timeRuleBuffs) then
		num = num + self:getBuffTotalNumByGroup(timeRuleBuffs, 1)
	end

	local lubanCBuffs = self:getBuffsByName(xyd.BUFF_LUBAN_HURT_C)

	if next(lubanCBuffs) then
		num = num - self:getBuffTotalNumByGroup(lubanCBuffs, 2)
	end

	if xyd.Battle.god and self:getTeamType() == xyd.TeamType.A and not self:isBackTarget() then
		local bossStorms = xyd.Battle.god:getBuffsByNameAndFighter(xyd.BUFF_BOSS_STORM)

		for k, v in ipairs(bossStorms) do
			num = num + v.finalNumArray_[3]
		end
	end

	local mayaHpSeals = self:getBuffsByNameAndFighter(xyd.BUFF_MAYA_HP_LOSE_SEAL)

	if next(mayaHpSeals) then
		local mayaHpSealNum = 0

		for k, v in ipairs(mayaHpSeals) do
			mayaHpSealNum = mayaHpSealNum + v.finalNumArray_[3]
		end

		if mayaHpSeals[1].finalNumArray_[4] < mayaHpSealNum then
			mayaHpSealNum = mayaHpSeals[1].finalNumArray_[4]
		end

		num = num - mayaHpSealNum
	end

	return math_max(num, 0)
end

function ReportBaseFighter:getHealI()
	local num = self:getAttrByType(xyd.BUFF_HEAL_I, true)

	return math_max(num, 0)
end

function ReportBaseFighter:getDHuJia()
	local num = self:getAttrByType(xyd.BUFF_BRK)

	return math_min(num, 1)
end

function ReportBaseFighter:getJianshang()
	local rate = self:getAttrByType(xyd.BUFF_DEC_DMG)
	local exRate = 0
	exRate = exRate + self:getBuffTotalNumByGroup(self.decDmgShield)
	exRate = exRate + self:getBuffTotalNumByGroup(self.isDecDmgNAdd_)
	exRate = exRate + self:getBuffTotalNumByGroup(self.isDecDmgBlood_)
	exRate = exRate + self:getBuffTotalNumByGroup(self.isFragranceDecDmg_)
	rate = rate + exRate
	local feisinaWeak = self:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

	if next(feisinaWeak) then
		local decRate = self:getBuffTotalNumByGroup(feisinaWeak, 1)
		rate = rate - decRate
	end

	rate = math_max(rate, 0)

	return math_min(rate, 0.7)
end

function ReportBaseFighter:getFImpress()
	if not next(self.fImpresses_) then
		return 0
	end

	local totalNum = 0

	for _, fImpBuff in ipairs(self.fImpresses_) do
		totalNum = totalNum + fImpBuff:getFinalNum()
	end

	return totalNum
end

function ReportBaseFighter:getOImpress()
	if not next(self.oImpresses_) then
		return 0
	end

	local totalNum = 0

	for _, oImpBuff in ipairs(self.oImpresses_) do
		totalNum = totalNum + oImpBuff:getFinalNum()
	end

	if totalNum > 3 then
		totalNum = 3
	end

	return totalNum
end

function ReportBaseFighter:getSklp()
	return self:getAttrByType(xyd.BUFF_SKL_P)
end

function ReportBaseFighter:getTrueAtk()
	return self:getAttrByType(xyd.BUFF_TRUE_ATK)
end

function ReportBaseFighter:getFree()
	local rate = self:getAttrByType(xyd.BUFF_FREE)
	local exRate = 0
	exRate = exRate + self:getBuffTotalNumByGroup(self.freeShield)
	exRate = exRate + self:getBuffTotalNumByGroup(self.isFreeLimit1_)
	local trueVampireBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TRUE_VAMPIRE)

	if next(trueVampireBuffs) then
		exRate = exRate + self:getBuffTotalNumByGroup(trueVampireBuffs, 2)
	end

	local timeRuleBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_TIME_RULE)

	if next(timeRuleBuffs) then
		exRate = exRate + self:getBuffTotalNumByGroup(timeRuleBuffs, 2)
	end

	local freeBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_FREE_DEC_CHANGE)

	for k, v in ipairs(freeBuffs) do
		exRate = exRate + v.freeRate
	end

	if xyd.Battle.god and self:getTeamType() == xyd.TeamType.B then
		local bossStorms = xyd.Battle.god:getBuffsByNameAndFighter(xyd.BUFF_BOSS_STORM)

		for k, v in ipairs(bossStorms) do
			exRate = exRate + v.finalNumArray_[2]
		end
	end

	rate = rate + exRate

	return rate
end

function ReportBaseFighter:getUnFree()
	local rate = self:getAttrByType(xyd.BUFF_UNFREE)
	local fateWheelBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_FATE_WHEEL)

	if next(fateWheelBuffs) then
		rate = rate + fateWheelBuffs[1].finalNumArray_[2]
	end

	local unfreeRecieveBuffs = self:getBuffsByName(xyd.BUFF_UNFREE_RECIEVE)

	for k, v in ipairs(unfreeRecieveBuffs) do
		rate = rate + v.rate
	end

	return rate
end

function ReportBaseFighter:getBuffHurtLHurtP()
	return self:getAttrByType(xyd.BUFF_HURTL_HURT_P, true)
end

function ReportBaseFighter:getTearRate()
	return self:getBuffTotalNumByGroup(self.isTear_)
end

function ReportBaseFighter:getDotAddHarmRate()
	return self:getBuffTotalNumByGroup(self.isDotB_)
end

function ReportBaseFighter:getExtraDecHarmRate(target, skillID)
	local rate = 1
	local fighterJob = self:getJob()

	local function calRate(val)
		if val >= 1 then
			val = val - 1
		end

		local tmpRate = 1 - val

		return tmpRate
	end

	if fighterJob == xyd.HeroJob.ZS then
		rate = rate * calRate(target:getAttrByType("resist_zs"))
	elseif fighterJob == xyd.HeroJob.FS then
		rate = rate * calRate(target:getAttrByType("resist_fs"))
	elseif fighterJob == xyd.HeroJob.MS then
		rate = rate * calRate(target:getAttrByType("resist_ms"))
	elseif fighterJob == xyd.HeroJob.CK then
		rate = rate * calRate(target:getAttrByType("resist_ck"))
	elseif fighterJob == xyd.HeroJob.YX then
		rate = rate * calRate(target:getAttrByType("resist_yx"))
	end

	rate = math.max(rate, 0)
	rate = math.min(rate, 1)

	return rate
end

function ReportBaseFighter:getAddHarmRate(target, skillID)
	local rate = 1

	if target:isStun() then
		rate = rate * self:getAttrByType("stunB", true)
	end

	if target:isIce() then
		rate = rate * self:getAttrByType("iceB", true)
	end

	if target:isStone() then
		rate = rate * self:getAttrByType("stoneB", true)
	end

	if target:isDotFire() then
		rate = rate * self:getAttrByType("dotFireB", true)
	end

	if target:isDotPoison() then
		rate = rate * self:getAttrByType("dotPoisonB", true)
	end

	if target:isDotBlood() then
		rate = rate * self:getAttrByType("dotBloodB", true)
	end

	local job = target:getJob()

	if job == xyd.HeroJob.ZS then
		rate = rate * self:getAttrByType("zs", true)
	elseif job == xyd.HeroJob.FS then
		rate = rate * self:getAttrByType("fs", true)
	elseif job == xyd.HeroJob.MS then
		rate = rate * self:getAttrByType("ms", true)
	elseif job == xyd.HeroJob.CK then
		rate = rate * self:getAttrByType("ck", true)
	elseif job == xyd.HeroJob.YX then
		rate = rate * self:getAttrByType("yx", true)
	end

	if self:isPugongSkill(skillID) then
		rate = rate * self:getAttrByType(xyd.BUFF_HURT_B, true)
	end

	local dmgBLimit30Buffs = self:getBuffsByNameAndFighter(xyd.BUFF_ALL_DMG_B_LIMIT30)

	if dmgBLimit30Buffs and next(dmgBLimit30Buffs) then
		local needNum = self:getBuffTotalNumByGroup(dmgBLimit30Buffs, 1)

		if needNum < -0.3 then
			needNum = -0.3
		end

		rate = rate * (1 + needNum)
	end

	return rate
end

function ReportBaseFighter:getBuffAttrChange(attrType)
	local abs = 0
	local percent = 0

	local function getBasicAttribute(buffs, fighter)
		for _, buff in ipairs(buffs) do
			if #buff.globalBuffPos <= 0 or xyd.arrayIndexOf(buff.globalBuffPos, self:getPos()) > 0 then
				local type_ = buff:getName()
				local num = buff:getFinalNum()

				if type_ == attrType or attrType == string.sub(type_, 1, -2) or attrType == string.sub(type_, 1, -4) or attrType == xyd.BUFF_ATK and type_ == xyd.BUFF_SIPHON_ATK or attrType == xyd.BUFF_ATK and type_ == xyd.BUFF_ATK_P_BK and buff:checkIsHero(fighter) or attrType == xyd.BUFF_BRK and type_ == xyd.BUFF_BRK_BK and buff:checkIsHero(fighter) or attrType == xyd.BUFF_ARM and type_ == xyd.BUFF_SIPHON_ARM or buff:isGroupBuff() and buff:checkActualType(attrType) and buff:checkHeroGroup(fighter) then
					local isPercent = BuffTable:isPercent(type_)

					if isPercent and not buff:isSiphon() then
						percent = percent + num
					else
						abs = abs + num
					end
				end
			end
		end
	end

	getBasicAttribute(self.buffs_, self)

	if self:getTeamType() == xyd.TeamType.A then
		getBasicAttribute(xyd.Battle.groupBuffA, self)
	else
		getBasicAttribute(xyd.Battle.groupBuffB, self)
	end

	getBasicAttribute(xyd.Battle.globalBuff, self)

	return abs, percent
end

function ReportBaseFighter:getName()
	return self.hero_:getName()
end

function ReportBaseFighter:getJob()
	if self:isPet() or self:isGod() then
		return 0
	end

	return self.hero_:getJob()
end

function ReportBaseFighter:isDeath()
	return self.hp_ <= 0
end

function ReportBaseFighter:isMonster()
	return self.hero_:isMonster()
end

function ReportBaseFighter:canReborn()
	if self.hasReviveMaxTime_ then
		return false
	end

	if self.hasInfRevive_ then
		return true
	end

	if next(self.isApateRevive_) then
		return false
	end

	if next(self.isRevive_) and self.hasReviveTimes_ < #self.isRevive_ then
		return true
	end

	return false
end

function ReportBaseFighter:apateSpecialReborn()
	local allDead = true

	for _, v in ipairs(self.selfTeam_) do
		if not v:isDeath() or v:canReborn() then
			allDead = false

			break
		end
	end

	if allDead then
		return false
	end

	if next(self.isApateRevive_) then
		return true
	end

	return false
end

function ReportBaseFighter:hasRebornInf()
	return self.hasInfRevive_ and not self.hasReviveMaxTime_
end

function ReportBaseFighter:ifJustReviveFromInf()
	return self.justReviveFromInf_
end

function ReportBaseFighter:setJustReviveFromInf(flag)
	self.justReviveFromInf_ = flag
end

function ReportBaseFighter:isWeak()
	if self:getBuffByName(xyd.BUFF_WEAK) then
		return true
	end

	return false
end

function ReportBaseFighter:getBuffTotalNumByName(name)
	local num = 0

	for _, buff in ipairs(self.buffs_) do
		if buff:getName() == name then
			num = num + buff:getFinalNum()
		end
	end

	return num
end

function ReportBaseFighter:getBuffTotalNumByGroup(group, index)
	local num = 0

	if not group then
		return 0
	end

	for _, buff in ipairs(group) do
		local finalNum = buff:getFinalNum(index)

		if finalNum == nil then
			print("buffname=====", buff:getName(), index)

			finalNum = 0
		end

		num = num + finalNum
	end

	return num
end

function ReportBaseFighter:getBuffTotalNumByGetLeafGroup(group, isThis)
	local num = 0

	if #group <= 0 then
		return 0
	end

	for _, buff in ipairs(group) do
		local effectNum = EffectTable:num(buff.effectID, true)

		if isThis then
			num = num + effectNum[0]
		else
			num = num - effectNum[1]
		end
	end

	return num
end

function ReportBaseFighter:getBuffByName(name, isShift)
	local buff = nil

	if isShift then
		for i = #self.buffs_, 1, -1 do
			local b = self.buffs_[i]

			if b:getName() == name then
				buff = b

				break
			end
		end
	else
		for _, b in ipairs(self.buffs_) do
			if b:getName() == name then
				buff = b

				break
			end
		end
	end

	return buff
end

function ReportBaseFighter:getBuffsByName(name)
	local result = {}

	for _, b in ipairs(self.buffs_) do
		if b:getName() == name then
			table.insert(result, b)
		end
	end

	return result
end

function ReportBaseFighter:addBuffs(buffs, unit)
	for i = 1, #buffs do
		local buff = buffs[i]
		local type_ = buff:getName()

		if buff:isStun() then
			table.insert(self.isStun_, buff)
		elseif buff:isForbid() then
			table.insert(self.isForbid_, buff)
		elseif buff:isIce() then
			table.insert(self.isIce_, buff)
		elseif buff:isStone() then
			table.insert(self.isStone_, buff)
		elseif buff:isAtkUnable() then
			table.insert(self.isAtkUnable_, buff)
		elseif type_ == xyd.BUFF_CRYSTALL then
			table.insert(self.isCrystal_, buff)
		elseif type_ == xyd.BUFF_CRYSTALLIZE then
			table.insert(self.isCrystallize_, buff)
		elseif buff:isDot() then
			table.insert(self.isDot_, buff)
		elseif buff:isDecHpLimit() then
			local limit = self:getHpLimit()
			local num = buff:getFinalNum()

			self:changeHpLimit(limit * (1 - num), true)
		elseif buff:isAddHpLimit() then
			local limit = self:getHpLimit()
			local num = buff:getFinalNum()

			self:changeHpLimit(limit * (1 + num), true)
		elseif buff:isAllDmgB() then
			table.insert(self.isAllDmgB_, buff)
		elseif type_ == xyd.BUFF_REVIVE_FIRST_TWO_ENEMY then
			table.insert(self.isReviveFirstTwoEnemy_, buff)
		elseif type_ == xyd.BUFF_TEAR_LIMIT2 then
			if #self.isTear_ <= 1 then
				table.insert(self.isTear_, buff)
			end
		elseif type_ == xyd.BUFF_MISS_LIMIT2 then
			if #self.isMissLimit2_ <= 1 then
				table.insert(self.isMissLimit2_, buff)
			end
		elseif type_ == xyd.BUFF_GET_REFLECT then
			table.insert(self.isReflect_, buff)
		elseif type_ == xyd.BUFF_HALF_HP_ARM then
			table.insert(self.isHalfHpArm_, buff)
		elseif type_ == xyd.BUFF_HALF_HP_DMG then
			table.insert(self.isHalfHpDmg_, buff)
		elseif type_ == xyd.BUFF_HALF_HP_DEC_P then
			table.insert(self.isHalfHpDecP_, buff)
		elseif type_ == xyd.BUFF_ROUND_DMG_B then
			table.insert(self.isRoundDmgB_, buff)
		elseif type_ == xyd.BUFF_AMP_HURT then
			table.insert(self.isExtraNoCritHarm_, buff)
		elseif type_ == xyd.BUFF_FORBID_NO_CLEAN then
			table.insert(self.isForbidUnableClean_, buff)
		elseif buff:isHot() then
			table.insert(self.isHot_, buff)
		elseif type_ == xyd.BUFF_IMMENU then
			table.insert(self.isImmenu_, buff)
		elseif type_ == xyd.BUFF_CONTROL_REMOVE then
			table.insert(self.isRemoveControl_, buff)
		elseif type_ == xyd.BUFF_CIMPRESS then
			table.insert(self.cImpresses_, buff)
		elseif type_ == xyd.BUFF_RIMPRESS then
			table.insert(self.rImpresses_, buff)
		elseif type_ == xyd.BUFF_OIMPRESS then
			table.insert(self.oImpresses_, buff)
		elseif type_ == xyd.BUFF_X_TIME_SHIELD then
			table.insert(self.isXTimeShield_, buff)
		elseif type_ == xyd.BUFF_DEC_DMG_SHIELD_LIMIT8 then
			table.insert(self.isDecDmgShieldLimit8_, buff)
		elseif type_ == xyd.BUFF_FREE_LIMIT1 then
			table.insert(self.isFreeLimit1_, buff)
		elseif type_ == xyd.BUFF_HURT_DEBUFF_REMOVE then
			table.insert(self.isXHurtDebuffRemove_, buff)
		elseif type_ == xyd.BUFF_ATK_P_LIMIT3 then
			table.insert(self.isAtkPLimit3_, buff)
		elseif type_ == xyd.BUFF_HEAL_B_LIMIT1 then
			table.insert(self.isHealBLimit1_, buff)
		elseif type_ == xyd.BUFF_CRIT_TIME_LIMIT3 then
			table.insert(self.isCritTimeLimit3_, buff)
		elseif type_ == xyd.BUFF_YX_CONTROL_REMOVE then
			table.insert(self.isYxControlRemove_, buff)

			if self.isYxControlRemove_[1]:getFinalNum() <= #self.isYxControlRemove_ then
				local recordBuffs = {}

				self:cleanAllControlBuffs(unit, recordBuffs)

				for _, v in ipairs(self.isYxControlRemove_) do
					v:writeRecord(self, xyd.BUFF_REMOVE)
					table.insert(recordBuffs, v)
				end

				self:removeBuffs(self.isYxControlRemove_)
				unit:recordBuffs(self, recordBuffs)
			end
		elseif type_ == xyd.BUFF_HURT_SHIELD_LIMIT1 then
			table.insert(self.isHurtShieldLimit1_, buff)
		elseif type_ == xyd.BUFF_HURT_SHIELD_LIMIT2 then
			table.insert(self.isHurtShieldLimit2_, buff)
		elseif type_ == xyd.BUFF_HURT_SHIELD_LIMIT3 then
			if #self.isHurtShieldLimit3_ < 3 then
				table.insert(self.isHurtShieldLimit3_, buff)
			end
		elseif type_ == xyd.BUFF_BIMPRESS_LIMIT30 then
			if not next(self.bImpresses_) then
				table.insert(self.bImpresses_, buff)
			end
		elseif type_ == xyd.BUFF_REVIVE or type_ == xyd.BUFF_REVIVE_INF then
			if not next(self.isApateRevive_) then
				table.insert(self.isRevive_, buff)
			end
		elseif type_ == xyd.BUFF_APATE_REVIVE then
			table.insert(self.isApateRevive_, buff)
		elseif type_ == xyd.BUFF_FIMPRESS then
			table.insert(self.fImpresses_, buff)
		elseif buff:isHeal() then
			table.insert(self.isHeal_, buff)
		elseif type_ == xyd.BUFF_MIND_CONTROL then
			table.insert(self.isMindControl_, buff)
		elseif type_ == xyd.BUFF_TRANSFORM_BK then
			table.insert(self.isTransform_, buff)
		elseif type_ == xyd.BUFF_FREE_HARM then
			table.insert(self.isFreeHarm_, buff)
		elseif type_ == xyd.BUFF_AGGRESSION then
			table.insert(self.aggressions_, buff)
		elseif type_ == xyd.BUFF_HURT_FOR_ENERGY then
			table.insert(self.hurtForEnergy_, buff)
		elseif type_ == xyd.BUFF_EAT_FREEHARM then
			table.insert(self.isEatFreeHarm_, buff)
		elseif type_ == xyd.BUFF_EAT then
			table.insert(self.isEat_, buff)
		elseif type_ == xyd.BUFF_EXCEPT_DOT_SHIELD then
			table.insert(self.isExceptDotShield_, buff)
		elseif type_ == xyd.BUFF_FIRELESS then
			table.insert(self.isFireLess_, buff)
		elseif type_ == xyd.BUFF_BLOODLESS then
			table.insert(self.isBloodLess_, buff)
		elseif type_ == xyd.BUFF_FIRE_DEC_DMG then
			table.insert(self.isFireDecDmg_, buff)
		elseif type_ == xyd.BUFF_FRIGHTEN then
			table.insert(self.isFrighten_, buff)
		elseif type_ == xyd.BUFF_DEC_DMG_SHIELD_LIMIT5 then
			if #self.decDmgShield < 5 then
				table.insert(self.decDmgShield, buff)
			end
		elseif type_ == xyd.BUFF_FREE_SHIELD_LIMIT5 then
			if #self.freeShield < 5 then
				table.insert(self.freeShield, buff)
			end
		elseif type_ == xyd.BUFF_MARK_HURT_PAS_L_B then
			if not next(self.isMarkHurtPasLB) then
				table.insert(self.isMarkHurtPasLB, buff)
			end
		elseif type_ == xyd.BUFF_REDUCE_DOT then
			table.insert(self.isReduceDot_, buff)
		elseif type_ == xyd.BUFF_MARK_HURT_SKILL_L_B then
			if not next(self.isMarkHurtSkillLB_) then
				table.insert(self.isMarkHurtSkillLB_, buff)
			end
		elseif type_ == xyd.BUFF_MARK_APATE then
			if not next(self.isMarkApate_) then
				table.insert(self.isMarkApate_, buff)
			end
		elseif type_ == xyd.BUFF_ATK_DEBUFF then
			table.insert(self.isAtkDebuff_, buff)
		elseif type_ == xyd.BUFF_VANITY then
			table.insert(self.isVanity_, buff)

			if #self.isVanity_ >= 10 and unit then
				self:usePasSkill(xyd.TriggerType.VANITY_TEN_TIMES, unit)

				for _, buff in ipairs(self.isVanity_) do
					buff:writeRecord(nil, xyd.BUFF_OFF)
				end

				unit:recordBuffs(self, self.isVanity_)
				self:removeBuffs(self.isVanity_)
			end
		elseif type_ == xyd.BUFF_EXILE then
			table.insert(self.isExile_, buff)
		elseif type_ == xyd.BUFF_DEC_DMG_N_ADD then
			if #self.isDecDmgNAdd_ <= 0 then
				table.insert(self.isDecDmgNAdd_, buff)
			end
		elseif type_ == xyd.BUFF_CRIT_TIME_BLOOD then
			table.insert(self.isCritTimeBlood_, buff)
		elseif type_ == xyd.BUFF_DEC_DMG_BLOOD then
			table.insert(self.isDecDmgBlood_, buff)
		elseif type_ == xyd.BUFF_DOT_B then
			table.insert(self.isDotB_, buff)
		elseif type_ == xyd.BUFF_CRIT_TIME_LIMIT then
			table.insert(self.isCritTimeLimit_, buff)
		elseif type_ == xyd.BUFF_DEC_HURT then
			table.insert(self.isDecHurt_, buff)
		elseif type_ == xyd.BUFF_SUPER_DEC_HURT then
			table.insert(self.isSuperDecHurt_, buff)
		elseif type_ == xyd.BUFF_ROUND_REFLECT then
			table.insert(self.isRoundReflect_, buff)
		elseif type_ == xyd.BUFF_NO_HARM then
			table.insert(self.isNoHarm_, buff)
		elseif type_ == xyd.BUFF_NO_DEBUFF then
			table.insert(self.isNoDebuff_, buff)
		elseif type_ == xyd.BUFF_SEAL then
			table.insert(self.isSeal_, buff)
		elseif type_ == xyd.BUFF_WULIEER_SEAL then
			table.insert(self.isWulieerSeal_, buff)
		elseif type_ == xyd.BUFF_HURT_MAX_HP_LIMIT then
			table.insert(self.isHurtMaxHpLimit_, buff)
		elseif type_ == xyd.BUFF_DEC_HURT_LESS then
			table.insert(self.isDecHurtLess_, buff)
		elseif type_ == xyd.BUFF_MOON_SHADOW then
			table.insert(self.isMoonShadow_, buff)
		elseif type_ == xyd.BUFF_STAR_MOON then
			table.insert(self.isStarMoon_, buff)

			buff.fighter.weiweianLinkHero_ = buff.target
		elseif type_ == xyd.BUFF_FRAGRANCE_GET then
			table.insert(self.isFragranceGet_, buff)
		elseif type_ == xyd.BUFF_FRAGRANCE_ATK then
			table.insert(self.isFragranceAtk_, buff)
		elseif type_ == xyd.BUFF_FRAGRANCE_DEC_DMG then
			table.insert(self.isFragranceDecDmg_, buff)
		elseif type_ == xyd.BUFF_MARK_FRIEND_HURT_LB then
			table.insert(self.isMarkFriendHurtLB_, buff)
		elseif type_ == xyd.BUFF_CONTROL_REDUCE then
			table.insert(self.isControlReduce_, buff)
		elseif type_ == xyd.BUFF_GET_ABSORB_SHIELD then
			table.insert(self.isGetAbsorbShield_, buff)
		elseif type_ == xyd.BUFF_GET_HEAL_CURSE then
			table.insert(self.isGetHealCurse_, buff)
		elseif type_ == xyd.BUFF_GET_LIGHT or type_ == xyd.BUFF_ADD_GET_LIGHT then
			table.insert(self.isGetLight_, buff)

			if #self.isGetLight_ >= 2 and unit then
				buff.fighter:usePasSkill(xyd.TriggerType.LIGHT_GET_TWO, unit)

				for _, buff in ipairs(self.isGetLight_) do
					buff:writeRecord(nil, xyd.BUFF_OFF)
				end

				unit:recordBuffs(self, self.isGetLight_)
				self:removeBuffs(self.isGetLight_)
			end
		elseif type_ == xyd.BUFF_ATK_RANDOM_TIME then
			table.insert(self.isAtkRandomTime_, buff)
		elseif type_ == xyd.BUFF_MARK_ADD_HURT_FREE_ARM then
			table.insert(self.isMarkAddHurtFreeArm_, buff)
		elseif type_ == xyd.BUFF_MARK_ADD_HURT then
			table.insert(self.isMarkAddHurt_, buff)
		elseif type_ == xyd.BUFF_GET_LEAF then
			if self:isGetLeaf() == false then
				table.insert(self.isGetLeaf_, buff)
			else
				self.isGetLeaf_[1] = buff
			end
		elseif type_ == xyd.BUFF_GET_THORNS then
			table.insert(self.isGetThorns_, buff)

			local pasSkillID = buff.finalNum_

			self:addPasSkill({
				pasSkillID
			})
		elseif type_ == xyd.BUFF_EXCHANGE_SPD then
			if buff.finalNum_ ~= 0 then
				table.insert(self.isExchangeSpd_, buff)
			end
		elseif type_ == xyd.BUFF_SPD_STEAL then
			table.insert(self.isSpdSteal_, buff)
		elseif type_ == xyd.BUFF_ALL_HARM_SHARE then
			table.insert(self.isAllHarmShare_, buff)
		elseif type_ == xyd.BUFF_FORCE_SEAL then
			table.insert(self.isForceSeal_, buff)
		elseif type_ == xyd.BUFF_TARGET_CHANGE then
			table.insert(self.isTargetChange_, buff)
		elseif type_ == xyd.BUFF_FULL_ENERGY_HURT then
			table.insert(self.isFullEnergyHurt_, buff)
		elseif type_ == xyd.BUFF_REDUCE_SPD then
			if #self.isReduceSpd_ < 5 then
				table.insert(self.isReduceSpd_, buff)
			else
				local minBuff = buff
				local minNum = buff:getFinalNum()

				for _, buff_ in ipairs(self.isReduceSpd_) do
					if buff_:getFinalNum() < minNum then
						minNum = buff_:getFinalNum()
						minBuff = buff_
					end
				end

				if minBuff ~= buff then
					buff:writeRecord(self, xyd.BUFF_ON)
					minBuff:writeRecord(self, xyd.BUFF_OFF)

					if unit ~= nil then
						unit:recordPasBuffs(self, {
							buff,
							minBuff
						})
					end

					self:removeBuffs({
						minBuff
					})
				end
			end
		elseif type_ == xyd.BUFF_ABSORB_DAMAGE then
			if not self.hasAbsorbDamage then
				table.insert(self.isAbsorbDamage_, buff)

				self.hasAbsorbDamage = true
			end
		elseif type_ == xyd.BUFF_XIFENG_SPD then
			table.insert(self.isXifengSpd_, buff)
		elseif type_ == xyd.BUFF_COMMON_EXHURT then
			table.insert(self.commonExHurtBuffs_, buff)
		elseif type_ == xyd.BUFF_TRUE_VAMPIRE then
			table.insert(self.isBloodLess_, buff)
			self:addBuffToLists({
				buff
			})
		else
			self:addBuffToLists({
				buff
			})
		end

		if type_ == xyd.BUFF_SIPHON_ATK then
			type_ = xyd.BUFF_ATK
		elseif type_ == xyd.BUFF_SIPHON_ARM then
			type_ = xyd.BUFF_ARM
		end

		self:clearAttrCache(type_)

		if buff:isDebuff() and unit and xyd.Battle.hasAllInited and not buff:isEndLoop() then
			xyd.Battle.lastDebuff = buff

			self:usePasSkill(xyd.TriggerType.STARMOON_SELF_DEBUFF, unit)
		end

		table.insert(self.buffs_, buff)

		if unit and xyd.Battle.hasAllInited then
			if not buff:isControlNew() and buff:isDebuff() then
				self:usePasSkill(xyd.TriggerType.SELF_UNCONTROL_DEBUFF, unit)
			end

			if buff:isDot() then
				self:usePasSkill(xyd.TriggerType.SELF_DOT, unit)
			end

			if buff:isImpressNew() then
				self:usePasSkill(xyd.TriggerType.SELF_IMPRESSED, unit)
			end
		end
	end
end

function ReportBaseFighter:addGlobalBuffs(buffs)
	for i = 1, #buffs do
		local buff = buffs[i]
		local type_ = buff:getName()

		if type_ == xyd.BUFF_SIPHON_ATK or type_ == xyd.BUFF_ATK_P_BK then
			type_ = xyd.BUFF_ATK
		elseif type_ == xyd.BUFF_SIPHON_ARM then
			type_ = xyd.BUFF_ARM
		elseif type_ == xyd.BUFF_BRK_BK then
			type_ = xyd.BUFF_BRK
		end

		for _, v in ipairs(xyd.Battle.team) do
			v:clearAttrCache(type_)
		end

		table.insert(xyd.Battle.globalBuff, buff)
	end
end

function ReportBaseFighter:clearAttrCache(name)
	if self.___attrCache[name] then
		self.___attrCache[name] = nil
	end

	if self.___attrCache[name] then
		self.___attrCache[name] = nil
	end

	if self.___attrCache[string.sub(name, 1, -2)] then
		self.___attrCache[string.sub(name, 1, -2)] = nil
	end

	if self.___attrCache[string.sub(name, 1, -4)] then
		self.___attrCache[string.sub(name, 1, -4)] = nil
	end

	if name == xyd.BUFF_SPD then
		self.___ackSpeed = nil
		xyd.Battle.ackSpeedFlag = false
	end

	if name == xyd.BUFF_EXCHANGE_SPD or name == xyd.BUFF_SPD_STEAL or name == xyd.BUFF_REDUCE_SPD or name == xyd.BUFF_XIFENG_SPD then
		self.___ackSpeed = nil
		xyd.Battle.ackSpeedFlag = false
	end
end

function ReportBaseFighter:removeAllBuffByName(name)
	for i = #self.buffs_, 1, -1 do
		local buff = self.buffs_[i]

		if buff:getName() == name then
			self:removeBuffs({
				buff
			})
		end
	end
end

function ReportBaseFighter:removeBuffByName(name)
	for i = #self.buffs_, 1, -1 do
		local buff = self.buffs_[i]

		if buff:getName() == name then
			self:removeBuffs({
				buff
			})

			break
		end
	end
end

function ReportBaseFighter:exlodedBuffs(unit, recordBuffs)
	local needRemove = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isBuff() and buff:ifCanClean() and name_ ~= xyd.BUFF_REVIVE and name_ ~= xyd.BUFF_REVIVE_INF then
			table.insert(needRemove, buff)
			buff:writeRecord(self, xyd.BUFF_REMOVE)
			table.insert(recordBuffs, buff)
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	return #needRemove
end

function ReportBaseFighter:changeFireCount(delta, recordBuffs)
	local needRemove = {}

	for _, buff_ in ipairs(self.buffs_) do
		if buff_:isFire() then
			local count = buff_.leftCount_
			local finalCount = count + delta
			finalCount = math.max(finalCount, 0)

			buff_:setLeftCount(finalCount)

			if finalCount <= 0 then
				table.insert(needRemove, buff_)
				buff_:writeRecord(self, xyd.BUFF_REMOVE)
				table.insert(recordBuffs, buff_)
			end
		end
	end

	self:removeBuffs(needRemove)
end

function ReportBaseFighter:exchangeSpeed(buff, recordBuffs)
	local function param(buff, fighter, target)
		return {
			effectID = buff.effectID,
			fighter = fighter,
			target = target,
			skillID = buff.skillID
		}
	end

	local newBuff1 = BuffManager:newBuff(param(buff, buff.fighter, buff.target))
	local newBuff2 = BuffManager:newBuff(param(buff, buff.target, buff.fighter))
	local target = buff.target
	local fighter = buff.fighter
	newBuff1.finalNum_ = target:getAckSpeed() - fighter:getAckSpeed()
	newBuff2.finalNum_ = -newBuff1.finalNum_

	fighter:addBuffs({
		newBuff1
	})
	target:addBuffs({
		newBuff2
	})
	newBuff1:writeRecord(self, xyd.BUFF_ON)
	newBuff2:writeRecord(target, xyd.BUFF_ON)
	table.insert(recordBuffs, newBuff1)
	table.insert(recordBuffs, newBuff2)
end

function ReportBaseFighter:spdSteal(buff, recordBuffs)
	local newBuff = BuffManager:newBuff({
		effectID = buff.effectID,
		fighter = buff.fighter,
		target = buff.fighter,
		skillID = buff.skillID
	})
	newBuff.finalNum_ = -buff.finalNum_

	newBuff:writeRecord(buff.fighter, xyd.BUFF_ON)
	buff.fighter:addBuffs({
		newBuff
	})
	table.insert(recordBuffs, newBuff)
end

function ReportBaseFighter:cleanAllControlBuffs(unit, recordBuffs)
	local allControlBuffs = {}
	local needRemove = {}
	local controlBuffNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()
		local finalNum = buff:getFinalNum()

		if buff:isControlNew() and buff:ifCanClean() then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				if not allControlBuffs[actual_buff] then
					allControlBuffs[actual_buff] = {}

					table.insert(controlBuffNames, actual_buff)
				end

				table.insert(allControlBuffs[actual_buff], buff)
			end
		end
	end

	if #controlBuffNames > 0 then
		for _, buffName in ipairs(controlBuffNames) do
			local selectDBuffs = allControlBuffs[buffName]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					self:cleanOneBuff(needRemove, recordBuffs, buff, unit)
				end
			end
		end
	end

	self:removeBuffs(needRemove)

	return #needRemove
end

function ReportBaseFighter:cleanAllDebuff(unit, recordBuffs)
	local allDbuffs = {}
	local needRemove = {}
	local dBuffNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isDebuff() and buff:ifCanClean() then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				if not allDbuffs[actual_buff] then
					allDbuffs[actual_buff] = {}

					table.insert(dBuffNames, actual_buff)
				end

				table.insert(allDbuffs[actual_buff], buff)
			end
		end
	end

	if #dBuffNames > 0 then
		for _, buffName in ipairs(dBuffNames) do
			local selectDBuffs = allDbuffs[buffName]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					self:cleanOneBuff(needRemove, recordBuffs, buff, unit)
				end
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	return #needRemove
end

function ReportBaseFighter:cleanOneBuff(needRemove, recordBuffs, buff, unit)
	table.insert(needRemove, buff)
	buff:writeRecord(self, xyd.BUFF_REMOVE)
	table.insert(recordBuffs, buff)
end

function ReportBaseFighter:transMultiDebuff(unit, recordBuffs, num)
	local function copyBuff(buff, target)
		local params = {
			effectID = buff.effectID,
			fighter = buff.fighter,
			target = target,
			skillID = buff.skillID,
			index = buff.skillIndex
		}
		local newBuff = BuffManager:newBuff(params)

		if newBuff:isBuffLess() then
			newBuff.isFree_ = true
			newBuff.isHit_ = 0
		elseif newBuff:isBuffLimit() then
			newBuff.isHit_ = 0
		else
			newBuff.isHit_ = 1
		end

		newBuff.finalNum_ = buff.finalNum_
		local tmpArray = {}

		for i = 1, #buff.finalNumArray_ do
			tmpArray[i] = buff.finalNumArray_[i]
		end

		newBuff.finalNumArray_ = tmpArray

		newBuff:setLeftCount(buff:getCount())

		return newBuff
	end

	local allControlBuffs = {}
	local allControlBuffNames = {}
	local allDebuffs = {}
	local allDebuffNames = {}
	local needRemove = {}

	for _, buff in ipairs(self.buffs_) do
		if buff:ifCanClean() then
			if buff:isControlNew() then
				local actual_buff = buff:getActualBuff()

				if actual_buff ~= nil then
					if not allControlBuffs[actual_buff] then
						allControlBuffs[actual_buff] = {}

						table.insert(allControlBuffNames, actual_buff)
					end

					table.insert(allControlBuffs[actual_buff], buff)
				end
			elseif buff:isDebuff() then
				local actual_buff = buff:getActualBuff()

				if actual_buff ~= nil then
					if not allDebuffs[actual_buff] then
						allDebuffs[actual_buff] = {}

						table.insert(allDebuffNames, actual_buff)
					end

					table.insert(allDebuffs[actual_buff], buff)
				end
			end
		end
	end

	while num > 0 do
		if #allControlBuffNames > 0 then
			local selectIndexes = xyd.randomSelects(allControlBuffNames, num)
			num = num - #selectIndexes

			for _, selectIndex in ipairs(selectIndexes) do
				local selectDBuffs = allControlBuffs[selectIndex]

				if next(selectDBuffs) then
					for _, buff in ipairs(selectDBuffs) do
						local target = GetTarget_.noControlFirst(self)

						if target then
							local newBuff = copyBuff(buff, target)

							if newBuff.isHit_ == 1 then
								newBuff:writeRecord(target, xyd.BUFF_ON)
								table.insert(recordBuffs, newBuff)
								target:addBuffs({
									newBuff
								}, unit)
							elseif newBuff.isHit_ == 0 and newBuff.isFree_ then
								local tmpBuff = BuffManager:newBuff({
									isFree = true,
									target = target
								})

								tmpBuff:writeRecord(target, xyd.BUFF_ON)
								table.insert(recordBuffs, tmpBuff)
							end

							table.insert(needRemove, buff)
							buff:writeRecord(self, xyd.BUFF_REMOVE)
							table.insert(recordBuffs, buff)
						end
					end
				end
			end

			allControlBuffNames = {}
		elseif #allDebuffNames > 0 then
			local selectIndexes = xyd.randomSelects(allDebuffNames, num)
			num = num - #selectIndexes

			for _, selectIndex in ipairs(selectIndexes) do
				local selectDBuffs = allDebuffs[selectIndex]

				if next(selectDBuffs) then
					for _, buff in ipairs(selectDBuffs) do
						local target = GetTarget_.noDebuffFirst(self)

						if target then
							local newBuff = copyBuff(buff, target)

							if newBuff.isHit_ == 1 then
								newBuff:writeRecord(target, xyd.BUFF_ON)
								table.insert(recordBuffs, newBuff)
								target:addBuffs({
									newBuff
								}, unit)
							elseif newBuff.isHit_ == 0 and newBuff.isFree_ then
								local tmpBuff = BuffManager:newBuff({
									isFree = true,
									target = target
								})

								tmpBuff:writeRecord(target, xyd.BUFF_ON)
								table.insert(recordBuffs, tmpBuff)
							end

							table.insert(needRemove, buff)
							buff:writeRecord(self, xyd.BUFF_REMOVE)
							table.insert(recordBuffs, buff)
						end
					end
				end
			end

			allDebuffNames = {}
		else
			break
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	return #needRemove
end

function ReportBaseFighter:transDebuff(unit, recordBuffs, num)
	local function copyBuff(buff, fighter, target)
		local params = {
			effectID = buff.effectID,
			fighter = fighter,
			target = target,
			skillID = buff.skillID,
			index = buff.skillIndex
		}
		local newBuff = BuffManager:newBuff(params)
		newBuff.isHit_ = 1
		newBuff.finalNum_ = buff.finalNum_
		local tmpArray = {}

		for i = 1, #buff.finalNumArray_ do
			tmpArray[i] = buff.finalNumArray_[i]
		end

		newBuff.finalNumArray_ = tmpArray

		newBuff:setLeftCount(buff:getCount() + num)

		return newBuff
	end

	local allDbuffs = {}
	local needRemove = {}
	local dBuffNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isDebuff() and not buff.isYongjiu_ then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				if not allDbuffs[actual_buff] then
					allDbuffs[actual_buff] = {}

					table.insert(dBuffNames, actual_buff)
				end

				table.insert(allDbuffs[actual_buff], buff)
			end
		end
	end

	if #dBuffNames > 0 then
		for _, buffName in ipairs(dBuffNames) do
			local selectDBuffs = allDbuffs[buffName]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					local target = GetTarget_.S18(self, 1)[1]

					if not target then
						return
					end

					local tmpBuff = copyBuff(buff, self, target)

					target:addBuffs({
						tmpBuff
					}, unit)
					table.insert(needRemove, buff)
					buff:writeRecord(self, xyd.BUFF_REMOVE)
					table.insert(recordBuffs, tmpBuff)
					table.insert(recordBuffs, buff)
					tmpBuff:writeRecord(target, xyd.BUFF_ON)
				end
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)
end

function ReportBaseFighter:changeDebuffWithoutDOT(unit, recordBuffs, hitBuff)
	local function newChangeBuff(changeSkillID)
		local effects = SkillTable:getEffect(changeSkillID, 1)
		local effectID = effects[1]
		local params = {
			index = 1,
			effectID = effectID,
			fighter = self,
			target = self,
			skillID = changeSkillID
		}
		local newBuff = BuffManager:newBuff(params)
		newBuff.isHit_ = 1

		newBuff:calculate()

		return newBuff
	end

	local prob = hitBuff:getFinalNum(1)
	prob = math.min(prob, 1)
	local changeSkillID = hitBuff:getFinalNum(2)
	local allDbuffs = {}
	local needRemove = {}
	local needAdd = {}
	local dBuffNames = {}
	local changeCount = 0

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isDebuff() and not buff:isDot() and buff:ifCanClean() then
			local actualBuff = buff:getActualBuff()

			if actualBuff ~= nil then
				if not allDbuffs[actualBuff] then
					allDbuffs[actualBuff] = {}

					table.insert(dBuffNames, actualBuff)
				end

				table.insert(allDbuffs[actualBuff], buff)
			end
		end
	end

	if #dBuffNames > 0 then
		for _, buffName in ipairs(dBuffNames) do
			local selectDBuffs = allDbuffs[buffName]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					if changeCount >= 3 then
						break
					end

					local isChangeHit = xyd.weightedChoise({
						prob,
						1 - prob
					}) == 1

					if isChangeHit then
						changeCount = changeCount + 1
						local tmpBuff = newChangeBuff(changeSkillID)

						table.insert(recordBuffs, tmpBuff)
						table.insert(needAdd, tmpBuff)
						tmpBuff:writeRecord(self, xyd.BUFF_ON)
						buff:writeRecord(self, xyd.BUFF_REMOVE)
						table.insert(needRemove, buff)
						table.insert(recordBuffs, buff)
						self:usePasSkill(xyd.TriggerType.GET_SUCK_REAL_BLOOD, unit)
					end
				end
			end

			if changeCount >= 3 then
				break
			end
		end
	end

	self:addBuffs(needAdd, unit)
	self:removeBuffs(needRemove, nil, unit)
end

function ReportBaseFighter:isControl()
	for _, buff in ipairs(self.buffs_) do
		if buff:isControlNew() then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isHasDebuff()
	for _, buff in ipairs(self.buffs_) do
		if buff:isDebuff() then
			return true
		end
	end

	return false
end

function ReportBaseFighter:cleanMultiBuff(unit, recordBuffs, num)
	local allBuffs = {}
	local needRemove = {}
	local buffNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isBuff() and buff:ifCanClean() then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				if not allBuffs[actual_buff] then
					allBuffs[actual_buff] = {}

					table.insert(buffNames, actual_buff)
				end

				table.insert(allBuffs[actual_buff], buff)
			end
		end
	end

	if #buffNames > 0 then
		local selectIndexes = xyd.randomSelects(buffNames, num)

		for _, selectIndex in ipairs(selectIndexes) do
			local selectDBuffs = allBuffs[selectIndex]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					self:cleanOneBuff(needRemove, recordBuffs, buff, unit)
				end
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	return #needRemove
end

function ReportBaseFighter:cleanMultiDebuff(unit, recordBuffs, num)
	local allDbuffs = {}
	local needRemove = {}
	local dBuffNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()

		if buff:isDebuff() and buff:ifCanClean() then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				if not allDbuffs[actual_buff] then
					allDbuffs[actual_buff] = {}

					table.insert(dBuffNames, actual_buff)
				end

				table.insert(allDbuffs[actual_buff], buff)
			end
		end
	end

	if #dBuffNames > 0 then
		local selectIndexes = xyd.randomSelects(dBuffNames, num)

		for _, selectIndex in ipairs(selectIndexes) do
			local selectDBuffs = allDbuffs[selectIndex]

			if next(selectDBuffs) then
				for _, buff in ipairs(selectDBuffs) do
					self:cleanOneBuff(needRemove, recordBuffs, buff, unit)
				end
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)

	return #needRemove
end

function ReportBaseFighter:getBuffListByName(buffName)
	return self.recordBuffLists_[buffName] or {}
end

function ReportBaseFighter:addBuffToLists(buffs, buffType)
	for i = 1, #buffs do
		local buff = buffs[i]
		local buffName = buff:getName()

		if buffType then
			buffName = buffType
		end

		if not self.recordBuffLists_[buffName] then
			self.recordBuffLists_[buffName] = {}
		end

		table.insert(self.recordBuffLists_[buffName], buff)
	end
end

function ReportBaseFighter:removeBuffs(buffs, noRemoves, unit)
	noRemoves = noRemoves or {}

	for i = #buffs, 1, -1 do
		local buff = buffs[i]

		if buff and xyd.arrayIndexOf(noRemoves, buff:getName()) < 0 then
			local buffName = buff:getName()

			table.removebyvalue(self.buffs_, buff)
			table.removebyvalue(self.isForbid_, buff)
			table.removebyvalue(self.isStun_, buff)
			table.removebyvalue(self.isCrystal_, buff)
			table.removebyvalue(self.isCrystallize_, buff)
			table.removebyvalue(self.isEat_, buff)
			table.removebyvalue(self.isEatFreeHarm_, buff)
			table.removebyvalue(self.isExceptDotShield_, buff)
			table.removebyvalue(self.isIce_, buff)
			table.removebyvalue(self.isDot_, buff)
			table.removebyvalue(self.isTear_, buff)
			table.removebyvalue(self.isMissLimit2_, buff)
			table.removebyvalue(self.isHot_, buff)
			table.removebyvalue(self.isHeal_, buff)
			table.removebyvalue(self.isStone_, buff)
			table.removebyvalue(self.isRemoveControl_, buff)
			table.removebyvalue(self.cImpresses_, buff)
			table.removebyvalue(self.rImpresses_, buff)
			table.removebyvalue(self.fImpresses_, buff)
			table.removebyvalue(self.oImpresses_, buff)
			table.removebyvalue(self.isXTimeShield_, buff)
			table.removebyvalue(self.bImpresses_, buff)
			table.removebyvalue(self.isRevive_, buff)
			table.removebyvalue(self.isMindControl_, buff)
			table.removebyvalue(self.isTransform_, buff)
			table.removebyvalue(self.isFreeHarm_, buff)
			table.removebyvalue(self.aggressions_, buff)
			table.removebyvalue(self.hurtForEnergy_, buff)
			table.removebyvalue(self.isFireLess_, buff)
			table.removebyvalue(self.isBloodLess_, buff)
			table.removebyvalue(self.isFireDecDmg_, buff)
			table.removebyvalue(self.isFrighten_, buff)
			table.removebyvalue(self.decDmgShield, buff)
			table.removebyvalue(self.freeShield, buff)
			table.removebyvalue(self.isMarkHurtPasLB, buff)
			table.removebyvalue(self.isMarkHurtSkillLB_, buff)
			table.removebyvalue(self.isAtkDebuff_, buff)
			table.removebyvalue(self.isVanity_, buff)
			table.removebyvalue(self.isExile_, buff)
			table.removebyvalue(self.isDecDmgNAdd_, buff)
			table.removebyvalue(self.isCritTimeBlood_, buff)
			table.removebyvalue(self.isDecDmgBlood_, buff)
			table.removebyvalue(self.isDotB_, buff)
			table.removebyvalue(self.isCritTimeLimit_, buff)
			table.removebyvalue(self.isExtraNoCritHarm_, buff)
			table.removebyvalue(self.isImmenu_, buff)
			table.removebyvalue(self.isReflect_, buff)
			table.removebyvalue(self.isReduceDot_, buff)
			table.removebyvalue(self.isHalfHpArm_, buff)
			table.removebyvalue(self.isAllDmgB_, buff)
			table.removebyvalue(self.isRoundDmgB_, buff)
			table.removebyvalue(self.isDecDmgShieldLimit8_, buff)
			table.removebyvalue(self.isFreeLimit1_, buff)
			table.removebyvalue(self.isXHurtDebuffRemove_, buff)
			table.removebyvalue(self.isAtkPLimit3_, buff)
			table.removebyvalue(self.isHealBLimit1_, buff)
			table.removebyvalue(self.isCritTimeLimit3_, buff)
			table.removebyvalue(self.isYxControlRemove_, buff)
			table.removebyvalue(self.isHurtShieldLimit1_, buff)
			table.removebyvalue(self.isHurtShieldLimit2_, buff)
			table.removebyvalue(self.isHurtShieldLimit3_, buff)
			table.removebyvalue(self.isDecHurt_, buff)
			table.removebyvalue(self.isSuperDecHurt_, buff)
			table.removebyvalue(self.isRoundReflect_, buff)
			table.removebyvalue(self.isNoHarm_, buff)
			table.removebyvalue(self.isNoDebuff_, buff)
			table.removebyvalue(self.isReviveFirstTwoEnemy_, buff)
			table.removebyvalue(self.isSeal_, buff)
			table.removebyvalue(self.isWulieerSeal_, buff)
			table.removebyvalue(self.isHurtMaxHpLimit_, buff)
			table.removebyvalue(self.isDecHurtLess_, buff)
			table.removebyvalue(self.isForbidUnableClean_, buff)
			table.removebyvalue(self.isMoonShadow_, buff)
			table.removebyvalue(self.isStarMoon_, buff)
			table.removebyvalue(self.isFragranceGet_, buff)
			table.removebyvalue(self.isFragranceAtk_, buff)
			table.removebyvalue(self.isFragranceDecDmg_, buff)
			table.removebyvalue(self.isMarkFriendHurtLB_, buff)
			table.removebyvalue(self.isControlReduce_, buff)
			table.removebyvalue(self.isGetAbsorbShield_, buff)
			table.removebyvalue(self.isGetHealCurse_, buff)
			table.removebyvalue(self.isGetLight_, buff)
			table.removebyvalue(self.isAtkRandomTime_, buff)
			table.removebyvalue(self.isMarkAddHurtFreeArm_, buff)
			table.removebyvalue(self.isMarkAddHurt_, buff)
			table.removebyvalue(self.isAllHarmShare_, buff)
			table.removebyvalue(self.isTargetChange_, buff)
			table.removebyvalue(self.isForceSeal_, buff)
			table.removebyvalue(self.isGetLeaf_, buff)
			table.removebyvalue(self.isGetThorns_, buff)
			table.removebyvalue(self.isExchangeSpd_, buff)
			table.removebyvalue(self.isFullEnergyHurt_, buff)
			table.removebyvalue(self.isMarkApate_, buff)
			table.removebyvalue(self.isApateRevive_, buff)
			table.removebyvalue(self.isReduceSpd_, buff)
			table.removebyvalue(self.isSpdSteal_, buff)
			table.removebyvalue(self.isAbsorbDamage_, buff)
			table.removebyvalue(self.commonExHurtBuffs_, buff)

			if self.buffRidicule_ == buff then
				self.buffRidicule_ = nil
			end

			if self.buffOutBreak_ == buff then
				self.buffOutBreak_ = nil
			end

			if self.recordBuffLists_[buffName] then
				table.removebyvalue(self.recordBuffLists_[buffName], buff)
			end

			local type_ = buff:getName()

			if type_ == xyd.BUFF_SIPHON_ATK then
				type_ = xyd.BUFF_ATK
			elseif type_ == xyd.BUFF_SIPHON_ARM then
				type_ = xyd.BUFF_ARM
			elseif type_ == xyd.BUFF_WULIEER_SEAL and unit then
				local params2 = {
					effectID = buff.finalNum_,
					fighter = buff.fighter,
					target = self
				}
				local newBuff2 = BuffManager:newBuff(params2)
				newBuff2.isHit_ = 1

				newBuff2:calculate()
				self:updateHpByHarm(newBuff2.finalNum_, unit, false, false, false, newBuff2)
				buff.fighter:recordData(-newBuff2.finalNum_, 0)
				newBuff2:writeRecord(self, xyd.BUFF_WORK)
				unit:recordBuffs(self, {
					newBuff2
				})
			end

			if type_ == xyd.BUFF_GET_THORNS then
				local skillIDs = self:getPasSkillByType(xyd.TriggerType.SELF_ATTACKED_WITH_THORNS)

				for i = 1, #skillIDs do
					if buff.finalNum_ == skillIDs[i] then
						table.remove(skillIDs, i)

						break
					end
				end
			end

			self:clearAttrCache(type_)
		end
	end
end

function ReportBaseFighter:removeGlobalBuffs()
	for i = #self.globalBuffs_, 1, -1 do
		local buff = self.globalBuffs_[i]

		table.removebyvalue(xyd.Battle.globalBuff, buff)

		local type_ = buff:getName()

		if type_ == xyd.BUFF_SIPHON_ATK or type_ == xyd.BUFF_ATK_P_BK then
			type_ = xyd.BUFF_ATK
		elseif type_ == xyd.BUFF_SIPHON_ARM then
			type_ = xyd.BUFF_ARM
		elseif type_ == xyd.BUFF_BRK_BK then
			type_ = xyd.BUFF_BRK
		end

		for _, v in ipairs(xyd.Battle.team) do
			v:clearAttrCache(type_)
		end
	end

	self.globalBuffs_ = {}
end

function ReportBaseFighter:checkEnergySkill()
	if self.isEnergyQueue_ then
		return true
	end

	if self.energy_ < self:getEnergySkillNeed() then
		return false
	elseif self:isPugongOnly() then
		return false
	elseif self.isPassiveQuene_ then
		return false
	elseif self:isTransform() then
		return false
	elseif #self.isMindControl_ > 0 then
		return false
	elseif self.energySkillID_ == 0 or not self.energySkillID_ then
		return false
	end

	return true
end

function ReportBaseFighter:getEnergySkillNeed()
	return xyd.Battle.ENERGY_DEFAULT
end

function ReportBaseFighter:updateBuffCount(unit)
	self.selectEnemy = nil

	if self:isExile() then
		local needRemove = {}
		local needRecord = {}

		for i = #self.isExile_, 1, -1 do
			local buff = self.isExile_[i]

			buff:delCount()

			if buff:getCount() <= 0 then
				buff:writeRecord(nil, xyd.BUFF_OFF)
				table.insert(needRemove, buff)

				if xyd.arrayIndexOf(needRecord, buff) < 0 then
					table.insert(needRecord, buff)
				end
			end
		end

		self:removeBuffs(needRemove)
		unit:recordBuffs(self, needRecord)

		xyd.Battle.justRemoveExileRound[self:getPos()] = xyd.Battle.round

		return
	end

	if xyd.Battle.round == 3 then
		self:usePasSkill(xyd.TriggerType.ROUND_3_START, unit)
	end

	if xyd.Battle.round >= 3 then
		self:usePasSkill(xyd.TriggerType.ROUND_BEGIN_AFTER_3, unit)
	end

	if xyd.Battle.round == 7 then
		self:usePasSkill(xyd.TriggerType.ROUND_AFTER_6, unit)
	elseif xyd.Battle.round == 5 then
		self:usePasSkill(xyd.TriggerType.ROUND_AFTER_4, unit)
	end

	if xyd.Battle.round - 1 >= 4 and (xyd.Battle.round - 1) % 4 == 0 then
		self:usePasSkill(xyd.TriggerType.EVERY_4_ROUND, unit)
	end

	if xyd.Battle.round - 1 >= 5 and (xyd.Battle.round - 1) % 5 == 0 then
		self:usePasSkill(xyd.TriggerType.EVERY_5_ROUND, unit)
	end

	if xyd.Battle.round - 1 >= 6 and (xyd.Battle.round - 1) % 6 == 0 then
		self:usePasSkill(xyd.TriggerType.EVERY_6_ROUND, unit)
	end

	if xyd.Battle.round % 4 == 0 then
		self:usePasSkill(xyd.TriggerType.ROUND_PASS_4, unit)
	end

	self:usePasSkill(xyd.TriggerType.ROUND_END, unit)

	if xyd.Battle.round > 2 then
		self:usePasSkill(xyd.TriggerType.ROUND_END_AFTER_1, unit)
	end

	if self:isMoonShadow() then
		self:usePasSkill(xyd.TriggerType.MOONSHADOW_ROUND_END, unit)
	end

	local needRecord = {}
	local needRemove = {}
	local totalCure = 0
	local totalHarm = 0
	local isAlive = not self:isDeath()
	local killer = nil
	local baseAddHarmRate = 1 + self:getExtraHarmRate(unit)

	if self:isDecHurtLess() then
		local decRate = self.isDecHurtLess_[1]:getFinalNum()
		local minRate = -0.5

		for _, buff in ipairs(self.isDecHurt_) do
			if buff and buff:getFinalNum() < minRate then
				local nextNum = buff:getFinalNum() - decRate
				nextNum = math.min(minRate, nextNum)
				buff.finalNum_ = nextNum
			end
		end
	end

	for i = #self.isDot_, 1, -1 do
		if self:isDeath() then
			break
		end

		local buff = self.isDot_[i]

		if not buff then
			break
		end

		local addHarmRate = self:getExtraRoundHarm(buff) + baseAddHarmRate
		local num = buff:getFinalNum()
		num = num * (1 + self:getTearRate() + self:getDotAddHarmRate())
		num = num * addHarmRate
		num = self:getShieldHarm(num, unit, false, false, buff.fighter)

		if buff:isFighterPet() then
			local exBuffHarmRate = self:getPetExBuffHarmRate(buff.fighter)
			num = num * (1 + exBuffHarmRate)
		end

		totalHarm = totalHarm - num

		buff.fighter:recordData(-num, 0)

		buff.isHarm = false

		self:updateHpByHarm(num, unit, false, true, false, buff)
		buff:delCount()
		buff:setRecordNum(num)

		if buff:getCount() <= 0 then
			buff:writeRecord(self, xyd.BUFF_OFF)
			table.insert(needRemove, buff)
		else
			buff:writeRecord(self, xyd.BUFF_WORK)
		end

		table.insert(needRecord, buff)

		if self:isDeath() and isAlive then
			killer = buff.fighter
		end
	end

	if self:isFreeHarm() and totalHarm > 0 then
		self:delFreeHarmBuffCount(needRecord, unit)
	end

	if xyd.Battle.god and xyd.Battle.round ~= xyd.Battle.useGodPasRound then
		xyd.Battle.god:usePasSkill(xyd.TriggerType.ROUND_AFTER_DOT, unit)

		xyd.Battle.useGodPasRound = xyd.Battle.round
	end

	for i = #self.rImpresses_, 1, -1 do
		if self:isDeath() then
			break
		end

		local buff = self.rImpresses_[i]

		if not buff then
			break
		end

		buff:delCount()

		if buff:getCount() <= 0 then
			local num = buff:getFinalNum()
			num = self:checkRimpressDoubleD(num)
			local addHarmRate = baseAddHarmRate + self:getExtraRoundHarm(buff)
			num = num * addHarmRate
			num = self:getShieldHarm(num, unit, false, true, buff.fighter)

			self:updateHpByHarm(num, unit, true, false, false, buff)
			buff:setRecordNum(num)
			buff.fighter:recordData(-num, 0)
			buff:writeRecord(self, xyd.BUFF_OFF)
			table.insert(needRecord, buff)
			table.insert(needRemove, buff)
		end

		if self:isDeath() and isAlive then
			killer = buff.fighter
		end
	end

	local rImpressesHpLimitBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_HP_LIMIT)

	if rImpressesHpLimitBuffs and next(rImpressesHpLimitBuffs) then
		for i = #rImpressesHpLimitBuffs, 1, -1 do
			if self:isDeath() then
				break
			end

			local buff = rImpressesHpLimitBuffs[i]

			if not buff then
				break
			end

			local isNeedRecord, isNeedRemove = buff:roundUpdate({
				unit = unit
			})

			if isNeedRecord then
				table.insert(needRecord, buff)
			end

			if isNeedRemove then
				table.insert(needRemove, buff)
			end

			if self:isDeath() and isAlive then
				killer = buff.fighter
			end
		end
	end

	if killer and not killer:isDeath() then
		killer:usePasSkill(xyd.TriggerType.SELF_KILL_ENEMY, unit)
		killer:usePasSkill(xyd.TriggerType.FIRST_SELF_KILL_ENEMY, unit)
	end

	if not self:isDeath() then
		for i = #self.isHot_, 1, -1 do
			local buff = self.isHot_[i]

			if buff then
				local num = buff:getFinalNum()

				buff:delCount()

				if num > 0 then
					num = num * buff.target:getExtraHealRate()
					num = self:blockHeal(num, unit, buff)
					totalCure = totalCure + num

					self:updateHpByHeal(num, unit)
					buff:setRecordNum(num)
					buff.fighter:recordData(0, num)

					if buff:getCount() <= 0 then
						buff:writeRecord(self, xyd.BUFF_OFF)
						table.insert(needRemove, buff)
					else
						buff:writeRecord(self, xyd.BUFF_WORK)
					end

					table.insert(needRecord, buff)

					if self:isDeath() then
						break
					end
				end
			end
		end
	end

	if not self:isDeath() then
		for i = #self.isHeal_, 1, -1 do
			local buff = self.isHeal_[i]
			local num = buff:getFinalNum()

			buff:delCount()

			if num > 0 then
				num = num * buff.target:getExtraHealRate()
				num = self:blockHeal(num, unit, buff)
				totalCure = totalCure + num

				self:updateHpByHeal(num, unit)
				buff:setRecordNum(num)
				buff.fighter:recordData(0, num)

				if buff:getCount() <= 0 then
					buff:writeRecord(self, xyd.BUFF_OFF)
					table.insert(needRemove, buff)
				else
					buff:writeRecord(self, xyd.BUFF_WORK)
				end

				table.insert(needRecord, buff)

				if self:isDeath() then
					break
				end
			end
		end
	end

	for i = #self.isEatFreeHarm_, 1, -1 do
		local buff = self.isEatFreeHarm_[i]

		if buff.delayNum_ > 0 then
			buff.delayNum_ = buff.delayNum_ - 1
		else
			buff:delCount()

			if buff:getCount() <= 0 then
				buff:writeRecord(nil, xyd.BUFF_OFF)
				table.insert(needRemove, buff)

				if xyd.arrayIndexOf(needRecord, buff) < 0 then
					table.insert(needRecord, buff)
				end
			else
				buff:writeRecord(self, xyd.BUFF_ON_WORK)
				table.insert(needRecord, buff)
			end
		end
	end

	local disappearedMarkCrystalBuff = nil

	for i = #self.buffs_, 1, -1 do
		local buff = self.buffs_[i]

		if buff then
			buff:excuteAfterRound(unit)
		end
	end

	for i = #self.buffs_, 1, -1 do
		local buff = self.buffs_[i]

		if buff and not buff:isImpress() and not buff:isDot() and not buff:isHeal() and not buff:isHot() and buff:getName() ~= xyd.BUFF_REVIVE and buff:getName() ~= xyd.BUFF_REVIVE_INF and buff:getName() ~= xyd.BUFF_EAT_FREEHARM and buff:getName() ~= xyd.BUFF_APATE_REVIVE and buff:getName() ~= xyd.BUFF_RIMPRESS_HP_LIMIT then
			buff:delCount()

			if buff:getCount() <= 0 then
				buff:writeRecord(nil, xyd.BUFF_OFF)
				table.insert(needRemove, buff)

				if xyd.arrayIndexOf(needRecord, buff) < 0 then
					table.insert(needRecord, buff)
				end

				if buff:getName() == xyd.BUFF_MARK_CRYSTAL and not self:isDeath() then
					disappearedMarkCrystalBuff = buff

					if xyd.arrayIndexOf(xyd.Battle.crystalTargets, self) < 0 and self:getTeamType() == xyd.TeamType.A then
						table.insert(xyd.Battle.crystalTargets, self)
					end
				end

				if (buff:getName() == xyd.BUFF_CRYSTALL or buff:getName() == xyd.BUFF_CRYSTALLIZE) and self:getTeamType() == xyd.TeamType.A and xyd.arrayIndexOf(xyd.Battle.crystalEndTargets, self) < 0 then
					table.insert(xyd.Battle.crystalEndTargets, self)
				end
			end
		end
	end

	if disappearedMarkCrystalBuff then
		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() then
				local isFriend = v:getTeamType() == self:getTeamType()

				if not isFriend then
					v:usePasSkill(xyd.TriggerType.ENEMY_CRYSTAL, unit)
				end
			end
		end
	end

	self:removeBuffs(needRemove, nil, unit)
	unit:recordBuffs(self, needRecord)

	if totalCure > 0 then
		xyd.Battle.isCure = true
	end

	if disappearedMarkCrystalBuff and not self:isDeath() then
		if self:isImmenu() then
			local buff = self.isImmenu_[1]

			buff:writeRecord(nil, xyd.BUFF_OFF)
			self:removeBuffs({
				buff
			})
			unit:recordBuffs(self, {
				buff
			})
		else
			local buff = disappearedMarkCrystalBuff
			local params = {
				effectID = buff:getFinalNum(),
				fighter = buff.fighter,
				target = self,
				skillID = buff.skillID,
				index = buff.skillIndex
			}
			local newBuff = BuffManager:newBuff(params)

			newBuff:baseSetIsHit(1)

			if newBuff.isHit_ then
				newBuff.finalNum_ = 0

				self:addBuffs({
					newBuff
				}, unit)
				newBuff:writeRecord(self, xyd.BUFF_ON)
				unit:recordBuffs(self, {
					newBuff
				})
				self:usePasSkill(xyd.TriggerType.SELF_CONTROLED, unit)
				self:checkStatusSkill(unit, {
					isControl = true
				})
			end
		end
	end

	if not self:isDeath() then
		self:checkHpPasSkill(unit)
	end

	if not self:isDeath() then
		self:checkRoundEndRemoveControlBuff(unit)
	end

	self:calculateAllharmShare(unit)
end

function ReportBaseFighter:checkRoundEndRemoveControlBuff(unit)
	local recordBuffs = {}
	local buffControlRemove = self:getBuffByName(xyd.BUFF_CONTROL_REMOVE)
	local buffOutBreak = self:getBuffByName(xyd.BUFF_CONTROL_REMOVE_YUNMU)
	local cleanBuffs = {}

	if buffControlRemove then
		table.insert(cleanBuffs, buffControlRemove)
	end

	if buffOutBreak then
		table.insert(cleanBuffs, buffOutBreak)
	end

	if #cleanBuffs > 0 then
		self:cleanAllControlBuffs(unit, recordBuffs)
		unit:recordBuffs(self, recordBuffs)

		recordBuffs = {}

		self:removeBuffs(cleanBuffs)
	end
end

function ReportBaseFighter:updateInfRebornBuff(unit)
	local needRecord = {}
	local needRemove = {}

	for i = #self.isRevive_, 1, -1 do
		local buff = self.isRevive_[i]

		buff:delCount()

		if buff:getCount() <= 0 then
			table.insert(needRemove, buff)

			if xyd.arrayIndexOf(needRecord, buff) < 0 then
				table.insert(needRecord, buff)
			end

			self:initHp()
			buff:writeRecord(self, xyd.BUFF_WORK)
		end
	end

	self:removeBuffs(needRemove)
	unit:recordBuffs(self, needRecord)
	self:setJustReviveFromInf(true)
end

function ReportBaseFighter:updateRebornBuff(unit)
	local needRecord = {}
	local needRemove = {}
	local canReborn_ = false
	local isApateReborn = false

	local function updateReviveBuff(buff)
		if xyd.arrayIndexOf(needRecord, buff) < 0 then
			table.insert(needRecord, buff)
		end

		self:updateHp(buff:getFinalNum(1) * self:getHpLimit())

		local ep = tonumber(buff:getFinalNum(2)) or 0

		if ep > 0 then
			self:addEnergy(ep, unit)

			local params = {
				target = self
			}
			local energyBuff = BuffManager:newBuff(params)
			energyBuff.isHit_ = true
			energyBuff.name_ = xyd.BUFF_ENERGY
			energyBuff.preName_ = xyd.BUFF_ENERGY

			energyBuff:writeRecord(self, xyd.BUFF_WORK)
			unit:recordPasBuffs(self, {
				energyBuff
			})
		end

		buff:writeRecord(self, xyd.BUFF_WORK)

		canReborn_ = true
	end

	if self.hasReviveTimes_ < #self.isRevive_ then
		local buff = self.isRevive_[self.hasReviveTimes_ + 1]

		buff:delCount()

		if buff:getCount() <= 0 then
			updateReviveBuff(buff)
		end
	end

	for i = #self.isApateRevive_, 1, -1 do
		local buff = self.isApateRevive_[i]
		buff.delayNum_ = buff.delayNum_ - 1

		if buff.delayNum_ <= 0 then
			table.insert(needRemove, buff)

			if xyd.arrayIndexOf(needRecord, buff) < 0 then
				table.insert(needRecord, buff)
			end

			self:updateHp(buff:getFinalNum() * self:getHpLimit())
			buff:setRecordNum(buff.delayNum_)
			buff:writeRecord(self, xyd.BUFF_OFF)

			self.energy_ = 100
			local params = {
				skillID = buff.skillID,
				target = buff.target
			}
			local energyBuff = BuffManager:newBuff(params)
			energyBuff.name = xyd.BUFF_ENERGY

			energyBuff:writeRecord(self, xyd.BUFF_ON)
			table.insert(needRecord, energyBuff)

			canReborn_ = true
			isApateReborn = true

			self:setUnitPosEp()
		else
			self:usePasSkill(xyd.TriggerType.ROUND_END_WITH_APATE_REVIVE, unit)
			buff:setRecordNum(buff.delayNum_)
			buff:writeRecord(self, xyd.BUFF_WORK)
			table.insert(needRecord, buff)
		end
	end

	self:removeBuffs(needRemove)
	unit:recordBuffs(self, needRecord)

	if canReborn_ then
		self:reborn(unit, isApateReborn)
	end
end

function ReportBaseFighter:checkRebornUnlimited(reviveBuff)
	local res = false

	if not reviveBuff then
		return res
	end

	if not xyd.BUFF_REVIVE == reviveBuff:getName() then
		return res
	end

	local target = reviveBuff.target
	local unLimitedBuffs = target:getBuffsByNameAndFighter(xyd.BUFF_YUJI_UNLIMITED_REVIVE)

	if unLimitedBuffs and next(unLimitedBuffs) then
		local hasAliveFriends = false
		local yujiTableIDs = {
			55004,
			655011,
			755002
		}

		for _, v in ipairs(xyd.Battle.team) do
			if not v:isDeath() or v:canReborn() then
				local isFriend = v:getTeamType() == target:getTeamType()
				local hero = v.hero_
				local heroTableID = hero:getTableID()

				if hero:isMonster() then
					heroTableID = hero:getPartnerLink()
				end

				local isYuji = xyd.arrayIndexOf(yujiTableIDs, heroTableID) > 0

				if isFriend and not isYuji then
					hasAliveFriends = true
					res = hasAliveFriends

					break
				end
			end
		end
	end

	return res
end

function ReportBaseFighter:checkRimpressDoubleD(num)
	local rImpressHurtPlusBuffs = self:getBuffsByNameAndFighter(xyd.BUFF_RIMPRESS_HURT_PLUS)

	if rImpressHurtPlusBuffs and next(rImpressHurtPlusBuffs) then
		local rpBuff = rImpressHurtPlusBuffs[1]
		local plusRate = rpBuff:getFinalNum()
		num = num * (1 + plusRate)
	end

	return num
end

function ReportBaseFighter:battleEndReborn()
	if self.hasReviveTimes_ < #self.isRevive_ then
		local buff = self.isRevive_[self.hasReviveTimes_ + 1]

		self:updateHp(buff:getFinalNum() * self:getHpLimit())
	end
end

function ReportBaseFighter:isFriendTeamBoss()
	return self:getHeroTableID() == 1000015
end

function ReportBaseFighter:getBuffsByNameAndFighter(buffName, fighter)
	local buffs = self:getBuffListByName(buffName)
	local result = {}

	if next(buffs) then
		for _, buff in ipairs(buffs) do
			if fighter then
				if buff.fighter == fighter then
					table.insert(result, buff)
				end
			else
				table.insert(result, buff)
			end
		end
	end

	return result
end

function ReportBaseFighter:isDecDmgFree()
	local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_DEC_DMG_FREE)

	if buffs and #buffs > 0 then
		local buff = buffs[1]

		if buff:getCount() > 0 then
			return true
		end
	end

	return false
end

function ReportBaseFighter:isPetControlFree()
	if self:isPet() then
		local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_PET_CONTROL_FREE)

		if buffs and #buffs > 0 then
			return true
		end
	end

	return false
end

function ReportBaseFighter:addControlCount()
	local addCount = 0

	if self:isPet() then
		local buffs = self:getBuffsByNameAndFighter(xyd.BUFF_PET_CONTORL_INCREASE)

		if buffs and #buffs > 0 then
			local buff = buffs[1]
			addCount = buff:getFinalNum()
		end
	end

	return addCount
end

function ReportBaseFighter:getPetExBuffHarmRate(fighter)
	local rate = 0

	if fighter:isPet() then
		local buffs = fighter:getBuffsByNameAndFighter(xyd.BUFF_PET_DMG_B, fighter)

		if buffs and #buffs > 0 then
			local buff = buffs[1]
			rate = buff:getFinalNum()
		end
	end

	return rate
end

function ReportBaseFighter:getNewDebuffList(filterList)
	local list = {}
	local listByName = {}
	local dTypeNum = 0
	local dNameNum = 0
	filterList = filterList or {
		1,
		2,
		3,
		4,
		5
	}

	for i = #self.buffs_, 1, -1 do
		local buff = self.buffs_[i]
		local dType = buff:getDebuffType()
		local buffName = buff:getName()
		local isNewDebuff = buff:isNewDebuff()

		if isNewDebuff and xyd.arrayIndexOf(filterList, dType) > 0 then
			if not list[dType] then
				dTypeNum = dTypeNum + 1
				list[dType] = {}
			end

			if not listByName[buffName] then
				dNameNum = dNameNum + 1
				listByName[buffName] = {}
			end

			table.insert(list[dType], buff)
			table.insert(listByName[buffName], buff)
		end
	end

	local result = {
		debuffList = list,
		dTypeNum = dTypeNum,
		dNameNum = dNameNum,
		listByName = listByName
	}

	return result
end

function ReportBaseFighter:excuteBuffAfterAttack(unit)
	if xyd.Battle.lastAttacker then
		local mistletoeBuffs = xyd.Battle.lastAttacker:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE)

		if mistletoeBuffs and next(mistletoeBuffs) then
			local hpPercent = self:getHpPercent()

			if hpPercent < 0.6 then
				mistletoeBuffs[1]:excuteBuffAfterAttack(unit, {})
			end
		end

		xyd.Battle.lastAttacker = nil
	end
end

function ReportBaseFighter:getControlBuffs()
	local allControlBuffs = {}
	local allNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()
		local finalNum = buff:getFinalNum()

		if buff:isControlNew() and buff:ifCanClean() then
			local actualBuffName = buff:getActualBuff()

			if actualBuffName ~= nil then
				if not allControlBuffs[actualBuffName] then
					allControlBuffs[actualBuffName] = {}

					table.insert(allNames, actualBuffName)
				end

				table.insert(allControlBuffs[actualBuffName], buff)
			end
		end
	end

	return allControlBuffs, allNames
end

function ReportBaseFighter:getUnControlBuffs()
	local allUncontrolBuffs = {}
	local allNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()
		local finalNum = buff:getFinalNum()

		if not buff:isControlNew() and buff:isDebuff() and buff:ifCanClean() then
			local actualBuffName = buff:getActualBuff()

			if actualBuffName ~= nil then
				if not allUncontrolBuffs[actualBuffName] then
					allUncontrolBuffs[actualBuffName] = {}

					table.insert(allNames, actualBuffName)
				end

				table.insert(allUncontrolBuffs[actualBuffName], buff)
			end
		end
	end

	return allUncontrolBuffs, allNames
end

function ReportBaseFighter:getImpressBuffs()
	local allImpressBuffs = {}
	local allNames = {}

	for _, buff in ipairs(self.buffs_) do
		local name_ = buff:getName()
		local finalNum = buff:getFinalNum()

		if buff:isImpressNew() and buff:ifCanClean() then
			local actualBuffName = buff:getActualBuff()

			if actualBuffName ~= nil then
				if not allImpressBuffs[actualBuffName] then
					allImpressBuffs[actualBuffName] = {}

					table.insert(allNames, actualBuffName)
				end

				table.insert(allImpressBuffs[actualBuffName], buff)
			end
		end
	end

	return allImpressBuffs, allNames
end

return ReportBaseFighter
