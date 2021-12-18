local rImpressTreatmentBlockBuff = class("rImpressTreatmentBlockBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function rImpressTreatmentBlockBuff:ctor(params)
	rImpressTreatmentBlockBuff.super.ctor(self, params)
end

function rImpressTreatmentBlockBuff:setIsHit()
	local name = self:getName()
	self.isHit_ = true
end

function rImpressTreatmentBlockBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

return rImpressTreatmentBlockBuff
