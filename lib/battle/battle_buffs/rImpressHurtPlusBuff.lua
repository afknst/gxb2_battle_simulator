local rImpressHurtPlusBuff = class("rImpressHurtPlusBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local math_max = math.max

function rImpressHurtPlusBuff:ctor(params)
	rImpressHurtPlusBuff.super.ctor(self, params)
end

function rImpressHurtPlusBuff:setIsHit()
	local name = self:getName()
	self.isHit_ = true
end

function rImpressHurtPlusBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num

	return finalNum
end

return rImpressHurtPlusBuff
