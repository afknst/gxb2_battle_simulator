function printf(fmt, ...)
	print(string.format(tostring(fmt), ...))
end

function checknumber(value, base)
	return tonumber(value, base) or 0
end

function checkint(value)
	return math.round(checknumber(value))
end

function checkbool(value)
	return value ~= nil and value ~= false
end

function checktable(value)
	if type(value) ~= "table" then
		value = {}
	end

	return value
end

function isset(hashtable, key)
	local t = type(hashtable)

	return (t == "table" or t == "userdata") and hashtable[key] ~= nil
end

function clone(object)
	local lookup_table = {}

	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end

		local new_table = {}
		lookup_table[object] = new_table

		for key, value in pairs(object) do
			new_table[_copy(key)] = _copy(value)
		end

		return setmetatable(new_table, getmetatable(object))
	end

	return _copy(object)
end

local function __TS__Index(classProto)
	return function (tbl, key)
		local proto = classProto

		while true do
			if not proto then
				break
			end

			local val = rawget(proto, key)

			if val ~= nil then
				return val
			end

			local getters = rawget(proto, "____getters")

			if getters then
				local getter = getters[key]

				if getter then
					return getter(tbl)
				end
			end

			proto = rawget(proto, "super")
		end
	end
end

local function __TS__NewIndex(classProto)
	return function (tbl, key, val)
		local proto = classProto

		while true do
			if not proto then
				break
			end

			local setters = rawget(proto, "____setters")

			if setters then
				local setter = setters[key]

				if setter then
					setter(tbl, val)

					return
				end
			end

			proto = rawget(proto, "super")
		end

		rawset(tbl, key, val)
	end
end

function class(classname, super, useSetterGetter)
	local superType = type(super)
	local cls = nil

	if superType ~= "table" then
		superType = nil
		super = nil
	end

	if super then
		cls = {}

		setmetatable(cls, {
			__index = super
		})

		cls.super = super
	else
		cls = {
			ctor = function ()
			end
		}
	end

	cls.__cname = classname

	if useSetterGetter then
		cls.____getters = {}
		cls.____setters = {}
		cls.__index = __TS__Index(cls)
		cls.__newindex = __TS__NewIndex(cls)
	else
		cls.__index = cls
	end

	function cls.new(...)
		local instance = setmetatable({}, cls)
		instance.class = cls

		instance:ctor(...)

		return instance
	end

	return cls
end

function iskindof(obj, classname)
	local t = type(obj)
	local mt = nil

	if t == "table" then
		mt = getmetatable(obj)
	elseif t == "userdata" then
		mt = tolua.getpeer(obj)
	end

	while mt do
		if mt.__cname == classname then
			return true
		end

		mt = mt.super
	end

	return false
end

function import(moduleName, currentModuleName)
	local currentModuleNameParts = nil
	local moduleFullName = moduleName
	local offset = 1

	while true do
		if string.byte(moduleName, offset) ~= 46 then
			moduleFullName = string.sub(moduleName, offset)

			if currentModuleNameParts and #currentModuleNameParts > 0 then
				moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
			end

			break
		end

		offset = offset + 1

		if not currentModuleNameParts then
			if not currentModuleName then
				local n, v = debug.getlocal(3, 1)
				currentModuleName = v
			end

			currentModuleNameParts = string.split(currentModuleName, ".")
		end

		table.remove(currentModuleNameParts, #currentModuleNameParts)
	end

	return require(moduleFullName)
end

function handler(obj, method)
	if method and obj then
		return function (...)
			return method(obj, ...)
		end
	else
		error("no obj or method")
	end
end

function math.newrandomseed()
	math.randomseed(os.time())
	math.random()
	math.random()
	math.random()
	math.random()
end

function math.round(value)
	value = checknumber(value)

	return math.floor(value + 0.5)
end

function math.angle2radian(angle)
	return angle * math.pi / 180
end

function math.radian2angle(radian)
	return radian / math.pi * 180
end

function io.exists(path)
	local file = io.open(path, "r")

	if file then
		io.close(file)

		return true
	end

	return false
end

function io.readfile(path)
	local file = io.open(path, "r")

	if file then
		local content = file:read("*a")

		io.close(file)

		return content
	end

	return nil
end

function io.writefile(path, content, mode)
	mode = mode or "w+b"
	local file = io.open(path, mode)

	if file then
		if file:write(content) == nil then
			return false
		end

		io.close(file)

		return true
	else
		return false
	end
end

function io.pathinfo(path)
	local pos = string.len(path)
	local extpos = pos + 1

	while pos > 0 do
		local b = string.byte(path, pos)

		if b == 46 then
			extpos = pos
		elseif b == 47 then
			break
		end

		pos = pos - 1
	end

	local dirname = string.sub(path, 1, pos)
	local filename = string.sub(path, pos + 1)
	extpos = extpos - pos
	local basename = string.sub(filename, 1, extpos - 1)
	local extname = string.sub(filename, extpos)

	return {
		dirname = dirname,
		filename = filename,
		basename = basename,
		extname = extname
	}
end

function io.filesize(path)
	local size = false
	local file = io.open(path, "r")

	if file then
		local current = file:seek()
		size = file:seek("end")

		file:seek("set", current)
		io.close(file)
	end

	return size
end

function table.nums(t)
	local count = 0

	for k, v in pairs(t) do
		count = count + 1
	end

	return count
end

function table.keys(hashtable)
	local keys = {}

	for k, v in pairs(hashtable) do
		keys[#keys + 1] = k
	end

	return keys
end

function table.values(hashtable)
	local values = {}

	for k, v in pairs(hashtable) do
		values[#values + 1] = v
	end

	return values
end

function table.merge(dest, src)
	for k, v in pairs(src) do
		dest[k] = v
	end
end

function table.insertto(dest, src, begin)
	begin = checkint(begin)

	if begin <= 0 then
		begin = #dest + 1
	end

	local len = #src

	for i = 0, len - 1 do
		dest[i + begin] = src[i + 1]
	end
end

function table.indexof(array, value, begin)
	for i = begin or 1, #array do
		if array[i] == value then
			return i
		end
	end

	return false
end

function table.keyof(hashtable, value)
	for k, v in pairs(hashtable) do
		if v == value then
			return k
		end
	end

	return nil
end

function table.removebyvalue(array, value, removeall)
	local c = 0
	local i = 1
	local max = #array

	while i <= max do
		if array[i] == value then
			table.remove(array, i)

			c = c + 1
			i = i - 1
			max = max - 1

			if not removeall then
				break
			end
		end

		i = i + 1
	end

	return c
end

function table.map(t, fn)
	for k, v in pairs(t) do
		t[k] = fn(v, k)
	end
end

function table.walk(t, fn)
	for k, v in pairs(t) do
		fn(v, k)
	end
end

function table.filter(t, fn)
	for k, v in pairs(t) do
		if not fn(v, k) then
			t[k] = nil
		end
	end
end

function table.unique(t, bArray)
	local check = {}
	local n = {}
	local idx = 1

	for k, v in pairs(t) do
		if not check[v] then
			if bArray then
				n[idx] = v
				idx = idx + 1
			else
				n[k] = v
			end

			check[v] = true
		end
	end

	return n
end

string._htmlspecialchars_set = {
	["&"] = "&amp;",
	["\""] = "&quot;",
	["'"] = "&#039;",
	["<"] = "&lt;",
	[">"] = "&gt;"
}

function string.htmlspecialchars(input)
	for k, v in pairs(string._htmlspecialchars_set) do
		input = string.gsub(input, k, v)
	end

	return input
end

function string.restorehtmlspecialchars(input)
	for k, v in pairs(string._htmlspecialchars_set) do
		input = string.gsub(input, v, k)
	end

	return input
end

function string.nl2br(input)
	return string.gsub(input, "\n", "<br />")
end

function string.text2html(input)
	input = string.gsub(input, "\t", "    ")
	input = string.htmlspecialchars(input)
	input = string.gsub(input, " ", "&nbsp;")
	input = string.nl2br(input)

	return input
end

function string.split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function string.ltrim(input)
	return string.gsub(input, "^[ \t\n\r]+", "")
end

function string.rtrim(input)
	return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.trim(input)
	input = string.gsub(input, "^[ \t\n\r]+", "")

	return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.ucfirst(input)
	return string.upper(string.sub(input, 1, 1)) .. string.sub(input, 2)
end

local function urlencodechar(char)
	return "%" .. string.format("%02X", string.byte(char))
end

function string.urlencode(input)
	input = string.gsub(tostring(input), "\n", "\r\n")
	input = string.gsub(input, "([^%w%.%- ])", urlencodechar)

	return string.gsub(input, " ", "+")
end

function string.urldecode(input)
	input = string.gsub(input, "+", " ")
	input = string.gsub(input, "%%(%x%x)", function (h)
		return string.char(checknumber(h, 16))
	end)
	input = string.gsub(input, "\r\n", "\n")

	return input
end

function string.utf8len(input)
	local len = string.len(input)
	local left = len
	local cnt = 0
	local arr = {
		0,
		192,
		224,
		240,
		248,
		252
	}

	while left ~= 0 do
		local tmp = string.byte(input, -left)
		local i = #arr

		while arr[i] do
			if arr[i] <= tmp then
				left = left - i

				break
			end

			i = i - 1
		end

		cnt = cnt + 1
	end

	return cnt
end

function string.utf8sub(input, i, j)
	i = i or 1
	j = j or -1
	local len = string.len(input)
	local left = len
	local cnt = 0
	local arr = {
		0,
		192,
		224,
		240,
		248,
		252
	}
	local tmpI, tmpJ, utf8length = nil

	if i < 0 then
		if utf8length == nil then
			utf8length = string.utf8len(input)
		end

		i = i + utf8length + 1
	end

	if j < 0 then
		if utf8length == nil then
			utf8length = string.utf8len(input)
		end

		j = j + utf8length + 1
	end

	while left ~= 0 do
		if not tmpI and i == cnt + 1 then
			tmpI = len - left + 1
		end

		if not tmpJ and j == cnt then
			tmpJ = len - left + 1 - 1
		end

		local tmp = string.byte(input, -left)
		local k = #arr

		while arr[k] do
			if arr[k] <= tmp then
				left = left - k

				break
			end

			k = k - 1
		end

		cnt = cnt + 1
	end

	if not tmpJ and j == cnt then
		tmpJ = len - left + 1 - 1
	end

	return string.sub(input, tmpI or len + 1, tmpJ or -1)
end

function string.formatnumberthousands(num)
	local formatted = tostring(checknumber(num))
	local k = nil

	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")

		if k == 0 then
			break
		end
	end

	return formatted
end

function table.tostring(tb)
	local success, res = pcall(cjson.encode, tb)

	if success then
		return res
	else
		return nil
	end
end

function table.sortedKeys(tbl, func)
	local keys = {}

	for key, value in pairs(tbl) do
		table.insert(keys, key)
	end

	table.sort(keys, func)

	return keys
end

function table.find(tbl, elem)
	local res = {}

	for _, value in pairs(tbl) do
		if value == elem then
			table.insert(res, value)
		end
	end

	return #res > 0, res
end

function table.length(tbl)
	local count = 0

	for _, value in pairs(tbl) do
		count = count + 1
	end

	return count
end

table.clone = clone
