local luobiPreCombolBuff = class("luobiPreCombolBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function luobiPreCombolBuff:ctor(params)
	luobiPreCombolBuff.super.ctor(self, params)

	self.usedTimes = 0
end

function luobiPreCombolBuff:setIsHit()
	self.isHit_ = true
end

function luobiPreCombolBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function luobiPreCombolBuff:addExtraJumpSkill(unit)
	local extraSkillID = self.target:getEnergySubSkill()[1]
	local marks = self.target:getBuffsByName(xyd.BUFF_LUOBI_MARK)

	for i = 1, #marks do
		local ifNoBlock = false
		local curUnit = self.target:useOneJumpPasSkill(nil, extraSkillID, unit, false, ifNoBlock)

		marks[i]:writeRecord(nil, xyd.BUFF_OFF)

		if not curUnit then
			break
		end
	end

	unit:recordBuffs(self.target, marks)
	self.target:removeBuffs(marks)
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

return luobiPreCombolBuff
