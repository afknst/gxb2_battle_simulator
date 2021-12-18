local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local GroupTable = xyd.tables.groupTable
local GetTarget_ = xyd.Battle.getRequire("GetTarget")
local ReportBuff = class("ReportBuff")

function ReportBuff:ctor(params)
	self.isMiss_ = params.isMiss
	self.isFree_ = params.isFree

	if not self.isMiss_ and not self.isFree_ then
		self.effectID = params.effectID
		self.fighter = params.fighter
		self.skillID = params.skillID
		self.leftCount_ = EffectTable:round(self.effectID)
		self.skillIndex = params.index
		self.dieTarget = params.dieTarget
		self.forceEffectNum = params.forceEffectNum
		self.forceEffectProb = params.forceEffectProb
		self.recordEnergy = params.recordEnergy
		self.noAddEnergy = params.noAddEnergy
	end

	self.target = params.target
	self.isCrit_ = false
	self.isBlock_ = false
	self.finalNum_ = 0
	self.finalNumArray_ = EffectTable:num(self.effectID, true) or {}
	self.recordNum_ = nil
	self.delayNum_ = 0
	self.harmType = 0
	self.isHit_ = false
	self.isYongjiu_ = false
	self.record_ = nil
	self.name_ = nil
	self.basicHarm_ = 0
	self.preName_ = nil
	self.isHarm = true
	self.critFinalValue = 1
	self.globalBuffPos = {}
	self.isFighterPet_ = false
	self.ifNoBlock = params.ifNoBlock or false
	self.hadHit = false
	self.mustCrit = false

	if self.fighter then
		self.isFighterPet_ = self.fighter:isPet()
	end

	self.inHarmTargetList = true
end

function ReportBuff:checkSelfTeamNum(target)
	local allTeamate = target.selfTeam_
	local cnt = 0

	for _, v in ipairs(allTeamate) do
		if not v:isDeath() then
			cnt = cnt + 1
		end
	end

	return cnt
end

function ReportBuff:setIsHit(tmpBuffs)
	local name = self:getName()
	local job = BuffTable:getJob(name)
	local prob = self:getProb()

	if job > 0 then
		if self.target:getJob() ~= job then
			prob = 0
		end
	elseif self:isPosBuff() then
		local pos = BuffTable:pos(name)
		local fighterPos = self.target:getPos()

		if self.target:getTeamType() == xyd.TeamType.B then
			fighterPos = fighterPos - xyd.TEAM_B_POS_BASIC
		end

		if xyd.arrayIndexOf(pos, fighterPos) < 0 then
			prob = 0
		end
	elseif name == "phurt" and self.fighter:getHp() < self.target:getHp() then
		prob = 0
	elseif name == "stunH" and self.target:getHp() < self.fighter:getHp() then
		prob = 0
	elseif name == "hurtH" and self.fighter:getHp() <= self.target:getHp() then
		prob = 0
	elseif name == "forbidH" and self.fighter:getHp() < self.target:getHp() then
		prob = 0
	elseif name == "phurtH" and self.target:getHp() <= self.fighter:getHp() then
		prob = 0
	elseif name == xyd.BUFF_CRYSTALLIZE then
		local nuolisiAddBuff = self.fighter:getBuffsByName(xyd.BUFF_NUOLISI_ADD_RATE)

		if next(nuolisiAddBuff) and SkillTable:getSubSkills(nuolisiAddBuff[1].skillID)[1] == self.skillID then
			prob = prob + nuolisiAddBuff[1]:getAddRate()
		end
	elseif name == xyd.BUFF_CRIT_STUN and not self.target:isStun() then
		prob = 0
	elseif name == xyd.BUFF_POISON_STUN and not self.target:isDotPoison() then
		prob = 0
	elseif name == xyd.BUFF_ROW_B_CRIT and not self.target:isBackTarget() then
		prob = 0
	elseif name == xyd.BUFF_STUN_SOBER and self.target:isStun() then
		prob = 0
	elseif name == xyd.BUFF_N_DOT_FIRE and self.target:isDotFire() then
		prob = 0
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT15_BLOOD and not self.target:isDotBlood() then
		prob = 0
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT15_TEAR and not self.target:isTear() then
		prob = 0
	elseif name == xyd.BUFF_CRIT_N_TEAR and self.target:isTear() then
		prob = 0
	elseif name == xyd.BUFF_ADD_GET_LIGHT and not self.target:isGetLight() then
		prob = 0
	elseif name == xyd.BUFF_CONTROL_REMOVE_YUNMU and not self.target:isOutBreak() then
		prob = 0
	elseif name == xyd.BUFF_LOCK_TARGET then
		for k, v in ipairs(self.target.selfTeam_) do
			local buffs = v:getBuffsByNameAndFighter(name, self.fighter)

			if not v:isDeath() and next(buffs) then
				prob = 0
			end
		end
	elseif name == xyd.BUFF_FANHEXING_DIE1 then
		local buffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_LOCK_TARGET, self.fighter)

		if not next(buffs) then
			prob = 0
		end
	elseif name == xyd.BUFF_ATK_IMPRESS_BONUS then
		local buffs = self.target:getBuffsByNameAndFighter(name, self.fighter)

		if next(buffs) and #buffs >= 8 then
			prob = 0
		end
	elseif name == xyd.BUFF_DIE_ATK_IMPRESS then
		if not self.dieTarget then
			prob = 0
		else
			local buffs = self.dieTarget:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS)

			if not next(buffs) then
				prob = 0
			end
		end
	elseif name == xyd.BUFF_TRUE_VAMPIRE then
		local buffs = self.target:getBuffsByNameAndFighter(name)

		if next(buffs) then
			prob = 0
		end
	elseif name == xyd.BUFF_SUCK_REAL_BLOOD then
		local buffs = self.fighter:getBuffsByNameAndFighter(xyd.BUFF_SUCK_REAL_BLOOD_GET)

		if not next(buffs) then
			prob = 0
		end
	end

	if name == xyd.BUFF_SPD_STEAL and self.target:getAckSpeed() <= self.fighter:getAckSpeed() then
		prob = 0
	end

	if name == xyd.BUFF_ABSORB_DAMAGE and self.target.hasAbsorbDamage == true then
		prob = 0
	end

	if name == xyd.BUFF_DEC_DMG_BLOOD or name == xyd.BUFF_CRIT_TIME_BLOOD then
		local hasBlood = false
		local aliveEnemy = GetTarget_.S13(self.fighter)

		for _, v in ipairs(aliveEnemy) do
			if v:isDotBlood() then
				hasBlood = true

				break
			end
		end

		if not hasBlood then
			prob = 0
		end
	end

	local actual_buff = BuffTable:actualBuff(name)

	if actual_buff ~= "" and actual_buff ~= nil then
		self.origin_name = self.name_
		self.name_ = actual_buff
	end

	self:baseSetIsHit(prob, tmpBuffs)
end

function ReportBuff:isBuffLess()
	local name = self:getName()

	if self:isIce() and self.target:isIceLess() or self:isStone() and self.target:isStoneLess() or self:isStun() and self.target:isStunLess() or self:isForbid() and self.target:isForbidLess() or self:isActualFire(name) and self.target:isFireLess() or name == xyd.BUFF_DOT_BLOOD and self.target:isBloodLess() or self:isHit() and self:isControlNew() and self.target:isImmenu() or self:isDebuff() and self.target:isNoDebuff() then
		return true
	end

	return false
end

function ReportBuff:isBuffLimit()
	local name = self:getName()

	if name == xyd.BUFF_TEAR_LIMIT2 and #self.target.isTear_ >= 2 or name == xyd.BUFF_MISS_LIMIT2 and #self.target.isMissLimit2_ >= 2 or name == xyd.BUFF_DEC_DMG_N_ADD and #self.target.isDecDmgNAdd_ > 0 or name == xyd.BUFF_DEC_DMG_SHIELD_LIMIT8 and #self.target.isDecDmgShieldLimit8_ >= 8 or name == xyd.BUFF_HURT_SHIELD_LIMIT1 and #self.target.isHurtShieldLimit1_ >= 1 or name == xyd.BUFF_HURT_SHIELD_LIMIT2 and #self.target.isHurtShieldLimit2_ >= 2 or name == xyd.BUFF_HURT_SHIELD_LIMIT3 and #self.target.isHurtShieldLimit3_ >= 3 or name == xyd.BUFF_FREE_LIMIT1 and #self.target.isFreeLimit1_ >= 1 or name == xyd.BUFF_ATK_P_LIMIT3 and #self.target.isAtkPLimit3_ >= 3 or name == xyd.BUFF_HEAL_B_LIMIT1 and #self.target.isHealBLimit1_ >= 1 or name == xyd.BUFF_CRIT_TIME_LIMIT3 and #self.target.isCritTimeLimit3_ >= 3 or name == xyd.BUFF_REDUCE_SPD and #self.target.isReduceSpd_ >= 5 or name == xyd.BUFF_BIMPRESS_LIMIT30 and #self.target.bImpresses_ >= 1 then
		return true
	end

	return false
end

function ReportBuff:ifMustHit(name)
	if name == xyd.BUFF_HIT_STUN or name == xyd.BUFF_HIT_ICE or name == xyd.BUFF_HIT_STONE or name == xyd.BUFF_CRYSTALL then
		return true
	end

	return false
end

function ReportBuff:isHit()
	return self.isHit_
end

function ReportBuff:isFree()
	return self.isFree_
end

function ReportBuff:isCrit()
	return self.isCrit_
end

function ReportBuff:setIsCrit()
	if self.mustCrit then
		self.isCrit_ = true

		return self.isCrit_
	end

	local noCrit = SkillTable:getNoCrit(self.skillID, self.skillIndex)

	if noCrit == 1 or self:isDot() or self:isImpress() then
		return
	end

	local name = self:getName()

	if name == xyd.BUFF_BIMPRESS_LIMIT30 or name == xyd.BUFF_FULL_ENERGY_HURT then
		return
	end

	if name == xyd.BUFF_CRIT_STUN or name == xyd.BUFF_ROW_B_CRIT or name == xyd.BUFF_CRIT_N_TEAR then
		self.isCrit_ = true

		return self.isCrit_
	end

	if self.fighter:isOutBreak(self.skillID) then
		self.isCrit_ = true

		return self.isCrit_
	end

	local attacker = self.fighter
	local defender = self.target
	local critRate = attacker:getCrit(defender)
	local unCritRate = defender:getUnCrit()
	critRate = critRate - unCritRate
	critRate = math.min(1, critRate)
	critRate = math.max(0, critRate)

	if xyd.weightedChoise({
		critRate,
		1 - critRate
	}) == 1 then
		self.isCrit_ = true
	end

	return self.isCrit_
end

function ReportBuff:getProb()
	if self.forceEffectProb then
		return self.forceEffectProb
	end

	return EffectTable:prob(self:getTableID()) or 0
end

function ReportBuff:getFinalNum(index)
	if index then
		if self.finalNumArray_ and self.finalNumArray_[index] then
			return self.finalNumArray_[index]
		else
			return nil
		end
	else
		if self.finalNum_ then
			return self.finalNum_
		end

		if self.finalNumArray_ and self.finalNumArray_[1] then
			return self.finalNumArray_[1]
		end
	end
end

function ReportBuff:updateFinalNum(num)
	self.finalNum_ = num
end

function ReportBuff:setRecordNum(num)
	self.recordNum_ = num
end

function ReportBuff:setYongJiu(flag)
	self.isYongjiu_ = flag
end

function ReportBuff:calculate()
	local name = self:getName()
	local num = EffectTable:num(self.effectID)

	if self.forceEffectNum then
		num = self.forceEffectNum
	end

	local isAttr = BuffTable:isAttr(name)
	local isPercent = BuffTable:isPercent(name)

	if self.preName_ == xyd.BUFF_SUR_ATK_P then
		self.finalNum_ = self:calculateSurAtkP(num)
	elseif isAttr == 1 or self:isPosBuff() or name == xyd.BUFF_FIMPRESS or name == xyd.BUFF_OIMPRESS then
		self.finalNum_ = num
	else
		self.finalNum_ = self:calculateFinalNum(name, num, isPercent)
	end
end

function ReportBuff:calculateSurAtkP(num)
	local aliveNum = 0

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() or v:canReborn() then
			aliveNum = aliveNum + 1
		end
	end

	return num * aliveNum
end

function ReportBuff:calculateFinalNum(name, num, isPercent, forceHurt)
	local finalNum = num
	local attacker = self.fighter
	local defender = self.target

	if name == xyd.BUFF_SPD_GAP_HURT then
		num = math.abs(attacker:getAckSpeed() - defender:getAckSpeed()) + num
		num = math.min(num, 800) / 100
		num = num - num % 0.01
	end

	if name == "phurt" or name == "phurtH" then
		local tmpNum = defender:getHpLimit() * num
		local maxNum = attacker:getAD() * 15

		if tmpNum > maxNum then
			tmpNum = maxNum
		end

		finalNum = -tmpNum
	elseif self:checkIsHurt() and not self:checkSpecialCalculate() or forceHurt then
		if name == xyd.BUFF_HURT then
			local nuolisiAddBuff = attacker:getBuffByName(xyd.BUFF_NUOLISI_ADD_RATE)

			if nuolisiAddBuff and SkillTable:getSubSkills(nuolisiAddBuff.skillID)[1] == self.skillID then
				num = num + nuolisiAddBuff:getAddHurt()
				nuolisiAddBuff.usedTimes = nuolisiAddBuff.usedTimes + 1
			end
		end

		finalNum = self:calculateHurtNum(self:getName(), num, isPercent, nil, true)
	elseif name == xyd.BUFF_HEAL or self:isHot() then
		finalNum = self:calculateNum(num, isPercent, attacker:getAD())
		finalNum = self:updateHealNum(finalNum)
	elseif name == xyd.BUFF_HEAL_ATKP then
		finalNum = self:calculateNum(num, isPercent, attacker:getAD())
		finalNum = self:updateHealNum(finalNum)
	elseif name == xyd.BUFF_HEAL_P then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		finalNum = self:updateHealNum(finalNum)
	elseif name == xyd.BUFF_HEAL_PLOSE then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit() - defender:getHp())
		finalNum = self:updateHealNum(finalNum)
	elseif name == xyd.BUFF_SIPHON_ATK then
		finalNum = self:calculateNum(num, isPercent, defender:getAD())
	elseif name == xyd.BUFF_SIPHON_HP then
		finalNum = self:calculateNum(num, isPercent, self.basicHarm_)
		finalNum = self:updateHealNum(finalNum)
	elseif name == xyd.BUFF_SIPHON_ARM then
		finalNum = self:calculateNum(num, isPercent, defender:getHujia())
	elseif self:checkIsPet() then
		if defender:isReduceDot() and self:isRealDot() then
			num = num * (1 - defender:getReduceDot())
		end

		finalNum = -num
	elseif name == xyd.BUFF_BIMPRESS_LIMIT30 then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = attacker:getAD() * 30

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_M then
		local targets = self:getBuffTargets("29", 1, nil)
		local basic = 0
		local maxNum = 15

		if #targets > 0 then
			basic = targets[1]:getHpLimit()
			maxNum = targets[1]:getAD() * 15
		end

		finalNum = self:calculateNum(num, isPercent, basic)

		if maxNum < finalNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_OVER_FLOW then
		local targets = self:getBuffTargets("30", 1, nil)
		local basic = 0

		if #targets > 0 then
			basic = targets[1]:getHpLimit()
		end

		finalNum = self:calculateNum(num, isPercent, basic)
		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_H then
		finalNum = -self:calculateNum(num, isPercent, defender:getHpLimit())
	elseif name == xyd.BUFF_DOT_FIRE_MAX_HP then
		finalNum = -self:calculateNum(num, isPercent, attacker:getHpLimit())
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT25 then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = attacker:getAD() * 25

		if #self.finalNumArray_ == 2 then
			maxNum = attacker:getAD() * self.finalNumArray_[2]
		end

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT15 then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = attacker:getAD() * 15

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_DEC_HURT_NUM then
		finalNum = self:calculateNum(num, isPercent, attacker:getAD())
	elseif name == xyd.BUFF_HURT_MAX_HP then
		finalNum = self:calculateNum(num, isPercent, attacker:getHpLimit())
		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT15_BLOOD then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = attacker:getAD() * 15

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT15_TEAR then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = attacker:getAD() * 15

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_MAX_H_LIMIT then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit())
		local maxNum = 80000

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_ATK then
		finalNum = -self:calculateNum(num, isPercent, defender:getAD())
	elseif name == xyd.BUFF_PHURT_PAS_L_B then
		finalNum = -self:calculateNum(num, isPercent, xyd.Battle.puGongSkillHarms[defender:getPos()])
	elseif name == xyd.BUFF_PHURT_SKILL_L_B then
		finalNum = -self:calculateNum(num, isPercent, xyd.Battle.energySkillHarms[defender:getPos()])
	elseif name == xyd.BUFF_HURT_NOW_H_LIMIT15 then
		finalNum = self:calculateNum(num, isPercent, defender:getHp())
		local maxNum = attacker:getAD() * 15

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_HURT_DMG_H_LIMIT15 then
		finalNum = self:calculateNum(num, isPercent, defender:getHpLimit() - defender:getHp())
		local maxRate = 15

		if #self.finalNumArray_ == 2 then
			maxRate = self.finalNumArray_[2]
		end

		local maxNum = attacker:getAD() * maxRate

		if finalNum > maxNum then
			finalNum = maxNum
		end

		finalNum = -finalNum
	elseif name == xyd.BUFF_DOT_FIRE_HEAL_P then
		local fireEnemyNum = attacker:getFireEnemyNum()
		finalNum = self:calculateNum(num, isPercent, attacker:getHpLimit())
		finalNum = finalNum * fireEnemyNum
	elseif name == xyd.BUFF_EAT_FREEHARM then
		finalNum = defender:getHp()
	elseif name == xyd.BUFF_REVIVE then
		finalNum = defender.hasReviveTimes_
	elseif name == xyd.BUFF_EAT then
		finalNum = -defender:getHp()
	elseif name == xyd.BUFF_ATK_RANDOM_TIME then
		local weights = {}

		for i = 1, finalNum do
			table.insert(weights, 1)
		end

		finalNum = xyd.weightedChoise(weights)
	elseif name == xyd.BUFF_DEC_DMG_BLOOD or name == xyd.BUFF_CRIT_TIME_BLOOD then
		local cnt = 0
		local aliveEnemy = GetTarget_.S13(attacker)

		for _, v in ipairs(aliveEnemy) do
			if v:isDotBlood() then
				cnt = cnt + 1
			end
		end

		finalNum = finalNum * cnt
	elseif name == xyd.BUFF_GET_LEAF or name == xyd.BUFF_REDUCE_SPD or name == xyd.BUFF_ATK_IMPRESS_BONUS or name == xyd.BUFF_CLEAN_WITHOUT_DOT or name == xyd.BUFF_TRUE_VAMPIRE then
		self.finalNumArray_ = EffectTable:num(self.effectID, true)
		finalNum = self.finalNumArray_[1]
	elseif name == xyd.BUFF_SPD_STEAL then
		finalNum = -num
	elseif name == xyd.BUFF_ENERGY_HURT then
		finalNum = -defender:getEnergy() * num * attacker:getAD()
	elseif name == xyd.BUFF_OUT_BREAK then
		local factor = BuffTable:getFactor(name)

		if factor and factor > 0 then
			finalNum = finalNum / factor
		end
	elseif name == xyd.BUFF_SUCK_REAL_BLOOD then
		local srbgBuffs = self.fighter:getBuffsByNameAndFighter(xyd.BUFF_SUCK_REAL_BLOOD_GET)

		if next(srbgBuffs) then
			finalNum = -attacker:getAD() * num * #srbgBuffs
		end
	end

	if finalNum < 0 and BuffTable:getIsHpChange(name) == 1 then
		finalNum = finalNum * defender:getSuperDecHurtRate(self)
		finalNum = finalNum + defender:getDecHurtNum()
		finalNum = math.min(finalNum, 0)
	end

	if name == xyd.BUFF_DIE_ATK_IMPRESS and self.dieTarget then
		local buffs = self.dieTarget:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS)
		local times = 0

		if next(buffs) then
			times = #buffs
		end

		finalNum = finalNum * times
	end

	if self:isFire() then
		local buffs = self.target:getBuffsByName(xyd.BUFF_DOT_FIRE_RATE)
		local addRate = 0

		for k, v in ipairs(buffs) do
			addRate = addRate + v.finalNumArray_[1]
		end

		finalNum = finalNum * (1 + addRate)
	end

	if self:checkIsPet() and self.fighter:isGod() then
		self:changePetBuffName()
		self:setRecordNum(finalNum)
	end

	return finalNum
end

function ReportBuff:checkSpecialCalculate()
	local name = self:getName()

	if name == xyd.BUFF_DOT_FIRE_MAX_HP then
		return true
	end

	return false
end

function ReportBuff:getBuffTargets(selectType, randNum, unit)
	local targets = GetTarget_["S" .. selectType](self.fighter, randNum, unit)

	return targets
end

function ReportBuff:calculateNum(num, isPercent, basic)
	local finalNum = 0

	if not isPercent or isPercent == 0 then
		finalNum = num + basic
	else
		finalNum = num * basic
	end

	return finalNum
end

function ReportBuff:updateHealNum(finalNum)
	local attacker = self.fighter
	local defender = self.target
	local healI = attacker:getHealI()
	finalNum = finalNum * healI

	return finalNum
end

function ReportBuff:setIsBlock()
	local attacker = self.fighter
	local defender = self.target

	if attacker:isOutBreak(self.skillID) or self.ifNoBlock then
		self.isBlock_ = false

		return
	end

	local basic = 1
	local hitRate = basic + attacker:getMingZhong(attacker, defender) - defender:getShanBi()
	hitRate = math.max(0, hitRate)
	hitRate = math.min(1, hitRate)
	self.isBlock_ = xyd.weightedChoise({
		1 - hitRate,
		hitRate
	}) == 1
end

function ReportBuff:isBlock()
	return self.isBlock_
end

function ReportBuff:getName()
	if not self.name_ then
		self.name_ = EffectTable:buff(self.effectID)
		self.preName_ = self.name_
	end

	return self.name_
end

function ReportBuff:checkIsHurt()
	return self:isDamage() or self:isDot() or self:isImpress() or self:getName() == xyd.BUFF_EXLODED
end

function ReportBuff:checkFImpress(fighter)
	local heros = BuffTable:getHeros(xyd.BUFF_FIMPRESS)
	local fighterID = fighter:getHeroTableID()

	for _, id in ipairs(heros) do
		if id == fighterID then
			return true
		end
	end

	return false
end

function ReportBuff:checkIsHero(fighter)
	local heros = BuffTable:getHeros(self:getName())
	local fighterID = fighter:getHeroTableID()

	for _, id in ipairs(heros) do
		if id == fighterID then
			return true
		end
	end

	return false
end

function ReportBuff:isDamage()
	local name = self:getName()

	if name == xyd.BUFF_HURT or name == xyd.BUFF_TRUE_HURT or name == xyd.BUFF_REAL_HURT or name == xyd.BUFF_ADD_HURT or name == "addHurtd" or name == "phurt" or name == "phurtH" or name == xyd.BUFF_AGGRESSION_HARM or name == xyd.BUFF_CRIT_STUN or name == xyd.BUFF_ROW_B_CRIT or name == xyd.BUFF_HURT_FREE_ARM or name == xyd.BUFF_CRIT_N_TEAR or name == xyd.BUFF_ADD_HURT_FREE_ARM or name == xyd.BUFF_SPD_GAP_HURT or name == xyd.BUFF_SUN_ARROW_SHOOT or name == xyd.BUFF_HURT_ALL_LEVEL or name == xyd.BUFF_DIE_ATK_IMPRESS then
		return true
	end

	return false
end

function ReportBuff:canAddEnergy()
	if SkillTable:getIsAddEnergy(self.skillID) == 2 then
		return true
	elseif SkillTable:getIsAddEnergy(self.skillID) == 1 then
		return false
	end

	if self.noAddEnergy then
		return false
	end

	local name = self:getName()

	if name == xyd.BUFF_HURT or name == xyd.BUFF_TRUE_HURT or name == xyd.BUFF_HURT_FREE_ARM or name == xyd.BUFF_REAL_HURT then
		return true
	end

	return false
end

function ReportBuff:isRealDot()
	local name = self:getName()

	if name == xyd.BUFF_M_DOT_FIRE or name == xyd.BUFF_M_DOT_POISON or name == xyd.BUFF_M_DOT_BLOOD then
		return true
	end

	return self:isDot()
end

function ReportBuff:isDot()
	local name = self:getName()

	if name == xyd.BUFF_DOT or name == xyd.BUFF_DOT_POISON or name == xyd.BUFF_DOT_BLOOD or name == xyd.BUFF_DOT_FIRE or name == xyd.BUFF_DOT_FIRE_MAX_HP or name == xyd.BUFF_FEISINA_EXPLODE or name == xyd.BUFF_DOT_TWINS then
		return true
	end

	return false
end

function ReportBuff:isActualFire(name)
	local actualName = BuffTable:actualBuff(name)

	if actualName ~= "" and actualName ~= nil then
		name = actualName
	end

	if name == xyd.BUFF_DOT_FIRE or name == xyd.BUFF_DOT_FIRE_MAX_HP or name == xyd.BUFF_M_DOT_FIRE then
		return true
	end

	return false
end

function ReportBuff:isFire()
	local name = self:getName()

	if name == xyd.BUFF_DOT_FIRE or name == xyd.BUFF_DOT_FIRE_MAX_HP or name == xyd.BUFF_M_DOT_FIRE then
		return true
	end

	return false
end

function ReportBuff:isHeal()
	local name = self:getName()

	if name == xyd.BUFF_HEAL or name == xyd.BUFF_HEAL_P or name == xyd.BUFF_SIPHON_HP or name == xyd.BUFF_HEAL_PLOSE or name == xyd.BUFF_SIPHON or name == xyd.BUFF_CRIT_SIPHON or name == xyd.BUFF_HEAL_ATKP then
		return true
	end

	return false
end

function ReportBuff:isHot()
	local name = self:getName()

	if name == xyd.BUFF_HOT or name == xyd.BUFF_HOT_HUATUO then
		return true
	end

	return false
end

function ReportBuff:isControlNew()
	local name = self:getName()
	local debuffType = BuffTable:getDebuffType(name)

	return debuffType == 3
end

function ReportBuff:isSiphon()
	local name = self:getName()

	if name == xyd.BUFF_SIPHON_ATK or name == xyd.BUFF_SIPHON_ARM then
		return true
	end

	return false
end

function ReportBuff:isSiphonAttr()
	local name = self:getName()

	if name == xyd.BUFF_SIPHON then
		return true
	end

	return false
end

function ReportBuff:isImpress()
	local name = self:getName()

	if name == xyd.BUFF_RIMPRESS or name == xyd.BUFF_CIMPRESS then
		return true
	end

	return false
end

function ReportBuff:isImpressNew()
	local name = self:getName()
	local debuffType = BuffTable:getDebuffType(name)

	return debuffType == 5
end

function ReportBuff:isPosBuff()
	local name = self:getName()
	local pos = BuffTable:pos(name)

	if pos[1] and pos[1] > 0 then
		return true
	end

	return false
end

function ReportBuff:isIce()
	local name = self:getName()

	if name == "ice" or name == "zsIce" then
		return true
	end

	return false
end

function ReportBuff:isStone()
	local name = self:getName()

	if name == "stone" then
		return true
	end

	return false
end

function ReportBuff:isEatFreeHarm()
	local name = self:getName()

	if name == xyd.BUFF_EAT_FREEHARM then
		return true
	end

	return false
end

function ReportBuff:isAtkUnable()
	local name = self:getName()

	if name == "atkUnable" then
		return true
	end

	return false
end

function ReportBuff:isForbid()
	local name = self:getName()

	if name == "forbid" or name == "forbidH" then
		return true
	end

	return false
end

function ReportBuff:isAllDmgB()
	local name = self:getName()

	if name == xyd.BUFF_ALL_DMG_B or name == xyd.BUFF_BASE_4_ALL_DMG_B then
		return true
	end

	return false
end

function ReportBuff:isDecHpLimit()
	local name = self:getName()

	if name == xyd.BUFF_DEC_HP_LIMIT or name == xyd.BUFF_CX_XL_DEC_HP_LIMIT then
		return true
	end

	return false
end

function ReportBuff:isAddHpLimit()
	local name = self:getName()

	if name == xyd.BUFF_ADD_HP_LIMIT then
		return true
	end

	return false
end

function ReportBuff:isStun()
	local name = self:getName()

	if name == "stun" or name == "stunH" then
		return true
	end

	return false
end

function ReportBuff:isDebuff()
	local buffType = BuffTable:getBuffType(self:getName())

	if buffType and buffType > 0 then
		local flag = false

		if buffType == 2 then
			flag = true
		end

		if buffType == 3 and self:getFinalNum() < 0 then
			flag = true
		end

		if buffType == 4 and self:getFinalNum() > 0 then
			flag = true
		end

		return flag
	end

	return false
end

function ReportBuff:isAttrBuff()
	local buffType = BuffTable:getBuffType(self:getName())

	if buffType and buffType > 0 then
		local flag = false

		if buffType == 1 then
			flag = true
		end

		if buffType == 3 and self.finalNumArray_[1] > 0 then
			flag = true
		end

		if buffType == 4 and self.finalNumArray_[1] < 0 then
			flag = true
		end

		if not flag then
			return false
		end
	end

	return BuffTable:getIsAttrBuff(self:getName())
end

function ReportBuff:isBuff()
	local buffType = BuffTable:getBuffType(self:getName())

	if buffType and buffType > 0 then
		local flag = false

		if buffType == 1 then
			flag = true
		end

		if buffType == 3 and self:getFinalNum() > 0 then
			flag = true
		end

		if buffType == 4 and self:getFinalNum() < 0 then
			flag = true
		end

		return flag
	end

	return false
end

function ReportBuff:ifCanClean()
	local name = EffectTable:getType(self.effectID)
	local res = BuffTable:isCannotClean(name)

	if res and res ~= 0 then
		return false
	elseif self.isYongjiu_ then
		return false
	else
		return true
	end
end

function ReportBuff:checkIsPet()
	local name = self:getName()

	if name == xyd.BUFF_M_HURT or name == xyd.BUFF_M_DOT_FIRE or name == xyd.BUFF_M_DOT_POISON or name == xyd.BUFF_M_DOT_BLOOD then
		return true
	end

	return false
end

function ReportBuff:changePetBuffName()
	if self:checkIsPet() then
		local name = self:getName()
		self.name_ = string.sub(name, 2)
	end
end

function ReportBuff:isFighterPet()
	return self.isFighterPet_
end

function ReportBuff:checkIsAttr(name)
	return true
end

function ReportBuff:checkIsPassNoAttr()
	local name = self:getName()
	local isPassNoAttr = BuffTable:isPassNoAttr(name)

	return isPassNoAttr == 1
end

function ReportBuff:addCount(num)
	if not self.isYongjiu_ then
		self.leftCount_ = self.leftCount_ + num
	end
end

function ReportBuff:delCount()
	if not self.isYongjiu_ then
		self.leftCount_ = self.leftCount_ - 1
	end
end

function ReportBuff:setLeftCount(leftCount)
	if not self.isYongjiu_ then
		self.leftCount_ = leftCount
	end
end

function ReportBuff:recoverCount()
	self.leftCount_ = EffectTable:round(self.effectID)
end

function ReportBuff:getCount()
	if self.isYongjiu_ then
		return 1
	end

	if self:isFree() then
		return 0
	end

	if self:getName() == xyd.BUFF_CIMPRESS then
		return 1
	end

	return self.leftCount_
end

function ReportBuff:getTableID()
	return self.effectID
end

function ReportBuff:isRestraint(attacker, defender)
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

function ReportBuff:writeRecord(target, buffOn, noRecordHp)
	if xyd.Battle.isSweep then
		return
	end

	local value = self.recordNum_ ~= nil and self.recordNum_ or self:getFinalNum()
	local params = {}

	if not target or buffOn == xyd.BUFF_ON or self:isFree() then
		params = {
			pos = self.target:getPos(),
			table_id = self:getTableID(),
			name = self:getName(),
			value = value > 0 and 1 or -1,
			type = self:getType(),
			skill_id = self.skillID,
			effect_index = self.skillIndex
		}
	else
		params = {
			hp = math.ceil(xyd.PERCENT_BASE * target:getHp() / target:getHpLimit()),
			value = math.floor(value),
			name = self:getName(),
			table_id = self:getTableID(),
			pos = target:getPos(),
			type = self:getType(),
			skill_id = self.skillID,
			effect_index = self.skillIndex
		}

		if noRecordHp then
			params.hp = nil
		end
	end

	if self.origin_name and BuffTable:hasFx(self.origin_name) then
		params.name = self.origin_name
	end

	if self:isBlock() then
		params.is_block = 1
	end

	if self.fighter then
		params.f_pos = self.fighter:getPos()
	end

	if self:getName() == xyd.BUFF_HURT_FOR_ENERGY then
		params.value = value
	end

	params.buffOn = buffOn or xyd.BUFF_OFF
	params.isHarm = self.isHarm

	if self.isHarm then
		params.isHarm = 1
	elseif self.isHarm == false then
		params.isHarm = 0
	end

	if (not buffOn or buffOn ~= xyd.BUFF_OFF and buffOn ~= xyd.BUFF_REMOVE) and (self:isEatFreeHarm() or self:isIce() or self:isStone() or self:isStun() or self:isForbid() or self:needWorkAndOn()) then
		params.buffOn = xyd.BUFF_ON_WORK
	end

	self.record_ = params
end

function ReportBuff:needWorkAndOn()
	return false
end

function ReportBuff:getType()
	local type_ = xyd.BuffType.NORMAL

	if self.isMiss_ then
		type_ = xyd.BuffType.MISS
	elseif self.isCrit_ then
		type_ = xyd.BuffType.CRIT
	elseif self.isFree_ then
		type_ = xyd.BuffType.FREE
	end

	return type_
end

function ReportBuff:getRecord()
	if not self.record_ then
		self:writeRecord()
	end

	return self.record_
end

function ReportBuff:clearRecord()
	self.record_ = nil
end

function ReportBuff:isGroupBuff()
	self:getName()

	local group_ = BuffTable:getGroup(self.preName_)

	if group_ and #group_ > 0 then
		return true
	end

	return false
end

function ReportBuff:checkHeroGroup(fighter)
	self:getName()

	local group_ = BuffTable:getGroup(self.preName_)

	if group_ and #group_ > 0 then
		local group = fighter:getGroup()

		for _, v in ipairs(group_) do
			if group == v then
				return true
			end
		end

		return false
	end

	return false
end

function ReportBuff:getActualBuff()
	local name = self:getName()
	local actual_buff = BuffTable:actualBuff(self.preName_)

	if actual_buff ~= "" and actual_buff ~= nil then
		return actual_buff
	end

	return name
end

function ReportBuff:checkActualType(attrType)
	self:getName()

	local actual_buff = BuffTable:actualBuff(self.preName_)

	if attrType == actual_buff or attrType == string.sub(actual_buff, 1, -2) or attrType == string.sub(actual_buff, 1, -4) then
		return true
	end

	return false
end

function ReportBuff:isCanDebuffSame()
	local name = EffectTable:getType(self.effectID)

	return BuffTable:isCanDebuffSame(name)
end

function ReportBuff:roundUpdate()
end

function ReportBuff:getDebuffType()
	local buffName = self:getName()

	return BuffTable:getDebuffType(buffName)
end

function ReportBuff:isNewDebuff()
	local debuffType = self:getDebuffType()

	if debuffType and debuffType > 0 then
		local flag = true

		if debuffType == 1 and self:getFinalNum() > 0 then
			flag = false
		end

		if debuffType == 2 and self:getFinalNum() < 0 then
			flag = false
		end

		return flag
	end

	return false
end

function ReportBuff:calculateHurtNum(name, num, isPercent, extraData, isDirect)
	local finalNum = num
	local attacker = self.fighter
	local defender = self.target
	local targetHurtNum = defender:getTargetHurtNum(attacker)
	finalNum = finalNum + targetHurtNum

	if extraData and extraData.hurt then
		finalNum = finalNum + extraData.hurt
	end

	if self.skillID == attacker:getEnergySkillID() and (name == xyd.BUFF_HURT or name == xyd.BUFF_HURT_FREE_ARM) or attacker:isAddHurtNeedEnergy(self.skillID) then
		local energy_ = attacker:getEnergy()

		if self.recordEnergy then
			energy_ = self.recordEnergy
		end

		finalNum = finalNum + attacker:getSklp() + (energy_ - 100) * 0.01
	end

	local dRate = defender:getHujia() / (200 + (defender:getLevel() - 1) * 20) * (1 - attacker:getDHuJia())
	local rate = 1 - math.min(dRate, 0.9)

	if name == xyd.BUFF_HURT_FREE_ARM or name == xyd.BUFF_ADD_HURT_FREE_ARM then
		rate = 1
	end

	finalNum = finalNum * rate
	finalNum = finalNum + 0.7 * attacker:getTrueAtk()
	local defenderDecDmg = defender:getJianshang()

	if attacker:isDecDmgFree() then
		defenderDecDmg = 0
	end

	finalNum = finalNum * (1 - defenderDecDmg)
	local adNum = attacker:getAD()

	if extraData and extraData.adNum then
		adNum = extraData.adNum
	end

	finalNum = adNum * finalNum

	if (self.skillID == attacker:getEnergySkillID() or attacker:isPugongSkill(self.skillID)) and name == xyd.BUFF_HURT and attacker:getHpPercent() < defender:getHpPercent() then
		local hurtLHurtP = attacker:getBuffHurtLHurtP()
		finalNum = finalNum * hurtLHurtP
	end

	local isCrit = self:setIsCrit()

	if isCrit then
		local targetCritTime = defender:getTargetCritTime(attacker)
		local attackerCritTime = attacker:getCritTime(defender)
		local critTime = targetCritTime + attackerCritTime

		if critTime > 1.5 then
			critTime = 1.5
		end

		finalNum = finalNum * (1.5 + critTime * 2)
		local critDef = defender:getCritDefRate()
		finalNum = finalNum * (1 - critDef)
		self.critFinalValue = (1.5 + critTime * 2) * (1 - critDef)
	end

	if self:isDamage() then
		self:setIsBlock()

		if self:isBlock() then
			local blockRate = 0.3

			if isCrit then
				blockRate = 0.5
			end

			finalNum = finalNum * (1 - blockRate)
		end
	end

	if self:isRestraint(attacker, defender) then
		finalNum = finalNum * 1.3
	end

	local mingZhongHarmRate = attacker:getMingZhongHarmRate(attacker, defender)
	finalNum = finalNum * (1 + mingZhongHarmRate)
	local weakNum = 0

	if defender:isWeak() then
		weakNum = weakNum + 0.5
	end

	if defender:getOImpress() then
		weakNum = weakNum + defender:getOImpress()
	end

	finalNum = finalNum * (1 + weakNum)
	finalNum = -finalNum * attacker:getAddHarmRate(defender, self.skillID)
	finalNum = finalNum * attacker:getExtraDecHarmRate(defender, self.skillID)

	if defender:getFImpress() > 0 and self:checkFImpress(attacker) then
		finalNum = finalNum * (1 + defender:getFImpress())
	end

	if isCrit then
		finalNum = finalNum * (1 + attacker:getBuffTotalNumByGroup(attacker.isCritTimeLimit_))
	elseif not isCrit and (name == "hurt" or name == xyd.BUFF_HURT_FREE_ARM) and attacker:isExtraNoCritHarm() then
		finalNum = finalNum * (1 + attacker.isExtraNoCritHarm_[1]:getFinalNum())
	end

	for _, v in ipairs(defender.buffs_) do
		if v:getName() == xyd.BUFF_FEISINA_EXPLODE and not v.hasSameBuff and (name == "hurt" or name == xyd.BUFF_ADD_HURT or name == xyd.BUFF_HURT_FREE_ARM) then
			v.exploreHarmRecord = v.exploreHarmRecord - finalNum
		end
	end

	if defender:isReduceDot() and self:isRealDot() then
		finalNum = finalNum * (1 - defender:getReduceDot())
	end

	if defender:isFireDecDmg() and attacker:isDotFire() then
		finalNum = finalNum * (1 - defender:getBuffByName(xyd.BUFF_FIRE_DEC_DMG):getFinalNum())
	end

	finalNum = math.ceil(finalNum)
	finalNum = math.min(finalNum, -1)

	if not isDirect then
		finalNum = finalNum * defender:getSuperDecHurtRate(self)
		finalNum = finalNum + defender:getDecHurtNum()
		finalNum = math.ceil(finalNum)
		finalNum = math.min(finalNum, 0)
	end

	return finalNum
end

function ReportBuff:changeBuffName()
	local name = self:getName()
	self.oldName = name
	local actualBuff = BuffTable:actualBuff(name)

	if actualBuff ~= "" and actualBuff ~= nil then
		self.name_ = actualBuff
	end
end

function ReportBuff:revertBuffName()
	if self.oldName then
		self.name_ = self.oldName
	end
end

function ReportBuff:layerLimitAndCover(tmpBuffs)
	if not self.isHit_ then
		return
	end

	local name = self:getName()

	if BuffTable:getLayer(name) == 0 then
		return
	end

	local defender = self.target
	local coverType = BuffTable:getCover(name)
	local buffs = defender:getBuffsByName(name)
	local sameBuffs = {}

	if tmpBuffs then
		for k, v in ipairs(tmpBuffs) do
			if v:getName() == self:getName() then
				table.insert(sameBuffs, v)
			end
		end
	end

	if #sameBuffs ~= 0 and BuffTable:getLayer(name) <= #buffs + #sameBuffs then
		self.isHit_ = false

		return
	end

	if next(buffs) and BuffTable:getLayer(name) <= #buffs then
		if coverType == xyd.COVER_TYPE_NO then
			self.isHit_ = false

			return
		end

		local lowestBuff = buffs[1]

		for i = 2, #buffs do
			if buffs[i].finalNumArray_[1] < lowestBuff.finalNumArray_[1] then
				lowestBuff = buffs[i]
			elseif lowestBuff.finalNumArray_[1] == buffs[i].finalNumArray_[1] and buffs[i]:getCount() < lowestBuff:getCount() then
				lowestBuff = buffs[i]
			end
		end

		local needCover = false

		if lowestBuff.finalNumArray_[1] < self.finalNumArray_[1] then
			needCover = true
		elseif lowestBuff.finalNumArray_[1] == self.finalNumArray_[1] and coverType == xyd.COVER_TYPE_ROUND and lowestBuff:getCount() < self:getCount() then
			needCover = true
		end

		if needCover then
			local newParams = {
				fighter = self.fighter,
				effectID = self.effectID,
				skillID = self.skillID,
				leftCount_ = self.leftCount_,
				skillIndex = self.skillIndex,
				dieTarget = self.dieTarget
			}

			lowestBuff:coverParams(newParams)
			lowestBuff:calculate()
		end

		self.isHit_ = false
	end
end

function ReportBuff:baseSetIsHit(prob, tmpBuffs)
	local name = self:getName()
	local isLess = false
	prob = prob or self:getProb()
	prob = math.min(prob, 1)

	if self:isBuffLimit() then
		prob = 0
	end

	if self:isGroupBuff() and not self:checkHeroGroup(self.target) then
		prob = 0
	end

	if self:isControlNew() or name == xyd.BUFF_MARK_CRYSTAL then
		local freePro = self.target:getFree()

		if self:ifMustHit(name) or self.fighter:isPetControlFree() then
			freePro = 0
		end

		if not self.fighter then
			prob = prob * (1 - freePro)
		else
			prob = prob * (1 - freePro + self.fighter:getUnFree())
		end

		if not self.target:canControlBuffAdd(self) then
			isLess = true
		end

		local addCount = self.fighter:addControlCount()

		if addCount > 0 then
			self.leftCount_ = self.leftCount_ + addCount
		end
	end

	if self.target and not self.target:canHeal() and (self:isHeal() or self:isHot()) then
		prob = 0
	end

	prob = math.min(prob, 1)
	self.isHit_ = xyd.weightedChoise({
		prob,
		1 - prob
	}) == 1

	self:layerLimitAndCover(tmpBuffs)

	if self.isHit_ and (self:isBuffLess() or isLess == true) then
		self.hadHit = self.isHit_
		self.isFree_ = true
		self.isHit_ = false
	end
end

function ReportBuff:excuteBuff(unit, recordBuffs)
end

function ReportBuff:excuteAfterRound(unit)
end

function ReportBuff:hasFx()
	return BuffTable:hasFx(self:getName())
end

function ReportBuff:coverParams(newParams)
	for key, value in pairs(newParams) do
		self[key] = value
	end
end

function ReportBuff:reg_evt()
end

function ReportBuff:setEndLoop(status)
	self.endLoop = status
end

function ReportBuff:isEndLoop()
	return self.endLoop or false
end

return ReportBuff
