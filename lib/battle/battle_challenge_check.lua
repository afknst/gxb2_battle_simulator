local table_challenge = xyd.tables.battleChallengeTable
local table_monster = xyd.tables.monsterTable
local table_partner = xyd.tables.partnerTable
local _M = {
	check_func = {
		"complete",
		"pr_num",
		"rounds",
		"controlled_times",
		"left_hp",
		"dead_partner",
		"no_group",
		"has_partner",
		"total_harmed",
		"no_front",
		"no_back",
		"",
		"",
		"total_cure",
		"",
		"left_partner"
	},
	check = function (self, id, battle_result)
		local data = table_challenge:getType(id)

		return self[self.check_func[table_challenge:getType(id)]](self, {
			params = table_challenge:getParams(id)
		}, battle_result)
	end,
	complete = function (self, data, battle_result)
		if battle_result.is_win == 1 then
			return true
		end

		return false
	end
}

function _M:pr_num(data, battle_result)
	local report = battle_result.battle_report

	if #report.teamA <= data.params then
		return true
	else
		return false
	end
end

function _M:rounds(data, battle_result)
	local report = battle_result.battle_report

	if report.total_round <= data.params then
		return true
	else
		return false
	end
end

function _M:controlled_times(data, battle_result)
	local report = battle_result.battle_report

	if report.enemy_control_times <= data.params then
		return true
	else
		return false
	end
end

function _M:left_hp(data, battle_result)
	local total_hp = 0
	local left_hp = 0

	if not battle_result.status or not battle_result.status.status_a then
		return
	end

	for _, v in ipairs(battle_result.status.status_a) do
		if v.hp > 0 then
			total_hp = total_hp + math.ceil(v.true_hp / v.hp * 100)
			left_hp = left_hp + v.true_hp
		end
	end

	if data.params <= left_hp / total_hp * 100 then
		return true
	else
		return false
	end
end

function _M:dead_partner(data, battle_result)
	local die_num = 0

	if not battle_result.status or not battle_result.status.status_a then
		return
	end

	for _, v in ipairs(battle_result.status.status_a) do
		if v.hp == 0 then
			die_num = die_num + 1
		end
	end

	if die_num <= data.params then
		return true
	else
		return false
	end
end

function _M:no_group(data, battle_result)
	local report = battle_result.battle_report

	if not report.teamA then
		return
	end

	for _, v in ipairs(report.teamA) do
		local table_id = nil

		if v.isMonster then
			table_id = table_monster:getPartnerLink(v.table_id)
		else
			table_id = v.table_id
		end

		if table_partner:getGroup(table_id) == data.params then
			return false
		end
	end

	return true
end

function _M:has_partner(data, battle_result)
	local report = battle_result.battle_report

	if not report.teamA then
		return
	end

	for _, v in ipairs(report.teamA) do
		local table_id = nil

		if v.isMonster then
			table_id = table_monster:getPartnerLink(v.table_id)
		else
			table_id = v.table_id
		end

		if table_id == data.params then
			return true
		end
	end

	return false
end

function _M:total_harmed(data, battle_result)
	local total_harmed = battle_result.enemy_total_harm or 0

	if total_harmed > 0 and total_harmed < data.params then
		return true
	else
		return false
	end
end

function _M:no_front(data, battle_result)
	local report = battle_result.battle_report

	if not report.teamA then
		return
	end

	for _, v in ipairs(report.teamA) do
		if v.pos <= 2 then
			return false
		end
	end

	return true
end

function _M:no_back(data, battle_result)
	local report = battle_result.battle_report

	if not report.teamA then
		return
	end

	for _, v in ipairs(report.teamA) do
		if v.pos > 2 then
			return false
		end
	end

	return true
end

function _M:total_cure(data, battle_result)
	local report = battle_result.battle_report

	if not report.hurts then
		return
	end

	local totalHeal = 0

	for k, v in ipairs(report.hurts) do
		if v.pos <= 6 or v.pos == 13 then
			totalHeal = totalHeal + v.heal
		end
	end

	return data.params < totalHeal
end

function _M:left_partner(data, battle_result)
	local left_num = 0

	if not battle_result.status or not battle_result.status.status_a then
		return
	end

	for _, v in ipairs(battle_result.status.status_a) do
		if v.hp > 0 then
			left_num = left_num + 1
		end
	end

	return data.params <= left_num
end

return _M
