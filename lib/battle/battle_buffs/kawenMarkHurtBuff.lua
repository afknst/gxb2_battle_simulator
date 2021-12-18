local kawenMarkHurtBuff = class("kawenMarkHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function kawenMarkHurtBuff:ctor(params)
	kawenMarkHurtBuff.super.ctor(self, params)
end

function kawenMarkHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function kawenMarkHurtBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function kawenMarkHurtBuff:excuteBuff(unit, recordBuffs)
	local marks = self.target:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK)

	if #marks == 0 then
		return
	end

	local params1 = {
		noAddEnergy = true,
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID
	}

	BuffManager:addNewBuff(params1, unit)
end

return kawenMarkHurtBuff
