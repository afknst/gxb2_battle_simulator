require("preload")

local M = 8
winner = ""
math.randomseed( os.time() )

function shuffle (arr)
  for i = 1, #arr - 1 do
    local j = math.random(i, #arr)
    arr[i], arr[j] = arr[j], arr[i]
  end
end

local season = 2 -- 1 or 2, check 6-1, Phoenix = 1, Hexa = 2
io.write("Enter stage 6-10: ")
local stage = io.read("*n") -- wait for number input. 6-10
local options = {
	{name = "Nephilim", lv = 330, awake = 5, potentials = {1,3,3,1,2,}, travel = 0, gear_skill = 0, equips = {1066,2266,3066,4266,5750,6365,7193},},
	{name = "Angelica", lv = 330, awake = 5, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 3, equips = {1369,2369,3369,4369,5749,64423,7212},},
	{name = "Izanami", lv = 330, awake = 5, potentials = {1,1,3,1,2,}, travel = 3004, gear_skill = 3, equips = {1569,2569,3569,4569,5754,64781,7191},},
	{name = "Sivney", lv = 330, awake = 5, potentials = {1,3,3,1,2,}, travel = 3004, gear_skill = 3, equips = {1569,2569,3569,4569,5754,64362,7211},},
	{name = "Estel", lv = 330, awake = 5, potentials = {2,2,3,2,2,}, travel = 2103, gear_skill = 0, equips = {1066,2066,3266,4066,5749,64901,7171},},
	{name = "Kassy", lv = 330, awake = 5, potentials = {3,1,3,3,2,}, travel = 2103, gear_skill = 3, equips = {1468,2468,3468,4468,5654,64361,7222},},
	{name = "Vivian", lv = 330, awake = 5, potentials = {1,3,1,1,2,}, travel = 0, gear_skill = 0, equips = {1065,2066,3065,4066,5652,6412,7185},},
	{name = "Blair", lv = 330, awake = 5, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 0, equips = {1466,2066,3066,4066,5749,6706,7188},},
	{name = "Diana", lv = 330, awake = 5, potentials = {2,2,3,2,2,}, travel = 3002, gear_skill = 0, equips = {1266,2065,3066,4065,5749,64481,0},},
	{name = "Kassy", lv = 250, awake = 0, potentials = {0,0,0,0,0}, travel = 0, gear_skill = 0, equips = {1066,2466,3066,4466,5642,6362,0},},
	{name = "Linky", lv = 250, awake = 0, potentials = {0,0,0,0,0}, travel = 0, gear_skill = 0, equips = {1065,2066,3065,4066,5660,6454,7084},},
	{name = "Frexie", lv = 290, awake = 3, potentials = {1,3,3,0,0,}, travel = 1505, gear_skill = 3, equips = {1469,2469,3469,4469,5652,6364,7220},},
}
local lead = {
	{name = "Apate", lv = 330, awake = 5, potentials = {3,2,3,3,2,}, travel = 3004, gear_skill = 3, equips = {1369,2369,3369,4369,5749,64362,7199},},
	{name = "Apate", lv = 330, awake = 5, potentials = {2,2,3,2,2,}, travel = 0, gear_skill = 0, equips = {1066,2066,3066,4066,5651,6700,7158},},
	{name = "Fenrir", lv = 330, awake = 5, potentials = {1,1,3,1,2,}, travel = 1505, gear_skill = 0, equips = {1065,2066,3065,4066,5752,6646,7149},},
}
local exiled = {
	{name = "Monica", lv = 330, awake = 5, potentials = {1,3,3,1,2,}, travel = 2601, gear_skill = 0, equips = {1066,2266,3066,4266,5750,67181,7204},},
	{name = "Holly", lv = 330, awake = 5, potentials = {1,3,3,1,2,}, travel = 2601, gear_skill = 3, equips = {1269,2269,3269,4269,5764,6362,7178},},
	{name = "Teresa", lv = 330, awake = 5, potentials = {1,1,3,1,2,}, travel = 2601, gear_skill = 0, equips = {1065,2066,3065,4066,5652,6724,7186},},
}
local pets = {
	{ name = "Robert", UC = 0, lv = 120 },
	{ name = "Hunter", UC = 10, lv = 160 },
	{ name = "Deerling", UC = 75, lv = 180 },
}

local plan = {
	--400801, --Adrenaline
	--402501, --Armor Plate
	--404901, --Attack Steal NEW
	--403501, --Back Waters
	--404701,404702, --Bad Call NEW
	--401301, --Barrier
	--402001, --Bleed out
	--403001, --Blind
	--402301,402302, --Buffer
	--402601, --Close Formation
	--402101, --Disinfectant Spray
	--401601, --Energy Drain
	--404401, --Energy Potion
	--404101, --Exile
	--403401, --Faint
	--401801,401802,402701, --Full Attack
	--404201,404202, --Healing Curse
	--400701, --Heavy Armor
	--403201,403202, --Infestation Pandemic
	--404301, --Insufficient Energy
	--404001, --Invisibility
	--403801, --Low Morale
	--401501, --Medical Supply
	--403601,403602, --Painless
	--404801, --Phantom Pain NEW
	--401401, --Poisonous Gas
	--403701, --Poor Health
	--404601, --Reaper's Curse NEW
	--401701, --Regroup
	--403901, --Revenge
	--402801, --Scapegoat
	--404501,404502, --Stun
	--402401, --Thorns
	--401201,401202,401203,401204,401205, --Tiredness
	--402901,402902, --Ultimate Seal
	--403301, --Victor Rush
	--401901, --Void Seal
	--402201, --Well Protected
	
	404501,404502, --Stun
    400801, --Adrenaline
    401201,401202,401203,401204,401205, --Tiredness
    400701, --Heavy Armor
    402801, --Scapegoat
    403401, --Faint
    402901,402902, --Ultimate Seal
    401501, --Medical Supply
    403701, --Poor Health
    403001, --Blind
    402501, --Armor Plate
    403901, --Revenge
    402001, --Bleed out
    404601, --Reaper's Curse
    404101, --Exile
    404801, --Phantom Pain
    404901, --Attack Steal
    404701,404702, --Bad Call
}

local opponents = {
	-- Season 1
	{str = { 1801020, 1801021, 1801020, 1801021, 1801020, 1801021}, pos = {1, 2, 3, 4, 5, 6}}, --Valeera x3 Phoenix x3
	{str = { 1801023, 1801023, 1801022, 1801022, 1801022, 1801022}, pos = {1, 2, 3, 4, 5, 6}}, --Nia x4 Turin x2
	{str = { 1801026, 1801026, 1801025, 1801024, 1801025, 1801024}, pos = {1, 2, 3, 4, 5, 6}}, --N-Gen Iron Fist x2 Raphael x2 Esau&Jacob x2
	
	{str = { 1801028, 1801027, 1801029, 1801027, 1801029, 1801028}, pos = {1, 2, 3, 4, 5, 6}}, --Michael x2 Gabriel x2 Angel x2
	{str = { 1801031, 1801031, 1801030, 1801030, 1801030, 1801030}, pos = {1, 2, 3, 4, 5, 6}}, --Empress Saint x4 Hottie x2
	{str = { 1801033, 1801032, 1801033, 1801032, 1801033, 1801032}, pos = {1, 2, 3, 4, 5, 6}}, --Rogue x3 Linky x3
	
	{str = { 1801009, 1801010, 1801009, 1801010, 1801009, 1801010}, pos = {1, 2, 3, 4, 5, 6}}, --Krystal x3 Mio x3
	{str = { 1801013, 1801014, 1801013, 1801014, 1801013, 1801014}, pos = {1, 2, 3, 4, 5, 6}}, --Lucifer x3 Angel x3
	{str = { 1801015, 1801015, 1801015, 1801015, 1801015, 1801015}, pos = {1, 2, 3, 4, 5, 6}}, --Joan x6
	
	{str = { 1801038, 1801039, 1801038, 1801039, 1801038, 1801039}, pos = {1, 2, 3, 4, 5, 6}}, --Michael x3 Lucifer x3
	{str = { 1801040, 1801041, 1801040, 1801041, 1801040, 1801041}, pos = {1, 2, 3, 4, 5, 6}}, --N-Gen Iron Fist x3 Trinity x3
	{str = { 1801042, 1801043, 1801042, 1801043, 1801042, 1801043}, pos = {1, 2, 3, 4, 5, 6}}, --Fenrir x3 Sapphire x3
	
	{str = { 1801044, 1801045, 1801046, 1801044, 1801045, 1801046}, pos = {1, 2, 3, 4, 5, 6}}, --Kong Ming x2 Amazon x2 Muppet x2
	{str = { 1801047, 1801048, 1801049, 1801048, 1801047, 1801049}, pos = {1, 2, 3, 4, 5, 6}}, --Trinity x2 Angel x2 Amelia x2
	{str = { 1801050, 1801051, 1801050, 1801051, 1801050, 1801051}, pos = {1, 2, 3, 4, 5, 6}}, --Izanami x3 Uriel x3
	
	-- Season 2	
	{str = { 1802020, 1802021, 1802020, 1802021, 1802020, 1802021}, pos = {1, 2, 3, 4, 5, 6}}, --Valeera x3 Hexa x3
	{str = { 1802023, 1802023, 1802022, 1802022, 1802022, 1802022}, pos = {1, 2, 3, 4, 5, 6}}, --Amelia x4 Sakura x2
	{str = { 1802026, 1802026, 1802025, 1802024, 1802025, 1802024}, pos = {1, 2, 3, 4, 5, 6}}, --N-Gen Iron Fist x2 Raphael x2 Esau&Jacob x2
	
	{str = { 1802028, 1802027, 1802029, 1802027, 1802029, 1802028}, pos = {1, 2, 3, 4, 5, 6}}, --Michael x2 Gabriel x2 Angel x2
	{str = { 1802031, 1802031, 1802030, 1802030, 1802030, 1802030}, pos = {1, 2, 3, 4, 5, 6}}, --Empress Saint x4 Hottie x2
	{str = { 1802033, 1802032, 1802033, 1802032, 1802033, 1802032}, pos = {1, 2, 3, 4, 5, 6}}, --Vera x3 CapsuGirl x3
	
	{str = { 1802009, 1802010, 1802009, 1802010, 1802009, 1802010}, pos = {1, 2, 3, 4, 5, 6}}, --Krystal x3 Mio x3
	{str = { 1802013, 1802014, 1802013, 1802013, 1802013, 1802014}, pos = {1, 2, 3, 4, 5, 6}}, --Ennmaya x4 Vivian x2
	{str = { 1802052, 1802015, 1802052, 1802015, 1802052, 1802015}, pos = {1, 2, 3, 4, 5, 6}}, --Ithil x3 Joan x3
	
	{str = { 1802038, 1802039, 1802038, 1802039, 1802038, 1802039}, pos = {1, 2, 3, 4, 5, 6}}, --Michael x3 Lucifer x3
	{str = { 1802040, 1802041, 1802040, 1802041, 1802040, 1802041}, pos = {1, 2, 3, 4, 5, 6}}, --Nobunaga x3 Trinity x3
	{str = { 1802042, 1802043, 1802042, 1802043, 1802042, 1802043}, pos = {1, 2, 3, 4, 5, 6}}, --Fenrir x3 Sapphire x3
	
	{str = { 1802044, 1802045, 1802046, 1802044, 1802045, 1802046}, pos = {1, 2, 3, 4, 5, 6}}, --Kong Ming x2 Psychic x2 Rogue x2
	{str = { 1802047, 1802048, 1802047, 1802048, 1802047, 1802049}, pos = {1, 2, 3, 4, 5, 6}}, --Nephilim x3 Kratos x2 Amelia x1
	{str = { 1802050, 1802051, 1802050, 1802051, 1802050, 1802051}, pos = {1, 2, 3, 4, 5, 6}}, --Izanami x3 Uriel x3
}

local opponent1 = opponents[1 + ((season-1)*15) + ((stage-6)*3)]
local opponent2 = opponents[2 + ((season-1)*15) + ((stage-6)*3)]
local opponent3 = opponents[3 + ((season-1)*15) + ((stage-6)*3)]

print("\n\nTrying Stage "..stage)
while (true) do

	shuffle(options)
	local team1 = {
		girls = {
			put(lead[1], 1),
			put(exiled[1], 2),
			put(options[10], 3),
			put(options[7], 4),
			put(options[4], 5),
			put(options[1], 6),
		}, servant = pets[1], guild_skills = GUILD_1ST_PAGE,
		god_skills = plan
	}
	local team2 = {
		girls = {
			put(lead[2], 1),
			put(exiled[2], 2),
			put(options[11], 3),
			put(options[8], 4),
			put(options[5], 5),
			put(options[2], 6),
		}, servant = pets[2], guild_skills = GUILD_1ST_PAGE,
		god_skills = plan
	}
	local team3 = {
		girls = {
			put(lead[3], 1),
			put(exiled[3], 2),
			put(options[12], 3),
			put(options[9], 4),
			put(options[6], 5),
			put(options[3], 6),
		}, servant = pets[3], guild_skills = GUILD_1ST_PAGE,
		god_skills = plan
	}
	
	local teams = {team1, team2, team3}
	if (stage == 6 or stage == 8 or stage == 9) then -- 7-3 and 10-3 generally have Fenrir in F1
		shuffle(teams)
	end
	battle1 = (fight(PvE_params(teams[1], opponent1), get_seeds(M), false))
	battle2 = (fight(PvE_params(teams[2], opponent2), get_seeds(M), false))
	battle3 = (fight(PvE_params(teams[3], opponent3), get_seeds(M), false))

	if ((battle1.wins > 0 and battle2.wins > 0) or (battle1.wins > 0 and battle3.wins > 0) or (battle2.wins > 0 and battle3.wins > 0)) then
	
		print (teams[1].girls[1].name..teams[1].girls[1].awake..", "..teams[1].girls[2].name..teams[1].girls[2].awake..", "..teams[1].girls[3].name..teams[1].girls[3].awake..", "..teams[1].girls[4].name..teams[1].girls[4].awake..", "..teams[1].girls[5].name..teams[1].girls[5].awake..", "..teams[1].girls[6].name..teams[1].girls[6].awake..", "..teams[1].servant.name)
		print (teams[2].girls[1].name..teams[2].girls[1].awake..", "..teams[2].girls[2].name..teams[2].girls[2].awake..", "..teams[2].girls[3].name..teams[2].girls[3].awake..", "..teams[2].girls[4].name..teams[2].girls[4].awake..", "..teams[2].girls[5].name..teams[2].girls[5].awake..", "..teams[2].girls[6].name..teams[2].girls[6].awake..", "..teams[2].servant.name)
		print (teams[3].girls[1].name..teams[3].girls[1].awake..", "..teams[3].girls[2].name..teams[3].girls[2].awake..", "..teams[3].girls[3].name..teams[3].girls[3].awake..", "..teams[3].girls[4].name..teams[3].girls[4].awake..", "..teams[3].girls[5].name..teams[3].girls[5].awake..", "..teams[3].girls[6].name..teams[3].girls[6].awake..", "..teams[3].servant.name)
		
		print (battle1.wins.." "..battle2.wins.." "..battle3.wins.."\n")
		
		battle4 = nil -- Give the team who lost a chance. Also print how close they were so if no 3 wins, you can choose who is closest and work from there.
		if (battle1.wins == 0) then
			battle4 = (fight(PvE_params(teams[1], opponent1), get_seeds(32), false))
			print(battle4.wins)
			print(get_report(battle4))
		elseif (battle2.wins == 0) then
			battle4 = (fight(PvE_params(teams[2], opponent1), get_seeds(32), false))
			print(battle4.wins)
			print(get_report(battle4))
		elseif (battle3.wins == 0) then
			battle4 = (fight(PvE_params(teams[3], opponent1), get_seeds(32), false))
			print(battle4.wins)
			print(get_report(battle4))
		end
		
		
		if ((battle1.wins > 0 and battle2.wins > 0 and battle3.wins > 0) or battle4.wins > 0) then
			print("Win Stage "..stage)
			os.execute("echo \a")
			break
		end
		
	end
	
end





