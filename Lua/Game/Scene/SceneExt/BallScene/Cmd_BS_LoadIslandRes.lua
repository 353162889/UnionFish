
Cmd_BS_LoadIslandRes = Class(CommandBase)

function Cmd_BS_LoadIslandRes:Execute(context)
	Cmd_BS_LoadIslandRes.superclass.Execute(self,context)
	--开始加载岛屿资源
	local area = Res.scene[BallScene.sceneId].area
	if(#area > 0) then
		self:PrepareIsLands(area)
	else
		self:OnExecuteDone(CmdExecuteState.Success)
	end
end

function Cmd_BS_LoadIslandRes:PrepareIsLands(area)
	--默认选择第一个区域
	if(BallScene.curAreaID < 0) then
		BallScene.curAreaID = area[1]
	end

	--加载岛屿资源
	local areaInfo = Res.area[BallScene.curAreaID]
	self.islandIds = areaInfo.island
	self.staticRes = areaInfo.staticRes
	if(#self.islandIds > 0 or #self.staticRes > 0) then
		local names = {}
		for k,v in pairs(self.islandIds) do
			table.insert(names,self:GetIslandPath(v))
		end
		for k,v in pairs(self.staticRes) do
			table.insert(names,self:GetStaticResPath(v))
		end
		self.onComplete = function (loader)
			self:OnLoadIslandResComplete(loader)
		end
		self.onProgress = function (res)
			self:OnLoadIslandResProgress(res)
		end
		BallScene.isLandResLoader:LoadResList(names,self.onComplete,self.onProgress)
	else
		self:OnExecuteDone(CmdExecuteState.Success)
	end
end

function Cmd_BS_LoadIslandRes:OnLoadIslandResComplete(loader)
	--初始化岛屿
	local islandParent = BallScene.sceneRoot.gameObject.Find("BallBox/Island_Box")
	--初始化动态岛屿
	for k,v in pairs(self.islandIds) do
		local res = loader:TryGetRes(self:GetIslandPath(v),nil)
		local obj = Resource.GetGameObject(res,self:GetIslandPath(v))
		Ext.AddChildToParent(islandParent,obj,false)
		obj.name = tostring(v)
		BallScene.AddIsland(v,obj)
	end
	--初始化静态岛屿
	for k,v in pairs(self.staticRes) do
		local res = loader:TryGetRes(self:GetStaticResPath(v),nil)
		local obj = Resource.GetGameObject(res,self:GetStaticResPath(v))
		Ext.AddChildToParent(islandParent,obj,false)
		obj.name = "staticRes"
		BallScene.AddStaticIsland(obj)
	end
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_BS_LoadIslandRes:GetIslandPath(islandId)
	local island = Res.island[islandId]
	return island.path.."_"..BallScene.weather.b..".prefab"
end

function Cmd_BS_LoadIslandRes:GetStaticResPath(resPath)
	return resPath.."_"..BallScene.weather.b..".prefab"
end

function Cmd_BS_LoadIslandRes:OnLoadIslandResProgress(res)
end

function Cmd_BS_LoadIslandRes:OnDestroy()
	Cmd_BS_LoadIslandRes.superclass.OnDestroy(self)
	BallScene.isLandResLoader:Clear()
	self.islandIds = nil
	self.staticRes = nil
	self.onComplete = nil
	self.onProgress = nil
end