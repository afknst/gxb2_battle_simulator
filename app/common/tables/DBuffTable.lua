local DBuffTable = class("DBuffTable", import("app.common.tables.BaseTable"))

function DBuffTable:ctor()
	DBuffTable.super.ctor(self, "buff")

	self.dmgs = {
		xyd.BUFF_HURT,
		xyd.BUFF_TRUE_HURT,
		xyd.BUFF_M_HURT,
		xyd.BUFF_HURT_FREE_ARM,
		xyd.BUFF_SAME_ATK_HURT,
		xyd.BUFF_REAL_HURT
	}
	self.dmgRestarints = {
		xyd.BUFF_HURT,
		xyd.BUFF_TRUE_HURT,
		xyd.BUFF_ADD_HURT,
		xyd.BUFF_ADD_HURTD,
		xyd.BUFF_M_HURT,
		xyd.BUFF_REAL_HURT
	}
	self.dots = {
		xyd.BUFF_DOT,
		xyd.BUFF_DOT_POISON,
		xyd.BUFF_DOT_BLOOD
	}
	self.roots = {
		xyd.BUFF_STUN,
		xyd.BUFF_STONE,
		xyd.BUFF_ICE,
		xyd.BUFF_CRYSTALL,
		xyd.BUFF_CRYSTALLIZE,
		xyd.BUFF_TELEISHA_SEAL
	}
	self.heals = {
		xyd.BUFF_HEAL
	}
	self.buffs_ = {}
	local colIndexTable = self.TableLua.keys

	for id, _ in pairs(self.TableLua.rows) do
		local row = self.TableLua.rows[id]
		self.buffs_[id] = {}

		for key in pairs(colIndexTable) do
			self.buffs_[id][key] = row[colIndexTable[key]]
		end
	end
end

function DBuffTable:getBuffs()
	return self.buffs_
end

function DBuffTable:isDmg(name)
	return self:indexOf(self.dmgs, name) > -1
end

function DBuffTable:isDmgRestarints(name)
	return self:indexOf(self.dmgRestarints, name) > -1
end

function DBuffTable:isDot(name)
	return self:indexOf(self.dots, name) > -1
end

function DBuffTable:isHeal(name)
	return self:indexOf(self.heals, name) > -1
end

function DBuffTable:isRoots(name)
	return self:indexOf(self.roots, name) > -1
end

function DBuffTable:getIcon1(name)
	return self:getString(name, "icon1")
end

function DBuffTable:getIcon2(name)
	return self:getString(name, "icon2")
end

function DBuffTable:getFx(name)
	return self:split2num(name, "fx", "|")
end

function DBuffTable:getJob(name)
	return self:getNumber(name, "job") or 0
end

function DBuffTable:getGroup(name)
	return self:split2num(name, "group", "|")
end

function DBuffTable:isCannotClean(name)
	return self:getNumber(name, "is_unclean") or 0
end

function DBuffTable:isPercent(name)
	return self:getNumber(name, "is_percent") == 1
end

function DBuffTable:isShowPercent(name)
	return self:getNumber(name, "show_percent") == 1
end

function DBuffTable:actualBuff(name)
	return self:getString(name, "actual_buff")
end

function DBuffTable:getDesc(name)
	return xyd.tables.buffTextTable:getDesc(name)
end

function DBuffTable:getFactor(name)
	return self:getNumber(name, "factor")
end

function DBuffTable:isAttr(name)
	return self:getNumber(name, "is_attr")
end

function DBuffTable:isPassNoAttr(name)
	return self:getNumber(name, "is_pass_no_attr")
end

function DBuffTable:getHeros(name)
	return self:split2num(name, "hero", "|")
end

function DBuffTable:pos(name)
	return self:split2num(name, "pos", "|") or {}
end

function DBuffTable:getBuffType(name)
	return self:getNumber(name, "type")
end

function DBuffTable:heroWorkFx(name, modelID)
	local allHeros = self:split(name, "hero_work_fx", "|")
	local selectFx = nil

	for _, fxStr in ipairs(allHeros) do
		local fx = xyd.split(fxStr, "#")

		if tonumber(fx[1]) == modelID then
			selectFx = fx

			break
		end
	end

	return selectFx
end

function DBuffTable:translationDesc(str)
	local name = str[1]
	local val = str[2]
	local tmpDesc = self:getDesc(name)
	local desc = "+"
	local factor = self:Number(self:getFactor(name)) or 1

	if self:isShowPercent(name) then
		local str = string.format("%.1f", val * 100 / factor)
		desc = tostring(desc) .. str .. "%"
	else
		desc = tostring(desc) .. tostring(val)
	end

	desc = tostring(desc) .. " " .. tostring(tmpDesc)

	return desc
end

function DBuffTable:translationNum(name, val)
	local desc = ""
	local factor = self:Number(self:getFactor(name)) or 1

	if factor == 0 then
		factor = 1
	end

	if self:isShowPercent(name) then
		local str = string.format("%.1f", val * 100 / factor)
		desc = tostring(desc) .. str .. "%"
	else
		desc = tostring(desc) .. tostring(val)
	end

	return desc
end

function DBuffTable:isCanDebuffSame(name)
	local val = self:getNumber(name, "is_debuffSame")

	return val ~= 1
end

function DBuffTable:hasChild(name)
	local hasChild = self:getNumber(name, "has_child")

	return hasChild == 1
end

function DBuffTable:getDebuffType(name)
	local debuffType = self:getNumber(name, "debuff_type")

	return debuffType
end

function DBuffTable:hasFx(name)
	local hasFx = self:getNumber(name, "has_fx")

	return hasFx == 1
end

function DBuffTable:getIsAttrBuff(name)
	local isAttrBuff = self:getNumber(name, "is_attr_buff")

	return isAttrBuff == 1
end

function DBuffTable:getIsHpChange(name)
	return self:getNumber(name, "is_hp_change")
end

function DBuffTable:getLayer(name)
	return self:getNumber(name, "layer") or 0
end

function DBuffTable:getCover(name)
	return self:getNumber(name, "cover") or 0
end

return DBuffTable
