local debuffHurtBuff = class("debuffHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function debuffHurtBuff:ctor(params)
	debuffHurtBuff.super.ctor(self, params)
end

function debuffHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function debuffHurtBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local effectNums = EffectTable:num(self.effectID, true)
	local attacker = self.fighter
	local defender = self.target
	local newDebuffData = defender:getNewDebuffList()
	local nameNum = newDebuffData.dNameNum
	local extraHurt = nameNum * effectNums[2]
	local extraData = {
		hurt = extraHurt
	}

	self:changeBuffName()

	local finalNum = self:calculateHurtNum(self:getName(), effectNums[1], buffData, extraData)

	return finalNum
end

return debuffHurtBuff
