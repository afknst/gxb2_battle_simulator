local sameAtkBuff = class("sameAtkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function sameAtkBuff:ctor(params)
	sameAtkBuff.super.ctor(self, params)
end

function sameAtkBuff:setIsHit()
	local attacker = self.fighter
	local defender = self.target
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_SAME_ATK)

	if next(buffs) then
		self.isHit_ = false

		for _, buff in ipairs(buffs) do
			buff:recoverCount()
		end
	else
		self:baseSetIsHit()
	end
end

function sameAtkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

return sameAtkBuff
