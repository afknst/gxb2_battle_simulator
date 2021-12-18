local sameAtkHurtBuff = class("sameAtkHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function sameAtkHurtBuff:ctor(params)
	sameAtkHurtBuff.super.ctor(self, params)
end

function sameAtkHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function sameAtkHurtBuff:calculateFinalNum(name, num, buffData, forceHurt)
	xyd.Battle.lastSameAtkHurtBuff = self

	self:changeBuffName()

	local finalNum = self:calculateHurtNum(self:getName(), num, buffData)

	return finalNum
end

return sameAtkHurtBuff
