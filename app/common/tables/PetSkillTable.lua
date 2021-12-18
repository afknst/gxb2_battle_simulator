local PetSkillTable = class("PetSkillTable", import("app.common.tables.BaseTable"))

function PetSkillTable:ctor()
	PetSkillTable.super.ctor(self, "pet_skill")

	self.ids_ = {}
	self.skillIds_ = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]

		table.insert(self.ids_, id)

		local petSkillID = row[colIndexTable.pet_skill_id]

		if not self.skillIds_[petSkillID] then
			self.skillIds_[petSkillID] = {}
		end

		table.insert(self.skillIds_[petSkillID], id)
	end

	for k, v in pairs(self.skillIds_) do
		table.sort(self.skillIds_[k])
	end
end

function PetSkillTable:getName(id)
	return xyd.tables.petSkillTextTable:getName(id)
end

function PetSkillTable:getDesc(id)
	return xyd.tables.petSkillTextTable:getDesc(id)
end

function PetSkillTable:getSkillIcon(id)
	return self:getString(id, "icon")
end

function PetSkillTable:getSkillLev(id)
	return self:getNumber(id, "lv")
end

function PetSkillTable:getSound(id)
	return self:getNumber(id, "sound")
end

function PetSkillTable:isShake(id)
	return self:getNumber(id, "shake_screen") == 1
end

function PetSkillTable:getCost(id)
	return self:split2Cost(id, "cost", "|#")
end

function PetSkillTable:getEffect(id, lv)
	if lv ~= nil then
		local skillid = id + lv - 1

		return self:getEffect(skillid)
	end

	return self:split2Cost(id, "effect", "|#", false)
end

function PetSkillTable:getRestore(id)
	return self:split2Cost(id, "restore", "|#")
end

function PetSkillTable:getIdByLev(skillID, lev)
	local skillIds = self.skillIds_[skillID]
	local id = -1

	if skillIds then
		id = skillIds[lev]
	end

	return id
end

function PetSkillTable:getMaxSkillLev(skillID)
	local skillIds = self.skillIds_[skillID]
	local lev = 0

	if skillIds then
		lev = #skillIds
	end

	return lev
end

function PetSkillTable:getPetSkillID(id)
	return self:getNumber(id, "pet_skill_id")
end

return PetSkillTable
