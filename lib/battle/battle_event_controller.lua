local modules = {
	"lib.battle.battle_buffs.teleishaSealBuff",
	"lib.battle.battle_buffs.kaixiHurtDmgBuff",
	"lib.battle.battle_buffs.critHalfHpBuff",
	"lib.battle.battle_buffs.fateWheelBuff",
	"lib.battle.battle_buffs.naturalLawBuff",
	"lib.battle.battle_buffs.futureObserveBuff",
	"lib.battle.battle_buffs.dianaDieBuff",
	"lib.battle.battle_buffs.deathMarkBuff"
}
local _M = {
	reg_evt = function (self)
		for _, v in ipairs(modules) do
			local lib = require(v)

			lib:reg_evt()
		end
	end
}

return _M
