local naturalLawBuff = class("naturalLawBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local math_max = math.max
local battle_event = require("lib.battle.battle_event")

function naturalLawBuff:ctor(params)
	naturalLawBuff.super.ctor(self, params)
end

function naturalLawBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_NATURAL_LAW)

	if not next(buffs) then
		self:baseSetIsHit()
	end
end

function naturalLawBuff:calculateFinalNum(name, num, isPercent, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function naturalLawBuff:increRecoverTimes()
	if not self.recordRound or self.recordRound ~= xyd.Battle.round then
		self.recordRound = xyd.Battle.round
		self.canRecover = true
		self.recoverTimes = 0
	end

	if not self.canRecover then
		return false
	end

	if not self.recoverTimes then
		self.recoverTimes = 0
	end

	self.recoverTimes = self.recoverTimes + 1

	return true
end

local function _set_reg(fighter, defender, unit)
	if not fighter or not defender or fighter:isPet() or fighter:isGod() then
		return
	end

	local mBuffs = fighter:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

	if not mBuffs or not next(mBuffs) then
		return
	end

	local nBuffs = defender:getBuffsByNameAndFighter(xyd.BUFF_NATURAL_LAW)

	if not nBuffs or not next(nBuffs) then
		return
	end

	local nBuff = nBuffs[1]
	local isCanRecover = nBuff:increRecoverTimes()

	if not isCanRecover then
		return
	end

	local finalNum = nBuff:getFinalNum()
	local hpLimit = defender:getHpLimit()
	local healHp = math.floor(hpLimit * finalNum)
	healHp = healHp * defender:getExtraHealRate()
	healHp = defender:blockHeal(healHp, unit, nBuff)

	if healHp > 0 then
		defender:updateHpByHeal(healHp, unit)
		defender:recordData(0, healHp)

		local params1 = {
			target = defender,
			fighter = defender
		}
		local displayBuff1 = xyd.newBuff(params1)
		displayBuff1.isHit_ = true
		displayBuff1.name_ = xyd.BUFF_NATURAL_LAW_HEAL
		displayBuff1.preName_ = xyd.BUFF_NATURAL_LAW_HEAL

		displayBuff1:setRecordNum(healHp)
		displayBuff1:writeRecord(defender, xyd.BUFF_WORK)
		unit:recordBuffs(defender, {
			displayBuff1
		})
	end

	local hpPercent = defender:getHp() / (defender:getHpLimit() - defender:getLoseSealHp())

	if hpPercent >= 1 and nBuff.recoverTimes >= 8 then
		nBuff.canRecover = false
	end
end

function naturalLawBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_HURTED, _set_reg)
end

return naturalLawBuff
