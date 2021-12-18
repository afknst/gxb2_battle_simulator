local sunArrowBuff = class("sunArrowBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function sunArrowBuff:ctor(params)
	sunArrowBuff.super.ctor(self, params)
end

function sunArrowBuff:setIsHit()
	self:baseSetIsHit()

	self.maxCount = self.leftCount_
end

function sunArrowBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function sunArrowBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)
	self:writeRecord(self.target, xyd.BUFF_ON)
end

function sunArrowBuff:canAttack()
	if self.maxCount == self.leftCount_ then
		return false
	else
		return true
	end
end

return sunArrowBuff
