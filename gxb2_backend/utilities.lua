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

function init(seed)
	local seed = seed or os.time()
	seed = math.randomseed(seed)
	seed = math.random()
	seed = math.random()
	seed = math.random()
	return math.random(1, 2 ^ 23)
end

function get_seeds(M)
	local seeds = {}
	for i = 1, M do
		seeds[i] = math.random(1, 2 ^ 23)
	end
	return seeds
end

function safe_func(func, ...)
	local good, msg = pcall(func, ...)
	while not good do
		save(msg .. "\n", "lua_errors.log")
		good, msg = pcall(func, ...)
	end

	return msg
end
