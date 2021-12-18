local nuolisiAddRateBuff = class("nuolisiAddRateBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function nuolisiAddRateBuff:ctor(params)
	nuolisiAddRateBuff.super.ctor(self, params)

	self.usedTimes = 0
end

function nuolisiAddRateBuff:setIsHit()
	self.isHit_ = true
end

function nuolisiAddRateBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function nuolisiAddRateBuff:getAddHurt()
	return (self.usedTimes + 1) * self.finalNumArray_[1]
end

function nuolisiAddRateBuff:getAddRate()
	return self.usedTimes * self.finalNumArray_[2]
end

function nuolisiAddRateBuff:addExtraJumpSkill(unit)
	local extraSkillID = self.target:getEnergySubSkill()[1]

	for i = 1, self.finalNumArray_[3] do
		local ifNoBlock = false
		local curUnit = self.target:useOneJumpPasSkill(nil, extraSkillID, unit, false, ifNoBlock)

		self.target:checkCrystalPas(unit)

		if not curUnit then
			break
		end
	end

	self:writeRecord(nil, xyd.BUFF_OFF)
	unit:recordBuffs(self.target, {
		self
	})
	self.target:removeBuffs({
		self
	})

	if extraSkillID and self.target:isAddHurtCostEnergy(extraSkillID) then
		self.target:updateEnergy(0, unit)
	end
end

return nuolisiAddRateBuff
