local deathMarkBuff = class("deathMarkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local battle_event = require("lib.battle.battle_event")

function deathMarkBuff:ctor(params)
	deathMarkBuff.super.ctor(self, params)
end

function deathMarkBuff:setIsHit()
	self.isHit_ = true
end

function deathMarkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function deathMarkBuff:excuteAfterRound(unit)
	if self.leftCount_ == 1 then
		self.target:updateHpByDeath(self.target:getHp(), unit)
	end
end

local function dieEffect(unit, dieTarget)
	local dieTargetBuffs = dieTarget:getBuffsByName(xyd.BUFF_DEATH_MARK)

	if #dieTargetBuffs == 0 then
		return
	end

	if dieTargetBuffs[1].finalNumArray_[1] ~= 0 then
		for _, v in ipairs(dieTarget.selfTeam_) do
			if not v:isDeath() and v ~= dieTarget and not v:isExile() then
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
			end
		end
	end

	local theTarget = nil

	for _, v in ipairs(dieTarget.selfTeam_) do
		if not v:isDeath() and v ~= dieTarget and not v:isExile() then
			if theTarget then
				if theTarget:getAD() < v:getAD() then
					theTarget = v
				end
			else
				theTarget = v
			end
		end
	end

	if not theTarget then
		return
	end

	local params2 = {
		target = theTarget,
		fighter = dieTargetBuffs[1].fighter,
		effectID = dieTargetBuffs[1].effectID,
		skillID = dieTargetBuffs[1].skillID
	}
	local displayBuff = BuffManager:newBuff(params2)
	displayBuff.isHit_ = 1

	displayBuff:calculate()
	displayBuff:writeRecord(theTarget, xyd.BUFF_ON_WORK)
	unit:recordBuffs(theTarget, {
		displayBuff
	})
	theTarget:addBuffs({
		displayBuff
	}, unit)
	dieTargetBuffs[1]:writeRecord(dieTargetBuffs[1].target, xyd.BUFF_REMOVE)
	unit:recordBuffs(dieTargetBuffs[1].target, {
		dieTargetBuffs[1]
	})
	dieTargetBuffs[1].target:removeBuffs({
		dieTargetBuffs[1]
	})
end

function deathMarkBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_DIE, dieEffect)
end

return deathMarkBuff
