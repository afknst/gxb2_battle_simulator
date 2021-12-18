local BasePet = class("BasePet", xyd.Battle.getRequire("BaseFighter"))
local ModelTable = xyd.tables.modelTable
local BattleEffectFactory = xyd.BattleEffectFactory.get()
local PetTable = xyd.tables.petTable
local SkillTable = xyd.tables.skillTable
local FxTable = xyd.tables.fxTable

function BasePet:ctor()
	BasePet.super.ctor(self)

	self.wnd_ = nil
end

function BasePet:populate(heroData, top, bottom, scaleY)
	if scaleY == nil then
		scaleY = 1
	end

	self.heroData = heroData
	self.tableID_ = heroData.pet_id
	self.level = heroData.lv
	self.grade = heroData.grade
	self.screenScaleY = scaleY
	self.energy = 0
	self.bottomLayer_ = bottom
	self.topLayer_ = top
end

function BasePet:isPet()
	return true
end

function BasePet:changeColor(color, time_)
end

function BasePet:setMaskColor(flag)
end

function BasePet:setWnd(wnd)
	self.wnd_ = wnd
end

function BasePet:setTeamType(teamType)
	self.teamType = teamType
end

function BasePet:getTeamType()
	return self.teamType
end

function BasePet:setPosIndex(pos)
	self.posIndex = pos
end

function BasePet:getPosIndex()
	return self.posIndex
end

function BasePet:setFrameIndex(index)
	self.frameIndex_ = index
end

function BasePet:getTableID()
	return self.tableID_
end

function BasePet:getSkillIndex()
	return self.skillIndex_
end

function BasePet:getFighterModel(needCreate)
	if needCreate == nil then
		needCreate = false
	end

	if needCreate and not self.fighterModel then
		local posChange = ModelTable:getPetShowPos(self:getModelID() + self.grade - 1)
		local scaleX = xyd.checkCondition(self:getTeamType() == xyd.TeamType.A, posChange[1], -posChange[1])
		self.fighterModel = BattleEffectFactory:getNewEffect(nil, self:getModelName())

		self.fighterModel:SetLocalPosition(360 + posChange[2], 640 + posChange[3], 0)
		self.fighterModel:SetLocalScale(scaleX, posChange[1], 1)

		local SpineController = self.fighterModel:GetComponent(typeof(SpineAnim))
		SpineController.RenderTarget = self.topLayer_:GetComponent(typeof(UITexture))
		SpineController.targetDelta = 2
		self.spineController = SpineController
	end

	return self.fighterModel
end

function BasePet:getEnergyID()
	if self.energyID == nil then
		self.energyID = PetTable:getEnergyID(self:getTableID())
	end

	return self.energyID
end

function BasePet:getEnergy()
	return self.energy
end

function BasePet:updateEnergyBy(value)
	self.energy = self.energy + value

	self:updateEnergy(self.energy)
end

function BasePet:playAllDamageNumbers()
end

function BasePet:updateEnergy(val)
	self.energy = math.min(val, 100)
	self.energy = math.max(val, 0)
end

function BasePet:getModelName()
	return ModelTable:getModelName(self:getModelID() + self.grade - 1)
end

function BasePet:getModelID()
	local modelID = PetTable:getModelID(self:getTableID())

	return modelID
end

function BasePet:getHurtTime()
	local model = self:getFighterModel(true)
	local duration = self.spineController:getAnimationTime("show")

	return duration
end

function BasePet:playSound(skillID)
	local id = SkillTable:getSound(skillID, self.skillIndex_)

	if id > 0 then
		xyd.SoundManager.get():playSound(id)
	end
end

function BasePet:getLayerByType(type)
	if type == xyd.BaseFightLayerType.TOP then
		return self.topLayer_
	elseif type == xyd.BaseFightLayerType.BOTTOM then
		return self.bottomLayer_
	elseif type == xyd.BaseFightLayerType.BUFF_BOT then
		return self.buffBottomLayer
	else
		return self.buffLayer
	end
end

function BasePet:playEnergySkill()
	self:playMaskAction()

	local skillID = self:getEnergyID()
	local fxs = SkillTable:getFx(skillID, self.skillIndex_)
	local firstEffect = nil

	if fxs and next(fxs) then
		for i = 1, #fxs do
			local fx = fxs[i]
			local delta = i

			if i > 1 then
				delta = delta + 1
			end

			local effect = self:playOne(fx, self, skillID, nil, delta)
		end
	end

	self:playAnimation("show", function ()
		self.fighterModel:SetActive(false)

		self.fighterModel.transform.parent = nil
	end, 1)
end

function BasePet:playAnimation(name, callback, num)
	if num == nil then
		num = 1
	end

	local model = self:getFighterModel(true)

	self.spineController:play(name, num)

	self.spineController.timeScale = self.timeScale_

	self.spineController:addListener("Complete", function ()
		if callback ~= nil then
			callback()
		end
	end)

	local layer = self:getLayerByType(xyd.BaseFightLayerType.TOP)
	local posChange = ModelTable:getPetShowPos(self:getModelID() + self.grade - 1)
	local scaleX = xyd.checkCondition(self:getTeamType() == xyd.TeamType.A, posChange[1], -posChange[1])

	ResCache.AddChild(layer, model)
	model:SetLocalPosition(360, -640, 0)
	model:SetLocalScale(scaleX, posChange[1], 1)
	model:SetActive(true)
end

function BasePet:playMaskAction()
	local model = self:getFighterModel(true)
	local duration = self:getHurtTime()
	local layer = self:getLayerByType(xyd.BaseFightLayerType.TOP)

	if not self.maskImg_ then
		local img_ = NGUITools.AddChild(layer, "pet_mask")
		local sp = img_:AddComponent(typeof(UISprite))

		xyd.setUISprite(sp, xyd.Atlas.COMMON_UI, "guide_mask")

		sp.depth = layer:GetComponent(typeof(UIWidget)).depth - 1
		sp.width = 1000
		sp.height = 1559
		self.maskImg_ = sp
	end

	local img_ = self.maskImg_
	img_.color = Color.New2(1)

	self.maskImg_:SetLocalPosition(360, -640, 0)
	self.maskImg_:SetActive(true)

	local function getter()
		return img_.color
	end

	local function setter(value)
		img_.color = value
	end

	local delay = (duration - 0.2) / self.timeScale_
	local action = self:getTimeLineLite()

	action:Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 0.7, 0.1)):AppendInterval(delay):Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 0.01, 0.1)):AppendCallback(function ()
		self.maskImg_:SetActive(false)
	end)
end

function BasePet:getEffect(effectName, scaleX, scaleY)
	local effect = BattleEffectFactory:getNewEffect(nil, effectName)
	effect.transform.localScale = Vector3(scaleX, scaleY, 1)

	table.insert(self.effects_, effect)

	return effect
end

function BasePet:returnToObjs(effect)
	local index = xyd.arrayIndexOf(self.effects_, effect)

	if index > -1 then
		table.remove(self.effects_, index)
	end

	BattleEffectFactory:pushBackEffect(effect)

	local i = xyd.arrayIndexOf(self.effectsStayLastFrame_, effect)

	if i > -1 then
		table.remove(self.effectsStayLastFrame_, i)
	end
end

function BasePet:playOne(fx, target, skillID, unitPos, delta)
	if skillID == nil then
		skillID = 0
	end

	if unitPos == nil then
		unitPos = -1
	end

	local degree = nil

	function degree(x, y)
		return math.atan(y / x) * 57.29577951
	end

	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1
	local effectName = FxTable:getResName(fx)
	local texiaoName = FxTable:getFxName(fx)
	local position = FxTable:getPosition(fx)
	local layer = FxTable:getLayer(fx)
	local retain = FxTable:isRetain(fx)
	local isLoop = FxTable:isLoop(fx)
	local scale = FxTable:getScale(fx)
	local offX = FxTable:getX(fx)
	local offY = FxTable:getY(fx) * self.screenScaleY
	local isParallel = FxTable:isParallel(fx)
	local isPass = FxTable:isPass(fx)
	local playTimes = 1

	if isLoop then
		playTimes = 0
	end

	local effect = self:getEffect(effectName, scale, scale)
	effect.name = "" .. tostring(fx) .. tostring(self.frameIndex_)
	local effectAnim = effect:GetComponent(typeof(SpineAnim))
	local targetDelta = nil
	effectAnim.timeScale = self.timeScale_
	local fxType = FxTable:getType(fx)
	local uiLayer = target:getLayerByType(xyd.BaseFightLayerType.TOP)

	ResCache.AddChild(uiLayer, effect)

	effect.transform.localScale = Vector3(scale * diretion, scale, 1)
	effect.transform.localPosition = Vector3(360, -640, 0)

	effectAnim:play(texiaoName, playTimes)

	if playTimes ~= 0 and not retain then
		effectAnim:addListener("Complete", function ()
			self:returnToObjs(effect)
		end)
	end

	if retain and playTimes > 0 then
		effectAnim:addListener("Complete", function ()
			if xyd.arrayIndexOf(self.effectsStayLastFrame_, effect) < 0 then
				table.insert(self.effectsStayLastFrame_, effect)
			end
		end)
	end

	effectAnim.RenderTarget = uiLayer:GetComponent(typeof(UIWidget))
	effectAnim.targetDelta = delta

	return effect
end

function BasePet:playHurtFx(fxs)
	local t = 0

	if #fxs > 0 then
		for _, fx in ipairs(fxs) do
			local tmpT = FxTable:getSpeed(fx)
			t = xyd.checkCondition(t < tmpT, tmpT, t)
			local layer = FxTable:getLayer(fx)
			local uiLayer = nil

			if layer == xyd.FxLayerType.BOTTOM then
				uiLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_BOT)
			else
				uiLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
			end

			if not uiLayer:NodeByName("" .. tostring(fx) .. tostring(self.frameIndex_)) then
				-- Nothing
			end
		end
	end

	return t
end

function BasePet:pause(onlyModel)
	if onlyModel == nil then
		onlyModel = false
	end

	if onlyModel == false then
		for i = 1, #self.actions do
			local action = self.actions[i]

			action:Pause()
		end
	else
		self.isPause_ = true
	end
end

function BasePet:resume(onlyModel)
	if onlyModel == nil then
		onlyModel = false
	end

	if onlyModel and self.isPause_ then
		self.isPause_ = false
	end

	if onlyModel == false then
		for i = 1, #self.actions do
			local action = self.actions[i]

			action:Play()
		end
	end
end

function BasePet:getTimeLineLite()
	local action = nil

	local function completeCallback()
		for i = 1, #self.actions do
			if self.actions[i] == action then
				table.remove(self.actions, i)

				break
			end
		end
	end

	action = DG.Tweening.DOTween.Sequence():OnComplete(completeCallback)
	action.timeScale = self.timeScale_

	action:SetAutoKill(true)
	table.insert(self.actions, action)

	return action
end

function BasePet:setTimeScale(num)
	num = num == xyd.BASIC_BATTLE_SPEED and 1 or 2
	self.timeScale_ = num
end

function BasePet:getTimeScale()
	return self.timeScale_
end

function BasePet:battleSpeed()
end

function BasePet:clearAction()
	if #self.actions > 0 then
		for i = 1, #self.actions do
			local action = self.actions[i]

			action:Pause()
			action:Kill()
		end

		self.actions = {}
	end

	for i = 1, #self.effects_ do
		local effect = self.effects_[i]

		self:returnToObjs(effect)
	end
end

function BasePet:setMaskColor(flag)
end

return BasePet
