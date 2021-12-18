local reduceSpdHealBuff = class("reduceSpdHealBuff", xyd.Battle.getRequire("ReportBuff"))
local BuffManager = xyd.Battle.getRequire("BuffManager")
local EffectTable = xyd.tables.effectTable

function reduceSpdHealBuff:ctor(params)
	reduceSpdHealBuff.super.ctor(self, params)
end

function reduceSpdHealBuff:setIsHit()
	self:baseSetIsHit()
end

function reduceSpdHealBuff:getReduceSpdTimes()
	local times = 0

	for _, v in ipairs(self.target.sideTeam_) do
		local buffs = v:getBuffsByName(xyd.BUFF_REDUCE_SPD_HEAL_RECORD)

		if next(buffs) and buffs[1].fighter == self.fighter then
			local queyangBuffs = v:getBuffsByName(xyd.BUFF_REDUCE_SPD)
			times = #queyangBuffs

			break
		end
	end

	if times >= 5 then
		times = 5
	end

	return times
end

function reduceSpdHealBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = 0
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function reduceSpdHealBuff:excuteBuff(unit, recordBuffs)
	for i = 1, self:getReduceSpdTimes() do
		local params1 = {
			effectID = self.finalNumArray_[1],
			fighter = self.fighter,
			target = self.target,
			skillID = self.skillID
		}

		BuffManager:addNewBuff(params1, unit)

		if self.finalNumArray_[2] == 0 then
			return
		end

		local params2 = {
			effectID = self.finalNumArray_[2],
			fighter = self.fighter,
			target = self.target,
			skillID = self.skillID
		}

		BuffManager:addNewBuff(params2, unit)
	end
end

return reduceSpdHealBuff
