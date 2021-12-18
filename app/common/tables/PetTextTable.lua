local PetTextTable = class("PetTextTable", import("app.common.tables.BaseTable"))

function PetTextTable:ctor()
	PetTextTable.super.ctor(self, "pet_text_" .. tostring(xyd.Global.lang))
end

function PetTextTable:getName(id)
	return self:getString(id, "name")
end

function PetTextTable:getDialog(id)
	return self:getString(id, "dialog")
end

function PetTextTable:getClickDialog(id, index)
	if index == nil then
		index = 1
	end

	return self:getString(id, "click_dialog" .. tostring(index))
end

function PetTextTable:getExName(id)
	return self:getString(id, "exlevel_name")
end

return PetTextTable
