local sunArrowShootBuff = class("sunArrowShootBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function sunArrowShootBuff:ctor(params)
	sunArrowShootBuff.super.ctor(self, params)
end

function sunArrowShootBuff:setIsHit()
	self:baseSetIsHit()
end

function sunArrowShootBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = self:calculateHurtNum(self:getName(), num, buffData)

	return finalNum
end

function sunArrowShootBuff:excuteBuff(unit, recordBuffs)
	self:writeRecord(self.target, xyd.BUFF_WORK)
end

return sunArrowShootBuff
