local controlCleanBuff = class("controlCleanBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function controlCleanBuff:ctor(params)
	controlCleanBuff.super.ctor(self, params)
end

function controlCleanBuff:setIsHit()
	self:baseSetIsHit()
end

function controlCleanBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function controlCleanBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local removeBuffLists = {}
	local controlBuffs, allNames = self.target:getControlBuffs()

	if not next(controlBuffs) then
		return
	end

	local cleanNum = self.finalNum_
	local selectNames = xyd.randomSelects(allNames, cleanNum)

	if not selectNames or not next(selectNames) then
		return
	end

	for _, sName in ipairs(selectNames) do
		local buffs = controlBuffs[sName]

		if next(buffs) then
			for _, buff in ipairs(buffs) do
				buff:writeRecord(self.target, xyd.BUFF_REMOVE)
				table.insert(recordBuffs, buff)
				table.insert(removeBuffLists, buff)
			end
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return controlCleanBuff
