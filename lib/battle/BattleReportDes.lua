local BattleReportDes = class("BattleReportDes")
local cjson = require("cjson")

function BattleReportDes:ctor()
end

function BattleReportDes:des(report)
	if not UNITY_EDITOR and not UNITY_STANDALONE then
		return
	end

	local mainMsg = {
		die_info = "",
		battle_id = report.info.battle_id,
		teamA = {},
		teamB = {},
		isWin = report.isWin
	}
	local msgFrames = {}
	local poses = {}

	local function makePlayer(data)
		local player = {
			equips = "",
			table_id = data.table_id,
			pos = data.pos,
			grade = data.grade,
			level = data.level,
			awake = data.awake,
			skill_index = data.skill_index,
			love_point = data.love_point,
			ver = data.ver
		}

		for i = 1, #data.equips do
			player.equips = player.equips .. data.equips[i] .. ","
		end

		for i = 1, #report.hurts do
			if report.hurts[i].pos == player.pos then
				player.hurt = report.hurts[i].hurt
				player.heal = report.hurts[i].heal

				break
			end
		end

		local id = data.table_id

		if data.isMonster then
			id = xyd.tables.monsterTable:getPartnerLink(id)
		end

		player.name = xyd.tables.partnerTable:getName(id)

		return player
	end

	local function makePet(data)
		local player = {
			skills = "",
			isPet = true,
			table_id = data.pet_id,
			grade = data.grade,
			level = data.lv,
			ver = data.ver
		}

		for i = 1, #data.skills do
			player.skills = player.skills .. data.skills[i] .. ","
		end

		player.name = xyd.tables.petTable:getName(player.table_id)

		return player
	end

	for i = 1, #report.teamB do
		local player = makePlayer(report.teamB[i])
		poses[player.pos + 6] = player

		table.insert(mainMsg.teamB, player)
	end

	for i = 1, #report.teamA do
		local player = makePlayer(report.teamA[i])
		poses[player.pos] = player

		table.insert(mainMsg.teamA, player)
	end

	local isHasPetA = true

	if report.petA == nil or tostring(report.petA) == "" or report.petA and report.petA.lv == nil then
		isHasPetA = false
	end

	if report.petA ~= nil and isHasPetA then
		local pet = makePet(report.petA)
		pet.pos = 13
		poses[13] = pet

		table.insert(mainMsg.teamA, pet)
	end

	local isHasPetB = true

	if report.petB == nil or tostring(report.petB) == "" or report.petB and report.petB.lv == nil then
		isHasPetB = false
	end

	if report.petB ~= nil and isHasPetB then
		local pet = makePet(report.petB)
		pet.pos = 14
		poses[14] = pet

		table.insert(mainMsg.teamA, pet)
	end

	if report.die_info then
		for i = 1, #report.die_info do
			mainMsg.die_info = mainMsg.die_info .. report.die_info[i] .. ","
		end
	end

	local function getPosInfo(pos)
		if pos == nil then
			return nil
		end

		local attaker = poses[pos]

		if attaker == nil or attaker.name == nil then
			return "(" .. pos .. ")"
		end

		return "(" .. pos .. ")" .. attaker.name
	end

	local function getSkillInfo(skillId)
		if skillId == nil or skillId == 0 then
			return nil
		end

		if xyd.tables.skillTable:getName(skillId) == nil then
			return skillId
		end

		return skillId .. "(" .. xyd.tables.skillTable:getName(skillId)
	end

	for i = 1, #report.frames do
		if msgFrames[report.frames[i].round] == nil then
			msgFrames[report.frames[i].round] = {}
		end

		local skillId = report.frames[i].skill_id
		local attaker = poses[report.frames[i].pos]
		local frame = {
			targets = "",
			targets_2 = "",
			skill = getSkillInfo(skillId),
			attacker = getPosInfo(report.frames[i].pos),
			eps = report.frames[i].eps,
			buffs = {}
		}

		for j = 1, #report.frames[i].targets do
			if j == 1 then
				frame.targets = getPosInfo(report.frames[i].targets[j])
			else
				frame.targets = frame.targets .. " || " .. getPosInfo(report.frames[i].targets[j])
			end
		end

		for j = 1, #report.frames[i].targets_2 do
			if j == 1 then
				frame.targets_2 = getPosInfo(report.frames[i].targets_2[j])
			else
				frame.targets_2 = frame.targets_2 .. " || " .. getPosInfo(report.frames[i].targets_2[j])
			end
		end

		if frame.targets_2 == "" then
			frame.targets_2 = nil
		end

		local buffs = report.frames[i].buffs

		for j = 1, #buffs do
			local buff = {
				to_pos = getPosInfo(buffs[j].pos),
				from_pos = getPosInfo(buffs[j].f_pos),
				effect_id = buffs[j].table_id,
				name = buffs[j].name or "no name",
				value = tonumber(buffs[j].value),
				buffOn = buffs[j].buffOn,
				skill = getSkillInfo(buffs[j].skill_id),
				hp = buffs[j].hp or -1,
				ep = buffs[j].ep or -1,
				is_block = buffs[j].is_block or -1,
				isHarm = buffs[j].isHarm or -1
			}

			if buff.name == "" then
				buff.name = "no name"
			end

			if xyd.tables.effectTable:round(buffs[j].table_id) ~= 0 then
				buff.round = xyd.tables.effectTable:round(buffs[j].table_id)
			end

			table.insert(frame.buffs, buff)
		end

		table.insert(msgFrames[report.frames[i].round], frame)
	end

	local infoStr = reportLog2(mainMsg, 2, 7, "INFO")
	infoStr = infoStr .. "\nFRAMES:\n"

	for i = 1, #msgFrames do
		infoStr = infoStr .. reportLog2(msgFrames[i], 2, 7, "round" .. i) .. "\n"
	end

	LuaManager.Instance:showBattleReport(infoStr)
	io.writefile(XYDDef.DataPath .. "\\battle_info.log", infoStr)

	local data = {
		battle_report = report
	}

	if report.petA and not report.petA.lv then
		report.petA = nil
	end

	if report.petB and not report.petB.lv then
		report.petB = nil
	end

	report.random_seed = report.random_seed_2
	local isOk = true

	if report.guildSkillsA and report.guildSkillsA[1] and report.guildSkillsA[1]._cached_byte_size_dirty then
		isOk = false
	end

	if report.teamA[1] and not report.teamA[1].equips._type_checker and isOk then
		io.writefile(XYDDef.DataPath .. "\\report.json", cjson.encode(data))
	else
		reportLog2("no data report.json")
	end

	print("report dir===========", XYDDef.DataPath .. "\\battle_info.log")
end

function BattleReportDes:randomRecord(localData, serverData)
	if localData then
		io.writefile(XYDDef.DataPath .. "\\random_local.log", dump(cjson.decode(localData), "", 5))
	end

	if serverData then
		io.writefile(XYDDef.DataPath .. "\\random_server.log", dump(cjson.decode(serverData), "", 5))
	end
end

return BattleReportDes
