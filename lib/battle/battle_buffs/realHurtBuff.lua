local realHurtBuff = class("realHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function realHurtBuff:ctor(params)
	realHurtBuff.super.ctor(self, params)
end

function realHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function realHurtBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = self.fighter:getAD() * self.finalNumArray_[1]

	if self.target:isSuperDecHurt() then
		local tmpRate = self.target:getBuffTotalNumByGroup(self.target.isSuperDecHurt_)
		finalNum = finalNum * (1 - tmpRate)
	end

	return -finalNum
end

return realHurtBuff
