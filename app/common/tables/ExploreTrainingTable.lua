local ExploreTrainingTable = class("ExploreTrainingTable", import(".BaseTable"))

function ExploreTrainingTable:ctor()
	ExploreTrainingTable.super.ctor(self, "travel_train")
end

function ExploreTrainingTable:getLvMax(id)
	return self:getNumber(id, "lv_max")
end

function ExploreTrainingTable:getBaseCost(id)
	return self:split2Cost(id, "base_cost", "|#", true)
end

function ExploreTrainingTable:getGrowCost(id)
	return self:split2num(id, "grow_cost", "|")
end

function ExploreTrainingTable:getEffectID(id)
	return self:getNumber(id, "base_effect")
end

function ExploreTrainingTable:getGrowEffect(id)
	return self:getNumber(id, "grow_effect")
end

function ExploreTrainingTable:getCost(index, lev)
	local baseCost = self:getBaseCost(index)
	local growCost = self:getGrowCost(index)

	for i in ipairs(baseCost) do
		baseCost[i][2] = baseCost[i][2] + (lev - 1) * growCost[i]
	end

	return baseCost
end

function ExploreTrainingTable:getTransformValue(id)
	return self:getNumber(id, "value_transform")
end

function ExploreTrainingTable:getEffect(index, lev)
	local effectId = self:getEffectID(index)
	local baseEffect = xyd.tables.effectTable:getNum(effectId, nil)
	local buffName = xyd.tables.effectTable:getType(effectId)
	local growEffect = self:getGrowEffect(index)

	return {
		buffName,
		baseEffect + (lev - 1) * growEffect
	}
end

function ExploreTrainingTable:getEffectString(index, lev)
	local num = self:getEffect(index, lev)[2]
	local tValue = self:getTransformValue(index)
	local res = nil

	if tValue == 0 then
		res = num * 100 .. "%"
	elseif tValue == 1 then
		res = num
	else
		res = num / 20 .. "%"
	end

	return res
end

return ExploreTrainingTable
