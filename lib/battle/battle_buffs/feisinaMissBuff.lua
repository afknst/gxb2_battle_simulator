local feisinaMissBuff = class("feisinaMissBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable

function feisinaMissBuff:ctor(params)
	feisinaMissBuff.super.ctor(self, params)
end

function feisinaMissBuff:setIsHit()
	local hasBuff = false

	if self.target:getBuffByName(xyd.BUFF_FEISINA_MISS) then
		hasBuff = true
	end

	self:baseSetIsHit()

	if hasBuff and self.isHit_ then
		local buffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_FEISINA_MISS)

		if buffs[1]:getCount() < self:getCount() then
			buffs[1].leftCount_ = self:getCount()
		end

		self.isHit_ = false
	end
end

function feisinaMissBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return EffectTable:num(self.effectID)
end

return feisinaMissBuff
