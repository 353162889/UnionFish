UnitySceneMgr = {}
local this = UnitySceneMgr

this._curLoadingSceneName = nil
this._emptySceneName = "EmptyScene"

function this.LoadScene(sceneName,callback,onProgress)
	if(sceneName == nil or sceneName == "") then
		LogError("sceneName can not null!")
		return
	end
	if(this._curLoadingSceneName ~= nil and this._curLoadingSceneName ~= "") then
		LogError("scene ["..this._curLoadingSceneName.."] is loading!")
		return
	end
	this._curLoadingSceneName = sceneName
	coroutine.start(this.LoadEnterScene,callback,onProgress)
end

function this.LoadEnterScene(callback,onProgress)
	local displayProgress = 0;
    local toProgress = 0;
    local progressPerChange = 0.01;

	local asyncOperation
	asyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(this._emptySceneName)
	while(not asyncOperation.isDone)
	do
		coroutine.wait(0.1)
	end
	ResourceMgr.ReleaseUnuseResource()

	asyncOperation = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(this._curLoadingSceneName)
	asyncOperation.allowSceneActivation = false
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
	this._curLoadingSceneName = nil
	if(callback ~= nil) then
		callback()
	end
end

