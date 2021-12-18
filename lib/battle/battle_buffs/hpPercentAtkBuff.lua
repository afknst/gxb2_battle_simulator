local hpPercentAtkBuff = class("hpPercentAtkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function hpPercentAtkBuff:ctor(params)
	hpPercentAtkBuff.super.ctor(self, params)
end

function hpPercentAtkBuff:setIsHit()
	self:baseSetIsHit()
end

function hpPercentAtkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function hpPercentAtkBuff:getAtkRate()
	local hpPercent = self.target:getHp() / self.target:getHpLimit()
	local x1 = self.finalNumArray_[1]
	local x2 = self.finalNumArray_[2]

	return (x2 - x1) * hpPercent + x1
end

return hpPercentAtkBuff
