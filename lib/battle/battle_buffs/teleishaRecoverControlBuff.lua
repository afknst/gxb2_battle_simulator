local teleishaRecoverControlBuff = class("teleishaRecoverControlBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable
local GetTarget_ = xyd.Battle.getRequire("GetTarget")

function teleishaRecoverControlBuff:ctor(params)
	teleishaRecoverControlBuff.super.ctor(self, params)
end

function teleishaRecoverControlBuff:setIsHit()
	self:baseSetIsHit()
end

function teleishaRecoverControlBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function teleishaRecoverControlBuff:excuteBuff(unit, recordBuffs)
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

	local controlBuffs, allNames = self.target:getControlBuffs()

	if not next(controlBuffs) then
		return
	end

	local newTarget = GetTarget_.useTarget(18, self.target, 1)

	if not next(newTarget) then
		return
	end

	local selectNames = xyd.randomSelects(allNames, 1)
	local sName = selectNames[1]

	if not sName then
		return
	end

	if sName then
		local buffs = controlBuffs[sName]

		if next(buffs) then
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

			local params1 = {
				target = self.target,
				fighter = self.target
			}
			local displayBuff1 = xyd.newBuff(params1)
			displayBuff1.isHit_ = true
			displayBuff1.name_ = xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY_SELF
			displayBuff1.preName_ = xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY_SELF

			displayBuff1:writeRecord(self.target, xyd.BUFF_ON_WORK)
			table.insert(recordBuffs, displayBuff1)

			local selectTargets = newTarget
			local sTarget = selectTargets[1]
			local params2 = {
				target = sTarget,
				fighter = self.target
			}
			local displayBuff2 = xyd.newBuff(params2)
			displayBuff2.isHit_ = true
			displayBuff2.name_ = xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY
			displayBuff2.preName_ = xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY

			displayBuff2:writeRecord(sTarget, xyd.BUFF_ON_WORK)
			table.insert(recordBuffs, displayBuff2)

			for _, buff in ipairs(buffs) do
				buff:writeRecord(self.target, xyd.BUFF_REMOVE)
				table.insert(recordBuffs, buff)
				table.insert(removeBuffLists, buff)

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
							if newBuff:getName() == xyd.BUFF_ALL_TARGET_CHANGE then
								newBuff:writeRecord(sTarget, xyd.BUFF_ON_WORK)
							else
								newBuff:writeRecord(sTarget, xyd.BUFF_ON)
							end

							table.insert(recordBuffs, newBuff)
						end
					end
				end
			end
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return teleishaRecoverControlBuff
