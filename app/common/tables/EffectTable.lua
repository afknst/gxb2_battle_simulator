local EffectTable = class("EffectTable", import("app.common.tables.BaseTable"))

function EffectTable:ctor()
	EffectTable.super.ctor(self, "effect")

	self.datas = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]
		self.datas[id] = {}

		for key in pairs(colIndexTable) do
			self.datas[id][key] = row[colIndexTable[key]]
		end
	end
end

function EffectTable:getType(id)
	return self:getString(id, "buff")
end

function EffectTable:buff(id)
	return self:getString(id, "buff")
end

function EffectTable:getNum(id, isArr)
	if isArr == nil then
		isArr = false
	end

	local arr = self:split2num(id, "num", "|")

	if not arr then
		return nil
	end

	if isArr then
		return arr
	end

	if next(arr) and #arr ~= 1 then
		return arr[1]
	end

	return self:getNumber(id, "num")
end

function EffectTable:num(id, isArr)
	return self:getNum(id, isArr)
end

function EffectTable:prob(id)
	return self:getNumber(id, "prob")
end

function EffectTable:round(id)
	return self:getNumber(id, "round")
end

return EffectTable
