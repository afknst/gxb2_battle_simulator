local BuffManager = class("BuffManager")
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable

function BuffManager:ctor()
end

function BuffManager:newBuff(params, buffName)
	local effectID = params.effectID

	if not buffName and effectID then
		buffName = EffectTable:buff(effectID)
	end

	local hasChild = BuffTable:hasChild(buffName)

	if not hasChild then
		buffName = nil
	end

	local buffClass = xyd.Battle.requireBuff(buffName)
	local buff_ = buffClass.new(params)

	return buff_
end

function BuffManager:addNewBuff(params, unit, isNeedProb)
	local buff = self:newBuff(params)

	if isNeedProb then
		buff:setIsHit()

		if not buff.isHit_ then
			return buff
		end
	end

	buff.isHit_ = true

	buff:calculate()

	local harm, cure = params.target:applyBuffHarm(unit, {
		buff
	})

	params.fighter:recordData(harm, cure)

	return buff
end

return BuffManager
