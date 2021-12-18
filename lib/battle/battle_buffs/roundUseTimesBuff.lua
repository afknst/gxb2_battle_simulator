local roundUseTimesBuff = class("roundUseTimesBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function roundUseTimesBuff:ctor(params)
	roundUseTimesBuff.super.ctor(self, params)
end

function roundUseTimesBuff:setIsHit()
	self:baseSetIsHit()
end

function roundUseTimesBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function roundUseTimesBuff:excuteBuff(unit, recordBuffs)
	if not self.target.roundUseTimes then
		self.target.roundUseTimes = {}
	end

	local key = xyd.Battle.round .. "_" .. self.finalNumArray_[1] .. "_" .. self.finalNumArray_[2]

	if not self.target.roundUseTimes[key] then
		self.target.roundUseTimes[key] = 0
	end

	self.target.roundUseTimes[key] = self.target.roundUseTimes[key] + 1

	if self.finalNumArray_[2] < self.target.roundUseTimes[key] then
		return
	end

	local params1 = {
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID
	}

	BuffManager:addNewBuff(params1, unit)
end

return roundUseTimesBuff
