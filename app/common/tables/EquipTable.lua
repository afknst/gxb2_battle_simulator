local EquipTable = class("EquipTable", import("app.common.tables.BaseTable"))

function EquipTable:ctor()
	EquipTable.super.ctor(self, "equip")

	self.ids_ = {}
	self.artifactInitialList_ = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		table.insert(self.ids_, tonumber(id))

		if self:getType(id) == 11 then
			local initial_id = self:getInitialSoulID(id)
			local itemLev = self:getItemLev(id)

			if initial_id and initial_id > 0 then
				if not self.artifactInitialList_[initial_id] then
					self.artifactInitialList_[initial_id] = {
						[tonumber(itemLev)] = tonumber(id)
					}
				else
					self.artifactInitialList_[initial_id][tonumber(itemLev)] = tonumber(id)
				end
			end
		end
	end
end

function EquipTable:getIDs()
	return self.ids_
end

function EquipTable:getName(id)
	return xyd.tables.equipTextTable:getName(id)
end

function EquipTable:getQuality(id)
	return self:getNumber(id, "qlt")
end

function EquipTable:getType(id)
	return self:getNumber(id, "type")
end

function EquipTable:getWays(id)
	local ways = self:getAny(id, "get_ways")
	local results = xyd.split(ways, "|", true)

	return results
end

function EquipTable:getBase(id, index)
	local str = self:getString(id, "base" .. tostring(index))

	return xyd.split(str, "#")
end

function EquipTable:skillId(id)
	return self:split2num(id, "skill_id", "|") or {}
end

function EquipTable:exSkillId(id)
	return self:split2num(id, "ex_skill", "|") or {}
end

function EquipTable:getDesc(id)
	local desc = ""
	local buffTable = xyd.tables.dBuffTable
	local i = 1

	while i <= 3 do
		local base = self:getBase(id, i)

		if #base <= 0 then
			break
		end

		if desc ~= "" then
			desc = tostring(desc) .. "\n"
		end

		local num = tonumber(base[2])
		local factor = tonumber(buffTable:getFactor(base[1])) == 0 and 1 or tonumber(buffTable:getFactor(base[1]))

		if buffTable:isShowPercent(base[1]) then
			num = string.format("%.1f", num * 100 / factor) .. "%"
		end

		desc = tostring(desc) .. "+" .. tostring(num) .. " " .. tostring(xyd.tables.dBuffTable:getDesc(base[1]))
		i = i + 1
	end

	local skillID = self:skillId(id)[1]

	if skillID and skillID > 0 then
		if desc ~= "" then
			desc = desc .. "\n"
		end

		desc = desc .. xyd.tables.skillTable:getDesc(skillID)
	end

	return desc
end

function EquipTable:getSuit(id, index)
	return xyd.split(self:getString(id, "suit" .. tostring(index)), "#")
end

function EquipTable:getSuitName(id)
	return xyd.tables.equipTextTable:getSuitName(id)
end

function EquipTable:getGroup(id)
	return self:getNumber(id, "group")
end

function EquipTable:getJob(id)
	return self:getNumber(id, "job")
end

function EquipTable:getAct(id)
	local tmpStrs = xyd.split(self:getString(id, "act"), "|")
	local data = {}

	for key, str in ipairs(tmpStrs) do
		table.insert(data, xyd.split(str, "#"))
	end

	return data
end

function EquipTable:getStar(id)
	return self:getNumber(id, "star")
end

function EquipTable:needFormula(id)
	local res = self:split2Cost(id, "need_formula", "|#", true)

	return res
end

function EquipTable:getPower(id)
	return self:getNumber(id, "power")
end

function EquipTable:getForm(id)
	return xyd.split(self:getString(id, "form"), "|")
end

function EquipTable:getSuitSkills(id)
	return self:split2num(id, "suit_skills", "|")
end

function EquipTable:getPos(id)
	return self:getNumber(id, "pos")
end

function EquipTable:getItemLev(id)
	return self:getNumber(id, "item_lv")
end

function EquipTable:getTreasureCost(id)
	local arr = xyd.split(self:getString(id, "treasure_all_upgrade"), "|")
	local res = {}

	for k, v in ipairs(arr) do
		local t = xyd.split(v, "#", true)

		table.insert(res, t)
	end

	return res
end

function EquipTable:getTreasureUpCost(id)
	local str = self:getString(id, "treasure_upgrade")

	if str ~= "" and str ~= nil then
		local res = {}
		local arr = xyd.split(str, "|")

		for key, val in ipairs(arr) do
			local arr2 = xyd.split(val, "#", true)
			res[arr2[1]] = arr2[2]
		end

		return res
	else
		return nil
	end
end

function EquipTable:getTreasureChangeCost(id)
	local str = self:getString(id, "treasure_refresh")

	if str ~= nil then
		local res = {}
		local arr = xyd.split(str, "|")

		for key, val in ipairs(arr) do
			local arr2 = xyd.split(val, "#", true)
			res[arr2[1]] = arr2[2]
		end

		return res
	else
		return nil
	end
end

function EquipTable:getTreasureLockCost(id)
	local str = self:getString(id, "treasure_lock_up")

	if str ~= nil and str ~= "" then
		local arr = xyd.split(str, "|")
		local arr2 = xyd.split(arr[2], "#", true)

		return arr2[2]
	else
		return nil
	end
end

function EquipTable:getTreasureLock(id)
	local str = self:getString(id, "treasure_lock_up")

	if str ~= nil and str ~= "" then
		local arr = xyd.split(str, "|")

		return arr[1]
	else
		return nil
	end
end

function EquipTable:getArtifactUpNext(id)
	return self:getNumber(id, "artifact_next")
end

function EquipTable:getArtifactUpExp(id)
	return self:getNumber(id, "artifact_upg")
end

function EquipTable:getArtifactExp(id)
	return self:getNumber(id, "artifact_exp")
end

function EquipTable:getSkinModel(id)
	return self:getNumber(id, "partner_model")
end

function EquipTable:getSkinAvatar(id)
	return self:getString(id, "avatar")
end

function EquipTable:getFxIndex(id)
	return self:getNumber(id, "fx_index") + 1
end

function EquipTable:getInitialSoulID(id)
	if self:getType(id) ~= 11 then
		return -1
	else
		return self:getNumber(id, "initial_artifact")
	end
end

function EquipTable:getSoulByIdAndLev(id, lev)
	local initial_id = self:getInitialSoulID(id)

	if initial_id and initial_id > 0 and lev and lev > 0 then
		if self.artifactInitialList_[initial_id][lev] and self.artifactInitialList_[initial_id][lev] > 0 then
			return self.artifactInitialList_[initial_id][lev]
		else
			return self:getSoulByIdAndLev(id, lev - 1)
		end
	else
		return id
	end
end

return EquipTable
