require 'Framework/Command/Impl/CommandSequence'
require 'Game/Scene/SceneExt/BallScene/Cmd_BS_LoadIslandRes'
require 'Game/Scene/SceneExt/BallScene/Cmd_BS_LoadSceneRes'
require 'Game/Scene/SceneExt/BallScene/Cmd_BS_LoadWeatherRes'
require 'Game/Scene/SceneExt/BallScene/Cmd_BS_WeatherRandom'
require 'Game/Scene/SceneExt/BallScene/Cmd_BS_PreloadRes'
require 'Game/Scene/Unit/UnitIsland'

BallScene = {}
local this = BallScene

this.callback = nil
this.sceneId = -1
this.weather = nil
this.sceneRoot = nil
this.weatherResLoader = MultiResLoader:New()
this.isLandResLoader = MultiResLoader:New()
this.otherResLoader = MultiResLoader:New()
this.curAreaID = -1
this.curSelectIsLandId = -1
this.islands = {}
this.staticIsland = {}

function this.Enter(id,callback,...)
	this.callback = callback
	this.sceneId = id
	local arg = {...}
	if(#arg > 0) then
		this.curAreaID = select(1,...)
	end
	if(#arg > 1) then
		this.curSelectIsLandId = select(2,...)
	end

	this.sequence = CommandSequence.new()
	local cmdWeatherRandom = Cmd_BS_WeatherRandom.new()
	local cmdLoadSceneRes = Cmd_BS_LoadSceneRes.new()
	local cmdLoadWeatherRes = Cmd_BS_LoadWeatherRes.new()
	local cmdLoadIslandRes = Cmd_BS_LoadIslandRes.new()
	local cmdPreloadRes = Cmd_BS_PreloadRes.new()
	this.sequence:AddSubCommand(cmdWeatherRandom)
	this.sequence:AddSubCommand(cmdLoadSceneRes)
	this.sequence:AddSubCommand(cmdLoadWeatherRes)
	this.sequence:AddSubCommand(cmdLoadIslandRes)
	this.sequence:AddSubCommand(cmdPreloadRes)
	this.sequence:AddDoneFunc(this.OnEnterDone)
	this.sequence:Execute()
end

function this.Exit() 
	if(this.cmdLoadIslandRes ~= nil) then
		this.cmdLoadIslandRes:OnDestroy()
		this.cmdLoadIslandRes= nil
	end
	this.CloseViews()
	this.ClearIsland()
	this.sceneId = -1
	this.sceneRoot = nil
	this.callback = nil
	this.weather = nil
	this.weatherResLoader:Clear()
	this.isLandResLoader:Clear()
	this.otherResLoader:Clear()
	this.curAreaID = -1
	this.curSelectIsLandId = -1
end

function this.OnEnterDone(cmd)
	this.OnEnterFinish()
	--播放天气声音
	if(this.weather ~= nil) then
		local sound = this.weather.sound
		if(sound > 0) then
			PlaySound(sound,nil)
		end
	end
end

function this.SetLoadingViewSetProgress(progress)
	LoadingCtrl.SetLoadingProgress(progress)
end

function this.OnEnterFinish()
	this.SetLoadingViewSetProgress(100)
	if(this.callback ~= nil) then
		this.callback(this.sceneRoot)
	end
	this.callback = nil
	this.OpenViews()
end

function this.OpenViews()
	UIMgr.OpenView("MainView",{areaID = this.curAreaID,islandID = this.curSelectIsLandId})
end

function this.CloseViews()
	UIMgr.CloseView("MainView")
end

function this.AddIsland(islandId,islandObj)
	local unitIsland = UnitIsland:New(islandId,islandObj)
	unitIsland:Init()
	unitIsland:UpdateSelect(false)
	this.islands[islandId] = unitIsland
end

function this.AddStaticIsland(obj)
	if(obj ~= nil) then
		table.insert(this.staticIsland,obj)
	end
end

function this.ClearIsland()
	if(this.islands ~= nil) then
		for k,v in pairs(this.islands) do
			if(v ~= nil) then
				v:Dispose()
			end
		end
		this.islands = {}
	end
	if(this.staticIsland ~= nil) then
		for k,v in pairs(this.staticIsland) do
			UnityEngine.GameObject.Destroy(v)
		end
		this.staticIsland = {}
	end
end

function this.UpdateSelect(islandID)
	if(this.curSelectIsLandId > 0) then
		this.islands[this.curSelectIsLandId]:UpdateSelect(false)
	end
	this.curSelectIsLandId = islandID
	if(this.islands[this.curSelectIsLandId] ~= nil) then
		this.islands[this.curSelectIsLandId]:UpdateSelect(true)
	end
end

function this.UpdateArea(areaID,callback)
	this.curAreaID = areaID
	this.ClearIsland()
	this.cmdLoadIslandRes = Cmd_BS_LoadIslandRes.new()
	this.cmdLoadIslandRes:AddDoneFunc(function (cmd)
		this.cmdLoadIslandRes = nil
		callback()
	end)
	this.cmdLoadIslandRes:Execute()
end

function this.RefreshIsLands()
	if(this.islands ~= nil) then
		for k,v in pairs(this.islands) do
			if(v ~= nil) then
				v:Refresh()
			end
		end
	end
end

function this.IsIslandOpen(islandID)
	local island = this.islands[islandID]
	return island ~= nil and island.isOpen
end

