
Cmd_BS_LoadWeatherRes = Class(CommandBase)

function Cmd_BS_LoadWeatherRes:Execute(context)
	Cmd_BS_LoadWeatherRes.superclass.Execute(self,context)

	--加载天气资源
	if(BallScene.weather ~= nil) then
		local names = {}
		
		self.backgroundPath = "Scene/Pre/Weather_"..BallScene.sceneId.."/Background/Background_"..BallScene.weather.b..".prefab"
		if(tonumber(BallScene.weather.w) > 0) then
			self.effectPath = "Scene/Pre/Weather_"..BallScene.sceneId.."/Effect/Effect_"..BallScene.weather.w..".prefab"
		else
			self.effectPath = nil
		end
		self.groundPath = "Scene/Pre/Weather_"..BallScene.sceneId.."/Ground/Ground_"..BallScene.weather.b..".prefab"
		table.insert(names,self.backgroundPath)
		if(self.effectPath ~= nil) then
			table.insert(names,self.effectPath)
		end
		table.insert(names,self.groundPath)
		self.onComplete = function (loader)
			self:OnLoadWeatherResComplete(loader)
		end
		self.onProgress = function (res)
			self:OnLoadWeatherResProgress(res)
		end
		BallScene.weatherResLoader:LoadResList(names,self.onComplete,self.onProgress)
	else
		self:OnExecuteDone(CmdExecuteState.Success)
	end
end

--天气资源加载完成
function Cmd_BS_LoadWeatherRes:OnLoadWeatherResComplete(loader)
	--将资源都挂载到sceneRoot上
	local root = BallScene.sceneRoot
	local effectParent = root.gameObject.Find("CameraBox/Camera/Effect_Box")
	local backgroundParent = root.gameObject.Find("CameraBox/Background_Box")
	local groundParent = root.gameObject.Find("BallBox/Ground_Box")

	if(self.effectPath ~= nil) then
		local res = loader:TryGetRes(self.effectPath,nil)
		local obj = Resource.GetGameObject(res,self.effectPath)
		Ext.AddChildToParent(effectParent,obj,false)
	end

	res = loader:TryGetRes(self.backgroundPath,nil)
	obj = Resource.GetGameObject(res,self.backgroundPath)
	Ext.AddChildToParent(backgroundParent,obj,false)

	res = loader:TryGetRes(self.groundPath,nil)
	obj = Resource.GetGameObject(res,self.groundPath)
	Ext.AddChildToParent(groundParent,obj,false)

	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_BS_LoadWeatherRes:OnLoadWeatherResProgress(res)
end

function Cmd_BS_LoadWeatherRes:OnDestroy()
	Cmd_BS_LoadWeatherRes.superclass.OnDestroy(self)
	self.onComplete = nil
	self.onProgress = nil
	self.backgroundPath = nil
	self.effectPath = nil
	self.groundPath = nil
	BallScene.weatherResLoader:Clear()
end