xyd = xyd or {}
xyd.SECOND2STR = {
	HOURMINSEC = 5,
	VIP = 2,
	NOSEC = 3,
	NOMINU = 4,
	NORMAL = 1
}

function xyd.round(v)
	return math.floor(v + 0.5)
end

function xyd.fixNum(v)
	return v - v % 0.01
end

function xyd.getItemIconName(itemID, noPath)
	local iconName = ""
	local path = "Textures/partner_avatar_web/"
	local iconType = xyd.tables.itemTable:getType(itemID)

	if iconType == xyd.ItemType.HERO_DEBRIS then
		local partnerCost = xyd.tables.itemTable:partnerCost(itemID)
		iconName = xyd.tables.partnerTable:getAvatar(partnerCost[1])
	elseif iconType == xyd.ItemType.HERO then
		iconName = xyd.tables.partnerTable:getAvatar(itemID)
	elseif iconType == xyd.ItemType.SKIN then
		iconName = xyd.tables.equipTable:getSkinAvatar(itemID)
	else
		path = "Textures/head_web/"
		iconName = xyd.tables.itemTable:getIcon(itemID)
	end

	path = path .. (iconName or "")

	if noPath then
		return iconName
	end

	return path
end

function xyd.getItemIcon(params, iconType, offsetDepth)
	local uiRoot = params.uiRoot

	if not uiRoot then
		error("no uiRoot")
	end

	local icon = nil
	local itemID = params.itemID

	if iconType then
		local iconClass = require("app.components.IconClasses")

		if iconType == xyd.ItemIconType.PLAYER_ICON then
			icon = iconClass[iconType].new(uiRoot, params.renderPanel)
			params.avatar_frame_id = itemID

			if not params.noClick then
				params.noClick = false
			end
		else
			icon = iconClass[iconType].new(uiRoot, offsetDepth)
		end
	else
		local type_ = xyd.tables.itemTable:getType(itemID)

		if type_ == xyd.ItemType.AVATAR_FRAME then
			local renderPanel = params.renderPanel
			local PlayerIcon = import("app.components.PlayerIcon")
			icon = PlayerIcon.new(uiRoot, renderPanel)
			params.avatar_frame_id = itemID

			if not params.noClick then
				params.noClick = false
			end
		elseif type_ ~= xyd.ItemType.HERO_DEBRIS and type_ ~= xyd.ItemType.HERO and type_ ~= xyd.ItemType.HERO_RANDOM_DEBRIS and type_ ~= xyd.ItemType.SKIN then
			local ItemIcon = import("app.components.ItemIcon")
			icon = ItemIcon.new(uiRoot, offsetDepth)
		else
			local HeroIcon = import("app.components.HeroIcon")
			icon = HeroIcon.new(uiRoot)
		end
	end

	icon:setInfo(params)

	return icon
end

function xyd.getItemIconType(itemID)
	local type_ = xyd.tables.itemTable:getType(itemID)

	if type_ == xyd.ItemType.AVATAR_FRAME then
		return 1
	elseif type_ ~= xyd.ItemType.HERO_DEBRIS and type_ ~= xyd.ItemType.HERO and type_ ~= xyd.ItemType.HERO_RANDOM_DEBRIS and type_ ~= xyd.ItemType.SKIN then
		return 2
	else
		return 3
	end
end

function xyd.getCachePrefabByPath(path)
	return xyd.WindowManager.get():getCachePrefabByPath(path)
end

function xyd.getHeroIcon(params)
	local heroTableID = params.tableID
	local uiRoot = params.uiRoot
	local panel_ = params.panel
	local isUnique_ = params.isUnique
	local hideLev_ = params.hideLev

	if params.isPartnerData and params.isPartnerData() then
		-- Nothing
	elseif params.isMonster then
		heroTableID = xyd.tables.monsterTable:getPartnerLink(params.tableID)
	else
		local Partner = import("app.models.Partner")
		local p = Partner.new()
		params.table_id = params.tableID

		p:populate(params)

		params = p:getInfo()
		params.noClick = true
	end

	params.tableID = heroTableID
	local HeroIcon = import("app.components.HeroIcon")
	local heroIcon = HeroIcon.new(uiRoot)

	if params.panel == nil and panel_ ~= nil then
		params.panel = panel_
	end

	if params.isUnique == nil and isUnique_ ~= nil then
		params.isUnique = isUnique_
	end

	if params.hideLev == nil and hideLev_ ~= nil then
		params.hideLev = hideLev_
	end

	heroIcon:setInfo(params)

	return heroIcon
end

function xyd.getMapInstanceByType(mapType)
	local type2Instance = {
		[xyd.GameMapType.MAIN] = xyd.MainMap.get()
	}

	return type2Instance[mapType]
end

function xyd.checkTableIsLang(tableName)
	local langs = {
		"zh_tw",
		"zh_cn",
		"en_en",
		"ja_jp",
		"fr_fr",
		"ko_kr",
		"de_de"
	}

	for _, lang in ipairs(langs) do
		local has_lang = string.find(tableName, lang)

		if has_lang then
			return lang
		end
	end

	return nil
end

function xyd.splitToNumber(str, delimiter)
	return xyd.split(str, delimiter, true)
end

function xyd.split(str, delimiter, isNumber, isReg)
	if not str or not delimiter then
		return {}
	end

	local result = {}

	if str == "" then
		return result
	end

	local tDelimiter = delimiter

	if isReg then
		tDelimiter = string.gsub(delimiter, "%%", "")
	end

	if delimiter == "$" then
		delimiter = "%$"
	end

	for match in (str .. tDelimiter):gmatch("(.-)" .. delimiter) do
		if match ~= "" then
			if isNumber then
				match = tonumber(match)
			end

			table.insert(result, match)
		else
			if isNumber then
				match = 0
			end

			table.insert(result, match)
		end
	end

	return result
end

function xyd.split2(str, delimiters, isNumber, handler)
	if not str or not delimiters or not next(delimiters) then
		return
	end

	local result = {}

	if str == "" then
		return result
	end

	local length = #delimiters

	local function split(str, dindex)
		local delimiter = delimiters[dindex]
		local isLastIndex = dindex == length
		local toNumber = isNumber and isLastIndex or false
		local strs = xyd.split(str, delimiter, toNumber)

		if not isLastIndex then
			for i, str2 in ipairs(strs) do
				strs[i] = split(str2, dindex + 1)
			end
		elseif handler then
			strs = handler(strs)
		end

		return strs
	end

	result = split(str, 1)

	return result
end

function xyd.getScreenSize()
	local Screen = UnityEngine.Screen

	return Screen.width, Screen.height
end

function xyd.isOverUI()
	if UNITY_ANDROID or UNITY_IOS then
		return XYDUtils.IsFingerOverUI()
	else
		return XYDUtils.IsMouseOverUI()
	end
end

function xyd.setUISprite(uiSprite, atlasName, spriteName)
	if not spriteName then
		return
	end

	local pos = string.find(spriteName, "_png")

	if pos then
		local name = string.sub(spriteName, 1, pos - 1)
		spriteName = name
	end

	local index = xyd.Sprites2Atlas.table_map[spriteName]

	if not index then
		return
	end

	atlasName = xyd.Sprites2Atlas.table_index[index]

	if not atlasName then
		UnityEngine.Debug.LogWarning("dont't find the atlas of sprite: " .. spriteName)

		return
	end

	local path = string.format("Atlases/%s/%s", atlasName, atlasName)

	ResCache.SetUISprite(uiSprite, path, spriteName)
end

function xyd.setUISpriteAsync(uiSprite, atlasName, spriteName, callback, showLoading, isMakePixel)
	if not spriteName then
		return
	end

	local pos = string.find(spriteName, "_png")

	if pos then
		local name = string.sub(spriteName, 1, pos - 1)
		spriteName = name
	end

	local index = xyd.Sprites2Atlas.table_map[spriteName]

	if not index then
		return
	end

	atlasName = xyd.Sprites2Atlas.table_index[index]

	if not atlasName then
		UnityEngine.Debug.LogWarning("dont't find the atlas of sprite: " .. spriteName)

		return
	end

	local path = string.format("Atlases/%s/%s", atlasName, atlasName)

	ResCache.SetUISpriteAsync(uiSprite, path, spriteName, function (isSuccess)
		if isSuccess and isMakePixel and not tolua.isnull(uiSprite) then
			uiSprite:MakePixelPerfect()
		end

		if isSuccess and callback ~= nil then
			callback()
		end
	end, showLoading)
end

function xyd.getSpritePath(spriteName)
	local index = xyd.Sprites2Atlas.table_map[spriteName]

	if not index then
		return
	end

	local atlasName = xyd.Sprites2Atlas.table_index[index]
	local path = string.format("Atlases/%s/%s", atlasName, atlasName)

	return path
end

function xyd.getAtlasSP2MappingPath(spriteName)
	local realName = "Sp2_" .. spriteName

	return xyd.MappingData[realName]
end

function xyd.setUITexture(uiTexture, path)
	ResCache.SetUITexture(uiTexture, path)
end

function xyd.setUITextureAsync(uiTexture, path, callback, showLoading)
	ResCache.SetUITextureAsync(uiTexture, path, function (isSuccess)
		if isSuccess and callback ~= nil then
			callback()
		end
	end, showLoading)
end

function xyd.getTextureRealSize(name)
	local result = {
		width = 0,
		height = 0
	}
	local str = xyd.Textures2Config.table_map[name]

	if not str then
		return result
	end

	local conf = xyd.split(str, "|", true)
	result.width = conf[2]
	result.height = conf[3]

	return result
end

function xyd.setUITextureByNameAsync(uiTexture, name, isSetSize, callback, showLoading)
	local str = xyd.Textures2Config.table_map[name]

	if not str then
		return
	end

	local conf = xyd.split(str, "|", true)
	local path = string.format("Textures/%s/%s", xyd.Textures2Config.table_index[conf[1]], name)

	ResCache.SetUITextureAsync(uiTexture, path, function (isSuccess)
		if isSuccess and uiTexture and isSetSize then
			uiTexture.width = conf[2]
			uiTexture.height = conf[3]
		end

		if isSuccess and callback ~= nil then
			callback()
		end
	end, showLoading)
end

function xyd.setUITextureByName(uiTexture, name, isSetSize)
	local str = xyd.Textures2Config.table_map[name]

	if not str then
		return
	end

	local conf = xyd.split(str, "|", true)
	local path = string.format("Textures/%s/%s", xyd.Textures2Config.table_index[conf[1]], name)

	ResCache.SetUITexture(uiTexture, path)

	if isSetSize then
		uiTexture.width = conf[2]
		uiTexture.height = conf[3]
	end
end

function xyd.getTexturePath(name)
	local str = xyd.Textures2Config.table_map[name]

	if not str then
		return ""
	end

	local conf = xyd.split(str, "|", true)
	local path = string.format("Textures/%s/%s", xyd.Textures2Config.table_index[conf[1]], name)

	return path
end

function xyd.changeSlotTransform(spAnim, name, pos, scale)
	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, xyd.ANDROID_1_1_86) <= 0 then
		return false
	end

	pos = pos or Vector3.zero
	scale = scale or Vector3.one

	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, xyd.ANDROID_1_4_88) < 0 or UNITY_IOS and XYDUtils.CompVersion(UnityEngine.Application.version, xyd.IOS_71_3_51) < 0 then
		spAnim:changeRegionAttachmentPosition(name, pos, scale)
	else
		spAnim:changeRegionAttachmentPosition(name, pos, scale, 0)
	end

	return true
end

function xyd.isPkgVersionUp(version)
	return true
end

function xyd.getMapInstance(mapType)
	local instances = {
		[xyd.MapType.CITY] = xyd.CityMap.get()
	}

	return instances[mapType]
end

function xyd.getTimeZone()
	local tb = os.date("*t", 0)

	if tb.year == 1970 then
		return tb.hour
	else
		return tb.hour - 24
	end
end

function xyd.getDisplayDate(time, noTime)
	if noTime == nil then
		noTime = true
	end

	local timeDesc = os.date("*t", time)
	local nowDesc = os.date("*t")
	local HM = ""

	if timeDesc.hour < 10 then
		HM = HM .. "0" .. timeDesc.hour
	else
		HM = HM .. timeDesc.hour
	end

	HM = HM .. ":"

	if timeDesc.min < 10 then
		HM = HM .. "0" .. timeDesc.min
	else
		HM = HM .. timeDesc.min
	end

	HM = HM .. ":"

	if timeDesc.sec < 10 then
		HM = HM .. "0" .. timeDesc.sec
	else
		HM = HM .. timeDesc.sec
	end

	if not noTime then
		return timeDesc.year .. "-" .. timeDesc.month .. "-" .. timeDesc.day .. "  " .. HM
	else
		return timeDesc.year .. "-" .. timeDesc.month .. "-" .. timeDesc.day
	end
end

function xyd.getFixedSize()
	local Screen = UnityEngine.Screen
	local screenW = Screen.width
	local screenH = Screen.height
	local fixedScale = xyd.STANDARD_WIDTH / screenW
	local fixedHeight = screenH * fixedScale

	return xyd.STANDARD_WIDTH, fixedHeight
end

function xyd.getServerTime(exact)
	if exact then
		local socket = require("socket")

		return xyd.Global.serverDeltaTime + socket.gettime()
	else
		return xyd.Global.serverDeltaTime + os.time()
	end
end

function xyd.getReceiveTime(receiveTime)
	local duration = math.max(xyd.getServerTime() - receiveTime, 0)
	local str = nil

	if duration <= 59 then
		str = __("RECEIVE_TIME_1")
	elseif duration > 59 and duration <= 3599 then
		str = __("RECEIVE_TIME_2", math.floor(duration / 60))
	elseif duration > 3599 and duration <= 86399 then
		str = __("RECEIVE_TIME_3", math.floor(duration / 3600))
	elseif duration > 86399 and duration <= 863999 then
		str = __("RECEIVE_TIME_4", math.floor(duration / 86400))
	else
		str = __("RECEIVE_TIME_5")
	end

	return str
end

function xyd.getDisplayNumber(n)
	if not n or n == math.huge or n == tonumber("nan") then
		return ""
	end

	local left, num, right = string.match(n, "^([^%d]*%d)(%d*)(.-)$")

	if not num then
		return ""
	end

	return left .. num:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. right
end

function xyd.tableContains(list, targetElem)
	for _, elem in ipairs(list) do
		if elem == targetElem then
			return true
		end
	end
end

function xyd.getRoughDisplayNumber(num, limitNum)
	local absNum = math.abs(num)

	if absNum < (limitNum or 10000) then
		return tonumber(num)
	end

	local denoNum = 1
	local postfix = nil

	if absNum < 10000000 then
		denoNum = 1000
		postfix = "K"
	elseif absNum < 10000000000.0 then
		denoNum = 1000000
		postfix = "M"
	elseif absNum < 10000000000000.0 then
		denoNum = 1000000000
		postfix = "B"
	elseif absNum < 1e+16 then
		denoNum = 1000000000000.0
		postfix = "T"
	else
		denoNum = 1000000000000000.0
		postfix = "P"
	end

	local a, b = math.modf(absNum / denoNum)

	return string.format("%s%s%s", num < 0 and "-" or "", a, postfix)
end

function xyd.getRoughDisplayNumber2(num, limitNum)
	if type(num) ~= "number" then
		return nil
	end

	local absNum = math.abs(num)

	if absNum < (limitNum or 10000) then
		return tonumber(num)
	end

	local denoNum = 1
	local postfix = nil

	if absNum < 10000000 then
		denoNum = 1000
		postfix = "K"
	elseif absNum < 10000000000.0 then
		denoNum = 1000000
		postfix = "M"
	elseif absNum < 10000000000000.0 then
		denoNum = 1000000000
		postfix = "B"
	elseif absNum < 1e+16 then
		denoNum = 1000000000000.0
		postfix = "T"
	else
		denoNum = 1000000000000000.0
		postfix = "P"
	end

	local a, b = math.modf(absNum / denoNum)

	return string.format("%s%s%s", num < 0 and "-" or "", a, postfix)
end

function xyd.getRoughDisplayNumber3(num, limitNum)
	local absNum = math.abs(num)

	if absNum < (limitNum or 10000) then
		return tonumber(num)
	end

	local denoNum = 1
	local postfix = nil

	if absNum < 10000000 then
		denoNum = 1000
		postfix = "K"
	elseif absNum < 1000000000 then
		denoNum = 1000000
		postfix = "M"
	else
		denoNum = 1000000
		postfix = "M"
	end

	local a, b = math.modf(absNum / denoNum)

	return string.format("%s%s%s", num < 0 and "-" or "", a, postfix)
end

function xyd.getRoughDisplayTime(seconds, short)
	local day = math.floor(seconds / xyd.DAY)
	local hour = math.floor(seconds % xyd.DAY / xyd.HOUR)
	local minute = math.floor(seconds % xyd.HOUR / xyd.MINUTE)
	local second = seconds % xyd.MINUTE

	if short then
		if day > 0 then
			return day .. "d"
		elseif hour > 0 then
			return hour .. "h"
		elseif minute > 0 then
			return minute .. "m"
		else
			return second .. "s"
		end
	elseif day > 0 then
		return __("DAY", day)
	elseif hour > 0 then
		return __("HOUR", hour)
	elseif minute > 0 then
		return __("MINUTE", minute)
	else
		return __("SECOND", second)
	end
end

function xyd.getRoughDisplayName(playerName, limitNum)
	limitNum = limitNum or 12
	local rough_str = nil

	if limitNum < #playerName then
		rough_str = string.sub(playerName, 1, limitNum)
	else
		rough_str = playerName
	end

	return rough_str
end

function xyd.getDisplayTime(time, timestampStrType)
	local timeDesc = os.date("*t", time)

	if timestampStrType == xyd.TimestampStrType.DATE then
		return string.format("%04d-%02d-%02d", timeDesc.year, timeDesc.month, timeDesc.day)
	elseif timestampStrType == xyd.TimestampStrType.DATE_NO_YEAR then
		return string.format("%02d-%02d", timeDesc.month, timeDesc.day)
	elseif timestampStrType == xyd.TimestampStrType.TIME then
		return string.format("%02d:%02d:%02d", timeDesc.hour, timeDesc.min, timeDesc.sec)
	elseif timestampStrType == xyd.TimestampStrType.TIME_NO_SECOND then
		return string.format("%02d:%02d", timeDesc.hour, timeDesc.min)
	else
		return string.format("%04d-%02d-%02d  %02d:%02d:%02d", timeDesc.year, timeDesc.month, timeDesc.day, timeDesc.hour, timeDesc.min, timeDesc.sec)
	end
end

function xyd.getDisplayTime2(time, timestampStrType)
	local timeDesc = os.date("*t", time)

	if timestampStrType == xyd.TimestampStrType.DATE then
		return string.format("%04d/%02d/%02d", timeDesc.year, timeDesc.month, timeDesc.day)
	elseif timestampStrType == xyd.TimestampStrType.DATE_NO_YEAR then
		return string.format("%02d/%02d", timeDesc.month, timeDesc.day)
	elseif timestampStrType == xyd.TimestampStrType.TIME then
		return string.format("%02d:%02d:%02d", timeDesc.hour, timeDesc.min, timeDesc.sec)
	elseif timestampStrType == xyd.TimestampStrType.TIME_NO_SECOND then
		return string.format("%02d:%02d", timeDesc.hour, timeDesc.min)
	else
		return string.format("%04d/%02d/%02d  %02d:%02d:%02d", timeDesc.year, timeDesc.month, timeDesc.day, timeDesc.hour, timeDesc.min, timeDesc.sec)
	end
end

function xyd.dispatchEventByFrontEnd(event, params)
	local data = {
		name = event,
		params = params
	}

	xyd.EventDispatcher.outer():dispatchEvent(data)
	xyd.EventDispatcher.inner():dispatchEvent(data)
end

function xyd.secondsToString(seconds, strType)
	if seconds < 0 then
		seconds = 0
	end

	if strType == nil then
		strType = xyd.SecondsStrType.NORMAL
	end

	local day = math.floor(seconds / xyd.DAY)
	local hour = math.floor(seconds / xyd.HOUR)
	local minute = math.floor(seconds % xyd.HOUR / xyd.MINUTE)
	local second = seconds % xyd.MINUTE
	local secondString = ""

	if strType == xyd.SECOND2STR.NOSEC then
		secondString = string.format("%02d:%02d", hour, minute)
	elseif strType == xyd.SECOND2STR.NOMINU then
		local leftHour = math.floor(seconds % xyd.DAY / xyd.HOUR)
		secondString = __("NOMINU_COUNTDOWN", day, leftHour)
	else
		secondString = string.format("%02d:%02d:%02d", hour, minute, second)
	end

	return secondString
end

function xyd.clearList(goParent)
	if tolua.isnull(goParent) then
		return
	end

	local Object = UnityEngine.Object
	local transParent = goParent.transform
	local funcDestroy = Object.Destroy
	local childCount = transParent.childCount

	for i = childCount, 1, -1 do
		local t = transParent:GetChild(i - 1)
		local go = t.gameObject

		go:SetActive(false)
		funcDestroy(go)
	end
end

function xyd.setMaskMaterial(material, localPos, size)
	local ScreenOffset = 10
	local fixedWidth, fixedHeight = xyd.getFixedSize()
	fixedWidth = fixedWidth + ScreenOffset
	fixedHeight = fixedHeight + ScreenOffset
	local offsetX = fixedWidth / 2 + localPos.x - size.width / 2
	local offsetY = fixedHeight / 2 + localPos.y - size.height / 2

	material:SetFloat("_TexSizeW", fixedWidth)
	material:SetFloat("_TexSizeH", fixedHeight)
	material:SetFloat("_MaskSizeW", size.width)
	material:SetFloat("_MaskSizeH", size.height)
	material:SetFloat("_MaskPosX", offsetX)
	material:SetFloat("_MaskPosY", offsetY)
end

function xyd.getRomanNumber(num)
	local n = nil

	if type(num) == "number" then
		n = num
	elseif tonumber(num) then
		n = tonumber(num)
	else
		return ""
	end

	local result = ""
	local roman = {
		"I",
		"II",
		"III",
		"IV",
		"V",
		"VI",
		"VII",
		"VIII",
		"IX",
		"X",
		"XI",
		"XII",
		"XIII",
		"XIV",
		"XV"
	}

	if n > 0 and n <= 15 then
		return roman[n]
	else
		return ""
	end
end

function xyd.getLineID()
	local res = "@mafia"

	if xyd.isTWPkg() then
		res = "@mafia"
	end

	return res
end

function xyd.isTWPkg()
	local pkgName = XYDDef.PkgName

	return pkgName == "com.carolgames.moemoegirls"
end

function xyd.isH5EN()
	local pkgName = XYDDef.PkgName

	return pkgName == "com.carolgames.moemoegirls"
end

function xyd.isH5JP()
	local pkgName = XYDDef.PkgName

	return pkgName == "com.carolgames.moemoegirls.jp"
end

function xyd.getRedText(text)
	local redColor = "c20f12"

	return "[" .. redColor .. "]" .. text .. "[-]"
end

function xyd.getGreenText(text)
	local greenColor = "2a9c2a"

	return "[" .. greenColor .. "]" .. text .. "[-]"
end

function xyd.beginSample(name)
	UnityEngine.Profiling.Profiler.BeginSample(name)
end

function xyd.endSample()
	UnityEngine.Profiling.Profiler.EndSample()
end

function xyd.showSmallKeyboard(go, params)
	local CommonKeyboardPanel = require("app.common.ui.CommonKeyboardPanel")

	CommonKeyboardPanel.get():show(go, params)
end

function xyd.calcPointToLine(px, py, fx, fy, tx, ty)
	local distance = nil

	if fx == tx then
		distance = (tx - px)^2
	else
		local k = (fy - ty) / (fx - tx)
		local b = fy - k * fx
		local num1 = k * px - py + b
		distance = num1 * num1 / (k^2 + 1)
	end

	return distance
end

function xyd.getIntersectionPoints(p1, p2, p3, p4)
	local ix, iy = nil

	local function sortPoints(p1, p2)
		if p2.x < p1.x or p1.x == p2.x and p2.y < p1.y then
			local tmp = p2
			p2 = p1
			p1 = tmp
		end

		return p1, p2
	end

	if p1.x ~= p2.x and p3.x ~= p4.x then
		p1, p2 = sortPoints(p1, p2)
		p3, p4 = sortPoints(p3, p4)
		local k1 = (p1.y - p2.y) / (p1.x - p2.x)
		local b1 = p1.y - p1.x * k1
		local k2 = (p3.y - p4.y) / (p3.x - p4.x)
		local b2 = p3.y - p3.x * k2
		ix = (b1 - b2) / (k2 - k1)
		iy = k1 * ix + b1

		if p1.x < ix and ix < p2.x and p3.x < ix and ix < p4.x then
			return ix, iy
		end
	elseif p1.x == p2.x and p3.x == p4.x then
		if p1.x == p3.x then
			return p1.x, p1.x
		end
	else
		if p1.x == p2.x then
			local tmp3 = p3
			local tmp4 = p4
			p3 = p1
			p4 = p2
			p1 = tmp3
			p2 = tmp4
		end

		p1, p2 = sortPoints(p1, p2)
		p3, p4 = sortPoints(p3, p4)

		if p1.x <= p3.x and p3.x <= p2.x then
			local k = (p1.y - p2.y) / (p1.x - p2.x)
			local b = p1.y - p1.x * k
			local y = k * p3.x + b

			if p3.y <= y and y <= p4.y then
				ix = p3.x
				iy = y

				return ix, iy
			end
		end
	end
end

function xyd.calcAnimeDirection(angle)
	angle = angle % 360

	if angle > 347 and angle <= 360 or angle >= 0 and angle <= 13 then
		return 270
	elseif angle > 13 and angle <= 58 then
		return 225
	elseif angle > 58 and angle <= 122 then
		return 180
	elseif angle > 122 and angle <= 154 then
		return 135
	elseif angle > 154 and angle <= 193 then
		return 90
	elseif angle > 193 and angle <= 238 then
		return 45
	elseif angle > 238 and angle <= 302 then
		return 0
	elseif angle > 302 and angle <= 347 then
		return 315
	end
end

function xyd.chsize(char)
	if not char then
		return 0
	elseif char >= 252 then
		return 6
	elseif char >= 248 then
		return 5
	elseif char >= 240 then
		return 4
	elseif char >= 224 then
		return 3
	elseif char >= 192 then
		return 2
	else
		return 1
	end
end

function xyd.compareStringNumber(lh, rh)
	if string.byte(lh, 1, 1) == 45 and string.byte(rh, 1, 1) == 45 then
		return -xyd.compareStringNumberHelper(lh, rh)
	elseif string.byte(lh, 1, 1) == 45 then
		return -1
	elseif string.byte(rh, 1, 1) == 45 then
		return 1
	else
		return xyd.compareStringNumberHelper(lh, rh)
	end
end

function xyd.compareStringNumberHelper(lh, rh)
	if #lh > #rh then
		return 1
	elseif #lh == #rh then
		if rh < lh then
			return 1
		elseif lh == rh then
			return 0
		else
			return -1
		end
	else
		return -1
	end
end

function xyd.setOnceEventTrigger(eventName, listener, params)
	params = params or {}
	local dispatcher = nil

	if params.dispatcherType == xyd.DispatcherType.OUTER then
		dispatcher = xyd.EventDispatcher.outer()
	else
		dispatcher = xyd.EventDispatcher.inner()
	end

	local timer, handle = nil
	handle = dispatcher:addEventListener(eventName, function (event)
		dispatcher:removeEventListener(handle)

		if timer then
			timer:Stop()

			timer = nil
		end

		if listener then
			listener(event)
		end
	end)
	local limitTime = params.limitTime or 10
	local timeOutCallback = params.timeOutCallback
	timer = Timer.New(function ()
		if not timer then
			return
		end

		dispatcher:removeEventListener(handle)

		if timeOutCallback then
			timeOutCallback()
		end
	end, limitTime, 1, false)

	timer:Start()

	return handle
end

function xyd.getUnderlineText(text)
	return string.format("[u]%s[-]", text)
end

function xyd.compareResult(a, b, time, reverse)
	time = time or 1

	if b < a then
		if not reverse then
			return 0, 1 * time
		else
			return 1 * time, 0
		end
	elseif a < b then
		if not reverse then
			return 1 * time, 0
		else
			return 0, 1 * time
		end
	else
		return 0, 0
	end
end

function xyd.updateParentAnchors(trans)
	local parent = trans.parent

	if parent then
		local name = parent.name
		local _, _, num = string.find(name, "WindowLayer_(%d)")

		if not num then
			xyd.updateParentAnchors(parent)
		end
	end

	NGUITools.ResetAndUpdateAnchors(trans)
end

function xyd.tableReverse(t)
	local res = {}

	for i = #t, 1, -1 do
		table.insert(res, t[i])
	end

	return res
end

function xyd.tableInsert(tb, pos, value)
	local index = pos
	local curValue = tb[index]

	while curValue ~= nil do
		index = index + 1
		local tmp = tb[index]
		tb[index] = curValue
		curValue = tmp
	end

	tb[pos] = value
end

function xyd.setTimeLimitAutoOnceEventTrigger(limitTime, eventName, listener, timeOutCallback, data, dispatcherType)
	local eventDispatcher = nil

	if not dispatcherType or dispatcherType == 1 then
		eventDispatcher = xyd.EventDispatcher.inner()
	elseif dispatcherType == 2 then
		eventDispatcher = xyd.EventDispatcher.outer()
	end

	local handle = {}
	local timer = nil
	handle.handle = eventDispatcher:addEventListener(eventName, function (event)
		eventDispatcher:removeEventListener(handle.handle)

		if timer then
			timer:Stop()
		end

		listener(event)
	end, data)

	if limitTime and limitTime > 0 then
		timer = Timer.New(function ()
			eventDispatcher:removeEventListener(handle.handle)

			if timeOutCallback then
				timeOutCallback()
			end
		end, limitTime, 1, true)

		timer:Start()
	end

	return handle.handle
end

function xyd.getLarger(list, target)
	if not list or not next(list) then
		return nil
	end

	table.sort(list, function (a, b)
		return a < b
	end)

	for _, v in pairs(list) do
		if target < v then
			return v
		end
	end
end

function xyd.getSmaller(list, target)
	if not list or not next(list) then
		return nil
	end

	table.sort(list, function (a, b)
		return b < a
	end)

	for _, v in pairs(list) do
		if v < target then
			return v
		end
	end
end

function xyd.openTipWindow(...)
	local params = {
		...
	}
	local msgType = params[1]

	table.remove(params, 1)
	xyd.MessageController.get():localMessageInsert({
		type = msgType,
		params = params
	})
end

function xyd.random(value1, value2, params)
	local math_random = math.random

	if not value1 and not value2 then
		return math_random()
	else
		value1 = value1 or 0
		value2 = value2 or 0

		if value1 == value2 then
			return value1
		elseif value2 < value1 then
			local tmp = value1
			value2 = value1
			value1 = tmp
		end

		if params and params.int then
			return math_random(value1, value2)
		else
			local delta = value2 - value1
			local value = math_random() * delta + value1

			return value
		end
	end
end

function xyd.setRandomSeed(seed)
end

function xyd.getStringWeight(value)
	local currentIndex = 1
	local res = 0

	while currentIndex <= #value do
		local char = string.byte(value, currentIndex)
		local end_index = currentIndex + xyd.chsize(char) - 1
		local utf8Char = string.sub(value, currentIndex, end_index)
		res = res + xyd.getUnicodeWeight(utf8Char)
		currentIndex = end_index + 1
	end

	return res
end

function xyd.getUnicodeWeight(char)
	local unicodeValue = xyd.utf8ToUnicode(char)

	if unicodeValue >= 17152 and unicodeValue <= 40895 then
		return 2
	elseif unicodeValue >= 12352 and unicodeValue <= 12543 then
		return 2
	elseif unicodeValue >= 44032 and unicodeValue <= 55215 then
		return 2
	else
		return 1
	end
end

function xyd.utf8ToUnicode(str)
	local len2num = {
		0,
		192,
		224,
		240,
		248,
		252
	}
	local firstByte = string.byte(str, 1, 1)
	local len = xyd.chsize(firstByte)
	local res = firstByte - len2num[len]

	for i = 2, len do
		res = res * 64 + string.byte(str, i, i) - 128
	end

	return res
end

function xyd.utf8len(str)
	str = tostring(str)
	local len = 0
	local currentIndex = 1

	while currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		currentIndex = currentIndex + xyd.chsize(char)
		len = len + 1
	end

	return len
end

function xyd.subUft8Len(str, length)
	str = tostring(str)
	local len = 0
	local currentIndex = 1
	local tmpStr = str

	while currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		currentIndex = currentIndex + xyd.chsize(char)
		len = len + 1

		if length <= len then
			tmpStr = string.sub(str, 1, currentIndex - 1)

			break
		end
	end

	return tmpStr
end

function xyd.getDayStartTime(time)
	local tm = os.date("!*t", time)
	time = time - (tm.hour * 3600 + tm.min * 60 + tm.sec)

	return time
end

function xyd.setUI2DSpriteSize(sprite, size, baseOnHeight)
	local sp = sprite.sprite
	local rect = sp.bounds
	local w = rect.extents.x * 2
	local h = rect.extents.y * 2

	if not baseOnHeight then
		local scaleFactor = size / w
		local trans = sprite.transform
		trans.localScale = Vector3.one * scaleFactor
	else
		local scaleFactor = size / h
		local trans = sprite.transform
		trans.localScale = Vector3.one * scaleFactor
	end
end

function xyd.getAndAddComponent(go, ctype)
	local component = go:GetComponent(typeof(ctype))
	component = component or go:AddComponent(typeof(ctype))

	return component
end

function xyd.setContainerChild(container, active)
	local childCount = container.transform.childCount

	for i = childCount, 1, -1 do
		local go = container.transform:GetChild(i - 1)

		go:SetActive(active)
	end
end

function xyd.openWindow(windowName, params, callback)
	local wnd = xyd.WindowManager.get():openWindow(windowName, params, callback)

	return wnd
end

function xyd.closeWindow(windowName)
	xyd.WindowManager.get():closeWindow(windowName)
end

function xyd.getWindow(windowName)
	return xyd.WindowManager.get():getWindow(windowName)
end

function xyd.setNormalBtnBehavior(go, self, func)
	if tolua.isnull(go) then
		return
	end

	UIEventListener.Get(go).onPress = function (go, isPressed)
		if isPressed then
			xyd.useFilter(go, xyd.FILTER.darkFilter)
		else
			xyd.removeFilter(go)

			if func then
				func(self)
			end
		end
	end
end

function xyd.setDarkenBtnBehavior(go, self, func, pressed_func)
	if tolua.isnull(go) then
		return
	end

	if not go:GetComponent(typeof(UIButtonScale)) then
		go:AddComponent(typeof(UIButtonScale))
	end

	local tScale = go.transform.localScale

	if pressed_func then
		UIEventListener.Get(go).onPress = function (go, isPressed)
			if pressed_func then
				pressed_func(self, isPressed)
			end
		end
	end

	UIEventListener.Get(go).onClick = function ()
		if func then
			func(self)
		end
	end
end

function xyd.setBreathBtnBehavior(go, self, func)
	if tolua.isnull(go) then
		return
	end

	local tScale = go.transform.localScale
	local sequence = DG.Tweening.DOTween.Sequence()

	sequence:Append(go.transform:DOScale(tScale * 1.1, 0.5))
	sequence:SetLoops(-1, DG.Tweening.LoopType.Yoyo)

	UIEventListener.Get(go).onPress = function (go, isPressed)
		if isPressed then
			xyd.useFilter(go, xyd.FILTER.darkFilter)
		else
			xyd.removeFilter(go)

			if func then
				func(self)
			end
		end
	end

	return sequence
end

function xyd.shuffleArray(array, randDoubleFunc)
	local i = #array - 1

	while i > 0 do
		local j = math.floor(randDoubleFunc() * (i + 1))
		local tmp = array[i + 1]
		array[i + 1] = array[j + 1]
		array[j + 1] = tmp
		i = i - 1
	end
end

function xyd.getAngleWithCamera(pos1, pos2)
	local diffX = pos1.x - pos2.x
	local diffY = pos1.y - pos2.y

	return 360 * math.atan2(diffY, diffX) / (2 * math.pi)
end

function xyd.getAngle(pos1, pos2)
	local diffX = pos2.x - pos1.x
	local diffY = pos2.y - pos1.y

	return 360 * math.atan2(-diffY, diffX) / (2 * math.pi)
end

function xyd.getRotation(pos1, pos2)
	return -xyd.getAngle(pos1, pos2) + 90
end

function xyd.useFilter(go, filter)
	local sprites = go:GetComponentsInChildren(typeof(UISprite))

	for i = 0, sprites.Length - 1 do
		local sprite = sprites[i]
		sprite.color = filter
	end
end

function xyd.removeFilter(go)
	local sprites = go:GetComponentsInChildren(typeof(UISprite))

	for i = 0, sprites.Length - 1 do
		local sprite = sprites[i]
		sprite.color = Color.New(1, 1, 1, 1)
	end
end

function xyd.isRepeateAnimation(anim)
	for _, v in ipairs(xyd.repeatAnim) do
		if anim == v then
			return true
		end
	end

	return false
end

function xyd.hasAnimationClip(id, anim)
	if not xyd.ClipConstants[id] then
		return false
	end

	for _, v in ipairs(xyd.ClipConstants[id]) do
		if anim == v then
			return true
		end
	end

	return false
end

function xyd.secondsNoHourToTimeString(seconds)
	local day = math.floor(seconds / xyd.DAY)
	local hour = math.floor(seconds % xyd.DAY / xyd.HOUR)
	local minute = math.floor(seconds % xyd.HOUR / xyd.MINUTE)
	local second = seconds % xyd.MINUTE
	local secondString = ""

	if hour > 0 then
		if hour < 10 then
			secondString = secondString .. "0"
		end

		secondString = secondString .. hour .. ":"
	end

	if minute < 10 then
		secondString = secondString .. "0"
	end

	secondString = secondString .. minute .. ":"

	if second < 10 then
		secondString = secondString .. "0"
	end

	secondString = secondString .. second

	return secondString
end

function xyd.secondsNoDayToTimeString(seconds)
	local hour = math.floor(seconds / xyd.HOUR)
	local minute = math.floor(seconds % xyd.HOUR / xyd.MINUTE)
	local second = seconds % xyd.MINUTE
	local secondString = ""

	if hour > 0 then
		secondString = secondString .. hour .. ":"
	end

	if minute < 10 then
		secondString = secondString .. "0"
	end

	secondString = secondString .. minute .. ":"

	if second < 10 then
		secondString = secondString .. "0"
	end

	secondString = secondString .. second

	return secondString
end

function xyd.scb(obj, callback)
	return function (...)
		if type(obj) == "userdata" then
			if not tolua.isnull(obj) and callback ~= nil then
				callback(...)
			end
		elseif obj and callback ~= nil then
			callback(...)
		end
	end
end

function xyd.deepCopy(obj)
	local SearchTable = {}

	local function Func(obj)
		if type(obj) ~= "table" then
			return obj
		end

		local NewTable = {}
		SearchTable[obj] = NewTable

		for k, v in pairs(obj) do
			NewTable[Func(k)] = Func(v)
		end

		return setmetatable(NewTable, getmetatable(obj))
	end

	return Func(obj)
end

function xyd.setAppEntryAudioListener(use)
	local appEntry = UnityEngine.Object.FindObjectOfType(typeof(XYDApp))

	if not tolua.isnull(appEntry) then
		local audioListener = appEntry:GetComponent(typeof(UnityEngine.AudioListener))

		if not tolua.isnull(audioListener) then
			audioListener.enabled = use
		end
	end
end

function xyd.setCameraManagerAudioListener(use)
	local cameraManager = UnityEngine.GameObject.FindGameObjectWithTag("CameraManager")

	if not tolua.isnull(cameraManager) then
		local audioListener = cameraManager:GetComponent(typeof(UnityEngine.AudioListener))

		if not tolua.isnull(audioListener) then
			audioListener.enabled = use
		end
	end
end

function xyd.stringFormat(formatStr, ...)
	local inargs = {
		...
	}
	local args = {}
	local ordinals = {}

	for num in formatStr:gmatch("{(%d+)}") do
		table.insert(ordinals, tonumber(num))
	end

	formatStr = string.gsub(formatStr, "{%d+}", "%%s")

	for _, index in ipairs(ordinals) do
		table.insert(args, inargs[index] or "")
	end

	local res = string.format(formatStr, unpack(args))

	return res
end

function xyd.arrayEqual(a, b)
	if a and b and #a == #b then
		for i = 1, #a do
			if a[i] ~= b[i] then
				return false
			end
		end

		return true
	end

	return false
end

function xyd.applyDark(sprite)
	sprite.color = Color.New(0.7, 0.7, 0.7, 1)
end

function xyd.applyGrey(sprite)
	sprite.color = Color.New(0, 0, 0, 1)
end

function xyd.applyOrigin(sprite)
	sprite.color = Color.New(1, 1, 1, 1)
end

function xyd.applyBright(sprite)
	sprite.color = Color.new(1, 1, 1, 1)
end

function xyd.applyChildrenDark(go)
	XYDUtils.UseFilter(go, Color.New(0.7, 0.7, 0.7, 1))
end

function xyd.applyChildrenOrigin(go)
	XYDUtils.ApplyChildrenOrigin(go)
end

function xyd.applyChildrenGrey(go)
	XYDUtils.ApplyChildrenGrey(go)
end

function xyd.arrayIndexOf(tb, elem)
	if not tb then
		return -1
	end

	for i, v in ipairs(tb) do
		if v == elem then
			return i
		end
	end

	return -1
end

function xyd.getQualityColor(quality)
	local color = nil

	if quality == 1 then
		color = Color.New2(6933759)
	elseif quality == 2 then
		color = Color.New2(4071227647.0)
	elseif quality == 3 then
		color = Color.New2(2452081919.0)
	elseif quality == 4 then
		color = Color.New2(915996927)
	elseif quality == 5 then
		color = Color.New2(3422556671.0)
	elseif quality == 6 then
		color = Color.New2(3613720831.0)
	elseif quality == 7 then
		color = Color.New2(3980891135.0)
	else
		color = Color.New2(4294967295.0)
	end

	return color
end

function xyd.getQualityColor2(quality)
	local color = nil

	if quality == 1 then
		color = "0069cc"
	elseif quality == 2 then
		color = "f2aa00"
	elseif quality == 3 then
		color = "9227cc"
	elseif quality == 4 then
		color = "369900"
	elseif quality == 5 then
		color = "cc0011"
	elseif quality == 6 then
		color = "d76500"
	else
		color = "ffffff"
	end

	return color
end

function xyd.labelQulityColor(label, tableID)
	local quality = xyd.tables.itemTable:getQuality(tableID)
	label.color = xyd.getQualityColor(quality)
end

function xyd.showRechargeAward(id, items)
	local skins = {}

	for i = 1, #items do
		if xyd.tables.itemTable:getType(items[i].item_id) == xyd.ItemType.SKIN then
			for j = 1, items[i].item_num do
				table.insert(skins, items[i].item_id)
			end
		end
	end

	local function effect_callback()
		xyd.WindowManager.get():openWindow("recharge_award_window", {
			giftbag_id = id,
			items = items
		})
	end

	if #skins > 0 then
		xyd.onGetNewPartnersOrSkins({
			destory_res = false,
			skins = skins,
			callback = effect_callback
		})
	else
		effect_callback()
	end
end

function xyd.getLabel(params)
	local uiRoot = params.uiRoot
	local go = ResCache.AddGameObject(uiRoot, "Prefabs/Components/base_label")
	local label = go:GetComponent(typeof(UILabel))
	local baseDepth = uiRoot:GetComponent(typeof(UIWidget)).depth
	label.depth = baseDepth + 1

	go:SetLocalPosition(params.x or 0, params.y or 0, 0)

	if params.w then
		label.width = params.w
	end

	if params.h then
		label.height = params.h
	end

	if params.s then
		label.fontSize = params.s
	end

	if params.c then
		label.color = Color.New2(params.c)
	end

	if params.t then
		label.text = params.t
	end

	if params.b then
		label.fontStyle = UnityEngine.FontStyle.Bold
	else
		label.fontStyle = UnityEngine.FontStyle.Normal
	end

	if params.p then
		label.pivot = params.p
	end

	if params.ec then
		label.effectStyle = UILabel.Effect.Outline
		label.effectDistance = Vector2(1, 1)
		label.effectColor = Color.New2(params.ec)
	end

	if params.spacingY then
		label.spacingY = params.spacingY
	end

	if params.alignment then
		label.alignment = params.alignment
	end

	return label
end

function xyd.setBgColorType(btn, bgType)
	local label = btn:ComponentByName("button_label", typeof(UILabel))
	local sp = btn:GetComponent(typeof(UISprite))

	xyd.setUISprite(sp, xyd.Atlas.COMMON_Btn, bgType)

	label.effectStyle = UILabel.Effect.Outline8
	label.effectDistance = Vector2(2, 2)

	if bgType == xyd.ButtonBgColorType.shop_green_btn then
		label.color = Color.New2(4093310975.0)
		label.effectColor = Color.New2(92095743)
		label.fontSize = 28
	elseif bgType == xyd.ButtonBgColorType.blue_btn_65_65 then
		label.color = Color.New2(4294967295.0)
		label.effectColor = Color.New2(1012112383)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.red_btn_65_65 then
		label.color = Color.New2(4294967295.0)
		label.effectColor = Color.New2(2621259263.0)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.white_btn_65_65 then
		label.color = Color.New2(960513791)
		label.effectColor = Color.New2(4294967295.0)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.blue_btn_60_60 then
		label.color = Color.New2(4294967295.0)
		label.effectColor = Color.New2(1012112383)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.white_btn_60_60 then
		label.color = Color.New2(960513791)
		label.effectColor = Color.New2(4294967295.0)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.blue_btn_70_70 then
		label.color = Color.New2(4294967295.0)
		label.effectColor = Color.New2(1012112383)
		label.fontSize = 25
	elseif bgType == xyd.ButtonBgColorType.white_btn_70_70 then
		label.color = Color.New2(960513791)
		label.effectColor = Color.New2(4294967295.0)
		label.fontSize = 25
	end
end

function xyd.setBtnLabel(btn, params)
	if not params then
		return
	end

	local labelName = params.name or "button_label"
	local label = btn:ComponentByName(labelName, typeof(UILabel))

	xyd.setLabel(label, params)
end

function xyd.setLabel(label, params)
	if not params then
		return
	end

	if params.color and params.color > 0 then
		label.color = Color.New2(params.color)
	end

	if params.stroke and params.stroke > 0 then
		label.effectStyle = UILabel.Effect.Outline
		label.effectDistance = Vector2(1, 1)
	end

	if params.strokeColor and params.strokeColor > 0 then
		label.effectColor = Color.New2(params.strokeColor)
	end

	if params.text then
		label.text = params.text
	end

	if params.textColor then
		label.color = Color.New2(params.textColor)
	end

	if params.size then
		label.fontSize = params.size
	end

	if params.fontFamily then
		label.fontStyle = params.fontFamily
	end

	if params.stroke_none then
		label.effectStyle = UILabel.Effect.None
	end

	if params.textAlign then
		label.alignment = params.textAlign
	end
end

function xyd.alertItems(items, callback, title, des, sortFunc)
	local tmpData = {}
	local starData = {}

	for _, item in ipairs(items) do
		local itemID = item.item_id

		if tmpData[itemID] == nil then
			tmpData[itemID] = 0
		end

		starData[itemID] = item.star
		tmpData[itemID] = tmpData[item.item_id] + item.item_num
	end

	local datas = {}

	for k, v in pairs(tmpData) do
		table.insert(datas, {
			item_id = tonumber(k),
			item_num = v,
			star = starData[k]
		})
	end

	if sortFunc then
		table.sort(datas, sortFunc)
	end

	local params = {
		items = datas,
		callback = callback,
		title = title
	}

	if des then
		params.des = des

		xyd.openWindow("alert_items_with_des_window", params)

		return
	end

	if #datas == 1 then
		xyd.WindowManager.get():openWindow("alert_award_window", params)
	else
		xyd.WindowManager.get():openWindow("alert_item_window", params)
	end
end

function xyd.checkHasMarriedAndNotice(partners, callback)
	local found = false

	for _, partner in pairs(partners) do
		if partner and partner.is_vowed == 1 then
			found = true

			xyd.alert(xyd.AlertType.YES_NO, __("VOW_SWAP_TIPS"), function (yes_no)
				if yes_no then
					callback()
				end
			end)

			break
		end
	end

	if not found then
		callback()
	end
end

function xyd.checkCondition(bool, a, b)
	if bool then
		return a
	end

	return b
end

function xyd.getTweenAlphaGeterSeter(w)
	local function getter()
		return w.color
	end

	local function setter(color)
		w.color = color
	end

	return getter, setter
end

function xyd.getTweenAlpha(w, finalAlpha, t, window)
	local function getter()
		return w.color
	end

	local function setter(color)
		w.color = color
	end

	local tween_ = DG.Tweening.DOTween.ToAlpha(getter, setter, finalAlpha, t)

	if window then
		window:addSequene(tween_)
	end

	return tween_
end

function xyd.showLockTips(partner)
	local lock = partner:getLockTypes()

	if #lock > 0 then
		local totalStr = xyd.split(__("LOCK_PARTNER_TIPS"), "|")

		for i = 1, #lock do
			lock[i] = totalStr[lock[i]]
		end

		local str = table.concat(lock, "\n")

		xyd.alert(xyd.AlertType.TIPS, str)

		return true
	end

	return false
end

function xyd.checkLast(partner)
	local lock = partner:getLockTypes()

	for i = 1, #lock do
		local lockState = lock[i] - 1

		if lockState == 1 then
			local list = xyd.models.arena:getDefFormation()

			if #list <= 1 then
				return true
			end
		elseif lockState == 2 then
			local cnt = {}
			local info = xyd.models.arena3v3:getDefFormation()
			local teams = {}

			for i = 1, 3 do
				if not cnt[i] then
					cnt[i] = 0
				end

				local res = {}

				for j = (i - 1) * 6 + 1, i * 6 do
					if info[j] then
						res[j] = info[j]
						cnt[i] = cnt[i] + 1
					end
				end

				teams[i] = {
					partners = res
				}
			end

			for i = 1, 3 do
				for j = (i - 1) * 6 + 1, i * 6 do
					if teams[i].partners[j] and teams[i].partners[j].partner_id == partner:getPartnerID() and cnt[i] <= 1 then
						return true
					end
				end
			end
		elseif lockState == 3 then
			local list = xyd.models.arenaTeam:getDefFormation()

			if #list <= 1 then
				return true
			end
		elseif lockState == 9 then
			local list = xyd.models.arenaAllServerScore:getDefFormation().partners or {}
			local found = false

			for i = 1, #list do
				if list[i].partner_id == partner:getPartnerID() then
					found = true

					break
				end
			end

			if #list <= 1 and found then
				return true
			end
		end
	end

	return false
end

function xyd.checkDateLock(partner)
	local lock = partner:getLockTypes()

	for i = 1, #lock do
		if lock[i] == 5 then
			return true
		end
	end

	return false
end

function xyd.checkHouseLock(partner)
	local lock = partner:getLockTypes()

	for i = 1, #lock do
		if lock[i] == xyd.PartnerFlag.HOUSE then
			return true
		end
	end

	return false
end

function xyd.partnerUnlock(partner)
	local lock = partner:getLockTypes()
	local succeed = false

	if #lock <= 0 then
		return
	end

	for i = 1, #lock do
		local result = nil
		local lockState = lock[i] - 1

		if lockState == 0 then
			result = xyd.partnerManualUnlock(partner)
		elseif lockState == 1 then
			result = xyd.partnerArenaUnlock(partner)
		elseif lockState == 2 then
			result = xyd.partnerArena3v3Unlock(partner)
		elseif lockState == 3 then
			result = xyd.partnerArenaTeamUnlock(partner)
		elseif lockState == 4 then
			-- Nothing
		elseif lockState == 5 then
			result = xyd.partnerHouseUnlock(partner)
		elseif lockState == 6 then
			result = xyd.partnerExploreTrainingUnlock(partner)
		elseif lockState == 7 then
			result = xyd.partnerExploreMinorUnlock(partner)
		elseif lockState == 9 then
			result = xyd.partnerArenaAllServerScoreUnlock(partner)
		end

		if result then
			partner:setLock(0, lock[i])
		end

		succeed = succeed and succeed or result
	end

	return succeed
end

function xyd.partnerManualUnlock(partner)
	partner:lock(false)

	return true
end

function xyd.partnerArenaUnlock(partner)
	local info = xyd.models.arena:getDefFormation()
	local team = {}
	local found = false

	for i = 1, #info do
		table.insert(team, info[i])
	end

	if #team <= 1 then
		return false
	end

	for i = 1, #team do
		if team[i].partner_id == partner:getPartnerID() then
			found = true

			table.remove(team, i)

			break
		end
	end

	local msg = messages_pb:set_partners_req()

	for i = 1, #team do
		local partner = messages_pb:fight_partner()
		partner.partner_id = team[i].partner_id
		partner.pos = team[i].pos

		table.insert(msg.partners, partner)
	end

	if found then
		xyd.Backend.get():request(xyd.mid.SET_PARTNERS, msg)
	end

	return found
end

function xyd.partnerArena3v3Unlock(partner)
	local info = xyd.models.arena3v3:getDefFormation()
	local teams = {}
	local found = false

	for i = 1, 3 do
		local res = {}

		for j = (i - 1) * 6 + 1, i * 6 do
			if info[j] then
				res[j] = info[j]
			end
		end

		teams[i] = {
			partners = res
		}
	end

	for i = 1, 3 do
		if found then
			break
		end

		for j = (i - 1) * 6 + 1, i * 6 do
			if teams[i].partners[j] and teams[i].partners[j].partner_id == partner:getPartnerID() then
				teams[i].partners[j] = nil
				found = true

				break
			end
		end
	end

	local msg = messages_pb:set_partners_3v3_req()

	for i = 1, 3 do
		local teamOne = messages_pb:set_partners_req()

		for j = (i - 1) * 6 + 1, i * 6 do
			local partner = messages_pb:fight_partner()

			if teams[i].partners[j] then
				partner.partner_id = teams[i].partners[j].partner_id
				partner.pos = teams[i].partners[j].pos

				table.insert(teamOne.partners, partner)
			end
		end

		table.insert(msg.teams, teamOne)
	end

	if found then
		xyd.Backend.get():request(xyd.mid.SET_PARTNERS_3v3, msg)
	end

	return found
end

function xyd.partnerArenaAllServerScoreUnlock(partner)
	local info = xyd.models.arenaAllServerScore:getDefFormation()
	local score = xyd.models.arenaAllServerScore:getScore()
	local rank = xyd.models.arenaAllServerScore:getRank()
	local teams = {}
	local found = false
	local subsitNum = xyd.tables.arenaAllServerRankTable:getSubsitNum(xyd.tables.arenaAllServerRankTable:getRankLevel(score, rank))
	local msg = messages_pb.set_partners_all_server_req()
	local petIDs = info.pet_infos

	for _, petInfo in ipairs(petIDs) do
		if petInfo and tonumber(petInfo.pet_id) > 0 then
			table.insert(msg.pet_ids, tonumber(petInfo.pet_id))
		end
	end

	for i = 1, 6 do
		local oneP = info.partners[i]

		if oneP then
			if oneP.partner_id == partner:getPartnerID() then
				found = true
			else
				local fight_partner = messages_pb.fight_partner()
				fight_partner.partner_id = oneP.partner_id
				fight_partner.pos = oneP.pos

				table.insert(msg.partners, fight_partner)
			end
		end
	end

	if info.front_infos and #info.front_infos > 0 then
		for index, oneP in ipairs(info.front_infos) do
			if oneP.partner_id == partner:getPartnerID() then
				found = true
			elseif index <= subsitNum * 2 then
				table.insert(msg.front_prs, oneP.partner_id)
			end
		end
	end

	if info.back_infos and #info.back_infos > 0 then
		for index, oneP in ipairs(info.back_infos) do
			if oneP.partner_id == partner:getPartnerID() then
				found = true
			elseif index <= subsitNum * 4 then
				table.insert(msg.back_prs, oneP.partner_id)
			end
		end
	end

	if found then
		xyd.Backend.get():request(xyd.mid.SET_PARTNERS_ALL_SERVER, msg)
	end

	return found
end

function xyd.partnerArenaTeamUnlock(partner)
	local info = xyd.models.arenaTeam:getDefFormation()
	local team = {}
	local found = false

	for i = 1, #info do
		table.insert(team, info[i])
	end

	if #team <= 1 then
		return false
	end

	for i = 1, #team do
		if team[i].partner_id == partner:getPartnerID() then
			table.remove(team, i)

			found = true

			break
		end
	end

	local msg = messages_pb:set_arena_team_partners_req()

	for i = 1, #team do
		local partner = messages_pb:fight_partner()
		partner.partner_id = team[i].partner_id
		partner.pos = team[i].pos

		table.insert(msg.partners, partner)
	end

	if found then
		xyd.Backend.get():request(xyd.mid.SET_ARENA_TEAM_PARTNERS, msg)
	end

	return found
end

function xyd.partnerHouseUnlock(partner)
	local info = xyd.models.house:getHeroIDs()
	local found = false
	local ids = {}

	for i = 1, #info do
		if info[i] == partner:getPartnerID() then
			ids[i] = 0
			found = true
		else
			ids[i] = info[i]
		end
	end

	if not found then
		return false
	end

	local msg = messages_pb.house_set_partner_req()

	for i = 1, #ids do
		table.insert(msg.partner_ids, ids[i])
	end

	xyd.Backend.get():request(xyd.mid.HOUSE_SET_PARTNER, msg)

	return true
end

function xyd.partnerExploreTrainingUnlock(partner)
	local lockFlag = partner:getLockFlags()[xyd.PartnerFlag.EXPLORE_TRAINING]

	xyd.models.exploreModel:setTrainPartner(lockFlag % 100, (lockFlag - lockFlag % 100) / 100, 0)

	return true
end

function xyd.partnerExploreMinorUnlock(partner)
	local lockFlag = partner:getLockFlags()[xyd.PartnerFlag.EXPLORE_MINOR]

	xyd.models.exploreModel:setBuildingPartner(lockFlag % 100, (lockFlag - lockFlag % 100) / 100, 0)

	return true
end

function xyd.isItemAbsence(id, need, toast)
	if toast == nil then
		toast = true
	end

	if xyd.models.backpack:getItemNumByID(id) < need then
		if toast then
			xyd.alertTips(__("NOT_ENOUGH", xyd.tables.itemTable:getName(id)))
		end

		return true
	end

	return false
end

function xyd.setTouchEnable(obj, flag)
	local boxCollider = obj:GetComponent(typeof(UnityEngine.BoxCollider))

	if boxCollider then
		boxCollider.enabled = flag
	end
end

function xyd.setEnabled(obj, enable)
	xyd.setTouchEnable(obj, enable)

	obj:GetComponent(typeof(UISprite)).color = xyd.checkCondition(enable, Color.New2(4294967295.0), Color.New2(255))

	if not enable then
		xyd.applyChildrenGrey(obj.gameObject)
	else
		xyd.applyChildrenOrigin(obj.gameObject)
	end
end

function xyd.showToast(tips)
	xyd.alertTips(tips)
end

function xyd.slice(inputArray, startPos, endPos)
	local tmp = {}

	for i = startPos, endPos do
		table.insert(tmp, inputArray[i])
	end

	return tmp
end

function xyd.splice(inputArray, startPos, num)
	local tmp = {}

	for i = 1, #inputArray do
		if i < startPos or i >= startPos + num then
			table.insert(tmp, inputArray[i])
		end
	end

	return tmp
end

function xyd.tableSlice(inputArray, startPos, endPos)
	local tmp = {}

	for i = startPos, endPos do
		table.insert(tmp, inputArray[i])

		inputArray = tmp
	end
end

function xyd.tableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end

	return t1
end

function xyd.tableShift(t)
	local res = {}

	for i = 2, #t do
		table.insert(res, t[i])
	end

	return res
end

function xyd.isToSilentDownLoad()
	if not xyd.needBackUpdate or not xyd.backUpdateParams or xyd.backUpdateParams.need_restart ~= 1 then
		return false
	end

	return true
end

function xyd.openActivityWindow(params)
	if params.activity_type ~= xyd.EventType.LIMIT then
		xyd.WindowManager.get():openWindow("activity_window", params)

		return
	end

	if not xyd.isToSilentDownLoad() or not xyd.GuideController.get():isGuideComplete() then
		xyd.WindowManager.get():openWindow("activity_window", params)

		return
	else
		xyd.alertYesNo(__("NEW_GAME_RESOURCE_LOADED"), function (yes)
			if yes then
				xyd.MainController.get():restartGame()
			end
		end)

		return
	end
end

function xyd.getServerNumber(serverID)
	return xyd.tables.serverMapTable:getIdText(serverID)
end

function xyd.getUpdateTime()
	local serverTime = math.floor(xyd.Global.serverDeltaTime + os.time())

	return 86400 - serverTime % 86400
end

function xyd.itemFloatAni(uiRoot, items)
	for idx, itemInfo in ipairs(items) do
		XYDCo.WaitForFrame(2 * idx, function ()
			local itemFloat = import("app.components.ItemFloat").new(uiRoot)

			itemFloat:setInfo(itemInfo)
			itemFloat:playGetAni()
		end, nil)
	end
end

function xyd.itemFloat(itemsData, callback, parentGo, depth)
	xyd.models.itemFloatModel:pushNewItems(itemsData, callback)
end

function xyd.getGMTWeekDay(time)
	local timeDesc = os.date("!*t", time)
	local weekDay = timeDesc.wday

	if weekDay == 0 then
		weekDay = 7
	end

	return weekDay
end

function xyd.getGMTWeekStartTime(time)
	local timeDesc = os.date("!*t", time)
	local weekDay = timeDesc.wday - 1

	if weekDay == 0 then
		weekDay = 7
	end

	local result = time - ((weekDay - 1) * 86400 + timeDesc.hour * 3600 + timeDesc.min * 60 + timeDesc.sec)

	return result
end

function xyd.getTomorrowTime()
	local selfPlayer = xyd.models.selfPlayer

	return selfPlayer:getTomorrowTime()
end

function xyd.calcTimeToNextWeek()
	local tomorrowTime = xyd.getTomorrowTime()
	local tomorrowWeekDay = os.date("%w", tomorrowTime)

	if tomorrowWeekDay == 0 then
		tomorrowWeekDay = 7
	end

	local modayTime = (8 - tomorrowWeekDay) % 7 * 60 * 60 * 24 + tomorrowTime

	return modayTime
end

function xyd.isTextInValid(text)
	if text == "" or string.find(text, " ") then
		return true
	end

	return false
end

function xyd.showFuncNotOpenGuide(functionID)
	local name_ = xyd.tables.functionTable:getName(functionID)
	local lev = xyd.tables.functionTable:getOpenValue(functionID)
	local wnd = xyd.WindowManager.get():getWindow("main_window")

	if not wnd then
		return
	end

	xyd.alertTips(__("FUNC_OPEN_LEV", lev))
end

function xyd.getCopyData(data)
	local arry = {}

	for _, val in ipairs(data) do
		table.insert(arry, val)
	end

	return arry
end

function xyd.arrayMerge(...)
	local arg = {
		...
	}
	local tt = {}

	for _, t in ipairs(arg) do
		for _, v in ipairs(t) do
			tt[#tt + 1] = v
		end
	end

	return tt
end

function xyd.mouseWorldPos(pos)
	local mousePoS = pos or UnityEngine.Input.mousePosition
	local cameraPos = xyd.WindowManager.get():screenToWorldPoint(Vector3(mousePoS.x, mousePoS.y, 0))

	return cameraPos
end

function xyd.mouseToLocalPos(transform)
	local mousePoS = UnityEngine.Input.mousePosition
	local cameraPos = xyd.WindowManager.get():screenToWorldPoint(Vector3(mousePoS.x, mousePoS.y, 0))
	local mouseLocalPos = transform:InverseTransformPoint(cameraPos)

	return mouseLocalPos
end

function xyd.setDragScrollView(go, scrollView)
	local widget = go:GetComponent(typeof(UIWidget))

	if not widget then
		return
	end

	if not go:GetComponent(typeof(UnityEngine.BoxCollider)) then
		local boxCollider = go:AddComponent(typeof(UnityEngine.BoxCollider))
		boxCollider.size = Vector3(widget.width, widget.height, 0)
	end

	local dragScrollView = go:GetComponent(typeof(UIDragScrollView))
	dragScrollView = dragScrollView or go:AddComponent(typeof(UIDragScrollView))
	dragScrollView.scrollView = scrollView
end

function xyd.getNameStringLength(str)
	str = tostring(str)
	local len = 0
	local currentIndex = 1

	while currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		local size = xyd.chsize(char)
		currentIndex = currentIndex + size

		if size == 3 then
			len = len + 2
		elseif size == 4 then
			len = len + 4
		else
			len = len + 1
		end
	end

	return len
end

function xyd.getStrLength(str)
	str = tostring(str)
	local len = 0
	local currentIndex = 1

	while currentIndex <= #str do
		local char = string.byte(str, currentIndex)
		local size = xyd.chsize(char)
		currentIndex = currentIndex + size

		if size == 3 then
			len = len + 4
		else
			len = len + 1
		end
	end

	return len
end

function xyd.getModelID(tableID, isMonster, skinID, showSkin)
	local modelID = nil

	if skinID and skinID > 0 and showSkin == 1 then
		modelID = xyd.tables.equipTable:getSkinModel(skinID)
	else
		local heroTableID = tableID

		if isMonster then
			heroTableID = xyd.tables.monsterTable:getPartnerLink(tableID)
		end

		modelID = xyd.tables.partnerTable:getModelID(heroTableID)

		if isMonster then
			local tmpSkinID = xyd.tables.monsterTable:getSkin(tableID)

			if tmpSkinID > 0 then
				modelID = xyd.tables.equipTable:getSkinModel(tmpSkinID)
			end
		end
	end

	return modelID
end

function xyd.getModelScale(tableID, isMonster, skinID, showSkin)
	if tableID == xyd.models.selfPlayer.playerID_ then
		return tonumber(xyd.tables.miscTable:getVal("house_senpai_scale"))
	end

	local modelID = xyd.getModelID(tableID, isMonster, skinID, showSkin)
	local scale = xyd.tables.modelTable:getScale(modelID)

	if isMonster then
		scale = scale + xyd.tables.monsterTable:getScale(tableID)
	end

	return scale
end

function xyd.getModelInfo(tableID, isMonster, skinID, showSkin)
	local modelID = xyd.getModelID(tableID, isMonster, skinID, showSkin)
	local scale = xyd.tables.modelTable:getScale(modelID)

	if isMonster then
		scale = scale + xyd.tables.monsterTable:getScale(tableID)
	end

	local name = xyd.tables.modelTable:getModelName(modelID)

	return {
		id = modelID,
		scale = scale,
		name = name
	}
end

function xyd.getModelNameByID(tableID, isMonster, skinID, showSkin)
	local modelID = xyd.getModelID(tableID, isMonster, skinID, showSkin)
	local name = xyd.tables.modelTable:getModelName(modelID)

	return name
end

function xyd.getSenpaiModelResByIDs(dressStyles)
	local resNames = {}

	for _, id in ipairs(dressStyles) do
		local res = xyd.tables.senpaiDressStyleTable:getResource(id)

		if res then
			table.insert(resNames, res)
		end
	end

	return resNames
end

function xyd.getRandomByExceptArry(arry, exceptArry)
	if #arry <= #exceptArry then
		return -1
	end

	local count = 0
	local select = nil

	while not select and count < 500 do
		local index = math.ceil(math.random() * #arry)
		local tmpNum = arry[index]

		if xyd.arrayIndexOf(exceptArry, tmpNum) < 0 then
			select = tmpNum

			break
		end

		count = count + 1
	end

	return select
end

function xyd.getRandoms(ids, num)
	if num > #ids then
		return ids
	end

	local tmps = {}

	for i = 1, #ids do
		table.insert(tmps, ids[i])
	end

	for i = 1, #ids - num do
		local ind = math.random(#tmps)

		table.remove(tmps, ind)
	end

	return tmps
end

function xyd.trim(str)
	return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

function xyd.escapesLuaString(str)
	str = str or ""
	local tmpStr = string.gsub(str, "%%", "%%%%")
	tmpStr = string.gsub(tmpStr, "%+", "%%%+")

	return xyd.trim(tmpStr)
end

function xyd.isResLoad(path)
	return ResManager.IsLocalAsset(path)
end

function xyd.isAllPathLoad(paths)
	return ResManager.IsLocalAssets(paths)
end

function xyd.setTextureByURL(url, uiTexture, width, height, callback, checkFunc, savePath, fileName)
	xyd.WebPictureManager.get():setUITexture(url, uiTexture, width, height, callback, checkFunc, savePath, fileName)
end

function xyd.fitFullScreen(obj)
	local height = 1024
	local width = 657
	local screen = UnityEngine.Screen
	local realHeight = math.min(xyd.Global.getMaxBgHeight(), screen.height)
	local scale1 = height / realHeight
	local scale2 = width / xyd.Global.getRealWidth()
	local scale = math.min(scale1, scale2)
	obj.width = width / scale
	obj.height = height / scale

	if realHeight <= xyd.Global.getMaxHeight() then
		obj:SetLocalPosition(0, 0, 0)
	else
		obj:SetLocalPosition(0, 7, 0)
	end

	return scale
end

function xyd.fitFullScreen2(obj)
	local common_scaling = 1.7777777777777777
	local screen = UnityEngine.Screen
	local screen_scaling = screen.height / screen.width

	if common_scaling <= screen_scaling then
		local stageHeight = xyd.Global.getRealHeight()
		local real_scaling = xyd.Global.getRealHeight() / xyd.Global.getRealWidth()

		if screen_scaling > real_scaling then
			stageHeight = stageHeight * screen_scaling / real_scaling
		end

		obj.width = stageHeight
		obj.height = stageHeight
	else
		local scale = xyd.Global.getRealWidth() / 647
		obj.width = 1024 * scale
		obj.height = 1024 * scale

		if obj.height < 1280 then
			obj.height = 1280
			obj.width = 1280
		end
	end
end

function xyd.getEffectFilesByNames(names)
	local arry = {}

	for _, name in ipairs(names) do
		local path = xyd.EffectConstants[name]

		if path then
			table.insert(arry, path)
		end
	end

	return arry
end

function xyd.splitOneChar(list, tmpStr, color)
	local curStrPos = 1

	while curStrPos <= #tmpStr do
		local count = 1
		local c = string.sub(tmpStr, curStrPos, curStrPos)

		if c then
			if string.byte(c) > 128 then
				count = 3
				c = string.sub(tmpStr, curStrPos, curStrPos + 2)
			end

			if color then
				c = string.format("[c][%s]%s[-][/c]", color, c)
			end

			table.insert(list, c)
		end

		curStrPos = curStrPos + count
	end
end

function xyd.getColorLabelList(str)
	local list = {}
	str = string.gsub(str, "%[c%]", "")
	str = string.gsub(str, "%[/c%]", "")
	local strList = string.split(str, "[-]")

	for i = 1, #strList do
		local curStr = strList[i]
		local curStrList = string.split(curStr, "[")

		for j = 1, #curStrList do
			if string.find(curStrList[j], "]") then
				local tmpList = string.split(curStrList[j], "]")
				local color = tmpList[1]
				local tmpStr = tmpList[2]

				xyd.splitOneChar(list, tmpStr, color)
			else
				xyd.splitOneChar(list, curStrList[j])
			end
		end
	end

	return list
end

function xyd.uploadBinaryData(url, fileNameArr, bytesArr, callback)
	local function complete(success)
		if callback ~= nil then
			callback(success)
		end
	end

	local function onWebResponse(response)
		if not response.IsSuccess then
			local state = response.ReqState

			__TRACE(state)
			complete(false)

			return
		end

		local code = response.StatusCode
		local text = response.DataAsText
		local cjson = require("cjson")
		local data = cjson.decode(text)

		if data and data.is_ok then
			complete(true)
		else
			complete(false)
		end
	end

	local request = HttpRequest.Request(url, "POST")

	for i = 1, #fileNameArr do
		request:AddField("filename" .. i, fileNameArr[i])
		request:AddBinaryData("binarydata", bytesArr[i], fileNameArr[i], "multipart/form-data")
	end

	request:SetTimeout(30)
	request:AddCallback(onWebResponse)
	request:Send()
end

function xyd.uploadGMImgURL()
	return "https://xuemeih5upload.xunmenginc.com/upload_gm_img"
end

function xyd.downloadGMImgURL()
	return "https://yottacdn.akamaized.net/xuemeih5res/gm-img/"
end

function xyd.getHomeAPIUrl(lastName)
	return "https://mhome.carolgames.com/home_api/" .. lastName
end

function xyd.arrayIndexOf(table, id)
	for idx, info in ipairs(table) do
		if info == id then
			return idx
		end
	end

	return -1
end

function xyd.getBpLev()
	local exp = xyd.models.backpack:getItemNumByID(xyd.ItemID.BP_EXP)
	local battlePassAwardTable = xyd.models.activity:getBattlePassTable(xyd.BATTLE_PASS_TABLE.AWARD)

	return tonumber(battlePassAwardTable:getLevByExp(exp))
end

function xyd.getBpNowExp()
	local nowAndMax = {}
	local lev = xyd.getBpLev()
	local battlePassAwardTable = xyd.models.activity:getBattlePassTable(xyd.BATTLE_PASS_TABLE.AWARD)
	local exp = xyd.models.backpack:getItemNumByID(xyd.ItemID.BP_EXP) - battlePassAwardTable:getCostTotal(lev)
	local max = battlePassAwardTable:getCostExp(lev)[2]

	if max and max < exp then
		exp = max
	end

	table.insert(nowAndMax, exp)
	table.insert(nowAndMax, max)

	return nowAndMax
end

function xyd.isHasNew5Stars(event, collectionBefore)
	collectionBefore = collectionBefore or {}
	local Partner = import("app.models.Partner")
	local partners = {}

	if event.data.summon_result then
		partners = event.data.summon_result.partners
	else
		partners = event.data.partners
	end

	local new5stars = {}

	for i = 1, #partners do
		local np = Partner.new()

		np:populate(partners[i])

		if np:getStar() == 5 and not collectionBefore[np:getTableID()] or xyd.arrayIndexOf(xyd.split(xyd.tables.miscTable:getVal("activity_gacha_partner_show", "|", true)), np:getTableID()) > 0 then
			table.insert(new5stars, partners[i])
		end
	end

	return new5stars
end

function xyd.isHasNew5Stars2(items, collectionBefore)
	local partners = {}
	local new5stars = {}
	local Partner = import("app.models.Partner")

	for _, itemInfo in ipairs(items) do
		local itemID = itemInfo.item_id
		local iconType = xyd.tables.itemTable:getType(itemID)

		if iconType == xyd.ItemType.HERO then
			table.insert(partners, itemID)
		end
	end

	local targetIds = xyd.split(xyd.tables.miscTable:getVal("activity_gacha_partner_show", "|", true))

	for i = 1, #partners do
		local np = Partner.new()

		np:populate({
			table_id = partners[i]
		})

		if np:getStar() == 5 and not collectionBefore[np:getTableID()] or xyd.arrayIndexOf(targetIds, np:getTableID()) > 0 then
			table.insert(new5stars, partners[i])
		end
	end

	return new5stars
end

function xyd.onGetNewPartnersOrSkins(params, collection)
	local collection_ = collection or {}

	if params.skins then
		local hasSkins = xyd.models.backpack:getSkinCollect()
		local skins = {}

		for i = 1, #params.skins do
			if not hasSkins[params.skins[i]] then
				table.insert(skins, params.skins[i])
			end
		end

		params.skins = skins
		local callback = params.callback

		function params.callback()
			xyd.models.backpack:updateSkinCollect()

			if callback then
				callback()
			end
		end
	end

	if params.partners and not params.showRepeat then
		local partners = {}

		for i = 1, #params.partners do
			if not collection_[params.partners[i]] then
				table.insert(partners, params.partners[i])
			end
		end

		params.partners = partners
	end

	if params.partners and #params.partners > 0 or params.skins and #params.skins > 0 then
		xyd.WindowManager.get():openWindow("summon_effect_res_window", params)
	elseif params.callback then
		params.callback()
	end
end

function xyd.getRoughDisplayHTime(time)
	local hour = math.floor(time / 3600)

	if hour > 0 then
		return hour .. "h"
	end
end

function xyd.getSoundPath(id)
	if xyd.tables.soundTable:getRes(id) == nil then
		return nil
	end

	local path = "Sounds/" .. xyd.tables.soundTable:getRes(id)

	return path
end

function xyd.decodeProtoBuf(msg)
	local text_format = require("protobuf.text_format")

	return text_format.msg_decode(msg)
end

function xyd.getPicturePath(showID, partner)
	if not showID and partner then
		showID = partner:getShowID()
		showID = showID or partner:getTableID()
	end

	local dragonBoneID = xyd.tables.partnerPictureTable:getDragonBone(showID)
	local files = {}

	if dragonBoneID and dragonBoneID ~= 0 then
		local resName = xyd.tables.girlsModelTable:getResource(dragonBoneID)
		files = xyd.getEffectFilesByNames({
			resName
		})
	else
		files = {
			xyd.getTexturePath(xyd.tables.partnerPictureTable:getPartnerPic(showID))
		}
	end

	return files[1]
end

function xyd.isSubscription()
	if xyd.models.gMcommand:subScription() then
		return xyd.models.gMcommand:subScription()
	end

	local subscriptionData = xyd.models.activity:getActivity(xyd.ActivityID.SUBSCRIPTION)
	local giftBagIDs = subscriptionData.detail.charge_ids

	if UNITY_IOS then
		if xyd.arrayIndexOf(giftBagIDs, xyd.GIFTBAG_ID.WEEK_SUBSCRIPTION) >= 0 then
			return xyd.APP_VERSION.Subscription
		else
			return xyd.APP_VERSION.ManaSubscription
		end
	end

	if UNITY_ANDROID then
		if xyd.arrayIndexOf(giftBagIDs, xyd.GIFTBAG_ID.WEEK_SUBSCRIPTION) >= 0 then
			return xyd.APP_VERSION.AND_Subscription
		else
			return xyd.APP_VERSION.ManaCard
		end
	end

	return xyd.APP_VERSION.ManaCard
end

function xyd.addTextInput(label, params)
	xyd.models.textInput:addInputEvent(label, params)
end

function xyd.setTextInputAtt(input)
end

function xyd.isSameDay(time1, time2, isLocal)
	local date1, date2 = nil

	if isLocal then
		date1 = os.date("*t", time1)
		date2 = os.date("*t", time2)
	else
		date1 = os.date("!*t", time1)
		date2 = os.date("!*t", time2)
	end

	if tonumber(date1.year) ~= tonumber(date2.year) or tonumber(date1.month) ~= tonumber(date2.month) or tonumber(date1.day) ~= tonumber(date2.day) then
		return false
	else
		return true
	end
end

function xyd.getFightPartnerMsg(msg, partners)
	for i = 1, #partners do
		local item = messages_pb.fight_partner()
		item.partner_id = partners[i].partner_id
		item.pos = partners[i].pos

		table.insert(msg, item)
	end
end

function xyd.getTimeKey()
	xyd.Global.waitForTimeKey = xyd.Global.waitForTimeKey + 1

	return tostring(xyd.Global.waitForTimeKey)
end

function xyd.checkRedMarkSetting(redMarkType)
	if not xyd.GuideController.get():isGuideComplete() then
		return false
	end

	local redMarkIds = xyd.tables.deviceRedMarkTable:getIDs()
	local redMarkId = nil

	for i in pairs(redMarkIds) do
		local id = redMarkIds[i]
		local redMarkTypes = xyd.tables.deviceRedMarkTable:getRedMarkTypes(id)

		if xyd.arrayIndexOf(redMarkTypes, redMarkType) >= 0 then
			redMarkId = id

			break
		end
	end

	if not redMarkId then
		return true
	end

	if xyd.models.deviceNotify:isRedMarkUp(redMarkId) then
		return true
	else
		return false
	end
end

function xyd.addGlobalTimer(callBack, timeDis, alltimes)
	return xyd.models.selfPlayer:addGlobalTimer(callBack, timeDis, alltimes)
end

function xyd.removeGlobalTimer(keyId)
	xyd.models.selfPlayer:removeGlobalTimer(keyId)
end

function xyd.checkPartnerRedMark(partnerId, redMarkType)
	local redParams = xyd.models.redMark:getRedMarkParams(redMarkType)

	if redParams == nil then
		return false
	end

	local npList = redParams.npList or {}

	if xyd.arrayIndexOf(npList, partnerId) > -1 then
		if xyd.checkRedMarkSetting(redMarkType) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function xyd.changeScrollViewMove(scroll_obj, state, resetPos, resetClipOffset)
	if scroll_obj == nil then
		return
	end

	local scroll_uiScrollView = scroll_obj:GetComponent(typeof(UIScrollView))
	local scroll_springPanel = scroll_obj:GetComponent(typeof(SpringPanel))
	local scroll_uiPanel = scroll_obj:GetComponent(typeof(UIPanel))

	if state == false then
		scroll_uiScrollView.isLateUpdateMoveTween = false

		if scroll_springPanel ~= nil then
			scroll_springPanel.isUpdateMoveBack = false
			scroll_springPanel.target = resetPos
		end

		if resetPos ~= nil then
			scroll_obj:SetLocalPosition(resetPos.x, resetPos.y, resetPos.z)
		end

		if resetClipOffset ~= nil then
			scroll_uiPanel.clipOffset = resetClipOffset
		end
	else
		if scroll_springPanel ~= nil then
			scroll_springPanel.isUpdateMoveBack = true
		end

		scroll_uiScrollView.isLateUpdateMoveTween = true
	end
end

function xyd.getPartnerInfo(partner_info)
	local params = {
		table_id = partner_info.table_id,
		partner_id = partner_info.partner_id,
		level = partner_info.level,
		awake = partner_info.awake
	}

	if partner_info.equips and tostring(partner_info.equips) ~= "" then
		params.equips = {}

		for _, equip in ipairs(partner_info.equips) do
			table.insert(params.equips, equip)
		end
	end

	params.grade = partner_info.grade
	params.flags = partner_info.flags
	params.create_time = partner_info.create_time
	params.pos = partner_info.pos
	params.power = partner_info.power

	if partner_info.status and tostring(partner_info.status) ~= "" then
		params.status = {
			hp = partner_info.status.hp,
			mp = partner_info.status.mp,
			pos = partner_info.status.pos,
			true_hp = partner_info.status.true_hp
		}
	end

	params.show_skin = partner_info.show_skin
	params.tmp_treasure = partner_info.tmp_treasure
	params.show_id = partner_info.show_id
	params.love_point = partner_info.love_point
	params.last_love_point_time = partner_info.last_love_point_time
	params.guaji_love_point = partner_info.guaji_love_point
	params.is_vowed = partner_info.is_vowed
	params.wedding_date = partner_info.wedding_date
	params.potentials = partner_info.potentials

	return params
end

function xyd.check2TableSame(t1, t2)
	if #t1 ~= #t2 then
		return false
	end

	local flag = true

	for i = 1, #t1 do
		if t1[i] ~= t2[i] then
			flag = false

			break
		end
	end

	return flag
end

function xyd.isToday(time)
	local date = os.date("%y/%m/%d", time)
	local nowDate = os.date("%y/%m/%d", xyd.getServerTime())

	if date == nowDate then
		return true
	end

	return false
end

function xyd.getStoryLoadRes(storyID, storyType, bigPics_, effectNames_)
	print(debug.traceback())

	local subStoryIDs_ = {}
	local res_ = {}
	local oldIDs = {}
	local coun_ = 0

	local function pushRes(arry, path_, prePath)
		prePath = prePath or ""

		if path_ and path_ ~= "" and xyd.arrayIndexOf(arry, prePath .. path_) < 0 then
			table.insert(arry, prePath .. path_)
		end
	end

	local storyTable = nil

	if storyType == xyd.StoryType.PARTNER then
		storyTable = xyd.tables.partnerPlotTable
	elseif storyType == xyd.StoryType.MAIN then
		storyTable = xyd.tables.mainPlotTable
	elseif storyType == xyd.StoryType.ACTIVITY then
		storyTable = xyd.tables.storyTable
	elseif storyType == xyd.StoryType.OLD_PLAYER_BACK then
		storyTable = xyd.tables.playerReturnStoryTable
	elseif storyType == xyd.StoryType.OTHER then
		storyTable = xyd.tables.partnerWarmUpPlotTable
	elseif storyType == xyd.StoryType.ACTIVITY_FROG then
		storyTable = xyd.tables.activityTravelFrogPlotTable
	elseif storyType == xyd.StoryType.TRIAL then
		storyTable = xyd.tables.newTrialPlotTable
	elseif storyType == xyd.StoryType.DATE_MONOPOLY then
		storyTable = xyd.tables.activityDatePlotTable
	elseif storyType == xyd.StoryType.SWIMSUIT then
		storyTable = xyd.tables.activityIceSummerPlotTable
	elseif storyType == xyd.StoryType.ACTIVITY_VALENTINE then
		storyTable = xyd.tables.activityValentinePlotTable
	elseif storyType == xyd.StoryType.CRYSTAL_BALL then
		storyTable = xyd.tables.storyTable
	end

	local isEffectOn = xyd.SoundManager.get():isEffectOn()

	while storyID > 0 do
		oldIDs[storyID] = true
		local resPath = storyTable:getResPath(storyID)

		pushRes(bigPics_, resPath)
		pushRes(res_, xyd.getTexturePath(resPath))

		local imagePath = storyTable:getImagePath(storyID)

		pushRes(bigPics_, imagePath)
		pushRes(res_, xyd.getTexturePath(imagePath))

		local cgPaths = storyTable:getCgPath(storyID)

		for i = 1, #cgPaths do
			local cgPath = cgPaths[i]

			pushRes(bigPics_, cgPath)
			pushRes(res_, xyd.getTexturePath(cgPath))
		end

		local facePath = storyTable:getFace(storyID)

		pushRes(res_, xyd.getSpritePath(facePath))

		local effect_temp_list = storyTable:effect(storyID)
		local effect_list = {}

		if effect_temp_list then
			effect_list = effect_temp_list
		end

		for i = 1, #effect_list do
			local str_ = effect_list[i]
			local tmpStrs = xyd.split(str_, "*")

			for j = 1, #tmpStrs do
				local effect = xyd.split(tmpStrs[i], "#")

				if effect[1] and xyd.arrayIndexOf(effectNames_, effect[1]) < 0 then
					table.insert(effectNames_, effect[1])
				end
			end
		end

		if isEffectOn then
			local music = storyTable:music(storyID)

			if music > 0 then
				local assetPath = xyd.getSoundPath(music)

				pushRes(res_, assetPath)
			end

			local sound = storyTable:getSound(storyID)

			if sound > 0 then
				local assetPath = xyd.getSoundPath(sound)

				pushRes(res_, assetPath)
			end
		end

		local selectStoryIDs = storyTable:getSelectNextIDs(storyID)

		if #selectStoryIDs > 0 then
			for i = 1, #selectStoryIDs do
				local id = tonumber(selectStoryIDs[i])

				if not oldIDs[id] and xyd.arrayIndexOf(subStoryIDs_, id) < 0 then
					table.insert(subStoryIDs_, id)
				end
			end
		end

		storyID = storyTable:getNext(storyID)

		if oldIDs[storyID] then
			storyID = 0
		end

		if storyID <= 0 and #subStoryIDs_ > 0 then
			storyID = tonumber(table.remove(subStoryIDs_, 1))
		end

		coun_ = coun_ + 1

		if coun_ > 10000 then
			break
		end
	end

	local files = xyd.getEffectFilesByNames(effectNames_)

	if #files > 0 then
		res_ = xyd.arrayMerge(res_, files)
	end

	dump(res_)

	return res_
end

function xyd.getLastWorldPos()
	local camera = xyd.WindowManager.get():getUICamera2()

	return camera.lastWorldPosition
end

function xyd.getScale_Num_shortToLong()
	local stageHeight = xyd.Global.getRealHeight()
	local num = (stageHeight - 1280) / (xyd.Global.getMaxHeight() - 1280)

	if xyd.Global.getMaxHeight() < stageHeight then
		num = 1
	end

	local scale_num_ = 1 - num
	local scale_num_contrary = 1 - scale_num_

	return scale_num_contrary
end

function xyd.goWay(id, wndCallback, callback, closeCallBack)
	local getWayID = id
	local function_id = xyd.tables.getWayTable:getFunctionId(getWayID)
	local windows = xyd.tables.getWayTable:getGoWindow(getWayID)
	local params = xyd.tables.getWayTable:getGoParam(getWayID)

	if not xyd.checkFunctionOpen(function_id) then
		return
	end

	if id == 73 then
		xyd.WindowManager.get():openWindow("house_window", {
			openShop = true
		})

		return
	end

	if callback then
		callback()
	end

	for i = 1, #windows do
		local windowName = windows[i]

		if windowName == "activity_window" then
			local win = xyd.WindowManager.get():getWindow(windowName)
			local newParams = xyd.tables.activityTable:getWindowParams(params[i].select)

			if newParams ~= nil then
				params[i].onlyShowList = newParams.activity_ids
				params[i].activity_type = xyd.tables.activityTable:getType(newParams.activity_ids[1])
			end

			if closeCallBack then
				if params[i] then
					params[i].closeCallBack = closeCallBack
				else
					params[i] = {
						closeCallBack = closeCallBack
					}
				end
			end

			xyd.goToActivityWindowAgain(params[i])
		else
			if closeCallBack then
				if params[i] then
					params[i].closeCallBack = closeCallBack
				else
					params[i] = {
						closeCallBack = closeCallBack
					}
				end
			end

			if getWayID == 125 and xyd.models.guild.guildID <= 0 then
				xyd.WindowManager.get():openWindow("guild_join_window")

				return
			end

			xyd.WindowManager.get():openWindow(windowName, params[i], wndCallback, nil)
		end
	end
end

function xyd.getReturnBackIsDoubleTime()
	local returnBackData = xyd.models.activity:getActivity(xyd.ActivityID.RETURN)

	if returnBackData and returnBackData:getIsDoubleTime() then
		return true
	else
		return false
	end
end

function xyd.getIsQuizDoubleDrop()
	local data = xyd.models.activity:getActivity(xyd.ActivityID.ACTIVITY_DOUBLE_DROP_QUIZ)

	if data then
		return true
	else
		return false
	end
end

function xyd.setUrlLabelTouch(labelMsg)
	if not labelMsg:GetComponent(typeof(UnityEngine.BoxCollider)) then
		local boxCollider = labelMsg:AddComponent(typeof(UnityEngine.BoxCollider))
		labelMsg.autoResizeBoxCollider = true

		labelMsg:ResizeCollider()
	end

	UIEventListener.Get(labelMsg.gameObject).onClick = function ()
		local pos = xyd.getLastWorldPos()
		local url = labelMsg:GetUrlAtPosition(pos)

		if url then
			local trueUrl = string.sub(url, 2, -2)

			if string.find(trueUrl, "https") then
				UnityEngine.Application.OpenURL(trueUrl)
			else
				UnityEngine.Application.OpenURL(url)
			end
		end
	end
end

function xyd.isIosTest()
	return xyd.Global.isReview == 1 and not xyd.isH5()
end

function xyd.isH5()
	return xyd.Global.mainStyleType == xyd.MainStyle.H5
end

function xyd.iosSetUISprite(uiSprite, spriteName)
	local AsyncUISprite = uiSprite.gameObject:GetComponent("AsyncUISprite")

	if AsyncUISprite ~= nil then
		AsyncUISprite.enabled = false
	end

	xyd.setUISprite(uiSprite, nil, spriteName)
end

function xyd.getMVPPartner(battleReportData)
	local scores = {
		0,
		0,
		0,
		0,
		0,
		0
	}
	local dBuffTable = xyd.tables.dBuffTable
	local frames = battleReportData.frames
	local hurts = battleReportData.hurts
	local mvpPos = 1
	local maxScore = 0
	local maxDamage = 0
	local maxHeal = 0
	local maxDamagePos = 0
	local maxHealPos = 0

	for _, hurtData in ipairs(hurts) do
		local pos = tostring(hurtData.pos)

		if tonumber(pos) <= 6 then
			local hurt = xyd.getBattleNum(hurtData.hurt)
			local heal = xyd.getBattleNum(hurtData.heal)
			scores[tonumber(pos) - 1] = hurt + heal
		end
	end

	for i = 1, #frames do
		local frame = frames[i]
		local pos = frame.pos
		local buffs = frame.buffs

		for j = 1, #buffs do
			local buff = buffs[j]
			local fromPos = tonumber(buff.f_pos)
			local toPos = tonumber(buff.pos)
			local buffName = buff.name

			if fromPos and fromPos > 6 and toPos <= 6 then
				if dBuffTable:isDmg(buffName) then
					local dmgValue = math.abs(xyd.getBattleNum(buff.value))
					scores[toPos - 1] = scores[toPos - 1] + dmgValue * 1.1
				end
			elseif fromPos and fromPos <= 6 and toPos > 6 and dBuffTable:getDebuffType(buffName) == 3 then
				scores[fromPos - 1] = scores[fromPos - 1] + 1000
			end
		end
	end

	for m = 0, 5 do
		if scores[m] and maxScore < scores[m] then
			mvpPos = m + 1
			maxScore = scores[m]
		end
	end

	return mvpPos
end

function xyd.showCurrencyText(signal, price)
	return signal .. price
end

function xyd.setUISpriteOffsetType(sp, type)
	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, xyd.ANDROID_1_1_64) <= 0 then
		return
	end

	sp.isOffset = true
	sp.offsetType = UIBasicSprite.OffsetType.IntToEnum(type)
end

function xyd.getRandomByWeights(weights)
	local total = 0

	for i = 1, #weights do
		total = total + weights[i]
	end

	local rand = math.random() * total

	for i = 1, #weights do
		rand = rand - weights[i]

		if rand < 0 then
			return i
		end
	end

	return #weights
end

function xyd.replaceSpace(text)
	if xyd.Global.lang == "ko_kr" then
		return string.gsub(text, " ", " ")
	else
		return text
	end
end

function xyd.stringInsert(str, pos, c)
	if type(str) ~= "string" or type(c) ~= "string" then
		return
	end

	local str1 = string.sub(str, 1, pos)
	local str2 = string.sub(str, pos + 1)

	return str1 .. c .. str2
end

function xyd.autoLineFeed(str, maxLen)
	if maxLen < string.len(str) and not string.find(str, " ") then
		local pos = string.find(str, "-")

		if pos then
			str = xyd.stringInsert(str, pos, "\n")
		else
			str = xyd.stringInsert(str, maxLen, "-\n")
		end
	end

	return str
end

function xyd.gmTestGiftBuy(bagId)
	if UNITY_EDITOR then
		local text = "#gm buy " .. bagId

		xyd.db.misc:setValue({
			key = "gm_gift_buy_state_id",
			value = bagId
		})
		xyd.gmTestCommon(text)
	end
end

function xyd.gmTestAddRes(type)
	if UNITY_EDITOR then
		local typeNum = 1

		if type == "coin" then
			typeNum = 1
		elseif type == "gem" then
			typeNum = 2
		elseif type == "exp" then
			typeNum = 3
		end

		local text = "#gm item " .. typeNum .. " 10000000"

		if type == "coin" then
			text = "#gm item " .. typeNum .. " 100000000"
		end

		xyd.gmTestCommon(text)
	end
end

function xyd.gmTestCommon(str)
	if UNITY_EDITOR then
		local text = str
		local index = string.find(text, "#gm")

		if index then
			local gmStr = string.sub(text, 5)

			if #gmStr > 0 then
				xyd.models.gMcommand:request(gmStr)
			end
		end
	end
end

function xyd.gmSetSpaceExploreAutoTime(timeNum)
	if tonumber(timeNum) <= 0 then
		timeNum = 0
	end

	if UNITY_EDITOR then
		xyd.db.misc:setValue({
			key = "gm_set_space_explore_auto_time",
			value = timeNum
		})
	end
end

function xyd.TestSkillTableOk()
	local unControlEffects = ""

	for _, id in pairs(xyd.tables.skillTable:getIds()) do
		local effects = xyd.tables.skillTable:getEffects(id)

		for k, efts in ipairs(effects) do
			for k2, eft in ipairs(efts) do
				local thebf = xyd.tables.effectTable:buff(eft)

				if tonumber(eft) > 0 and (thebf == nil or thebf == "") then
					unControlEffects = unControlEffects .. eft .. ", "
				end
			end
		end
	end

	if unControlEffects ~= "" then
		reportLog2(unControlEffects)
	else
		reportLog2("no uncontrol effect id in skill table")
	end
end

function xyd.gmSearchItem(type, searchStr, isAllCharSearch)
	if UNITY_EDITOR then
		if type == "searchName" then
			return xyd.tables.itemTable:getNameByZhTw(tonumber(searchStr))
		elseif type == "searchId" then
			local ids = xyd.tables.itemTable:getSearchId(searchStr, isAllCharSearch)
			local idsStr = ""

			for i in pairs(ids) do
				if idsStr == "" then
					idsStr = idsStr .. ids[i]
				else
					idsStr = idsStr .. "," .. ids[i]
				end
			end

			return idsStr
		end
	end
end

function xyd.playSoundByTableId(tableId)
	xyd.SoundManager.get():playSound(tableId)
end

function xyd.gmGetStoryData()
	if UNITY_EDITOR then
		local win = xyd.WindowManager.get():getWindow("story_window")

		if win then
			local position, _, _, scale = win:getPictureInfo()
			local str1 = "x|y|s ：" .. position.x .. "|" .. position.y .. "|" .. scale

			return str1
		end
	end
end

function xyd.gmGetStoryData2()
	if UNITY_EDITOR then
		local win = xyd.WindowManager.get():getWindow("story_window")

		if win then
			local _, bgName, id = win:getPictureInfo()

			return "id:" .. id .. " bg:" .. bgName
		end
	end
end

function xyd.gmGetStoryFaceData()
	if UNITY_EDITOR then
		local win = xyd.WindowManager.get():getWindow("story_window")

		if win then
			local positionx, positiony, scale = win:getPictureFaceInfo()
			local str1 = "x|y|s ：" .. positionx .. "|" .. positiony .. "|" .. scale

			return str1
		end
	end
end

function xyd.gmSetStoryPicturePos(arg1, arg2, arg3)
	if tonumber(arg1) and tonumber(arg2) and UNITY_EDITOR then
		local win = xyd.WindowManager.get():getWindow("story_window")

		if win then
			win:setPicturePos(tonumber(arg1), tonumber(arg2), arg3)

			return "true"
		end
	end
end

function xyd.gmSetStoryPictureFacePos(arg1, arg2, arg3)
	if tonumber(arg1) and tonumber(arg2) and UNITY_EDITOR then
		local win = xyd.WindowManager.get():getWindow("story_window")

		if win then
			win:setPictureFacePos(tonumber(arg1) or 0, tonumber(arg2) or 0, arg3 or 1)

			return "true"
		end
	end
end

function xyd.gmSearchType(id)
	if UNITY_EDITOR then
		return xyd.tables.itemTable:getType(tonumber(id))
	end
end

function xyd.gmDressSummon(type, times)
	if UNITY_EDITOR then
		print("測試1：", type)
		print("測試2：", times)

		local is_wait = false
		local msg = messages_pb.summon_req()

		if type == 1 then
			local cost = xyd.tables.miscTable:split2Cost("dress_gacha_cost1", "value", "#")

			if xyd.models.backpack:getItemNumByID(cost[1]) < cost[2] * times then
				xyd.gmTestCommon("#gm item " .. cost[1] .. " " .. times)

				is_wait = true
			end

			msg.summon_id = 1
			msg.times = times
		elseif type == 2 then
			local cost = xyd.tables.miscTable:split2Cost("dress_gacha_cost2", "value", "|#")

			if xyd.models.backpack:getItemNumByID(cost[2][1]) < cost[2][2] * times then
				xyd.gmTestCommon("#gm item " .. cost[2][1] .. " " .. times)

				is_wait = true
			end

			msg.summon_id = 3
			msg.times = times
		end

		if is_wait then
			XYDCo.WaitForTime(0.1, function ()
				xyd.Backend:get():request(xyd.mid.SUMMON_DRESS, msg)
			end, "test")
		else
			xyd.Backend:get():request(xyd.mid.SUMMON_DRESS, msg)
		end
	end
end

function xyd.delayRegisterNotification(delay)
	if UNITY_IOS then
		XYDCo.WaitForTime(delay, function ()
			xyd.SdkManager.get():registerNotification()
		end, "__SDK__REGISTER__NOTIFICATION__")
	end
end

function xyd.updateFrameRate(val)
	local frameRate = UnityEngine.PlayerPrefs.GetInt("__GAME_FRAME_RATE__", 30)
	frameRate = (not frameRate or tonumber(val) == -1) and 30 or tonumber(frameRate)
	XYDCore.FrameRate = frameRate
	xyd.frameRate = frameRate
	xyd.frameScale = frameRate / 30
	xyd.DeltaTime = 1 / frameRate
	xyd.G = xyd.G / xyd.frameScale
	xyd.MAX_YA = xyd.MAX_YA / xyd.frameScale
end

function xyd.getLength(table)
	local len = 0

	for i, _ in pairs(table) do
		len = len + 1
	end

	return len
end

function xyd.getPingUrls()
	local urls = {
		"http://" .. xyd.backendurl .. "/api/v1"
	}
	local host = xyd.Backend.get().host or ""
	local port = xyd.Backend.get().port or ""

	table.insert(urls, "http://" .. host .. ":" .. port)

	local data = {
		urls = urls
	}
	local cjson = require("cjson")

	return cjson.encode(data)
end

function xyd.andBit(left, right)
	return left == 1 and right == 1 and 1 or 0
end

function xyd.orBit(left, right)
	return (left == 1 or right == 1) and 1 or 0
end

function xyd.xorBit(left, right)
	return left + right == 1 and 1 or 0
end

function xyd.base(left, right, op)
	left = tonumber(left)
	right = tonumber(right)

	if left < right then
		right = left
		left = right
	end

	local res = 0
	local shift = 1

	while left ~= 0 do
		local ra = left % 2
		local rb = right % 2
		res = shift * op(ra, rb) + res
		shift = shift * 2
		left = math.modf(left / 2)
		right = math.modf(right / 2)
	end

	return res
end

function xyd.andOp(left, right)
	return xyd.base(left, right, xyd.andBit)
end

function xyd.xorOp(left, right)
	return xyd.base(left, right, xyd.xorBit)
end

function xyd.orOp(left, right)
	return xyd.base(left, right, xyd.orBit)
end

function xyd.notOp(left)
	return left > 0 and -(left + 1) or -left - 1
end

function xyd.lShiftOp(left, num)
	return left * 2^num
end

function xyd.rShiftOp(left, num)
	return math.floor(left / 2^num)
end

function xyd.bool2Num(bool)
	if bool then
		return 1
	else
		return 0
	end
end

function xyd.getItemIconPreAll(name)
	if name == "item_icon" then
		if not xyd.item_icon_pre_all then
			local obj = ResCache.AddGameObject(xyd.WindowManager.get():getNgui(), "Prefabs/Components/item_icon_all")

			obj:SetActive(false)

			xyd.item_icon_pre_all = obj
		end

		return xyd.item_icon_pre_all
	elseif name == "hero_icon" then
		if not xyd.hero_icon_pre_all then
			local obj = ResCache.AddGameObject(xyd.WindowManager.get():getNgui(), "Prefabs/Components/hero_icon_all")

			obj:SetActive(false)

			xyd.hero_icon_pre_all = obj
		end

		return xyd.hero_icon_pre_all
	end
end

function xyd.checkFunctionOpen(funcID, notToast)
	local opened_funcs = xyd.models.selfPlayer:getOpenedFuncs()

	if not funcID or funcID == 0 then
		return true
	end

	if opened_funcs[funcID] then
		return true
	else
		local openType = xyd.tables.functionTable:getOpenType(funcID)
		local openValue = xyd.tables.functionTable:getOpenValue(funcID)
		local playerLev = xyd.models.backpack:getLev()
		local mapInfo = xyd.models.map:getMapInfo(xyd.MapType.CAMPAIGN)
		local maxStage = nil

		if mapInfo then
			maxStage = mapInfo.max_stage
		else
			maxStage = 0
		end

		if funcID == 12 then
			local funcOpen11 = xyd.checkFunctionOpen(11, true)
			local vip = xyd.tables.gambleConfigTable:needVip(2)

			if funcOpen11 and vip[1] <= xyd.models.backpack:getVipLev() then
				return true
			end
		end

		if openType == 1 then
			if openValue <= playerLev then
				return true
			else
				if not notToast then
					xyd.showToast(__("FUNC_OPEN_LEV", openValue))
				end

				return false
			end
		elseif openType == 2 then
			if openValue <= maxStage then
				return true
			else
				local fortId = xyd.tables.stageTable:getFortID(openValue)
				local text = tostring(fortId) .. "-" .. tostring(xyd.tables.stageTable:getName(openValue))

				if not notToast then
					xyd.showToast(__("FUNC_OPEN_STAGE", text))
				end

				return false
			end
		end
	end
end

function xyd.checkShowPvpWindow(battleType)
	if battleType == xyd.BattleType.FRIEND or battleType == xyd.BattleType.ARENA or battleType == xyd.BattleType.ARENADEF or battleType == xyd.BattleType.ARENA_TEAM or battleType == xyd.BattleType.ARENA_TEAM_DEF or battleType == xyd.BattleType.ARENA_3v3 or battleType == xyd.BattleType.ARENA_3v3_DEF or battleType == xyd.BattleType.ARENA_ALL_SERVER then
		return true
	else
		return false
	end
end

function xyd.checkReportVer(battleReport)
	local trans_str = "BATTLE_VERSION_TIPS"
	local mainVer = xyd.tables.miscTable:getNumber("battle_version", "value") or 0
	local mainVer_ = battleReport.battle_version or 0

	if mainVer > mainVer_ then
		xyd.alertTips(__(trans_str))

		return false
	elseif mainVer == mainVer_ then
		local teamA = battleReport.teamA

		for i = 1, #teamA do
			local p = teamA[i]
			local ver = p.ver or 0

			if ver < xyd.tables.partnerTable:getVer(p.table_id) then
				xyd.alertTips(__(trans_str))

				return false
			end
		end

		local teamB = battleReport.teamB

		for i = 1, #teamB do
			local p = teamB[i]
			local ver = p.ver or 0

			if ver < xyd.tables.partnerTable:getVer(p.table_id) then
				xyd.alertTips(__(trans_str))

				return false
			end
		end

		local petA = battleReport.petA

		if petA and petA.pet_id then
			local ver = petA.ver or 0

			if ver < xyd.tables.petTable:getVer(petA.pet_id) then
				xyd.alertTips(__(trans_str))

				return false
			end
		end

		local petB = battleReport.petB

		if petB and petB.pet_id then
			local ver = petB.ver or 0

			if ver < xyd.tables.petTable:getVer(petB.pet_id) then
				xyd.alertTips(__(trans_str))

				return false
			end
		end

		return true
	end
end

function xyd.getInputWindowName()
	if UNITY_EDITOR or UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, "1.3.75") >= 0 or UNITY_IOS and XYDUtils.CompVersion(UnityEngine.Application.version, "71.2.93") >= 0 then
		return "new_input_window"
	else
		return "input_window"
	end
end

function xyd.writeBattleReport(data)
	local cjson = require("cjson")
	local path = "G:/xuemei2_branch/unity_client/Assets/Lua/data/battle_report/bbbreport.json"
	local file = io.open(path, "w")

	assert(file)
	file:write(tostring(data))
	file:close()
end

function xyd.restartTestGame()
	xyd.MainController.get():restartGame()
end

function xyd.getPrChallengeNum()
	return xyd.tables.partnerChallengeTable:getPageNum() + xyd.tables.partnerChallengeChessTable:getPageNum() + xyd.tables.partnerChallengeSpeedTable:getPageNum()
end

function xyd.goToActivityWindowAgain(param)
	local windowName = "activity_window"
	local win = xyd.WindowManager.get():getWindow("activity_window")

	if win then
		if param and param.select and win:getInThisWindow(param.select) then
			win:reOpen(windowName, param)
		else
			xyd.WindowManager.get():closeWindow(windowName, function ()
				xyd.openWindow(windowName, param)
			end)
		end
	else
		xyd.WindowManager.get():openWindow(windowName, param)
	end
end
