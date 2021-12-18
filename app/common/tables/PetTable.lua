local PetTable = class("PetTable", import("app.common.tables.BaseTable"))

function PetTable:ctor()
	PetTable.super.ctor(self, "pet")

	self.datas_ = {}
	self.ids_ = {}
	self.forgeList = {}
end

function PetTable:getName(id)
	return xyd.tables.petTextTable:getName(id)
end

function PetTable:getMaxExLev(id)
	return self:getNumber(id, "max_exlevel")
end

function PetTable:getVer(id)
	return self:getNumber(id, "ver") or 0
end

function PetTable:getModelID(id)
	return self:getNumber(id, "pet_model")
end

function PetTable:getEnergyID(id)
	return self:getNumber(id, "act_skill_id")
end

function PetTable:getPasSkill(id, i)
	return self:getNumber(id, "pas_skill" .. tostring(i) .. "_id")
end

function PetTable:getPasTier(id, i)
	return self:getNumber(id, "pas_tier" .. tostring(i))
end

function PetTable:getAvatar(id)
	return self:getString(id, "pet_avatar")
end

function PetTable:getMaxGrade(id)
	return self:getNumber(id, "max_grade")
end

function PetTable:getGradeUpCost(id, grade)
	local arr = xyd.split(self:getString(id, "grade_exp" .. tostring(grade)), "|")
	local res = {}

	for k, v in ipairs(arr) do
		local t = xyd.split(v, "#", true)
		res[t[1]] = t[2]
	end

	return res
end

function PetTable:getMaxlev(id, grade)
	if grade ~= nil then
		local max_grade = self:getMaxGrade(id)
		local target_grade = nil

		if max_grade < grade + 1 then
			return self:getNumber(id, "max_lv")
		else
			target_grade = grade + 1
		end

		local key = "grade_lv" .. tostring(target_grade)

		return self:getNumber(id, key)
	else
		return self:getNumber(id, "max_lv")
	end
end

function PetTable:getPetCard(id)
	return self:split(id, "pet_card", "|")
end

function PetTable:getPetBg(id)
	return self:getString(id, "pet_bg")
end

function PetTable:getPetModel(id)
	return self:getNumber(id, "pet_model")
end

function PetTable:getClickDialogInfo(id, index)
	if index == nil then
		index = 1
	end

	local sound = self:getString(id, "click_sound" .. tostring(index))
	local time = self:getNumber(id, "time_sound" .. tostring(index))
	local dialog = xyd.tables.petTextTable:getClickDialog(id, index)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PetTable:getActiveCost(id)
	return self:split2Cost(id, "active_cost", "#")
end

function PetTable:isOpen(id)
	local val = self:getNumber(id, "is_open")

	if not val then
		return false
	end

	return val < xyd.getServerTime()
end

function PetTable:getCardBg(id)
	return tostring(self:getString(id, "pet_card_bg")) .. "_png"
end

function PetTable:getPetFrame(id)
	return tostring(self:getString(id, "pet_frame")) .. "_png"
end

function PetTable:getPetFrameGroup(id)
	return tostring(self:getString(id, "pet_frame_group")) .. "_png"
end

function PetTable:getPetCardPos(id)
	return self:split2num(id, "pet_card_pos", "|")
end

function PetTable:getShowTime(id)
	return self:getNumber(id, "is_show")
end

function PetTable:getExSkillID(id)
	return self:getNumber(id, "exskill_id")
end

function PetTable:getPetSkills(id)
	return self:split(id, "pas_skills", "|")
end

function PetTable:getPetSkillsUnlockLv(id)
	return self:split(id, "pas_skill_exlevel", "|")
end

function PetTable:getTrainingXY(id)
	return self:split2Cost(id, "training_xy", "|")
end

function PetTable:getTrainingScale(id)
	return self:split2Cost(id, "training_scale", "|")
end

return PetTable
