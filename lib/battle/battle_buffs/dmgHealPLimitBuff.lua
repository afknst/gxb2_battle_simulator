local dmgHealPLimitBuff = class("dmgHealPLimitBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function dmgHealPLimitBuff:ctor(params)
	dmgHealPLimitBuff.super.ctor(self, params)
end

function dmgHealPLimitBuff:setIsHit()
	self:baseSetIsHit()

	if self.isHit_ then
		if self.target.dmgHealPLimitBuffRound and self.target.dmgHealPLimitBuffRound == xyd.Battle.round then
			self.target.dmgHealPLimitBuffTimes = self.target.dmgHealPLimitBuffTimes + 1
		else
			self.target.dmgHealPLimitBuffRound = xyd.Battle.round
			self.target.dmgHealPLimitBuffTimes = 0
		end

		if EffectTable:num(self.effectID, true)[2] <= self.target.dmgHealPLimitBuffTimes then
			self.isHit_ = false
		end
	end
end

function dmgHealPLimitBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function dmgHealPLimitBuff:excuteBuff(unit, recordBuffs)
	local params1 = {
		effectID = self.finalNumArray_[1],
		fighter = self.fighter,
		target = self.target,
		skillID = self.skillID
	}

	BuffManager:addNewBuff(params1, unit)
end

return dmgHealPLimitBuff
