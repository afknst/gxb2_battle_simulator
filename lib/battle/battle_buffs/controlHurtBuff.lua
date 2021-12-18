local controlHurtBuff = class("controlHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function controlHurtBuff:ctor(params)
	controlHurtBuff.super.ctor(self, params)
end

function controlHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function controlHurtBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function controlHurtBuff:excuteBuff(unit, recordBuffs)
	if self.target:getTeamType() == self.fighter:getTeamType() then
		return
	end

	if not self.target:isControl() then
		return
	end

	local params1 = {
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID
	}

	BuffManager:addNewBuff(params1, unit)
end

return controlHurtBuff
