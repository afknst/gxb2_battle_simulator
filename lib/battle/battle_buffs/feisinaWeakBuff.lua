local feisinaWeakBuff = class("feisinaWeakBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable

function feisinaWeakBuff:ctor(params)
	feisinaWeakBuff.super.ctor(self, params)
end

function feisinaWeakBuff:setIsHit()
	local hasBuff = false

	if self.target:getBuffByName(xyd.BUFF_FEISINA_WEAK) then
		hasBuff = true
	end

	self:baseSetIsHit()

	if hasBuff and self.isHit_ then
		local buffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_WEAK)

		if buffs[1]:getCount() < self:getCount() then
			buffs[1].leftCount_ = self:getCount()
		end

		self.isHit_ = false
	end
end

function feisinaWeakBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = 0
	self.finalNumArray_ = EffectTable:num(self.effectID, true)
	finalNum = self.finalNumArray_[1]

	return finalNum
end

return feisinaWeakBuff
