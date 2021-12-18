local maxAtkHurtBuff = class("maxAtkHurtBuff", xyd.Battle.getRequire("ReportBuff"))
local math_max = math.max
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function maxAtkHurtBuff:ctor(params)
	maxAtkHurtBuff.super.ctor(self, params)
end

function maxAtkHurtBuff:setIsHit()
	self:baseSetIsHit()
end

function maxAtkHurtBuff:calculateFinalNum(name, num, isPercent, forceHurt)
	self.finalNumArray_ = EffectTable:num(self.effectID, true)
	local maxADFighter = self.fighter.selfTeam_[1]

	for _, fighter in ipairs(self.fighter.selfTeam_) do
		if maxADFighter:getAD() < fighter:getAD() then
			maxADFighter = fighter
		end
	end

	local maxAdNum = maxADFighter:getAD()
	local extraData = {
		adNum = maxAdNum
	}

	self:changeBuffName()

	local finalNum = self:calculateHurtNum(self:getName(), self.finalNumArray_[1], isPercent, extraData)

	return finalNum
end

return maxAtkHurtBuff
