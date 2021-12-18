local GroupBuffTable = class("GroupBuffTable", import("app.common.tables.BaseTable"))

function GroupBuffTable:ctor()
	GroupBuffTable.super.ctor(self, "group_buff")

	self.datas_ = {}
	self.ids_ = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]
		self.datas_[id] = {}

		for key in pairs(colIndexTable) do
			self.datas_[id][key] = row[colIndexTable[key]]
		end

		table.insert(self.ids_, tonumber(id))
	end
end

function GroupBuffTable:getData(id)
	return self.datas_[id]
end

function GroupBuffTable:getIds()
	return self.ids_
end

function GroupBuffTable:getName(id)
	return self:getString(id, "name")
end

function GroupBuffTable:getGroupConfig(id)
	return self:getString(id, "group_config")
end

function GroupBuffTable:getEffect(id)
	return self:split(id, "effect", "|")
end

function GroupBuffTable:getEffectShow(id)
	return self:getString(id, "effect_show")
end

function GroupBuffTable:getFx(id)
	return self:getString(id, "fx")
end

function GroupBuffTable:getBuffIdByGroupIds(groupData)
	local actBuffId = 0

	for _, buffId in ipairs(self.ids_) do
		local buffConfig = self:getGroupConfig(tonumber(buffId))
		local configList = xyd.split(buffConfig, "|", false)
		local type = self:getType(buffId)
		local flag = true

		if tonumber(type) == 1 then
			for key, configStr in ipairs(configList) do
				local req = xyd.split(configStr, "#", true)
				flag = groupData[req[1]] == req[2]

				if flag == false then
					break
				end
			end
		elseif tonumber(type) == 2 then
			if groupData[5] + groupData[6] ~= 3 then
				flag = false
			end

			if groupData[1] + groupData[2] + groupData[3] + groupData[4] ~= 3 then
				flag = false
			end

			if groupData[1] > 1 or groupData[2] > 1 or groupData[3] > 1 or groupData[4] > 1 then
				flag = false
			end
		end

		if flag then
			actBuffId = self:Number(buffId)

			break
		end
	end

	return actBuffId
end

function GroupBuffTable:getType(id)
	return self:getString(id, "type")
end

function GroupBuffTable:getStand(id)
	return self:split(id, "effect_stands", "#")
end

function GroupBuffTable:getEffectStands(id)
	return self:split(id, "effect_stands", "#")
end

return GroupBuffTable
