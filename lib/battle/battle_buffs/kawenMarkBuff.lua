local kawenMarkBuff = class("kawenMarkBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")
local GetTarget_ = xyd.Battle.getRequire("GetTarget")

function kawenMarkBuff:ctor(params)
	kawenMarkBuff.super.ctor(self, params)
end

function kawenMarkBuff:setIsHit()
	self:baseSetIsHit()
end

function kawenMarkBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function kawenMarkBuff:needWorkAndOn()
	return true
end

function kawenMarkBuff:shareHarm(defender, finalNum, unit, attacker)
	local selfIsFront = not defender:isBackTarget()
	local alives = GetTarget_.S2(defender)
	local sharePartners = GetTarget_.frontTargets(alives, true) or {}
	local canUseFrontNum = #sharePartners

	if selfIsFront then
		canUseFrontNum = canUseFrontNum - 1
	end

	if canUseFrontNum == 0 then
		return finalNum
	end

	local frontSharePercent = self.finalNumArray_[3] / canUseFrontNum
	local selfPercent = 1 - self.finalNumArray_[3]
	local buffs = {}

	for k, v in ipairs(sharePartners) do
		attacker = attacker or self.target

		if v ~= defender then
			local params = {
				target = v,
				fighter = attacker
			}
			local buff = BuffManager:newBuff(params)
			buff.isHit_ = true
			buff.name_ = xyd.BUFF_HURT_SHARE
			buff.preName_ = xyd.BUFF_HURT_SHARE
			buff.finalNum_ = frontSharePercent * finalNum

			table.insert(buffs, buff)
		end
	end

	attacker:harmShareCalculate(unit, buffs)

	return finalNum * selfPercent
end

return kawenMarkBuff
