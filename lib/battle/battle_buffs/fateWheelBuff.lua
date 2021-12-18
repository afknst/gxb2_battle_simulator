local fateWheelBuff = class("fateWheelBuff", xyd.Battle.getRequire("ReportBuff"))
local battle_event = xyd.Battle.getRequire("battle_event")
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function fateWheelBuff:ctor(params)
	fateWheelBuff.super.ctor(self, params)
end

function fateWheelBuff:setIsHit()
	self:baseSetIsHit()

	local buffs = self.target:getBuffsByName(self:getName())

	if next(buffs) then
		self.isHit_ = false
	end

	if self.isHit_ then
		self.target.usedRoundFreeHarm = false
	end
end

function fateWheelBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return 0
end

function fateWheelBuff:cureByBuff(unit, value)
	local healBuff = BuffManager:newBuff({
		effectID = self.finalNumArray_[3],
		skillID = unit.skillID,
		target = self.target,
		fighter = self.fighter
	})
	healBuff.finalNum_ = EffectTable:num(self.finalNumArray_[3]) * value
	local num = healBuff:getFinalNum()
	num = num * healBuff.target:getExtraHealRate()
	num = healBuff.target:blockHeal(num, unit, healBuff)

	healBuff.target:updateHpByHeal(num, unit, true)
	healBuff:setRecordNum(num)
	healBuff.fighter:recordData(0, num)
	healBuff:writeRecord(healBuff.target, xyd.BUFF_WORK)
	unit:recordPasBuffs(healBuff.target, {
		healBuff
	})
end

local function _set_reg(fighter, unit, value)
	if fighter:isPet() or fighter:isGod() then
		return
	end

	for k, v in ipairs(fighter.selfTeam_) do
		if v ~= fighter then
			local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_FATE_WHEEL, fighter)

			if next(buffs) then
				buffs[1]:cureByBuff(unit, value)

				break
			end
		end
	end
end

function fateWheelBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_HEAL, _set_reg)
end

return fateWheelBuff
