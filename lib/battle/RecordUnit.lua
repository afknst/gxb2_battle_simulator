local RecordUnit = class("RecordUnit")

function RecordUnit:ctor(params)
	self.buffs = {}
	self.fighter = params.fighter
	self.skillID = params.skillID
	self.mainUnit = params.unit
	local round = xyd.Battle.round

	if round == 0 then
		round = 1
	end

	self.round_ = round
	self.unitDatas_ = {}
	self.targetsPos_ = {}
	self.targets2Pos_ = {}
	self.records_ = {}
	self.buffs_ = {}

	self:saveMissBuffs()
end

function RecordUnit:init()
end

function RecordUnit:saveTarget(target, index)
	local targets = self.targetsPos_
	local pos = target:getPos()

	if index ~= 1 then
		targets = self.targets2Pos_
	end

	if xyd.arrayIndexOf(targets, pos) < 0 then
		table.insert(targets, pos)
	end
end

function RecordUnit:getRecords()
	local params = {
		skill_id = self.skillID,
		round = self.round_,
		buffs = self:getBuffsRecord(),
		targets = self:getTargetsRecord(),
		targets_2 = self:getTargets2Record(),
		pos = self.fighter and self.fighter:getPos() or 0,
		eps = self:getEps()
	}

	return params
end

function RecordUnit:getEps()
	local newEps = {}

	if self.eps and self.mainUnit.eps then
		local eps_ = {}

		for k, v in ipairs(self.eps) do
			eps_[v.pos] = v.ep
		end

		for k, v in ipairs(self.mainUnit.eps) do
			eps_[v.pos] = v.ep
		end

		for k, v in pairs(eps_) do
			table.insert(newEps, {
				pos = tonumber(k),
				ep = v
			})
		end
	elseif self.eps then
		newEps = self.eps
	elseif self.mainUnit.eps then
		newEps = self.mainUnit.eps
	end

	if #newEps == 0 then
		return nil
	end

	return newEps
end

function RecordUnit:setUnitEp(pos, energy)
	if not self.eps then
		self.eps = {}
	end

	local hasPos = false

	for k, v in ipairs(self.eps) do
		if pos == v.pos then
			v.ep = energy
			hasPos = true
		end
	end

	if not hasPos then
		table.insert(self.eps, {
			pos = pos,
			ep = energy
		})
	end
end

function RecordUnit:getBuffsRecord()
	return self.buffs_
end

function RecordUnit:saveBuffsRecord(buffs, index)
	if xyd.Battle.isSweep then
		return
	end

	if not buffs or not next(buffs) then
		return
	end

	for i = 1, #buffs do
		local buff = buffs[i]
		local record = buff:getRecord()

		table.insert(self.buffs_, record)
		buff:clearRecord()
		self:saveTarget(buff.target, index or buff.skillIndex)
	end
end

function RecordUnit:saveBuffsRecord2(records, targets)
	if xyd.Battle.isSweep then
		return
	end

	if not records or not next(records) then
		return
	end

	for i = 1, #records do
		local record = records[i]

		table.insert(self.buffs_, record)
	end

	for i = 1, #targets do
		local pos = targets[i]

		if xyd.arrayIndexOf(self.targets2Pos_, pos) < 0 then
			table.insert(self.targets2Pos_, pos)
		end
	end
end

function RecordUnit:getTargetsRecord()
	local params = {}

	for _, pos in pairs(self.targetsPos_) do
		table.insert(params, pos)
	end

	table.sort(params)

	return params
end

function RecordUnit:getTargets2Record()
	local params = {}

	for _, pos in pairs(self.targets2Pos_) do
		table.insert(params, pos)
	end

	table.sort(params)

	return params
end

function RecordUnit:recordBuffs(target, buffs)
	self:saveBuffsRecord(buffs)
end

function RecordUnit:recordPasBuffs(target, buffs)
	self:saveBuffsRecord(buffs, 2)
end

function RecordUnit:getRecordIndex(unit, index)
	if unit == self.mainUnit then
		return index
	end

	return 2
end

function RecordUnit:saveMissBuffs()
	local missBuffs = self.mainUnit:getMissBuffs()

	self:saveBuffsRecord(missBuffs)
end

return RecordUnit
