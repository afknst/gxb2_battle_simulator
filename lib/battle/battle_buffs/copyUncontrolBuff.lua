local copyUncontrolBuff = class("copyUncontrolBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function copyUncontrolBuff:ctor(params)
	copyUncontrolBuff.super.ctor(self, params)
end

function copyUncontrolBuff:setIsHit()
	self:baseSetIsHit()
end

function copyUncontrolBuff:calculateFinalNum(name, num, buffData, forceHurt)
	return 0
end

function copyUncontrolBuff:excuteBuff(unit, recordBuffs)
	local removeBuffLists = {}
	local uncontrolBuffs, allNames = self.target:getUnControlBuffs()

	if not next(uncontrolBuffs) then
		return
	end

	local newTarget = {}
	local team = self.target.sideTeam_

	for _, fighter in ipairs(team) do
		if fighter ~= self.target and not fighter:isDeath() then
			table.insert(newTarget, fighter)
		end
	end

	if not next(newTarget) then
		return
	end

	local selectNames = xyd.randomSelects(allNames, 1)
	local sName = selectNames[1]

	if not sName then
		return
	end

	if sName then
		local buffs = uncontrolBuffs[sName]

		if next(buffs) then
			local num = 0
			local selectTargets = xyd.randomSelects(newTarget, 1)
			local sTarget = selectTargets[1]

			for _, buff in ipairs(buffs) do
				if xyd.weightedChoise({
					self.finalNumArray_[1],
					1 - self.finalNumArray_[1]
				}) then
					buff:writeRecord(self.target, xyd.BUFF_REMOVE)
					table.insert(recordBuffs, buff)
					table.insert(removeBuffLists, buff)
				end

				if buff:isCanDebuffSame() and sTarget then
					local newBuff = xyd.copyBuff(buff, sTarget, buff.fighter, 1)

					if newBuff:isHit() then
						newBuff:changeBuffName()
						newBuff:setEndLoop(true)
						sTarget:addBuffs({
							newBuff
						}, unit)
						sTarget:delSpecialBuffCount(newBuff)

						if newBuff:getCount() > 0 then
							newBuff:writeRecord(sTarget, xyd.BUFF_ON)
							table.insert(recordBuffs, newBuff)
						end
					end
				end
			end
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return copyUncontrolBuff
