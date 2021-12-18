local yujiUnlimitedReviveBuff = class("yujiUnlimitedReviveBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local yujiTableIDs = {
	55004,
	655011,
	755002
}

function yujiUnlimitedReviveBuff:ctor(params)
	yujiUnlimitedReviveBuff.super.ctor(self, params)
end

function yujiUnlimitedReviveBuff:setIsHit()
	local name = self:getName()
	local hero = self.target.hero_
	local heroTableID = hero:getTableID()

	if hero:isMonster() then
		heroTableID = hero:getPartnerLink()
	end

	local isYuji = xyd.arrayIndexOf(yujiTableIDs, heroTableID) > 0

	if isYuji then
		self.isHit_ = true
	else
		self.isHit_ = false
	end
end

function yujiUnlimitedReviveBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num

	return finalNum
end

return yujiUnlimitedReviveBuff
