local energySkillLimitBuff = class("energySkillLimitBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function energySkillLimitBuff:ctor(params)
	energySkillLimitBuff.super.ctor(self, params)
end

function energySkillLimitBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_LIMIT)

	if next(buffs) then
		return
	else
		self:baseSetIsHit()
	end
end

function energySkillLimitBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function energySkillLimitBuff:excuteBuff(unit, recordBuffs)
	local attacker = self.fighter
	local defender = self.target
	local removeBuffs = {}
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_ENERGY_SKILL_HOLD)

	if buffs and next(buffs) then
		for _, buff in ipairs(buffs) do
			buff:writeRecord(self.target, xyd.BUFF_OFF)
			table.insert(recordBuffs, buff)
			table.insert(removeBuffs, buff)
		end
	end

	self.target:removeBuffs(removeBuffs)
end

return energySkillLimitBuff
