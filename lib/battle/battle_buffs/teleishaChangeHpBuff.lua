local teleishaChangeHpBuff = class("teleishaChangeHpBuff", xyd.Battle.getRequire("ReportBuff"))
local battle_event = xyd.Battle.getRequire("battle_event")
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function teleishaChangeHpBuff:ctor(params)
	teleishaChangeHpBuff.super.ctor(self, params)
end

function teleishaChangeHpBuff:setIsHit()
	self:baseSetIsHit()
end

function teleishaChangeHpBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function teleishaChangeHpBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local removeBuffLists = {}
	local costBuffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_RECOVER_COST)
	local costNum = 0

	if #self.finalNumArray_ > 1 then
		local costNumList = xyd.randomSelects(self.finalNumArray_, 1)
		costNum = costNumList[1]
	else
		costNum = self.finalNumArray_[1]
	end

	if costNum > #costBuffs then
		return
	end

	local team = self.target.sideTeam_
	local maxHpEnemy = nil
	local maxHp = 0
	local mHp = self.target:getHp()

	for _, fighter in ipairs(team) do
		if fighter ~= self.target and not fighter:isDeath() then
			local fHp = fighter:getHp()

			if maxHp < fHp and mHp < fHp then
				maxHp = fHp
				maxHpEnemy = fighter
			end
		end
	end

	if not maxHpEnemy then
		return
	end

	local num = 0

	for i = #costBuffs, 1, -1 do
		if costNum <= num then
			break
		end

		local cBuff = costBuffs[i]

		cBuff:writeRecord(self.target, xyd.BUFF_REMOVE)
		table.insert(recordBuffs, cBuff)
		table.insert(removeBuffLists, cBuff)

		num = num + 1
	end

	local diffHp = math.min(maxHp - mHp, self.target:getAD() * 50)
	local params1 = {
		target = self.target,
		fighter = self.target
	}

	self.target:updateHpDirect(diffHp, unit)
	self.target:recordData(diffHp, diffHp)
	maxHpEnemy:updateHpDirect(-diffHp, unit)

	local displayBuff1 = xyd.newBuff(params1)
	displayBuff1.isHit_ = true
	displayBuff1.name_ = xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY_SELF
	displayBuff1.preName_ = xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY_SELF

	displayBuff1:writeRecord(self.target, xyd.BUFF_ON_WORK)
	table.insert(recordBuffs, displayBuff1)

	local params2 = {
		target = maxHpEnemy,
		fighter = self.target
	}
	local displayBuff2 = xyd.newBuff(params2)
	displayBuff2.isHit_ = true
	displayBuff2.name_ = xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY
	displayBuff2.preName_ = xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY

	displayBuff2:writeRecord(maxHpEnemy, xyd.BUFF_ON_WORK)
	table.insert(recordBuffs, displayBuff2)
	self.target:removeBuffs(removeBuffLists)
end

return teleishaChangeHpBuff
