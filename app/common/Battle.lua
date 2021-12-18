xyd = xyd or {}
xyd.Battle = {
	round = 0,
	teamA = {},
	teamB = {},
	team = {},
	teamPet = {},
	god = nil,
	recordUnits = {},
	fighterQueue = {},
	passiveQueue = {},
	groupBuffA = {},
	groupBuffB = {},
	globalBuff = {},
	ackSpeedFlag = false,
	curRoundFigthers = {},
	maxRound = 15,
	PET_RE_MP = 10,
	PET_ROUND_RE_MP = 20,
	MAX_TEAM_NUM = 12,
	ENERGY_DEFAULT = 100,
	unAuto = false,
	isCure = false,
	isJustCrystal = false,
	shareHarmBuffs = {},
	curRoundDie = {},
	aoeBuffEffect_ = {},
	randomHandler = nil,
	randomSeed = 0,
	effect_battlecover = "difangchuchang",
	effect_switch = "switch",
	recordSkills = {},
	unityPosYFlip = -1,
	curBattleType = -1,
	maxSportMeetingRound = 99,
	lastAttacker = nil,
	getRequire = function (class)
		return import("lib.battle." .. class)
	end,
	requireFighter = function (class)
		if not class then
			return import("lib.battle.ReportBaseFighter")
		end

		return import("lib.battle." .. class)
	end,
	requireBuff = function (buffName)
		if not buffName then
			return import("lib.battle.ReportBuff")
		end

		local className = buffName .. "Buff"

		return import("lib.battle.battle_buffs." .. className)
	end
}
xyd.BattleColor = {
	hurtRedMatrix = Vector4(1, 0.31, 0.31, 1),
	fenshenMatrix = Vector4(0.25, 0.41, 0.88, 1),
	maskColorMatrix = Vector4(0.35, 0.35, 0.35, 1),
	grey = Vector4(0, 0, 0, 1)
}
xyd.SKILL_INDEX = {
	PasSkill2 = 4,
	PasSkill1 = 3,
	Pugong = 1,
	PasSkill3 = 5,
	Energy = 2
}
xyd.BuffType = {
	MISS = 2,
	FREE = 4,
	BLOCK = 5,
	NORMAL = 1,
	CRIT = 3
}
xyd.TargetType = {
	TARGET_SELF = 1,
	TARGET_UNKNOW = 3,
	TARGET_ENEMY = 2
}
xyd.SpecialEffect = {
	NO_TRIGGER_TARGET = -1
}
xyd.GodInitTarget = {
	TEAM_B = 13,
	TEAM_A = 2
}
xyd.TriggerType = {
	SELF_IMPRESSED = 121,
	ROUND_END_USE_DEBUFF_CLEAN = 111,
	ENEMY_ATTACKED_SKILL_H = 40,
	SELF_AFTER_SKILL_2 = 138,
	ROUND_BEGIN_WITH_ARTIFACT = 108,
	ROUND_END_AFTER_3 = 102,
	SELF_TEAM_YX_DEBUFF = 129,
	SELF_ROUND = 1,
	MOONSHADOW_FRIEND_ATTACKED = 95,
	ROUND_AFTER_6 = 29,
	SELF_TEAM_FS_ATTACKED = 82,
	FRIEND_ATTACK = 99,
	BLOCK_THREE_TIMES = 55,
	EVERY_5_ROUND = 135,
	SELF_ATTACKED_WITH_REFLECT = 79,
	FRIEND_BURNT = 59,
	ENEMY_CONTROLED = 71,
	SELF_ATTACKED_AFTER_HP_LESS_50 = 78,
	CRYSTAL_END = 70,
	FRIEND_ATTACK_SHANBI = 18,
	SELF_TEAM_YX_CONTROLLED = 87,
	SELF_DOT = 140,
	SELF_TEAM_YX_ATTACKED = 83,
	ROUND_3_START = 112,
	ROUND_END_WITH_APATE_REVIVE = 109,
	DIE_HIT = 45,
	ENEMY_BLOOD = 130,
	ENEMY_DIE = 27,
	SELF_DIE = 9,
	MOONSHADOW_ROUND_END = 96,
	EAT_ENEMY = 56,
	FRIEND_DIE = 19,
	ENEMY_SHANBI = 25,
	CURE_LATER = 33,
	HURTED_BY_MISTLETOE = 118,
	SELF_HP_LESS_80 = 31,
	SELF_CRIT = 5,
	ROUND_AFTER_4 = 30,
	SELF_ATTACKED_HP_MORE_50 = 50,
	SELF_TEAM_MS_ATTACKED = 85,
	VANITY_TEN_TIMES = 73,
	SELF_ATTACK = 66,
	ENEMY_HP_LESS_30 = 63,
	SELF_ATTACKED = 4,
	ENEMY_ICE = 49,
	ENEMY_DIE_2 = 137,
	ENEMY_ATTACKED = 22,
	ENEMY_HP_LESS_50_FIRST = 119,
	SELF_ATTACK_WITH_CRIT = 76,
	ENEMY_ATTACK_SHANBI = 26,
	NO_FREE_HARM = 139,
	BEFORE_SELF_ENERGY_SKILL = 124,
	STARMOON_SELF_DEBUFF = 98,
	ENEMY_ATTACK_LATER = 32,
	ATTACK_UNDER_MISTLETOE = 116,
	ROUND_END = 42,
	ROUND_BEGIN = 103,
	SELF_UNCONTROL_DEBUFF = 141,
	BEFORE_SELF_ENERGY_SKILL_2 = 143,
	ROUND_BEGIN_AFTER_6 = 145,
	HURTED_BY_LOWER_HP = 146,
	ENEMY_CONTROLED_6 = 147,
	DIE = 43,
	GOD_INIT_FIGHTER_SKILL = 148,
	ENEMY_DIE_HIT = 104,
	SELF_CONTROLED = 44,
	ODD_ROUND = 93,
	ONLY_FRIEND_PUGONG = 149,
	WEIWEAN_ROUND_BEGIN = 97,
	ENEMY_HP_LESS_35 = 64,
	SELF_SKILL = 3,
	ROUND_PASS_4 = 74,
	SELF_TEAM_FS_SKILL = 86,
	GET_SUCK_REAL_BLOOD = 126,
	FRIEND_CRITED = 16,
	ENEMY_CRIT = 23,
	ENEMY_SKILL = 21,
	TEAMA_START_ATTACK = 58,
	SELF_ATTACK_WITH_HARM = 53,
	FIRST_SELF_KILL_ENEMY = 114,
	SELF_PUGONG_BEFORE_ENERGY_CHANGE = 125,
	SELF_ATTACK_AFTER = 133,
	SELF_TEAM_CK_ATTACKED = 84,
	BEFORE_BATTLE_START = 132,
	DOT = 72,
	EVERY_6_ROUND = 136,
	ENEMY_CRYSTAL = 67,
	SELF_HP_LESS_50 = 11,
	FRIEND_SKILL_H = 41,
	ROUND_AFTER_DOT = 57,
	ENEMY_BURNT = 60,
	SELF_AFTER_SKILL = 101,
	SELF_ROUND_REFLECT_ATTACKED = 92,
	EVEN_ROUND = 117,
	FRIEND_CRYSTAL = 69,
	FRIEND_SHANBI = 17,
	SELF_TEAM_ZS_ATTACKED = 81,
	SELF_TEAM_CK_ATTACK = 88,
	FRIEND_PUGONG = 12,
	ENEMY_PUGONG = 20,
	SELF_KILL_ENEMY = 46,
	LIGHT_GET_TWO = 100,
	ROUND_END_BEFORE_DEBUFF_CLEAN = 115,
	SELF_BEFOR_HURTED = 34,
	SELF_HP_LESS_30 = 10,
	ENEMY_STONE = 48,
	SELF_ATTACKED_WITH_THORNS = 105,
	ROUND_END_AFTER_COUNT = 127,
	ENEMY_CRITED = 24,
	EVERY_4_ROUND = 134,
	SELF_HP_LESS_30_UNLIMIT = 122,
	ROUND_BEGIN_AFTER_ONE = 106,
	ROUND_END_AFTER_1 = 120,
	FIRST_TWO_ROUND_END = 94,
	SELF_CRITED = 6,
	STUN = 52,
	FRIEND_SKILL_WITHOUT_SELF_H = 61,
	FENSHEN_CREATE = 37,
	ENEMY_ATTACK_BEFORE = 142,
	SELF_CRIT_FIRST_TWO_ROUND = 144,
	SELF_ATTACKED_HP_LESS_50 = 51,
	FRIEND_ATTACKED_SKILL_H = 39,
	SELF_ATTACKED_SKILL_H = 38,
	XIFENG_HP_LESS_50 = 110,
	SELF_TEAM_CK_ATTACK_FIRST_TIME = 90,
	CRYSTALL_MARK_END = 68,
	SELF_PUGONG = 2,
	ROUND_BEGIN_AFTER_3 = 113,
	AFTER_REBORN = 107,
	SELF_BLOCK = 47,
	SELF_REMOVE_BUFF_RESET = 91,
	ENERGY_SKILL_HOLD = 123,
	SELF_ATTACK_SHANBI = 8,
	ENEMY_HP_LESS_25 = 62,
	BATTLE_START = 35,
	BATTLE_START_WITHOUT_PASSKILL = 80,
	HURTED = 128,
	SELF_TEAM_YX_PUGONG = 89,
	FRIEND_ATTACKED = 14,
	SELF_ATTACK_WITHOUT_CRIT = 75,
	SELF_SHANBI = 7,
	FRIEND_SKILL = 13,
	ROUND_SKILL = 54,
	SELF_ATTACKED_AFTER_HP_MORE_50 = 77,
	ENEMY_FRIGHTEN = 65,
	FRIEND_CRIT = 15,
	TOTAL_ATTACK_NUM_TEN = 131,
	MASTER_ATTACK = 36,
	FOREVER = 28
}
xyd.PurposeType = {
	BLOOD_POSION_FIRE = 12,
	CONTROL_TIMES = 15,
	SELF_ONE_HERO_HURTED = 13
}
xyd.HeroJob = {
	MS = 5,
	FS = 2,
	YX = 3,
	CK = 4,
	ZS = 1
}
xyd.HeroJobStr = {
	"ZS",
	"FS",
	"YX",
	"CK",
	"MS"
}
xyd.ReportBattleType = {
	OLD_BUILDING = 15,
	TEST = 49,
	LIMIT_GACHA_BOSS = 16,
	DUNGEON = 4,
	PARTNER_CHALLENGE_SPEED = 10,
	ARENA_TEAM = 17,
	ARENA_NORMAL = 18,
	ARENA_CHOSEN_BET = 20,
	SKY_ISLAND = 24,
	TIME_CLOISTER = 23,
	FAIRY_TALE = 12,
	GUILD_WAR = 21,
	SPORTS_MEETING = 13,
	GOVERN_TEAM = 7,
	ICE_SECRET_BOSS = 14,
	GUILD_BOSS = 5,
	MONTHLY_HIKE = 22,
	NORMAL = 1,
	ARENA_ALL_SERVER = 8,
	TRAIL = 2,
	ARENA_TOP = 19,
	TRIAL_NEW = 9,
	FRIEND_BOSS = 3,
	HERO_CHALLENGE = 6,
	RICHMAN = 11
}
xyd.BaseFightLayerType = {
	BOTTOM = 2,
	TOP = 1,
	BUFF_TOP = 3,
	BUFF_BOT = 4
}
xyd.HeroBattlePos = {
	{
		x = 330,
		y = 1290
	},
	{
		x = 330,
		y = 960
	},
	{
		x = 200,
		y = 1636
	},
	{
		x = 130,
		y = 1370
	},
	{
		x = 130,
		y = 880
	},
	{
		x = 200,
		y = 616
	},
	{
		x = 750,
		y = 1290
	},
	{
		x = 750,
		y = 960
	},
	{
		x = 880,
		y = 1636
	},
	{
		x = 950,
		y = 1370
	},
	{
		x = 950,
		y = 880
	},
	{
		x = 880,
		y = 616
	}
}
xyd.HeroBattlePosScale = {
	0.98,
	0.94,
	1.05,
	1,
	0.93,
	0.9,
	0.98,
	0.94,
	1.05,
	1,
	0.93,
	0.9
}
xyd.UNIT_ZORDERS = {
	20,
	15,
	30,
	25,
	10,
	0
}
xyd.MODEL_ATK_BASE = 30
xyd.BULLET_DURATION = 0.2
xyd.BASIC_BATTLE_SPEED = 1.1
xyd.DOUBLE_BATTLE_SPEED = 1.8
xyd.QUADRUPLE_BATTLE_SPEED = 2.5
xyd.TEAM_B_POS_BASIC = 6
xyd.DEFAULT_FRONT_NUM = 2
xyd.DEFAULT_BACK_NUM = 4
xyd.PUGONG_RE_MP = 50
xyd.HARM_RE_MP = 10
xyd.HARM_CRIT_MP = 20
xyd.MAX_TEAM_NUM = 12
xyd.PET_RE_MP = 10
xyd.PET_ROUND_RE_MP = 20
xyd.ENERGY_DEFAULT = 100
xyd.PERCENT_BASE = 100
xyd.NDSV_SKILL_TARGET = 34
xyd.BUFF_ON_WORK = 0
xyd.BUFF_ON = 1
xyd.BUFF_WORK = 2
xyd.BUFF_OFF = 3
xyd.BUFF_REMOVE = 4
xyd.COVER_TYPE_NO = 0
xyd.COVER_TYPE_VALUE = 1
xyd.COVER_TYPE_ROUND = 2
xyd.BUFF_ATK = "atk"
xyd.BUFF_HP = "hp"
xyd.BUFF_ARM = "arm"
xyd.BUFF_SPD = "spd"
xyd.BUFF_SKL_P = "sklP"
xyd.BUFF_HIT = "hit"
xyd.BUFF_MISS = "miss"
xyd.BUFF_CRIT = "crit"
xyd.BUFF_CRIT_TIME = "critTime"
xyd.BUFF_BRK = "brk"
xyd.BUFF_FREE = "free"
xyd.BUFF_UNFREE = "unfree"
xyd.BUFF_TRUE_ATK = "trueAtk"
xyd.BUFF_ENERGY = "energy"
xyd.BUFF_DEC_DMG = "decDmg"
xyd.BUFF_STUN = "stun"
xyd.BUFF_ICE = "ice"
xyd.BUFF_STONE = "stone"
xyd.BUFF_FORBID = "forbid"
xyd.BUFF_REVIVE = "revive"
xyd.BUFF_REVIVE_INF = "reviveINF"
xyd.BUFF_REVIVE_INF_BUFF = "reviveINFbuff"
xyd.BUFF_REVIVE_INF_NUM = "reviveINFnum"
xyd.BUFF_HURT = "hurt"
xyd.BUFF_DOT = "dot"
xyd.BUFF_HEAL = "heal"
xyd.BUFF_HEAL_ATKP = "healAtkP"
xyd.BUFF_HOT = "hot"
xyd.BUFF_HEAL_P = "healP"
xyd.BUFF_TRUE_HURT = "trueHurt"
xyd.BUFF_REAL_HURT = "realHurt"
xyd.BUFF_SIPHON_ATK = "siphonAtk"
xyd.BUFF_SIPHON_HP = "siphonHp"
xyd.BUFF_SIPHON_ARM = "siphonArm"
xyd.BUFF_BRIER = "brier"
xyd.BUFF_DOT_FIRE = "dotFire"
xyd.BUFF_DOT_POISON = "dotPoison"
xyd.BUFF_DOT_BLOOD = "dotBlood"
xyd.BUFF_ATK_P = "atkP"
xyd.BUFF_HP_P = "hpP"
xyd.BUFF_ARM_P = "armP"
xyd.BUFF_ADD_HURT = "addHurt"
xyd.BUFF_ZSHPPO = "zsHpPO"
xyd.BUFF_FSHPPO = "fsHpPO"
xyd.BUFF_YXHPPO = "yxHpPO"
xyd.BUFF_CKHPPO = "ckHpPO"
xyd.BUFF_MSHPPO = "msHpPO"
xyd.BUFF_RIMPRESS = "rImpress"
xyd.BUFF_CIMPRESS = "cImpress"
xyd.BUFF_FIMPRESS = "fImpress"
xyd.BUFF_OIMPRESS = "oImpress"
xyd.BUFF_ADD_HURTD = "addHurtd"
xyd.BUFF_M_HURT = "mhurt"
xyd.BUFF_M_DOT_FIRE = "mdotFire"
xyd.BUFF_M_DOT_POISON = "mdotPoison"
xyd.BUFF_M_DOT_BLOOD = "mdotBlood"
xyd.BUFF_WEAK = "weak"
xyd.BUFF_RD_DOT = "rddot"
xyd.BUFF_RD_CONTROL = "rdcontrol"
xyd.BUFF_HURT_MAX_M = "hurtmaxM"
xyd.BUFF_HURT_MAX_H = "hurtmaxH"
xyd.BUFF_HEAL_B = "healB"
xyd.BUFF_HEAL_I = "healI"
xyd.BUFF_HURT_SHARE = "hurtshare"
xyd.BUFF_EX_HURT = "exhurt"
xyd.BUFF_HURT_B = "hurtB"
xyd.BUFF_OVER_FLOW = "overflow"
xyd.BUFF_SHIELD = "shield"
xyd.BUFF_NEW_ROUND = "newRound"
xyd.BUFF_EXLODED = "buffExloded"
xyd.BUFF_MIND_CONTROL = "mindControl"
xyd.BUFF_TRANSFORM_BK = "transformBK"
xyd.BUFF_ATK_P_BK = "atkPBK"
xyd.BUFF_BRK_BK = "brkBK"
xyd.BUFF_CRIT_DEF = "critDef"
xyd.BUFF_DEBUFF_CLEAN = "debuffClean"
xyd.BUFF_SUR_ATK_P = "surAtkP"
xyd.BUFF_HURTL_HURT_P = "hurtLhurtP"
xyd.BUFF_HEAL_PLOSE = "healPlose"
xyd.BUFF_ROW_F_ARM_P = "rowFArmP"
xyd.BUFF_ROW_F_STONE = "rowFStone"
xyd.BUFF_ROW_B_ATK_P = "rowBAtkP"
xyd.BUFF_ROW_B_SPD = "rowBSpd"
xyd.BUFF_DOT_TWINS = "dotTwins"
xyd.BUFF_HOT_HUATUO = "hotHuatuo"
xyd.BUFF_DOT_FIRE_MAX_HP = "dotFireMaxHp"
xyd.BUFF_FREE_HARM = "free_harm"
xyd.BUFF_AGGRESSION = "aggression"
xyd.BUFF_AGGRESSION_HARM = "aggressionHarm"
xyd.BUFF_ATK_UNABLE = "atkUnable"
xyd.BUFF_STUN_SOBER = "stunSober"
xyd.BUFF_CRIT_STUN = "critStun"
xyd.BUFF_HURT_MAX_H_LIMIT15 = "hurtmaxHLimit15"
xyd.BUFF_HURT_MAX_H_LIMIT25 = "hurtmaxHLimit25"
xyd.BUFF_DOT_FIRE_HEAL_P = "dotFirehealP"
xyd.BUFF_HURT_MAX_H_LIMIT = "hurtmaxHLimit"
xyd.BUFF_HURT_FOR_ENERGY = "hurt4Energy"
xyd.BUFF_FREE_SKILL = "freeSkill"
xyd.BUFF_SIPHON = "siphon"
xyd.BUFF_ROW_B_CRIT = "critRowB"
xyd.BUFF_CONTROL_REMOVE = "controlRemove"
xyd.BUFF_DEBUFF_TRANS_ALL = "debuffTransAll"
xyd.BUFF_ATK_D = "atkd"
xyd.BUFF_EAT = "eat"
xyd.BUFF_EAT_FREEHARM = "eatFreeHarm"
xyd.BUFF_HIT_STUN = "hitStun"
xyd.BUFF_HIT_ICE = "hitIce"
xyd.BUFF_HIT_STONE = "hitStone"
xyd.BUFF_EXCEPT_DOT_SHIELD = "exceptdotShield"
xyd.BUFF_EXCEPT_DOT_SHIELD_REMOVE = "exceptdotShieldRemove"
xyd.BUFF_FIRE_EXPLOADED = "fireExploded"
xyd.BUFF_N_DOT_FIRE = "ndotFire"
xyd.BUFF_FIRELESS = "fireless"
xyd.BUFF_FIRE_DEC_DMG = "fireDecDmg"
xyd.BUFF_DEC_FIRE = "decFire"
xyd.BUFF_ADD_FIRE = "addFire"
xyd.BUFF_FRIGHTEN = "frighten"
xyd.BUFF_HURT_DMG_H_LIMIT15 = "hurtDmgHLimit15"
xyd.BUFF_PHURT_SKILL_L_B = "phurtSkillLB"
xyd.BUFF_PHURT_PAS_L_B = "phurtPasLB"
xyd.BUFF_MARK_HURT_PAS_L_B = "markHurtPasLB"
xyd.BUFF_MARK_HURT_SKILL_L_B = "markHurtSkillLB"
xyd.BUFF_HURT_NOW_H_LIMIT15 = "hurtNowHLimit15"
xyd.BUFF_DEC_DMG_SHIELD_LIMIT5 = "decDmgShieldLimit5"
xyd.BUFF_FREE_SHIELD_LIMIT5 = "freeShieldLimit5"
xyd.BUFF_HURT_FREE_ARM = "hurtFreeArm"
xyd.BUFF_BIMPRESS_LIMIT30 = "balanceImpressLimit30"
xyd.BUFF_HURT_ATK = "hurtAtk"
xyd.BUFF_HURT_0 = "hurt0"
xyd.BUFF_CRYSTALLIZE = "crystallize"
xyd.BUFF_MARK_CRYSTAL = "markCrystal"
xyd.BUFF_CRYSTALL = "crystal"
xyd.BUFF_TEAR_LIMIT2 = "tearLimit2"
xyd.BUFF_MISS_LIMIT2 = "missLimit2"
xyd.BUFF_HURT_MAX_H_LIMIT15_BLOOD = "hurtmaxHLimit15Blood"
xyd.BUFF_BLOODLESS = "bloodless"
xyd.BUFF_HURT_MAX_H_LIMIT15_TEAR = "hurtmaxHLimit15Tear"
xyd.BUFF_CRIT_N_TEAR = "critNtear"
xyd.BUFF_DEC_DMG_BLOOD = "decDmgBlood"
xyd.BUFF_CRIT_TIME_BLOOD = "critTimeBlood"
xyd.BUFF_X_TIME_SHIELD = "xtimeShield"
xyd.BUFF_ATK_DEBUFF = "atkdebuff"
xyd.BUFF_EXILE = "exile"
xyd.BUFF_VANITY = "vanity"
xyd.BUFF_CRIT_TIME_LIMIT = "critLimit"
xyd.BUFF_DOT_B = "dotB"
xyd.BUFF_DEC_DMG_N_ADD = "decDmgNadd"
xyd.BUFF_AMP_HURT = "ampHurt"
xyd.BUFF_HURT_MAX_HP = "hurtMaxHp"
xyd.BUFF_CRIT_SIPHON = "critSiphon"
xyd.BUFF_IMMENU = "getImmenu"
xyd.BUFF_GET_REFLECT = "getReflect"
xyd.BUFF_REFLECT = "Reflect"
xyd.BUFF_CRIT_HURT = "critHurt"
xyd.BUFF_REDUCE_DOT = "reduceDot"
xyd.BUFF_HALF_HP_ARM = "halfHpArm"
xyd.BUFF_HALF_HP_DMG = "halfHpDmg"
xyd.BUFF_HALF_HP_DEC_P = "halfHpDecP"
xyd.BUFF_ALL_DMG_B = "allDmgB"
xyd.BUFF_ALL_DMG_B_LIMIT30 = "allDmgBLimit30"
xyd.BUFF_ROUND_DMG_B = "roundDmgB"
xyd.BUFF_DEC_DMG_SHIELD_LIMIT8 = "decDmgShieldmax8"
xyd.BUFF_HURT_SHIELD_LIMIT1 = "hurtShieldmax1"
xyd.BUFF_HURT_SHIELD_LIMIT2 = "hurtShieldmax2"
xyd.BUFF_HURT_SHIELD_LIMIT3 = "hurtShieldmax3"
xyd.BUFF_FREE_LIMIT1 = "freemax1"
xyd.BUFF_YX_CONTROL_REMOVE = "yxControlRemove"
xyd.BUFF_HURT_DEBUFF_REMOVE = "xhurtDebuffRemove"
xyd.BUFF_ATK_P_LIMIT3 = "atkPmax3"
xyd.BUFF_HEAL_B_LIMIT1 = "healBmax1"
xyd.BUFF_CRIT_TIME_LIMIT3 = "CritTimemax3"
xyd.BUFF_DEC_HURT = "decHurt"
xyd.BUFF_DEC_HURT_NUM = "decHurtNum"
xyd.BUFF_SUPER_DEC_HURT = "superDecHurt"
xyd.BUFF_ROUND_REFLECT = "roundReflect"
xyd.BUFF_ROUND_REFLECT_HURT = "roundReflectHurt"
xyd.BUFF_NO_HARM = "noHarm"
xyd.BUFF_NO_DEBUFF = "noDebuff"
xyd.BUFF_DEC_HP_LIMIT = "decHpLimit"
xyd.BUFF_UNCRIT = "unCrit"
xyd.BUFF_FORBID_NO_CLEAN = "forbidUnableClean"
xyd.BUFF_REVIVE_FIRST_TWO_ENEMY = "revive2nd"
xyd.BUFF_SEAL = "seal"
xyd.BUFF_INJURED = "beInjured"
xyd.BUFF_HURT_MAX_HP_LIMIT = "hurtMaxHpLimit"
xyd.BUFF_HURT_MAX_HP_LIMIT_B = "hurtMaxHpLimitB"
xyd.BUFF_CX_XL_DEC_HP_LIMIT = "decHpLimitCxXl"
xyd.BUFF_BASE_4_ALL_DMG_B = "allDmgB4BaseGroup"
xyd.BUFF_DEC_HURT_LESS = "decHurtless"
xyd.BUFF_MOON_SHADOW = "moonShadow"
xyd.BUFF_DEBUFF_CLEAN_2_LIMIT = "debuffClean2Limit"
xyd.BUFF_CLEAR = "buffClear"
xyd.BUFF_STAR_MOON = "starMoon"
xyd.BUFF_HURT_BY_RECEIVE = "hurtByReceive"
xyd.BUFF_DEBUFF_SAME = "debuffSame"
xyd.BUFF_WEI_WEI_AN_HEAL = "weiweianHeal"
xyd.BUFF_FRAGRANCE_GET = "fragranceGet"
xyd.BUFF_FRAGRANCE_ATK = "fragranceAtk"
xyd.BUFF_FRAGRANCE_DEC_DMG = "fragranceDecDmg"
xyd.BUFF_MARK_FRIEND_HURT_LB = "markFriendHurtLB"
xyd.BUFF_BOSS_ATK_P = "bossAtkP"
xyd.BUFF_ALL_HARM_DEC = "allHarmDec"
xyd.BUFF_GET_ABSORB_SHIELD = "getAbsorbShield"
xyd.BUFF_ABSORB_SHIELD = "AbsorbShield"
xyd.BUFF_GET_HEAL_CURSE = "getHealCurse"
xyd.BUFF_HEAL_CURSE = "HealCurse"
xyd.BUFF_CONTROL_REDUCE = "controlReduce"
xyd.BUFF_GET_LIGHT = "getLight"
xyd.BUFF_ATK_RANDOM_TIME = "AtkRandomTime"
xyd.BUFF_ADD_GET_LIGHT = "addGetLight"
xyd.BUFF_ADD_HURT_FREE_ARM = "addHurtFreeArm"
xyd.BUFF_MARK_ADD_HURT_FREE_ARM = "markAddHurtFreeArm"
xyd.BUFF_MARK_ADD_HURT = "markAddHurt"
xyd.BUFF_WULIEER_SEAL = "wulieerSeal"
xyd.BUFF_FREE_DEC_CHANGE = "freeDecChange"
xyd.BUFF_HIT_ENERGY_CHANGE = "hitEnergyChange"
xyd.BUFF_BOSS_STORM = "bossStorm"
xyd.BUFF_HP_LOSE_SEAL = "hpLoseSeal"
xyd.BUFF_ENERGY_STEAL = "energySteal"
xyd.BUFF_GET_LEAF = "getLeaf"
xyd.BUFF_GET_THORNS = "getThorns"
xyd.BUFF_EXCHANGE_SPD = "exchangeSpd"
xyd.BUFF_ALL_HARM_SHARE = "allHarmShare"
xyd.BUFF_DEBUFF_TRANS_ONE = "debuffTransOne"
xyd.BUFF_FORCE_SEAL = "forceSeal"
xyd.BUFF_TARGET_CHANGE = "targetChange"
xyd.BUFF_ENERGY_HURT = "energyHurt"
xyd.BUFF_CLEAR_ENERGY = "clearEnergy"
xyd.BUFF_FULL_ENERGY_HURT = "fullEnergyHurt"
xyd.BUFF_AVOID_HURT = "avoidHurt"
xyd.BUFF_APATE_REVIVE = "apateRevive"
xyd.BUFF_MARK_APATE = "markApate"
xyd.BUFF_APATE_HURT = "apateHurt"
xyd.BUFF_APATE_ENERGY_HURT = "apateEnergyHurt"
xyd.BUFF_REDUCE_SPD = "ReduceSpd"
xyd.BUFF_REDUCE_SPD_HEAL = "reduceSpdHeal"
xyd.BUFF_REDUCE_SPD_HEAL_RECORD = "reduceSpdHealRecord"
xyd.BUFF_ENEMY_DEAD_HEAL = "enemyDealHeal"
xyd.BUFF_SPD_GAP_HURT = "spdGapHurt"
xyd.BUFF_SPD_STEAL = "spdSteal"
xyd.BUFF_ABSORB_DAMAGE = "absorbDamage"
xyd.BUFF_XIFENG_SPD = "xifengSpd"
xyd.BUFF_ADD_HP_LIMIT = "addHpLimit"
xyd.BUFF_RIDICULE = "ridicule"
xyd.BUFF_OUT_BREAK = "outBreak"
xyd.BUFF_CONTROL_REMOVE_YUNMU = "controlRemoveYumu"
xyd.BUFF_YUNMU_DIE = "yunmuDie"
xyd.BUFF_POISON_STUN = "poisonStun"
xyd.BUFF_COMMON_EXHURT = "commonExHurt"
xyd.BUFF_ABSORB_FIX_DAMAGE = "absorbFixDamage"
xyd.BUFF_LOCK_TARGET = "lockTarget"
xyd.BUFF_FANHEXING_DIE1 = "fanhexingDie1"
xyd.BUFF_ATK_IMPRESS_BONUS = "atkImpressBonus"
xyd.BUFF_FANHEXING_DIE2 = "fanhexingDie2"
xyd.BUFF_DIE_ATK_IMPRESS = "dieAtkImpress"
xyd.BUFF_SUCK_REAL_BLOOD_GET = "suckRealBloodGet"
xyd.BUFF_SUCK_REAL_BLOOD = "suckRealBlood"
xyd.BUFF_CLEAN_WITHOUT_DOT = "cleanWithoutDot"
xyd.BUFF_TRUE_VAMPIRE = "trueVampire"
xyd.BUFF_PET_DMG_B = "petDmgB"
xyd.BUFF_DEC_DMG_FREE = "decDmgFree"
xyd.BUFF_PET_CONTROL_FREE = "petControlFree"
xyd.BUFF_PET_CONTORL_INCREASE = "petControlIncrease"
xyd.BUFF_RIMPRESS_HP_LIMIT = "rImpressHpLimit"
xyd.BUFF_RIMPRESS_HURT_PLUS = "rImpressHurtPlus"
xyd.BUFF_RIMPRESS_TREATMENT_BLOCK = "rImpressTreatmentBlock"
xyd.BUFF_YUJI_UNLIMITED_REVIVE = "yujiUnlimitedRevive"
xyd.BUFF_DEBUFF_HURT = "debuffHurt"
xyd.BUFF_DEBUFF_ADD_COUNT = "debuffAddCount"
xyd.BUFF_DEBUFF_COPY = "debuffCopy"
xyd.BUFF_SAME_ATK = "sameAtk"
xyd.BUFF_SAME_ATK_HURT = "sameAtkHurt"
xyd.BUFF_SAME_ATK_SEEK = "sameAtkSeek"
xyd.BUFF_ATK_DOT_POISON = "atkDotPoison"
xyd.BUFF_ATK_DOT_BLOOD = "atkDotBlood"
xyd.BUFF_ATK_DOT = "atkDot"
xyd.BUFF_MISTLETOE = "mistletoe"
xyd.BUFF_MISTLETOE_NEW = "mistletoeNew"
xyd.BUFF_HURTED_BY_MISTLETOE = "hurtedByMistletoe"
xyd.BUFF_LOW_HP_TARGET = "lowHpTarget"
xyd.BUFF_MISTLETOE_DIE = "mistletoeDie"
xyd.BUFF_NO_CRIT = "noCrit"
xyd.BUFF_GOD_CONTROL_ENERGY = "godControlEnergy"
xyd.BUFF_INVISIBLE = "invisible"
xyd.BUFF_HEAL_CURSE_CLEAN_HURT = "healCurseCleanHurt"
xyd.BUFF_TELEISHA_SEAL = "teleishaSeal"
xyd.BUFF_TELEISHA_RECOVER_CONTROL = "teleishaRecoverControl"
xyd.BUFF_TELEISHA_RECOVER_IMPRESS = "teleishaRecoverImpress"
xyd.BUFF_TELEISHA_CHANGE_HP = "teleishaChangeHp"
xyd.BUFF_TELEISHA_RECOVER_COST = "teleishaRecoverCost"
xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY = "teleishaChangeHpDisplay"
xyd.BUFF_TELEISHA_CHANGE_HP_DISPLAY_SELF = "teleishaChangeHpDisplaySelf"
xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY = "teleishaRecoverControlDisplay"
xyd.BUFF_TELEISHA_RECOVER_CONTROL_DISPLAY_SELF = "teleishaRecoverControlDisplaySelf"
xyd.BUFF_FEISINA_EXPLODE = "feisinaExplode"
xyd.BUFF_FEISINA_WEAK = "feisinaWeak"
xyd.BUFF_FEISINA_MISS = "feisinaMiss"
xyd.BUFF_ENERGY_SKILL_HOLD = "energySkillHold"
xyd.BUFF_ENERGY_SKILL_LIMIT = "energySkillLimit"
xyd.BUFF_SUN_ARROW = "sunArrow"
xyd.BUFF_SUN_ARROW_SHOOT = "sunArrowShoot"
xyd.BUFF_IMPRESS_CLEAN = "impressClean"
xyd.BUFF_CONTROL_CLEAN = "controlClean"
xyd.BUFF_ALL_TARGET_CHANGE = "allTargetChange"
xyd.BUFF_MISTLETOE_MAX_HP_LIMIT = "mistletoeMaxHpLimit"
xyd.BUFF_MAX_ATK_HURT = "maxAtkHurt"
xyd.BUFF_NATURAL_LAW = "naturalLaw"
xyd.BUFF_NATURAL_LAW_CLEAN = "naturalLawClean"
xyd.BUFF_NATURAL_LAW_HEAL = "naturalLawHeal"
xyd.BUFF_FUTURE_OBSERVE = "futureObserve"
xyd.BUFF_ROUND_FREE_HARM = "roundFreeHarm"
xyd.BUFF_FATE_WHEEL = "fateWheel"
xyd.BUFF_TIME_RULE = "timeRule"
xyd.BUFF_CRIT_HALF_HP = "critHalfHp"
xyd.BUFF_KAIXI_HURT_DMG = "kaixiHurtDmg"
xyd.BUFF_NUOLISI_ADD_RATE = "nuolisiAddRate"
xyd.BUFF_TOTAL_HARM_SIPHON = "totalHarmSiphon"
xyd.BUFF_MAGIC_SHOOT = "magicShoot"
xyd.BUFF_ALL_DMG_C = "allDmgC"
xyd.BUFF_ALL_DMG_C_40 = "allDmgC40"
xyd.BUFF_ALL_HARM_DEC_ChANGE = "allHarmDecChange"
xyd.BUFF_EXCHANGE_ATK = "exchangeAtk"
xyd.BUFF_FUTURE_OBSERVE_PARAMS = "futureObserveParams"
xyd.BUFF_DIANA_DIE = "dianaDie"
xyd.BUFF_DIANA_DIE_EFFECT = "dianaDieEffect"
xyd.BUFF_X_CAN_SKILL = "xCanSkill"
xyd.BUFF_ENEMY_STEAL_ATK = "enemyStealAtk"
xyd.BUFF_HP_PERCENT_ATK = "hpPercentAtk"
xyd.BUFF_LUBAN_HURT_B = "lubanHurtB"
xyd.BUFF_LUBAN_HURT_C = "lubanHurtC"
xyd.BUFF_FIRST_CONTROL_FREE = "firstControlFree"
xyd.BUFF_ENERGY_RESIST = "energyResist"
xyd.BUFF_COPY_UNCONTROL = "copyUncontrol"
xyd.BUFF_LUOBI_MARK = "luobiMark"
xyd.BUFF_LUOBI_HP = "luobiHp"
xyd.BUFF_LUOBI_PRE_COMBOL = "luobiPreCombol"
xyd.BUFF_DEATH_MARK = "deathMark"
xyd.BUFF_DOT_FIRE_RATE = "dotFireRate"
xyd.BUFF_CRIT_ADD_CRIT_TIME = "critAddCritTime"
xyd.BUFF_COST_CURRENT_HP = "costCurrentHp"
xyd.BUFF_UNFREE_RECIEVE = "unfreeRecieve"
xyd.BUFF_KAWEN_MARK = "kawenMark"
xyd.BUFF_HURT_ALL_LEVEL = "hurtAllLevel"
xyd.BUFF_MAYA_BUFF_RESIST = "mayaBuffResist"
xyd.BUFF_MAYA_HP_LOSE_SEAL = "mayaHpLoseSeal"
xyd.BUFF_MAYA_HP_LOSE_SEAL_FX = "mayaHpLoseSealFx"
xyd.BUFF_KAWEN_COUNT_MARK_F5 = "kawenCountMarkF5"
xyd.BUFF_KAWEN_COUNT_MARK_F1 = "kawenCountMarkF1"
xyd.BATTLE_EVENT_NORMAL_OR_SKILL_ATTACKED = "battle_event_normal_or_skill_attacked"
xyd.BATTLE_EVENT_HURTED = "battle_event_hurted"
xyd.BATTLE_EVENT_UNIT_FINISH = "battle_event_unit_finish"
xyd.BATTLE_EVENT_PRE_FREE_HARM = "battle_event_pre_free_harm"
xyd.BATTLE_EVENT_HEAL = "battle_event_heal"
xyd.BATTLE_EVENT_DIE = "battle_event_die"
xyd.jobBuff = {
	yx = "yx",
	ck = "ck",
	resist_yx = "resist_yx",
	resist_ck = "resist_ck",
	fs = "fs",
	zs = "zs",
	ms = "ms",
	resist_ms = "resist_ms",
	resist_zs = "resist_zs",
	resist_fs = "resist_fs",
	zsHpPO = xyd.BUFF_HP_P,
	zsAtkPO = xyd.BUFF_ATK_P,
	zsCritO = xyd.BUFF_CRIT,
	zsMissO = xyd.BUFF_MISS,
	zsSklPO = xyd.BUFF_SKL_P,
	zsSpdO = xyd.BUFF_SPD,
	fsHpPO = xyd.BUFF_HP_P,
	fsAtkPO = xyd.BUFF_ATK_P,
	fsCritO = xyd.BUFF_CRIT,
	fsHitO = xyd.BUFF_HIT,
	fsSklPO = xyd.BUFF_SKL_P,
	fsSpdO = xyd.BUFF_SPD,
	ckHpPO = xyd.BUFF_HP_P,
	ckCritTimeO = xyd.BUFF_CRIT_TIME,
	ckCritO = xyd.BUFF_CRIT,
	ckBrkO = xyd.BUFF_BRK,
	ckSklPO = xyd.BUFF_SKL_P,
	ckSpdO = xyd.BUFF_SPD,
	ckAtkPO = xyd.BUFF_ATK_P,
	yxHpPO = xyd.BUFF_HP_P,
	yxAtkPO = xyd.BUFF_ATK_P,
	yxMissO = xyd.BUFF_MISS,
	yxHitO = xyd.BUFF_HIT,
	yxSklPO = xyd.BUFF_SKL_P,
	yxSpdO = xyd.BUFF_SPD,
	msHpPO = xyd.BUFF_HP_P,
	msMissO = xyd.BUFF_MISS,
	msCritO = xyd.BUFF_CRIT,
	msSpdO = xyd.BUFF_SPD,
	msSklPO = xyd.BUFF_SKL_P,
	msAtkPO = xyd.BUFF_ATK_P
}

function xyd.getRandom()
	xyd.Battle.randomSeed = (xyd.Battle.randomSeed * 9301 + 49297) % 233280

	if xyd.Battle.has_random and xyd.Battle.has_random == 1 then
		local traceArr = xyd.split(debug.traceback(), "\n")
		local recordItem = {
			num = xyd.Battle.randomSeed,
			round = xyd.Battle.round,
			from = {}
		}

		for i = 4, 6 do
			if traceArr[i] then
				local funItem = {}
				local arr1 = xyd.split(traceArr[i], ": in function ")
				funItem.func = string.sub(arr1[2], 2, -2)
				local arr2 = xyd.split(arr1[1], ":")
				local arr3 = xyd.split(arr2[1], "/")
				funItem.file = arr3[#arr3]
				funItem.line = arr2[2]
				local str = funItem.file .. "," .. funItem.func .. "," .. (funItem.line or 0)

				table.insert(recordItem.from, str)
			end
		end

		table.insert(xyd.Battle.randomUseData, recordItem)
	end

	return xyd.Battle.randomSeed / 233280
end

function xyd.weightedChoise(weights)
	local total = 0

	for i = 1, #weights do
		total = total + weights[i]
	end

	local rand = xyd.getRandom() * total

	for i = 1, #weights do
		rand = rand - weights[i]

		if rand < 0 then
			return i
		end
	end

	return #weights
end

function xyd.randomSelects(all, num)
	if not all or #all < 1 then
		return {}
	end

	num = num or 1

	if num >= #all then
		return all
	end

	local curSelect = {}
	local selects = {}
	local arrLen = #all

	for i = 1, num do
		while true do
			local index = math.floor(xyd.getRandom() * arrLen) + 1

			if not curSelect[index] then
				curSelect[index] = true

				table.insert(selects, all[index])

				break
			end
		end
	end

	return selects
end

function xyd.getBattleNum(data)
	if type(data) == "number" then
		return data
	end

	return tonumber(data)
end

function xyd.copyBuff(buff, target, fighter, prob)
	local BuffManager = xyd.Battle.getRequire("BuffManager")
	local params = {
		effectID = buff.effectID,
		fighter = fighter,
		target = target,
		skillID = buff.skillID,
		index = buff.skillIndex
	}
	local newBuff = BuffManager:newBuff(params)

	newBuff:baseSetIsHit(prob)

	newBuff.finalNum_ = buff.finalNum_

	newBuff:changeBuffName()

	local tmpArray = {}

	for i = 1, #buff.finalNumArray_ do
		tmpArray[i] = buff.finalNumArray_[i]
	end

	newBuff.finalNumArray_ = tmpArray

	newBuff:setLeftCount(buff:getCount())

	return newBuff
end

function xyd.newBuff(buffData)
	local params = {
		effectID = buffData.effectID,
		fighter = buffData.fighter,
		target = buffData.target,
		skillID = buffData.skillID,
		index = buffData.skillIndex
	}
	local BuffManager = xyd.Battle.getRequire("BuffManager")
	local newBuff = BuffManager:newBuff(params)

	newBuff:setIsHit()

	return newBuff
end

function xyd.checkWeiWeiAn(fighter)
	if fighter.hero_ and xyd.arrayIndexOf({
		51013,
		651020,
		751013
	}, fighter:getHeroTableID()) > 0 then
		for _, v in ipairs(fighter.targetTeam_) do
			if not v:isDeath() and v:isStarMoon() then
				for _, buff in ipairs(v.isStarMoon_) do
					if buff.fighter == fighter then
						return false
					end
				end
			end
		end

		if fighter.weiweianLinkHero_ == nil then
			return true
		elseif fighter.weiweianLinkHero_.dieRoundWithReborn_ == xyd.Battle.round - 1 then
			return true
		end
	end

	return false
end
