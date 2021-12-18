local PartnerTextTable = class("PartnerTextTable", import("app.common.tables.BaseTable"))

function PartnerTextTable:ctor()
	PartnerTextTable.super.ctor(self, "partner_text_" .. tostring(xyd.Global.lang))
end

function PartnerTextTable:getName(id)
	return self:getString(id, "name")
end

function PartnerTextTable:getDialog(id)
	return self:getString(id, "dialog")
end

function PartnerTextTable:getClickDialog(id, index)
	if index == nil then
		index = 1
	end

	return self:getString(id, "click_dialog" .. tostring(index))
end

function PartnerTextTable:getCVName(id)
	return self:getString(id, "cv_name")
end

function PartnerTextTable:getBattleDialog(id)
	return self:getString(id, "battle_dialog")
end

function PartnerTextTable:getDeadDialog(id)
	return self:getString(id, "dead_dialog")
end

function PartnerTextTable:getSkilleDialog(id)
	return self:getString(id, "skill_dialog")
end

function PartnerTextTable:getGiftDialog(id, index)
	return self:getString(id, "love_gift_dialog" .. tostring(index))
end

function PartnerTextTable:getVowText(id)
	return self:getString(id, "vow_dialog")
end

function PartnerTextTable:getLoginDialog(id)
	return self:getString(id, "login_dialog")
end

function PartnerTextTable:getLvlupDialog(id)
	return self:getString(id, "lvlup_dialog")
end

function PartnerTextTable:getGradeupDialog(id)
	return self:getString(id, "gradeup_dialog")
end

function PartnerTextTable:getAwakeDialog(id)
	return self:getString(id, "awake_dialog")
end

function PartnerTextTable:getShenXueDialog(id)
	return self:getString(id, "shengxue_dialog")
end

function PartnerTextTable:getEquipDialog(id, index)
	return self:getString(id, "equip_dialog" + index)
end

function PartnerTextTable:getHouseDialog(id)
	return self:getString(id, "house_dialog")
end

function PartnerTextTable:getHouseSetDialog(id)
	return self:getString(id, "house_set_dialog")
end

function PartnerTextTable:getStageDialog(id)
	return self:getString(id, "new_stage_dialog")
end

function PartnerTextTable:getTaverDialog(id)
	return self:getString(id, "dagong_dialog")
end

function PartnerTextTable:getMissionDialog(id)
	return self:getString(id, "daily_mission_dialog")
end

function PartnerTextTable:getIdleDialog(id)
	return self:getString(id, "idle_dialog")
end

function PartnerTextTable:getVowDialog(id)
	return self:getString(id, "vow_dialog")
end

function PartnerTextTable:getVictoryDialog(id)
	return self:getString(id, "victory_dialog")
end

function PartnerTextTable:getFailedDialog(id)
	return self:getString(id, "failed_dialog")
end

return PartnerTextTable
