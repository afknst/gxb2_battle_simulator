local atkDotPoisonBuff = class("atkDotPoisonBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function atkDotPoisonBuff:ctor(params)
	atkDotPoisonBuff.super.ctor(self, params)
end

function atkDotPoisonBuff:setIsHit()
	self:baseSetIsHit()
end

function atkDotPoisonBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local sameAtkhurtBuff = xyd.Battle.lastSameAtkHurtBuff
	sameAtkhurtBuff = sameAtkhurtBuff or xyd.Battle.lastHurtBuff
	local finalNum = sameAtkhurtBuff:getFinalNum() * num

	if not sameAtkhurtBuff then
		finalNum = 0
	end

	self:changeBuffName()

	return finalNum
end

return atkDotPoisonBuff
