local PartnerTable = class("PartnerTable", import("app.common.tables.BaseTable"))

function PartnerTable:ctor()
	PartnerTable.super.ctor(self, "partner")

	self.datas_ = {}
	self.ids_ = {}
	self.forgeList = {}
	self.wedding_list_ = {}
	self.puppet_partner_id_ = {}
	self.five_star_by_ten_star = {}
	self.skinsToPartner = {}
	self.soundPartner = {}
	local colIndexTable = getmetatable(self.TableLua.keys).__index
	local forgeFiveStarList = {}
	local forgeSixStarList = {}

	for _, id in pairs(self.TableLua.ids) do
		id = tostring(id)
		local row = self.TableLua.rows[id]
		self.datas_[id] = {}

		for key, _ in pairs(colIndexTable) do
			self.datas_[id][key] = row[colIndexTable[key]]
		end

		local group = row[colIndexTable.group]
		local showInForge = self:Number(row[colIndexTable.show_in_forge]) or 0
		local star = self:Number(row[colIndexTable.max_star] or 0)

		if showInForge >= 1 then
			if not forgeFiveStarList[tostring(group)] then
				forgeFiveStarList[tostring(group)] = {}
			end

			if not forgeSixStarList[tostring(group)] then
				forgeSixStarList[tostring(group)] = {}
			end

			if not self.forgeList[tostring(group)] then
				self.forgeList[tostring(group)] = {}
			end

			if star == 5 then
				table.insert(forgeFiveStarList[tostring(group)], id)
			elseif star == 6 then
				table.insert(forgeSixStarList[tostring(group)], id)
			end
		end

		table.insert(self.ids_, tonumber(id))

		local wedding_id = self:getWeddingSkin(id)
		self.wedding_list_[wedding_id] = 1
		local ten_star = self:getStar10(id)

		if ten_star then
			self.five_star_by_ten_star[ten_star] = id
		end

		local heroList = self:getHeroList(id)

		if heroList then
			self.soundPartner[tonumber(id)] = heroList[1]
		end

		local skinIDs = self:getSkins(id)

		for _, skinID in pairs(skinIDs) do
			if self.skinsToPartner[skinID] == nil then
				self.skinsToPartner[skinID] = {}
			end

			table.insert(self.skinsToPartner[skinID], id)
		end
	end

	for key, _ in pairs(forgeFiveStarList) do
		for i, _ in pairs(forgeSixStarList[key]) do
			table.insert(self.forgeList[key], forgeSixStarList[key][i])
		end

		for i, _ in pairs(forgeFiveStarList[key]) do
			table.insert(self.forgeList[key], forgeFiveStarList[key][i])
		end
	end

	table.sort(self.ids_)

	local puppet_list = xyd.tables.miscTable:split2num("return_10star_puppet_id", "value", "|")

	for _, data in pairs(puppet_list) do
		self.puppet_partner_id_[tonumber(data)] = 1
	end
end

function PartnerTable:getPartnerIdBySkinId(skinID)
	return self.skinsToPartner[skinID]
end

function PartnerTable:getData(id)
	return self.datas_[id]
end

function PartnerTable:getIds()
	return self.ids_
end

function PartnerTable:getName(id)
	return xyd.tables.partnerTextTable:getName(id)
end

function PartnerTable:getVer(id)
	return self:getNumber(id, "ver") or 0
end

function PartnerTable:getExSkill(id)
	return self:getNumber(id, "ex_skill")
end

function PartnerTable:getModelID(id)
	return self:getNumber(id, "partner_model")
end

function PartnerTable:getModelName(id)
	return self:getString(id, "partner_model_name")
end

function PartnerTable:getPugongID(id)
	local skillIDs_ = self:split2num(id, "atk_id", "|")

	if #skillIDs_ == 1 then
		return skillIDs_[1]
	else
		return xyd.getRandoms(skillIDs_, 1)[1]
	end
end

function PartnerTable:getAllPugongIDs(id)
	return self:split2num(id, "atk_id", "|")
end

function PartnerTable:getEnergyID(id)
	return self:getNumber(id, "act_skill_id")
end

function PartnerTable:getInitMp(id)
	return self:getNumber(id, "energy_base")
end

function PartnerTable:getPasSkill(id, i)
	return self:getNumber(id, "pas_skill" .. tostring(i) .. "_id")
end

function PartnerTable:getPasTier(id, i)
	return self:getNumber(id, "pas_tier" .. tostring(i))
end

function PartnerTable:getGroup(id)
	local group = self:getNumber(id, "group")

	return group
end

function PartnerTable:getJob(id)
	local job = self:getNumber(id, "job")

	return job
end

function PartnerTable:getShowInGuide(id)
	return self:getNumber(id, "show_in_guide")
end

function PartnerTable:getCommentID(id)
	return self:getNumber(id, "comment_id")
end

function PartnerTable:getShowInReviewGuide(id)
	return self:getNumber(id, "show_in_guide_auditing")
end

function PartnerTable:getAvatar(id)
	return self:getString(id, "avatar")
end

function PartnerTable:getStar(id)
	return self:getNumber(id, "max_star")
end

function PartnerTable:getMaxGrade(id)
	return self:getNumber(id, "max_grade")
end

function PartnerTable:getGradeUpCost(id, grade)
	local arr = xyd.split(self:getString(id, "grade_exp" .. tostring(grade)), "|")
	local res = {}

	for k, v in ipairs(arr) do
		local t = xyd.split(v, "#", true)
		res[t[1]] = t[2]
	end

	return res
end

function PartnerTable:getMaxlev(id, grade)
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

function PartnerTable:growAtk(id)
	return self:getNumber(id, "grow_atk")
end

function PartnerTable:growHp(id)
	return self:getNumber(id, "grow_hp")
end

function PartnerTable:growArm(id)
	return self:getNumber(id, "grow_arm")
end

function PartnerTable:growSpd(id)
	return self:getNumber(id, "grow_spd")
end

function PartnerTable:awakeGrow(id)
	return xyd.split(self:getString(id, "awake_grow"), "|")
end

function PartnerTable:awakeSkill(id)
	return xyd.split(self:getString(id, "awake_skill"), "|")
end

function PartnerTable:getBaseHp(id)
	return self:getNumber(id, "base_hp")
end

function PartnerTable:getBaseAtk(id)
	return self:getNumber(id, "base_atk")
end

function PartnerTable:getBaseArm(id)
	return self:getNumber(id, "base_arm")
end

function PartnerTable:getBaseSpd(id)
	return self:getNumber(id, "base_spd")
end

function PartnerTable:getAwakeMaterial(id, awake)
	if awake ~= nil then
		local str = xyd.split(self:getString(id, "awake_material"), "|")[awake + 1]

		return xyd.split(str, "#", true)
	end

	return self:getString(id, "awake_material")
end

function PartnerTable:getAwakeItemCost(id, awake)
	if awake ~= nil then
		local str = xyd.split(self:getString(id, "stone_material"), "|")[awake + 1]

		return xyd.split(str, "#", true)
	else
		return self:getString(id, "stone_material")
	end
end

function PartnerTable:getShowInForge(id)
	return self:getNumber(id, "show_in_forge")
end

function PartnerTable:getShowInForgeAuditing(id)
	return self:getNumber(id, "show_in_forge_auditing")
end

function PartnerTable:getMaterial(id)
	return self:getString(id, "material")
end

function PartnerTable:getMaterial1(id)
	return self:split2Cost(id, "material", "|")
end

function PartnerTable:getHost(id)
	return self:getNumber(id, "host")
end

function PartnerTable:getDialogList(id)
	local soundPartner = self.soundPartner[tonumber(id)]

	return xyd.tables.partnerDialogTable:getDialogList(soundPartner)
end

function PartnerTable:getStartSound(id)
	return self:getString(id, "start_sound")
end

function PartnerTable:getSoundByType(id, type_, index, skin_id)
	local list = self:getDialogList(id)
	local type2 = xyd.PartnerToSoundTableKey[tostring(type_)]
	local skinIndex = self:getSkinIndex(id, skin_id)
	local sound_id = xyd.tables.partnerDialogTable:getIdsInList(list, type2, skinIndex)

	if tonumber(sound_id) then
		return xyd.tables.partnerDialogTable:getSoundTableId(sound_id), sound_id
	elseif index and index >= 1 then
		return xyd.tables.partnerDialogTable:getSoundTableId(sound_id[index]), sound_id[index]
	else
		return 0, 0
	end
end

function PartnerTable:getStartDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "start_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getSkillSound(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "skill_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)

	return {
		id = self:Number(sound),
		time = time
	}
end

function PartnerTable:getBattleSound(id, skin_id)
	local sound = self:getSoundByType(id, "battle_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)

	return {
		id = self:Number(sound),
		time = time
	}
end

function PartnerTable:getDeadSound(id, skin_id)
	local sound = self:getSoundByType(id, "dead_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)

	return {
		id = self:Number(sound),
		time = time
	}
end

function PartnerTable:getSoundTime(id, index)
	return self:getNumber(id, "time_sound" .. tostring(index))
end

function PartnerTable:getForgeList()
	dump(self.forgeList)

	return self.forgeList
end

function PartnerTable:getDeComposeItem(id)
	local arr = xyd.split(self:getString(id, "decompose"), "|")
	local res = {}

	for k, v in ipairs(arr) do
		local t = xyd.split(v, "#", true)

		table.insert(res, t)
	end

	return res
end

function PartnerTable:getClickDialogInfo(id, index, skin_id)
	if index == nil then
		index = 1
	end

	local sound, partnerSoundId = self:getSoundByType(id, "click_sound", index, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getBattleDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "battle_sound", nil, skin_id)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return dialog
end

function PartnerTable:getDeadDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "dead_sound", nil, skin_id)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return dialog
end

function PartnerTable:getSkilleDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "skill_sound", nil, skin_id)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return dialog
end

function PartnerTable:getSkins(id)
	return self:split2num(id, "skin_ids", "|")
end

function PartnerTable:getSkinIndex(id, skin_id)
	local skinList = self:split2num(id, "skin_ids", "|")

	return xyd.arrayIndexOf(skinList, skin_id)
end

function PartnerTable:checkIfTaiWu(id)
	if self:getStar(id) ~= 10 and self:getTenId(id) == 0 and self:getStar10(id) == 0 then
		return false
	end

	return true
end

function PartnerTable:getTenId(id)
	return self:getNumber(id, "n_id") or 0
end

function PartnerTable:getShowIds(id)
	return self:split(id, "show_ids", "|")
end

function PartnerTable:getDataID(id)
	return self:split2num(id, "partner_data_id", "|")
end

function PartnerTable:getPlotIDS(id)
	return self:split2num(id, "plot_id", "|")
end

function PartnerTable:getGiftsLike(id)
	return self:split2num(id, "gift_type2", "|")
end

function PartnerTable:getGiftsDislike(id)
	return self:split2num(id, "gift_type1", "|")
end

function PartnerTable:getAchievementIDs(id)
	return self:split2num(id, "achievement_id", "|")
end

function PartnerTable:getTableIDByName(name)
	local ids = {}
	local i = 0

	while i < #self.ids_ do
		local id = self:Number(self.ids_[i + 1])

		if xyd.tables.partnerTextTable:getString(id, "name") == name then
			table.insert(ids, id)
		end

		i = i + 1
	end

	return ids
end

function PartnerTable:getStar10(id)
	return self:getNumber(id, "star_10")
end

function PartnerTable:getWeddingSkin(id)
	return self:getNumber(id, "wedding_skin_id")
end

function PartnerTable:getHeroList(id)
	return self:split2num(id, "hero_list", "|")
end

function PartnerTable:checkIsWeddingSkin(skin_id)
	if self.wedding_list_[skin_id] then
		return true
	end

	return false
end

function PartnerTable:getPotential(id)
	return self:split2Cost(id, "potential", "|#") or {}
end

function PartnerTable:checkPuppetPartner(partner_id)
	if self.puppet_partner_id_[tonumber(partner_id)] then
		return true
	else
		return false
	end
end

function PartnerTable:getLvlupDialogInfo(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "lvlup_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getGradeupDialogInfo(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "gradeup_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getShenXueDialogInfo(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "shengxue_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getAwakeDialogInfo(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "awake_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getEquipDialogInfo(id, index, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "equip_sound", index, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getLovePointDialogInfo(id, index, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "love_point_sound", index, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getHangTeamSound(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "hangteam_sound", nil, skin_id)

	return sound
end

function PartnerTable:getGiftDialog(id, index, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "gift_sound" .. index, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getHouseSound(id)
	return self:getString(id, "house_sound")
end

function PartnerTable:getHouseDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "house_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getHouseSetDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "house_set_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getLoginDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "login_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getIdleDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "idle_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getTavernDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "dagong_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getMissionDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "daily_mission_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getStageDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "new_stage_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getVowSound(id, skin_id)
	local soundId, _ = self:getSoundByType(id, "vow_sound", nil, skin_id)

	return soundId
end

function PartnerTable:getVictorySound(id)
	return self:getString(id, "victory_sound")
end

function PartnerTable:getFailedSound(id)
	return self:getString(id, "failed_sound")
end

function PartnerTable:getVowDialog(id, skin_id)
	local sound, partnerSoundId = self:getSoundByType(id, "vow_sound", nil, skin_id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerDialogTextTable:getText(partnerSoundId)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getVictoryDialogInfo(id)
	local sound = self:getVictorySound(id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerTextTable:getVictoryDialog(id)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getFailedDialogInfo(id)
	local sound = self:getFailedSound(id)
	local time = xyd.tables.soundTable:getLength(sound)
	local dialog = xyd.tables.partnerTextTable:getFailedDialog(id)

	return {
		sound = sound,
		time = time,
		dialog = dialog
	}
end

function PartnerTable:getShenxueTableId(id)
	return self:getNumber(id, "shenxue_table_id")
end

function PartnerTable:getPartnerShard(id)
	return self:getNumber(id, "partner_shard")
end

function PartnerTable:getFiveStarByTenStar(ten_star_id)
	return self.five_star_by_ten_star[ten_star_id]
end

function PartnerTable:hasId(id)
	return xyd.arrayIndexOf(self.ids_, id) > -1
end

function PartnerTable:get5PartnerNum()
	local num = 0

	for _, id in ipairs(self.ids_) do
		if self:getStar(id) == 5 and self:getShowInGuide(id) >= 1 and tonumber(id) ~= 56008 and tonumber(id) ~= 55010 then
			num = num + 1
		end
	end

	return num
end

function PartnerTable:get10PartnerNum()
	local num = 0

	for _, id in ipairs(self.ids_) do
		if self:getStar(id) == 10 and self:getShowInGuide(id) >= 1 and tonumber(id) ~= 756008 and tonumber(id) ~= 755009 then
			num = num + 1
		end
	end

	return num
end

return PartnerTable
