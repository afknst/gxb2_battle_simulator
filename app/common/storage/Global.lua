xyd = xyd or {}
xyd.Global = {}

function xyd.Global.init()
	xyd.Global.reset()
end

function xyd.Global.reset()
	xyd.Global.platformId_ = 29
	xyd.Global.token = ""
	xyd.Global.uid = ""
	xyd.Global.sid = ""
	xyd.Global.psw = ""
	xyd.Global.playerID = -1
	xyd.Global.playerName = "BOSS"
	xyd.Global.playerLev = -1
	xyd.Global.serverDeltaTime = -1
	xyd.Global.backGameTime = 0
	xyd.Global.panelScale = 0
	xyd.Global.panelScalePad = 0
	xyd.Global.defaulSenderName = "Emily"
	xyd.Global.emilyHeadID = 10000
	xyd.Global.firstLogoin = true
	xyd.Global.clipboardMsg = ""
	xyd.Global.loginTime = 0
	xyd.Global.curRunPlatform_ = null
	xyd.Global.maxWidth = 1000
	xyd.Global.maxHeight = 1458
	xyd.Global.maxBgHeight = 1559
	xyd.Global.lang = xyd.lang or "zh_tw"
	xyd.Global.guideType = 1
	xyd.Global.playReport = false
	xyd.Global.isSoundBgOn = true
	xyd.Global.isSoundEffectOn = true
	xyd.Global.battleLoadingNum = 5
	xyd.Global.battleLoadingIds = {}
	xyd.Global.loginToken_ = ""
	xyd.Global.curEffectName = ""
	xyd.Global.curBattleInfo = {}
	xyd.Global.curWindowNames = {}
	xyd.Global.curCloseWindowNames = {}
	xyd.Global.isInGuide = false
	xyd.Global.curActivityID = -1
	xyd.Global.updateDays = {}
	xyd.Global.recordMids = {}
	xyd.Global.recordOpenWindows = {}
	xyd.Global.recordCloseWindows = {}
	xyd.Global.recordCurWindows = {}
	xyd.Global.recordTime = 0
	xyd.Global.recordDialog = {}
	xyd.Global.isInBack = false
	xyd.Global.armatureError = {}
	xyd.Global.urlImgTextureCache = {}
	xyd.Global.urlImgUrlArray = {}
	xyd.Global.battleMap = {}
	xyd.Global.backendurl = ""
	xyd.Global.version = "0.0.1"
	xyd.Global.isLoginInfoReceived = false
	xyd.Global.AlertWin_ = null
	xyd.Global.isANewPlayer_ = 0
	xyd.Global.isNewDevice_ = false
	xyd.Global.isNewPlayer = false
	xyd.Global.isAnonymous_ = 0
	xyd.Global.tpCode_ = ""
	xyd.Global.isLoadingFinish = true
	xyd.Global.selfLoginTime = 0
	xyd.Global.isMainMapLoaded = false
	xyd.Global.appInfo_ = null
	xyd.Global.osType_ = ""
	xyd.Global.appV_ = "0"
	xyd.Global.deviceType_ = UnityEngine.SystemInfo.deviceModel
	xyd.Global.packageLang_ = "en_en"
	xyd.Global.androidUrl = "https://play.google.com/store/apps/details?id=com.carolgames.moemoegirls"
	xyd.Global.iosUrl = "https://itunes.apple.com/app/id1402944867"
	xyd.Global.selfTimeEnterCityGoldNum = 0
	xyd.Global.firstConfirm = null
	xyd.Global.dragonbones = {}
	xyd.Global.dragonbonesReference = {}
	xyd.Global.retainDragonbones = {}
	xyd.Global.bigPics = {}
	xyd.Global.bigPicExceptions = {}
	xyd.Global.commonTipInstance = null
	xyd.Global.showingRewardCount_ = 0
	xyd.Global.isMainMapLoaded = false
	xyd.Global.isReview = 0
	xyd.Global.isAlertError = false
	xyd.Global.isInStart = false
	xyd.Global.suffix = ""
	xyd.Global.usePvr = false
	xyd.Global.effectPngNum = {}
	xyd.Global.isFontLoaded = false
	xyd.Global.effectSyncTime = os.clock()
	xyd.Global.thmSuffix = ""
	xyd.Global.mainWinVer = "_v3"
	xyd.Global.versionCode = ""
	xyd.Global.note_ = 1
	xyd.Global.toUpdateVersion = false
	xyd.Global.theme = null
	xyd.Global.bgMusic = xyd.SoundID.HOME_BG
	xyd.Global.backendInfo = ""
	xyd.Global.isGuideEditNameRegister = false
	xyd.Global.silentLoadRes = {}
	xyd.Global.waitForTimeKey = 1000
	xyd.Global.screenToLocalAspect_ = nil
	xyd.Global.lastRefreshTime_ = 0
	xyd.Global.token = ""
	xyd.Global.uid = ""
	xyd.Global.sid = ""
	xyd.Global.loginToken = ""
	xyd.Global.playerID = -1
	xyd.Global.serverID = nil
	xyd.Global.playerName = "Bella"
	xyd.Global.kingdomID = -1
	xyd.Global.serverDeltaTime = -1
	xyd.Global.backGameTime = 0
	xyd.Global.hasCameraPermission = false
	xyd.Global.hasSDCardPermission = false
	xyd.Global.hasGetAccountsPermission = false
	xyd.Global.ignoreUseCrystal = false
	xyd.Global.realHeight = nil
	xyd.Global.realWidth = nil
	xyd.Global.guideMask05 = nil
	xyd.Global.guideMask001 = nil
	xyd.Global.mainStyleType = xyd.MainStyle.UNITY
	xyd.Global.loginTime = os.time()
	xyd.Global.forumJumpUrl = ""
	xyd.Global.platformID = nil
	xyd.Global.systemMemorySize = UnityEngine.SystemInfo.systemMemorySize
	xyd.Global.processorFrequency = UnityEngine.SystemInfo.processorFrequency
	xyd.Global.deviceModel = UnityEngine.SystemInfo.deviceModel
	xyd.Global.commonBarNum = 1

	xyd.Global.checkH5()
end

function xyd.Global.isInLoginPeriod()
	return math.abs(os.time() - xyd.Global.loginTime) < 60
end

function xyd.Global.getCommonBarNum()
	return xyd.Global.commonBarNum
end

function xyd.Global.setCommonBarNum(num)
	xyd.Global.commonBarNum = num
end

function xyd.Global.isIphoneXAspect()
	if xyd.Global.isIphoneXAspect_ == nil then
		local condtionPlatform = false

		if UNITY_IOS or UNITY_EDITOR then
			condtionPlatform = true
		end

		xyd.Global.isIphoneXAspect_ = condtionPlatform and math.abs(xyd.WindowManager.get():getActiveHeight() / 720 - 2.1653333333333333) <= 0.001
	end

	return xyd.Global.isIphoneXAspect_
end

function xyd.Global.isLineBindEnable()
	if xyd.Global.isLineBindEnable_ == nil then
		xyd.Global.isLineBindEnable_ = true
	end

	return xyd.Global.isLineBindEnable_
end

function xyd.Global.isTwitterBindEnable()
	if xyd.Global.isTwitterBindEnable_ == nil then
		xyd.Global.isTwitterBindEnable_ = false
	end

	return xyd.Global.isTwitterBindEnable_
end

function xyd.Global.isVKBindEnable()
	if xyd.Global.isVKBindEnable_ == nil then
		xyd.Global.isVKBindEnable_ = false
	end

	return xyd.Global.isVKBindEnable_
end

function xyd.Global.isCheckServer()
	if xyd.Global.isCheckServer_ == nil then
		local playerModel = xyd.models.selfPlayer
		local kingdomID = playerModel:getKingdomID() or 0

		if kingdomID == 9999 then
			xyd.Global.isCheckServer_ = true
		else
			xyd.Global.isCheckServer_ = false
		end
	end

	return xyd.Global.isCheckServer_
end

function xyd.Global.isSupportArabic()
	if xyd.Global.isSupportArabic_ == nil then
		local str = xyd.SdkInterface.Instance:getLang()
		local langStr = string.split(str, "_")[1] or ""
		langStr = string.lower(langStr)
		xyd.Global.isSupportArabic_ = langStr == "ar"
	end

	return xyd.Global.isSupportArabic_
end

function xyd.Global.isAmazonBindEnable()
	if xyd.Global.isAmazonBindEnable_ == nil then
		xyd.Global.isAmazonBindEnable_ = false
	end

	return xyd.Global.isAmazonBindEnable_
end

function xyd.Global.screenToLocalAspect()
	if xyd.Global.screenToLocalAspect_ == nil then
		local activeHeight = xyd.WindowManager.get():getActiveHeight()
		local screenH = NGUITools.screenSize.y
		local proportion_y = screenH / activeHeight
		local activeWidth = xyd.WindowManager.get():getActiveWidth()
		local screenW = NGUITools.screenSize.x
		local proportion_x = screenW / activeWidth
		xyd.Global.screenToLocalAspect_ = xyd.checkCondition(proportion_x < proportion_y, proportion_x, proportion_y)
	end

	return xyd.Global.screenToLocalAspect_
end

function xyd.Global.getMaxWidth()
	return xyd.Global.maxWidth
end

function xyd.Global.getMaxHeight()
	return xyd.Global.maxHeight
end

function xyd.Global.getRealHeight()
	if not xyd.Global.realHeight then
		xyd.Global.realHeight = xyd.WindowManager.get():getActiveHeight()
	end

	return xyd.Global.realHeight
end

function xyd.Global.getRealWidth()
	if not xyd.Global.realWidth then
		xyd.Global.realWidth = xyd.WindowManager.get():getActiveWidth()
	end

	return xyd.Global.realWidth
end

function xyd.Global.getMaxBgHeight()
	return xyd.Global.maxBgHeight
end

function xyd.Global.initGuideMask()
	if xyd.Global.guideMask05 and xyd.Global.guideMask001 then
		return
	end

	local ngui = xyd.WindowManager.get():getNgui()
	local GuideMask = import("app.components.GuideMask")
	xyd.Global.guideMask05 = GuideMask.new(ngui)

	xyd.Global.guideMask05:init(xyd.Global.getRealWidth(), xyd.Global.getMaxBgHeight(), 0.5)
	xyd.Global.guideMask05:SetActive(false)

	xyd.Global.guideMask001 = GuideMask.new(ngui)

	xyd.Global.guideMask001:init(xyd.Global.getRealWidth(), xyd.Global.getMaxBgHeight(), 0.01)
	xyd.Global.guideMask001:SetActive(false)
end

function xyd.Global.checkH5()
	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, "1.2.56") <= 0 or UNITY_IOS and XYDUtils.CompVersion(UnityEngine.Application.version, "1.1.66") <= 0 then
		return
	end

	if XYDDef.isH5() then
		xyd.Global.mainStyleType = xyd.MainStyle.H5
	end
end
