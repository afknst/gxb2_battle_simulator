local naturalLawCleanBuff = class("naturalLawCleanBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local math_max = math.max

function naturalLawCleanBuff:ctor(params)
	naturalLawCleanBuff.super.ctor(self, params)
end

function naturalLawCleanBuff:setIsHit()
	self:baseSetIsHit()
end

function naturalLawCleanBuff:calculateFinalNum(name, num, isPercent, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function naturalLawCleanBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local removeBuffLists = {}
	local mLawBuffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_NATURAL_LAW)

	if next(mLawBuffs) then
		for _, mBuff in ipairs(mLawBuffs) do
			mBuff:writeRecord(self.target, xyd.BUFF_REMOVE)
			table.insert(recordBuffs, mBuff)
			table.insert(removeBuffLists, mBuff)
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return naturalLawCleanBuff
