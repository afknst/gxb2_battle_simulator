local DatesTable = class("DatesTable", import("app.common.tables.BaseTable"))

function DatesTable:ctor()
	DatesTable.super.ctor(self, "appointment")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		table.insert(self.ids_, id)
	end
end

function DatesTable:getIcon(lovePoint)
	local id = math.floor(lovePoint / 1000)

	return tostring(self:getString(id, "icon"))
end

function DatesTable:getAttr(lovePoint)
	local id = math.floor(lovePoint / 1000)

	return self:split2Cost(id, "attribute_bonus", "|#", false)
end

return DatesTable
