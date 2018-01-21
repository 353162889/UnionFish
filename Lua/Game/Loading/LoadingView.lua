LoadingView=Class(BaseView)

function LoadingView:ConfigUI()
    self.BG = Find(self.gameObject,"BG")
    self.Run = UIProgress:New(Find(self.gameObject,"BG/Line/Run"),UIProgressMode.Horizontal)
    self.RunEffectParent = Find(self.gameObject,"BG/Line/Run/Effect")
    --self.Run = Find(self.gameObject,"BG/Line/Run"):GetComponent("UISprite")
    self.Label = Find(self.gameObject,"BG/Line/Label"):GetComponent("UILabel")
    self.LabelDesc = Find(self.gameObject,"BG/Line/LabelDesc"):GetComponent("UILabel")
    self.Anim = Find(self.gameObject,"BG/Line/Anim")
    self.AnimHelper = self.Anim:AddComponent(typeof(SpineAnimHelper))
    self.AnimIds = {
        1000101,1001001,1001201
    }
end

function LoadingView:AfterOpenView(t)
    self.OnProgressChange = function (progress)
        self:OnSelfProgressChange(progress)
    end
    LoadingCtrl.AddEvent(LoadingEvent.OnProgressChange,self.OnProgressChange)
    self:OnSelfProgressChange(LoadingCtrl.Progress)
    if(t[1]) then
        self:UpdateDesc()
       -- self:UpdateAnim()
    end
    self.curTime = 0
    self.onTime = function ()
        self:OnSecond()
    end
    ClockCtrl.AddEvent(ClockEvent.OnSecond,self.onTime)

    --显示特效
    if(self.SkillProgressEffect == nil) then
        local renderQueue = GetParentPanelRenderQueue(self.RunEffectParent)
        self.SkillProgressEffect = UnitEffectMgr.ShowUIEffectInParent(self.RunEffectParent,54014,Vector3.zero,true,renderQueue + 10)
    end
    self.SkillProgressEffect:Show(self.RunEffectParent,Vector3.zero,true)

end

function LoadingView:OnSecond()
    self.curTime = self.curTime + 1
    if(self.curTime >= 8) then
        self.curTime = 0
        self:UpdateDesc()
    end
end

function LoadingView:BeforeCloseView()
    LogColor("#ff0000","LoadingView:BeforeCloseView")
    if(self.onTime ~= nil) then
        ClockCtrl.RemoveEvent(ClockEvent.OnSecond,self.onTime)
        self.onTime = nil
    end
    LoadingCtrl.RemoveEvent(LoadingEvent.OnProgressChange,self.OnProgressChange)
    self.OnProgressChange = nil

    if(self.SkillProgressEffect ~= nil) then
        UnitEffectMgr.DisposeEffect(self.SkillProgressEffect)
        self.SkillProgressEffect = nil
    end
end

function LoadingView:OnDestory()end

function LoadingView:OnSelfProgressChange(progress)
    self.Run:UpdateProgress(progress/100.0)
    --self.Run:GetComponent("UISprite").fillAmount = progress/100.0
    self.Label.text = L("{1}%",math.ceil(progress))
end

function LoadingView:UpdateDesc()
    local count = #SortRes.SortLoadingDesc
    local index = math.random(1,count)
    self.LabelDesc.text = L("{1}",SortRes.SortLoadingDesc[index].desc)
end

function LoadingView:UpdateAnim()
    local count = #self.AnimIds
    local index = math.random(1,count)
    local id = self.AnimIds[index]
    local path = Res.spineanim[id].path
    self.AnimHelper:UpdatePath(path)
    self.AnimHelper:UpdateLayer(SortingLayer.UI)
    local renderQueue = GetParentPanelRenderQueue(self.Anim)
    LogColor("#ff0000","RenderQueue",renderQueue)
    self.AnimHelper:UpdateQueue(renderQueue + 100)
    self.AnimHelper:PlayAnim("Idle",true)
end
