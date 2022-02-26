local turbo = require("turbo")

local PvPHandler = class("PvPHandler", turbo.web.RequestHandler)

require("preload")

function PvPHandler:get() end

function PvPHandler:post()
	local req = self:get_json(true)
	self:write(PvP_fight(req))
end

local app = turbo.web.Application:new({
	{ "/PvP$", PvPHandler },
})

function start(port)
	app:listen(port)
	turbo.ioloop.instance():start()
end

return start
