local MiscTable = class("MiscTable", import("app.common.tables.BaseTable"))

function MiscTable:ctor()
	MiscTable.super.ctor(self, "misc")
end

function MiscTable:getVal(name, ...)
	local __args = {
		...
	}
	local formatStr = self:getString(name, "value")

	if not formatStr then
		return name
	end

	local newargs = self:slice(__args, 0, #__args)
	local result = xyd.stringFormat(formatStr, unpack(newargs))
	result = string.gsub(result, "undefined", "")

	return result
end

return MiscTable
