local ReportAttackUnit = class("ReportAttackUnit")
local SkillTable = xyd.tables.skillTable
local EffectTable = xyd.tables.effectTable
local GetTarget_ = xyd.Battle.getRequire("GetTarget")
local BuffManager = xyd.Battle.getRequire("BuffManager")
local BuffTable = xyd.tables.dBuffTable
local GroupTable = xyd.tables.groupTable
local BattleTargetTable = xyd.tables.battleTargetTable

function ReportAttackUnit:ctor(params)
	self.buffs = {}
	self.fighter = params.fighter
	self.lastFighter = params.fighter
	self.skillID = params.skillID
	local round = xyd.Battle.round

	if round == 0 then
		round = 1
	end

	self.round_ = round
	self.isPas_ = params.isPas
	self.specialUnit_ = params.unit
	self.unitDatas_ = {}
	self.targetsPos_ = {}
	self.targets2Pos_ = {}
	self.records_ = {}
	self.buffs_ = {}
	self.rebornTimes_ = params.rebornTimes
	self.totalHarm_ = tonumber(params.totalHarm) or 0
	self.totalCritHarm_ = tonumber(params.totalCritHarm) or 0
	self.totalReflectHarm_ = params.totalReflectHarm or {
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
	self.totalPosHarm_ = params.totalPosHarm or {
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
	self.totalAttackHarm_ = {
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
	self.notTrigPasSkill_ = params.notTrigPasSkill
	self.missBuffs = {}
	self.isNeedRecord = params.isNeedRecord
	self.dieTarget = params.dieTarget
	self.ifNoBlock = params.ifNoBlock or false
	self.isPet = false

	if self.fighter then
		self.isPet = self.fighter:isPet()
	end

	self:init()
end

function ReportAttackUnit:init()
	local selectTypes = SkillTable:getTargets(self.skillID)

	for i = 1, #selectTypes do
		local selectType = selectTypes[i]

		if selectType > 0 then
			local randNum = SkillTable:getRandNum(self.skillID, i)
			local targets = self:getBuffTargets(selectType, randNum, self.specialUnit_, i)

			if targets and next(targets) then
				local effects = SkillTable:getEffect(self.skillID, i)
				local specialEffects = SkillTable:getEffectAdd(self.skillID)

				for j = 1, #targets do
					local target = targets[j]

					if target then
						local isMiss = self:isSkillMiss(target, i, self.fighter)
						local invisibleBuffs = target:getBuffsByNameAndFighter(xyd.BUFF_INVISIBLE)

						if next(invisibleBuffs) and #targets == 1 and target:getTeamType() ~= self.fighter:getTeamType() then
							isMiss = true
						end

						local skillIndex = SkillTable:getTargetSkillIndex(self.skillID, i)

						if isMiss then
							self:recordTargets(target, isMiss, false, false, {}, {}, false, skillIndex)
						else
							local trueEffects = effects

							if i == 1 and j > 1 and selectType == xyd.NDSV_SKILL_TARGET then
								trueEffects = specialEffects[j - 1]
							end

							self:createBuff(target, trueEffects, skillIndex)

							if i == 1 then
								self:addPreHitTargets(target)
							end
						end

						if self.isPet and not target:isPet() then
							self:addToPetTarget(target, selectType)
						end
					end
				end
			end
		end
	end
end

function ReportAttackUnit:addPreHitTargets(target)
	if self.fighter:getPos() <= 12 and (self.skillID == self.fighter:getEnergySkillID() or self.fighter:isPugongSkill(self.skillID)) and target:getTeamType() ~= self.fighter:getTeamType() then
		table.insert(xyd.Battle.preHitTargets, target)
	end
end

function ReportAttackUnit:isPasSkill()
	return self.isPas_
end

function ReportAttackUnit:notUsePasSkill()
	return self.notTrigPasSkill_
end

function ReportAttackUnit:addToPetTarget(target, selectType)
	local targetType = BattleTargetTable:getTargetType(selectType)

	if targetType == xyd.TargetType.TARGET_ENEMY and xyd.Battle.petChooseEnemys then
		if xyd.arrayIndexOf(xyd.Battle.petChooseEnemys, target) > 0 then
			return
		end

		table.insert(xyd.Battle.petChooseEnemys, target)
	elseif targetType == xyd.TargetType.TARGET_SELF and xyd.Battle.petChooseFriends then
		if xyd.arrayIndexOf(xyd.Battle.petChooseFriends, target) > 0 then
			return
		end

		table.insert(xyd.Battle.petChooseFriends, target)
	end
end

function ReportAttackUnit:getBuffTargets(selectType, randNum, unit, index)
	local targetType = BattleTargetTable:getTargetType(selectType)

	if index == 1 then
		local allTargetChangeBuffs = self.fighter:getBuffsByNameAndFighter(xyd.BUFF_ALL_TARGET_CHANGE)

		if (self.skillID == self.fighter:getEnergySkillID() and self.fighter:isTargetChange() or allTargetChangeBuffs and next(allTargetChangeBuffs) and targetType == xyd.TargetType.TARGET_ENEMY) and BattleTargetTable:isCanChange(selectType) then
			selectType = 18
			randNum = 1
		end
	end

	if self.fighter:isRidicule() and targetType == xyd.TargetType.TARGET_ENEMY and BattleTargetTable:isCanChange(selectType) then
		selectType = 67
	end

	local targets = GetTarget_["S" .. selectType](self.fighter, randNum, unit)

	return targets
end

function ReportAttackUnit:isSkillMiss(target, index, fighter)
	if index > 1 then
		if next(self.missBuffs) then
			for _, buff in ipairs(self.missBuffs) do
				if buff.target == target then
					return true
				end
			end
		end

		return false
	end

	if not self.isNeedRecord and self.specialUnit_ then
		local specialUnit = self.specialUnit_
		local specialUnitMissBuffs = specialUnit:getMissBuffs()

		for _, missBuff in ipairs(specialUnitMissBuffs) do
			if missBuff.fighter == self.fighter and missBuff.target == target then
				return true
			end
		end

		return false
	end

	if fighter and not fighter:isPet() and not fighter:isGod() and target:getTeamType() ~= self.fighter:getTeamType() and fighter.hero_ ~= nil and (self.skillID == fighter:getEnergySkillID() or fighter:isPugongSkill(self.skillID)) then
		local missRate = target:getAvoidHurt()

		if xyd.weightedChoise({
			missRate,
			1 - missRate
		}) == 1 then
			return true
		end
	end

	return false
end

function ReportAttackUnit:isRestraint(attacker, defender)
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

function ReportAttackUnit:createBuff(target, effects, index)
	local tmpBuffs = {}

	local function newBuff(target, effectID, index)
		local params = {
			effectID = effectID,
			fighter = self.fighter,
			target = target,
			skillID = self.skillID,
			index = index,
			dieTarget = self.dieTarget,
			ifNoBlock = self.ifNoBlock
		}
		local buff = BuffManager:newBuff(params)

		buff:setIsHit(tmpBuffs)

		return buff
	end

	local noTriggerPas = false
	local isMiss = false
	local isCrit = false
	local hitBuffs = {}
	local missBuffs = {}
	local isFree = false
	local isBlock = false
	local fighterHitBuffs = {}

	local function getHurt()
		local hurt = 0

		for _, buff_ in ipairs(tmpBuffs) do
			if buff_:getName() == xyd.BUFF_HURT then
				hurt = hurt + buff_:getFinalNum()
			end

			if buff_:getName() == xyd.BUFF_HURT_MAX_H_LIMIT15 then
				hurt = hurt + buff_:getFinalNum()
			end

			if buff_:getName() == xyd.BUFF_HURT_MAX_H_LIMIT25 then
				hurt = hurt + buff_:getFinalNum()
			end

			if buff_:getName() == xyd.BUFF_ADD_HURT then
				hurt = hurt + buff_:getFinalNum()
			end

			if buff_:getName() == xyd.BUFF_PHURT_PAS_L_B or buff_:getName() == xyd.BUFF_PHURT_SKILL_L_B then
				hurt = hurt + buff_:getFinalNum()
			end

			if buff_:getName() == xyd.BUFF_SUCK_REAL_BLOOD then
				hurt = hurt + buff_:getFinalNum()
			end
		end

		return hurt
	end

	local feisinaExplodeBuff = nil
	local AtkImpressBonusNum = 0

	for i = 1, #effects do
		local buff = {}
		local effectID = effects[i]

		if effectID <= 0 then
			if effectID == xyd.SpecialEffect.NO_TRIGGER_TARGET then
				noTriggerPas = true
			end
		else
			local name_ = EffectTable:buff(effectID)

			if name_ == xyd.BUFF_SIPHON_HP then
				buff = newBuff(self.fighter, effectID, 2)
			elseif name_ == xyd.BUFF_RD_DOT or name_ == xyd.BUFF_RD_CONTROL then
				effectID = self:getRandEffect(effectID)
				name_ = EffectTable:buff(effectID)
				buff = newBuff(target, effectID, index)

				table.insert(tmpBuffs, buff)
			elseif name_ == xyd.BUFF_REVIVE_INF_BUFF then
				effectID = self:getRebornInfEffect(effectID)
				name_ = EffectTable:buff(effectID)
				buff = newBuff(target, effectID, index)

				table.insert(tmpBuffs, buff)
			elseif name_ == xyd.BUFF_BOSS_ATK_P then
				effectID = self:getBossEffect(effectID)
				buff = newBuff(target, effectID, index)

				table.insert(tmpBuffs, buff)
			else
				buff = newBuff(target, effectID, index)

				table.insert(tmpBuffs, buff)
			end

			if name_ == xyd.BUFF_HURT then
				xyd.Battle.lastHurtBuff = buff
			end

			if name_ == xyd.BUFF_FEISINA_EXPLODE then
				feisinaExplodeBuff = buff
			end

			if name_ == xyd.BUFF_ATK_IMPRESS_BONUS then
				local buffs = buff.target:getBuffsByNameAndFighter(name_, buff.fighter)

				if #buffs + AtkImpressBonusNum >= 8 then
					buff.isHit_ = false
				end
			end

			if buff:isFree() then
				isFree = true
			elseif buff:isHit() then
				if next(buff.target:getBuffsByNameAndFighter(xyd.BUFF_MAYA_BUFF_RESIST)) and buff:isAttrBuff() then
					local mayaResist = buff.target:getBuffsByNameAndFighter(xyd.BUFF_MAYA_BUFF_RESIST)[1]
					buff = mayaResist:excuteResist(buff, self)
				end

				if name_ == xyd.BUFF_ATK_IMPRESS_BONUS then
					AtkImpressBonusNum = AtkImpressBonusNum + 1
				end

				if buff:getName() == xyd.BUFF_SIPHON_HP then
					buff.basicHarm_ = -getHurt()

					buff:calculate()
					table.insert(fighterHitBuffs, buff)
				elseif buff:getName() == xyd.BUFF_DEBUFF_SAME then
					if xyd.Battle.lastDebuff then
						local lastDebuff = xyd.Battle.lastDebuff
						local newDebuff = newBuff(buff.target, lastDebuff.effectID, lastDebuff.skillIndex)

						if newDebuff.isHit_ and lastDebuff:isCanDebuffSame() then
							newDebuff.finalNum_ = lastDebuff.finalNum_
							local tmpArray = {}

							for i = 1, #lastDebuff.finalNumArray_ do
								tmpArray[i] = lastDebuff.finalNumArray_[i]
							end

							newDebuff.finalNumArray_ = tmpArray

							newDebuff:setLeftCount(lastDebuff:getCount())
							table.insert(hitBuffs, newDebuff)
						else
							table.insert(missBuffs, newDebuff)
						end
					end

					table.insert(hitBuffs, buff)
				elseif buff:getName() == xyd.BUFF_ENERGY_STEAL then
					local realEffects = EffectTable:num(effectID, true)
					local buff1 = newBuff(buff.target, realEffects[1], index)
					local buff2 = newBuff(buff.fighter, realEffects[2], index)

					buff1:calculate()
					buff2:calculate()

					local energyNum = buff.target:getEnergy()

					if energyNum < math.abs(buff1:getFinalNum()) then
						buff1.finalNum_ = -energyNum
						buff2.finalNum_ = energyNum
					end

					table.insert(hitBuffs, buff1)
					table.insert(fighterHitBuffs, buff2)
					table.insert(hitBuffs, buff)
				else
					buff:calculate()
					table.insert(hitBuffs, buff)

					if buff:isSiphon() then
						local num = buff:getFinalNum()
						buff.finalNum_ = -num
						local buff2 = newBuff(self.fighter, effectID, 2)
						buff2.finalNum_ = num

						table.insert(fighterHitBuffs, buff2)
					end
				end

				isCrit = isCrit or buff:isCrit()
			else
				table.insert(missBuffs, buff)
			end

			if buff:isBlock() then
				isBlock = true
			end

			if buff.hadHit and buff:isControlNew() and target:isImmenu() then
				local delBuff = target.isImmenu_[1]

				table.insert(xyd.Battle.needRemoveBuffs, delBuff)
				target:removeBuffs({
					delBuff
				})
			end

			if feisinaExplodeBuff and name_ == "hurt" then
				feisinaExplodeBuff.exploreHarmRecord = feisinaExplodeBuff.exploreHarmRecord - buff.finalNum_
			end
		end
	end

	self:recordTargets(target, isMiss, isCrit, isBlock, hitBuffs, missBuffs, isFree, index, noTriggerPas)

	if next(fighterHitBuffs) then
		self:recordTargets(self.fighter, false, false, false, fighterHitBuffs, {}, false, 2, noTriggerPas)
	end
end

function ReportAttackUnit:getRandEffect(effectID)
	local ids = EffectTable:num(effectID, true)
	local selectIds = xyd.randomSelects(ids, 1)

	return selectIds[1]
end

function ReportAttackUnit:getRebornInfEffect(effectID)
	local ids = EffectTable:num(effectID, true)
	local pos = math.min(#ids, self.rebornTimes_)

	return ids[pos]
end

function ReportAttackUnit:getBossEffect(effectID)
	local ids = EffectTable:num(effectID, true)
	local pos = math.min(#ids, xyd.Battle.round - 1)

	return ids[pos]
end

function ReportAttackUnit:getUnitDatas()
	return self.unitDatas_
end

function ReportAttackUnit:recordTargets(target, isMiss, isCrit, isBlock, hitBuffs, missBuffs, isFree, index, noTriggerPas)
	if noTriggerPas == nil then
		noTriggerPas = false
	end

	if isMiss then
		local buff = BuffManager:newBuff({
			isMiss = true,
			target = target
		})
		buff.skillIndex = index

		table.insert(self.missBuffs, buff)
	end

	if isFree then
		local buff = BuffManager:newBuff({
			isFree = true,
			target = target
		})

		table.insert(hitBuffs, buff)
	end

	self:saveTarget(target, index)
	table.insert(self.unitDatas_, {
		target = target,
		isMiss = isMiss,
		isBlock = isBlock,
		hitBuffs = hitBuffs,
		missBuffs = missBuffs,
		noTriggerPas = noTriggerPas,
		isCrit = isCrit
	})
end

function ReportAttackUnit:saveTarget(target, index)
	local targets = self.targetsPos_
	local pos = target:getPos()

	if index ~= 1 then
		targets = self.targets2Pos_
	end

	if xyd.arrayIndexOf(targets, pos) < 0 then
		table.insert(targets, pos)
	end

	if xyd.Battle.recordUnit then
		local recordIndex = xyd.Battle.recordUnit:getRecordIndex(self, index)

		xyd.Battle.recordUnit:saveTarget(target, recordIndex)
	end
end

function ReportAttackUnit:getRecords()
	local params = {
		skill_id = self.skillID,
		round = self.round_,
		buffs = self:getBuffsRecord(),
		targets = self:getTargetsRecord(),
		targets_2 = self:getTargets2Record(),
		pos = self.fighter and self.fighter:getPos() or 0,
		eps = self.eps
	}

	return params
end

function ReportAttackUnit:setUnitEp(pos, energy)
	if not self.eps then
		self.eps = {}
	end

	local hasPos = false

	for k, v in ipairs(self.eps) do
		if pos == v.pos then
			v.ep = energy
			hasPos = true
		end
	end

	if not hasPos then
		table.insert(self.eps, {
			pos = pos,
			ep = energy
		})
	end
end

function ReportAttackUnit:getBuffsRecord()
	if xyd.Battle.recordUnit then
		return xyd.Battle.recordUnit:getBuffsRecord()
	end

	return self.buffs_
end

function ReportAttackUnit:saveBuffsRecord(buffs, index)
	if xyd.Battle.isSweep then
		return
	end

	if not buffs or not next(buffs) then
		return
	end

	if xyd.Battle.recordUnit then
		local recordIndex = xyd.Battle.recordUnit:getRecordIndex(self, index)

		xyd.Battle.recordUnit:saveBuffsRecord(buffs, recordIndex)
	end
end

function ReportAttackUnit:saveBuffsRecord2(records, targets)
	if xyd.Battle.isSweep then
		return
	end

	if not records or not next(records) then
		return
	end

	for i = 1, #records do
		local record = records[i]

		table.insert(self.buffs_, record)
	end

	for i = 1, #targets do
		local pos = targets[i]

		if xyd.arrayIndexOf(self.targets2Pos_, pos) < 0 then
			table.insert(self.targets2Pos_, pos)
		end
	end

	if xyd.Battle.recordUnit then
		xyd.Battle.recordUnit:saveBuffsRecord2(records, targets)
	end
end

function ReportAttackUnit:getTargetsRecord()
	local params = {}

	for _, pos in pairs(self.targetsPos_) do
		table.insert(params, pos)
	end

	table.sort(params)

	return params
end

function ReportAttackUnit:getTargets2Record()
	local params = {}

	for _, pos in pairs(self.targets2Pos_) do
		table.insert(params, pos)
	end

	table.sort(params)

	return params
end

function ReportAttackUnit:recordBuffs(target, buffs)
	self:saveBuffsRecord(buffs)
end

function ReportAttackUnit:recordPasBuffs(target, buffs)
	self:saveBuffsRecord(buffs, 2)
end

function ReportAttackUnit:getMissBuffs()
	return self.missBuffs or {}
end

return ReportAttackUnit
