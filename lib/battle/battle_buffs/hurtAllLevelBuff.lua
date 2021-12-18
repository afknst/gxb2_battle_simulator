local hurtAllLevelBuff = class("hurtAllLevelBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function hurtAllLevelBuff:ctor(params)
	hurtAllLevelBuff.super.ctor(self, params)
end

function hurtAllLevelBuff:setIsHit()
	self:baseSetIsHit()
end

function hurtAllLevelBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local enemyLevels = 0

	for k, v in ipairs(self.fighter.sideTeam_) do
		if v.level_ then
			enemyLevels = enemyLevels + v.level_
		end
	end

	local result = math.max(self.finalNumArray_[1] * enemyLevels + self.finalNumArray_[2], 100)

	return -result / 100 * self.fighter:getAD()
end

function hurtAllLevelBuff:excuteBuff(unit, recordBuffs)
	self:writeRecord(self.target, xyd.BUFF_WORK)
end

return hurtAllLevelBuff
