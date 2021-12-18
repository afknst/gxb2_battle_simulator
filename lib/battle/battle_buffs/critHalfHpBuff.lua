local critHalfHpBuff = class("critHalfHpBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function critHalfHpBuff:ctor(params)
	critHalfHpBuff.super.ctor(self, params)
end

function critHalfHpBuff:setIsHit()
	self:baseSetIsHit()
end

function critHalfHpBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return 0
end

function critHalfHpBuff:excuteBuff(unit, recordBuffs, status)
	local params1 = {
		target = self.target,
		fighter = self.fighter,
		effectID = self.finalNumArray_[1],
		skillID = unit.skillID
	}
	local displayBuff1 = BuffManager:newBuff(params1)
	displayBuff1.isHit_ = 1

	if self.target:getHp() < self.target:getHpLimit() / 2 then
		displayBuff1.mustCrit = true
	end

	displayBuff1:calculate()

	unit.lastFighter = self.fighter
	local tmpHarm, tmpCure, tmpIsCrit, recordBuffs, tmpIsHarm, inHarmTargetList = self.target:applyBuffHarm(unit, {
		displayBuff1
	})

	self.fighter:recordData(tmpHarm, 0)

	status.isHarm = true
end

return critHalfHpBuff
