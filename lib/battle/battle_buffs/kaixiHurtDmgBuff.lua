local kaixiHurtDmgBuff = class("kaixiHurtDmgBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local battle_event = require("lib.battle.battle_event")

function kaixiHurtDmgBuff:ctor(params)
	kaixiHurtDmgBuff.super.ctor(self, params)
end

function kaixiHurtDmgBuff:setIsHit()
	self:baseSetIsHit()
end

function kaixiHurtDmgBuff:isBuffLimit()
	local buffs = self.target:getBuffsByNameAndFighter(self:getName())

	if next(buffs) then
		return true
	end

	return false
end

function kaixiHurtDmgBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return 0
end

function kaixiHurtDmgBuff:excuteBuff(unit, recordBuffs)
	self:writeRecord(self.target, xyd.BUFF_ON_WORK)
end

function kaixiHurtDmgBuff:useBuff(unit)
	local datas = unit:getUnitDatas()

	for _, data in ipairs(datas) do
		local target = data.target

		if self.target:getTeamType() ~= target:getTeamType() then
			if data.isMiss then
				return
			else
				local params1 = {
					target = target,
					fighter = self.target,
					effectID = self.finalNumArray_[1],
					skillID = unit.skillID
				}
				local displayBuff1 = BuffManager:newBuff(params1)
				displayBuff1.isHit_ = 1

				displayBuff1:calculate()

				unit.lastFighter = self.fighter

				target:applyBuffHarm(unit, {
					displayBuff1
				})
				self.fighter:recordData(-displayBuff1:getFinalNum(), 0)

				if target:isDeath() and target:getDieRound() == 0 then
					target:die(unit)
				end
			end
		end
	end

	local recordBuffs = {}
	local params2 = {
		target = self.target,
		fighter = self.target,
		effectID = self.finalNumArray_[2],
		skillID = unit.skillID
	}
	local displayBuff2 = BuffManager:newBuff(params2)
	displayBuff2.isHit_ = 1

	displayBuff2:calculate()
	displayBuff2:excuteBuff(unit, recordBuffs)
	unit:recordBuffs(self.target, {
		displayBuff2
	})
	self.target:addBuffs({
		displayBuff2
	}, unit)
end

local function _set_reg(fighter, defender, unit)
	if fighter:isPet() or fighter:isGod() then
		return
	end

	local buffs = fighter:getBuffsByNameAndFighter(xyd.BUFF_KAIXI_HURT_DMG)

	if next(buffs) then
		buffs[1]:useBuff(unit)
	end
end

function kaixiHurtDmgBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_UNIT_FINISH, _set_reg)
end

return kaixiHurtDmgBuff
