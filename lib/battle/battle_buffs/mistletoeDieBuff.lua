local mistletoeDieBuff = class("mistletoeDieBuff", xyd.Battle.getRequire("ReportBuff"))
local EffectTable = xyd.tables.effectTable
local BuffTable = xyd.tables.dBuffTable
local SkillTable = xyd.tables.skillTable

function mistletoeDieBuff:ctor(params)
	mistletoeDieBuff.super.ctor(self, params)
end

function mistletoeDieBuff:setIsHit()
	self:baseSetIsHit()
end

function mistletoeDieBuff:calculateFinalNum(name, num, buffData, forceHurt)
	local finalNum = num
	self.finalNumArray_ = EffectTable:num(self.effectID, true)

	return finalNum
end

function mistletoeDieBuff:excuteBuff(unit, recordBuffs)
	local attacker = self.fighter
	local defender = self.target
	local removeBuffLists = {}
	local buffs = defender:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE, attacker)

	if buffs and next(buffs) then
		for _, buff in ipairs(buffs) do
			buff:writeRecord(self.target, xyd.BUFF_REMOVE)
			table.insert(recordBuffs, buff)
			table.insert(removeBuffLists, buff)
		end
	end

	local nbuffs = defender:getBuffsByNameAndFighter(xyd.BUFF_MISTLETOE_NEW, attacker)

	if nbuffs and next(nbuffs) then
		for _, nbuff in ipairs(nbuffs) do
			nbuff:writeRecord(self.target, xyd.BUFF_REMOVE)
			table.insert(recordBuffs, nbuff)
			table.insert(removeBuffLists, nbuff)
		end
	end

	self.target:removeBuffs(removeBuffLists)
end

return mistletoeDieBuff
