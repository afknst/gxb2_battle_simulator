local costCurrentHpBuff = class("costCurrentHpBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function costCurrentHpBuff:ctor(params)
	costCurrentHpBuff.super.ctor(self, params)
end

function costCurrentHpBuff:setIsHit()
	self.isHit_ = self.target:isDeath() == false
end

function costCurrentHpBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = math.floor(self.finalNumArray_[1] * self.target:getHp())

	return -finalNum
end

function costCurrentHpBuff:excuteBuff(unit, recordBuffs)
	local hp = self.target:getHp() + self.finalNum_

	if hp <= 0 then
		hp = 1
	end

	self.target:updateHp(hp)
	self:writeRecord(self.target, xyd.BUFF_WORK)
end

return costCurrentHpBuff
