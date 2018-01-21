UnitCatch = {}
function UnitCatch:New(go)
	local o = {}
	o.id = go:GetInstanceID()
	o.tableName = "UnitCatch"
	o.gameObject = go
    o.transform = o.gameObject.transform
    o.catch = o.transform:FindChild("Catch")
    o.catchTransform = o.catch.transform
    o.unitGOParent = o.transform:FindChild("Catch/Effect").gameObject
    o.changeNumerHelper = o.catch:FindChild("Num"):GetComponent("ChangeNumberHelper")
    o.icon_Sprite = o.catch:FindChild("Icon"):GetComponent("UISprite")
    o.icon_TS = o.catch:FindChild("Icon"):GetComponent("TweenScale")
    o.bg_Sprite = o.catch:FindChild("BG"):GetComponent("UISprite")
    o.line_Sprite = o.catch:FindChild("Line"):GetComponent("UISprite")
    o.catch_TP = o.catch:GetComponent("TweenPosition")
    o.catch_TS = o.catch:GetComponent("TweenScale")
    o.moveHelper = o.gameObject:GetComponent("GoMoveHelper")
    o.timeHelper = o.gameObject:GetComponent("TimeHelper")
    o.Spe = o.catch:FindChild("Spe"):GetComponent("UISprite")
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitCatch:Show(roleObjId,num,fishInfo,delay,finishCallback)
    self.callback = finishCallback
    local d = string.Split(fishInfo.ui_Catch,",")
    self.gameObject:SetActive(false)        
    self.Timer = LH.UseVP(delay, 1, 0, function()
        if(GunMgr.GetGun(roleObjId) == nil) then
            self:ShowFinish(nil,nil)
            return
        end
       	self.gameObject:SetActive(true)
        local catch = self.catch

        local unitGOParent = self.unitGOParent
        local renderQueue = GetParentPanelRenderQueue(unitGOParent)
        if PlayCtrl.IsMainRole(roleObjId) then
            if tonumber(d[6]) ~= 0 then
                UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[6]),Vector3.zero,renderQueue + 3,nil,nil)
            end            
            if tonumber(d[5]) ~= 0 then
                EventMgr.SendEvent(ED.HelpView_AddBDEffect,tonumber(d[5]))
            end
        else
            -- LogError("d_7",d[7])
            if tonumber(d[7]) ~= 0 then
                UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[7]),Vector3.zero,renderQueue + 3,nil,nil)
            end
        end
        if(tonumber(d[8]) ~= 0) then
            UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[8]),Vector3.zero,renderQueue - 2,nil,nil)
        end


        local catchTransform = self.catchTransform
        catchTransform.parent = self.transform.parent
        if tonumber(d[1]) == 1 then
            catchTransform.localPosition = Vector3.zero
            catchTransform.localScale = Vector3.one
        elseif tonumber(d[1]) == 2 then
            catchTransform.localPosition = GunMgr.GetGun(roleObjId):GetCenterPos() + Vector3.New(0,200,0)
            catchTransform.localScale = Vector3.one * 0.5
            self.changeNumerHelper.gameObject:SetActive(true)
            self.Spe.gameObject:SetActive(false)
        elseif tonumber(d[1]) == 3 then
            catchTransform.localPosition = GunMgr.GetGun(roleObjId):GetCenterPos() + Vector3.New(0,200,0)
            catchTransform.localScale = Vector3.one * 0.5
            self.changeNumerHelper.gameObject:SetActive(false)
            self.Spe.gameObject:SetActive(true)
            self.Spe.spriteName = d[9]
            self.Spe:MakePixelPerfect()
        end
        self.transform.localPosition = GunMgr.GetGun(roleObjId):GetCenterPos()
        catchTransform.parent = self.transform

        --catch:FindChild("Num"):GetComponent("UILabel").text = tostring(t.get_coin)
        local numHelper = self.changeNumerHelper
        numHelper:SetNumber(tonumber(num),1)
        self.icon_Sprite.spriteName = tostring(d[2])
        -- catch:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
        local ts = self.icon_TS
        LH.SetTweenScale(ts,0.5,1,Vector3.one*2,Vector3.one*1.5)
        --local spineHelper = catch:FindChild("SpineIcon"):GetComponent("SpineAnimHelper")
        --spineHelper:PlayAnim("Idle",true)
        --spineHelper:UpdatePath(Res.spineanim[tonumber(d[2])].path)
        self.bg_Sprite.spriteName = tostring(d[3])
        self.bg_Sprite:MakePixelPerfect()
        self.line_Sprite.spriteName = tostring(d[4])
        self.line_Sprite:MakePixelPerfect()
        if(fishInfo.type ~=  1 and fishInfo.type ~= 2) then
            PlaySound(AudioDefine.BigFishGoldDrop,nil)
        end

        local tp = self.catch_TP
        local ts = self.catch_TS
        LH.SetTweenPosition(tp,0,0.1,catch.transform.localPosition,catch.transform.localPosition)       
        if tonumber(d[1]) == 1 then 
            LH.SetTweenScale(ts,0,0.5,Vector3.one*2,Vector3.one*1)  
        elseif tonumber(d[1]) == 2 then
            LH.SetTweenScale(ts,0,0.5,Vector3.one*1,Vector3.one*0.75)
        elseif tonumber(d[1]) == 3 then
            LH.SetTweenScale(ts,0,0.5,Vector3.one*1,Vector3.one*0.75)
        end
        self.moveHelper:SetGoTo(GunMgr.GetGun(roleObjId).container,GunMgr.GetGun(roleObjId):GetCenterOffset(),0.5,3)
        local onFinish = function (go,t)
    		self:ShowFinish(go,t)
        end
        self.timeHelper:AddTime(3.5,onFinish,nil)
    end,nil)
end

function UnitCatch:ShowFinish(go,t)
	if(self.callback ~= nil) then
        local temp = self.callback
        self.callback = nil
        temp(self)
    end
end

function UnitCatch:Reset()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	self.callback = nil
end

function UnitCatch:Dispose()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
    self.gameObject = nil
    self.transform =nil
    self.catch = nil
    self.catchTransform = nil
    self.unitGOParent = nil
    self.changeNumerHelper = nil
    self.icon_Sprite = nil
    self.icon_TS = nil
    self.bg_Sprite = nil
    self.line_Sprite = nil
    self.catch_TP = nil
    self.catch_TS = nil
    self.moveHelper = nil
    self.timeHelper = nil
    self.Spe = nil
	self.callback = nil
end
