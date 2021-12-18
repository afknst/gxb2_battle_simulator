local atkDotBuff = class("atkDotBuff", xyd.Battle.getRequire("ReportBuff"))
local math_max = math.max

function atkDotBuff:ctor(params)
	atkDotBuff.super.ctor(self, params)
end

function atkDotBuff:setIsHit()
	self:baseSetIsHit()
end

function atkDotBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local harm = self.target.roundHarm[xyd.Battle.round - 1] or 0
	local finalNum = -harm * num

	self:changeBuffName()

	return finalNum
end

return atkDotBuff
