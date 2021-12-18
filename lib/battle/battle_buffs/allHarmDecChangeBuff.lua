local allHarmDecChangeBuff = class("allHarmDecChangeBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable

function allHarmDecChangeBuff:ctor(params)
	allHarmDecChangeBuff.super.ctor(self, params)
end

function allHarmDecChangeBuff:setIsHit()
	self:baseSetIsHit()
	self:setRecordNum(0)
end

function allHarmDecChangeBuff:calculateFinalNum(name, num, buffData, forceHurt)
	self.recordFinalNum = self.finalNumArray_[1]

	return 0
end

function allHarmDecChangeBuff:excuteAfterRound(unit)
	self.recordFinalNum = self.recordFinalNum - self.finalNumArray_[2]

	if self.recordFinalNum <= 0 then
		self.recordFinalNum = 0
		local removeBuffLists = {}

		self:writeRecord(self.target, xyd.BUFF_REMOVE)
		unit:recordBuffs(self.target, {
			self
		})
		self.target:removeBuffs({
			self
		})
	end
end

return allHarmDecChangeBuff
