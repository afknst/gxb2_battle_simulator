local BattleController = class("BattleController", import("app.controllers.BaseController"))
local cjson = require("cjson")
local battleMID = {
	[xyd.mid.MAP_FIGHT] = 1,
	[xyd.mid.DUNGEON_FIGHT] = 2,
	[xyd.mid.TOWER_FIGHT] = 3,
	[xyd.mid.TOWER_REPORT] = 4,
	[xyd.mid.QUIZ_FIGHT] = 5,
	[xyd.mid.ARENA_FIGHT] = 6,
	[xyd.mid.FRIEND_FIGHT_BOSS] = 7,
	[xyd.mid.FRIEND_FIGHT_FRIEND] = 8,
	[xyd.mid.TRIAL_FIGHT] = 9,
	[xyd.mid.GUILD_BOSS_FIGHT] = 10,
	[xyd.mid.ARENA_3v3_FIGHT] = 11,
	[xyd.mid.ARENA_TEAM_FIGHT] = 12,
	[xyd.mid.PARTNER_CHALLENGE_FIGHT] = 13,
	[xyd.mid.PARTNER_CHALLENGE_GET_REPORT] = 14,
	[xyd.mid.FRIEND_TEAM_BOSS_FIGHT] = 15,
	[xyd.mid.FIGHT_CHESS] = 16,
	[xyd.mid.GUILD_COMPETITION_BATTLE] = 17
}
local MainPlotListTable = xyd.tables.mainPlotListTable
local StageTable = xyd.tables.stageTable
local MiscTable = xyd.tables.miscTable
local ReportHero = import("lib.battle.ReportHero")
local ReportPet = import("lib.battle.ReportPet")
local BattleCreateReport = import("lib.battle.BattleCreateReport")
local battleReportDes = import("lib.battle.BattleReportDes")
local newVerTypeList = {
	xyd.BattleType.CAMPAIGN,
	xyd.BattleType.TOWER,
	xyd.BattleType.TOWER_PRACTICE,
	xyd.BattleType.FRIEND_BOSS,
	xyd.BattleType.DAILY_QUIZ,
	xyd.BattleType.GUILD_BOSS,
	xyd.BattleType.WORLD_BOSS,
	xyd.BattleType.ACADEMY_ASSESSMENT,
	xyd.BattleType.HERO_CHALLENGE,
	xyd.BattleType.HERO_CHALLENGE_CHESS,
	xyd.BattleType.HERO_CHALLENGE_REPORT,
	xyd.BattleType.HERO_CHALLENGE_SPEED,
	xyd.BattleType.ACTIVITY_SCHOOL_EXPLORE,
	xyd.BattleType.EXPLORE_OLD_CAMPUS,
	xyd.BattleType.EXPLORE_ADVENTURE,
	xyd.BattleType.GUILD_COMPETITION,
	xyd.BattleType.BEACH_ISLAND,
	xyd.BattleType.ENCOUNTER_STORY,
	xyd.BattleType.TIME_CLOISTER_BATTLE,
	xyd.BattleType.TIME_CLOISTER_EXTRA
}

function BattleController:ctor(...)
	BattleController.super.ctor(self, ...)

	self.battleData_ = nil

	self:onRegister()

	self.isNeedControllerOverCard = {
		[xyd.BattleType.ARENA] = "ARENA_OVER_CARD",
		[xyd.BattleType.ARENA_3v3] = "ARENA_3v3_OVER_CARD",
		[xyd.BattleType.ARENA_ALL_SERVER] = "ARENA_ALL_SERVER_OVER_CARD"
	}
end

function BattleController.get()
	if BattleController.INSTANCE == nil then
		BattleController.INSTANCE = BattleController.new()
	end

	return BattleController.INSTANCE
end

function BattleController:onRegister()
	BattleController.super.onRegister(self)
	self:registerEvent(xyd.event.ERROR_MESSAGE, handler(self, self.onError))
	self:registerEvent(xyd.event.REQUEST_INFO, handler(self, self.onRequest))
	self:registerEvent(xyd.event.START_BATTLE, handler(self, self.onBattleStart))
	self:registerEvent(xyd.event.BATTLE_END, handler(self, self.onBattleEnd))
	self:registerEvent(xyd.event.MAP_FIGHT, handler(self, self.onBattleStart))
	self:registerEvent(xyd.event.DUNGEON_FIGHT, handler(self, self.onDungeonBattle))
	self:registerEvent(xyd.event.TOWER_FIGHT, handler(self, self.onTowerStart))
	self:registerEvent(xyd.event.TOWER_PRACTICE, handler(self, self.onTowerPractice))
	self:registerEvent(xyd.event.TOWER_REPORT, function (event)
		self:onTowerStart(event, true)
	end)
	self:registerEvent(xyd.event.TOWER_SELF_REPORT, handler(self, self.onTowerSelfReport))
	self:registerEvent(xyd.event.QUIZ_FIGHT, handler(self, self.onDailyQuizBattle))
	self:registerEvent(xyd.event.ARENA_FIGHT, handler(self, self.onArenaBattle))
	self:registerEvent(xyd.event.ARENA_3v3_FIGHT, handler(self, self.onArena3v3Battle))
	self:registerEvent(xyd.event.ARENA_TEAM_FIGHT, handler(self, self.onArenaTeamBattle))
	self:registerEvent(xyd.event.FRIEND_FIGHT_BOSS, handler(self, self.onFriendBossBattle))
	self:registerEvent(xyd.event.FRIEND_FIGHT_FRIEND, handler(self, self.onFriendBattle))
	self:registerEvent(xyd.event.NEW_TRIAL_FIGHT, handler(self, self.onNewTrialFight))
	self:registerEvent(xyd.event.GET_ACTIVITY_AWARD, handler(self, self.onActivityFight))
	self:registerEvent(xyd.event.GUILD_BOSS_FIGHT, handler(self, self.onGuildBossFight))
	self:registerEvent(xyd.event.BOSS_FIGHT, handler(self, self.onBossFight))
	self:registerEvent(xyd.event.BOSS_NEW_FIGHT, handler(self, self.onBossNewFight))
	self:registerEvent(xyd.event.PARTNER_CHALLENGE_FIGHT, handler(self, self.onHeroChallengeFight))
	self:registerEvent(xyd.event.FIGHT_CHESS, handler(self, self.onHeroChallengeChessFight))
	self:registerEvent(xyd.event.PARTNER_CHALLENGE_GET_REPORT, handler(self, self.onHeroChallengeReport))
	self:registerEvent(xyd.event.FAIRY_CHALLENGE, handler(self, self.onFairyTaleBattle))
	self:registerEvent(xyd.event.ARENA_GET_REPORT, function (event)
		self:onArenaBattle(event, true)
	end)
	self:registerEvent(xyd.event.FRIEND_TEAM_BOSS_FIGHT, handler(self, self.onFriendTeamBossFight))
	self:registerEvent(xyd.event.FRIEND_TEAM_BOSS_GET_REPORT, handler(self, self.onFriendTeamBossReport))
	self:registerEvent(xyd.event.SCHOOL_PRACTICE_FIGHT, handler(self, self.onSchoolPracticeFight))
	self:registerEvent(xyd.event.FRIEND_BOSS_FIGHT, handler(self, self.onFriendBossFight))
	self:registerEvent(xyd.event.PARTNER_DATA_FIGHT, handler(self, self.onPartnerDataFight))
	self:registerEvent(xyd.event.NEW_PARTNER_WARMUP_FIGHT, handler(self, self.onNewPartnerWarmUpFight))
	self:registerEvent(xyd.event.SPORTS_FIGHT, handler(self, self.onSportsFight))
	self:registerEvent(xyd.event.OLD_BUILDING_FIGHT, handler(self, self.onOldBuildingFight))
	self:registerEvent(xyd.event.EXPLORE_ADVENTURE_COST, handler(self, self.onAdventureBattle))
	self:registerEvent(xyd.event.GUILD_COMPETITION_BATTLE, handler(self, self.onGuildCometitionBattleFight))
	self:registerEvent(xyd.event.FAIR_ARENA_BATTLE, handler(self, self.onFairArenaBattle))
	self:registerEvent(xyd.event.FAIR_ARENA_BATTLE_REPORT, handler(self, self.onFairArenaBattleReport1))
	self:registerEvent(xyd.event.FAIR_ARENA_GET_REPORT, handler(self, self.onFairArenaBattleReport2))
	self:registerEvent(xyd.event.ACTIVITY_BEACH_ISLAND_BATTLE, handler(self, self.onBeachIslandBattle))
	self:registerEvent(xyd.event.ENCOUNTER_FIGHT, handler(self, self.onEncounterBattle))
	self:registerEvent(xyd.event.TIME_CLOISTER_FIGHT, handler(self, self.onTimeCloisterBattle))
	self:registerEvent(xyd.event.TIME_CLOISTER_EXTRA, handler(self, self.onTimeCloisterExtra))
	self:registerEvent(xyd.event.GET_ALL_SEVER_FIGHT, handler(self, self.onArenaScoreBattle))
	self:registerEvent(xyd.event.ACADEMY_ASSESSMENT_REPORT, handler(self, self.onAcademyAssessmentReport))
end

function BattleController:onRequest(event)
	local mid = tonumber(event.data.mid)

	if battleMID[mid] and battleMID[mid] > 0 then
		xyd.Global.playReport = true

		self:openBattleLoading(mid, event.data.msg)
	end
end

function BattleController:openBattleLoading(mid, params)
	local flag = true

	if mid == xyd.mid.DUNGEON_FIGHT and xyd.models.dungeon:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.ARENA_FIGHT and xyd.models.arena:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.ARENA_3v3_FIGHT and xyd.models.arena3v3:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.ARENA_TEAM_FIGHT and xyd.models.arenaTeam:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.QUIZ_FIGHT and xyd.models.dailyQuiz:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.TRIAL_FIGHT and xyd.models.trial:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.PARTNER_CHALLENGE_FIGHT and xyd.models.heroChallenge:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.NEW_TRIAL_FIGHT and xyd.models.trial:isSkipReport() then
		flag = false
	end

	if mid == xyd.mid.TOWER_FIGHT and xyd.models.towerMap:isSkipReport(xyd.BattleType.TOWER) then
		flag = false
	end

	if mid == xyd.mid.TOWER_PRACTICE and xyd.models.towerMap:isSkipReport(xyd.BattleType.TOWER_PRACTICE) then
		flag = false
	end

	if mid == xyd.mid.MAP_FIGHT then
		local stageId = params.stage_id
		local plotIds = MainPlotListTable:getPlotIDsByStageID(stageId)
		local isFinal = xyd.tables.stageTable:getFortFinal(stageId)

		if isFinal and tonumber(isFinal) > 0 then
			self.needUpdateAchieve_ = true
		end

		if plotIds and plotIds[1] > 0 then
			flag = false
		end
	end

	if flag then
		ResManager.ForceGCCollect()
		xyd.WindowManager.get():openWindow("battle_loading_window")
	end
end

function BattleController:onBattleStart(event)
	local data = event.data

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.CAMPAIGN
	})

	if self.needUpdateAchieve_ then
		self.needUpdateAchieve_ = false

		xyd.models.achievement:getData()
	end
end

function BattleController:onPartnerDataFight(event)
	local data = event.data
	local wndName = {
		"partner_data_station_window",
		"partner_station_battle_formation_window",
		"guide_detail_window"
	}

	for _, name in ipairs(wndName) do
		local wnd = xyd.WindowManager.get():getWindow(name)

		if wnd then
			wnd:hide()
		end
	end

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.PARTNER_STATION
	})
end

function BattleController:onGuildwarBattle(event)
	local data = event.data
	data = xyd.decodeProtoBuf(data)
	local battleReport = data.battle_report

	if battleReport and battleReport.random_seed and battleReport.random_seed > 0 then
		local report = xyd.BattleController.get():createReport(data.battle_report)
		data.battle_report = report
	end

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.GUILD_WAR
	})
end

function BattleController:ArenaTeamSingleBattle(data, isReport)
	isReport = isReport or false
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ARENA_TEAM,
		isReport = isReport,
		is_last = data.is_last
	}

	if isReport then
		tmpData.is_last = true
	end

	local battleReport = data.battle_report
	tmpData.event_data.battle_report_backend = battleReport

	if battleReport and battleReport.random_seed and battleReport.random_seed > 0 then
		local report = xyd.BattleController.get():createReport(data.battle_report)
		tmpData.event_data.battle_report = report

		if self:diffReport(battleReport, report, data.record_id) then
			tmpData.diffReport = true

			xyd.alertConfirm(__("BATTLE_RECORD_ERROR"), handler(self, function ()
				xyd.closeWindow("battle_loading_window")
				self:onArenaTeamBattleResult(tmpData)
			end))

			return
		end
	end

	self:startBattle(tmpData)
end

function BattleController:arcticExpeditionSingleBattle(data, cell_id, self_info)
	local tmpData = {
		isReport = true,
		event_data = data,
		battle_type = xyd.BattleType.ARCTIC_EXPEDITION,
		self_info = self_info
	}
	local battleReport = data.battle_report
	tmpData.event_data.battle_report_backend = battleReport
	tmpData.event_data.self_info = self_info
	tmpData.event_data.cell_id = cell_id

	if battleReport and battleReport.random_seed and battleReport.random_seed > 0 then
		local report = xyd.BattleController.get():createReport(data.battle_report)
		tmpData.event_data.battle_report = report
	end

	self:startBattle(tmpData)
end

function BattleController:onArenaTeamBattle(event, isReport, battleIndex)
	if isReport == nil then
		isReport = false
	end

	local arenaTeam = xyd.models.arenaTeam
	local data = xyd.decodeProtoBuf(event.data)
	local battleData = {
		is_win = data.is_win,
		enemy_info = data.enemy_info,
		battle_report = data.battle_report,
		self_info = data.self_info,
		items = data.items,
		index = data.index,
		record_id = data.record_id,
		self_change = data.self_change,
		enemy_change = data.enemy_change,
		battle_reports = data.battle_reports,
		matchNum = battleIndex
	}

	arenaTeam:setTmpReports(data)

	if not isReport then
		arenaTeam:updateRank(data.rank)
		arenaTeam:updateScore(data.score)
		xyd.EventDispatcher.inner():dispatchEvent({
			name = xyd.event.GET_ARENA_TEAM_INFO,
			data = {}
		})

		if data.rank <= xyd.TOP_ARENA_NUM then
			arenaTeam:reqRankList()
		end
	else
		arenaTeam:resetTmpReports(battleIndex)

		battleData.battle_report = data.battle_report

		self:ArenaTeamSingleBattle(battleData, true)

		return
	end

	if not arenaTeam:isSkipReport() then
		battleData.battle_report = data.battle_reports[1]

		function battleData.onOpenCallback()
			xyd.WindowManager.get():closeWindow("arena_team_choose_player_window")
			xyd.WindowManager.get():closeWindow("arena_team_record_window")
		end

		battleData.is_last = arenaTeam:isLastReport()

		self:ArenaTeamSingleBattle(battleData)
	else
		xyd.WindowManager.get():closeWindow("arena_team_choose_player_window")
		xyd.WindowManager.get():closeWindow("arena_team_record_window")

		battleData.battle_type = xyd.BattleType.ARENA_TEAM

		xyd.WindowManager.get():openWindow("arena_3v3_result_window", {
			battleParams = battleData,
			battle_type = xyd.BattleType.ARENA_TEAM
		})
	end
end

function BattleController:Arena3v3SingleBattle(data)
	local battleReport = data.battle_report
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ARENA_3v3,
		is_last = data.is_last,
		isReport = data.isReport,
		battle_report = data.battle_report,
		onOpenCallback = data.onOpenCallback,
		event_data = {
			is_win = data.is_win,
			enemy_info = data.enemy_info,
			self_info = data.self_info,
			battle_report_backend = data.battle_report,
			items = data.items,
			index = data.index,
			record_id = data.record_id
		}
	}
	local battleReport = data.battle_report

	if battleReport and battleReport.random_seed and battleReport.random_seed > 0 then
		local report = xyd.BattleController.get():createReport(data.battle_report)
		tmpData.event_data.battle_report = report

		if self:diffReport(battleReport, report, data.record_id) then
			tmpData.diffReport = true
			tmpData.isReport = data.isReport

			xyd.alertConfirm(__("BATTLE_RECORD_ERROR"), handler(self, function ()
				xyd.closeWindow("battle_loading_window")
				self:onArena3v3BattleResult(tmpData)
			end))

			return
		end
	end

	self:startBattle(tmpData)
end

function BattleController:ArenaAllServerSingleBattle(data)
	local battleReport = data.battle_report
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ARENA_ALL_SERVER,
		is_last = data.is_last,
		isReport = data.isReport,
		battle_report = data.battle_report,
		onOpenCallback = data.onOpenCallback
	}
	tmpData.event_data.battle_report_backend = data.battle_report

	if battleReport and battleReport.random_seed and battleReport.random_seed > 0 then
		local report = xyd.BattleController.get():createReport(data.battle_report)
		tmpData.event_data.battle_report = report

		if self:diffReport(battleReport, report, data.record_id) then
			tmpData.diffReport = true

			xyd.alertConfirm(__("BATTLE_RECORD_ERROR"), handler(self, function ()
				xyd.closeWindow("battle_loading_window")
				self:onArenaAllServerBattleResult(tmpData)
			end))

			return
		end
	end

	self:startBattle(tmpData)
end

function BattleController:sportShowsBattle(data)
	self:startBattle({
		event_data = data.data,
		battle_type = xyd.BattleType.SPORTS_SHOW,
		is_last = data.is_last,
		isReport = data.isReport,
		battle_report = data.battle_report,
		onOpenCallback = data.onOpenCallback
	})
end

function BattleController:onArena3v3Battle(event, isReport)
	if isReport == nil then
		isReport = false
	end

	local arena = xyd.models.arena3v3
	local data = event.data
	local battleData = {
		self_change = data.self_change,
		enemy_change = data.enemy_change,
		index = data.index,
		items = data.items,
		is_win = data.is_win,
		rank = data.rank,
		score = data.score,
		enemy_info = data.enemy_info,
		battle_reports = data.battle_reports,
		self_info = data.self_info,
		record_ids = data.record_ids
	}

	xyd.models.arena3v3:setTmpReports(data)

	if not isReport then
		arena:updateRank(data.rank)
		arena:updateScore(data.score)
		xyd.EventDispatcher.inner():dispatchEvent({
			name = xyd.event.GET_ARENA_3v3_INFO
		})

		if data.rank <= xyd.TOP_ARENA_NUM then
			arena:reqRankList()
		end
	else
		arena:resetTmpReports()

		battleData.is_last = true
		battleData.isReport = true
		battleData.battle_report = data.battle_report
		battleData.record_id = event.record_id

		self:Arena3v3SingleBattle(battleData)

		return
	end

	local record_id = -1

	if data.record_ids then
		record_id = data.record_ids[1]
	end

	if not arena:isSkipReport() then
		battleData.battle_report = data.battle_reports[1]

		function battleData:onOpenCallback()
			xyd.WindowManager.get():closeWindow("arena_3v3_choose_player_window")
			xyd.WindowManager.get():closeWindow("arena_3v3_record_window")
		end

		battleData.is_last = xyd.models.arena3v3:isLastReport()
		battleData.record_id = record_id

		self:Arena3v3SingleBattle(battleData)
	else
		self:Arena3v3BattleSkip(record_id, battleData)
	end
end

function BattleController:Arena3v3BattleSkip(record_id, battleData)
	xyd.WindowManager.get():closeWindow("arena_3v3_choose_player_window")
	xyd.WindowManager.get():closeWindow("arena_3v3_record_window")
	xyd.WindowManager.get():openWindow("arena_3v3_result_window", {
		battleParams = battleData,
		battle_type = xyd.BattleType.ARENA_3v3,
		record_id = record_id,
		onOpenCallback = function ()
			local win = xyd.WindowManager.get():getWindow("arena_3v3_window")
			local winTop = nil

			if win then
				winTop = win:getWindowTop()
			end

			if self:checkShowOverCardWindow(xyd.BattleType.ARENA_3v3) then
				xyd.WindowManager.get():openWindow("arena_battle_award_window", {
					items = battleData.items,
					index = battleData.index,
					delayedTop = winTop,
					isCheckShowType = xyd.BattleType.ARENA_3v3
				})
			else
				xyd.models.itemFloatModel:pushNewItems({
					battleData.items[battleData.index]
				})
			end
		end
	})
end

function BattleController:onArenaScoreBattle(event, isReport)
	if isReport == nil then
		isReport = false
	end

	local arena = xyd.models.arenaAllServerScore
	local data = event.data
	local battleData = {
		self_change = data.self_change,
		enemy_change = data.enemy_change,
		index = data.index,
		items = data.items,
		is_win = data.is_win,
		rank = data.rank,
		score = data.score,
		enemy_info = data.enemy_info,
		battle_reports = data.battle_reports,
		self_info = data.self_info,
		record_ids = data.record_ids,
		isReport = isReport
	}

	if data.is_win and tonumber(data.is_win) == -1 and not isReport then
		xyd.alertTips(__("NEW_ARENA_ALL_MATCH_ERROR"))

		local msg = messages_pb:get_match_all_sever_infos_req()

		xyd.Backend.get():request(xyd.mid.GET_MATCH_ALL_SEVER_INFOS, msg)

		return
	end

	xyd.models.arenaAllServerScore:setTmpReports(data)

	if not isReport then
		if data.rank and data.rank > 0 then
			arena:updateRank(data.rank)
		end

		if data.score and data.score >= 0 then
			arena:updateScore(data.score)
		end
	else
		arena:resetTmpReports()

		battleData.is_last = true
		battleData.isReport = true
		battleData.battle_report = data.battle_report
		battleData.battle_report_backend = data.battle_report
		battleData.record_id = event.record_id

		self:ArenaAllServerSingleBattle(battleData)

		return
	end

	local record_id = -1

	if data.record_ids then
		record_id = data.record_ids[1]
	end

	if not arena:isSkipReport() then
		battleData.battle_report = data.battle_reports[1]

		function battleData:onOpenCallback()
			xyd.WindowManager.get():closeWindow("arena_3v3_choose_player_window")
			xyd.WindowManager.get():closeWindow("arena_3v3_record_window")
		end

		battleData.is_last = xyd.models.arenaAllServerScore:isLastReport()
		battleData.record_id = record_id

		self:ArenaAllServerSingleBattle(battleData)
	else
		xyd.WindowManager.get():closeWindow("arena_3v3_choose_player_window")
		xyd.WindowManager.get():closeWindow("arena_3v3_record_window")
		xyd.WindowManager.get():openWindow("arena_3v3_result_window", {
			battleParams = battleData,
			battle_type = xyd.BattleType.ARENA_ALL_SERVER,
			onOpenCallback = function ()
				local win = xyd.WindowManager.get():getWindow("arena_all_server_window")
				local winTop = nil

				if win then
					win:updateScorePartInfo()

					winTop = win:getWindowTop()
				end

				if self:checkShowOverCardWindow(xyd.BattleType.ARENA_ALL_SERVER) then
					xyd.WindowManager.get():openWindow("arena_battle_award_window", {
						items = data.items,
						index = data.index,
						delayedTop = winTop,
						isCheckShowType = xyd.BattleType.ARENA_ALL_SERVER
					})
				else
					xyd.models.itemFloatModel:pushNewItems({
						data.items[data.index]
					})
				end
			end
		})
	end
end

function BattleController:onArenaBattle(event, isReport)
	if isReport == nil then
		isReport = false
	end

	local arena = xyd.models.arena
	local data = xyd.decodeProtoBuf(event.data)

	if not isReport then
		arena:updateRank(data.rank)
		arena:updateScore(data.score)
		xyd.EventDispatcher:inner():dispatchEvent({
			name = xyd.event.GET_ARENA_INFO,
			data = {}
		})

		if data.rank <= xyd.TOP_ARENA_NUM then
			arena:reqRankList()
		end
	end

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ARENA
	}
	tmpData.event_data.battle_report_backend = data.battle_report
	local activity_entrance_test_window_wd = xyd.WindowManager.get():getWindow("activity_entrance_test_window")

	if activity_entrance_test_window_wd then
		tmpData.battle_type = xyd.BattleType.ENTRANCE_TEST
	end

	local battleReport = data.battle_report
	local needCreateReport = battleReport and battleReport.random_seed and battleReport.random_seed > 0

	if arena:isSkipReport() and not isReport then
		needCreateReport = false
	end

	if needCreateReport then
		if not xyd.checkReportVer(data.battle_report) then
			xyd.closeWindow("battle_loading_window")

			return
		end

		local report = xyd.BattleController.get():createReport(data.battle_report)
		tmpData.event_data.battle_report = report

		if self:diffReport(battleReport, report, data.record_id) then
			tmpData.diffReport = true
			tmpData.isReport = isReport

			xyd.alertConfirm(__("BATTLE_RECORD_ERROR"), handler(self, function ()
				xyd.closeWindow("battle_loading_window")
				xyd.WindowManager.get():closeWindow("arena_choose_player_window")
				xyd.WindowManager.get():closeWindow("arena_record_window")
				self:onArenaBattleResult(tmpData)
			end))

			return
		end
	end

	if not arena:isSkipReport() or isReport then
		if not isReport then
			function tmpData.onOpenCallback()
				local win = xyd.WindowManager.get():getWindow("arena_window")
				local winTop = nil

				if win then
					winTop = win:getWindowTop()
				end

				if self:checkShowOverCardWindow(xyd.BattleType.ARENA) then
					xyd.WindowManager.get():openWindow("arena_battle_award_window", {
						items = data.items,
						index = data.index,
						delayedTop = winTop,
						isCheckShowType = xyd.BattleType.ARENA
					})
				else
					xyd.models.itemFloatModel:pushNewItems({
						data.items[data.index]
					})
				end

				xyd.WindowManager.get():closeWindow("arena_choose_player_window")
				xyd.WindowManager.get():closeWindow("arena_record_window")
			end
		end

		self:startBattle(tmpData)
	else
		xyd.WindowManager.get():closeWindow("arena_choose_player_window")
		xyd.WindowManager.get():closeWindow("arena_record_window")
		self:onArenaBattleResult(tmpData)
	end
end

function BattleController:diffReport(backReport, report, record_id)
	if backReport.isWin ~= report.isWin then
		local log = "BATTLE DIFF: " .. "Player ID: " .. tostring(xyd.Global.playerID) .. " record ID: " .. tostring(record_id) .. "\n"

		xyd.db.errorLog:add(log, 0, "", true)

		return true
	end

	return false
end

function BattleController:onDungeonBattle(event)
	local dungeon = xyd.models.dungeon
	local data = event.data
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.DUNGEON
	}

	if not dungeon:isSkipReport() then
		local wnd = xyd.getWindow("dungeon_window")

		if wnd then
			wnd:beforeBattle()
		end

		self:startBattle(tmpData)
	else
		self:onDungeonBattleResult(tmpData)
	end
end

function BattleController:onDailyQuizBattle(event)
	local data = event.data

	if xyd.models.dailyQuiz:isSkipReport() then
		self:normalBattleResult({
			event_data = data,
			battle_type = xyd.BattleType.DAILY_QUIZ
		})
	else
		self:startBattle({
			event_data = data,
			battle_type = xyd.BattleType.DAILY_QUIZ
		})
	end
end

function BattleController:onSportsShowBattleResult(data)
	data.map_type = xyd.MapType.SPORTS_PVP

	self:openBaseBattleResult({
		event_data = data
	}, function ()
		if not data.is_win or data.is_win == 0 then
			return
		end
	end)
end

function BattleController:onHeroChallengeFight(event)
	local data = event.data
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.HERO_CHALLENGE
	}

	if xyd.models.heroChallenge:isSkipReport() then
		self:onHeroChallengeBattleResult(tmpData)
	elseif false and UNITY_EDITOR and xyd.db.misc:getValue("test_index", -1) == "1" then
		if type(data.ListFields) ~= "nil" then
			data = xyd.decodeProtoBuf(data)
		end

		data.battle_report.random_seed = math.random(1, 10000)
		data.battle_report.battle_type = xyd.ReportBattleType.HERO_CHALLENGE
		local report = xyd.BattleController.get():createReport(data.battle_report)
		local params = {
			event_data = {}
		}

		for key, _ in pairs(data) do
			params.event_data[key] = _
		end

		params.battle_type = xyd.ReportBattleType.HERO_CHALLENGE
		params.event_data.battle_report = report

		reportLog2("test_local")
		self:startBattle(params)
	else
		self:startBattle(tmpData)
	end
end

function BattleController:onHeroChallengeChessFight(event)
	local data = event.data
	local fortID = data.fort_info.base_info.fort_id
	local baseInfo = data.fort_info.base_info
	local decCoin = 0

	if baseInfo.coin and xyd.models.heroChallenge.chessCoin_[fortID] ~= baseInfo.coin then
		decCoin = baseInfo.coin - xyd.models.heroChallenge.chessCoin_[fortID]
		xyd.models.heroChallenge.chessCoin_[fortID] = baseInfo.coin
	end

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.HERO_CHALLENGE_CHESS,
		decCoin = decCoin
	}

	if xyd.models.heroChallenge:isSkipReport() then
		self:onHeroChallengeBattleResult(tmpData)
	else
		self:startBattle(tmpData)
	end
end

function BattleController:onHeroChallengeReport(event)
	local data = event.data

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.HERO_CHALLENGE_REPORT
	})
end

function BattleController:onFriendBossBattle(event)
	local data = event.data

	local function onOpenCallback()
		xyd.WindowManager.get():openWindow("arena_battle_award_window", {
			items = data.items,
			index = data.index
		})
	end

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.FRIEND_BOSS,
		onOpenCallback = onOpenCallback
	})
end

function BattleController:onFriendBattle(event)
	local data = event.data

	if UNITY_EDITOR and xyd.db.misc:getValue("test_index", -1) == "1" then
		if type(data.ListFields) ~= "nil" then
			data = xyd.decodeProtoBuf(data)
		end

		local report = xyd.BattleController.get():createReport(data.battle_report, 1)
		local params = {
			event_data = {}
		}

		for key, _ in pairs(data) do
			params.event_data[key] = _
		end

		params.battle_type = xyd.BattleType.FRIEND
		params.event_data.battle_report = report

		battleReportDes:randomRecord(report.random_log, data.battle_report.random_log)
		reportLog2("test_local")
		self:startBattle(params)
	else
		self:startBattle({
			event_data = data,
			battle_type = xyd.BattleType.FRIEND
		})
	end
end

function BattleController:onFriendBossFight(event)
	local data = event.data
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.FRIEND_BOSS
	}
	local selectedBossLevel = xyd.models.friend:getSelectedBossLevel()

	if xyd.models.friend:canJumpBattle(selectedBossLevel) and xyd.models.friend:isSkipBattle() then
		self:normalBattleResult(tmpData)
	else
		self:startBattle(tmpData)
	end
end

function BattleController:onNewPartnerWarmUpFight(event)
	local data = event.data
	local report = self:createBattleReport(data.stage_id)

	self:startBattle({
		event_data = report,
		battle_type = xyd.BattleType.NEW_PARTNER_WARMUP
	})
end

function BattleController:onSportsFight(event)
	local data = event.data

	if not data.battle_report then
		return
	end

	local isSkipReport = xyd.checkCondition(tonumber(xyd.db.misc:getValue("sports_skip_report")) == 1, true, false)

	if not isSkipReport then
		self:startBattle({
			event_data = data,
			battle_type = xyd.BattleType.SPORTS_PVP
		})
	else
		self:onSportsBattleResult({
			event_data = data,
			battle_type = xyd.BattleType.SPORTS_PVP
		})
	end
end

function BattleController:onOldBuildingFight(event)
	xyd.models.activity:exploreOldCampusFightTime()

	local data = event.data
	local isSkipReport = xyd.checkCondition(tonumber(xyd.db.misc:getValue("explore_old_campus_skip_fight")) == 1, true, false)

	if type(data.ListFields) ~= "nil" then
		data = xyd.decodeProtoBuf(data)
	end

	if not data.battle_result then
		self:startBattle({
			event_data = data,
			battle_type = xyd.BattleType.EXPLORE_OLD_CAMPUS
		})

		return
	end

	local params = {}
	local isChange, beforeScore = xyd.models.oldSchool:checkScoreChange(data.stage_id, data.floor_info)
	params.battle_report = data.battle_result.battle_report
	params.is_win = data.battle_result.is_win
	params.buff_ids = data.buff_ids
	params.battle_type = xyd.BattleType.EXPLORE_OLD_CAMPUS
	params.is_score_up = isChange
	params.beforeScore = beforeScore
	params.floor_info = data.floor_info
	params.stage_id = data.stage_id

	if not isSkipReport then
		self:startBattle({
			event_data = params,
			battle_type = xyd.BattleType.EXPLORE_OLD_CAMPUS
		})
	else
		self:onOldBuildingBattleResult({
			event_data = params,
			battle_type = xyd.BattleType.EXPLORE_OLD_CAMPUS
		})
	end
end

function BattleController:onTowerStart(event, isReport)
	local data = event.data
	local isRecord = false

	if data.battle_report and data.battle_report.random_seed and data.battle_report.random_seed > 0 then
		if not xyd.checkReportVer(data.battle_report) then
			return
		end

		data = xyd.models.towerMap:getTowerReport(data.stage_id, data.record_id)
	end

	if data.record_id or isReport == true then
		isRecord = true
	end

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.TOWER,
		isRecord = isRecord
	}

	if xyd.models.towerMap:isSkipReport(xyd.BattleType.TOWER) and not isRecord then
		self:onTowerBattleResult(tmpData)
	else
		xyd.closeWindow("tower_window")
		self:startBattle(tmpData)
	end
end

function BattleController:onAdventureBattle(event)
	local data = xyd.decodeProtoBuf(event.data)

	if data.battle_result then
		local wnd = xyd.WindowManager.get():getWindow("explore_adventure_window")

		if wnd and wnd.onAutoAdven then
			return
		end

		xyd.closeWindow("explore_adventure_prepare_window")
		xyd.models.exploreModel:setBattleAwards(data.items)

		local tmpData = {
			event_data = event.data.battle_result,
			battle_type = xyd.BattleType.EXPLORE_ADVENTURE
		}

		if xyd.models.exploreModel:isSkipReport() then
			self:normalBattleResult(tmpData)
		else
			self:startBattle(tmpData)
		end
	end
end

function BattleController:onTowerPractice(event)
	local data = event.data

	if data.battle_report and data.battle_report.random_seed and data.battle_report.random_seed > 0 then
		data = xyd.models.towerMap:getTowerReport(data.stage_id, data.record_id)
	end

	local tmpData = {
		isRecord = true,
		event_data = data,
		battle_type = xyd.BattleType.TOWER_PRACTICE
	}

	if xyd.models.towerMap:isSkipReport(xyd.BattleType.TOWER_PRACTICE) then
		self:onTowerPracticeResult(tmpData)
	else
		xyd.closeWindow("tower_window")
		self:startBattle(tmpData)
	end
end

function BattleController:onTowerSelfReport(event)
	local data = event.data

	if not data.battle_report.teamA[1] then
		xyd.alertTips(__("BATTLE_VERSION_TIPS"))

		return
	end

	if not data.battle_report then
		local wnd = xyd.WindowManager.get():getWindow("tower_record_window")

		if wnd then
			wnd:showNoReportTips()
		end
	else
		if data.battle_report and data.battle_report.random_seed and data.battle_report.random_seed > 0 then
			if not xyd.checkReportVer(data.battle_report) then
				return
			end

			data = xyd.models.towerMap:getMyTowerReport(data.stage_id)
		end

		xyd.closeWindow("tower_window")
		self:startBattle({
			isRecord = true,
			event_data = data,
			battle_type = xyd.BattleType.TOWER
		})
	end
end

function BattleController:onFriendTeamBossFight(event)
	local data = event.data

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.FRIEND_TEAM_BOSS
	})
end

function BattleController:onFriendTeamBossReport(event)
	local data = event.data
	local team_info = xyd.models.friendTeamBoss:getTeamInfo()

	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.FRIEND_TEAM_BOSS_REPORT,
		team_info = team_info
	})
end

function BattleController:onTrialFight(event)
	local data = event.data
	local onOpenCallback = nil

	if data.is_win and data.items then
		local win = xyd.WindowManager.get():getWindow("trial_window")

		if win then
			local winTop = win:getWindowTop()
			local resItem = winTop:getResItems()[1]
			local currentStage = xyd.models.trial:currentStage() - 1
			local awards = xyd.tables.trialTable:getAward(xyd.models.backpack:getLev(), currentStage)

			for i = 1, #awards do
				if awards[i][1] == resItem.itemID then
					resItem:setItemNum(resItem:getTrueNum() + awards[i][2])

					break
				end
			end
		end

		function onOpenCallback()
			local win = xyd.WindowManager.get():getWindow("trial_window")
			local winTop = nil

			if win then
				winTop = win:getWindowTop()
			end

			xyd.WindowManager.get():openWindow("arena_battle_award_window", {
				items = data.items,
				index = data.index,
				delayedTop = winTop
			})
		end
	end

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.TRIAL,
		onOpenCallback = onOpenCallback
	}

	if not xyd.models.trial:isSkipReport() then
		self:startBattle(tmpData)
	else
		self:onTrialBattleResult(tmpData)
	end
end

function BattleController:onNewTrialFight(event)
	local data = event.data

	if not data.battle_report or tostring(data.battle_report) == "" then
		return
	end

	if data.battle_report.isWin == 1 and data.battle_report.items then
		-- Nothing
	end

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.TRIAL,
		stage_id = data.info.current_stage
	}

	if not xyd.models.trial:isSkipReport() or xyd.models.trial:getIsReport() then
		if xyd.models.trial:getIsReport() then
			tmpData.isReport = true

			xyd.models.trial:setIsReport(false)
		end

		self:startBattle(tmpData)
	else
		self:onTrialBattleResult(tmpData)
	end
end

function BattleController:onFairyTaleBattle(event)
	local data = event.data

	if not data.battle_result or tostring(data.battle_result) == "" and data.is_video then
		local result = event.data
		result.items = data.items or {}
		result.battle_report.hasDecoded = true
		result.battle_report.isWin = 1
		local tmpData = {
			event_data = result,
			battle_type = xyd.BattleType.FAIRY_TALE
		}

		self:startBattle(tmpData)
	elseif data.battle_result and tostring(data.battle_result) ~= "" then
		data.battle_result.is_win = 1
		local result = xyd.decodeProtoBuf(data.battle_result)
		result.items = data.items or {}
		result.battle_report.hasDecoded = true
		result.battle_report.isWin = 1
		local tmpData = {
			event_data = result,
			battle_type = xyd.BattleType.FAIRY_TALE
		}

		self:startBattle(tmpData)
	end
end

function BattleController:onSchoolPracticeFight(event)
	local data = event.data

	xyd.WindowManager.get():closeWindow("academy_assessment_battle_formation_window")

	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ACADEMY_ASSESSMENT
	}
	local isSkipReport = xyd.checkCondition(tonumber(xyd.db.misc:getValue("academy_assessment_skip_report")) == 1, true, false)

	if not isSkipReport then
		self:startBattle(tmpData)
	else
		self:openBaseBattleResult(tmpData)
	end
end

function BattleController:onGuildBossFight(event)
	local data = event.data

	xyd.WindowManager.get():closeWindow("guild_boss_window")
	xyd.WindowManager.get():closeWindow("guild_final_boss_window")
	xyd.WindowManager.get():closeWindow("guild_gym_window")
	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.GUILD_BOSS
	})
end

function BattleController:onGuildCometitionBattleFight(event)
	local data = xyd.decodeProtoBuf(event.data)
	data.battle_result.is_win = 1
	data.battle_result.battle_report.isWin = 1
	data.battle_result.items = data.items
	data.battle_result.self_harm = data.self_harm
	data.battle_result.type = data.type
	local guildCompetitionFightWn = xyd.WindowManager.get():getWindow("guild_competition_fight_window")

	if guildCompetitionFightWn then
		guildCompetitionFightWn:hideEffect()
		xyd.WindowManager.get():closeWindow("guild_competition_fight_window")
	end

	if data.type == 1 then
		xyd.models.guild:guildCometitionBattleBack(data)
	end

	local point = 0

	if data.point then
		point = data.point
		point = math.floor((point + 0.001) * 100) / 100
	else
		local bossTable = xyd.tables.guildCompetitionBossTable
		local battle_round = data.battle_lv

		if data.battle_lv > #bossTable:getIds() then
			battle_round = #bossTable:getIds()
		end

		local allBlood = 0
		local battleId = bossTable["getBattleId" .. data.boss_id](bossTable, battle_round)
		local monsters = xyd.tables.battleTable:getMonsters(battleId)

		for i in pairs(monsters) do
			allBlood = allBlood + xyd.tables.monsterTable:getHp(monsters[i])
		end

		point = tonumber(data.self_harm) / allBlood * bossTable:getPoint(battle_round)
		point = math.floor((point + 0.001) * 100) / 100
	end

	data.battle_result.point = point

	if data.battle_result.battle_report.teamB then
		for i, enemyData in pairs(data.battle_result.battle_report.teamB) do
			if enemyData and enemyData.status and enemyData.status.hp and enemyData.status.true_hp and data.battle_lv then
				local bossTable = xyd.tables.guildCompetitionBossTable
				local battleId = bossTable["getBattleId" .. data.boss_id](bossTable, data.battle_lv)
				local monsters = xyd.tables.battleTable:getMonsters(battleId)
				local all_hp = xyd.tables.monsterTable:getHp(monsters[i])
				enemyData.status.hp = math.ceil(tonumber(enemyData.status.true_hp) / all_hp * 100)
			end
		end
	end

	self:startBattle({
		event_data = data.battle_result,
		battle_type = xyd.BattleType.GUILD_COMPETITION
	})
end

function BattleController:onFairArenaBattle(event)
	local data = event.data
	local tmpData = {
		battle_type = xyd.BattleType.FAIR_ARENA,
		onOpenCallback = function ()
			local win = xyd.WindowManager.get():getWindow("fair_arena_explore_window")
			local winTop = nil

			if win then
				winTop = win:getWindowTop()
			end

			xyd.WindowManager.get():openWindow("arena_battle_award_window", {
				items = data.battle_result.items,
				index = data.battle_result.index,
				delayedTop = winTop
			})
		end,
		event_data = {
			battle_report = data.battle_result.battle_report,
			is_win = data.battle_result.is_win,
			enemy_info = xyd.models.fairArena:getOldEnemyInfo(),
			self_info = xyd.models.fairArena:getSelfInfo()
		}
	}

	self:startBattle(tmpData)
	xyd.WindowManager.get():closeWindow("fair_arena_explore_window")
end

function BattleController:onFairArenaBattleResult(data)
	self:openBaseBattleResult(data, function (isOpen)
		if isOpen and not xyd.WindowManager.get():isOpen("fair_arena_explore_window") then
			xyd.WindowManager.get():openWindow("fair_arena_explore_window", {})
		end
	end)
end

function BattleController:onAcademyAssessmentReport(event)
	local data = event.data
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.ACADEMY_ASSESSMENT
	}

	self:startBattle(tmpData)
end

function BattleController:onFairArenaBattleReport1(event)
	local data = event.data
	local tmpData = {
		event_data = data,
		battle_type = xyd.BattleType.FAIR_ARENA
	}

	self:startBattle(tmpData)
end

function BattleController:onFairArenaBattleReport2(event)
	local data = event.data
	local tmpData = {
		battle_type = xyd.BattleType.FAIR_ARENA,
		event_data = {
			battle_report = data.battle_result.battle_report,
			is_win = data.battle_result.is_win,
			enemy_info = xyd.models.fairArena:getReportEnemyInfo(),
			self_info = xyd.models.fairArena:getSelfInfo()
		}
	}

	self:startBattle(tmpData)
end

function BattleController:onBeachIslandBattle(event)
	local data = xyd.decodeProtoBuf(event.data)
	local tmpData = {
		battle_type = xyd.BattleType.BEACH_ISLAND,
		event_data = {
			battle_report = data.battle_result.battle_report,
			is_win = data.battle_result.is_win,
			items = data.items
		}
	}

	self:startBattle(tmpData)
end

function BattleController:onEncounterBattle(event)
	local data = xyd.decodeProtoBuf(event.data)
	local tmpData = {
		battle_type = xyd.BattleType.ENCOUNTER_STORY,
		event_data = {
			battle_report = data.battle_result.battle_report,
			is_win = data.battle_result.is_win,
			items = data.items
		}
	}

	self:startBattle(tmpData)
end

function BattleController:onTimeCloisterBattle(event)
	local data = xyd.decodeProtoBuf(event.data)
	local tmpData = {
		battle_type = xyd.BattleType.TIME_CLOISTER_BATTLE
	}
	local stage = data.stage_id
	local next_id = xyd.tables.timeCloisterBattleTable:getNext(stage)
	tmpData.event_data = {
		battle_report = data.battle_result.battle_report,
		is_win = data.battle_result.is_win,
		items = data.items
	}

	if next_id == -1 then
		tmpData.event_data.total_harm = data.battle_result.total_harm
		data.battle_result.battle_report.isWin = 1
	end

	self:startBattle(tmpData)
end

function BattleController:onTimeCloisterExtra(event)
	local data = xyd.decodeProtoBuf(event.data)

	if not data.battle_result then
		return
	end

	dump(data, "额外战斗回来")

	local tmpData = {
		battle_type = xyd.BattleType.TIME_CLOISTER_BATTLE
	}
	local items = {}
	local event_id = data.event_id

	if event_id and tonumber(event_id) > 0 then
		event_id = tonumber(event_id)
		local awards = xyd.tables.timeCloisterCardTable:getAwards(event_id)

		for i in pairs(awards) do
			table.insert(items, {
				item_id = awards[i][1],
				item_num = awards[i][2]
			})
		end
	end

	tmpData.event_data = {
		battle_report = data.battle_result.battle_report,
		is_win = data.battle_result.is_win,
		items = items
	}

	self:startBattle(tmpData)
end

function BattleController:onBossFight(event)
	local data = event.data

	xyd.WindowManager.get():closeWindow("battle_formation_window")
	self:startBattle({
		event_data = data,
		battle_type = xyd.BattleType.WORLD_BOSS
	})
end

function BattleController:onBossNewFight(event)
	local data = xyd.decodeProtoBuf(event.data)

	xyd.WindowManager.get():closeWindow("battle_formation_window")

	if data.boss_info and data.boss_info.boss_id then
		xyd.models.activity:getActivity(xyd.ActivityID.MONTHLY_HIKE):updateBossInfo(data.boss_info)
	end

	local activityData = xyd.models.activity:getActivity(xyd.ActivityID.MONTHLY_HIKE)

	if not data.battle_report or activityData.detail.isSweep then
		activityData.detail.isSweep = false
		local activityContent = xyd.WindowManager.get():getWindow("activity_window"):getCurContent()

		if activityContent:getActivityContentID() == xyd.ActivityID.MONTHLY_HIKE then
			activityContent:onSweepBoss(data)
		end
	else
		self:startBattle({
			event_data = data,
			battle_type = xyd.BattleType.WORLD_BOSS
		})
	end
end

function BattleController:startBattle(data)
	local canPlayPlot = true

	if not data then
		canPlayPlot = false
		data = self.battleData_
	else
		self.battleData_ = data
	end

	if data.event_data and data.event_data.battle_report and UNITY_EDITOR then
		local battle_report = nil

		if type(data.event_data.battle_report.ListFields) ~= "nil" then
			battle_report = xyd.decodeProtoBuf(data.event_data.battle_report)
		elseif type(data.event_data.ListFields) == "nil" then
			battle_report = data.event_data.battle_report
		else
			battle_report = xyd.decodeProtoBuf(data.event_data).battle_report
		end

		battleReportDes:des(battle_report)
	end

	local wnd = xyd.WindowManager.get():getWindow("battle_loading_window")

	if not wnd then
		ResManager.ForceGCCollect()

		wnd = xyd.WindowManager.get():openWindow("battle_loading_window", {})
	end

	xyd.WindowManager.get():hideAllWindow({
		"battle_loading_window",
		"battle_window"
	})
	wnd:setBattleData(data)
end

function BattleController:playFirstStory(storyID)
	xyd.WindowManager.get():openWindow("story_window", {
		story_id = storyID,
		story_type = xyd.StoryType.MAIN,
		callback = function ()
			xyd.BattleController.get():startBattle()
		end
	})
end

function BattleController:playThirdStory(stageId, data, battleType)
	local plotIds = {}
	local storyType = xyd.StoryType.MAIN
	local callback = nil

	if battleType == xyd.BattleType.CAMPAIGN then
		local fort_id = StageTable:getFortID(stageId)

		if fort_id and fort_id > 10 then
			local timestamp = MiscTable:getNumber("new_story_lock_time", "value")

			if xyd.getServerTime() < timestamp then
				plotIds = nil
			else
				plotIds = MainPlotListTable:getPlotIDsByStageID(stageId)
			end
		else
			plotIds = MainPlotListTable:getPlotIDsByStageID(stageId)
		end
	elseif battleType == xyd.BattleType.HERO_CHALLENGE and xyd.models.heroChallenge:checkPlayStory(stageId) then
		plotIds = xyd.tables.partnerChallengeTable:plotId(stageId)
		storyType = xyd.StoryType.PARTNER
	elseif battleType == xyd.BattleType.HERO_CHALLENGE_CHESS and xyd.models.heroChallenge:checkPlayChessStory(stageId) then
		plotIds = xyd.tables.partnerChallengeChessTable:plotId(stageId)
		storyType = xyd.StoryType.PARTNER
	elseif battleType == xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT then
		plotIds = xyd.tables.activityNewStoryTable:getPlotIds(stageId)
		storyType = xyd.StoryType.MAIN
	elseif battleType == xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT2 then
		plotIds = xyd.tables.ativityThermStoryTable:getPlotIds(stageId)
		storyType = xyd.StoryType.ACTIVITY

		function callback()
			local win = xyd.WindowManager.get():getWindow("activity_window")
			local content = win:getCurContent()

			content:updateLayout()
		end
	end

	if (data.event_data and data.event_data.is_win and data.event_data.is_win == 1 or data.is_win and data.is_win == 1) and plotIds and plotIds[3] and plotIds[3] > 0 then
		XYDCo.WaitForTime(1, function ()
			xyd.WindowManager.get():openWindow("story_window", {
				story_id = plotIds[3],
				story_type = storyType,
				callback = function ()
					xyd.EventDispatcher:inner():dispatchEvent({
						name = xyd.event.BATTLE_END,
						data = data
					})

					if callback then
						callback()
					end
				end
			})
		end, nil)

		return
	else
		xyd.EventDispatcher:inner():dispatchEvent({
			name = xyd.event.BATTLE_END,
			data = data
		})
	end
end

function BattleController:onBattleEnd(event)
	local data = event.data
	local type_ = data.battle_type

	if type_ == xyd.BattleType.DUNGEON then
		self:onDungeonBattleResult(data)
	elseif type_ == xyd.BattleType.TOWER then
		self:onTowerBattleResult(data)
	elseif type_ == xyd.BattleType.TOWER_PRACTICE then
		self:onTowerPracticeResult(data)
	elseif type_ == xyd.BattleType.TRIAL then
		self:onTrialBattleResult(data)
	elseif type_ == xyd.BattleType.GUILD_BOSS then
		self:onGuildBossResult(data)
	elseif type_ == xyd.BattleType.ARENA_3v3 then
		self:onArena3v3BattleResult(data)
	elseif type_ == xyd.BattleType.ARENA_ALL_SERVER then
		self:onArenaAllServerBattleResult(data)
	elseif type_ == xyd.BattleType.ARENA_TEAM then
		self:onArenaTeamBattleResult(data)
	elseif type_ == xyd.BattleType.WORLD_BOSS then
		self:onWorldBossResult(data)
	elseif type_ == xyd.BattleType.GUILD_WAR then
		self:onGuildWarBattleResult(data)
	elseif type_ == xyd.BattleType.HERO_CHALLENGE then
		self:onHeroChallengeBattleResult(data)
	elseif type_ == xyd.BattleType.HERO_CHALLENGE_CHESS then
		self:onHeroChallengeChessBattleResult(data)
	elseif type_ == xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT then
		self:onLibraryWatcherStageBattleResult(data)
	elseif type_ == xyd.BattleType.PARTNER_STATION then
		self:onPartnerStationBattleResult(data)
	elseif type_ == xyd.BattleType.SPORTS_SHOW then
		self:onSportsShowBattleResult(data)
	elseif type_ == xyd.BattleType.SPORTS_PVP then
		self:onSportsBattleResult(data)
	elseif type_ == xyd.BattleType.EXPLORE_OLD_CAMPUS then
		self:onOldBuildingBattleResult(data)
	elseif type_ == xyd.BattleType.FAIR_ARENA then
		self:onFairArenaBattleResult(data)
	elseif type_ == xyd.BattleType.BEACH_ISLAND then
		self:onBeachIslandResult(data)
	elseif type_ == xyd.BattleType.ENCOUNTER_STORY then
		self:onEncounterResult(data)
	else
		self:normalBattleResult(data)
	end

	if type_ ~= xyd.BattleType.SKIN_PLAY then
		xyd.WindowManager.get():resumeHideAllWindow()
	end
end

function BattleController:normalBattleResult(data)
	local callback = nil
	local isWin = data.event_data.battle_report.isWin

	if data.battle_type == xyd.BattleType.CAMPAIGN then
		function callback(isOpen)
			if not xyd.Global.isInStart and isOpen and not xyd.WindowManager.get():isOpen("campaign_window") then
				xyd.WindowManager.get():openWindow("campaign_window", {
					noDelay = true,
					is_win = isWin
				})
			end

			if isWin ~= 1 then
				local win = xyd.WindowManager.get():getWindow("main_window")

				if win then
					win:updateStoryDialogData(data.event_data.stage_id, nil, 1)
				end
			end
		end
	elseif data.battle_type == xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT2 and isWin then
		function callback()
			local win = xyd.WindowManager.get():getWindow("activity_window")
			local content = win:getCurContent()

			content:updateLayout()
		end
	end

	self:openBaseBattleResult(data, callback)
end

function BattleController:openBaseBattleResult(data, callback, onOpenCallback)
	if xyd.Global.playReport then
		xyd.Global.playReport = false
	end

	local battleParams = data.event_data
	local isRecord = data.isRecord or false
	local recordID = data.record_id or -1
	local report = battleParams.battle_report
	report = report or data.battle_report
	onOpenCallback = onOpenCallback or data.onOpenCallback
	local isWin = report.isWin

	if data.battle_type == xyd.BattleType.GUILD_BOSS then
		isWin = battleParams.is_win
	elseif data.battle_type == xyd.BattleType.WORLD_BOSS then
		isWin = battleParams.is_win
	elseif data.battle_type == xyd.BattleType.ARENA or data.battle_type == xyd.BattleType.ARENA_3v3 or data.battle_type == xyd.BattleType.ARENA_TEAM or data.battle_type == xyd.BattleType.ARENA_ALL_SERVER then
		isWin = battleParams.battle_report_backend.isWin
	end

	local showMVP = xyd.db.misc:getValue("abbr_setting_up_battle_result")
	local abbr = false

	if not showMVP or tonumber(showMVP) == 1 then
		abbr = true
	end

	local isNew = false

	if xyd.arrayIndexOf(newVerTypeList, data.battle_type) > 0 then
		isNew = true
	end

	if isWin == 1 then
		local name = "battle_win_window"

		if isNew and abbr then
			name = "battle_win_v2_window"
		end

		xyd.WindowManager.get():openWindow(name, {
			battleParams = battleParams,
			listener = callback,
			onOpenCallback = onOpenCallback,
			map_type = data.map_type,
			battle_type = data.battle_type,
			is_last = data.is_last,
			stage_id = data.stage_id,
			is_new = isNew and abbr,
			real_battle_report = data.real_battle_report,
			isRecord = isRecord,
			record_id = recordID
		})
	else
		local name = "battle_fail_window"

		if isNew and abbr then
			name = "battle_fail_v2_window"
		end

		xyd.WindowManager.get():openWindow(name, {
			battleParams = battleParams,
			listener = callback,
			onOpenCallback = onOpenCallback,
			map_type = data.map_type,
			battle_type = data.battle_type,
			is_last = data.is_last,
			stage_id = data.stage_id,
			is_new = isNew and abbr,
			real_battle_report = data.real_battle_report,
			isRecord = isRecord,
			record_id = recordID
		})
	end
end

function BattleController:onGuildWarBattleResult(data)
	data.map_type = xyd.MapType.GUILD_WAR
	data.battle_type = xyd.BattleType.GUILD_WAR

	self:openBaseBattleResult(data)
end

function BattleController:onArenaBattleResult(data)
	data.battle_type = xyd.BattleType.ARENA

	self:openBaseBattleResult(data, nil, function ()
		if data.isReport then
			return
		end

		local win = xyd.WindowManager.get():getWindow("arena_window")
		local winTop = nil

		if win then
			winTop = win:getWindowTop()
		end

		if data.event_data.is_win == 1 then
			xyd.models.background:addBackgroundCount(xyd.ParticularBackground.DaoChang)
		end

		if self:checkShowOverCardWindow(xyd.BattleType.ARENA) then
			xyd.WindowManager.get():openWindow("arena_battle_award_window", {
				items = data.event_data.items,
				index = data.event_data.index,
				delayedTop = winTop,
				isCheckShowType = xyd.BattleType.ARENA
			})
		else
			xyd.models.itemFloatModel:pushNewItems({
				data.event_data.items[data.event_data.index]
			})
		end
	end)
end

function BattleController:onDungeonBattleResult(data)
	data.map_type = xyd.MapType.DUNGEON
	data.battle_type = xyd.BattleType.DUNGEON

	self:openBaseBattleResult(data, function ()
		local wnd = xyd.WindowManager.get():getWindow("dungeon_window")

		if wnd then
			wnd:playBattleResult(data.event_data)
		end
	end)
end

function BattleController:onTowerBattleResult(data)
	if xyd.models.towerMap:isSkipReport(xyd.BattleType.TOWER) then
		local win = xyd.getWindow("tower_window")

		if win then
			win:onTowerUpdate(data)
		end
	end

	data.map_type = xyd.MapType.TOWER
	data.battle_type = xyd.BattleType.TOWER

	self:openBaseBattleResult(data, function (isOpen)
		if isOpen and not xyd.WindowManager.get():isOpen("tower_window") then
			local wnd = xyd.WindowManager.get():getWindow("tower_window")

			if data.isRecord then
				xyd.WindowManager.get():openWindow("tower_window")
			else
				xyd.WindowManager.get():openWindow("tower_window", {
					isWin = data.event_data.battle_report.isWin
				})
			end
		end
	end)
end

function BattleController:onBeachIslandResult(data)
	data.battle_type = xyd.BattleType.BEACH_ISLAND

	self:openBaseBattleResult(data, function ()
		xyd.models.activity:reqActivityByID(xyd.ActivityID.ACTIVITY_BEACH_SUMMER)
	end)
end

function BattleController:onEncounterResult(data)
	data.battle_type = xyd.BattleType.ENCOUNTER_STORY

	self:openBaseBattleResult(data, function ()
		xyd.models.activity:reqActivityByID(xyd.ActivityID.ENCONTER_STORY)
	end)
end

function BattleController:onTowerPracticeResult(data)
	data.map_type = xyd.MapType.TOWER
	data.battle_type = xyd.BattleType.TOWER_PRACTICE

	self:openBaseBattleResult(data, function (isOpen)
		if isOpen and not xyd.WindowManager.get():isOpen("tower_window") then
			local wnd = xyd.WindowManager.get():getWindow("tower_window")

			xyd.WindowManager.get():openWindow("tower_window")
		end
	end)
end

function BattleController:onTrialBattleResult(data)
	data.map_type = xyd.MapType.TRIAL
	data.battle_type = xyd.BattleType.TRIAL

	local function openCallback()
		local params = {
			info = data.event_data.info
		}

		xyd.WindowManager.get():openWindow("activity_new_trial_fight_award_window", params)
	end

	if data.event_data.info.buff_rewards and #data.event_data.info.buff_rewards <= 0 then
		openCallback = nil
		self.newTrialInfo = data.event_data.info
	end

	if data.isReport then
		openCallback = nil
	end

	self:openBaseBattleResult(data, function ()
		local isWin = data.event_data.battle_report.isWin

		if isWin and isWin == 0 and self.newTrialInfo.current_stage ~= 1 then
			if self.newTrialInfo then
				xyd.models.trial:updateData(self.newTrialInfo)
			end

			return
		end

		local wnd = xyd.WindowManager.get():getWindow("trial_window")

		if wnd then
			wnd:onNextPoint({
				data = self.newTrialInfo
			})
		end
	end, openCallback)
end

function BattleController:onArenaTeamBattleResult(data)
	data.map_type = xyd.MapType.ARENA_TEAM
	data.battle_type = xyd.BattleType.ARENA_TEAM

	if data.isReport then
		self:openBaseBattleResult(data)
	else
		self:openBaseBattleResult(data, function ()
			local arenaTeam = xyd.models.arenaTeam
			local data = arenaTeam:getTmpReports()
			local battleData = {
				is_win = data.is_win,
				enemy_info = data.enemy_info,
				self_info = data.self_info,
				items = data.items,
				index = data.index,
				record_id = data.record_id,
				self_change = data.self_change,
				enemy_change = data.enemy_change,
				battle_reports = data.battle_reports,
				battle_report = arenaTeam:getNextReport(),
				is_last = arenaTeam:isLastReport()
			}

			if battleData.battle_report then
				xyd.WindowManager.get():closeWindow("battle_window")
				self:ArenaTeamSingleBattle(battleData)
			else
				xyd.WindowManager.get():openWindow("arena_3v3_result_window", {
					battleParams = battleData,
					battle_type = xyd.BattleType.ARENA_TEAM
				})
				arenaTeam:resetTmpReports()
			end
		end)
	end
end

function BattleController:onArena3v3BattleResult(data)
	data.map_type = xyd.MapType.ARENA_3v3
	data.battle_type = xyd.BattleType.ARENA_3v3

	if data.isReport then
		self:openBaseBattleResult(data)
	else
		self:openBaseBattleResult(data, function ()
			local arena3v3 = xyd.models.arena3v3
			local tmpReports = arena3v3:getTmpReports()
			local battleData = {
				self_change = tmpReports.self_change,
				enemy_change = tmpReports.enemy_change,
				index = tmpReports.index,
				items = tmpReports.items,
				is_win = tmpReports.is_win,
				rank = tmpReports.rank,
				score = tmpReports.score,
				enemy_info = tmpReports.enemy_info,
				battle_reports = tmpReports.battle_reports,
				self_info = tmpReports.self_info,
				record_ids = tmpReports.record_ids,
				battle_report = arena3v3:getNextReport(),
				is_last = arena3v3:isLastReport(),
				record_id = arena3v3:getRecordId()
			}

			if battleData.battle_report then
				xyd.WindowManager.get():closeWindow("battle_window")
				self:Arena3v3SingleBattle(battleData)
			else
				self:Arena3v3BattleSkip(battleData.record_id, battleData)
				arena3v3:resetTmpReports()
			end
		end)
	end
end

function BattleController:onArenaAllServerBattleResult(data)
	data.map_type = xyd.MapType.ARENA_3v3
	data.battle_type = xyd.BattleType.ARENA_ALL_SERVER

	if data.isReport then
		self:openBaseBattleResult(data)
	else
		self:openBaseBattleResult(data, function ()
			local arenaAs = xyd.models.arenaAllServerScore
			local tmpReports = arenaAs:getTmpReports()
			local battleData = {
				self_change = tmpReports.self_change,
				enemy_change = tmpReports.enemy_change,
				index = tmpReports.index,
				items = tmpReports.items,
				is_win = tmpReports.is_win,
				rank = tmpReports.rank,
				score = tmpReports.score,
				enemy_info = tmpReports.enemy_info,
				battle_reports = tmpReports.battle_reports,
				self_info = tmpReports.self_info,
				record_ids = tmpReports.record_ids,
				battle_report = arenaAs:getNextReport(),
				is_last = arenaAs:isLastReport(),
				record_id = arenaAs:getRecordId()
			}

			if battleData.battle_report then
				xyd.WindowManager.get():closeWindow("battle_window")
				self:ArenaAllServerSingleBattle(battleData)
			else
				xyd.WindowManager.get():openWindow("arena_3v3_result_window", {
					battleParams = battleData,
					battle_type = xyd.BattleType.ARENA_ALL_SERVER,
					onOpenCallback = function ()
						local win = xyd.WindowManager.get():getWindow("arena_all_server_window")
						local winTop = nil

						if win then
							win:updateScorePartInfo()

							winTop = win:getWindowTop()
						end

						if self:checkShowOverCardWindow(xyd.BattleType.ARENA_ALL_SERVER) then
							xyd.WindowManager.get():openWindow("arena_battle_award_window", {
								items = data.event_data.items,
								index = data.event_data.index,
								delayedTop = winTop,
								isCheckShowType = xyd.BattleType.ARENA_ALL_SERVER
							})
						else
							xyd.models.itemFloatModel:pushNewItems({
								data.event_data.items[data.event_data.index]
							})
						end
					end
				})
				arenaAs:resetTmpReports()
			end
		end)
	end
end

function BattleController:onGuildBossResult(data)
	data.map_type = xyd.MapType.GUILD_BOSS
	data.battle_type = xyd.BattleType.GUILD_BOSS
	local guildModel = xyd.models.guild

	self:openBaseBattleResult(data, function ()
		guildModel:updateBossInfo(data)

		local gymWnd = xyd.WindowManager.get():getWindow("guild_gym_window")

		if not gymWnd then
			xyd.WindowManager.get():openWindow("guild_gym_window")
		end

		if guildModel.bossID <= xyd.tables.guildBossTable:getMaxID() then
			if guildModel.bossID == xyd.GUILD_FINAL_BOSS_ID then
				local bossWnd = xyd.WindowManager.get():getWindow("guild_final_boss_window")

				if not bossWnd then
					xyd.WindowManager.get():openWindow("guild_final_boss_window", {
						bossId = guildModel.bossID
					})
				end
			else
				local bossWnd = xyd.WindowManager.get():getWindow("guild_boss_window")

				if not bossWnd then
					xyd.WindowManager.get():openWindow("guild_boss_window", {
						bossId = guildModel.bossID
					})
				end
			end
		end
	end)
end

function BattleController:onWorldBossResult(data)
	data.battle_type = xyd.BattleType.WORLD_BOSS

	if data.event_data.boss_info and data.event_data.boss_info.boss_type and tonumber(data.event_data.boss_info.boss_type) > 0 then
		self:openBaseBattleResult(data, function ()
			data = data.event_data

			if data == nil or data.boss_info == nil then
				return
			end

			local activityData = xyd.models.activity:getActivity(xyd.ActivityID.ACTIVITY_WORLD_BOSS)
			local type = data.boss_info.boss_type

			if data.is_win and data.is_win == 1 then
				local cur_id = activityData.detail.boss_infos[type].boss_id
				activityData.detail.boss_infos[type].boss_id = xyd.tables.activityBossTable:getNext(cur_id)

				activityData:setDataNodecode(activityData)
			end

			local info = data.boss_info

			if activityData.detail then
				activityData.detail.boss_infos[type].enemies = info.enemies

				activityData:setDataNodecode(activityData)
			else
				activityData:reqActivityList()
			end

			local bossID = info.boss_id or 0
			local win = xyd.WindowManager.get():getWindow("activity_world_boss_window")

			if bossID > 0 and win then
				win:updateStatus()
			end

			if data.is_win == 1 then
				xyd.showToast(__("WORLD_BOSS_KILL"))

				if win then
					xyd.WindowManager.get():closeWindow("activity_world_boss_window")
				end
			end
		end)
	else
		self:openBaseBattleResult(data, function ()
			if data.event_data.is_fake then
				return
			end

			if data.event_data.is_win == 1 then
				local activityData = xyd.models.activity:getActivity(xyd.ActivityID.MONTHLY_HIKE)
				local curID = activityData.detail.cur_stage_id

				if curID > 0 then
					xyd.showToast(__("WORLD_BOSS_KILL"))

					activityData.detail.cur_stage_id = xyd.tables.activityMonthlyStageTable:getNextID(curID)
					activityData.detail.skill_point = activityData.detail.skill_point + xyd.tables.activityMonthlyStageTable:getSkillPoint(curID)
					local activityContent = xyd.WindowManager.get():getWindow("activity_window"):getCurContent()

					if activityContent:getActivityContentID() == xyd.ActivityID.MONTHLY_HIKE then
						activityContent:onNextStage()
					end
				end
			end
		end)
	end
end

function BattleController:onHeroChallengeBattleResult(data)
	data.battle_type = xyd.BattleType.HERO_CHALLENGE
	local fortID = 0
	local eventData = data.event_data

	if eventData and eventData.fort_info then
		fortID = eventData.fort_info.base_info.fort_id
	end

	if data.decCoin and data.decCoin == 0 then
		fortID = 0
	end

	local function openCallback()
		xyd.WindowManager.get():openWindow("hero_challenge_fight_award_window")
	end

	local rewards = xyd.models.heroChallenge:getRewards(fortID)

	if not rewards then
		openCallback = nil
	end

	self:openBaseBattleResult(data, nil, openCallback)
end

function BattleController:onHeroChallengeChessBattleResult(data)
	data.battle_type = xyd.BattleType.HERO_CHALLENGE_CHESS
	local fortID = 0

	if data.event_data and data.event_data.fort_info then
		fortID = data.event_data.fort_info.base_info.fort_id
	end

	if data.decCoin and data.decCoin == 0 then
		fortID = 0
	end

	local function openCallback()
		local curAward = xyd.models.heroChallenge:getAwardItemInfo()

		if tonumber(curAward.num) > 0 then
			local item = {
				item_num = tonumber(curAward.num),
				item_id = xyd.ItemID.HERO_CHALLENGE_CHESS
			}
			local isWin = data.event_data.is_win

			if isWin == 0 then
				local hp = xyd.models.heroChallenge:getFailhp(fortID)
				local message = __("CHESS_FAIL_COST") .. hp
				item.item_num = xyd.tables.miscTable:getVal("partner_challenge_chess_award2")

				xyd.alertItems({
					item
				})
				xyd.alertTips(message)
			else
				xyd.alertItems({
					item
				})
			end
		end
	end

	local rewards = xyd.models.heroChallenge:getRewards(fortID)

	if not rewards then
		openCallback = nil
	end

	self:openBaseBattleResult(data, nil, openCallback)
end

function BattleController:onLibraryWatcherStageBattleResult(data)
	data.battle_type = xyd.BattleType.LIBRARY_WATCHER_STAGE_FIGHT

	self:openBaseBattleResult(data, function ()
		local win = xyd.WindowManager.get():getWindow("activity_window")
		local content = win:getCurContent()

		content:updateLayout()
	end)
end

function BattleController:onPartnerStationBattleResult(data)
	data.battle_type = xyd.BattleType.PARTNER_STATION

	self:openBaseBattleResult(data, function ()
		local wndName = {
			"partner_data_station_window",
			"partner_station_battle_formation_window",
			"guide_detail_window"
		}

		for _, name in ipairs(wndName) do
			local wnd = xyd.WindowManager.get():getWindow(name)

			if wnd then
				wnd:show()
			end
		end
	end)
end

function BattleController:onError(event)
	local mid = event.data.error_mid
	local code = event.data.error_code

	if mid and self:checkIsBattle(mid) then
		xyd.WindowManager.get():closeWindow("battle_loading_window")

		local tips = "BATTLE_ERROR"

		if code == xyd.ErrorCode.ARENA_NO_TEAM then
			tips = "ARENA_NO_TEAM"
		end

		if code == xyd.ErrorCode.BOSS_NO_EXIST or code == xyd.ErrorCode.REVENGE_CD then
			tips = xyd.tables.errorInfoTextTable:getText(code)
		end

		if code == xyd.ErrorCode.GUILD_COMPETITION_NO_TIMES then
			tips = xyd.tables.errorInfoTextTable:getText(code)

			xyd.models.guild:getGuildCompetitionServerData()
		end

		xyd.alert(xyd.AlertType.TIPS, __(tips))

		xyd.Global.playReport = false
	end
end

function BattleController:resourceLoadError()
	xyd.WindowManager.get():closeWindow("battle_loading_window")
	xyd.alert(xyd.AlertType.TIPS, __("BATTLE_LOAD_ERROR"))

	xyd.Global.playReport = false

	xyd.WindowManager.get():resumeHideAllWindow()
end

function BattleController:checkIsBattle(mid)
	if battleMID[mid] and battleMID[mid] > 0 then
		return true
	end

	return false
end

function BattleController:createBattleReport(stageID)
	local battleId = xyd.tables.newPartnerWarmUpStageTable:getBattleID(stageID)
	local initPartners = xyd.tables.newPartnerWarmUpStageTable:getInitPartner(stageID)
	local herosA = {}
	local herosB = {}
	local str = xyd.tables.battleTable:getMonsters(battleId)
	local pos = xyd.tables.battleTable:getStands(battleId)
	local posA = xyd.tables.newPartnerWarmUpStageTable:getPoses(stageID)

	for i = 1, #str do
		local hero = ReportHero.new()

		hero:populateWithTableID(str[i], {
			pos = pos[i]
		})
		table.insert(herosB, hero)
	end

	for i = 1, #initPartners do
		local hero = ReportHero.new()

		hero:populateWithTableID(initPartners[i], {
			pos = posA[i]
		})
		table.insert(herosA, hero)
	end

	local random_seeds = xyd.split(xyd.tables.miscTable:getVal("partner_warmup_random_seed"), "|", true)
	local random_seed = random_seeds[math.floor(math.random() * #random_seeds) + 1]
	local params = {
		battle_type = xyd.BattleType.NEW_PARTNER_WARMUP,
		herosA = herosA,
		herosB = herosB,
		guildSkillsA = xyd.models.guild:getGuildSkills(),
		guildSkillsB = {},
		battleID = battleId,
		random_seed = random_seed
	}
	local reporter = BattleCreateReport.new(params)

	reporter:run()

	local result = {
		battle_report = reporter:getReport(),
		stage_id = stageID
	}

	return result
end

function BattleController:frontBattleBy2BattleId(battleId1, battleId2, battleType, isWin)
	local monsterA = xyd.tables.battleTable:getMonsters(battleId1)
	local standsA = xyd.tables.battleTable:getStands(battleId1)
	local herosA = self:createHeros(monsterA, standsA)
	local monsterB = xyd.tables.battleTable:getMonsters(battleId2)
	local standsB = xyd.tables.battleTable:getStands(battleId2)
	local herosB = self:createHeros(monsterB, standsB)
	local params = {
		random_seed = 0,
		battle_type = battleType,
		herosA = herosA,
		herosB = herosB,
		battleID = battleId1
	}
	local reporter = BattleCreateReport.new(params)

	reporter:run()

	local report = reporter:getReport()
	report.isWin = isWin
	local battleParams = {
		battle_report = report
	}

	self:startBattle({
		event_data = battleParams,
		battle_type = battleType
	})
end

function BattleController:createHeros(monsters, stands)
	local heros = {}

	for i = 1, #monsters do
		local hero = ReportHero.new()

		hero:populateWithTableID(monsters[i], {
			pos = stands[i]
		})
		table.insert(heros, hero)
	end

	return heros
end

function BattleController:createReport(data, has_random)
	local herosA = {}
	local herosB = {}

	for i = 1, #data.teamA do
		local hero = ReportHero.new()

		if data.teamA[i].isMonster then
			hero:populateWithTableID(data.teamA[i].table_id, data.teamA[i])
		else
			hero:populate(data.teamA[i])
		end

		table.insert(herosA, hero)
	end

	for i = 1, #data.teamB do
		local hero = ReportHero.new()

		if data.teamB[i].isMonster then
			hero:populateWithTableID(data.teamB[i].table_id, data.teamB[i])
		else
			hero:populate(data.teamB[i])
		end

		table.insert(herosB, hero)
	end

	local petA, petB = nil

	if data.petA and tostring(data.petA) ~= "" and data.petA.pet_id ~= nil then
		local pet = ReportPet.new()

		pet:populate(data.petA)

		petA = pet
	end

	if data.petB and tostring(data.petB) ~= "" and data.petB.pet_id ~= nil then
		local pet = ReportPet.new()

		pet:populate(data.petB)

		petB = pet
	end

	local params = {
		battle_type = data.battle_type,
		herosA = herosA,
		herosB = herosB,
		petA = petA,
		petB = petB,
		guildSkillsA = data.guildSkillsA,
		guildSkillsB = data.guildSkillsB or {},
		god_skills = data.god_skills or {},
		battleID = data.info.battle_id,
		random_seed = data.random_seed,
		has_random = has_random,
		dressAttrsA = data.dressAttrsA,
		dressAttrsB = data.dressAttrsB
	}
	local reporter = BattleCreateReport.new(params)

	reporter:run()

	local report = reporter:getReport()

	return report
end

function BattleController:onActivityFight(event)
	if event.data.activity_id == xyd.ActivityID.ENTRANCE_TEST then
		local data = event.data
		local detaildata = xyd.decodeProtoBuf(event.data).detail
		local detail = cjson.decode(detaildata)
		local activitydata = xyd.models.activity:getActivity(xyd.ActivityID.ENTRANCE_TEST)
		local hasParner = false
		local isWin = detail.battle_report.isWin
		local rank = activitydata:getLevel()
		local needParners = xyd.tables.miscTable:split2num("activity_warmup_arena_partners", "value", "|")

		for i = 1, #detail.self_info.partners do
			local id = detail.self_info.partners[i].table_id

			for j = 1, #needParners do
				if tonumber(needParners[j]) == id then
					hasParner = true
				end
			end
		end

		if hasParner then
			activitydata:battleFinish(isWin)
		end

		local testWin = xyd.WindowManager.get():getWindow("activity_entrance_test_window")

		if testWin then
			testWin:battleBack(detail)
		end

		if detail.battle_report then
			detail.battle_type = xyd.BattleType.ENTRANCE_TEST
			local isSkipReport = xyd.checkCondition(tonumber(xyd.db.misc:getValue("entrance_test_skip_report")) == 1, true, false)

			if not isSkipReport then
				self:startBattle({
					event_data = detail,
					battle_type = xyd.BattleType.ENTRANCE_TEST,
					battle_report = detail.battle_report
				})
			else
				self:openBaseBattleResult({
					event_data = detail,
					battle_type = xyd.BattleType.ENTRANCE_TEST,
					battle_report = detail.battle_report
				})
			end
		end

		return
	end

	if event.data.activity_id == xyd.ActivityID.ICE_SECRET_BOSS_CHALLENGE then
		local detaildata = xyd.decodeProtoBuf(event.data).detail
		local detail = require("cjson").decode(detaildata).battle_result

		if detail.battle_report then
			detail.battle_report.isWin = 1
			local items = {}
			local item = nil
			local damage = detail.total_harm
			local ids = xyd.tables.activityIceSecretBossRewardTable:getIds()

			for i = 1, #ids do
				if xyd.tables.activityIceSecretBossRewardTable:getDamage(ids[i]) <= damage then
					item = xyd.tables.activityIceSecretBossRewardTable:getReward(ids[i])
				else
					break
				end
			end

			if not item then
				detail.battle_report.isWin = 0
			end

			table.insert(items, item)

			detail.battle_report.items = items
			detail.battle_type = xyd.BattleType.ICE_SECRET_BOSS

			self:startBattle({
				event_data = detail,
				battle_type = xyd.BattleType.ICE_SECRET_BOSS,
				battle_report = detail.battle_report
			})
		end

		return
	end

	if event.data.activity_id == xyd.ActivityID.LIMIT_CALL_BOSS then
		local detaildata = xyd.decodeProtoBuf(event.data).detail
		local detail = require("cjson").decode(detaildata).battle_result

		if detail.battle_report then
			detail.battle_report.isWin = 1
			local items = nil
			local damage = detail.total_harm
			local awardTable = xyd.tables.activityLimitBossAwardTable
			local ids = awardTable:getIds()

			for i = 1, #ids do
				if awardTable:getDamage(ids[i]) <= damage then
					items = awardTable:getReward(ids[i])
				else
					break
				end
			end

			if not items then
				detail.battle_report.isWin = 0
			end

			detail.battle_report.items = items
			detail.battle_type = xyd.BattleType.LIMIT_CALL_BOSS

			self:startBattle({
				event_data = detail,
				battle_type = xyd.BattleType.LIMIT_CALL_BOSS,
				battle_report = detail.battle_report
			})
		end

		return
	end
end

function BattleController:onSportsBattleResult(data)
	data.map_type = xyd.MapType.SPORTS_PVP
	data.battle_type = xyd.BattleType.SPORTS_PVP

	self:openBaseBattleResult(data, function ()
		if not data.is_win then
			return
		end
	end)
end

function BattleController:onOldBuildingBattleResult(data)
	data.battle_type = xyd.BattleType.EXPLORE_OLD_CAMPUS

	self:openBaseBattleResult(data)
end

function BattleController:checkShowOverCardWindow(id)
	if not self.isNeedControllerOverCard[id] then
		return true
	else
		local localTime = xyd.db.misc:getValue(self.isNeedControllerOverCard[id])

		if not localTime then
			return true
		elseif xyd.isSameDay(tonumber(localTime), xyd.getServerTime()) then
			return false
		else
			return true
		end
	end
end

function BattleController:getIsNeedControllerOverCardArr()
	return self.isNeedControllerOverCard
end

return BattleController
