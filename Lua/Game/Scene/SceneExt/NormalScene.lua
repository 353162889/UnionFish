
NormalScene = {}
local this = NormalScene

this.callback = nil
this.id = nil
this.sceneRoot = nil

function this.Enter(id,callback,...)
	this.callback = callback
	this.id = id
	this.LoadSceneRes(this.OnLoadSceneRes)
end

function this.Exit() 
	this.id = -1
	this.sceneRoot  = nil
	this.callback = nil
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
		this.sceneRoot  = GameObject.Find("SceneBox")
		if(callback ~= nil) then
			callback()
		end
	end,this.OnSceneResProgressChange)
end

function this.OnLoadSceneRes()
	this.SetLoadingViewSetProgress(100)
	this.OnEnterFinish();
end

function this.OnEnterFinish()
	if(this.callback ~= nil) then
		this.callback(this.sceneRoot)
	end
	this.callback = nil
end