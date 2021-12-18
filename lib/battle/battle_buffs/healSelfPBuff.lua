local healSelfPBuff = class("healSelfPBuff", xyd.Battle.getRequire("ReportBuff"))

function healSelfPBuff:ctor(params)
	healSelfPBuff.super.ctor(self, params)
end

function healSelfPBuff:setIsHit()
	self:baseSetIsHit()
end

function healSelfPBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = self:calculateNum(self.finalNumArray_[1], true, self.fighter:getHpLimit())
	finalNum = self:updateHealNum(finalNum)

	return finalNum
end

function healSelfPBuff:isHeal()
	return true
end

return healSelfPBuff
