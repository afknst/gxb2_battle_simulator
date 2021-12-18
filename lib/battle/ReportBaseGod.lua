local ReportBaseGod = class("ReportBaseGod", xyd.Battle.getRequire("ReportBaseFighter"))
local SkillTable = xyd.tables.skillTable
local BuffTable = xyd.tables.dBuffTable
local math_max = math.max

function ReportBaseGod:init()
	ReportBaseGod.super.init(self)

	self.skills_ = {}
	self.forverBuffs_ = {}
end

function ReportBaseGod:canAttack()
	return false
end

function ReportBaseGod:isDeath()
	return false
end

function ReportBaseGod:isGod()
	return true
end

function ReportBaseGod:setInfo(info)
	self.skills_ = info.skills or {}
end

function ReportBaseGod:getPasSkill()
	if self.pasSkills_ == nil then
		local skills = self.skills_
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

function ReportBaseGod:getHpLimit()
	return 1
end

function ReportBaseGod:getHp()
	return 1
end

function ReportBaseGod:addInitBuffs()
	local recordUnit = self:createAttackUnit(-1, true, nil, true)
	local pasSkills = self:getPasSkill()
	local foreverSkills = pasSkills[xyd.TriggerType.FOREVER] or {}

	for _, skillID in ipairs(foreverSkills) do
		local unit = self:createAttackUnit(skillID, true)
		local datas = unit:getUnitDatas()
		local ifChangeHp = false

		for _, data in ipairs(datas) do
			local hitBuffs = data.hitBuffs
			local target = data.target

			if not self.forverBuffs_[target:getPos()] then
				self.forverBuffs_[target:getPos()] = {}
			end

			for i = #hitBuffs, 1, -1 do
				local buff = hitBuffs[i]

				buff:setYongJiu(true)
				buff:writeRecord(target, xyd.BUFF_ON)
				table.insert(self.forverBuffs_[target:getPos()], buff)

				if buff:getName() == xyd.BUFF_HP or buff:getName() == xyd.BUFF_HP_P then
					ifChangeHp = true
				end
			end

			target:addBuffs(hitBuffs, unit)

			if ifChangeHp then
				target:initHp()
			end

			recordUnit:recordPasBuffs(target, hitBuffs)
		end
	end

	local selfAttackedSkills = self:getPasSkillByType(xyd.TriggerType.SELF_ATTACKED)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfAttackedSkills)
	end

	local selfBeforHurtedSkills = self:getPasSkillByType(xyd.TriggerType.SELF_BEFOR_HURTED)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfBeforHurtedSkills)
	end

	local selfDieHitSkills = self:getPasSkillByType(xyd.TriggerType.DIE_HIT)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfDieHitSkills)
	end

	local enemyDieHitSkills = self:getPasSkillByType(xyd.TriggerType.ENEMY_DIE_HIT)

	for _, v in ipairs(xyd.Battle.teamB) do
		v:addPasSkill(enemyDieHitSkills)
	end

	local selfAttackSkills = self:getPasSkillByType(xyd.TriggerType.SELF_ATTACK_WITH_HARM)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfAttackSkills)
	end

	local selfSkillSkills = self:getPasSkillByType(xyd.TriggerType.SELF_SKILL)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfSkillSkills)
	end

	local selfCritSkills = self:getPasSkillByType(xyd.TriggerType.SELF_ATTACK_WITH_CRIT)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfCritSkills)
	end

	local selfRoundReflectSkills = self:getPasSkillByType(xyd.TriggerType.SELF_ROUND_REFLECT_ATTACKED)

	for _, v in ipairs(xyd.Battle.teamA) do
		v:addPasSkill(selfRoundReflectSkills)
	end

	self:playStartSkill(recordUnit)
end

function ReportBaseGod:playStartSkill(recordUnit)
	local skills = self:getPasSkillByType(xyd.TriggerType.BATTLE_START)

	for _, skillID in ipairs(skills) do
		local unit = self:createAttackUnit(skillID, true)
		local datas = unit:getUnitDatas()

		if self:checkIsHpStartSkill(skillID) then
			for _, data in ipairs(datas) do
				local target = data.target
				local harm, cure, isCrit, recordBuffs = target:applyBuffHarmsByTarget(data, unit, true)

				recordUnit:recordPasBuffs(target, recordBuffs)
			end
		else
			for _, data in ipairs(datas) do
				local hitBuffs = data.hitBuffs
				local target = data.target

				for i = #hitBuffs, 1, -1 do
					local buff = hitBuffs[i]
					local num = buff:getFinalNum()

					if buff:getName() == xyd.BUFF_ENERGY then
						target:addEnergy(num, recordUnit)
					else
						buff:writeRecord(target, xyd.BUFF_ON)
					end

					if buff:getCount() <= 0 then
						table.remove(hitBuffs, i)
					end
				end

				target:addBuffs(hitBuffs, unit)
				recordUnit:recordPasBuffs(target, hitBuffs)
			end
		end
	end
end

function ReportBaseGod:checkIsHpStartSkill(skillID)
	if tonumber(skillID) == 10201 or tonumber(skillID) == 400401 then
		return true
	end

	return false
end

function ReportBaseGod:addForverBuffs(target, unit)
	local buffs = self.forverBuffs_[target:getPos()]

	if buffs then
		target:addBuffs(buffs, unit)
		unit:recordPasBuffs(target, buffs)
	end
end

function ReportBaseGod:setAD(num)
	self.godAD = num
end

function ReportBaseGod:getAD()
	return self.godAD or 0
end

function ReportBaseGod:getAttrByType(attrType, isRate)
	if not self.___attrCache[attrType] then
		local basic = 0

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

return ReportBaseGod
