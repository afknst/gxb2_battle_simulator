local lubanHurtDirectBuff = class("lubanHurtDirectBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function lubanHurtDirectBuff:ctor(params)
	lubanHurtDirectBuff.super.ctor(self, params)
end

function lubanHurtDirectBuff:setIsHit()
	self:baseSetIsHit()
end

function lubanHurtDirectBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function lubanHurtDirectBuff:excuteBuff(unit, recordBuffs)
	local params1 = {
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID
	}
	local buff = BuffManager:addNewBuff(params1, unit)

	if buff.isHit_ == 1 then
		local fighterBuffs = self.fighter:getBuffsByNameAndFighter(xyd.BUFF_LUBAN_HURT_B)

		if next(fighterBuffs) then
			fighterBuffs[1]:writeRecord(self.fighter, xyd.BUFF_REMOVE)
			unit:recordBuffs(self.fighter, {
				fighterBuffs[1]
			})
			self.fighter:removeBuffs({
				fighterBuffs[1]
			})
		end
	end
end

return lubanHurtDirectBuff
