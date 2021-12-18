local BattleEffectFactory = class("BattleEffectFactory")
local besicPath = "Spine/"
local effectPaths = {}

function BattleEffectFactory:ctor()
	self.effectsPool_ = {}
	self.effectList_ = {}
end

function BattleEffectFactory:get()
	if BattleEffectFactory.INSTANCE == nil then
		BattleEffectFactory.INSTANCE = BattleEffectFactory.new()
	end

	return BattleEffectFactory.INSTANCE
end

function BattleEffectFactory:reset()
	if not BattleEffectFactory.INSTANCE then
		return
	end

	if BattleEffectFactory.INSTANCE.effectsPool_ then
		for key in pairs(BattleEffectFactory.INSTANCE.effectsPool_) do
			BattleEffectFactory.INSTANCE:clearEffects(key, true)
		end
	end

	BattleEffectFactory.INSTANCE = nil
end

function BattleEffectFactory:loadPath()
end

function BattleEffectFactory:pushBackEffect(eff)
	if eff == nil or tolua.isnull(eff) then
		return
	end

	local SpineController = eff:GetComponent(typeof(SpineAnim))
	local refKey = SpineController.effName

	SpineController:stop()

	eff.transform.parent = nil

	eff:SetActive(false)

	if not self.effectsPool_[refKey] then
		self.effectsPool_[refKey] = {}
	end

	if xyd.arrayIndexOf(self.effectsPool_[refKey], eff) > -1 then
		return
	end

	table.insert(self.effectsPool_[refKey], eff)

	return true
end

function BattleEffectFactory:popEffect(key)
	local list = self.effectsPool_[key]

	if list and #list > 0 then
		local eff = table.remove(list, 1)

		return eff
	end
end

function BattleEffectFactory:getPoolEffectNum(effectName)
	local list = self.effectsPool_[effectName] or {}

	return #list
end

function BattleEffectFactory:getNewEffect(parentGo, key)
	local eff = self:popEffect(key)

	if eff ~= nil and not tolua.isnull(eff) then
		eff:SetActive(true)

		if parentGo then
			ResCache.AddChild(parentGo, eff)
		end

		return eff
	end

	local effPath = xyd.EffectConstants[key]

	if not effPath then
		UnityEngine.Debug.LogError("dont't find the path of spine: " .. key)

		return
	end

	if UNITY_EDITOR then
		self:checkHasLoad(effPath)
	end

	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, "1.3.91") >= 0 or UNITY_IOS and XYDUtils.CompVersion(UnityEngine.Application.version, "71.2.55") >= 0 then
		if parentGo then
			eff = ResCache.AddGameObjectSpine(parentGo, effPath)
		else
			eff = ResCache.NewGameObjectSpine(effPath)
		end
	elseif parentGo then
		eff = ResCache.AddGameObject(parentGo, effPath)
	else
		eff = ResCache.NewGameObject(effPath)
	end

	if not eff then
		UnityEngine.Debug.LogError("add effect error: " .. key)

		local hasParentGo = true

		if not parentGo then
			hasParentGo = false
		end

		local errorInfo = {
			error = "Add Effect Error: " .. key .. " " .. tostring(hasParentGo)
		}
		local encodeInfo = require("cjson").encode(errorInfo)

		xyd.Backend.get():errorLog(0, encodeInfo)

		return
	end

	local spAnim = eff:GetComponent(typeof(SpineAnim))

	if not spAnim then
		UnityEngine.Debug.LogError("dont't find the spAnim of spine: " .. key)

		return
	end

	table.insert(self.effectList_, eff)

	return eff
end

function BattleEffectFactory:clearEffectList()
	for index, eff in ipairs(self.effectList_) do
		NGUITools.Destroy(eff)

		self.effectList_[index] = nil
	end
end

function BattleEffectFactory:clearEffects(key, isDestroy)
	if isDestroy == nil then
		isDestroy = false
	end

	local list = self.effectsPool_[key]

	if list and #list > 0 then
		for i = 1, #list do
			NGUITools.Destroy(list[i])
		end

		self.effectsPool_[key] = nil

		return true
	end

	return false
end

function BattleEffectFactory:createEffects(effectName, num)
	local curNum = self:getPoolEffectNum(effectName)

	if curNum < num then
		local i = 0

		while i < num - curNum do
			local eff = xyd:getEffect(effectName, 1, 1, false)

			self:pushBackEffect(eff)

			i = i + 1
		end
	end
end

function BattleEffectFactory:setLoadData(params)
	self.curBattleLoad_ = params
end

function BattleEffectFactory:checkHasLoad(path)
	if not self.curBattleLoad_ then
		return
	end

	if xyd.arrayIndexOf(self.curBattleLoad_, path) > -1 then
		return
	end

	local msg = "not local res : \n " .. path

	UnityEngine.Debug.LogError("not local res: " .. msg)
end

return BattleEffectFactory
