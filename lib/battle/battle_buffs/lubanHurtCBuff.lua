local lubanHurtCBuff = class("lubanHurtCBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function lubanHurtCBuff:ctor(params)
	lubanHurtCBuff.super.ctor(self, params)
end

function lubanHurtCBuff:setIsHit()
	self:baseSetIsHit()
end

function lubanHurtCBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function lubanHurtCBuff:excuteBuff(unit, recordBuffs)
	local fighterBuffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_LUBAN_HURT_B)

	if next(fighterBuffs) then
		fighterBuffs[1]:writeRecord(self.target, xyd.BUFF_REMOVE)
		unit:recordBuffs(self.target, {
			fighterBuffs[1]
		})
		self.target:removeBuffs({
			fighterBuffs[1]
		})
	end
end

return lubanHurtCBuff
