local totalHarmSiphonBuff = class("totalHarmSiphonBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function totalHarmSiphonBuff:ctor(params)
	totalHarmSiphonBuff.super.ctor(self, params)
end

function totalHarmSiphonBuff:setIsHit()
	self.target = self.fighter

	self:baseSetIsHit()
end

function totalHarmSiphonBuff:calculateFinalNum(name, num, buffData, forceHurt)
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return self.finalNumArray_[1]
end

function totalHarmSiphonBuff:excuteBuff(unit, recordBuffs)
	if xyd.Battle.oneSkillHarmRecord == 0 then
		return
	end

	local num = self.finalNumArray_[1]

	self:setRecordNum(num * xyd.Battle.oneSkillHarmRecord)

	num = num * xyd.Battle.oneSkillHarmRecord
	num = num * self.fighter:getExtraHealRate()
	self.fighter.blockHealUnit = nil
	num = self.fighter:blockHeal(num, unit, self)

	self:delCount()
	self.fighter:updateHpByHeal(num, unit)
	self.fighter:recordData(0, num)

	self.target = self.fighter

	self:setRecordNum(num)

	if self:getCount() <= 0 then
		self:writeRecord(self.fighter, xyd.BUFF_WORK)
	else
		self:writeRecord(self.fighter, xyd.BUFF_ON_WORK)
	end

	table.insert(recordBuffs, self)

	xyd.Battle.oneSkillHarmRecord = 0
end

function totalHarmSiphonBuff:isHeal()
	return true
end

return totalHarmSiphonBuff
