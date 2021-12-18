local sameAtkSeekBuff = class("sameAtkSeekBuff", xyd.Battle.getRequire("ReportBuff"))
local SkillTable = xyd.tables.skillTable
local BuffTable = xyd.tables.dBuffTable
local EffectTable = xyd.tables.effectTable
local math_max = math.max

function sameAtkSeekBuff:ctor(params)
	sameAtkSeekBuff.super.ctor(self, params)
end

function sameAtkSeekBuff:setIsHit()
	self:baseSetIsHit()
end

function sameAtkSeekBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local sameAtkhurtBuff = xyd.Battle.lastSameAtkHurtBuff

	if not sameAtkhurtBuff then
		return num
	end

	local finalNum = sameAtkhurtBuff:getFinalNum() / sameAtkhurtBuff.critFinalValue
	local attacker = self.fighter
	local defender = self.target
	local isCrit = self:setIsCrit()

	if isCrit then
		local targetCritTime = defender:getTargetCritTime(attacker)
		local attackerCritTime = attacker:getCritTime(defender)
		local critTime = targetCritTime + attackerCritTime

		if critTime > 1.5 then
			critTime = 1.5
		end

		finalNum = finalNum * (1.5 + critTime * 2)
		local critDef = defender:getCritDefRate()
		finalNum = finalNum * (1 - critDef)
	end

	self:changeBuffName()

	self.inHarmTargetList = false

	return finalNum
end

return sameAtkSeekBuff
