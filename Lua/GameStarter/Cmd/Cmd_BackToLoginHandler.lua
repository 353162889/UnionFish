Cmd_BackToLoginHandler = Class(CommandBase)

function Cmd_BackToLoginHandler:ctor()
end

function Cmd_BackToLoginHandler:Execute(context)
	Cmd_BackToLoginHandler.superclass.Execute(self)
    LogColor("#ff0000","Cmd_BackToLoginHandler:Execute")
    --断开连接
    Client.DisposeClient()

	UIMgr.CloseAll()
	LoadingCtrl.ResetLoadingProgress()
    LoadingCtrl.OpenView(true)

    --判断当前场景是不是登录场景，如果是登录场景，不切场景，如果不是，切到登录场景
    if(LuaSceneMgr.CurSceneId ~= GlobalDefine.LoginSceneID) then
        self.OnSceneLoadFinish = function()
            self:OnSceneOperateFinish()
        end
        EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoadFinish)
        LuaSceneMgr.EnterScene(GlobalDefine.LoginSceneID)
    else
        self:OnSceneOperateFinish()
    end
end

function Cmd_BackToLoginHandler:ResetData()
     --销毁ctrl中的mode数据
    BagCtrl.ResetData()     --背包
    ChangeGunCtrl.ResetData()       --换炮
    ClockCtrl.ResetData()           --时钟
    FirstRechargeCtrl.ResetData()   --首冲
    FishCtrl.ResetData()            --鱼图鉴
    GuideCtrl.ResetData()           --指引
    GunRateUnlockCtrl.ResetData()           --炮倍解锁
    HelpCtrl.ResetData()            --帮助界面
    LoadingCtrl.ResetData()         --Loading页
    LoginCtrl.ResetData()           --登录页面
    LookForCtrl.ResetData()         --寻宝
    MainCtrl.ResetData()            --主面板
    OnlineCtrl.ResetData()          --在线奖励
    PersonalCenterCtrl.ResetData()  --个人中心
    PlayCtrl.ResetData()            --玩家控制
    RankCtrl.ResetData()            --排行
    RotationDiscCtrl.ResetData()    --转盘抽奖
    ShopCtrl.ResetData()            --商店
    SignCtrl.ResetData()            --签到
    SkillCtrl.ResetData()           --技能
    TaskCtrl.ResetData()            --任务
end

function Cmd_BackToLoginHandler:OnExecuteFinish()
     LogColor("#ff0000","Cmd_BackToLoginHandler:OnExecuteFinish")
end

function Cmd_BackToLoginHandler:OnSceneOperateFinish()
    self:ResetData()
    UIMgr.CloseView("LoadingView")
    self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_BackToLoginHandler:OnDestroy()
   
    if(self.OnSceneLoadFinish ~= nil) then
        EventMgr.RemoveEvent(ED.LuaSceneMgr_SceneLoaded,self.OnSceneLoadFinish)
        self.OnSceneLoadFinish = nil
    end
end