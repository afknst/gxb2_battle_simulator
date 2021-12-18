local unfreeRecieveBuff = class("unfreeRecieveBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function unfreeRecieveBuff:ctor(params)
	unfreeRecieveBuff.super.ctor(self, params)
end

function unfreeRecieveBuff:setIsHit()
	self:baseSetIsHit()

	if self.isHit_ then
		self.rate = self.finalNumArray_[1]
	end
end

function unfreeRecieveBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function unfreeRecieveBuff:excuteAfterRound(unit)
	self.rate = self.rate + self.finalNumArray_[1]
end

return unfreeRecieveBuff
