local ReportBasePet = class("ReportBasePet", xyd.Battle.getRequire("ReportBaseFighter"))
local BuffTable = xyd.tables.dBuffTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local math_min = math.min
local math_max = math.max
local math_abs = math.abs
local math_floor = math.floor
local math_ceil = math.ceil
local math_sqrt = math.sqrt

function ReportBasePet:init()
	ReportBasePet.super.init(self)
end

function ReportBasePet:isPet()
	return true
end

function ReportBasePet:updateEnergyBy2(value)
	local curUnit = xyd.Battle.recordUnit

	self:setEnergy(self.energy_ + value, curUnit)
end

function ReportBasePet:canAttack()
	if self:getEnergySkillNeed() <= self:getEnergy() then
		return true
	end

	return false
end

function ReportBasePet:isDeath()
	return false
end

function ReportBasePet:getAttrByType(attrType, isRate)
	if not self.___attrCache[attrType] then
		local basic = 0

		if isRate and basic == 0 then
			basic = 1
		end

		local abs, percent = self:getBuffAttrChange(attrType)
		local result = math_max(1 + percent, 0) * basic + abs
		local factor = BuffTable:getFactor(attrType)

		if factor > 0 then
			result = result / factor
		end

		self.___attrCache[attrType] = math_max(result, 0)
	end

	return self.___attrCache[attrType]
end

function ReportBasePet:getGroup()
	return 0
end

function ReportBasePet:getHpLimit()
	return 1
end

function ReportBasePet:getHp()
	return 1
end

return ReportBasePet
