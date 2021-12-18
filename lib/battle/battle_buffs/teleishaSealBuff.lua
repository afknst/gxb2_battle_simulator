local teleishaSealBuff = class("teleishaSealBuff", xyd.Battle.getRequire("ReportBuff"))
local battle_event = require("lib.battle.battle_event")
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function teleishaSealBuff:ctor(params)
	teleishaSealBuff.super.ctor(self, params)
end

function teleishaSealBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_SEAL)

	if next(buffs) then
		return
	else
		self:baseSetIsHit()

		self.attackedTimes = 4
	end
end

function teleishaSealBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function teleishaSealBuff:decreAttackedTimes(num)
	if not self.attackedTimes then
		self.attackedTimes = 4
	end

	self.attackedTimes = self.attackedTimes - num
	self.attackedTimes = math.max(self.attackedTimes, 0)

	return self.attackedTimes > 0
end

local function _set_reg(fighter, defender, unit)
	if fighter:isPet() or fighter:isGod() then
		return
	end

	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_SEAL)

	if not buffs or not next(buffs) then
		return
	end

	for _, buff in ipairs(buffs) do
		local status = buff:decreAttackedTimes(1)

		if not status then
			buff:writeRecord(defender, xyd.BUFF_REMOVE)
			unit:recordBuffs(defender, {
				buff
			})
			defender:removeBuffs({
				buff
			})
		end
	end
end

function teleishaSealBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_NORMAL_OR_SKILL_ATTACKED, _set_reg)
end

return teleishaSealBuff
