local fateWheelCleanBuff = class("fateWheelCleanBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable

function fateWheelCleanBuff:ctor(params)
	fateWheelCleanBuff.super.ctor(self, params)
end

function fateWheelCleanBuff:setIsHit()
	self:baseSetIsHit()

	self.recordBuffs = {}

	if self.isHit_ then
		local fateBuffs = {}

		for k, v in ipairs(self.target.selfTeam_) do
			local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_FATE_WHEEL)

			if buffs[1] and buffs[1].fighter == self.target then
				table.insert(fateBuffs, buffs[1])
			end
		end

		for _, mBuff in ipairs(fateBuffs) do
			mBuff:writeRecord(mBuff.target, xyd.BUFF_REMOVE)
			table.insert(self.recordBuffs, mBuff)
			mBuff.target:removeBuffs({
				mBuff
			})
		end
	end
end

function fateWheelCleanBuff:calculateFinalNum(name, num, isPercent, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function fateWheelCleanBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	for k, v in ipairs(self.recordBuffs) do
		table.insert(recordBuffs, v)
	end
end

return fateWheelCleanBuff
