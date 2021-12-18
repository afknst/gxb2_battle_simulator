local DBuffTable = xyd.tables.dBuffTable
local PartnerTable = xyd.tables.partnerTable
local MonsterTable = xyd.tables.monsterTable
local EquipTable = xyd.tables.equipTable
local ModelTable = xyd.tables.modelTable
local BattleEffectFactory = xyd.BattleEffectFactory.get()
local SkillTable = xyd.tables.skillTable
local EffectTable = xyd.tables.effectTable
local FxTable = xyd.tables.fxTable
local PngNum = import("app.components.PngNum")
local HeadView = class("HeadView", import("app.components.BaseComponent"))

function HeadView:ctor(parentGo)
	HeadView.super.ctor(self, parentGo)

	self.energyEffect_ = nil
	self.timeKey_ = -1
	self.isHpBarHide_ = false
	self.buffItems_ = {}
end

function HeadView:getPrefabPath()
	return "Prefabs/Components/battle_hero_head"
end

function HeadView:setInfo(fighter)
	self.fighter = fighter

	self:updateLevel(self.fighter:getShowLevel())
	self:updateGroup(self.fighter:getGroup())
end

function HeadView:initUI()
	HeadView.super.initUI(self)

	local go = self.go
	self.groupMain_ = go:NodeByName("groupMain_").gameObject
	self.textLevel = self.groupMain_:ComponentByName("textLevel", typeof(UILabel))
	self.group = self.groupMain_:ComponentByName("group", typeof(UISprite))
	self.groupBg_ = self.groupMain_:ComponentByName("groupBg_", typeof(UISprite))
	self.buffGroup = self.groupMain_:NodeByName("buffGroup").gameObject
	self.buffGroupWidget = self.buffGroup:GetComponent(typeof(UIWidget))
	self.progress = self.groupMain_:NodeByName("progress").gameObject
	self.hpBg = self.progress:ComponentByName("hpBg", typeof(UISprite))
	self.mpEffect = self.progress:ComponentByName("mpEffect", typeof(UITexture))
	self.hpThumb = self.progress:ComponentByName("hpBarSpecial/hpThumb", typeof(UISprite))
	self.hpThumb2 = self.progress:ComponentByName("hpBar/hpThumb2", typeof(UISprite))
	self.mpBg = self.progress:ComponentByName("mpBar/mpBg", typeof(UISprite))
	self.mpThumb = self.progress:ComponentByName("mpBar/mpThumb", typeof(UISprite))
	self.loseHpNode = self.progress:NodeByName("loseHpNode").gameObject
	self.buffItem = self.groupMain_:NodeByName("buffItem").gameObject
	self.groupDialog_ = go:NodeByName("groupDialog_").gameObject
	self.imgDialogBg_ = self.groupDialog_:ComponentByName("imgDialogBg_", typeof(UISprite))
	self.labelDialog_ = self.groupDialog_:ComponentByName("labelDialog_", typeof(UILabel))
	self.hpBar = self.progress:ComponentByName("hpBar", typeof(UISlider))
	self.hpBarSpecial = self.progress:ComponentByName("hpBarSpecial", typeof(UISlider))
	self.mpBar = self.progress:ComponentByName("mpBar", typeof(UISlider))
	self.depthObjs_ = {
		self.buffGroupWidget,
		self.hpBg,
		self.hpThumb,
		self.hpThumb2,
		self.loseHpNode:GetComponent(typeof(UIWidget)),
		self.mpBg,
		self.mpThumb,
		self.mpEffect,
		self.groupBg_,
		self.group,
		self.textLevel,
		self.imgDialogBg_,
		self.labelDialog_
	}
end

function HeadView:getHeight()
	local go = self.go
	local widget = go:GetComponent(typeof(UIWidget))

	return widget.height
end

function HeadView:updateLevel(lev)
	self.textLevel.text = lev
end

function HeadView:updateGroup(group)
	if not group or group == 0 then
		self.group:SetActive(false)
		self.groupBg_:SetActive(false)
		self.textLevel:SetActive(false)

		return
	end

	local groupPath = "img_group" .. group

	if xyd.isIosTest() then
		xyd.setUISprite(self.group, nil, groupPath .. "_ios_test")
	else
		xyd.setUISprite(self.group, xyd.Atlas.COMMON_UI, groupPath)
	end
end

function HeadView:playBarAction(bar, start, to, t, timeScale, callback)
	local function setter(value)
		bar.value = value
	end

	local sequence1 = DG.Tweening.DOTween.Sequence()
	sequence1.timeScale = timeScale

	sequence1:Append(DG.Tweening.DOTween.To(DG.Tweening.Core.DOSetter_float(setter), start, to, t):SetEase(DG.Tweening.Ease.Linear))
	sequence1:AppendCallback(function ()
		if callback then
			callback()
		end
	end)

	return sequence1
end

function HeadView:updateLoseHp(value)
	local scaleX = 0.5
	local scaley = 0.25

	if not self.loseHpEffect then
		local fx = DBuffTable:getFx(xyd.BUFF_MAYA_HP_LOSE_SEAL)
		local effectName = FxTable:getResName(fx[1])
		self.loseHpEffect = xyd.Spine.new(self.loseHpNode)

		self.loseHpEffect:setInfo(effectName, function ()
			self.loseHpEffect:play("texiao01", 0, 1)
		end)
	end

	local startPosX = 15.9
	local length = 120

	self.loseHpEffect:SetLocalScale(value * scaleX, scaley, 1)
	self.loseHpNode:X(startPosX + length * (1 - value) / 2)
end

function HeadView:updateHpBar(value)
	self.hpBar.value = value / xyd.PERCENT_BASE
	local timeScale = self.fighter:getTimeScale()
	local sequence1 = self:playBarAction(self.hpBarSpecial, self.hpBarSpecial.value, value / xyd.PERCENT_BASE, 0.5, timeScale)
	local w = self.groupMain_:GetComponent(typeof(UIWidget))

	local function getter()
		return w.color
	end

	local function setter(value)
		w.color = value
	end

	if value == 0 then
		self:updateMpBar(0)

		self.isHpBarHide_ = true

		sequence1:Insert(0, DG.Tweening.DOTween.ToAlpha(getter, setter, 0, 0.5))
	elseif value > 0 and self.isHpBarHide_ then
		sequence1:Insert(0, DG.Tweening.DOTween.ToAlpha(getter, setter, 1, 0.5))

		self.isHpBarHide_ = false
	end
end

function HeadView:updateMpBar(value)
	local timeScale = self.fighter:getTimeScale()

	self:playBarAction(self.mpBar, self.mpBar.value, value / xyd.PERCENT_BASE, 0.2, timeScale)

	if value >= 100 and not self.fighter:isDeath() then
		if self.energyEffect_ == nil then
			self.energyEffect_ = xyd.Spine.new(self.mpEffect.gameObject)

			self.energyEffect_:setInfo("fx_ui_nlt", function ()
				self.energyEffect_:play("texiao01", 0)
			end)
		end

		self.energyEffect_:SetActive(true)
	elseif self.energyEffect_ ~= nil then
		self.energyEffect_:SetActive(false)
	end
end

function HeadView:removeAllBuffs()
	for _, item in ipairs(self.buffItems_) do
		item:SetActive(false)
	end
end

function HeadView:refreshBuffIcons(buffs)
	self:removeAllBuffs()

	local count = 0
	local showBuffs = {}

	local function checkHave(path)
		local data = nil

		for i = 1, #showBuffs do
			local val = showBuffs[i]

			if val.path == path then
				data = val

				break
			end
		end

		return data
	end

	for i = #buffs, 1, -1 do
		local buff = buffs[i]
		local icon1 = DBuffTable:getIcon1(buff.name)
		local path = icon1
		local icon2 = DBuffTable:getIcon2(buff.name)

		if icon2 and icon2 ~= "" and buff.value < 0 then
			path = icon2
		end

		if path ~= nil and path ~= "" then
			local data = checkHave(path)

			if data then
				data.num = data.num + 1

				if buff.name == "weak" then
					data.num = 1
				end
			elseif count < 4 then
				table.insert(showBuffs, {
					num = 1,
					path = path
				})

				count = count + 1
			end
		end
	end

	for i = #showBuffs, 1, -1 do
		local path = showBuffs[i].path
		local num = showBuffs[i].num

		if not self.buffItems_[i] then
			self.buffItems_[i] = NGUITools.AddChild(self.buffGroup, self.buffItem)

			self.buffItems_[i]:SetLocalPosition(28 * i, 0, 0)
		end

		local node = self.buffItems_[i]

		node:SetActive(true)

		local img = node:ComponentByName("buffIcon", typeof(UISprite))
		local label = node:ComponentByName("buffNum", typeof(UILabel))
		local depth = self.buffGroupWidget.depth
		img.depth = depth + 1
		label.depth = depth + 2

		xyd.setUISprite(img, xyd.Atlas.BATTLE, path)

		label.text = num

		if num == 1 then
			label:SetActive(false)
		else
			label:SetActive(true)
		end
	end
end

function HeadView:showDialog(index, isPlaySound)
	local tips = ""
	local soundID = 0
	local sound = nil
	local heroID = self.fighter:getHeroTableID()
	local skinID = self.fighter:getSkin()

	if index == xyd.PartnerBattleDialog.BATTLE_DIALOG then
		tips = PartnerTable:getBattleDialog(heroID, skinID)
		sound = PartnerTable:getBattleSound(heroID, skinID)
	elseif index == xyd.PartnerBattleDialog.SKILL_DIALOG then
		tips = PartnerTable:getSkilleDialog(heroID, skinID)
		sound = PartnerTable:getSkillSound(heroID, skinID)
	elseif index == xyd.PartnerBattleDialog.DEAD_DIALOG then
		tips = PartnerTable:getDeadDialog(heroID, skinID)
		sound = PartnerTable:getDeadSound(heroID, skinID)
	end

	if not tips or #tips == 0 then
		return
	end

	self.labelDialog_.text = tips

	self:playDialogAction()

	local effect = nil

	if isPlaySound and sound.id and sound.id > 0 then
		effect = self:playSound(sound)
	end

	if not sound.time then
		sound.time = 0
	end

	self:autoHideDialog(sound.time)

	return effect
end

function HeadView:playDialogAction()
	if self.dialogAction_ then
		self.dialogAction_:Pause()

		self.dialogAction_ = nil
	end

	local timeScale = self.fighter:getTimeScale()
	local action = DG.Tweening.DOTween.Sequence():SetEase(DG.Tweening.Ease.OutElastic)
	action.timeScale = timeScale

	self.groupDialog_:SetActive(true)
	self.groupDialog_:SetLocalPosition(0, 0, 0)

	local widget = self.groupDialog_:GetComponent(typeof(UIWidget))
	widget.alpha = 0.5

	local function getter()
		return widget.color
	end

	local function setter(value)
		widget.color = value
	end

	action:Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 1, 0.5))
	action:Join(self.groupDialog_.transform:DOLocalMove(Vector3(0, 48, 0), 0.5))

	self.dialogAction_ = action
end

function HeadView:hideDialog()
	if not tolua.isnull(self.groupDialog_) then
		self.groupDialog_:SetActive(false)
	end

	self.timeKey_ = nil
end

function HeadView:playSound(sound)
	xyd.SoundManager.get():playSound(sound.id)
end

function HeadView:autoHideDialog(time)
	if self.timeKey_ then
		XYDCo.StopWait(self.timeKey_)

		self.timeKey_ = nil
	end

	local timeScale = 1
	self.timeKey_ = "HeadView" .. xyd.getTimeKey()

	XYDCo.WaitForTime(time, handler(self, self.hideDialog), self.timeKey_)
end

function HeadView:iosTestChangeUI()
	xyd.setUISprite(self.hpBg, nil, "battle_hp_bar_bg_ios_test")
	xyd.setUISprite(self.hpThumb, nil, "battle_hp_bar2_ios_test")
	xyd.setUISprite(self.hpThumb2, nil, "battle_hp_bar1_ios_test")
	xyd.setUISprite(self.mpBg, nil, "battle_mp_bar_bg_ios_test")
	xyd.setUISprite(self.mpThumb, nil, "battle_mp_bar_ios_test")
end

function HeadView:apateHeadViewDie()
	self.groupMain_:SetActive(true)

	self.groupMain_:GetComponent(typeof(UIWidget)).alpha = 1

	self.buffGroup:SetActive(true)

	self.hpBg:GetComponent(typeof(UISprite)).alpha = 0
	self.hpThumb:GetComponent(typeof(UISprite)).alpha = 0
	self.hpThumb2:GetComponent(typeof(UISprite)).alpha = 0
	self.mpBg:GetComponent(typeof(UISprite)).alpha = 0
	self.mpThumb:GetComponent(typeof(UISprite)).alpha = 0
	self.groupBg_:GetComponent(typeof(UIWidget)).alpha = 0
	self.group:GetComponent(typeof(UIWidget)).alpha = 0
	self.textLevel:GetComponent(typeof(UIWidget)).alpha = 0
end

function HeadView:apateHeadViewRevive()
	self.groupMain_:SetActive(true)

	self.groupMain_:GetComponent(typeof(UIWidget)).alpha = 1

	self.buffGroup:SetActive(true)

	self.hpBg:GetComponent(typeof(UISprite)).alpha = 1
	self.hpThumb:GetComponent(typeof(UISprite)).alpha = 1
	self.hpThumb2:GetComponent(typeof(UISprite)).alpha = 1
	self.mpBg:GetComponent(typeof(UISprite)).alpha = 1
	self.mpThumb:GetComponent(typeof(UISprite)).alpha = 1
	self.groupBg_:GetComponent(typeof(UIWidget)).alpha = 1
	self.group:GetComponent(typeof(UIWidget)).alpha = 1
	self.textLevel:GetComponent(typeof(UIWidget)).alpha = 1
end

local BaseFighter = class("BaseFighter")

function BaseFighter:ctor()
	self.heroData = {}
	self.posIndex = 0
	self.fighterModel = nil
	self.teamType = 0
	self.puGongID = nil
	self.puGongIDs = {}
	self.energyID = nil
	self.addHurtID = nil
	self.energy = 0
	self.hp = 0
	self.damageNumbers = {}
	self.buffState = {}
	self.buffs = {}
	self.effects_ = {}
	self.actions = {}
	self.timeScale_ = 1
	self.tableID_ = 0
	self.grade = 0
	self.level = 0
	self.awake = 0
	self.screenScaleY = 1
	self.isMonster = false
	self.isInStone_ = false
	self.skinID_ = 0
	self.skillIndex_ = 1
	self.isShowSkin_ = 0
	self.frameIndex_ = 0
	self.effectsStayLastFrame_ = {}
	self.defaultColor = nil
	self.curTargets_ = {}
	self.floatTextPos = 0
	self.splitPercent = {}
	self.splitDelay = {}
	self.isBattlehangup = false
	self.freeSkill_ = false
	self.needHideHeadView = false
	self.slotImgName = ""
	self.battleId = 0
	self.initScaleX = 0
	self.initScaleY = 0
	self.isGetLeaf = false
	self.apateValue = 0
end

function BaseFighter:populate(heroData, parent, top, bottom, scaleY)
	if scaleY == nil then
		scaleY = 1
	end

	self.heroData = heroData
	self.tableID_ = heroData.table_id
	self.level = heroData.level
	self.grade = heroData.grade
	self.awake = heroData.awake
	self.isMonster = heroData.isMonster
	self.screenScaleY = scaleY
	self.hp = 100
	self.energy = heroData.initMp or self:getInitMp()
	self.parent = parent
	self.bottomLayer_ = bottom
	self.topLayer_ = top

	if heroData.status and heroData.status.hp and tostring(heroData.status) ~= "" then
		self.hp = heroData.status.hp

		if heroData.status.mp ~= nil and heroData.status.mp >= 0 then
			self.energy = heroData.status.mp
		end
	end

	self:setSkin(heroData)
	self:resetConfig()
	self:getUIComponent()
end

function BaseFighter:setSlotImgName(name)
	self.slotImgName = name
end

function BaseFighter:setBattleId(id)
	self.battleId = id
end

function BaseFighter:setNeedHideHeadView(flag)
	self.needHideHeadView = flag
end

function BaseFighter:getNeedHideHeadView()
	return self.needHideHeadView
end

function BaseFighter:setBattleHangUp(flag)
	self.isBattleHangUp = flag
end

function BaseFighter:resetConfig()
	self.isPause_ = false
	self.buffState = {}
	self.buffs = {}
end

function BaseFighter:setFreeSkill(flag)
	self.freeSkill_ = flag
end

function BaseFighter:getFreeSkill()
	return self.freeSkill_
end

function BaseFighter:setSkin(heroData)
	self.skinID_ = heroData.skin_id or 0
	self.isShowSkin_ = heroData.show_skin or 0

	if self.isMonster then
		local tmpSkinID = MonsterTable:getSkin(self:getTableID())

		if tmpSkinID > 0 then
			self.isShowSkin_ = 1
			self.skinID_ = tmpSkinID
		end
	end

	if self.isShowSkin_ == 1 and self.skinID_ > 0 then
		self.skillIndex_ = EquipTable:getFxIndex(self.skinID_) or 1
	end
end

function BaseFighter:getSkin()
	return self.skinID_
end

function BaseFighter:setWnd(wnd)
	self.wnd_ = wnd
end

function BaseFighter:setTeamType(teamType)
	self.teamType = teamType
end

function BaseFighter:getTeamType()
	return self.teamType
end

function BaseFighter:setFighterModelSlot(name)
	if not name or name ~= "" then
		if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, xyd.ANDROID_1_1_86) <= 0 then
			return
		end

		if self:getTableID() and xyd.models.selfPlayer.slotChangeTableId[self:getTableID()] then
			return
		end

		xyd.setUITextureByNameAsync(self.imgSlot, name, true, function ()
			local xy = xyd.tables.battleTable:getBossMapXy(self.battleId)
			local scale = xyd.tables.battleTable:getBossMapScale(self.battleId)
			local spinAnim = self.fighterModel:GetComponent(typeof(SpineAnim))
			local width = self.imgSlot.width
			local height = self.imgSlot.height

			spinAnim:changeAttachment("tihuan1", self.imgSlot)
			xyd.changeSlotTransform(spinAnim, "tihuan1", Vector3(-xy[1] / 2 - 76, xy[2] / 2 - 55, 0), Vector3(scale[1] / width, scale[2] / height, 1))

			xyd.models.selfPlayer.slotChangeTableId[self:getTableID()] = true

			self.slotNode:SetActive(false)
		end)
	end
end

function BaseFighter:getUIComponent()
	self.shadow_ = self.parent:ComponentByName("shadow", typeof(UISprite))
	self.buffBottomLayer = self.parent:NodeByName("buffBottomLayer").gameObject
	self.buffLayer = self.parent:NodeByName("buffLayer").gameObject

	if self.parent:NodeByName("slotNode") then
		self.slotNode = self.parent:NodeByName("slotNode").gameObject
		self.imgSlot = self.parent:ComponentByName("slotNode/imgSlot", typeof(UITexture))
	end
end

function BaseFighter:setBaseDepth(depth)
	self.baseDepth_ = depth
end

function BaseFighter:resetZOrder()
	local depth = self.baseDepth_

	self:setZOrder(depth)
end

function BaseFighter:buffBotLayerDepth(depth)
	local widget = self.buffBottomLayer:GetComponent(typeof(UITexture))
	widget.depth = depth
end

function BaseFighter:buffLayerDepth(depth)
	local widget = self.buffLayer:GetComponent(typeof(UITexture))
	widget.depth = depth
end

function BaseFighter:setZOrder(depth)
	self.parent:GetComponent(typeof(UIWidget)).depth = depth

	self.parent:Z(-depth)
	self:buffBotLayerDepth(depth + 1)

	if self.modelRender_ then
		self.modelRender_.depth = depth + 2
	end

	if self.headView then
		local headDepth = self:getTeamType() == xyd.TeamType.A and 100 or 90

		self.headView:updateDepthObj(headDepth)
	end

	self:buffLayerDepth(depth + 4)
end

function BaseFighter:initModel(directX_)
	local shade = ModelTable:getShadePos(self:getModelID())
	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1

	self.shadow_:SetLocalPosition(shade[1] * diretion, shade[2] + 20, 0)
	self.shadow_:SetLocalScale(shade[3], shade[3], 1)

	local go = self:getModel(directX_)
	local SpineController = go:GetComponent(typeof(SpineAnim))
	SpineController.RenderTarget = self.modelRender_
	SpineController.targetDelta = 0
	SpineController.timeScale = 1
	self.fighterModel = go

	self:setFighterModelSlot(self.slotImgName)

	self.spineController = SpineController
end

function BaseFighter:changeColor(color, time_)
	if time_ == nil then
		time_ = 0
	end

	if self:isHasBuff(xyd.BUFF_STONE) and color ~= xyd.BattleColor.grey then
		return
	end

	if color ~= nil then
		self.spineController.fillColor = color
		self.spineController.fillPhase = 1

		if time_ > 0 then
			local action = self:getTimeLineLite()

			action:AppendInterval(time_ / self.timeScale_):AppendCallback(function ()
				if self:isHasBuff(xyd.BUFF_STONE) then
					return
				end

				self:setDefaultColor()
			end)
		end
	else
		self:setDefaultColor()
	end
end

function BaseFighter:setDefaultColor()
	if self.defaultColor then
		self.spineController.fillColor = self.defaultColor
		self.spineController.fillPhase = 1
	else
		self.spineController.fillPhase = 0
		self.spineController.fillColor = Vector4(1, 1, 1, 1)
	end
end

function BaseFighter:setMaskColor(flag)
	if flag then
		self:changeColor(xyd.BattleColor.maskColorMatrix)
	else
		self:changeColor()
	end
end

function BaseFighter:getFighterModel()
	return self.fighterModel
end

function BaseFighter:isPet()
	return false
end

function BaseFighter:setPosIndex(pos)
	self.posIndex = pos
end

function BaseFighter:getPosIndex()
	return self.posIndex
end

function BaseFighter:getParentPos()
	return self.parent.transform.localPosition
end

function BaseFighter:getParentCurDepth()
	return self.parent:GetComponent(typeof(UIWidget)).depth
end

function BaseFighter:setFrameIndex(index)
	self.frameIndex_ = index
end

function BaseFighter:resumeIdle()
	if self:isDeath() then
		return
	end

	self:playAnimation("idle", function ()
	end, 0)

	if self.isPause_ then
		self:pause(true)
	end
end

function BaseFighter:pos(x, y)
	self.fighterModel.x = x
	self.fighterModel.y = y
end

function BaseFighter:posX(x)
	self.fighterModel.x = x
end

function BaseFighter:getX()
	return self.fighterModel.x
end

function BaseFighter:posY(y)
	self.fighterModel.y = y
end

function BaseFighter:getY()
	return self.fighterModel.y
end

function BaseFighter:getParent()
	return self.parent
end

function BaseFighter:getName()
	return PartnerTable:getName(self:getHeroTableID())
end

function BaseFighter:getLevel()
	return self.level
end

function BaseFighter:getShowLevel()
	if self.isMonster then
		if xyd.Battle.curBattleType == xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT2 then
			return math.min(250, self:getLevel())
		elseif xyd.Battle.curBattleType == xyd.BattleType.EXPLORE_ADVENTURE then
			return xyd.tables.exploreAdventureTable:getEnemyLv(xyd.models.exploreModel:getExploreInfo().lv)
		end

		return MonsterTable:getShowLev(self:getTableID())
	end

	return self:getLevel()
end

function BaseFighter:getGroup()
	return PartnerTable:getGroup(self:getHeroTableID())
end

function BaseFighter:getTableID()
	return self.tableID_
end

function BaseFighter:getHeroTableID()
	if self.isMonster then
		local id = MonsterTable:getPartnerLink(self:getTableID())

		return id
	end

	return self:getTableID()
end

function BaseFighter:getXOffset()
	local offset = 0

	if self.isMonster then
		offset = MonsterTable:getXOffset(self:getTableID()) or 0
	end

	return offset
end

function BaseFighter:getShowInGuide()
	return PartnerTable:getShowInGuide(self:getHeroTableID())
end

function BaseFighter:getModelName()
	return ModelTable:getModelName(self:getModelID())
end

function BaseFighter:getModel(directX_)
	local modelName = self:getModelName()
	local scale = self:getScale()
	local modelNode = self.parent:ComponentByName("model", typeof(UITexture))
	local go = BattleEffectFactory:getNewEffect(modelNode.gameObject, modelName)

	go:SetLocalPosition(0, 0, 0)
	go:SetLocalScale(directX_ * scale, scale, 1)

	self.modelRender_ = modelNode

	return go
end

function BaseFighter:getModelID()
	local modelID = 0

	if self.isShowSkin_ == 1 and self.skinID_ > 0 then
		modelID = EquipTable:getSkinModel(self.skinID_)
	else
		modelID = PartnerTable:getModelID(self:getHeroTableID())
	end

	return modelID
end

function BaseFighter:getSkillIndex()
	return self.skillIndex_
end

function BaseFighter:getScale()
	local scale = ModelTable:getScale(self:getModelID())

	if self.isMonster then
		scale = scale + MonsterTable:getScale(self:getTableID())
	end

	return scale
end

function BaseFighter:isBlackScreen(skillID)
	return SkillTable:isBlackScreen(skillID, self.skillIndex_)
end

function BaseFighter:getModelOffset()
	local pos = ModelTable:battlePos(self:getModelID())
	local diretion = self:getTeamType() == xyd.TeamType.A and -1 or 1
	local x = (pos[1] or 0) * diretion
	local y = pos[2] or 0
	local offset = {
		x,
		y
	}

	return offset
end

function BaseFighter:updateSkillId(skillID, index)
	local exSkills = self.heroData.ex_skills

	if not exSkills or not exSkills[index - 1] or exSkills[index - 1] == 0 then
		return skillID
	end

	return xyd.tables.partnerExSkillTable:getExID(skillID)[exSkills[index - 1]]
end

function BaseFighter:isBoss()
	if self.isMonster then
		return MonsterTable:isBoss(self:getTableID())
	end

	return false
end

function BaseFighter:getPasSkills()
	local pasSkills = {}
	local awake = self.awake
	local tableID = self:getHeroTableID()
	pasSkills[1] = PartnerTable:getPasSkill(tableID, 1)
	pasSkills[2] = PartnerTable:getPasSkill(tableID, 2)
	pasSkills[3] = PartnerTable:getPasSkill(tableID, 3)

	if awake and awake > 0 and awake < 6 then
		local changeSkills = xyd.split(PartnerTable:awakeSkill(tableID)[awake], "#", true)
		pasSkills[1] = changeSkills[2]
		pasSkills[2] = changeSkills[3]
		pasSkills[3] = changeSkills[4]
	end

	local grade = self.grade or 0

	for i = 1, 3 do
		local pasTier = PartnerTable:getPasTier(tableID, i)

		if grade < pasTier then
			pasSkills[i] = 0
		else
			pasSkills[i] = self:updateSkillId(pasSkills[i], xyd.SKILL_INDEX["PasSkill" .. i])
			local subSkills = xyd.tables.skillTable:getSubSkills(pasSkills[i])

			if subSkills and #subSkills > 0 then
				for _, subSkill in ipairs(subSkills) do
					if subSkill and subSkill > 0 then
						table.insert(pasSkills, subSkill)
					end
				end
			end
		end
	end

	return pasSkills
end

function BaseFighter:checkSkillIsPugong(skillID)
	if self:checkIsMindControl(skillID) then
		return true
	end

	local flag = false

	if #self.puGongIDs <= 0 then
		self:getPugongID()
	end

	flag = xyd.arrayIndexOf(self.puGongIDs, skillID) > -1

	return flag
end

function BaseFighter:checkIsMindControl(skillID)
	if skillID == 100001605 then
		return true
	end

	if skillID == 200000601 then
		return true
	end

	return false
end

function BaseFighter:getPugongID()
	if self.puGongID == nil then
		local partnerTable = PartnerTable
		local puGongID = partnerTable:getPugongID(self:getHeroTableID())

		table.insert(self.puGongIDs, puGongID)

		local pasSkills = self:getPasSkills()

		for i = 1, #pasSkills do
			local pasSkill = pasSkills[i]

			if pasSkill > 0 then
				local effects = SkillTable:getEffects(pasSkill)

				for j = 1, #effects do
					local effect = effects[j]

					for _, effectId in ipairs(effect) do
						if EffectTable:getType(effectId) == "changeCombat" then
							local tmpIDs = EffectTable:getNum(effectId, true)
							puGongID = tmpIDs[1]

							for _, skillID in ipairs(tmpIDs) do
								if xyd.arrayIndexOf(self.puGongIDs, skillID) < 0 then
									table.insert(self.puGongIDs, skillID)
								end
							end

							break
						end
					end
				end
			end
		end

		self.puGongID = puGongID
	end

	return self.puGongID
end

function BaseFighter:getEnergyID()
	if self.energyID == nil then
		self.energyID = self:updateSkillId(PartnerTable:getEnergyID(self:getHeroTableID()), xyd.SKILL_INDEX.Energy)
	end

	return self.energyID
end

function BaseFighter:getInitMp()
	return PartnerTable:getInitMp(self:getHeroTableID())
end

function BaseFighter:checkIsAttack(skillID)
	if self:isForceNoAttack(skillID) then
		return false
	end

	return self:checkSkillIsPugong(skillID) or self:getEnergyID() == skillID or self:getAddHurtID(skillID) or self:checkSkillHasAddHurtFreeArm(skillID)
end

function BaseFighter:isForceNoAttack(skillID)
	return self:isLiuBeiAttack(skillID)
end

function BaseFighter:isLiuBeiAttack(skillID)
	return skillID == 5401305 or skillID == 65402005 or skillID == 75401305 or skillID == 75401307 or skillID == 75401308 or skillID == 75401309 or skillID == 75401310 or skillID == 75401311 or skillID == 75401307
end

function BaseFighter:checkSkillHasAddHurtFreeArm(skillID)
	local effects = SkillTable:getEffects(skillID)

	for i = 1, #effects do
		for _, effect in ipairs(effects[i]) do
			if EffectTable:getType(effect) == xyd.BUFF_ADD_HURT_FREE_ARM then
				return true
			end
		end
	end

	return false
end

function BaseFighter:getAddHurtID(skillID)
	local effects = SkillTable:getEffects(skillID)

	for i = 1, #effects do
		for _, effect in ipairs(effects[i]) do
			if EffectTable:getType(effect) == xyd.BUFF_ADD_HURT or EffectTable:getType(effect) == xyd.BUFF_ADD_HURTD then
				return true
			end
		end
	end

	return false
end

function BaseFighter:initHeadView()
	local parentGo = self.parent:NodeByName("headView").gameObject
	local headView = HeadView.new(parentGo)

	headView:setInfo(self)

	self.headView = headView

	self:updateHeadViewPos()
end

function BaseFighter:updateHeadViewPos()
	local headView = self.headView
	local origin = self:getHeadPoint()
	local bloodPos = ModelTable:getBloodPos(self:getModelID())
	local x = bloodPos[1]
	local y = self:getScale() * origin.y + headView:getHeight() / 2 + bloodPos[2]

	headView:SetLocalPosition(x, y, 0)
	headView:SetLocalScale(bloodPos[3], bloodPos[3], 1)
end

function BaseFighter:getHeadView()
	return self.headView
end

function BaseFighter:getHeadPoint()
	local model = self.spineController
	local bone = model:getBone("Phead")
	local pos = {
		x = bone.X,
		y = bone.Y
	}

	return pos
end

function BaseFighter:getEnergy()
	return self.energy
end

function BaseFighter:updateEnergyBy(value)
	if value > 0 and self:isHasBuff(xyd.BUFF_GOD_CONTROL_ENERGY) then
		value = value * 0.5
	end

	self.energy = self.energy + value

	self:updateEnergy(self.energy)
end

function BaseFighter:updateEnergy(val)
	self.energy = math.min(val, 100)
	self.energy = math.max(val, 0)

	self:updateMpBar()
end

function BaseFighter:updateHpBy(value)
	self.hp = self.hp + value

	self:setHp()
end

function BaseFighter:updateHp(value)
	self.hp = value

	self:setHp()
end

function BaseFighter:isDeath()
	return self.hp <= 0
end

function BaseFighter:setHp()
	self.hp = math.max(self.hp, 0)
	self.hp = math.min(self.hp, 100)

	self:updateHpBar()
end

function BaseFighter:getHp()
	return self.hp
end

function BaseFighter:updateLostHpBar(value)
	if self.headView ~= nil then
		self.headView:updateLoseHp(value)
	end
end

function BaseFighter:updateHpBar()
	if self.headView ~= nil then
		self.headView:updateHpBar(self.hp)
	end
end

function BaseFighter:updateMpBar()
	if self.headView ~= nil then
		self.headView:updateMpBar(self.energy)
	end
end

function BaseFighter:getHurtTime(skillID, useSpeed)
	local fxs = SkillTable:getFx(skillID, self.skillIndex_)
	local duration = 0

	if fxs then
		for _, fx in ipairs(fxs) do
			if self:checkFxCanPlayInPos(fx) then
				local fxType = FxTable:getType(fx)
				local speed = FxTable:getSpeed(fx)

				if fxType == xyd.BattleFxType.BULLET or useSpeed then
					duration = xyd.checkCondition(speed > 0, speed, xyd.BULLET_DURATION)

					break
				else
					duration = xyd.checkCondition(speed < duration, duration, speed)
				end
			end
		end
	end

	return duration
end

function BaseFighter:getSpeedReduce(skillID)
	local fxs = xyd.tables.skillTable:getFx(skillID, self.skillIndex_)
	local duration = 0

	if fxs then
		for _, fx in pairs(fxs) do
			if self:checkFxCanPlayInPos(fx) then
				local dFxSpeed = xyd.tables.fxTable:getSpeedReduce(fx) or 0
				duration = xyd.checkCondition(dFxSpeed < duration, duration, dFxSpeed)
			end
		end

		return duration
	end
end

function BaseFighter:getAtkPoint(skillID, boneName)
	boneName = boneName or "Pattack01"
	local x = self.parent.transform.localPosition.x
	local y = self.parent.transform.localPosition.y
	local atkIndex = SkillTable:atkIndex(skillID)
	local bone = self.spineController:getBone(boneName)
	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1

	return {
		x = diretion * bone.X * self:getScale() + x,
		y = bone.Y * self:getScale() + y
	}
end

function BaseFighter:getAttackedPoint(isParent)
	if isParent == nil then
		isParent = true
	end

	local x = self.parent.transform.localPosition.x
	local y = self.parent.transform.localPosition.y
	local boneName = "Pshouji"
	local bone = self.spineController:getBone(boneName)
	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1

	if isParent == false then
		x = 0
		y = 0
	end

	return {
		x = diretion * bone.X * self:getScale() + x,
		y = bone.Y * self:getScale() + y
	}
end

function BaseFighter:playAttack(skillID, targets, callback)
	local name = "attack"

	if skillID == self:getEnergyID() then
		name = "skill"
	end

	local pos = 1

	if targets and targets[1] then
		pos = targets[1]:getPosIndex()

		if targets[1]:getTeamType() == xyd.TeamType.B then
			pos = pos - xyd.TEAM_B_POS_BASIC
		end
	end

	local animation = xyd.tables.skillTable:animation(skillID, self:getSkillIndex())

	if animation then
		if animation[pos] then
			name = animation[pos]
		elseif animation[1] then
			name = animation[1]
		end
	end

	self:playAnimation(name, function ()
		self:resumeIdle()
	end)
	self.spineController:addEvent(function (event)
		if callback ~= nil then
			callback(event)
		end
	end)
end

function BaseFighter:playOnlyAnimation(animationName)
	self:playAnimation(animationName, function ()
		self:resumeIdle()
	end)
end

function BaseFighter:playSound(skillID)
	local id = SkillTable:getSound(skillID, self.skillIndex_)

	if id > 0 then
		xyd.SoundManager.get():playSound(id)
	end
end

function BaseFighter:getSound(skillID)
	local id = SkillTable:getSound(skillID, self.skillIndex_)

	return id
end

function BaseFighter:getLayerByType(type)
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

function BaseFighter:playAll(skillID, targets)
	self.curTargets_ = targets
	local fxs = SkillTable:getFx(skillID, self.skillIndex_)

	if fxs then
		for id in pairs(fxs) do
			local fx = fxs[id]

			if self:checkFxCanPlayInPos(fx) then
				self:playSingleFx(fx, skillID)
			end
		end
	end
end

function BaseFighter:playSingleFx(fx, skillID, target, isAoe)
	if target and isAoe == false then
		self:playOne(fx, target, skillID)

		return
	end

	local targets = self.curTargets_

	if FxTable:isAoe(fx) == false then
		for i = 1, #targets do
			local target = targets[i]

			self:playOne(fx, target, skillID)
		end
	else
		local spUnitPos = FxTable:spUnitPos(fx)

		if #spUnitPos > 0 then
			for i = 1, #spUnitPos do
				self:playOne(fx, nil, skillID, spUnitPos[i])
			end
		else
			self:playOne(fx, self, skillID)
		end
	end
end

function BaseFighter:getEffect(effectName, scaleX, scaleY)
	local effect = BattleEffectFactory:getNewEffect(nil, effectName)
	effect.transform.localScale = Vector3(scaleX, scaleY, 1)

	table.insert(self.effects_, effect)

	return effect
end

function BaseFighter:returnToObjs(effect)
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

function BaseFighter:startAtFrame(spAnim, frame)
	if UNITY_ANDROID and XYDUtils.CompVersion(UnityEngine.Application.version, "1.2.56") <= 0 or UNITY_IOS and XYDUtils.CompVersion(UnityEngine.Application.version, "1.1.66") <= 0 then
		return
	end

	if not spAnim then
		return
	end

	spAnim:startAtFrame(frame)
end

function BaseFighter:stop(spAnim)
	if not spAnim then
		return
	end

	spAnim:stop()
end

function BaseFighter:playOne(fx, target, skillID, unitPos, renderDelta)
	if skillID == nil then
		skillID = 0
	end

	if unitPos == nil then
		unitPos = -1
	end

	if renderDelta == nil then
		renderDelta = 1
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
	local offY = -FxTable:getY(fx) * self.screenScaleY
	local isParallel = FxTable:isParallel(fx)
	local isPass = FxTable:isPass(fx)
	local nextTexiao = FxTable:getNextTexiao(fx)
	local effectWdith = FxTable:getWidth(fx)

	if effectWdith == 0 then
		effectWdith = 100
	end

	local texiaoIsPos = FxTable:texiaoIsPos(fx)
	local isAoe = FxTable:isAoe(fx)
	local playTimes = 1

	if isLoop then
		playTimes = 0
	end

	local pos = 1

	if target then
		pos = target:getPosIndex()

		if target:getTeamType() == xyd.TeamType.B and not self.isBattleHangUp then
			pos = pos - xyd.TEAM_B_POS_BASIC
		end

		if texiaoIsPos then
			texiaoName = texiaoName .. pos
		end
	end

	local dandaoXy = FxTable:getDandaoXy(fx, pos)
	local effect = self:getEffect(effectName, scale, scale)
	effect.name = "" .. tostring(fx) .. tostring(self.frameIndex_)

	if fx == 1059 then
		effect.name = "yueying"
	end

	local effectAnim = effect:GetComponent(typeof(SpineAnim))
	local targetDelta = nil
	effectAnim.timeScale = self.timeScale_

	if fx == 1145 then
		effectAnim:setToSetupPose()
	end

	local fxType = FxTable:getType(fx)
	local dandaoPoint = FxTable:getDandaoPoint(fx)

	if not dandaoPoint or dandaoPoint == "" then
		dandaoPoint = "Pattack01"
	end

	local uiLayer = nil

	if fxType == xyd.BattleFxType.BULLET then
		uiLayer = self:getLayerByType(xyd.BaseFightLayerType.TOP)

		ResCache.AddChild(uiLayer, effect)

		effect.transform.localScale = Vector3(scale * diretion, scale, 1)
		local atkPoint = self:getAtkPoint(skillID)
		local atkedPoint = nil

		if unitPos ~= -1 then
			if diretion == 1 then
				unitPos = unitPos + xyd.TEAM_B_POS_BASIC
			end

			atkedPoint = {
				x = xyd.HeroBattlePos[unitPos].x * 0.67,
				y = xyd.HeroBattlePos[unitPos].y * self.screenScaleY * 0.67
			}
		else
			atkedPoint = target:getAttackedPoint()
		end

		local rotateDiretion = (atkedPoint.x - atkPoint.x) * (atkedPoint.y - atkPoint.y) > 0 and 1 or -1
		effect.transform.localPosition = Vector3(atkPoint.x, atkPoint.y, 0)
		local lenX = math.abs(atkPoint.x - atkedPoint.x)
		local lenY = math.abs(atkPoint.y - atkedPoint.y)
		local rotate = degree(lenX, lenY)

		if not isParallel then
			effect.transform.localEulerAngles = Vector3(0, 0, rotate * rotateDiretion)
		end

		local action = self:getTimeLineLite()

		effectAnim:play(texiaoName, 0)

		local endX = atkedPoint.x
		local endY = atkedPoint.y
		local needTime = self:getHurtTime(skillID, true)

		if isPass then
			endX = endX + lenX * diretion
			endY = endY + lenY * rotateDiretion * diretion
			needTime = needTime * 2
		end

		action:Append(effect.transform:DOLocalMove(Vector3(endX, endY, 0), needTime))
		action:AppendCallback(function ()
			self:returnToObjs(effect)
		end)
		table.insert(self.actions, action)
	elseif fxType == xyd.BattleFxType.SPECIAL_BULLET then
		uiLayer = self:getLayerByType(xyd.BaseFightLayerType.TOP)

		ResCache.AddChild(uiLayer, effect)

		effect.transform.localScale = Vector3(scale * diretion, scale, 1)
		local atkPoint = self:getAtkPoint(skillID)
		local atkedPoint = {
			x = offX,
			y = offY
		}

		if diretion == 1 then
			atkedPoint.x = 720 - atkedPoint.x
		end

		local rotateDiretion = xyd.checkCondition((atkedPoint.x - atkPoint.x) * (atkedPoint.y - atkPoint.y) > 0, 1, -1)
		effect.transform.localPosition = Vector3(atkPoint.x, atkPoint.y, 0)
		local lenX = math.abs(atkPoint.x - atkedPoint.x)
		local lenY = math.abs(atkPoint.y - atkedPoint.y)
		local rotate = degree(lenX, lenY)

		if not isParallel then
			effect.transform.localEulerAngles = Vector3(0, 0, rotate * rotateDiretion)
		end

		local action = self:getTimeLineLite()

		effectAnim:play(texiaoName, 0)

		local endX = atkedPoint.x
		local endY = atkedPoint.y
		local needTime = self:getHurtTime(skillID, true)

		if isPass then
			endX = endX + lenX * diretion
			endY = endY + lenY * rotateDiretion * diretion
			needTime = needTime * 2
		end

		action:Append(effect.transform:DOLocalMove(Vector3(endX, endY, 0), needTime))
		action:AppendCallback(function ()
			self:returnToObjs(effect)
		end)
		table.insert(self.actions, action)
	elseif fxType == xyd.BattleFxType.HURT then
		if layer == xyd.FxLayerType.BOTTOM then
			uiLayer = target:getLayerByType(xyd.BaseFightLayerType.BUFF_BOT)
		else
			uiLayer = target:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
		end

		ResCache.AddChild(uiLayer, effect)

		local x_ = 0
		local y_ = 0

		if position == xyd.FxPositionType.BOTTOM then
			x_ = 0
			y_ = 0
		elseif position == xyd.FxPositionType.TOP then
			local origin = target:getHeadPoint()
			x_ = origin.x
			y_ = origin.y * target:getScale()

			if fx == 294 then
				y_ = y_ - 26
				x_ = x_ + 40 * -diretion
			end
		else
			local atkedPoint = self:getAttackedPoint(false)
			x_ = atkedPoint.x
			y_ = atkedPoint.y
		end

		effect.transform.localPosition = Vector3(x_, y_, 0)
		effect.transform.localScale = Vector3(scale * -diretion, scale, 1)

		effectAnim:play(texiaoName, playTimes)

		if playTimes ~= 0 and not retain then
			effectAnim:addListener("Complete", function ()
				self:returnToObjs(effect)
			end)
		end
	elseif fxType == xyd.BattleFxType.LASER then
		uiLayer = self:getLayerByType(xyd.BaseFightLayerType.TOP)

		ResCache.AddChild(uiLayer, effect)

		local atkPoint = self:getAtkPoint(skillID)
		local atkedPoint = target:getAttackedPoint()
		local rotateDiretion = (atkedPoint.x - atkPoint.x) * (atkedPoint.y - atkPoint.y) > 0 and 1 or -1
		local rotate = degree(math.abs(atkPoint.x - atkedPoint.x), math.abs(atkPoint.y - atkedPoint.y)) * rotateDiretion
		effect.transform.localPosition = Vector3(atkPoint.x, atkPoint.y, 0)
		effect.transform.localEulerAngles = Vector3(0, 0, rotate)
		local action = self:getTimeLineLite()

		effectAnim:play(texiaoName, 0)

		effect.transform.localScale = Vector3(0, scale, 1)
		local r = math.sqrt(math.pow(atkedPoint.x - atkPoint.x, 2) + math.pow(atkedPoint.y - atkPoint.y, 2))
		local endScaleX = diretion * r / effectWdith

		action:Append(effect.transform:DOScale(Vector3(endScaleX, scale, 1), self:getHurtTime(skillID)))
		action:Append(effect.transform:DOScale(Vector3(endScaleX, 0, 1), 0.15))
		action:AppendCallback(function ()
			self:returnToObjs(effect)
		end)
		table.insert(self.actions, action)
	elseif fxType == xyd.BattleFxType.SPECIAL_LASER then
		uiLayer = self:getLayerByType(xyd.BaseFightLayerType.TOP)

		ResCache.AddChild(uiLayer, effect)

		local atkPoint = self:getAtkPoint(skillID, dandaoPoint)

		if #dandaoXy == 2 then
			atkPoint.x = xyd.checkCondition(diretion == 1, dandaoXy[1], 720 - dandaoXy[1])
			atkPoint.y = dandaoXy[2]
		end

		local atkedPoint = target:getAttackedPoint()
		local parent = target:getParent()

		if position == xyd.FxPositionType.BOTTOM then
			atkedPoint.x = parent.x
			atkedPoint.y = parent.y
		elseif position == xyd.FxPositionType.TOP then
			local origin = target:getHeadPoint()
			atkedPoint.x = parent.x + origin.x
			atkedPoint.y = parent.y + origin.y * target:getScale()
		end

		atkedPoint.x = atkedPoint.x + diretion * offX
		atkedPoint.y = atkedPoint.y + offY
		local rotateDiretion = (atkedPoint.x - atkPoint.x) * (atkedPoint.y - atkPoint.y) > 0 and 1 or -1
		local rotate = degree(math.abs(atkPoint.x - atkedPoint.x), math.abs(atkPoint.y - atkedPoint.y)) * rotateDiretion
		effect.transform.localPosition = Vector3(atkPoint.x, atkPoint.y, 0)
		effect.transform.localEulerAngles = Vector3(0, 0, rotate)

		effectAnim:play(texiaoName, 1)
		effectAnim:addListener("Complete", function ()
			self:returnToObjs(effect)
		end)

		local r = math.sqrt(math.pow(atkedPoint.x - atkPoint.x, 2) + math.pow(atkedPoint.y - atkPoint.y, 2))
		effect.transform.localScale = Vector3(diretion * r / effectWdith, scale, 1)
	else
		if layer == xyd.FxLayerType.BOTTOM then
			uiLayer = target:getLayerByType(xyd.BaseFightLayerType.BOTTOM)
		else
			uiLayer = target:getLayerByType(xyd.BaseFightLayerType.TOP)
		end

		ResCache.AddChild(uiLayer, effect)

		effect.transform.localScale = Vector3(scale * diretion, scale, 1)
		local x_ = xyd.checkCondition(diretion == 1, offX, 720 - offX)
		effect.transform.localPosition = Vector3(x_, offY, 0)

		effectAnim:play(texiaoName, playTimes)

		if playTimes ~= 0 and not retain then
			effectAnim:addListener("Complete", function ()
				self:returnToObjs(effect)
			end)
		end

		if fxType == xyd.BattleFxType.SPECIAL then
			effectAnim:addEvent(function (event)
				if event and event.Data.Name == "hit" then
					self:playSingleFx(nextTexiao, skillID, target, isAoe)
				end
			end)
		end
	end

	local frameSkip = tonumber(xyd.tables.fxTable:getFrameSkip(fx)) or 0

	if frameSkip > 0 then
		self:startAtFrame(effectAnim, frameSkip)
	end

	if retain and playTimes > 0 then
		effectAnim:addListener("Complete", function ()
			if xyd.arrayIndexOf(self.effectsStayLastFrame_, effect) < 0 then
				table.insert(self.effectsStayLastFrame_, effect)
			end
		end)
	end

	effectAnim.RenderTarget = uiLayer:GetComponent(typeof(UIWidget))
	effectAnim.targetDelta = renderDelta

	return effect
end

function BaseFighter:die()
	self:clearBuffState()
	self:resetConfig()
	self:playDie()
end

function BaseFighter:die5()
	self:clearBuffState()
	self:resetConfig()
	self:playAnimation("dead", function ()
		self:getFighterModel():SetActive(false)
	end)

	local fxId = 1506
	local scale = FxTable:getScale(fxId)
	local effectName = FxTable:getResName(fxId)
	local offX = FxTable:getX(fxId)
	local offY = -FxTable:getY(fxId) * self.screenScaleY
	local layer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
	local dieEffect = layer:NodeByName("fuhuo_fx")

	if dieEffect then
		return
	end

	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1
	local effect = self:getEffect(effectName, scale, scale)

	ResCache.AddChild(layer, effect)

	effect.transform.localScale = Vector3(diretion * scale, scale, 1)
	effect.transform.localPosition = Vector3(offX, offY, 0)
	effect.name = "fuhuo_fx"
	local effectAnim = effect:GetComponent(typeof(SpineAnim))
	effectAnim.timeScale = self.timeScale_
	effectAnim.targetDelta = 1
	effectAnim.RenderTarget = layer:GetComponent(typeof(UIWidget))

	effectAnim:play("texiao01", 1)
	effectAnim:addListener("Complete", function ()
		effectAnim:play("texiao02", 0)
	end)
end

function BaseFighter:die2()
	self:clearBuffState()
	self:resetConfig()

	local effectName = ""
	local modelName = self:getModelName()

	if modelName == "yuji" or modelName == "yuji_awaken" or modelName == "yuji_10" or modelName == "yuji_pifu01" then
		effectName = "yujifuhuo"
	elseif modelName == "mijiale" then
		effectName = "mijiale_fuhuo"
	elseif modelName == "mijiale_awaken" then
		effectName = "mijiale_awaken_fuhuo"
	elseif modelName == "mijiale_10" then
		effectName = "mijiale_10_fuhuo"
	elseif modelName == "mijiale_pifu01" then
		effectName = "mijiale_pifu01_fuhuo"
	elseif modelName == "mijiale_pifu02" then
		effectName = "mijiale_pifu02_fuhuo"
	elseif modelName == "mijiale_pifu03" then
		effectName = "mijiale_pifu03_fuhuo"
	elseif modelName == "mijiale_pifu04" then
		effectName = "mijiale_pifu04_fuhuo"
	end

	self:playAnimation("dead", function ()
	end)

	local layer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
	local dieEffect = layer:NodeByName("fuhuo_fx")

	if dieEffect or effectName == "" then
		return
	end

	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1
	local effect = self:getEffect(effectName, 0.6, 0.6)

	ResCache.AddChild(layer, effect)

	effect.transform.localScale = Vector3(diretion * 0.6, 0.6, 1)
	effect.name = "fuhuo_fx"
	local effectAnim = effect:GetComponent(typeof(SpineAnim))
	effectAnim.timeScale = self.timeScale_
	effectAnim.targetDelta = 1
	effectAnim.RenderTarget = layer:GetComponent(typeof(UIWidget))

	effectAnim:play("texiao01", 1)
	effectAnim:addListener("Complete", function ()
		effectAnim:play("texiao02", 0)
	end)
end

function BaseFighter:die3()
	self.headView:SetActive(false)
	self.fighterModel:SetActive(false)
	self.shadow_:SetActive(false)

	local count = self.buffLayer.transform.childCount
	local trans = self.buffLayer.transform

	for i = 1, count do
		local child = trans:GetChild(i)

		if child.name ~= "805" .. self.frameIndex and child.name ~= "806" .. self.frameIndex then
			child:SetActive(false)
		end
	end

	count = self.buffBottomLayer.transform.childCount
	trans = self.buffBottomLayer.transform

	for i = 1, count do
		local child = trans:GetChild(i)

		if child.name ~= "805" .. self.frameIndex_ and child.name ~= "806" .. self.frameIndex_ then
			child:SetActive(false)
		end
	end
end

function BaseFighter:die4()
	self:clearBuffState()
	self:resetConfig()

	self.apateValue = 0
	local layer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
	local snakeEffect = layer:NodeByName("fuhuo_fx1")
	local circleEffect = layer:NodeByName("fuhuo_fx2")

	if circleEffect and snakeEffect then
		return self:playApateDie(circleEffect, snakeEffect, layer)
	end

	local snakeEffectName = ""
	local modelName = self:getModelName()
	snakeEffectName = modelName .. "_revival"
	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1
	snakeEffect = self:getEffect(snakeEffectName, 0.65, 0.65)

	ResCache.AddChild(layer, snakeEffect)

	snakeEffect.transform.localScale = Vector3(diretion * 0.65, 0.65, 1)
	snakeEffect.name = "fuhuo_fx1"

	snakeEffect:GetComponent(typeof(SpineAnim)):setToSetupPose()

	local snakeEffectEffectAnim = snakeEffect:GetComponent(typeof(SpineAnim))
	snakeEffectEffectAnim.targetDelta = 0
	circleEffect = self:getEffect("apate_buff02", 1, 1)

	ResCache.AddChild(layer, circleEffect)

	circleEffect.transform.localScale = Vector3(diretion * 1, 1, 1)
	circleEffect.transform.localPosition = Vector3(0, 102, 1)
	circleEffect.name = "fuhuo_fx2"

	circleEffect:GetComponent(typeof(SpineAnim)):setToSetupPose()

	local circleEffectAnim = circleEffect:GetComponent(typeof(SpineAnim))
	circleEffectAnim.targetDelta = 1

	self:playApateDie(circleEffect, snakeEffect, layer)
end

function BaseFighter:playApateDie(circleEffect, snakeEffect, layer)
	self:playAnimation("dead", function ()
		self:getFighterModel():SetActive(false)

		local snakeEffectEffectAnim = snakeEffect:GetComponent(typeof(SpineAnim))
		snakeEffectEffectAnim.timeScale = self.timeScale_
		snakeEffectEffectAnim.RenderTarget = layer:GetComponent(typeof(UIWidget))

		self:stop(snakeEffectEffectAnim)
		snakeEffectEffectAnim:play("texiao01", 1)
		self:startAtFrame(snakeEffectEffectAnim, 0)

		local buff = {
			name = xyd.BUFF_APATE_REVIVE
		}

		if self.apateValue < 4 then
			table.insert(self.buffs, buff)

			self.apateValue = self.apateValue + 1
		end

		self:apateHeadView()
		snakeEffectEffectAnim:addListener("Complete", function ()
			snakeEffectEffectAnim.timeScale = self.timeScale_

			snakeEffectEffectAnim:play("texiao02", 0)
		end)
		circleEffect:SetActive(true)

		local circleEffectAnim = circleEffect:GetComponent(typeof(SpineAnim))
		circleEffectAnim.timeScale = self.timeScale_

		self:stop(circleEffectAnim)
		circleEffectAnim:play("texiao0" .. self.apateValue * 2 - 1, 1)
		self:startAtFrame(circleEffectAnim, 0)

		circleEffectAnim.RenderTarget = layer:GetComponent(typeof(UIWidget))

		circleEffectAnim:addListener("Complete", function ()
			circleEffectAnim.timeScale = self.timeScale_

			circleEffectAnim:play("texiao0" .. self.apateValue * 2, 0)
		end)
	end)
end

function BaseFighter:getValue()
	return self.apateValue
end

function BaseFighter:setValue(value)
	self.apateValue = value
end

function BaseFighter:revive()
	local layer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
	local effect = layer:NodeByName("fuhuo_fx")

	self:getFighterModel():SetActive(true)

	if effect then
		local obj = effect.gameObject
		local effectAnim = obj:GetComponent(typeof(SpineAnim))
		effectAnim.timeScale = self.timeScale_

		effectAnim:play("texiao03", 1)
		effectAnim:addListener("Complete", function ()
			self:returnToObjs(obj)
		end)
	end

	self:resumeIdle()
end

function BaseFighter:apateRevive(buffOn)
	if buffOn == 3 then
		local layer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
		local snakeEffect = layer:NodeByName("fuhuo_fx1")
		local circleEffect = layer:NodeByName("fuhuo_fx2")

		for i = #self.buffs, 1, -1 do
			local b = self.buffs[i]

			if b.name ~= xyd.BUFF_STAR_MOON then
				table.remove(self.buffs, i)
			end
		end

		self.apateValue = 0

		self:refreshBuffIcons()

		if circleEffect and snakeEffect then
			self:stop(self.spineController)

			if self:getModelName() == "apate_pifu02" or self:getModelName() == "apate_pifu03" then
				self.spineController:setToSetupPose()
			end

			self:resumeIdle()
			self:startAtFrame(self.spineController, 0)

			local circleEffectAnim = circleEffect:GetComponent(typeof(SpineAnim))
			circleEffectAnim.timeScale = self.timeScale_

			self:returnToObjs(circleEffect.gameObject)
			self.headView:apateHeadViewRevive()

			local snakeEffectEffectAnim = snakeEffect:GetComponent(typeof(SpineAnim))
			snakeEffectEffectAnim.timeScale = self.timeScale_

			snakeEffectEffectAnim:play("texiao04", 1)
			snakeEffectEffectAnim:addListener("Complete", function ()
				self:getFighterModel():SetActive(true)
				self:returnToObjs(snakeEffect.gameObject)
			end)
		end
	end
end

function BaseFighter:playDie()
	self:playAnimation("dead", function ()
		self.parent:SetActive(false)
	end)
end

function BaseFighter:playWin()
	self:playAnimation("win", nil, 0)
end

function BaseFighter:attacked()
	if self.isHoldEnergyPose then
		self:playAnimation("skillhurt", function ()
			self:playAnimation("skill01", nil, 0)
		end)
	else
		self:changeColor(xyd.BattleColor.hurtRedMatrix, 0.13)
		self:playAnimation("hurt", function ()
			self:resumeIdle()
		end)
	end
end

function BaseFighter:playBlock()
	self:playFloatText({
		xyd.BattleFloatType.BLOCK
	}, self:getTeamType(), function ()
		self.floatTextPos = self.floatTextPos - 1
	end)
end

function BaseFighter:playShanbi()
	self:playFloatText({
		xyd.BattleFloatType.MISS
	}, self:getTeamType(), function ()
		self.floatTextPos = self.floatTextPos - 1
	end)

	local action = self:getTimeLineLite()
	local diretion = self:getTeamType() == xyd.TeamType.A and 1 or -1
	local model = self:getFighterModel()
	local oldX = model.transform.localPosition.x
	local oldY = model.transform.localPosition.y

	action:Append(model.transform:DOLocalMove(Vector3(oldX - 75 * diretion, oldY, 0), 0.13)):Append(model.transform:DOLocalMove(Vector3(oldX, oldY, 0), 0.2))
end

function BaseFighter:playFree()
	self:playFloatText({
		xyd.BattleFloatType.FREE
	}, self:getTeamType(), function ()
		self.floatTextPos = self.floatTextPos - 1
	end)
end

function BaseFighter:playAnimation(name, callback, num)
	if num == nil then
		num = 1
	end

	self.spineController:play(name, num)

	self.spineController.timeScale = self.timeScale_

	self.spineController:addListener("Complete", function ()
		if callback ~= nil then
			callback()
		end
	end)
end

function BaseFighter:playFloatText(floatTypes, side, callback)
	side = side or 1
	local resultViews = {}

	for i = 1, #floatTypes do
		local type_ = floatTypes[i]
		local path = nil

		if type_ == xyd.BattleFloatType.MISS then
			path = "battle_text_miss1"
		elseif type_ == xyd.BattleFloatType.FREE then
			path = "battle_text_immunity"
		elseif type_ == xyd.BattleFloatType.BLOCK then
			path = "battle_text_block"
		end

		local view = NGUITools.AddChild(self.parent, "floatText")
		local sp = view:AddComponent(typeof(UISprite))

		xyd.setUISpriteAsync(sp, xyd.Atlas.BATTLE, path, nil, false, true)

		sp.depth = self.parent:GetComponent(typeof(UIWidget)).depth + 12

		view:SetActive(false)
		table.insert(resultViews, view)

		local atkedPoint = self:getAttackedPoint(false)

		view:Y(atkedPoint.y + math.max(0, self.floatTextPos * 50))

		self.floatTextPos = self.floatTextPos + 1
	end

	if #resultViews > 0 then
		self:playFloatAnimation(resultViews, callback)
	elseif callback ~= nil then
		callback()
	end
end

function BaseFighter:getNumView(num, isCrit, isRestarint)
	local parentGo = self:getLayerByType(xyd.BaseFightLayerType.TOP)
	local pngNum = PngNum.new(parentGo)
	local iconName = ""
	local isHeath = false

	if num < 0 then
		if isCrit then
			iconName = "battle_crit"
		elseif isRestarint then
			iconName = "battle_restraint"
		else
			iconName = "battle_normal"
		end
	else
		isHeath = true
		iconName = "battle_heath"
	end

	local ifAbbr = xyd.db.misc:getValue("abbr_battle_num")
	local isAbbr = false

	if tonumber(ifAbbr) and tonumber(ifAbbr) ~= 0 then
		isAbbr = true
	end

	pngNum:setInfo({
		isShowAdd = true,
		iconName = iconName,
		num = num,
		isAbbr = isAbbr
	})

	pngNum.scale = 0.9

	return pngNum
end

function BaseFighter:playHPDeltas(hpDeltas, callback)
	local hpViews = {}

	for _, hpDelta in ipairs(hpDeltas) do
		local value = hpDelta.value
		local isCure = value > 0
		local isCrit = hpDelta.isCrit
		local isRestarint = hpDelta.isRestarint
		local label = self:getNumView(value, isCrit, isRestarint)

		label:getGameObject():SetActive(false)

		local atkedPoint = self:getAttackedPoint()
		local x_ = nil

		if isCrit then
			x_ = atkedPoint.x
		elseif isCure then
			local diretion = self:getTeamType() == xyd.TeamType.A and -1 or 1
			local offX = self.posIndex % 7 <= 2 and 0 or -50
			local width = label:getWidth()
			local height = label:getHeight()
			local mainGroup = label:getMainGroup()

			mainGroup:SetLocalPosition(0, height / 2, 0)

			x_ = atkedPoint.x + diretion * (0.8 * width / 2 + offX)
		else
			x_ = atkedPoint.x
		end

		label:SetLocalPosition(x_, atkedPoint.y - 30, 0)
		table.insert(hpViews, {
			view = label,
			isCrit = isCrit,
			isRestarint = isRestarint,
			isCure = isCure
		})
	end

	if #hpViews > 0 then
		self:playNumberFloat(hpViews, callback)
	end
end

function BaseFighter:playNumberFloat(hpViews, callback)
	local complete = nil

	function complete()
		if callback ~= nil then
			callback()
		end
	end

	local duration = 0.5
	local deltaY = 100
	local scaleDuration = 0.1
	local fadeDelay = 0.25
	local playFloat = nil

	function playFloat(view, isCrit, isRestarint, isCure, callback2)
		local transform = view:getGameObject().transform
		local scaleX = transform.localScale.x
		local scaleY = transform.localScale.y
		local x_ = transform.localPosition.x
		local y_ = transform.localPosition.y
		local action = self:getTimeLineLite()

		view:getGameObject():SetActive(true)

		local diretion = self:getTeamType() == xyd.TeamType.A and -1 or 1
		local w = view:getGameObject():GetComponent(typeof(UIWidget))

		local function getter()
			return w.color
		end

		local function setter(value)
			w.color = value
		end

		if isCrit then
			action:Append(transform:DOScale(Vector3(scaleX * 1.25, scaleY * 1.25, 1), 0.067))
			action:Append(transform:DOScale(Vector3(scaleX * 0.9, scaleY * 0.9, 1), 0.1))
			action:Append(transform:DOScale(Vector3(scaleX * 1.05, scaleY * 1.05, 1), 0.1))
			action:Append(transform:DOScale(Vector3(scaleX * 0.95, scaleY * 0.95, 1), 0.067))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY, 1), 0.067))
			action:AppendInterval(0.1 / self.timeScale_)
			action:Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 0, 0.8))
			action:Join(transform:DOLocalMove(Vector3(x_, y_ + 40, 0), 0.8))
			action:AppendCallback(callback2)
		elseif isCure then
			action:Append(transform:DOScale(Vector3(scaleX, scaleY + 0.2, 1), 0.17))
			action:Join(transform:DOLocalMove(Vector3(x_ + 7 * diretion, y_ + 40, 1), 0.17))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY - 0.1, 1), 0.17))
			action:Join(transform:DOLocalMove(Vector3(x_ + 15 * diretion, y_, 1), 0.17))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY + 0.06, 1), 0.13))
			action:Join(transform:DOLocalMove(Vector3(x_ + 18 * diretion, y_ + 10, 1), 0.13))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY - 0.06, 1), 0.13))
			action:Join(transform:DOLocalMove(Vector3(x_ + 22 * diretion, y_, 1), 0.13))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY + 0.04, 1), 0.1))
			action:Join(transform:DOLocalMove(Vector3(x_ + 24 * diretion, y_ + 5, 1), 0.1))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY - 0.04, 1), 0.1))
			action:Join(transform:DOLocalMove(Vector3(x_ + 25 * diretion, y_, 1), 0.1))
			action:AppendInterval(0.3 / self.timeScale_)
			action:Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 0, 0.1))
			action:AppendCallback(callback2)
		else
			action:Append(transform:DOScale(Vector3(scaleX * 1.25, scaleY * 1.25, 1), 0.067))
			action:Append(transform:DOScale(Vector3(scaleX * 0.9, scaleY * 0.9, 1), 0.1))
			action:Append(transform:DOScale(Vector3(scaleX * 1.05, scaleY * 1.05, 1), 0.1))
			action:Append(transform:DOScale(Vector3(scaleX * 0.95, scaleY * 0.95, 1), 0.067))
			action:Append(transform:DOScale(Vector3(scaleX, scaleY, 1), 0.067))
			action:AppendInterval(0.1 / self.timeScale_)
			action:Append(DG.Tweening.DOTween.ToAlpha(getter, setter, 0, 0.8))
			action:Join(transform:DOLocalMove(Vector3(x_, y_ + 40, 0), 0.8))
			action:AppendCallback(callback2)
		end
	end

	local actions = nil

	if #hpViews > 1 then
		actions = self:getTimeLineLite()
	end

	local interval = 0.25

	for i = 1, #hpViews do
		local view = hpViews[i].view
		local isCrit = hpViews[i].isCrit
		local isRestarint = hpViews[i].isRestarint
		local isLast = i == #hpViews
		local isCure = hpViews[i].isCure
		local play = nil

		function play()
			playFloat(view, isCrit, isRestarint, isCure, function ()
				NGUITools.Destroy(view:getGameObject())

				if isLast then
					complete()
				end
			end)
		end

		if i > 1 then
			actions:AppendInterval(interval / self.timeScale_)
		end

		if #hpViews == 1 then
			play()
		else
			actions:AppendCallback(play)
		end
	end
end

function BaseFighter:playFloatAnimation(resultViews, callback, delay)
	if delay == nil then
		delay = 0
	end

	local complete = nil

	function complete()
		if callback ~= nil then
			callback()
		end
	end

	local playFloat = nil

	function playFloat(view, callback)
		local w = view:GetComponent(typeof(UIWidget))

		local function getter()
			return w.color
		end

		local function setter(value)
			w.color = value
		end

		local action = self:getTimeLineLite()

		view:SetActive(true)

		w.alpha = 0
		local transform = view.transform
		local y_ = transform.localPosition.y
		local x_ = transform.localPosition.x

		action:Append(transform:DOLocalMove(Vector3(x_, y_ + 10, 0), 0.15)):Join(DG.Tweening.DOTween.ToAlpha(getter, setter, 1, 0.15)):Append(transform:DOLocalMove(Vector3(x_, y_ + 20, 0), 0.25)):Append(transform:DOLocalMove(Vector3(x_, y_ + 40, 0), 0.6)):Join(DG.Tweening.DOTween.ToAlpha(getter, setter, 0, 0.6)):AppendCallback(callback)
	end

	local actions = self:getTimeLineLite()
	local interval = 0.25

	for i = 1, #resultViews do
		local view = resultViews[i]
		local isLast = i == #resultViews
		local play = nil

		function play()
			playFloat(view, function ()
				NGUITools.Destroy(view)

				if isLast then
					complete()
				end
			end)
		end

		if i > 1 then
			actions:AppendInterval(interval / self.timeScale_)
		end

		if #resultViews == 1 then
			play()
		else
			actions:AppendCallback(play)
		end
	end
end

function BaseFighter:recordDamageNumber(result)
	table.insert(self.damageNumbers, result)
end

function BaseFighter:playAllDamageNumbers()
	if #self.damageNumbers <= 0 then
		return 0
	end

	local isMiss = false
	local isFree = false
	local isBlock = false
	local value1 = 0
	local value2 = 0
	local crit1 = false
	local crit2 = false
	local restraint1 = false
	local restraint2 = false

	for index = 1, #self.damageNumbers do
		local result = self.damageNumbers[index]
		local value = result.value
		local isCrit = result.isCrit
		local isRestarint = result.isRestarint

		if result.isMiss then
			isMiss = true
		elseif result.isFree then
			isFree = true
		elseif value > 0 then
			if value1 >= 0 then
				value1 = value1 + value
				crit1 = crit1 or isCrit
			else
				value2 = value2 + value
				crit2 = crit2 or isCrit
			end
		elseif value < 0 then
			if value1 <= 0 then
				value1 = value1 + value
				crit1 = crit1 or isCrit
				restraint1 = restraint1 or isRestarint
			else
				value2 = value2 + value
				crit2 = crit2 or isCrit
				restraint2 = restraint2 or isRestarint
			end
		end

		if result.isBlock then
			isBlock = true
		end
	end

	if isMiss then
		self:playShanbi()
	end

	if isFree then
		self:playFree()
	end

	local hpDeltas = {}
	local extraHpDeltas = {}
	local totalHarm = 0

	if value1 ~= 0 then
		table.insert(hpDeltas, {
			value = value1,
			isCrit = crit1,
			isRestarint = restraint1
		})

		if value1 < 0 then
			totalHarm = totalHarm + value1
		end
	end

	if value2 ~= 0 then
		table.insert(hpDeltas, {
			value = value2,
			isCrit = crit2,
			isRestarint = restraint2
		})

		if value2 < 0 then
			totalHarm = totalHarm + value2
		end
	end

	self:playHPDeltas(hpDeltas)

	local action = self:getTimeLineLite()

	for i = 1, #extraHpDeltas do
		action:AppendInterval(self.splitDelay[i] / 30)
		action:AppendCallback(function ()
			self:playHPDeltas({
				extraHpDeltas[i]
			})
		end)
	end

	self.splitDelay = {}
	self.splitPercent = {}

	if isBlock then
		self:playBlock()
	end

	self.damageNumbers = {}

	return totalHarm
end

function BaseFighter:refreshBuffIcons()
	if not self:isHasBuff(xyd.BUFF_STONE) and self.isInStone_ then
		self:changeColor()

		self.isInStone_ = false
	end

	self:checkLoseHp()

	if self.headView then
		self.headView:refreshBuffIcons(self.buffs)
	end
end

function BaseFighter:checkLoseHp()
	local percent = 0
	local maxNum = 0

	for _, buff in ipairs(self.buffs) do
		if buff.name == xyd.BUFF_MAYA_HP_LOSE_SEAL then
			local effectArr = EffectTable:getNum(buff.table_id, true)
			percent = percent + effectArr[1]
			maxNum = effectArr[2]
		end
	end

	if maxNum > 0 and maxNum < percent then
		percent = maxNum
	end

	self:updateLostHpBar(percent)
end

function BaseFighter:addBuffs(buff)
	local times = 0

	for _, buff_ in ipairs(self.buffs) do
		if buff_.name == xyd.BUFF_APATE_REVIVE then
			times = times + 1
		end

		if times >= 4 and buff.name == xyd.BUFF_APATE_REVIVE then
			return
		end
	end

	table.insert(self.buffs, buff)
end

function BaseFighter:playTransform(tableID)
	self.tableID_ = tableID
	self.isMonster = false

	if self:getFighterModel() then
		self:getFighterModel():SetActive(false)

		self:getFighterModel().transform.parent = nil
	end

	self:initModel(-1)
	self:resumeIdle()

	self.defaultColor = xyd.BattleColor.fenshenMatrix

	self:changeColor()
	self:updateHeadViewPos()
	self:clearBuffState()
	self:resetConfig()

	self.puGongIDs = {}
	self.puGongID = nil
	self.addHurtID = nil
end

function BaseFighter:playGetLeaf(buffName, buffOn, clear)
	local time = 0.5

	if clear and self.isGetLeaf then
		self.isGetLeaf = false
		local fighterModel = self:getFighterModel()
		local action1 = self:getTimeLineLite()

		action1:Append(fighterModel.transform:DOScale(Vector3(self.initScaleX, self.initScaleY, 1), time):SetEase(DG.Tweening.Ease.InOutSine))

		local action2 = self:getTimeLineLite()
		local buffLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)

		action2:Append(buffLayer.transform:DOScale(Vector3(1, 1, 1), time):SetEase(DG.Tweening.Ease.InOutSine))

		local action3 = self:getTimeLineLite()
		local buffBottomLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_BOT)

		action3:Append(buffBottomLayer.transform:DOScale(Vector3(1, 1, 1), time):SetEase(DG.Tweening.Ease.InOutSine))

		return
	end

	if buffOn == true and not self.isGetLeaf then
		self.isGetLeaf = true
		local fighterModel = self:getFighterModel()
		local action1 = self:getTimeLineLite()
		self.initScaleX = fighterModel.transform.localScale.x
		self.initScaleY = fighterModel.transform.localScale.y

		action1:Append(fighterModel.transform:DOScale(Vector3(self.initScaleX * 0.8, self.initScaleY * 0.8, 1), time):SetEase(DG.Tweening.Ease.InOutSine))

		local action2 = self:getTimeLineLite()
		local buffLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)

		action2:Append(buffLayer.transform:DOScale(Vector3(0.8, 0.8, 1), time):SetEase(DG.Tweening.Ease.InOutSine))

		local action3 = self:getTimeLineLite()
		local buffBottomLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_BOT)

		action3:Append(buffBottomLayer.transform:DOScale(Vector3(0.8, 0.8, 1), time):SetEase(DG.Tweening.Ease.InOutSine))
	end
end

function BaseFighter:playExchangeSpd(buffName)
	if self.buffState[buffName] and self.buffState[buffName][1] then
		local effect = self.buffState[buffName][1]
		local SpineController = effect:GetComponent(typeof(SpineAnim))
		local action1 = self:getTimeLineLite()

		SpineController:setAlpha(0.01)

		local function getter()
			return SpineController.ToAlpha
		end

		local function setter(value)
			SpineController.ToAlpha = value
		end

		action1:Append(DG.Tweening.DOTween.To(DG.Tweening.Core.DOSetter_float(setter), 0.01, 1, 0.5):SetEase(DG.Tweening.Ease.InOutSine))
	end
end

function BaseFighter:isHasStone()
	local flag = false

	for i = #self.buffs, 1, -1 do
		local b = self.buffs[i]

		if b.name == xyd.BUFF_STONE then
			flag = true

			break
		end
	end

	return flag
end

function BaseFighter:removeBuffs(buff)
	for i = 1, #self.buffs do
		local b = self.buffs[i]

		if buff.name == b.name and b.value * buff.value >= 0 then
			table.remove(self.buffs, i)

			break
		end
	end
end

function BaseFighter:removeBuff(name)
	for i = #self.buffs, 1, -1 do
		local b = self.buffs[i]

		if name == b.name then
			self.buffs = xyd.splice(self.buffs, i, 1)
		end
	end
end

function BaseFighter:getBuffByName(name)
	for i, _ in ipairs(self.buffs) do
		local buff = self.buffs[i]

		if buff.name == name then
			return buff
		end
	end

	return nil
end

function BaseFighter:isHasBuff(name)
	for i = 1, #self.buffs do
		local buff = self.buffs[i]

		if buff.name == name then
			return true
		end
	end

	return false
end

function BaseFighter:isInRoots()
	for index = 1, #self.buffs do
		local buff = self.buffs[index]

		if DBuffTable:isRoots(buff.name) then
			return true
		end
	end

	return false
end

function BaseFighter:checkFxCanPlayInPos(fx)
	local flag = true
	local targetPos = xyd.tables.fxTable:targetPos(fx)

	if targetPos and #targetPos > 0 and targetPos[1] then
		local selfPos = self:getPosIndex()

		if self:getTeamType() == xyd.TeamType.B then
			selfPos = selfPos - xyd.TEAM_B_POS_BASIC
		end

		if xyd.arrayIndexOf(targetPos, selfPos) <= 0 then
			flag = false
		end
	end

	return flag
end

function BaseFighter:playHurtFx(fxs)
	local t = 0

	if fxs and next(fxs) and #fxs > 0 then
		local topLayer = 0
		local bottomLayer = 0
		local curLayerNum = 0

		for _, fx in ipairs(fxs) do
			if self:checkFxCanPlayInPos(fx) and not xyd.Battle.aoeBuffEffect_[self:getAoeEffectKey(fx)] then
				local tmpT = FxTable:getSpeed(fx)
				t = xyd.checkCondition(t < tmpT, tmpT, t)
				local layer = FxTable:getLayer(fx)
				local uiLayer = nil

				if layer == xyd.FxLayerType.BOTTOM then
					uiLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_BOT)
					bottomLayer = bottomLayer + 1
					curLayerNum = bottomLayer
				else
					uiLayer = self:getLayerByType(xyd.BaseFightLayerType.BUFF_TOP)
					topLayer = topLayer + 1
					curLayerNum = topLayer
				end

				if not uiLayer:NodeByName("" .. tostring(fx) .. tostring(self.frameIndex_)) then
					self:playOne(fx, self, nil, , curLayerNum)
				end

				if xyd.tables.fxTable:isAoe(fx) then
					xyd.Battle.aoeBuffEffect_[self:getAoeEffectKey(fx)] = true
				end
			end
		end
	end

	return t
end

function BaseFighter:getAoeEffectKey(fx)
	return fx .. "|" .. self:getTeamType() .. "|" .. self.frameIndex_
end

function BaseFighter:playBuffEffectByFx(buffName, fxs)
	if not self.buffState[buffName] and fxs and #fxs > 0 then
		for _, fx in ipairs(fxs) do
			if fx and not xyd.Battle.aoeBuffEffect_[self:getAoeEffectKey(fx)] then
				local retain = xyd.tables.fxTable:isRetain(fx)
				local effect = self:playOne(fx, self)

				if retain then
					if not self.buffState[buffName] then
						self.buffState[buffName] = {}
					end

					table.insert(self.buffState[buffName], effect)
				end

				if DBuffTable:isRoots(buffName) then
					self:pause(true)
				end

				if FxTable:isAoe(fx) then
					xyd.Battle.aoeBuffEffect_[self:getAoeEffectKey(fx)] = true
				end
			end
		end
	end
end

function BaseFighter:playBuffEffect(buffName, buffFighter)
	local fx = DBuffTable:getFx(buffName)
	local canEffect = true

	if buffName == xyd.BUFF_BOSS_STORM and self:isHasBuff(buffName) then
		canEffect = false
	end

	if canEffect then
		self:playBuffEffectByFx(buffName, fx)
	end

	if buffFighter then
		local modelID = buffFighter:getModelID()
		local heroWorkFx = DBuffTable:heroWorkFx(buffName, modelID)

		if heroWorkFx and heroWorkFx[2] then
			local fxType = FxTable:getType(heroWorkFx[2])

			if fxType == xyd.BattleFxType.NORMAL then
				buffFighter:playBuffEffectByFx(buffName, {
					heroWorkFx[2]
				})
			else
				self:playBuffEffectByFx(buffName, {
					heroWorkFx[2]
				})
			end
		end
	end

	if buffName == xyd.BUFF_STONE then
		self:changeColor(xyd.BattleColor.grey)
		self:pause(true)

		self.isInStone_ = true
	end
end

function BaseFighter:clearBuffOff()
	for name in pairs(self.buffState) do
		local effects = self.buffState[name]

		if effects ~= nil and self:isHasBuff(name) == false then
			for _, effect in ipairs(effects) do
				self:returnToObjs(effect)
			end

			self.buffState[name] = nil

			if name == xyd.BUFF_GET_LEAF then
				self:playGetLeaf(name, false, true)
			end
		end
	end

	if self.isPause_ and self:isInRoots() == false then
		self:resume(true)
	end
end

function BaseFighter:clearBuffState()
	for name in pairs(self.buffState) do
		local effects = self.buffState[name]

		if effects ~= nil then
			for _, effect in ipairs(effects) do
				self:returnToObjs(effect)
			end

			self.buffState[name] = nil
		end
	end
end

function BaseFighter:getAttackTime(skillID, targets)
	local name = "attack"

	if skillID == self:getEnergyID() then
		name = "skill"
	end

	local pos = 1

	if targets and targets[1] then
		pos = targets[1]:getPosIndex()

		if targets[1]:getTeamType() == xyd.TeamType.B then
			pos = pos - xyd.TEAM_B_POS_BASIC
		end
	end

	local animation = SkillTable:animation(skillID, self:getSkillIndex())

	if animation then
		if animation[pos] then
			name = animation[pos]
		elseif animation[1] then
			name = animation[1]
		end
	end

	local duration = self.spineController:getAnimationTime(name)

	return duration
end

function BaseFighter:getAnimationTime(animationName)
	return self.spineController:getAnimationTime(animationName)
end

function BaseFighter:getChangeTime(skillID)
	local changeTime = {}

	if skillID == self:getEnergyID() then
		changeTime = ModelTable:getSkillTime(self:getModelID())
	else
		changeTime = ModelTable:getAtkTime(self:getModelID())
	end

	return changeTime
end

function BaseFighter:pause(onlyModel)
	if onlyModel == nil then
		onlyModel = false
	end

	self.spineController:pause()

	if onlyModel == false then
		for i = 1, #self.actions do
			local action = self.actions[i]

			action:Pause()
		end

		for i = 1, self.buffLayer.transform.childCount do
			local child = self.buffLayer.transform:GetChild(i - 1).gameObject
			local spineAnim = child:GetComponent(typeof(SpineAnim))

			if spineAnim then
				spineAnim:pause()
			end
		end

		for i = 1, self.buffBottomLayer.transform.childCount do
			local child = self.buffBottomLayer.transform:GetChild(i - 1).gameObject
			local spineAnim = child:GetComponent(typeof(SpineAnim))

			if spineAnim then
				spineAnim:pause()
			end
		end
	else
		self.isPause_ = true
	end
end

function BaseFighter:resume(onlyModel)
	if onlyModel == nil then
		onlyModel = false
	end

	if onlyModel and self.isPause_ then
		self.isPause_ = false

		self:resumeIdle()
	elseif not self.isPause_ or self:isInRoots() ~= true then
		self.spineController:resume()
	end

	if onlyModel == false then
		for i = 1, #self.actions do
			local action = self.actions[i]

			action:Play()
		end

		for i = 1, self.buffLayer.transform.childCount do
			local child = self.buffLayer.transform:GetChild(i - 1).gameObject
			local spineAnim = child:GetComponent(typeof(SpineAnim))

			if spineAnim then
				spineAnim:resume()
			end
		end

		for i = 1, self.buffBottomLayer.transform.childCount do
			local child = self.buffBottomLayer.transform:GetChild(i - 1).gameObject
			local spineAnim = child:GetComponent(typeof(SpineAnim))

			if spineAnim then
				spineAnim:resume()
			end
		end
	end
end

function BaseFighter:holdEnergyPose()
	local function eventCallback()
		self:playAnimation("skill01", nil, 0)
	end

	self:playAnimation("skill02", eventCallback, 1)
	xyd.SoundManager.get():playSound(1141)

	self.isHoldEnergyPose = true
end

function BaseFighter:getTimeLineLite()
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

function BaseFighter:setTimeScale(num)
	self.timeScale_ = num
end

function BaseFighter:getTimeScale()
	return self.timeScale_
end

function BaseFighter:battleSpeed()
end

function BaseFighter:clearAction()
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

function BaseFighter:apateHeadView()
	self.headView:apateHeadViewDie()
	self:refreshBuffIcons()
end

return BaseFighter
