local MonsterTable = class("MonsterTable", import("app.common.tables.BaseTable"))

function MonsterTable:ctor()
	MonsterTable.super.ctor(self, "monster")

	self.datas_ = {}
end

function MonsterTable:getPartnerLink(id)
	return self:getNumber(id, "partner_link")
end

function MonsterTable:getPartnerSkin(id)
	return self:getNumber(id, "skin")
end

function MonsterTable:getShowLev(id)
	return self:getNumber(id, "lv_show")
end

function MonsterTable:getLv(id)
	return self:getNumber(id, "lv")
end

function MonsterTable:isBoss(id)
	return self:getNumber(id, "is_boss") == 1
end

function MonsterTable:getScale(id)
	return self:getNumber(id, "scale")
end

function MonsterTable:getGrade(id)
	return self:getNumber(id, "grade")
end

function MonsterTable:getValByKey(id, key)
	return self:getNumber(id, key)
end

function MonsterTable:getSkin(id)
	return self:getNumber(id, "skin")
end

function MonsterTable:getXOffset(id)
	return self:getNumber(id, "x_offset")
end

function MonsterTable:getName(id)
	return self:getNumber(id, "name")
end

function MonsterTable:getSkill(id)
	return self:split2num(id, "skill", "|")
end

function MonsterTable:getExSkills(id)
	return self:split2num(id, "exskill", "|")
end

function MonsterTable:getHp(id)
	return self:getNumber(id, "hp")
end

return MonsterTable
