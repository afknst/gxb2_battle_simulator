local abcCopyBuff = class("abcCopyBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function abcCopyBuff:ctor(params)
	abcCopyBuff.super.ctor(self, params)
end

function abcCopyBuff:setIsHit()
	self:baseSetIsHit()

	if self.isHit_ then
		-- Nothing
	end
end

function abcCopyBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return self.finalNumArray_[1]
end

function abcCopyBuff:excuteBuff(unit, recordBuffs)
end

function abcCopyBuff:excuteAfterRound(unit)
end

return abcCopyBuff
