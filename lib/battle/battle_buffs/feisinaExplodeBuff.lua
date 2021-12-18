local feisinaExplodeBuff = class("feisinaExplodeBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable

function feisinaExplodeBuff:ctor(params)
	feisinaExplodeBuff.super.ctor(self, params)

	self.exploreHarmRecord = 0
	self.hasSameBuff = false
end

function feisinaExplodeBuff:setIsHit()
	local hasBuff = false

	if self.target:getBuffByName(xyd.BUFF_FEISINA_EXPLODE) then
		hasBuff = true
	end

	self:baseSetIsHit()

	if hasBuff and self.isHit_ then
		self.hasSameBuff = true
	end
end

function feisinaExplodeBuff:isDot()
	if self.hasSameBuff then
		return false
	else
		return true
	end
end

function feisinaExplodeBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = 0
	local maxNum = 0
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	if self.hasSameBuff then
		finalNum = self:calculateNum(self.finalNumArray_[2], true, self.target:getHpLimit())
		maxNum = self.fighter:getAD() * 15
	else
		finalNum = self:calculateNum(self.finalNumArray_[1], true, self.exploreHarmRecord)
		maxNum = self.fighter:getAD() * 40
	end

	if finalNum > maxNum then
		finalNum = maxNum
	end

	finalNum = -finalNum

	return finalNum
end

function feisinaExplodeBuff:excuteBuff(unit, recordBuffs)
	if self.hasSameBuff then
		self:writeRecord(self.target, xyd.BUFF_WORK)
	end
end

function feisinaExplodeBuff:excuteAfterRound(unit)
	if not self.hasSameBuff and not self.target:isDeath() then
		local finalNum = self:calculateFinalNum()

		self.target:updateHpByHarm(finalNum, unit, false, false, false, self)
		self:setRecordNum(finalNum)
		self.fighter:recordData(-finalNum, 0)
		self:writeRecord(self.target, xyd.BUFF_OFF)
	end
end

return feisinaExplodeBuff
