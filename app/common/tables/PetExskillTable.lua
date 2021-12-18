local PetExskillTable = class("PetExskillTable", import("app.common.tables.BaseTable"))

function PetExskillTable:ctor()
	PetExskillTable.super.ctor(self, "pet_exskill")
end

function PetExskillTable:getCost(id)
	return self:split2Cost(id, "cost", "|#", true)
end

function PetExskillTable:getEffects(id)
	return self:split2Cost(id, "effects", "|#", false)
end

function PetExskillTable:getPasSkills(id)
	return self:split2num(id, "pas_skills", "|")
end

return PetExskillTable
