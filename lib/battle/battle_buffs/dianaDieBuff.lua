local dianaDieBuff = class("dianaDieBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local battle_event = require("lib.battle.battle_event")

function dianaDieBuff:ctor(params)
	dianaDieBuff.super.ctor(self, params)
end

function dianaDieBuff:setIsHit()
	self:baseSetIsHit()

	if self.isHit_ and xyd.Battle.god and self.fighter == xyd.Battle.god then
		local godAdNum = self.finalNumArray_[2] or 0

		xyd.Battle.god:setAD(godAdNum)
	end
end

function dianaDieBuff:excuteAfterRound(unit)
	local params1 = {
		target = self.target,
		fighter = self.fighter,
		effectID = self.finalNumArray_[1],
		skillID = self.skillID
	}
	local displayBuff1 = BuffManager:newBuff(params1)
	displayBuff1.isHit_ = true

	displayBuff1:calculate()
	self.target:applyBuffHarm(unit, {
		displayBuff1
	})
	self.fighter:recordData(-displayBuff1:getFinalNum(), 0)

	local effectBuff = BuffManager:newBuff({
		target = self.target,
		skillID = self.skillID
	})
	effectBuff.name_ = xyd.BUFF_DIANA_DIE_EFFECT

	effectBuff:writeRecord(self.target, xyd.BUFF_WORK)
	unit:recordBuffs(self.target, {
		effectBuff
	})
end

function dianaDieBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

local function dieEffect(unit, dieTarget)
	local dieTargetBuffs = dieTarget:getBuffsByName(xyd.BUFF_DIANA_DIE)

	if not next(dieTargetBuffs) then
		return
	end

	for _, v in ipairs(dieTarget.selfTeam_) do
		if not v:isDeath() and v ~= dieTarget then
			local params1 = {
				target = v,
				fighter = dieTargetBuffs[1].fighter,
				effectID = dieTargetBuffs[1].finalNumArray_[1],
				skillID = dieTargetBuffs[1].skillID
			}
			local displayBuff1 = BuffManager:newBuff(params1)
			displayBuff1.isHit_ = true

			displayBuff1:calculate()
			v:applyBuffHarm(unit, {
				displayBuff1
			})
			dieTargetBuffs[1].fighter:recordData(-displayBuff1:getFinalNum(), 0)

			local effectBuff = BuffManager:newBuff({
				target = v,
				skillID = dieTargetBuffs[1].skillID
			})
			effectBuff.name_ = xyd.BUFF_DIANA_DIE_EFFECT

			effectBuff:writeRecord(v, xyd.BUFF_WORK)
			unit:recordBuffs(v, {
				effectBuff
			})
		end
	end
end

function dianaDieBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_DIE, dieEffect)
end

return dianaDieBuff
