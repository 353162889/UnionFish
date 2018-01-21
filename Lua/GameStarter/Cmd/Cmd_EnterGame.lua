Cmd_EnterGame = Class(CommandBase)

function Cmd_EnterGame:ctor()
end

function Cmd_EnterGame:Execute(context)
	Cmd_EnterGame.superclass.Execute(self)
	LogColor("#ff0000","Cmd_EnterGame:Execute")
	--监听进入场景的消息
	self.OnSceneLoad = function()
		self:OnSceneLoadFinish()
	end
	EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoad)

	--进入主场景
	-- local areaId = Res.scene[MainSceneId].area[1]
	-- local selectIslandID = Res.area[areaId].island[1]
	local areaId,islandId = MainCtrl.GetFitAreaAndIsland()
	LogColor("#ff0000","areaId",areaId,"islandId",islandId)
	LuaSceneMgr.EnterScene(GlobalDefine.BallSceneID,areaId,islandId)
	-- --关闭登录界面
	-- UIMgr.CloseView("LoginView")
	-- UIMgr.CloseView("FirstLoginView")
end

function Cmd_EnterGame:OnExecuteFinish()
	if(self.OnSceneLoad ~= nil) then
		EventMgr.RemoveEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoad)
		self.OnSceneLoad = nil
	end
	LogColor("#ff0000","Cmd_EnterGame:OnExecuteFinish")
end

function Cmd_EnterGame:OnSceneLoadFinish()
	-- UIMgr.OpenView("GunView")
	-- UIMgr.OpenView("HelpView")
	-- UIMgr.OpenView("HelpBottomView")
	-- UIMgr.OpenView("HeadView")

	UIMgr.CloseView("LoadingView")

	--打开签到
	if SignCtrl.modeSign~=nil then
		if SignCtrl.modeSign.sign==0 then
			UIMgr.OpenView("SignView")
		end
	end

	self:OnExecuteDone(CmdExecuteState.Success)


end