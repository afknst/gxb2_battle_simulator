local godControlEnergyBuff = class("godControlEnergyBuff", xyd.Battle.getRequire("ReportBuff"))

function godControlEnergyBuff:ctor(params)
	godControlEnergyBuff.super.ctor(self, params)
end

function godControlEnergyBuff:setIsHit()
	self:baseSetIsHit()
end

function godControlEnergyBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num

	return finalNum
end

function godControlEnergyBuff:excuteAfterRound(unit)
	if self.target:getEnergy() <= 50 then
		self.target:setEnergy(0, unit, true)
	end
end

return godControlEnergyBuff
