local PartnerTable = xyd.tables.partnerTable
local HeroAttr = xyd.models.heroAttr
local ReportHero = class("ReportHero")
local INVALID_HERO_ID = -1
local MonsterTable = xyd.tables.monsterTable
local GuildSkillTable = xyd.tables.guildSkillTable
local SkillTable = xyd.tables.skillTable
local EquipTable = xyd.tables.equipTable
local PartnerExskillTable = xyd.tables.partnerExSkillTable

function ReportHero:ctor()
	self.heroID_ = INVALID_HERO_ID
	self.playerID_ = 0
	self.isMonster_ = false
end

function ReportHero:initUnCollected(tableID, partnerID, params)
	params = params or {}
	self.tableID_ = tableID
	self.heroID_ = partnerID or INVALID_HERO_ID
	self.grade_ = params.grade or 0
	self.level_ = params.level or 1
	self.awake_ = tonumber(params.awake or 0)
	self.equips_ = params.equips or {}
	self.equipSkillIndex_ = params.skill_index
	self.exSkills = params.ex_skills or {}
end

function ReportHero:populate(params)
	self.playerID_ = tonumber(params.player_id or 0)
	self.partnerID_ = tonumber(params.partner_id or 0)
	self.tableID_ = tonumber(params.table_id or 0)
	self.grade_ = tonumber(params.grade or 0)
	self.level_ = tonumber(params.lv or params.level or 1)
	self.awake_ = tonumber(params.awake or 0)
	self.showSkin_ = tonumber(params.show_skin) or 1
	self.equips_ = params.equips or {}
	self.skinID_ = self.equips_[7] or 0
	self.lovePoint_ = tonumber(params.love_point or 0)
	self.isVowed_ = tonumber(params.is_vowed or 0)
	self.potentials_ = params.potentials or {}
	self.pos = tonumber(params.pos or 0)
	self.equipSkillIndex_ = params.skill_index
	self.exSkills = params.ex_skills or {}
	self.travel = tonumber(params.travel or 0)
	self.specialType = params.special_type or 0

	if params.status and params.status.hp then
		self.status = params.status
	end

	self.ver = params.ver or 0
end

function ReportHero:populateWithTableID(tableID, params)
	self.isMonster_ = true
	params = params or {}
	self.tableID_ = tableID
	self.partnerLink_ = MonsterTable:getPartnerLink(tableID)
	self.partnerID_ = params.partner_id
	self.grade_ = params.grade or MonsterTable:getGrade(tableID)
	self.level_ = params.level or MonsterTable:getLv(tableID)
	self.awake_ = params.awake or 0
	self.equips_ = params.equips or {
		MonsterTable:getValByKey(tableID, "equip_6")
	}
	self.potentials_ = params.potentials or {}
	self.pos = tonumber(params.pos or 0)
	self.skinID_ = MonsterTable:getSkin(tableID)
	self.equipSkillIndex_ = params.skill_index
	self.exSkills = params.ex_skills or MonsterTable:getExSkills(tableID)
	self.specialType = params.special_type or 0

	if params.status and params.status.hp then
		self.status = {
			hp = params.status.hp
		}
	end
end

function ReportHero:populateByHero(tableID, hero)
	self.tableID_ = tonumber(tableID) or 0
	self.grade_ = hero:getGrade()
	self.level_ = hero:getLevel()
	self.awake_ = hero:getAwake()
	self.showSkin_ = hero:getShowSkin()
	self.equips_ = hero:getEquips()
	self.skinID_ = hero:getSkin()
	self.lovePoint_ = hero:getLove()
	self.isVowed_ = hero:isVowed()
	self.potentials_ = hero:getPotential()
	self.equipSkillIndex_ = hero:getEquipSkillIndex()
	self.exSkills = hero:getExSkills() or {}

	hero:getBattleAttr()

	self.totalAttrs_ = hero.totalAttrs_
end

function ReportHero:getSpecialType()
	return self.specialType or 0
end

function ReportHero:setGuildInfo(info)
	self.guildInfo_ = info
end

function ReportHero:getGuildBuff(skillID)
	local buffs = {}

	if self.guildInfo_ then
		for _, info in ipairs(self.guildInfo_) do
			if tonumber(info.skill_id) == skillID then
				buffs = GuildSkillTable:getSkillBuffs(skillID, info.skill_lv)

				break
			end
		end
	end

	return buffs
end

function ReportHero:getTravelBuff()
	return self.travel
end

function ReportHero:setupBattleAttrInfo()
	self.totalAttrs_ = {}
	self.totalAttrs_ = HeroAttr:attr(self, {
		isBattle = true
	})
end

function ReportHero:isMonster()
	return self.isMonster_
end

function ReportHero:isMoreThenTenStar()
	local maxStar = self:getInfoByKey("maxStar")

	if maxStar >= 10 then
		return true
	else
		return false
	end
end

function ReportHero:getBattleAttr(attrType)
	if not self.totalAttrs_ then
		self:setupBattleAttrInfo()
	end

	return self.totalAttrs_[attrType] or 0
end

function ReportHero:updateInitAttr(attrs)
	for attrType in pairs(attrs) do
		if self:getBattleAttr(attrType) then
			self.totalAttrs_[attrType] = self.totalAttrs_[attrType] * attrs[attrType]
		end
	end
end

function ReportHero:getSkillID(index)
	local heroID = self:getHeroTableID()

	if index == xyd.SKILL_INDEX.Pugong then
		return PartnerTable:getAllPugongIDs(heroID)
	elseif index == xyd.SKILL_INDEX.Energy then
		return self:updateSkillId(PartnerTable:getEnergyID(heroID), index)
	end

	return 0
end

function ReportHero:getAwake()
	return self.awake_
end

function ReportHero:getPotential()
	return self.potentials_
end

function ReportHero:getEquips()
	return self.equips_
end

function ReportHero:getEquipment()
	return self.equips_
end

function ReportHero:getShowSkin()
	return self.showSkin_
end

function ReportHero:getSkin()
	return self.skinID_
end

function ReportHero:getHeroTableID()
	if self:isMonster() then
		return self:getPartnerLink()
	end

	return self:getTableID()
end

function ReportHero:getInfoByKey(key)
	if key == "name" then
		return PartnerTable:getName(self:getHeroTableID())
	elseif key == "job" then
		return PartnerTable:getJob(self:getHeroTableID())
	elseif key == "energyBase" then
		return PartnerTable:getInitMp(self:getHeroTableID())
	elseif key == "group" then
		return PartnerTable:getGroup(self:getHeroTableID())
	elseif key == "awakeSkill" then
		return PartnerTable:awakeSkill(self:getHeroTableID())
	elseif string.sub(key, 1, 7) == "pasTier" then
		return PartnerTable:getPasTier(self:getHeroTableID(), string.sub(key, 8, 8))
	elseif string.sub(key, 1, 8) == "pasSkill" then
		return PartnerTable:getPasSkill(self:getHeroTableID(), string.sub(key, 9, 9))
	elseif key == "potential" then
		return PartnerTable:getPotential(self:getHeroTableID())
	elseif key == "maxStar" then
		return PartnerTable:getStar(self:getHeroTableID())
	end

	reportLog2("no key:" .. key)

	return nil
end

function ReportHero:getName()
	return self:getInfoByKey("name")
end

function ReportHero:getJob()
	return self:getInfoByKey("job")
end

function ReportHero:getEnergyBase()
	return self:getInfoByKey("energyBase") + self:getBattleAttr(xyd.BUFF_ENERGY)
end

function ReportHero:className()
	return "ReportBaseFighter"
end

function ReportHero:getTableID()
	return self.tableID_
end

function ReportHero:getPartnerLink()
	return self.partnerLink_
end

function ReportHero:getLevel()
	return self.level_
end

function ReportHero:getVer()
	return self.ver
end

function ReportHero:getGroup()
	return self:getInfoByKey("group")
end

function ReportHero:getGrade()
	return self.grade_
end

function ReportHero:getEquipSkillIndex()
	return self.equipSkillIndex_
end

function ReportHero:getExSkills()
	return self.exSkills
end

function ReportHero:updateSkillId(skillID, index)
	if not self.exSkills[index - 1] or self.exSkills[index - 1] == 0 then
		return skillID
	end

	return PartnerExskillTable:exIds(skillID, self.exSkills[index - 1])
end

function ReportHero:getPasSkill()
	local awake = self:getAwake()
	local awakeSkill = {}
	local awakeSkills = self:getInfoByKey("awakeSkill")
	local tmpAwakeSkill = nil

	if awakeSkills then
		tmpAwakeSkill = awakeSkills[awake]
	end

	if awake and awake ~= 0 and awake < 6 and tmpAwakeSkill then
		awakeSkill = xyd.splitToNumber(tmpAwakeSkill, "#")
	end

	local skills = {}

	for i = 1, 3 do
		local pasTier = self:getInfoByKey("pasTier" .. i)

		if pasTier and pasTier <= self:getGrade() then
			local skill = nil

			if awake and awake ~= 0 and awake < 6 then
				skill = awakeSkill[i + 1]
			else
				skill = self:getInfoByKey("pasSkill" .. i .. "Id")
			end

			skill = tonumber(skill) or 0
			skill = self:updateSkillId(skill, xyd.SKILL_INDEX["PasSkill" .. i])

			if skill > 0 then
				local subSkills = SkillTable:getSubSkills(skill)

				table.insert(skills, skill)

				if #subSkills > 0 then
					for _, subSkill in ipairs(subSkills) do
						if subSkill > 0 then
							table.insert(skills, subSkill)
						end
					end
				end
			end
		else
			break
		end
	end

	local potentials = self:getPotential() or {}
	local skillPotentials = self:getInfoByKey("potential") or {}

	for i = 1, #skillPotentials do
		local tmpSkill = skillPotentials[i]
		local index = potentials[i]

		if index and index > 0 and tmpSkill[index] then
			local skill = tmpSkill[index]
			local subSkills = SkillTable:getSubSkills(skill)

			table.insert(skills, skill)

			if #subSkills > 0 then
				for _, subSkill in ipairs(subSkills) do
					table.insert(skills, subSkill)
				end
			end
		end
	end

	local equips = self:getEquips()

	for _, id in ipairs(equips) do
		local skillIDs = {}

		if id ~= 0 then
			xyd.tableConcat(skillIDs, EquipTable:skillId(id))
			xyd.tableConcat(skillIDs, EquipTable:exSkillId(id))
		end

		for k, v in ipairs(skillIDs) do
			if v > 0 then
				table.insert(skills, v)

				local subSkills = SkillTable:getSubSkills(v)

				if #subSkills > 0 then
					for _, subSkill in ipairs(subSkills) do
						table.insert(skills, subSkill)
					end
				end
			end
		end
	end

	if self.equipSkillIndex_ and self.equipSkillIndex_ > 0 then
		local suit_skills = EquipTable:getSuitSkills(equips[1])

		if suit_skills and #suit_skills > 0 and suit_skills[self.equipSkillIndex_] and suit_skills[self.equipSkillIndex_] > 0 then
			local skill = suit_skills[self.equipSkillIndex_]
			local subSkills = SkillTable:getSubSkills(skill)

			table.insert(skills, skill)

			if #subSkills > 0 then
				for _, subSkill in ipairs(subSkills) do
					table.insert(skills, subSkill)
				end
			end
		end
	end

	if self:isMonster() then
		local monsterSkills = MonsterTable:getSkill(self.tableID_)

		for _, skill in ipairs(monsterSkills) do
			if skill and skill > 0 then
				table.insert(skills, skill)
			end
		end
	end

	local actSkill = self:getSkillID(xyd.SKILL_INDEX.Energy)

	if actSkill and actSkill > 0 then
		local subSkills = SkillTable:getSubSkills(actSkill)

		if #subSkills > 0 then
			for _, subSkill in ipairs(subSkills) do
				table.insert(skills, subSkill)
			end
		end
	end

	if xyd.Battle.godPosSkill[self.pos] then
		for _, skill in ipairs(xyd.Battle.godPosSkill[self.pos]) do
			table.insert(skills, skill)
		end
	end

	return skills
end

function ReportHero:getLove()
	return self.lovePoint_ or 0
end

function ReportHero:getLovePoint()
	return self.lovePoint_ or 0
end

function ReportHero:setPetInfo(info)
	self.petInfo_ = info
end

function ReportHero:getPetInfo()
	return self.petInfo_ or {}
end

function ReportHero:isVowed()
	return self.isVowed_ or 0
end

return ReportHero
