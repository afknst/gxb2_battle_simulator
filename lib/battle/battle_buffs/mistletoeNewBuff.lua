local mistletoeNewBuff = class("mistletoeNewBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function mistletoeNewBuff:ctor(params)
	mistletoeNewBuff.super.ctor(self, params)

	self.endLoop = true
end

function mistletoeNewBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

	if next(buffs) and #buffs >= 3 then
		local newParams = {
			fighter = self.fighter,
			effectID = self.effectID,
			skillID = self.skillID,
			leftCount_ = self.leftCount_,
			skillIndex = self.skillIndex,
			dieTarget = self.dieTarget
		}
		local coverBuff = nil

		for _, mBuff in ipairs(buffs) do
			local mSkillID = mBuff.skillID

			if mSkillID < self.skillID then
				if not coverBuff then
					coverBuff = mBuff
				elseif mBuff:getCount() < coverBuff:getCount() then
					coverBuff = mBuff
				end
			end
		end

		self.isHit_ = false

		if coverBuff then
			coverBuff:coverParams(newParams)
			coverBuff:calculate()
		end
	else
		self:baseSetIsHit()
	end
end

function mistletoeNewBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function mistletoeNewBuff:excuteBuffAfterAttack(unit, recordBuffs)
	if self.fighter then
		self.fighter:usePasSkill(xyd.TriggerType.ATTACK_UNDER_MISTLETOE, unit)
	end
end

return mistletoeNewBuff
