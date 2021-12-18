local fireBallBuff = class("fireBallBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local GetTarget_ = xyd.Battle.getRequire("GetTarget")

function fireBallBuff:ctor(params)
	fireBallBuff.super.ctor(self, params)

	self.additionRate = params.additionRate or 0
	self.additionHurt = params.additionHurt or 0
	self.passTimes = params.passTimes or 0
end

function fireBallBuff:setIsHit()
	self:baseSetIsHit()
end

function fireBallBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function fireBallBuff:excuteBuff(unit, recordBuffs)
	local params1 = {
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID,
		forceEffectNum = EffectTable:getNum(self.finalNumArray_[1]) + self.additionHurt
	}

	BuffManager:addNewBuff(params1, unit)

	local params2 = {
		effectID = self.finalNumArray_[2],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID,
		forceEffectProb = EffectTable:prob(self.finalNumArray_[2]) + self.additionRate
	}

	BuffManager:addNewBuff(params2, unit, true)

	self.passTimes = self.passTimes + 1
	self.additionRate = self.additionRate + self.finalNumArray_[4]
	self.additionHurt = self.additionHurt + self.finalNumArray_[3]
	local alives = GetTarget_.S2(self.target)
	local preSelects = {}

	for k, v in ipairs(alives) do
		if v ~= self.target then
			table.insert(preSelects, v)
		end
	end

	if #preSelects == 0 or self.finalNumArray_[5] <= self.passTimes then
		return
	end

	local nextTarget = xyd.randomSelects(preSelects, 1)[1]
	local specialUnit = self.fighter:createAttackUnit(self.finalNumArray_[6], false, unit, true)
	local params3 = {
		effectID = self.effectID,
		fighter = self.fighter,
		target = nextTarget,
		skillID = self.skillID,
		passTimes = self.passTimes,
		additionHurt = self.additionHurt,
		additionRate = self.additionRate
	}
	local buff = BuffManager:addNewBuff(params3, specialUnit, true)
	buff.showFighter = nextTarget
end

return fireBallBuff
