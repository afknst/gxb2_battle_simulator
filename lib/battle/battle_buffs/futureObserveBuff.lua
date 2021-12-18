local futureObserveBuff = class("futureObserveBuff", xyd.Battle.getRequire("ReportBuff"))
local battle_event = xyd.Battle.getRequire("battle_event")
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function futureObserveBuff:ctor(params)
	futureObserveBuff.super.ctor(self, params)
end

function futureObserveBuff:setIsHit()
	self:baseSetIsHit()
end

function futureObserveBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local paramsBuffs = self.fighter:getBuffsByName(xyd.BUFF_FUTURE_OBSERVE_PARAMS)

	if next(paramsBuffs) then
		self.finalNumArray_ = paramsBuffs[1].finalNumArray_
	else
		self.finalNumArray_ = {}
	end

	return 0
end

function futureObserveBuff:useForFreeHarm(fighter, defender, unit)
	if not next(self.finalNumArray_) then
		return
	end

	defender.usedRoundFreeHarm = true
	local params2 = {
		target = defender,
		fighter = fighter,
		effectID = self.finalNumArray_[1],
		skillID = self.skillID
	}
	local displayBuff = BuffManager:newBuff(params2)
	displayBuff.isHit_ = 1

	displayBuff:calculate()
	unit:recordBuffs(defender, {
		displayBuff
	})
	defender:addBuffs({
		displayBuff
	}, unit)
	self:writeRecord(nil, xyd.BUFF_REMOVE)
	unit:recordPasBuffs(self.target, {
		self
	})
	self.target:removeBuffs({
		self
	}, nil, unit)
end

function futureObserveBuff:useForAddBuff(fighter, defender, unit)
	if not next(self.finalNumArray_) then
		return false
	end

	local ownTimeRule = 0

	for k, v in ipairs(defender.selfTeam_) do
		local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_TIME_RULE)

		if next(buffs) and buffs[1].fighter == fighter then
			ownTimeRule = ownTimeRule + 1
		end
	end

	if ownTimeRule >= 2 then
		return false
	end

	local params2 = {
		target = defender,
		fighter = fighter,
		effectID = self.finalNumArray_[2],
		skillID = self.skillID
	}
	local displayBuff = BuffManager:newBuff(params2)
	displayBuff.isHit_ = 1

	displayBuff:calculate()
	displayBuff:writeRecord(defender, xyd.BUFF_ON_WORK)
	unit:recordBuffs(defender, {
		displayBuff
	})
	defender:addBuffs({
		displayBuff
	}, unit)
	self:writeRecord(nil, xyd.BUFF_REMOVE)
	unit:recordPasBuffs(self.target, {
		self
	})
	self.target:removeBuffs({
		self
	}, nil, unit)

	return true
end

local function _set_reg(fighter, defender, unit)
	if defender:isPet() or defender:isGod() then
		return
	end

	if defender.usedRoundFreeHarm then
		return
	end

	local roundFreeHarmBuff = defender:getBuffsByName(xyd.BUFF_ROUND_FREE_HARM)

	if next(roundFreeHarmBuff) then
		return
	end

	for k, v in ipairs(defender.selfTeam_) do
		if v ~= defender then
			local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_FUTURE_OBSERVE)

			if next(buffs) and not buffs[1].fighter:isSeal() and not buffs[1].fighter:isForceSeal() then
				buffs[1]:useForFreeHarm(v, defender, unit)

				break
			end
		end
	end
end

local function _set_enemy_hitted_reg(fighter, defender, unit)
	if defender:isSeal() or defender:isForceSeal() then
		return
	end

	if not fighter or not defender or defender:isPet() or defender:isGod() then
		return
	end

	if fighter:getTeamType() == defender:getTeamType() then
		return
	end

	if defender:getHp() / defender:getHpLimit() >= 0.7 then
		return
	end

	local mBuffs = defender:getBuffsByNameAndFighter(xyd.BUFF_TIME_RULE)

	if next(mBuffs) then
		return
	end

	for k, v in ipairs(fighter.selfTeam_) do
		local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_FUTURE_OBSERVE)

		if next(buffs) and not buffs[1].fighter:isSeal() and not buffs[1].fighter:isForceSeal() then
			local useOk = buffs[1]:useForAddBuff(v, defender, unit)

			if useOk then
				break
			end
		end
	end
end

function futureObserveBuff:reg_evt()
	local evt = battle_event:instance()

	evt:on(xyd.BATTLE_EVENT_PRE_FREE_HARM, _set_reg)
	evt:on(xyd.BATTLE_EVENT_HURTED, _set_enemy_hitted_reg)
end

return futureObserveBuff
