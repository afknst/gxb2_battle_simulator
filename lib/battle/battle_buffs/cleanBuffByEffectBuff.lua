local cleanBuffByEffectBuff = class("cleanBuffByEffectBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffManager = xyd.Battle.getRequire("BuffManager")

function cleanBuffByEffectBuff:ctor(params)
	cleanBuffByEffectBuff.super.ctor(self, params)
end

function cleanBuffByEffectBuff:setIsHit()
	self:baseSetIsHit()
end

function cleanBuffByEffectBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function cleanBuffByEffectBuff:excuteBuff(unit, recordBuffs)
	local needCleanBuffs = {}
	local needRemoveBuffs = {}

	for k, v in ipairs(self.finalNumArray_) do
		needCleanBuffs[EffectTable:buff(v)] = true
	end

	for _, buff in ipairs(self.target.buffs_) do
		local name_ = buff:getName()

		if needCleanBuffs[name_] and buff:isDebuff() and buff:ifCanClean() then
			local actual_buff = buff:getActualBuff()

			if actual_buff ~= nil then
				buff:writeRecord(self.target, xyd.BUFF_REMOVE)
				table.insert(recordBuffs, buff)
				table.insert(needRemoveBuffs, buff)
			end
		end
	end

	self.target:removeBuffs(needRemoveBuffs)
end

return cleanBuffByEffectBuff
