local GroupTable = class("GroupTable", import("app.common.tables.BaseTable"))

function GroupTable:ctor()
	GroupTable.super.ctor(self, "group")
end

function GroupTable:getRestraintGroup(id)
	id = tostring(id)

	return self:getNumber(id, "restraint_group")
end

function GroupTable:getGroupIds()
	local res = {}

	for key, _ in pairs(self.TableLua.rows) do
		table.insert(res, self:getNumber(key, "id"))
	end

	return res
end

function GroupTable:getName(id)
	return xyd.tables.groupTextTable:getName(id)
end

function GroupTable:isRestraint(actor, actee)
	if actor:isPet() then
		return false
	end

	local actorGroupID = actor:getGroup()
	local acteeGroupID = actee:getGroup()
	local actorRestraintID = self:getRestraintGroup(actorGroupID)

	if actorRestraintID == acteeGroupID then
		return true
	end

	return false
end

return GroupTable
