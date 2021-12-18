local debuffCopyBuff = class("debuffCopyBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local GetTarget_ = xyd.Battle.getRequire("GetTarget")

function debuffCopyBuff:ctor(params)
	debuffCopyBuff.super.ctor(self, params)
end

function debuffCopyBuff:setIsHit()
	self:baseSetIsHit()
end

function debuffCopyBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num

	return finalNum
end

function debuffCopyBuff:excuteBuff(unit, recordBuffs)
	local res = self.target:getNewDebuffList({
		1,
		2,
		4
	})
	local nameNum = res.dNameNum
	local debuffList = res.listByName

	if nameNum <= 0 then
		self:setRecordNum(0)
		self:writeRecord(self.target, xyd.BUFF_OFF)

		return
	end

	local exceptFighters = {
		[self.target:getPos()] = true
	}
	local newTarget = GetTarget_.useTarget(18, self.fighter, 2, unit, exceptFighters)

	if #newTarget <= 0 then
		self:setRecordNum(0)
		self:writeRecord(self.target, xyd.BUFF_OFF)

		return
	end

	local copyNum = self:getFinalNum()
	local dNameList = {}

	for dName, _ in pairs(debuffList) do
		table.insert(dNameList, dName)
	end

	table.sort(dNameList)

	local copyNameList = xyd.randomSelects(dNameList, copyNum)

	for _, dName in ipairs(copyNameList) do
		local debuffs = debuffList[dName]
		local count = 0

		for i = 1, #debuffs do
			if count >= 3 then
				break
			end

			local debuff = debuffs[i]

			for _, copyTarget in ipairs(newTarget) do
				local newBuff = xyd.copyBuff(debuff, copyTarget, debuff.fighter)

				copyTarget:addBuffs({
					newBuff
				}, unit)
				table.insert(recordBuffs, newBuff)
				newBuff:writeRecord(copyTarget, xyd.BUFF_ON)
			end

			count = count + 1
		end
	end

	self:setRecordNum(0)
end

return debuffCopyBuff
