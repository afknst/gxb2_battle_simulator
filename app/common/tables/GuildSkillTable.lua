local GuildSkillTable = class("GuildSkillTable", import("app.common.tables.BaseTable"))
local NO_JOB_ID = 6

function GuildSkillTable:ctor()
	GuildSkillTable.super.ctor(self, "guild_skill")

	self.jobs = {}
	local colIndexTable = self.TableLua.keys

	for id in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]
		local job = row[colIndexTable.job]
		self.jobs[job] = self.jobs[job] or {}

		table.insert(self.jobs[job], tonumber(id))
	end

	for i, j in pairs(self.jobs) do
		table.sort(self.jobs[i], function (a, b)
			return a < b
		end)
	end
end

function GuildSkillTable:getName(id)
	return xyd.tables.guildSkillTextTable:getName(id)
end

function GuildSkillTable:getLevMax(id)
	return self:getNumber(id, "lv_max")
end

function GuildSkillTable:getJob(id)
	return self:getNumber(id, "job")
end

function GuildSkillTable:getPreSkill(id)
	return self:split2num(id, "pre_skill", "|")
end

function GuildSkillTable:getNextSkill(id)
	return self:getNumber(id, "next_skill")
end

function GuildSkillTable:getLvReq(id)
	return self:split2num(id, "lv_req", "|")
end

function GuildSkillTable:getBaseGold(id)
	return self:split2num(id, "base_gold", "#")
end

function GuildSkillTable:getGrowGold(id)
	return self:getNumber(id, "grow_gold")
end

function GuildSkillTable:getBaseGuildCoin(id)
	return self:split2num(id, "base_guild_coin", "#")
end

function GuildSkillTable:getGrowGuildCoin(id)
	return self:getNumber(id, "grow_guild_coin")
end

function GuildSkillTable:getBaseEffect(id)
	return self:split(id, "base_effect", "|")
end

function GuildSkillTable:getGrowEffect(id)
	return self:split(id, "grow_effect", "|")
end

function GuildSkillTable:getIcon(id)
	return self:getString(id, "icon")
end

function GuildSkillTable:getJobSkills(type)
	return self.jobs[type] or {}
end

function GuildSkillTable:getSkillBuffs(id, lev)
	local baseEffects = self:getBaseEffect(id)
	local growEffects = self:getGrowEffect(id)
	local buffs = {}

	for i = 1, #baseEffects do
		local base = xyd.split(baseEffects[i], "#")
		local grow = xyd.split(growEffects[i], "#")
		local buffName = base[1]
		local num = tonumber(base[2]) + (lev - 1) * tonumber(grow[2])

		table.insert(buffs, {
			type = buffName,
			num = num
		})
	end

	return buffs
end

function GuildSkillTable:getReset(id)
	return self:getNumber(id, "reset")
end

return GuildSkillTable
