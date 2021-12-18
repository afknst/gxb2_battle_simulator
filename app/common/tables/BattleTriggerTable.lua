local BattleTriggerTable = class("BattleTriggerTable", import("app.common.tables.BaseTable"))

function BattleTriggerTable:ctor()
	BattleTriggerTable.super.ctor(self, "battle_trigger")

	self.ids_ = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]

		table.insert(self.ids_, tonumber(id))
	end
end

function BattleTriggerTable:trigger(id)
	return self:getNumber(id, "trigger")
end

function BattleTriggerTable:isGodSkill(id)
	return self:getNumber(id, "is_god_skill")
end

function BattleTriggerTable:getLimitTimes(id)
	return self:getNumber(id, "limit_times")
end

function BattleTriggerTable:isDiePasSkill(id)
	return self:getNumber(id, "is_die_pas") == 1
end

function BattleTriggerTable:isHpPasSkill(id)
	return self:getNumber(id, "is_hp_pas") == 1
end

function BattleTriggerTable:isCanUseByPasSkill(id)
	return self:getNumber(id, "is_can_use_by_pas") == 1
end

return BattleTriggerTable
