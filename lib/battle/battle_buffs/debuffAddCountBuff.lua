local debuffAddCountBuff = class("debuffAddCountBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function debuffAddCountBuff:ctor(params)
	debuffAddCountBuff.super.ctor(self, params)
end

function debuffAddCountBuff:setIsHit()
	self:baseSetIsHit()
end

function debuffAddCountBuff:calculateFinalNum(name, num, buffData, forceHurt)
	self.finalNumArray_ = EffectTable:num(self.effectID, true)
	local finalNum = self.finalNumArray_[1]

	return finalNum
end

function debuffAddCountBuff:excuteBuff()
	local res = self.target:getNewDebuffList({
		1,
		2,
		3,
		4
	})
	local dTypeNum = res.dTypeNum
	local debuffList = res.debuffList
	local rate = self.finalNumArray_[1]
	local addNum = self.finalNumArray_[2]
	local list = {}

	for dType, debuffs in pairs(debuffList) do
		table.insert(list, {
			key = dType,
			value = debuffs
		})
	end

	table.sort(list, function (data1, data2)
		return data1.key < data2.key
	end)

	if dTypeNum > 0 then
		for dType, item in ipairs(list) do
			local isSuccess = xyd.weightedChoise({
				rate,
				1 - rate
			}) == 1

			if isSuccess then
				for _, debuff in ipairs(item.value) do
					debuff:addCount(addNum)
				end
			end
		end
	end
end

return debuffAddCountBuff
