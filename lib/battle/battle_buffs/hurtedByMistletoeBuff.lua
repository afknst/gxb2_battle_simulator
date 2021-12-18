local hurtedByMistletoeBuff = class("hurtedByMistletoeBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function hurtedByMistletoeBuff:ctor(params)
	hurtedByMistletoeBuff.super.ctor(self, params)
end

function hurtedByMistletoeBuff:setIsHit()
	self:baseSetIsHit()
end

function hurtedByMistletoeBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	self:setRecordNum(0)

	return finalNum
end

function hurtedByMistletoeBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local lastAttacker = xyd.Battle.lastAttacker

	if not lastAttacker then
		self:writeRecord(self.target, xyd.BUFF_ON)

		return
	end

	local mistletoeBuffs = lastAttacker:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE)

	if not mistletoeBuffs or not next(mistletoeBuffs) then
		self:writeRecord(self.target, xyd.BUFF_ON)

		return
	end

	self.target:usePasSkill(xyd.TriggerType.HURTED_BY_MISTLETOE, unit)
	self:writeRecord(self.target, xyd.BUFF_ON_WORK)
end

return hurtedByMistletoeBuff
