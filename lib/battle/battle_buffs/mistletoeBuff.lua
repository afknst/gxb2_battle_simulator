local mistletoeBuff = class("mistletoeBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function mistletoeBuff:ctor(params)
	mistletoeBuff.super.ctor(self, params)
end

function mistletoeBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE)

	if next(buffs) then
		local newParams = {
			fighter = self.fighter,
			effectID = self.effectID,
			skillID = self.skillID,
			leftCount_ = self.leftCount_,
			skillIndex = self.skillIndex,
			dieTarget = self.dieTarget
		}
		self.isHit_ = false

		for _, buff in ipairs(buffs) do
			buff:coverParams(newParams)
			buff:calculate()
		end
	else
		self:baseSetIsHit()
	end
end

function mistletoeBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function mistletoeBuff:excuteBuffAfterAttack(unit, recordBuffs)
	if self.fighter then
		self.fighter:usePasSkill(xyd.TriggerType.ATTACK_UNDER_MISTLETOE, unit)
	end
end

return mistletoeBuff
