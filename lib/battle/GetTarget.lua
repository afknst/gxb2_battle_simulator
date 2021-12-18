local GetTarget = {}
local math = math

function GetTarget.getTeam(fighter)
	return fighter.selfTeam_, fighter.targetTeam_
end

function GetTarget.aliveTargets(fighters)
	local targets = {}

	for _, v in ipairs(fighters) do
		if not v:isDeath() and not v:isExile() then
			table.insert(targets, v)
		end
	end

	return targets
end

function GetTarget.frontTargets(fighters, isOnce)
	if not next(fighters) then
		return
	end

	local targets = {}

	for _, v in ipairs(fighters) do
		local pos = v:getPos()

		if v:getTeamType() == xyd.TeamType.B then
			pos = pos - xyd.TEAM_B_POS_BASIC
		end

		if pos <= xyd.DEFAULT_FRONT_NUM then
			table.insert(targets, v)
		end
	end

	if not next(targets) and not isOnce then
		return GetTarget.backTargets(fighters, true)
	end

	return targets
end

function GetTarget.backTargets(fighters, isOnce)
	if not next(fighters) then
		return
	end

	local targets = {}

	for _, v in ipairs(fighters) do
		local pos = v:getPos()

		if v:getTeamType() == xyd.TeamType.B then
			pos = pos - xyd.TEAM_B_POS_BASIC
		end

		if xyd.DEFAULT_FRONT_NUM < pos and pos <= xyd.DEFAULT_FRONT_NUM + xyd.DEFAULT_BACK_NUM then
			table.insert(targets, v)
		end
	end

	if not next(targets) and not isOnce then
		return GetTarget.frontTargets(fighters, true)
	end

	return targets
end

function GetTarget.noControlFirst(fighter)
	local _, t2 = GetTarget.getTeam(fighter)
	local alives = GetTarget.aliveTargets(t2)
	local res = {}

	for _, alive in ipairs(alives) do
		if not alive:isControl() then
			table.insert(res, alive)
		end
	end

	if #res > 0 then
		return xyd.randomSelects(res, 1)[1]
	end

	return xyd.randomSelects(alives, 1)[1]
end

function GetTarget.noDebuffFirst(fighter)
	local _, t2 = GetTarget.getTeam(fighter)
	local alives = GetTarget.aliveTargets(t2)
	local res = {}

	for _, alive in ipairs(alives) do
		if not alive:isHasDebuff() then
			table.insert(res, alive)
		end
	end

	if #res > 0 then
		return xyd.randomSelects(res, 1)[1]
	end

	return xyd.randomSelects(alives, 1)[1]
end

function GetTarget.useTarget(selectType, fighter, randNum, unit, exceptFighters)
	local targetType = xyd.tables.battleTargetTable:getTargetType(selectType)

	if fighter:isRidicule() and targetType == xyd.TargetType.TARGET_ENEMY and xyd.tables.battleTargetTable:isCanChange(selectType) then
		selectType = 67
	end

	return GetTarget["S" .. selectType](fighter, randNum, unit, exceptFighters)
end

function GetTarget.S1(fighter)
	return {
		fighter
	}
end

function GetTarget.S2(fighter)
	local t1, t2 = GetTarget.getTeam(fighter)
	local alives = GetTarget.aliveTargets(t1)

	return alives
end

function GetTarget.S3(fighter)
	local alive = GetTarget.S2(fighter)
	local fighter_, minRate_ = nil

	for k, v in ipairs(alive) do
		local vRate = v:getHp() / v:getHpLimit()

		if not fighter_ or vRate < minRate_ or vRate == minRate_ and v:getHp() < fighter_:getHp() then
			fighter_ = v
			minRate_ = vRate
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S4(fighter)
	local alive = GetTarget.S2(fighter)
	local fighter_, maxRate_ = nil

	for k, v in ipairs(alive) do
		local vRate = v:getHp() / v:getHpLimit()

		if not fighter_ or maxRate_ < vRate or vRate == maxRate_ and fighter_:getHp() < v:getHp() then
			fighter_ = v
			maxRate_ = vRate
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S5(fighter)
	local alive = GetTarget.S2(fighter)

	return GetTarget.frontTargets(alive)
end

function GetTarget.S6(fighter)
	local alive = GetTarget.S2(fighter)

	return GetTarget.backTargets(alive)
end

function GetTarget.S7(fighter, num)
	local alive = GetTarget.S2(fighter)

	return xyd.randomSelects(alive, num)
end

function GetTarget.S8(fighter, num)
	local alive = GetTarget.S5(fighter)

	return xyd.randomSelects(alive, num)
end

function GetTarget.S9(fighter, num)
	local alive = GetTarget.S6(fighter)

	return xyd.randomSelects(alive, num)
end

function GetTarget.S10(fighter, num)
end

function GetTarget.S11(fighter, num)
	local alive = GetTarget.S2(fighter)

	for i, v in ipairs(alive) do
		if v == fighter then
			table.remove(alive, i)

			break
		end
	end

	return alive
end

function GetTarget.S12(fighter)
	local alives = GetTarget.S13(fighter)

	return {
		alives[1]
	}
end

function GetTarget.S13(fighter)
	local t1, t2 = GetTarget.getTeam(fighter)
	local alives = GetTarget.aliveTargets(t2)

	return alives
end

function GetTarget.S14(fighter)
	local alive = GetTarget.S13(fighter)

	return GetTarget.LowestHp(alive)
end

function GetTarget.LowestHp(alive)
	local fighter_, minRate_ = nil

	for k, v in ipairs(alive) do
		local vRate = v:getHp() / v:getHpLimit()

		if not fighter_ or vRate < minRate_ or vRate == minRate_ and v:getHp() < fighter_:getHp() then
			fighter_ = v
			minRate_ = vRate
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S15(fighter)
	local alive = GetTarget.S13(fighter)
	local fighter_, maxRate_ = nil

	for k, v in ipairs(alive) do
		local vRate = v:getHp() / v:getHpLimit()

		if not fighter_ or maxRate_ < vRate or vRate == maxRate_ and fighter_:getHp() < v:getHp() then
			fighter_ = v
			maxRate_ = vRate
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S16(fighter)
	local alive = GetTarget.S13(fighter)

	return GetTarget.frontTargets(alive)
end

function GetTarget.S17(fighter)
	local alive = GetTarget.S13(fighter)

	return GetTarget.backTargets(alive)
end

function GetTarget.findMistletoes(alives, num)
	if not alives then
		return {}, {}
	end

	local targets = {}
	local notChoosen = {}
	local tmpNum = 0

	for _, enemy in ipairs(alives) do
		local naturalLawBuffs = enemy:getBuffsByNameAndFighter(xyd.BUFF_NATURAL_LAW)

		if next(naturalLawBuffs) and tmpNum < num then
			table.insert(targets, enemy)

			tmpNum = tmpNum + 1
		else
			table.insert(notChoosen, enemy)
		end
	end

	return targets, notChoosen
end

function GetTarget.S18(fighter, num, unit, exceptFighters)
	local alive = GetTarget.S13(fighter)

	if exceptFighters then
		for i = #alive, 1, -1 do
			local target = alive[i]

			if exceptFighters[target:getPos()] then
				table.remove(alive, i)
			end
		end
	end

	local mistletoesTarget, notChoosen = GetTarget.findMistletoes(alive, num)

	if mistletoesTarget and next(mistletoesTarget) and #mistletoesTarget == num then
		return mistletoesTarget
	end

	local tmpRes = nil

	if next(fighter:getBuffsByNameAndFighter(xyd.BUFF_LOW_HP_TARGET)) then
		tmpRes = GetTarget.getLowHpFighters(notChoosen, num - #mistletoesTarget)
	else
		tmpRes = xyd.randomSelects(notChoosen, num - #mistletoesTarget)
	end

	if tmpRes and next(tmpRes) then
		mistletoesTarget = xyd.arrayMerge(mistletoesTarget, tmpRes)
	end

	return mistletoesTarget
end

function GetTarget.S19(fighter, num)
	local alive = GetTarget.S16(fighter)
	local mistletoesTarget, notChoosen = GetTarget.findMistletoes(alive, num)

	if mistletoesTarget and next(mistletoesTarget) and #mistletoesTarget == num then
		return mistletoesTarget
	end

	local tmpRes = nil

	if next(fighter:getBuffsByNameAndFighter(xyd.BUFF_LOW_HP_TARGET)) then
		tmpRes = GetTarget.getLowHpFighters(notChoosen, num - #mistletoesTarget)
	else
		tmpRes = xyd.randomSelects(notChoosen, num - #mistletoesTarget)
	end

	if tmpRes and next(tmpRes) then
		mistletoesTarget = xyd.arrayMerge(mistletoesTarget, tmpRes)
	end

	return mistletoesTarget
end

function GetTarget.S20(fighter, num)
	local alive = GetTarget.S17(fighter)
	local mistletoesTarget, notChoosen = GetTarget.findMistletoes(alive, num)

	if mistletoesTarget and next(mistletoesTarget) and #mistletoesTarget == num then
		return mistletoesTarget
	end

	local tmpRes = nil

	if next(fighter:getBuffsByNameAndFighter(xyd.BUFF_LOW_HP_TARGET)) then
		tmpRes = GetTarget.getLowHpFighters(notChoosen, num - #mistletoesTarget)
	else
		tmpRes = xyd.randomSelects(notChoosen, num - #mistletoesTarget)
	end

	if tmpRes and next(tmpRes) then
		mistletoesTarget = xyd.arrayMerge(mistletoesTarget, tmpRes)
	end

	return mistletoesTarget
end

function GetTarget.S21(fighter, num)
end

function GetTarget.S22(fighter, num, unit)
	local targetsPos = unit:getTargetsRecord()
	local alive = GetTarget.S13(fighter)

	for i = #alive, 1, -1 do
		local target = alive[i]

		if xyd.arrayIndexOf(targetsPos, target:getPos()) > 0 then
			table.remove(alive, i)
		end
	end

	return alive
end

function GetTarget.S23(fighter, num, unit)
	if unit and unit.fighter and not unit.fighter:isPet() and not unit.fighter:isGod() then
		return {
			unit.fighter
		}
	end

	return {}
end

function GetTarget.S24(fighter, num, unit)
	local targets = {}

	if unit then
		local datas = unit:getUnitDatas()
		local targetsPos = unit:getTargetsRecord()

		for i = 1, #datas do
			if not datas[i].isMiss and xyd.arrayIndexOf(targetsPos, datas[i].target:getPos()) > 0 and xyd.arrayIndexOf(targets, datas[i].target) < 0 and unit.fighter ~= datas[i].target then
				table.insert(targets, datas[i].target)
			end
		end
	end

	return targets
end

function GetTarget.S27(fighter, num, unit)
	if unit and not unit.fighter:isPet() then
		return {
			unit.fighter
		}
	end

	return {}
end

function GetTarget.S28(fighter, num, unit)
	local targets = {}

	if unit then
		local datas = unit:getUnitDatas()

		for i = 1, #datas do
			local isCrit = datas[i].isCrit

			if isCrit then
				table.insert(targets, datas[i].target)
			end
		end
	end

	return targets
end

function GetTarget.S29(fighter, num, unit)
	local alive = GetTarget.S2(fighter)
	local fighter_, maxHp_ = nil

	for k, v in ipairs(alive) do
		local curHp = v:getHpLimit()

		if not fighter_ or maxHp_ < curHp then
			fighter_ = v
			maxHp_ = curHp
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S30(fighter, num, unit)
	local alive = GetTarget.S13(fighter)
	local fighter_, maxHp_ = nil

	for k, v in ipairs(alive) do
		local curHp = v:getHpLimit()

		if not fighter_ or maxHp_ < curHp then
			fighter_ = v
			maxHp_ = curHp
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S31(fighter, num, unit)
	local targets = {}

	if unit then
		local datas = unit:getUnitDatas()
		local targetsPos = unit:getTargetsRecord()
		local tmpTargets = {}

		for i = 1, #datas do
			local target = datas[i].target

			if not datas[i].isMiss and xyd.arrayIndexOf(targetsPos, datas[i].target:getPos()) > 0 and xyd.arrayIndexOf(tmpTargets, datas[i].target) < 0 and not target:isDeath() then
				table.insert(tmpTargets, datas[i].target)
			end
		end

		if #tmpTargets > 0 then
			targets = xyd.randomSelects(tmpTargets, num)
		end
	end

	return targets
end

function GetTarget.S32(fighter, num)
	local alive = GetTarget.S2(fighter)

	for i, v in ipairs(alive) do
		if v == fighter then
			table.remove(alive, i)

			break
		end
	end

	return xyd.randomSelects(alive, num)
end

function GetTarget.S33(fighter)
	local alive = GetTarget.S2(fighter)
	local fighter_, minRate_ = nil

	for _, v in ipairs(alive) do
		if v ~= fighter and not v:isTransform() then
			local vRate = v:getHp() / v:getHpLimit()

			if not fighter_ or vRate < minRate_ or vRate == minRate_ and v:getHp() < fighter_:getHp() then
				fighter_ = v
				minRate_ = vRate
			end
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S34(fighter, num)
	local alive = GetTarget.S13(fighter)
	local mistletoesTarget, notChoosen = GetTarget.findMistletoes(alive, num)

	if mistletoesTarget and next(mistletoesTarget) and #mistletoesTarget == num then
		return mistletoesTarget
	end

	local selects = {}

	if #alive > 0 then
		selects = xyd.randomSelects(notChoosen, num - #mistletoesTarget)
	end

	selects = xyd.arrayMerge(selects, mistletoesTarget)

	return selects
end

function GetTarget.S35(fighter, num)
	local alive = GetTarget.S2(fighter)
	local noFullHpFighters = {}
	local fullHpFighters = {}

	for _, v in ipairs(alive) do
		if v:getHp() < v:getHpLimit() then
			table.insert(noFullHpFighters, v)
		else
			table.insert(fullHpFighters, v)
		end
	end

	local selects = xyd.randomSelects(noFullHpFighters, num)

	if num > #selects and #fullHpFighters > 0 then
		local leftNum = num - #selects
		local selects2 = xyd.randomSelects(fullHpFighters, leftNum)
		selects = xyd.arrayMerge(selects, selects2)
	end

	return selects
end

function GetTarget.S36()
	local result = {}

	if xyd.Battle.atkDFlag then
		table.insert(result, xyd.Battle.atkDTarget)
	end

	return result
end

function GetTarget.S37()
	local result = {}

	if xyd.Battle.fireTarget then
		table.insert(result, xyd.Battle.fireTarget)
	end

	return result
end

function GetTarget.S38()
	local result = {}

	for _, target in ipairs(xyd.Battle.energySkillTargets) do
		if not target:isDeath() then
			table.insert(result, target)
		end
	end

	return result
end

function GetTarget.S39()
	local result = {}

	for _, target in ipairs(xyd.Battle.puGongSkillTargets) do
		if not target:isDeath() then
			table.insert(result, target)
		end
	end

	return result
end

function GetTarget.S40()
	local result = {}

	if xyd.Battle.crystalTarget then
		table.insert(result, xyd.Battle.crystalTarget)
	end

	return result
end

function GetTarget.S41()
	local result = {}

	for _, t in ipairs(xyd.Battle.crystalTargets) do
		if t and not t:isDeath() then
			table.insert(result, t)
		end
	end

	return result
end

function GetTarget.S42()
	local result = {}

	for _, t in ipairs(xyd.Battle.crystalEndTargets) do
		if t and not t:isDeath() then
			table.insert(result, t)
		end
	end

	return result
end

function GetTarget.S43(fighter, num)
	local alive = GetTarget.S13(fighter)

	return GetTarget.getLowHpFighters(alive, num)
end

function GetTarget.getLowHpFighters(alives, num)
	local result = {}

	table.sort(alives, function (a, b)
		if a:getHp() / a:getHpLimit() == b:getHp() / b:getHpLimit() then
			return a:getHp() < b:getHp()
		end

		return a:getHp() / a:getHpLimit() < b:getHp() / b:getHpLimit()
	end)

	for i = 1, num do
		if alives[i] then
			table.insert(result, alives[i])
		else
			break
		end
	end

	return result
end

function GetTarget.S44(fighter)
	local result = {}
	local alives = GetTarget.aliveTargets(GetTarget.S2(fighter))

	for _, v in ipairs(alives) do
		if v.is_npc then
			table.insert(result, v)
		end
	end

	return result
end

function GetTarget.S45(fighter)
	local result = {}
	local alives = GetTarget.S13(fighter)

	for _, v in ipairs(alives) do
		if v:getHp() / v:getHpLimit() > 0.8 then
			table.insert(result, v)
		end
	end

	return result
end

function GetTarget.S46(fighter, num)
	local result = {}
	local alives = GetTarget.S13(fighter)

	table.sort(alives, function (a, b)
		return b:getAD() < a:getAD()
	end)

	for i = 1, num do
		if alives[i] then
			table.insert(result, alives[i])
		else
			break
		end
	end

	return result
end

function GetTarget.S47(fighter)
	local result = {}
	local alives = GetTarget.S13(fighter)

	for _, v in ipairs(alives) do
		if v:getHp() / v:getHpLimit() < 0.3 then
			table.insert(result, v)
		end
	end

	return result
end

function GetTarget.S48(fighter)
	local result = {}
	local alives = GetTarget.S13(fighter)
	local maxEnergy = -1
	local target = nil

	for _, v in ipairs(alives) do
		if maxEnergy < v:getEnergy() then
			target = v
			maxEnergy = v:getEnergy()
		end
	end

	table.insert(result, target)

	return result
end

function GetTarget.S49(fighter)
	local result = {}

	if xyd.Battle.justUseSkillTarget then
		table.insert(result, xyd.Battle.justUseSkillTarget)
	end

	return result
end

function GetTarget.S50(fighter)
	local alives = GetTarget.S13(fighter)
	local res = {}

	for _, alive in ipairs(alives) do
		if alive:isFriendTeamBoss() then
			table.insert(res, alive)
		end
	end

	return res
end

function GetTarget.S51(fighter, num)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v.equipHealRound ~= xyd.Battle.round then
			table.insert(res, v)
		end
	end

	local noFullHpFighters = {}
	local fullHpFighters = {}

	for _, v in ipairs(res) do
		if v:getHp() < v:getHpLimit() then
			table.insert(noFullHpFighters, v)
		else
			table.insert(fullHpFighters, v)
		end
	end

	local selects = xyd.randomSelects(noFullHpFighters, num)

	if num > #selects and #fullHpFighters > 0 then
		local leftNum = num - #selects
		local selects2 = xyd.randomSelects(fullHpFighters, leftNum)
		selects = xyd.arrayMerge(selects, selects2)
	end

	for _, v in ipairs(selects) do
		v.equipHealRound = xyd.Battle.round
	end

	return selects
end

function GetTarget.S52(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if not v.hero_:isMoreThenTenStar() then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S53(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v.hero_:isMoreThenTenStar() then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S54(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:getJob() == xyd.HeroJob.ZS then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S55(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:getJob() == xyd.HeroJob.FS then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S56(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:getJob() == xyd.HeroJob.YX then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S57(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:getJob() == xyd.HeroJob.CK then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S58(fighter)
	local alive = GetTarget.S2(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:getJob() == xyd.HeroJob.MS then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S59(fighter)
	local alive = GetTarget.S13(fighter)
	local res = {}

	for _, v in ipairs(alive) do
		if v:isStarMoon() then
			for key, buff in ipairs(v.isStarMoon_) do
				if buff.fighter == fighter then
					table.insert(res, v)

					break
				end
			end
		end
	end

	return res
end

function GetTarget.S60(fighter)
	local res = {}

	for _, v in ipairs(xyd.Battle.friendHurtTargets) do
		if not v:isDeath() then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S61(fighter)
	local res = {}
	local rPos = {}

	for _, v in ipairs(xyd.Battle.normalSkillTargets) do
		if not v:isDeath() then
			local pos = v:getPos()

			if rPos[pos] ~= 1 then
				rPos[pos] = 1

				table.insert(res, v)
			end
		end
	end

	return res
end

function GetTarget.S62(fighter)
	local res = {}
	local enemyTargets = GetTarget.S13(fighter)

	for _, v in ipairs(enemyTargets) do
		local buffNum = #v.isGetLight_

		if buffNum >= 2 then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S63(fighter, num)
	local alives = GetTarget.S13(fighter)
	local mistletoesTarget, notChoosen = GetTarget.findMistletoes(alives, num)

	if mistletoesTarget and next(mistletoesTarget) and #mistletoesTarget == num then
		return mistletoesTarget
	end

	local getLeafFighters = {}
	local noGetLeafFighters = {}

	for _, v in ipairs(notChoosen) do
		if v:isGetLeaf() then
			table.insert(getLeafFighters, v)
		else
			table.insert(noGetLeafFighters, v)
		end
	end

	local selects = xyd.randomSelects(noGetLeafFighters, num)
	selects = xyd.arrayMerge(selects, mistletoesTarget)

	if num > #selects and #getLeafFighters > 0 then
		local leftNum = num - #selects
		local selects2 = xyd.randomSelects(getLeafFighters, leftNum)
		selects = xyd.arrayMerge(selects, selects2)
	end

	return selects
end

function GetTarget.S64(fighter, num)
	local alive = GetTarget.S13(fighter)
	local fasterFighters = {}

	for _, v in ipairs(alive) do
		if fighter:getAckSpeed() < v:getAckSpeed() then
			table.insert(fasterFighters, v)
		end
	end

	local selects = xyd.randomSelects(fasterFighters, num)

	return selects
end

function GetTarget.S65(fighter, num)
	local result = {}

	for _, target in ipairs(xyd.Battle.puGongNormalSkillTargets) do
		if not target:isDeath() and target:getEnergy() > 0 then
			table.insert(result, target)
		end
	end

	return result
end

function GetTarget.S66(fighter, num)
	local result = {}
	local enemyTargets = GetTarget.S13(fighter)

	if not num or num == 0 then
		num = 1
	end

	table.sort(enemyTargets, function (a, b)
		return b:getAckSpeed() < a:getAckSpeed()
	end)

	for i = 1, num do
		if enemyTargets[i] then
			table.insert(result, enemyTargets[i])
		else
			break
		end
	end

	return result
end

function GetTarget.S67(fighter)
	local buffRidicule_ = fighter.buffRidicule_

	if buffRidicule_ and buffRidicule_.fighter and not buffRidicule_.fighter:isDeath() then
		return {
			buffRidicule_.fighter
		}
	end

	return {}
end

function GetTarget.S68(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				local buffRidicule_ = v.buffRidicule_

				if buffRidicule_ and buffRidicule_.fighter == fighter then
					table.insert(result, v)
				end
			end
		end
	end

	return result
end

function GetTarget.S69(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if isFriend then
				local vPos = v:getPos()

				if vPos % 2 == 1 then
					table.insert(result, v)
				end
			end
		end
	end

	return result
end

function GetTarget.S70(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if isFriend then
				local vPos = v:getPos()

				if vPos % 2 == 0 then
					table.insert(result, v)
				end
			end
		end
	end

	return result
end

function GetTarget.S71(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if isFriend then
				local vEnergy = v:getEnergy()

				if vEnergy < 20 then
					table.insert(result, vPos)
				end
			end
		end
	end

	return result
end

function GetTarget.S72(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				local lockBuffs = v:getBuffsByNameAndFighter(xyd.BUFF_LOCK_TARGET, fighter)

				if next(lockBuffs) then
					table.insert(result, v)

					break
				end
			end
		end
	end

	if not next(result) then
		result = GetTarget.S12(fighter)
	end

	return result
end

function GetTarget.S73(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				local iBuffs = v:getBuffsByNameAndFighter(xyd.BUFF_ATK_IMPRESS_BONUS, fighter)

				if next(iBuffs) then
					table.insert(result, v)

					break
				end
			end
		end
	end

	return result
end

function GetTarget.S74(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.petChooseEnemys) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				table.insert(result, v)
			end
		end
	end

	return result
end

function GetTarget.S75(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.petChooseFriends) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if isFriend then
				table.insert(result, v)
			end
		end
	end

	return result
end

function GetTarget.S76(fighter, num)
	local result = {}
	local alives = GetTarget.S2(fighter)

	table.sort(alives, function (a, b)
		return b:getAD() < a:getAD()
	end)

	for i = 1, num do
		if alives[i] then
			table.insert(result, alives[i])
		else
			break
		end
	end

	return result
end

function GetTarget.S77(fighter, num)
	local result = {}
	local yujiTableIDs = {
		55004,
		655011,
		755002
	}
	local rebornFighter = xyd.Battle.rebornFighter

	if not rebornFighter then
		return result
	end

	local hero = rebornFighter.hero_

	if not hero then
		return result
	end

	local tableID = hero:getTableID()

	if hero:isMonster() then
		tableID = hero:getPartnerLink()
	end

	local isYuji = xyd.arrayIndexOf(yujiTableIDs, tableID) > 0

	if not tableID or not isYuji then
		return result
	end

	result = GetTarget.S13(rebornFighter)

	return result
end

function GetTarget.S78(fighter, num)
	local result = {}
	local enemyList = {}
	local alives = GetTarget.S13(fighter)

	for i = 1, #alives do
		local enemy = alives[i]

		if enemy then
			local res = enemy:getNewDebuffList({
				1,
				2,
				4
			})
			local dTypeNum = res.dTypeNum
			local debuffList = res.debuffList

			if dTypeNum > 0 then
				table.insert(enemyList, enemy)
			end
		end
	end

	result = xyd.randomSelects(enemyList, num)

	return result
end

function GetTarget.S79(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_SAME_ATK)

				if next(buffs) then
					table.insert(result, v)
				end
			end
		end
	end

	return result
end

function GetTarget.S83(fighter)
	local alive = GetTarget.S13(fighter)
	local fighter_, minRate_ = nil

	for k, v in ipairs(alive) do
		local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW)

		if buffs and next(buffs) then
			local vRate = v:getHp() / v:getHpLimit()

			if not fighter_ or vRate < minRate_ or vRate == minRate_ and v:getHp() < fighter_:getHp() then
				fighter_ = v
				minRate_ = vRate
			end
		end
	end

	return {
		fighter_
	}
end

function GetTarget.S84(fighter)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() then
			local isFriend = v:getTeamType() == fighter:getTeamType()

			if not isFriend then
				local buffs = v:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW, fighter)

				if buffs and next(buffs) then
					table.insert(result, v)
				end
			end
		end
	end

	return result
end

function GetTarget.S85(fighter)
	local result = {}
	local alive = GetTarget.S13(fighter)

	for k, v in ipairs(alive) do
		if not v:isDeath() and not v.isFirstLow50_ and v:getHp() / v:getHpLimit() < 0.5 then
			table.insert(result, v)

			v.isFirstLow50_ = true
		end
	end

	return result
end

function GetTarget.S86(fighter)
	local result = {}
	local alive = GetTarget.S13(fighter)

	for _, v in ipairs(alive) do
		if not v:isDeath() then
			local lockBuffs = v:getBuffsByNameAndFighter(xyd.BUFF_GET_LEAF)

			if next(lockBuffs) then
				table.insert(result, v)

				break
			end
		end
	end

	return result
end

function GetTarget.S87(fighter)
	local result = {}

	if not fighter.selectEnemy or fighter.selectEnemy:isDeath() then
		local alive = GetTarget.S18(fighter, 1)
		result = alive
		fighter.selectEnemy = alive[1]
	else
		table.insert(result, fighter.selectEnemy)
	end

	return result
end

function GetTarget.S88(fighter, num)
	local alive = GetTarget.S2(fighter)

	return GetTarget.getLowHpFighters(alive, num)
end

function GetTarget.S89(fighter)
	local result = {}

	for _, t in ipairs(xyd.Battle.bloodTargets) do
		local isFriend = t:getTeamType() == fighter:getTeamType()

		if not t:isDeath() and not isFriend then
			table.insert(result, t)
		end
	end

	return result
end

function GetTarget.S90(fighter)
	local result = {}
	local selfPos = fighter:getPos()

	if selfPos > 6 then
		selfPos = selfPos - 6
	end

	local alive = GetTarget.S2(fighter)
	local posArr = {}

	for _, t in ipairs(alive) do
		local pos = t:getPos()

		if pos > 6 then
			pos = pos - 6
		end

		posArr[pos] = t
	end

	for i = selfPos + 1, 6 do
		if posArr[i] then
			table.insert(result, posArr[i])

			break
		end
	end

	if not next(result) then
		for i = selfPos - 1, 1, -1 do
			if posArr[i] then
				table.insert(result, posArr[i])

				break
			end
		end
	end

	return result
end

function GetTarget.S91(fighter)
	local res = {}

	for _, v in ipairs(xyd.Battle.preHitTargets) do
		if not v:isDeath() then
			table.insert(res, v)
		end
	end

	return GetTarget.LowestHp(res)
end

function GetTarget.S92(fighter)
	local res = {}

	for _, v in ipairs(xyd.Battle.preHitTargets) do
		if not v:isDeath() and v:getEnergy() < 90 then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S93(fighter)
	local res = {}

	for _, v in ipairs(xyd.Battle.preHitTargets) do
		if not v:isDeath() and v:getEnergy() >= 90 then
			table.insert(res, v)
		end
	end

	return res
end

function GetTarget.S94(fighter)
	local result = {}

	if fighter.killer and not fighter.killer:isDeath() and not fighter.killer:isPet() and not fighter.killer:isGod() and fighter.killer:getTeamType() ~= fighter:getTeamType() then
		result = {
			fighter.killer
		}
	end

	return result
end

function GetTarget.S95(fighter)
	local result = {}
	local selfPos = fighter:getPos()

	if selfPos > 6 then
		selfPos = selfPos - 6
	end

	local alive = GetTarget.S2(fighter)
	local posArr = {}

	for _, t in ipairs(alive) do
		local pos = t:getPos()

		if pos > 6 then
			pos = pos - 6
		end

		posArr[pos] = t
	end

	for i = selfPos - 1, 1, -1 do
		if posArr[i] then
			table.insert(result, posArr[i])

			break
		end
	end

	if not next(result) then
		for i = selfPos + 1, 6 do
			if posArr[i] then
				table.insert(result, posArr[i])

				break
			end
		end
	end

	return result
end

function GetTarget.S96(fighter)
	if #xyd.Battle.dressAttrsA ~= 3 or #xyd.Battle.dressAttrsB ~= 3 then
		return {}
	end

	if xyd.Battle.dressAttrsB[1] < xyd.Battle.dressAttrsA[1] then
		return xyd.Battle.teamA
	elseif xyd.Battle.dressAttrsA[1] < xyd.Battle.dressAttrsB[1] then
		return xyd.Battle.teamB
	end

	return {}
end

function GetTarget.S97(fighter)
	if #xyd.Battle.dressAttrsA ~= 3 or #xyd.Battle.dressAttrsB ~= 3 then
		return {}
	end

	if xyd.Battle.dressAttrsB[2] < xyd.Battle.dressAttrsA[2] then
		return xyd.Battle.teamA
	elseif xyd.Battle.dressAttrsA[2] < xyd.Battle.dressAttrsB[2] then
		return xyd.Battle.teamB
	end

	return {}
end

function GetTarget.S98(fighter)
	if #xyd.Battle.dressAttrsA ~= 3 or #xyd.Battle.dressAttrsB ~= 3 then
		return {}
	end

	if xyd.Battle.dressAttrsB[3] < xyd.Battle.dressAttrsA[3] then
		return xyd.Battle.teamA
	elseif xyd.Battle.dressAttrsA[3] < xyd.Battle.dressAttrsB[3] then
		return xyd.Battle.teamB
	end

	return {}
end

function GetTarget.LowestAndHighest(fighter)
	local result = {}
	local p1 = GetTarget.S14(fighter)[1]
	local p2 = GetTarget.S15(fighter)[1]

	if not p1 then
		return result
	end

	table.insert(result, p1)

	if p1 ~= p2 then
		table.insert(result, p2)
	end

	return result
end

function GetTarget.S99(fighter)
	return GetTarget.LowestAndHighest(fighter)
end

function GetTarget.S100(fighter)
	local result = {}
	local result_ = GetTarget.LowestAndHighest(fighter)

	for k, v in ipairs(result_) do
		if next(v:getBuffsByName(xyd.BUFF_LUBAN_HURT_B)) then
			table.insert(result, v)
		end
	end

	return result
end

function GetTarget.S101(fighter)
	local result = {}
	local result_ = GetTarget.LowestAndHighest(fighter)

	for k, v in ipairs(result_) do
		if next(v:getBuffsByName(xyd.BUFF_LUBAN_HURT_C)) then
			table.insert(result, v)
		end
	end

	return result
end

function GetTarget.S102(fighter)
	local result = {}
	local enemyTargets = GetTarget.S13(fighter)

	table.sort(enemyTargets, function (a, b)
		return b:getAckSpeed() < a:getAckSpeed()
	end)

	if #enemyTargets >= 2 then
		table.insert(result, enemyTargets[2])
	end

	return result
end

function GetTarget.S103(fighter)
	local result = {}
	local enemyTargets = GetTarget.S13(fighter)

	table.sort(enemyTargets, function (a, b)
		return b:getAckSpeed() < a:getAckSpeed()
	end)

	if #enemyTargets >= 3 then
		table.insert(result, enemyTargets[3])
	end

	return result
end

function GetTarget.S104(fighter)
	local lastHero = xyd.Battle.lastJumpTarget

	if lastHero then
		local lastHeroFriends = GetTarget.S11(lastHero)
		local res = xyd.randomSelects(lastHeroFriends, 1)
		xyd.Battle.lastJumpTarget = res[1] or nil

		return res
	end

	return {}
end

function GetTarget.S105(fighter)
	local res = {}

	for _, v in ipairs(xyd.Battle.puGongNormalSkillTargets) do
		if not v:isDeath() then
			local crystallizeBuffs = v:getBuffsByName(xyd.BUFF_CRYSTALLIZE)
			local crystallBuffs = v:getBuffsByName(xyd.BUFF_CRYSTALL)

			if next(crystallizeBuffs) or next(crystallBuffs) then
				table.insert(res, v)
			end
		end
	end

	for _, v in ipairs(xyd.Battle.normalSkillTargets) do
		if not v:isDeath() then
			local crystallizeBuffs = v:getBuffsByName(xyd.BUFF_CRYSTALLIZE)
			local crystallBuffs = v:getBuffsByName(xyd.BUFF_CRYSTALL)

			if next(crystallizeBuffs) or next(crystallBuffs) then
				table.insert(res, v)
			end
		end
	end

	return res
end

function GetTarget.S106(fighter)
	if fighter:isHasDebuff() then
		return {
			fighter
		}
	else
		return {}
	end
end

function GetTarget.S107(fighter)
	if xyd.Battle.god then
		return {
			xyd.Battle.god
		}
	else
		return {}
	end
end

function GetTarget.godInitFighterPos(targetIndex)
	local result = {}

	if targetIndex == xyd.GodInitTarget.TEAM_A then
		result = {
			1,
			2,
			3,
			4,
			5,
			6
		}
	elseif targetIndex == xyd.GodInitTarget.TEAM_B then
		result = {
			7,
			8,
			9,
			10,
			11,
			12
		}
	end

	return result
end

function GetTarget.S108(fighter, num)
	local alives = GetTarget.S13(fighter)
	local lives = {}

	for k, v in ipairs(alives) do
		local marks = v:getBuffsByNameAndFighter(xyd.BUFF_KAWEN_MARK)
		local item = {
			partner = v,
			rate = xyd.getRandom(),
			marks = #marks
		}

		table.insert(lives, v)
	end

	table.sort(lives, function (a, b)
		return a.marks * 10 + a.rate > b.marks * 10 + b.rate
	end)

	local result = {}

	for i = 1, num do
		if lives[i] then
			table.insert(result, lives[i])
		end
	end

	return result
end

function GetTarget.S109(fighter, num)
	local result = {}

	for _, v in ipairs(xyd.Battle.team) do
		if not v:isDeath() and v:getPos() == num then
			table.insert(result, v)
		end
	end

	return result
end

return GetTarget
