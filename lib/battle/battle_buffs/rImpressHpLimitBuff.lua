local rImpressHpLimitBuff = class("rImpressHpLimitBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local math_max = math.max

function rImpressHpLimitBuff:ctor(params)
	rImpressHpLimitBuff.super.ctor(self, params)
end

function rImpressHpLimitBuff:setIsHit()
	local name = self:getName()
	self.isHit_ = true
end

function rImpressHpLimitBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num

	return finalNum
end

function rImpressHpLimitBuff:getFinalNum(index)
	local num = rImpressHpLimitBuff.super.getFinalNum(self, index)

	return num
end

function rImpressHpLimitBuff:roundUpdate(params)
	local unit = params.unit
	local needRecord = false
	local needRemove = false

	self:delCount()

	if self:getCount() <= 0 then
		local target = self.target
		local num = self:getFinalNum()
		num = target:checkRimpressDoubleD(num)
		local hpLimit = target:getHpLimit()
		num = -num * hpLimit

		target:updateHpByHarm(num, unit, true, false, false, self)
		self:setRecordNum(num)
		target:recordData(-num, 0)
		self:writeRecord(target, xyd.BUFF_OFF)

		needRecord = true
		needRemove = true
	end

	return needRecord, needRemove
end

return rImpressHpLimitBuff
