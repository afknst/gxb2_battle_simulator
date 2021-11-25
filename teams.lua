local Apate = {
    name = "Apate",
    potentials = { 3, 3, 3, 3, 2 },
    excursion = 4,
    gear_skill = 3,
    core = "PINK3 Speed/HP",
    antique = "Deception",
}

local Vivian = {
    name = "Vivian",
    potentials = { 1, 3, 3, 1, 2 },
    excursion = 1,
    gear_skill = 2,
    core = "PINK3 HP/HP",
    antique = "Eternal Dawn P3",
}

local test_0 = {
    girls = {
        put(Apate, 1),
        put(Apate, 2),
        put(Apate, 3),
        put(Vivian, 4),
        put(Vivian, 5),
        put(Vivian, 6),
    },
    servant = {
        name = "Robert",
        UC = 60,
    },
    guild_skills = GUILD_FULL,
}

local test_1 = {
    girls = {
        put(Vivian, 1),
        put(Vivian, 2),
        put(Vivian, 3),
        put(Apate, 4),
        put(Apate, 5),
        put(Apate, 6),
    },
    servant = {
        name = "Kraken",
        UC = 60,
    },
    guild_skills = GUILD_FULL,
}

test_0["name"] = "test_0"
test_0["id"] = 0

test_1["name"] = "test_1"
test_1["id"] = 1

local teams = {
    test_0,
    test_1,
}

return teams
