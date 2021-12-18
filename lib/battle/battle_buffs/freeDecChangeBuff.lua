local freeDecChangeBuff = class("freeDecChangeBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function freeDecChangeBuff:ctor(params)
	freeDecChangeBuff.super.ctor(self, params)
end

function freeDecChangeBuff:setIsHit()
	self:baseSetIsHit()

	if self.isHit_ then
		self.freeRate = self.finalNumArray_[1]
	end
end

function freeDecChangeBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function freeDecChangeBuff:excuteAfterRound(unit)
	self.freeRate = self.freeRate - self.finalNumArray_[2]

	if self.freeRate < 0 then
		self.freeRate = 0
	end
end

return freeDecChangeBuff
