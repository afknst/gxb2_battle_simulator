local luobiHpBuff = class("luobiHpBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function luobiHpBuff:ctor(params)
	luobiHpBuff.super.ctor(self, params)
end

function luobiHpBuff:setIsHit()
	self:baseSetIsHit()
end

function luobiHpBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function luobiHpBuff:getHarmRate()
	local lostHp = self.target:getHpLimit() - self.target:getHp()
	local rate = self.finalNumArray_[1] / (1 - self.finalNumArray_[3]) * lostHp / self.target:getHpLimit()

	return math.min(rate, self.finalNumArray_[1])
end

function luobiHpBuff:getDefRate()
	local lostHp = self.target:getHpLimit() - self.target:getHp()
	local rate = self.finalNumArray_[2] / (1 - self.finalNumArray_[3]) * lostHp / self.target:getHpLimit()

	return math.min(rate, self.finalNumArray_[2])
end

return luobiHpBuff
