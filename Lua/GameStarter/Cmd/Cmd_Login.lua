Cmd_Login = Class(CommandBase)

function Cmd_Login:ctor()
end

function Cmd_Login:Execute(context)
	Cmd_Login.superclass.Execute(self,context)
	LogColor("#ff0000","Cmd_Login:Execute")
	--初始化网络Client（每次断线都会dispose掉）
	Client.InitClient()

	--进入登录流程，监听进入游戏的事件
	self.OnEnterGame = function ()
		self:OnRealEnterGame()
	end
	LoginCtrl.AddEvent(LoginEvent.LoginCtrl_S2CEnterGame,self.OnEnterGame)
	self.OnGetAllData = function ()
		self:OnRealGetAllData()
	end
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.GetAllData,self.OnGetAllData)

	--判断当前场景是不是登录场景，如果是登录场景，不切场景，如果不是，切到登录场景
	if(LuaSceneMgr.CurSceneId ~= GlobalDefine.LoginSceneID) then
		self.OnSceneLoad = function()
			self:OnSceneOperateFinish()
		end
		EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoad)
		LuaSceneMgr.EnterScene(GlobalDefine.LoginSceneID)
	else
		self:OnSceneOperateFinish()
	end
end

function Cmd_Login:OnExecuteFinish()
	 LogColor("#ff0000","Cmd_Login:OnExecuteFinish")
end

--销毁
function Cmd_Login:OnDestroy()
	Cmd_Login.superclass.OnDestroy(self)

	if(self.OnSceneLoad ~= nil) then
		EventMgr.RemoveEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoad)
		self.OnSceneLoad = nil
	end
	if(self.OnEnterGame ~= nil) then
		LoginCtrl.RemoveEvent(LoginEvent.LoginCtrl_S2CEnterGame,self.OnEnterGame)
		self.OnEnterGame = nil 
	end
	if(self.OnGetAllData ~= nil) then
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.GetAllData,self.OnGetAllData)
		self.OnGetAllData = nil 
	end
end

function Cmd_Login:OnSceneOperateFinish()
	UIMgr.OpenView("LoginView")
	UIMgr.OpenView("HelpView")
	-- if(LoginCtrl.CheckLocalInfo()) then
	-- 	--打开登录界面
	-- 	UIMgr.OpenView("LoginView")
	-- else
	-- 	UIMgr.OpenView("FirstLoginView")
	-- end
end

--拿到所有数据后才进入游戏
function Cmd_Login:OnRealGetAllData()
	self:OnExecuteDone(CmdExecuteState.Success)
end

--收到进入游戏命令后打开loading界面
function Cmd_Login:OnRealEnterGame()
	--打开loading界面
	LoadingCtrl.ResetLoadingProgress()
	LoadingCtrl.OpenView(true)
	--关闭登录界面
	UIMgr.CloseView("LoginView")
	-- UIMgr.CloseView("FirstLoginView")
	--打开其他界面
	UIMgr.OpenView("GunView")
	-- UIMgr.OpenView("HelpView")
	UIMgr.OpenView("HelpBottomView")
	UIMgr.OpenView("HeadView")

	--self:OnExecuteDone(CmdExecuteState.Success)
end

