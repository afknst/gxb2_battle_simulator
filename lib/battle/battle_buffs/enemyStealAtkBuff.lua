local enemyStealAtkBuff = class("enemyStealAtkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function enemyStealAtkBuff:ctor(params)
	enemyStealAtkBuff.super.ctor(self, params)
	self:getPosAtk()
end

function enemyStealAtkBuff:setIsHit()
	self:baseSetIsHit()
end

function enemyStealAtkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function enemyStealAtkBuff:getPosAtk()
	self.posAtk = {}

	for i = 1, 6 do
		self.posAtk[i] = 0
	end

	for k, v in ipairs(xyd.Battle.teamA) do
		self.posAtk[v:getPos()] = v:getAD({
			exceptEnemySteal = true
		}) * self.finalNumArray_[1]
	end
end

function enemyStealAtkBuff:getPosStealAtk(fighter)
	local sidePos = nil
	local index = 0
	local side = 1

	if fighter:getPos() > 6 then
		sidePos = fighter:getPos() - 6
		index = sidePos
	else
		sidePos = fighter:getPos() + 6
		index = fighter:getPos()
		side = -1
	end

	local roundIndex = xyd.Battle.round

	if self.finalNumArray_[2] < roundIndex then
		roundIndex = self.finalNumArray_[2]
	end

	if roundIndex == 0 then
		roundIndex = 1
	end

	return self.posAtk[index] * roundIndex * side
end

return enemyStealAtkBuff
