PREFIX = os.date("[%Y_%m_%d][%H_%M_%S]")

function repeat_char(char, times)
    local s = ""
    for i = 1, times do
        s = s .. char
    end
    return s
end

function range(length, sth)
    local res = {}
    for i = 1, length do
        res[i] = sth or i
    end
    return res
end

function save(_string, _file)
    local output = assert(io.open(_file, "a"))
    io.output(output)
    io.write(_string)
    io.close(output)
end

function init(seed, ind)
    seed = seed or os.time()
    seed = math.randomseed(seed)
    seed = math.random()
    seed = math.random()
    seed = math.random()
    if ind then
        PREFIX = PREFIX .. "[" .. ind .. "]"
    end
end

function get_seeds(M)
    local seeds = {}
    for i = 1, M do
        seeds[i] = math.random(1, 2 ^ 23)
    end
    return seeds
end

function round_m(num)
    local m = num / 1e6
    return (m - m % 0.01) .. "m"
end

function round_b(num)
    local m = num / 1e9
    return (m - m % 0.01) .. "b"
end

function round_n(num)
    if num >= 1000000000 then
        return round_b(num)
    elseif num >= 1000000 then
        return round_m(num)
    else
        return (num - num % 0.01)
    end
end

-- alignment: 'left' or 'right'
function fixed_length(sth, length, alignment)
    local str = tostring(sth)
    local size = #str
    assert(size <= length)
    local padding = repeat_char(" ", length - size)
    if alignment == "right" then
        return padding .. str
    end
    return str .. padding
end

function join(list, sep)
    local msg = ""
    sep = sep or ""
    for i = 1, #list do
        msg = msg .. list[i]
        if i ~= #list then
            msg = msg .. sep
        end
    end
    return msg
end
