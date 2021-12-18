local exchangeAtkBuff = class("exchangeAtkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function exchangeAtkBuff:ctor(params)
	exchangeAtkBuff.super.ctor(self, params)
end

function exchangeAtkBuff:setIsHit()
	self:baseSetIsHit()

	if self.target:getAD() <= self.fighter:getAD() then
		self.isHit_ = false
	end
end

function exchangeAtkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = self.target:getAD()
	local exchangeNum = math.abs(self.fighter:getAD() - finalNum)

	if exchangeNum > self.fighter:getAD() * self.finalNumArray_[1] then
		exchangeNum = self.fighter:getAD() * self.finalNumArray_[1]
	end

	finalNum = -exchangeNum
	self.fighterAtkChange = exchangeNum

	return finalNum
end

function exchangeAtkBuff:excuteBuff(unit, recordBuffs, status)
	local params1 = {
		target = self.fighter,
		fighter = self.target,
		effectID = self.effectID,
		skillID = unit.skillID
	}
	local displayBuff1 = BuffManager:newBuff(params1)
	displayBuff1.isHit_ = true
	displayBuff1.finalNum_ = self.fighterAtkChange

	self.fighter:addBuffs({
		displayBuff1
	})
	displayBuff1:writeRecord(self.fighter, xyd.BUFF_ON)
	unit:recordBuffs(self.fighter, {
		displayBuff1
	})
end

return exchangeAtkBuff
