local SkillTable = class("SkillTable", import("app.common.tables.BaseTable"))

function SkillTable:ctor()
	SkillTable.super.ctor(self, "skill")

	self.ids_ = {}

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]

		table.insert(self.ids_, tonumber(id))
	end
end

function SkillTable:getName(id)
	return xyd.tables.skillTextTable:getName(id)
end

function SkillTable:jump(id, index)
	if index == nil then
		index = 1
	end

	local arry = self:split2num(id, "jump", "#")
	local jump_ = arry[index]

	if jump_ == nil then
		jump_ = arry[1]
	end

	return jump_ or 0
end

function SkillTable:jumpDelta(id, index)
	index = index or 1
	local arry = self:split(id, "jump_pos_xy", "#")
	local delta = arry[index]

	if delta == nil then
		delta = arry[1]
	end

	return xyd.split(delta, "|", true)
end

function SkillTable:getDesc(id)
	return xyd.tables.skillTextTable:getDesc(id)
end

function SkillTable:getIds()
	return self.TableLua.ids
end

function SkillTable:animation(id, index)
	local tmpArry = self:split(id, "animation", "#")

	return xyd.split(tmpArry[index] or "", "|")
end

function SkillTable:atkIndex(id)
	return self:getNumber(id, "atk_index")
end

function SkillTable:getPreTime(id)
	return self:getNumber(id, "pretime")
end

function SkillTable:getIsAddEnergy(id)
	return self:getNumber(id, "is_add_energy")
end

function SkillTable:getFx(id, index)
	local fxString = self:getString(id, "fx1")
	local tmpFxs = xyd.split(fxString, "#")
	local fxs = {}
	local str = tmpFxs[1] or ""

	if index then
		str = tmpFxs[index] or ""
	end

	fxs = xyd.split(str, "|", true)

	return fxs
end

function SkillTable:getFxHurt1(id, index)
	local fxString = self:getString(id, "fx_hurt1")
	local tmpFxs = xyd.split(fxString, "#")
	local fxs = {}
	local str = tmpFxs[1] or ""

	if index then
		str = tmpFxs[index] or ""
	end

	fxs = xyd.split(str, "|", true)

	return fxs
end

function SkillTable:getFxHurt1Add(id, index)
	local tmpFxs = self:split(id, "fx_hurt1_add", "#")
	local str = tmpFxs[1] or ""

	if index then
		str = tmpFxs[index] or ""
	end

	local arry = xyd.split(str, ";")
	local data = {}

	for key, str2 in ipairs(arry) do
		table.insert(data, xyd.split(str2, "|", true))
	end

	return data
end

function SkillTable:getFxHurt2(id, index)
	local fxString = self:getString(id, "fx_hurt2")
	local tmpFxs = xyd.split(fxString, "#")
	local fxs = {}
	local str = tmpFxs[1] or ""

	if index then
		str = tmpFxs[index] or ""
	end

	fxs = xyd.split(str, "|", true)

	return fxs
end

function SkillTable:getEffects(id)
	local effects = {}

	for i = 1, 3 do
		local effect = xyd.split(self:getString(id, "effect" .. tostring(i)), "|")

		if #effect > 0 then
			table.insert(effects, effect)
		end
	end

	return effects
end

function SkillTable:isAttrPas(id)
	return self:getNumber(id, "attr_pas") == 1
end

function SkillTable:attrPas(id)
	return self:getNumber(id, "attr_pas")
end

function SkillTable:getSkillIcon(id)
	return self:getString(id, "icon_id")
end

function SkillTable:getSkillLev(id)
	return self:getNumber(id, "level")
end

function SkillTable:getIsEx(id)
	return self:getNumber(id, "is_exskill")
end

function SkillTable:getSound(id, index)
	if index == nil then
		index = 1
	end

	local sounds = self:split2num(id, "sound", "#")

	if not sounds then
		return 0
	end

	local sound = sounds[index] and sounds[index] or sounds[1]
	sound = sound or 0

	return sound
end

function SkillTable:isShake(id, index)
	local data = self:split2num(id, "shake_screen", "#")

	return (data[index] or 0) == 1
end

function SkillTable:shakeTime(id, index)
	local data = self:split(id, "shake_screen_time", "#")

	return data[index] or ""
end

function SkillTable:getTargets(id, index)
	if index then
		return self:getNumber(id, "target" .. tostring(index))
	else
		local targets = {}
		local i = 1

		while i <= 3 do
			local target = self:getNumber(id, "target" .. tostring(i))

			if target then
				table.insert(targets, target)
			end

			i = i + 1
		end

		return targets
	end
end

function SkillTable:getTargetNoEffect(id)
	return self:split2num(id, "target_no_effect", "|")
end

function SkillTable:getTargetSkillIndex(id, index)
	local result = index
	local noEffects = self:getTargetNoEffect(id)

	for i = 1, #noEffects do
		if noEffects[i] == index then
			result = -1
		end
	end

	return result
end

function SkillTable:heroPosType(id, index)
	local data = self:split2num(id, "hero_pos_type", "#")

	return data[index] or 0
end

function SkillTable:heroPosTypeXY(id, index)
	local arry = self:split(id, "hero_pos_type_xy", "#")
	local data = {}

	if arry and arry[index] then
		data = xyd.split(arry[index], "|", true)
	end

	return data
end

function SkillTable:getRandNum(id, index)
	return self:getNumber(id, "rand" .. tostring(index)) or 1
end

function SkillTable:getEffect(id, index)
	return self:split2num(id, "effect" .. tostring(index), "|")
end

function SkillTable:getEffectAdd(id)
	local arry = self:split(id, "effect1_add", ";")
	local data = {}

	for key, str in ipairs(arry) do
		table.insert(data, xyd.split(str, "|", true))
	end

	return data
end

function SkillTable:getNoCrit(id, index)
	return self:getNumber(id, "no_crit" .. tostring(index)) or 0
end

function SkillTable:getNoMiss(id, index)
	return self:getNumber(id, "no_miss" .. tostring(index)) or 0
end

function SkillTable:getNoAct(id, index)
	return self:getNumber(id, "no_act" .. tostring(index)) or 0
end

function SkillTable:getTrigger(id)
	return self:getNumber(id, "trigger")
end

function SkillTable:trigger(id)
	return self:getNumber(id, "trigger") or 0
end

function SkillTable:isBlackScreen(id, index)
	local data = self:split2num(id, "black_screen", "#")

	return (data[index] or 0) == 1
end

function SkillTable:getPreEffect(id)
	return self:getNumber(id, "pre_effect") or 0
end

function SkillTable:getSubSkills(id)
	return self:split2num(id, "sub_skill", "|")
end

function SkillTable:isPass(id)
	return self:getNumber(id, "is_pass")
end

function SkillTable:getSkillEffects(id)
	return self:getNumber(id, "skill_effect")
end

function SkillTable:isUnSeal(id)
	return self:getNumber(id, "is_unseal")
end

function SkillTable:isCostEnergy(id)
	return self:getNumber(id, "is_cost_energy")
end

return SkillTable
