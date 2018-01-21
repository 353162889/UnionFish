require 'Game/Scene/SceneExt/AdjustScene/Cmd_AS_PreloadRes'
require 'Game/Scene/SceneExt/AdjustScene/Cmd_AS_MgrInit'
require 'Game/Scene/SceneExt/AdjustScene/Cmd_AS_WaitRoleEnterScene'
require 'Game/Scene/SceneExt/AdjustScene/Cmd_AS_MgrDispose'

AdjustScene = {}
local this = AdjustScene

this.callback = nil
this.id = nil
this.sceneRoot = nil
this.effectResLoader = MultiResLoader:New()

function this.Enter(id,callback,...)
	this.callback = callback
	this.id = id
	Log("EnterAdjustScene")
	this.LoadSceneRes(this.OnLoadSceneRes)
end

function this.Exit() 
	this.id = -1
	this.sceneRoot = nil
	this.callback = nil
	local mgrDispose = Cmd_AS_MgrDispose.new()
	mgrDispose:Execute()
	this.effectResLoader:Clear()
	Log("ExitAdjustScene")
end

function this.SetLoadingViewSetProgress(progress)
	LoadingCtrl.SetLoadingProgress(progress)
end

function this.OnSceneResProgressChange(progress)
	this.SetLoadingViewSetProgress(progress * 99.9)
end

function this.LoadSceneRes(callback)
	local scene = Res.scene[this.id]
	LuaSceneMgr.LoadUnityScene(scene.name,function ()
		this.sceneRoot = GameObject.Find("SceneBox")
		if(callback ~= nil) then
			callback()
		end
	end,this.OnSceneResProgressChange)
end

function this.OnLoadSceneRes()
	this.SetLoadingViewSetProgress(100)
	this.OnEnterFinish()

	this.sequence = CommandSequence.new()
	local preloadRes = Cmd_AS_PreloadRes.new()
	local mgrInit = Cmd_AS_MgrInit.new()
	local waitRoleEnterScene = Cmd_AS_WaitRoleEnterScene.new()
	this.sequence:AddSubCommand(preloadRes)
	this.sequence:AddSubCommand(mgrInit)
	this.sequence:AddSubCommand(waitRoleEnterScene)
	this.sequence:Execute()
end

function this.OnEnterFinish()
	if(this.callback ~= nil) then
		this.callback(this.sceneRoot)
	end
	this.callback = nil
end