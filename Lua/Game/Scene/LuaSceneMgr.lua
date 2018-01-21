require 'Game/Scene/SceneExt/BallScene'
require 'Game/Scene/SceneExt/FishScene'
require 'Game/Scene/SceneExt/NormalScene'
require 'Game/Scene/SceneExt/AdjustScene'
require 'Framework/Resource/UnitySceneMgr'
require 'Framework/Resource/UnityBundleSceneMgr'

LuaSceneMgr = {}
local this = LuaSceneMgr

local _isLoading = false
local _curSceneMgr

local _sceneMap = { 
[1] = BallScene,
[2] = FishScene,
[3] = NormalScene,
[4] = AdjustScene
};

this.CurSceneId = -1
this.SceneRoot = nil

function this.EnterScene(id,...)
	if(_isLoading) then
		Log("scene is loading")
		return
	end
	local scene = Res.scene[id]
	if(scene ~= nil) then
		local sceneMgr = _sceneMap[scene.type]
		if(sceneMgr == nil) then
			LogError("can not find sceneMgr:"..scene.type)
			return
		end

		if(_curSceneMgr ~= nil) then
			_curSceneMgr.Exit()
			this.SceneRoot = nil
			_curSceneMgr = nil
		end
		_isLoading = true
		this.CurSceneId = id
		_curSceneMgr = sceneMgr
		LoadingCtrl.ResetLoadingProgress()
		--UIMgr.OpenView("LoadingView")			--切场景时打开loading界面
		LoadingCtrl.OpenView(true)
		StopAllSound()
		_curSceneMgr.Enter(id,this.OnSceneEnterFinish,...)
	else
		LogError("[loadScene]can not find sceneId:"..id)
	end		
end

function this.OnSceneEnterFinish(obj)
	this.SceneRoot = obj
	_isLoading = false
	UIMgr.CloseView("LoadingView")				--切完场景关闭loading界面
	local sound = Res.scene[this.CurSceneId].sound
	if(sound > 0) then
		PlaySound(sound,nil)
	end
	EventMgr.SendEvent(ED.LuaSceneMgr_SceneLoaded)
end

function this.SetSceneResProgress(progress)
	_curSceneMgr.OnSceneResProgressChange(progress)
end

function this.RandomWeather()
	if(this.CurSceneId > 0 and Res.scene[this.CurSceneId].type == 1) then
		_curSceneMgr.RandomWeather()
	else
		LogError("Current Scene not ball scene!")
	end

end

function this.LoadUnityScene(sceneName,callback,onProgress)
	if(ResourceMgr.Instance.ResourcesLoadMode)then
		UnitySceneMgr.LoadScene(sceneName,callback,onProgress)
	else
		local scenePath = "Scene/Pre/"..sceneName..".unity"
		UnityBundleSceneMgr.LoadScene(sceneName,scenePath,callback,onProgress)
	end
end
