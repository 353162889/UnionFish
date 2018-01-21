require 'Game/Scene/SceneExt/FishScene/Cmd_FS_PreloadRes'
require 'Game/Scene/SceneExt/FishScene/Cmd_FS_MgrInit'
require 'Game/Scene/SceneExt/FishScene/Cmd_FS_WaitRoleEnterScene'
require 'Game/Scene/SceneExt/FishScene/Cmd_FS_PlayEnterAnim'
require 'Game/Scene/SceneExt/FishScene/Cmd_FS_MgrDispose'

FishScene = {}
local this = FishScene

this.callback = nil
this.id = nil
this.sceneRoot = nil
this.effectResLoader = MultiResLoader:New()

function this.Enter(id,callback,...)
	this.callback = callback
	this.id = id
	Log("EnterFishScene")
	this.LoadSceneRes(this.OnLoadSceneRes)
end

function this.Exit() 
	this.id = -1
	this.sceneRoot = nil
	this.callback = nil
	local mgrDispose = Cmd_FS_MgrDispose.new()
	mgrDispose:Execute()
	this.effectResLoader:Clear()
	Log("ExitFishScene")
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
	local preloadRes = Cmd_FS_PreloadRes.new()
	local mgrInit = Cmd_FS_MgrInit.new()
	local waitRoleEnterScene = Cmd_FS_WaitRoleEnterScene.new()
	local playEnterAnim = Cmd_FS_PlayEnterAnim.new()
	this.sequence:AddSubCommand(preloadRes)
	this.sequence:AddSubCommand(mgrInit)
	this.sequence:AddSubCommand(waitRoleEnterScene)
	this.sequence:AddSubCommand(playEnterAnim)
	this.sequence:Execute()
end

function this.OnEnterFinish()
	if(this.callback ~= nil) then
		this.callback(this.sceneRoot)
	end
	this.callback = nil
end