local SenpaiDressEffectTable = class("SenpaiDressEffectTable", import("app.common.tables.BaseTable"))

function SenpaiDressEffectTable:ctor()
	SenpaiDressEffectTable.super.ctor(self, "senpai_dress_effect")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		table.insert(self.ids_, id)
	end

	table.sort(self.ids_)
end

function SenpaiDressEffectTable:getIDs()
	return self.ids_
end

function SenpaiDressEffectTable:getSkillId(absNum, typeIndex)
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

return SenpaiDressEffectTable
