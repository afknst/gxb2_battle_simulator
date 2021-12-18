local xCanSkillBuff = class("xCanSkillBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function xCanSkillBuff:ctor(params)
	xCanSkillBuff.super.ctor(self, params)

	self.partnerSkillTimes = 0
	self.noCheckIds = {}
end

function xCanSkillBuff:setIsHit()
	self:baseSetIsHit()
end

function xCanSkillBuff:addNoCheckId(skillID)
	for k, v in ipairs(self.noCheckIds) do
		if v == skillID then
			return
		end
	end

	table.insert(self.noCheckIds, skillID)
end

function xCanSkillBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function xCanSkillBuff:addPartnerSkillTimes(skillID)
	if skillID then
		for k, v in ipairs(self.noCheckIds) do
			if v == skillID then
				return
			end
		end
	end

	self.partnerSkillTimes = self.partnerSkillTimes + 1
end

function xCanSkillBuff:excuteAfterRound(unit)
	self.partnerSkillTimes = 0
end

function xCanSkillBuff:canSkill()
	return self.partnerSkillTimes < self.finalNumArray_[1]
end

return xCanSkillBuff
