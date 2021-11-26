require("preload")

local M = 1000

function get_random(N)
    math.random()
    math.random()
    math.random()
    local seeds = {}
    for i = 1, N do
        seeds[i] = math.random(1, os.time())
    end
    return seeds
end

function shuffle (arr)
  for i = 1, #arr - 1 do
    local j = math.random(i, #arr)
    arr[i], arr[j] = arr[j], arr[i]
  end
end

winner = ""
winnerRate = 0
math.randomseed( os.time() )
for i = 1,1, 1 do
	teamA = {str = {20016, 20029, 20020, 20031, 20028, 20062}, pos = {1, 2, 3, 4, 5, 6}}
	--list = {20016, 20029, 20004, 20062, 20034, 20032, 20038, 20020, 20028, 20031}
	--shuffle(list)
	--teamA = {str = {list[1], list[2], list[3], list[4], list[5], list[6]}, pos = {1, 2, 3, 4, 5, 6}}
	
	teamB = {str = {21077, 21078, 21081, 21077, 21078, 21077}, pos = {1, 2, 3, 4, 5, 6}}
	
	if (teamA.str[1]) then
	end
	
	tempRate = fight(sports_params(teamA, teamB), get_random(M), false).wins
	io.write(tempRate.."\n")
	if (winnerRate < tempRate) then
		winner = teamA.str[1]..", "..teamA.str[2]..", "..teamA.str[3]..", "..teamA.str[4]..", "..teamA.str[5]..", "..teamA.str[6]..", "
		winnerRate = tempRate
		if (winnerRate == 1) then
			break
		end
	end
	io.write(winner.."\t"..winnerRate.."\n\n")
end



-- 20031, 20062, 20032, 20004, 20020, 20016 -- 50.4% Amazon Linky Bud Elf Giana Sonya Librarian
-- 20062, 20031, 20028, 20020, 20004, 20032 -- 66.7% Linky Amazon Muppet Sonya Giana Bud Elf
-- 20032, 20004, 20031, 20028, 20062, 20020 -- 66.8% Bud Elf Giana Amazon Muppet Linky Sonya
--{20016,    20029,     20004, 20062, 20034, 20032,   20038,   20020, 20028,  20031}
--Librarian, Priestess, Giana, Linky, Lavia, Bud Elf, Aquaris, Sonya, Muppet, Amazon


--opponent
--{21095, 21095, 21095, 21095, 21095, 21095}
--{21097, 21097, 21097, 21097, 21097, 21097}
--{21098, 21098, 21098, 21098, 21098, 21098}
--{21076, 21076, 21072, 21072, 21072, 21072}
--{21071, 21070, 21073, 21074, 21073, 21075}
--{21085, 21080, 21083, 21080, 21084, 21083}

--{21110, 21110, 21110, 21110, 21110, 21110}
--{21108, 21108, 21108, 21108, 21108, 21108}
--{21109, 21109, 21109, 21109, 21109, 21109}
--{21113, 21114, 21113, 21114, 21114, 21114}
--{21077, 21078, 21081, 21077, 21078, 21077}
--{21115, 21115, 21115, 21115, 21115, 21115}

--{start
--{20059, 20022, 20012, 20042, 20005, 20045, 20051}
--{20046, 20016, 20031, 20009, 20018, 20030, 20023, 20037, 20003, 20032}
--{20030, 20037, 20033, 20013, 20006, 20025, 20011, 20002}
--{20001, 20003, 20017, 20032, 20035, 20036, 20043, 20041, 20027, 20013}
--{20032, 20009, 20010, 20011, 20025, 20014, 20027, 20024, 20016, 20015}
--{20016, 20018, 20015, 20036, 20008, 20004, 20005, 20043, 20022, 20044}
--Cynthia, Nobunaga, Javelin, Lucifer, Sapphire, Gabriel, Zoe
--Michael, Librarian, Amazon, Fencer, Hottie, Psychic, Silvia, Nani, Wildtress, Bud Elf
--Psychic, Nani, Himoto, Geisha, Wu Kong, Masamune, Chevalir, Dracula
--Succuba, Wildtress, Blowie, Bud Elf, Susan, Pandaria, Wraith, Scythe, Alice, Geisha
--Bud Elf, Fencer, Sakura, Chevalir, Masamune, Caitlyn, Alice, Toyo, Librarian, Guan Yin
--Librarian, Hottie, Guan Yin, Pandaria, Gambler, Giana, Sapphire, Wraith, Nobunaga, Angel

--{20019, 20004, 20037, 20034, 20021, 20008, 20994, 20995}
--{20015, 20024, 20036, 20031, 20004, 20006, 20016, 20008}
--{20010, 20040, 20041, 20005, 20034, 20038, 20037, 20023}
--{20043, 20031, 20035, 20038, 20026, 20062, 20045, 20037, 20017, 20032}
--{20016, 20029, 20004, 20062, 20034, 20032, 20038, 20020, 20028, 20031}
--{20020, 20011, 20038, 20003, 20023, 20027, 20035, 20001, 20009, 20032}
--Saint, Giana, Nani, Lavia, Nia, Gambler, Michael, Scythe
--Guan Yin, Toyo, Pandaria, Amazon, Giana, Wu Kong, Librarian, Gambler
--Sakura, Amelia, Scythe, Sapphire, Lavia, Aquaris, Nani, Silvia
--Wraith, Amazon, Susan, Aquaris, Hexa, Linky, Gabriel, Nani, Blowie, Bud Elf
--Librarian, Priestess, Giana, Linky, Lavia, Bud Elf, Aquaris, Sonya, Muppet, Amazon
--Sonya, Chevalir, Aquaris, Wildtress, Silvia, Alice, Susan, Succuba, Fencer, Bud Elf