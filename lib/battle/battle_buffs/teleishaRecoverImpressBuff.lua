local teleishaRecoverImpressBuff = class("teleishaRecoverImpressBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function teleishaRecoverImpressBuff:ctor(params)
	teleishaRecoverImpressBuff.super.ctor(self, params)
end

function teleishaRecoverImpressBuff:setIsHit()
	self:baseSetIsHit()
end

function teleishaRecoverImpressBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function teleishaRecoverImpressBuff:excuteBuff(unit, recordBuffs)
	self:setRecordNum(0)

	local costBuffs = self.target:getBuffsByNameAndFighter(xyd.BUFF_TELEISHA_RECOVER_COST)
	local costNum = 0
	local removeBuffLists = {}

	if #self.finalNumArray_ > 1 then
		local costNumList = xyd.randomSelects(self.finalNumArray_, 1)
		costNum = costNumList[1]
	else
		costNum = self.finalNumArray_[1]
	end

	if costNum > #costBuffs then
		return
	end

	local impressBuffs, allNames = self.target:getImpressBuffs()

	if not next(impressBuffs) then
		return
	end

	local selectNames = xyd.randomSelects(allNames, 1)
	local sName = selectNames[1]

	if not sName then
		return
	end

	if sName then
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

		local buffs = impressBuffs[sName]

		if next(buffs) then
			for _, buff in ipairs(buffs) do
				buff:writeRecord(self.target, xyd.BUFF_REMOVE)
				table.insert(recordBuffs, buff)
				table.insert(removeBuffLists, buff)
			end
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return teleishaRecoverImpressBuff
