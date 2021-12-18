local ngx = ngx
local _M = {}
local mt = {
	__index = _M
}

function _M:instance()
	if not xyd.Battle.battleEvent then
		xyd.Battle.battleEvent = {}

		setmetatable(xyd.Battle.battleEvent, mt)
	end

	return xyd.Battle.battleEvent
end

function _M:on(name, func)
	self[name] = self[name] or {}

	table.insert(self[name], func)
end

function _M:off(name, func)
	if not self[name] or next(self[name]) == nil then
		return
	end

	for k, v in ipairs(self[name]) do
		if v == func then
			table.remove(self[name], k)
		end
	end
end

function _M:emit(name, ...)
	if not self[name] then
		return
	end

	local function protect_call(fun, ...)
		local res, err = pcall(fun, ...)

		if not res then
			print(err)
			print(debug.traceback())
		end
	end

	local is_delay = string.sub(name, -5) == "delay"

	if is_delay then
		local lib_functions = require("lib.common.functions")

		local function delay_event(...)
			local event = _M:instance()

			for _, v in ipairs(event[name]) do
				protect_call(v, ...)
			end
		end

		lib_functions:timer_at(delay_event, ...)
	else
		for _, v in ipairs(self[name]) do
			protect_call(v, ...)
		end
	end
end

return _M
