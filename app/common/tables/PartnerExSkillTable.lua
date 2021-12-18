local PartnerExSkillTable = class("PartnerExSkillTable", import("app.common.tables.BaseTable"))

function PartnerExSkillTable:ctor()
	PartnerExSkillTable.super.ctor(self, "partner_exskill")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]

		table.insert(self.ids_, id)
	end

	table.sort(self.ids_)
end

function PartnerExSkillTable:getIDs()
	return self.ids_
end

function PartnerExSkillTable:getExID(id)
	return self:split2Cost(id, "ex_id", "|")
end

function PartnerExSkillTable:getDescNum(id, index)
	return self:split(id, "desc_num" .. index, "|")
end

function PartnerExSkillTable:exIds(skillID, index)
	return self:getExID(skillID)[index] or 0
end

return PartnerExSkillTable
