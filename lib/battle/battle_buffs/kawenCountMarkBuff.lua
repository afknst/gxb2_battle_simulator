local kawenCountMarkBuff = class("kawenCountMarkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function kawenCountMarkBuff:ctor(params)
	kawenCountMarkBuff.super.ctor(self, params)
end

function kawenCountMarkBuff:setIsHit()
	self:baseSetIsHit()

	self.recordEnergy = self.fighter:getEnergy()
end

function kawenCountMarkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function kawenCountMarkBuff:excuteBuff(unit, recordBuffs)
	local marks = self.target:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK)
	local showEffectBuff = nil

	if #marks >= 5 then
		showEffectBuff = xyd.BUFF_KAWEN_COUNT_MARK_F5
	elseif #marks >= 1 then
		showEffectBuff = xyd.BUFF_KAWEN_COUNT_MARK_F1
	end

	if showEffectBuff then
		local params = {
			target = self.target,
			fighter = self.fighter
		}
		local buff = BuffManager:newBuff(params)
		buff.isHit_ = true
		buff.name_ = showEffectBuff
		buff.preName_ = showEffectBuff
		buff.skillID = self.skillID

		buff:writeRecord(self.target, xyd.BUFF_WORK)
		unit:recordBuffs(self.target, {
			buff
		})
	end

	if #marks >= 5 then
		for i = 1, 2 do
			self:addEffectByIndex(unit, i)
		end

		local maxRoundMark = marks[1]

		for k, v in ipairs(marks) do
			if maxRoundMark:getCount() < v:getCount() then
				maxRoundMark = v
			end
		end

		local removeBuffs = {}

		for k, v in ipairs(marks) do
			if v ~= maxRoundMark then
				v:writeRecord(self.target, xyd.BUFF_REMOVE, true)
				table.insert(recordBuffs, v)
				table.insert(removeBuffs, v)
			end
		end

		self.target:removeBuffs(removeBuffs)
	end

	if #marks >= 3 then
		self:addEffectByIndex(unit, 3)
	end

	self:addEffectByIndex(unit, 4)
end

function kawenCountMarkBuff:addEffectByIndex(unit, index)
	local target = self.target
	local isNeedProb = false

	if index == 2 then
		target = self.fighter
		isNeedProb = true
	end

	if target:isDeath() then
		return
	end

	local params1 = {
		noAddEnergy = true,
		effectID = self.finalNumArray_[index],
		fighter = self.fighter,
		target = target,
		skillID = self.skillID,
		recordEnergy = self.recordEnergy
	}
	local buff = BuffManager:addNewBuff(params1, unit, isNeedProb)
end

return kawenCountMarkBuff
