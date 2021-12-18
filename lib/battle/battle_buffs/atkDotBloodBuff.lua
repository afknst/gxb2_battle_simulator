local atkDotBloodBuff = class("atkDotBloodBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function atkDotBloodBuff:ctor(params)
	atkDotBloodBuff.super.ctor(self, params)
end

function atkDotBloodBuff:setIsHit()
	self:changeBuffName()
	self:baseSetIsHit()
	self:revertBuffName()
end

function atkDotBloodBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local sameAtkhurtBuff = xyd.Battle.lastSameAtkHurtBuff
	local finalNum = num

	if sameAtkhurtBuff then
		finalNum = sameAtkhurtBuff:getFinalNum() * finalNum
	end

	self:changeBuffName()

	return finalNum
end

return atkDotBloodBuff
