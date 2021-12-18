local impressCleanBuff = class("impressCleanBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function impressCleanBuff:ctor(params)
	impressCleanBuff.super.ctor(self, params)
end

function impressCleanBuff:setIsHit()
	self:baseSetIsHit()
end

function impressCleanBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function impressCleanBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local removeBuffLists = {}
	local impressBuffs, allNames = self.target:getImpressBuffs()

	if not next(impressBuffs) then
		return
	end

	local cleanNum = self.finalNum_
	local selectNames = xyd.randomSelects(allNames, cleanNum)

	if not selectNames or not next(selectNames) then
		return
	end

	for _, sName in ipairs(selectNames) do
		local buffs = impressBuffs[sName]

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

return impressCleanBuff
