UnityBundleSceneMgr = {}
local this = UnityBundleSceneMgr

this._curLoadingScenePath = nil
this._curLoadingSceneName = nil
this._emptySceneName = "EmptyScene"
this._res = nil

function this.LoadScene(sceneName,scenePath,callback,onProgress)
	if(scenePath == nil or scenePath == "") then
		LogError("scenePath can not null!")
		return
	end
	if(this._curLoadingScenePath ~= nil and this._curLoadingScenePath ~= "") then
		LogError("scene ["..this._curLoadingScenePath.."] is loading!")
		return
	end
	this._curLoadingScenePath = scenePath
	this._curLoadingSceneName = sceneName
	coroutine.start(this.LoadEnterScene,callback,onProgress)
end

function this.LoadEnterScene(callback,onProgress)
	local asyncOperation
	asyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(this._emptySceneName)
	while(not asyncOperation.isDone)
	do
		coroutine.wait(0.1)
	end
	if(this._res ~= nil) then
        this._res:Release()
        this._res = nil
    end
	ResourceMgr.ReleaseUnuseResource()

	local OnResFinish = function (res)
		this.OnLoadFinish(res,{callback,onProgress})
	end
	--加载场景bundle
	ResourceMgr.GetResourceInLua(this._curLoadingScenePath,OnResFinish)
end

function this.OnLoadFinish(res, param)
	this._res = res
	this._res:Retain()
	local callback = param[1]
	local onProgress = param[2]
	coroutine.start(this.EnterSceneReal,callback,onProgress)
end

function this.EnterSceneReal(callback,onProgress)
	asyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(this._curLoadingSceneName)
	asyncOperation.allowSceneActivation = false
	local displayProgress = 0;
    local toProgress = 0;
    local progressPerChange = 0.01;
	while(asyncOperation.progress < 0.89)
	do
		toProgress = asyncOperation.progress
		while(displayProgress < toProgress)
		do
			displayProgress = displayProgress + progressPerChange
			if(displayProgress > toProgress)then displayProgress = toProgress end
			if(onProgress ~= nil) then onProgress(displayProgress) end
			coroutine.step()
		end
		if(displayProgress >= toProgress) then
			coroutine.step()
		end
	end
	toProgress = 1
	while(displayProgress < toProgress)
	do
		displayProgress = displayProgress + progressPerChange
		if(displayProgress > toProgress)then displayProgress = toProgress end
		if(onProgress ~= nil) then onProgress(displayProgress) end
		coroutine.step()
	end
	asyncOperation.allowSceneActivation = true
	while(not asyncOperation.isDone)
	do
		coroutine.step()
	end
	this._curLoadingScenePath = nil
	this._curLoadingSceneName = nil
	if(callback ~= nil) then
		callback()
	end
end

