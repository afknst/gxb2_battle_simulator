local BattleChallengeTable = class("BattleChallengeTable", import("app.common.tables.BaseTable"))

function BattleChallengeTable:ctor()
	BattleChallengeTable.super.ctor(self, "battle_challenge")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		table.insert(self.ids_, tonumber(id))
	end

	table.sort(self.ids_)
end

function BattleChallengeTable:getIDs()
	return self.ids_
end

function BattleChallengeTable:getType(id)
	return self:getNumber(id, "type")
end

function BattleChallengeTable:getParams(id)
	return self:getNumber(id, "params")
end

return BattleChallengeTable
