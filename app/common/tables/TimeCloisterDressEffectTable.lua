local TimeCloisterDressEffectTable = class("TimeCloisterDressEffectTable", import("app.common.tables.BaseTable"))

function TimeCloisterDressEffectTable:ctor()
	TimeCloisterDressEffectTable.super.ctor(self, "time_cloister_dress_effect")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		table.insert(self.ids_, id)
	end

	table.sort(self.ids_)
end

function TimeCloisterDressEffectTable:getIDs()
	return self.ids_
end

function TimeCloisterDressEffectTable:getSkillId(absNum, typeIndex)
	local needId = 0

	for i, id in ipairs(self.ids_) do
		if self:getNumber(i, "num") <= absNum and (i == #self.ids_ or absNum < self:getNumber(i + 1, "num")) then
			needId = i

			break
		end
	end

	if needId == 0 then
		return 0
	else
		return self:getNumber(needId, "base" .. typeIndex .. "_effect")
	end
end

return TimeCloisterDressEffectTable
