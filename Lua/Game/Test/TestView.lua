TestView=Class(BaseView)

function TestView:ConfigUI()    
    self.BtnClose = Find(self.gameObject,"BtnClose")
    local onClickClose = function (go)
    	self:OnClose()
    end
    LH.AddClickEvent(self.BtnClose,onClickClose)

    local clickBtn = function (go)
    	self:OnClickBtn(go)
    end
    self.Btn_1 = Find(self.gameObject,"Grid/Btn_1")
    LH.AddClickEvent(self.Btn_1,clickBtn)
    self:SetName(self.Btn_1,"返回到登录界面")

    self.Btn_2 = Find(self.gameObject,"Grid/Btn_2")
    LH.AddClickEvent(self.Btn_2,clickBtn)
    self:SetName(self.Btn_2,"切换账号")

    self.Btn_3 = Find(self.gameObject,"Grid/Btn_3")
    LH.AddClickEvent(self.Btn_3,clickBtn)
     self:SetName(self.Btn_3,"显示日志")

    self.Btn_4 = Find(self.gameObject,"Grid/Btn_4")
    LH.AddClickEvent(self.Btn_4,clickBtn)
    self:SetName(self.Btn_4,"清除缓存")

    self.Btn_5 = Find(self.gameObject,"Grid/Btn_5")
    LH.AddClickEvent(self.Btn_5,clickBtn)
    self:SetName(self.Btn_5,"自动发射")
   
    self.Btn_6 = Find(self.gameObject,"Grid/Btn_6")
    LH.AddClickEvent(self.Btn_6,clickBtn)
    self:SetName(self.Btn_6,"退出游戏")

    self.Btn_7 = Find(self.gameObject,"Grid/Btn_7")
    LH.AddClickEvent(self.Btn_7,clickBtn)
    self:SetName(self.Btn_7,"登出")

    self.Btn_8 = Find(self.gameObject,"Grid/Btn_8")
    LH.AddClickEvent(self.Btn_8,clickBtn)
    self:SetName(self.Btn_8,"平台中心")

    self.Input = Find(self.gameObject,"Input"):GetComponent("UIInput")
    self.Btn_Hide = Find(self.gameObject,"Btn_Hide")
    self.Btn_Show = Find(self.gameObject,"Btn_Show")
    LH.AddClickEvent(self.Btn_Hide,clickBtn)
    LH.AddClickEvent(self.Btn_Show,clickBtn)
end

function TestView:OnClose()
	UIMgr.CloseView("TestView")
end

local FishVisiable = true
local PlayViewVisiable = true
local HelpViewVisiable = true
local HelpBottomVisiable = true
local ChangeGunVisiable = true
local SceneRootVisiable = true

local StopCameraMove = false
local OtherBoxVisiable = true
local SceneCameraFxVisiable = true
local SceneCameraVisiable  = true
local FishCameraVisiable = true

local BloomEffectVisiable = false

local showLog = false
function TestView:OnClickBtn(go)
	local name = go.name
    LH.Play(go,"Play")
	if(name == "Btn_1") then
        GameStarter.BackToLogin()
	elseif(name == "Btn_2")then
         SDKMgr.AccountSwitch()
	elseif(name == "Btn_3")then
        showLog = not showLog
        LH.ShowConsoleLog(showLog)
	elseif(name == "Btn_4")then
        LoginCtrl.DeleteLocalInfo()
	elseif(name == "Btn_5")then
        self:OpenSelfLaunchBullet()
	elseif(name == "Btn_6")then
        UnityEngine.Application.Quit()
    elseif(name == "Btn_7")then
        SDKMgr.Logout()
    elseif(name == "Btn_8")then
        SDKMgr.EnterPlatform()
    elseif(name == "Btn_Hide")then
        local name = self.Input.value
        if(name == nil or name == "") then
            HelpCtrl.Msg("输入路径不能为空")
            return
        end
        local go = UnityEngine.GameObject.Find(name)
        if(go == nil) then
            HelpCtrl.Msg("输入路径不正确")
            return
        end
        go:SetActive(false)
    elseif(name == "Btn_Show")then
        local name = self.Input.value
        if(name == nil or name == "") then
            HelpCtrl.Msg("输入路径不能为空")
            return
        end
        local go = UnityEngine.GameObject.Find(name)
        if(go == nil) then
            HelpCtrl.Msg("输入路径不正确")
            return
        end
        go:SetActive(true)
	end
end

function TestView:OpenSelfLaunchBullet()
    if(self.Timer == nil) then
        local OnDelay = function (lt)
            self:SendBullet()
        end
        self.Timer = LH.UseVP(0, 0, 0.1 ,OnDelay,nil)
    else
        self.Timer:Cancel()
        self.Timer = nil
    end
    -- body
end

function TestView:SendBullet()
    if(GunMgr.MainGun == nil) then
        return
    end
    local d = GunMgr.MainGun.gun.transform.localEulerAngles.z
    GunMgr.ClientSendBullet(d)
end

function TestView:SetName(go,name)
    go.transform:Find("Label"):GetComponent("UILabel").text = name
end

function TestView:AfterOpenView(t)

end

function TestView:BeforeCloseView()
end

function TestView:OnDestory()
end