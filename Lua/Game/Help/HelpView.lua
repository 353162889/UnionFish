HelpView=Class(BaseView)

function HelpView:ConfigUI()    
    self.GuideBox = Find(self.gameObject,"GuideBox")
    self.BulletParent = Find(self.gameObject,"BulletBox")

	self.MsgItem = Find(self.gameObject,"MsgBox/Item")
	self.MsgItem:SetActive(false)
	self.MsgItemBox = {}
	self.MsgItemBoxUse = {}

    -- self.NumItem = Find(self.gameObject,"NumBox/Item")
    -- self.NumItem:SetActive(false)

    self.EffectBox = Find(self.gameObject,"EffectBox")

    -- self.MoneyItem = Find(self.gameObject,"MoneyBox/Item")
    -- self.MoneyItem:SetActive(false)
    -- self.MoneyItemBox = {}
    -- self.MoneyItemBoxUse = {}

    -- self.CatchItem = Find(self.gameObject,"CatchBox/Item")
    -- self.CatchItem:SetActive(false)
    -- self.CatchItemBox = {}
    -- self.CatchItemBoxUse = {}
    -- self.CurCatch = nil

    self.BDEffect = Find(self.gameObject,"BDEffect")
    self.BDEffect:SetActive(false)
    self.BDEffectDic = {}
    self.BDEffectList = {}
    self.VP_Handle_BDEffect = nil

    self.BtnTest = Find(self.gameObject,"BtnTest") 
    local onClickBtnTest = function ()
        if(LH.IsDebugMode()) then
            UIMgr.OpenView("TestView")
        end
    end
    LH.AddClickEvent(self.BtnTest,onClickBtnTest)

    self.RunWordItem = Find(self.gameObject,"RunWordBox")
    self.RunWordItem:SetActive(false)
    self.RunWordItemLabel = Find(self.gameObject,"RunWordBox/BG/LabelPoint")
    self.RunWordItemLabel.transform:FindChild("Label"):GetComponent("UILabel").text = ""
    self.RunWordItemLabel:SetActive(false)
    self.RunWordItemBG = Find(self.gameObject,"RunWordBox/BG")
    self.RunWordItemLabelBox = Find(self.gameObject,"RunWordBox/LabelBox")
    self.RunWordItemList = { }

end


function HelpView.RunWord(t)
    local str = t
    local s = UIMgr.Dic("HelpView")
    s.RunWordItem:SetActive(true)
    local item = s.GetRunWordItem()
    item.transform.parent = s.RunWordItemLabelBox.transform
    local item_X = s.GetRunWordX()
    item:SetActive(true)
    local w = s.RunWordItemBG:GetComponent("UISprite").width / 2
    local v3 = nil
    if item_X == -10000 then
        v3 = Vector3.New(w, s.RunWordItemBG.transform.localPosition.y, 0)
    else
        if item_X < w then
            v3 = Vector3.New(w + 100, s.RunWordItemBG.transform.localPosition.y, 0)
        else
            v3 = Vector3.New(item_X + 100, s.RunWordItemBG.transform.localPosition.y, 0)
        end
    end
    item.transform.localPosition = v3
    item.transform:FindChild("Label"):GetComponent("UILabel").text = L("{1}",str)
end
function HelpView.GetRunWordItem()
    local s = UIMgr.Dic("HelpView")
    for i = 1, #s.RunWordItemList do
        if s.RunWordItemList[i].transform:FindChild("Label"):GetComponent("UILabel").text == "" then
            return s.RunWordItemList[i]
        end
    end
    local temp = LH.GetGoBy(s.RunWordItemLabel,s.RunWordItemLabelBox)
    table.insert(s.RunWordItemList, temp)
    return temp
end
function HelpView.GetRunWordX()
    local s = UIMgr.Dic("HelpView")
    local _x = -10000
    for i = 1, #s.RunWordItemList do
        if s.RunWordItemList[i].transform:FindChild("Label"):GetComponent("UILabel").text ~= "" then
            if s.RunWordItemList[i].transform.localPosition.x + s.RunWordItemList[i].transform:FindChild("Label"):GetComponent("UILabel").width > _x then
                _x = s.RunWordItemList[i].transform.localPosition.x + s.RunWordItemList[i].transform:FindChild("Label"):GetComponent("UILabel").width
            end
        end
    end
    return _x
end


function HelpView:AfterOpenView(t)
    if (UIMgr.Dic("HelpView").VP_Handle_BDEffect == nil) then
        UIMgr.Dic("HelpView").VP_Handle_BDEffect = LH.UseVP(0.1, 0, 1, UIMgr.Dic("HelpView").UpdateBDEffect, nil) 
    end
end

local BDEffectIndex = -1
function HelpView.PlayBDEffect(b,c,cd,pic)
    UIMgr.Dic("HelpView").BDEffect:SetActive(b)
    if b then
        UIMgr.Dic("HelpView").BDEffect:GetComponent("UISprite").color = c
        UIMgr.Dic("HelpView").BDEffect:GetComponent("UISprite").spriteName = pic
        local tw = UIMgr.Dic("HelpView").BDEffect:GetComponent("TweenAlpha")
        tw.duration = cd
        tw:ResetToBeginning()
        tw:PlayForward()
    end
end

function HelpView.AddBDEffect(key)
    BDEffectIndex = BDEffectIndex + 1
    if (BDEffectIndex >= 10000) then BDEffectIndex = 0 end

    local dic = UIMgr.Dic("HelpView").BDEffectDic
    dic[Res.bd[key].Lv * 10000 + BDEffectIndex] = CopyTable(Res.bd[key])
end
function HelpView.RemoveBDEffectInID(id)
    local outEffect = {}
    for k,v in pairs(UIMgr.Dic("HelpView").BDEffectDic) do
        if v.id == id then
            table.insert(outEffect, k)
        end
    end
    for k,v in pairs(outEffect) do
        UIMgr.Dic("HelpView").BDEffectDic[v] = nil
    end
end
function HelpView.RemoveBDEffectInLv(lv)
    local outEffect = {}
    for k,v in pairs(UIMgr.Dic("HelpView").BDEffectDic) do
        if (k/(lv*10000) == 1) then
            table.insert(outEffect, k)
        end
    end
    for k,v in pairs(outEffect) do
        UIMgr.Dic("HelpView").BDEffectDic[v] = nil
    end
end
function HelpView.RemoveBDEffectInType(t) -- 整数
    if (t == -1) then return end
    local outEffect = {}
    for k,v in pairs(UIMgr.Dic("HelpView").BDEffectDic) do
        if (v.type == t) then
            table.insert(outEffect, k)
        end
    end
    for k,v in pairs(outEffect) do
        UIMgr.Dic("HelpView").BDEffectDic[v] = nil
    end
end
function HelpView.RemoveBDEffectAll()
    UIMgr.Dic("HelpView").BDEffectDic = {}
end
function HelpView.UpdateBDEffect()
    if (table.getn(UIMgr.Dic("HelpView").BDEffectDic) <= 0) then 
        UIMgr.Dic("HelpView").PlayBDEffect(false, Color.New(1,1,1), 1)
        return 
    end
    local dic = UIMgr.Dic("HelpView").BDEffectDic
    local outEffect = {}
    for k,v in pairs(dic) do
        v.time = v.time - 1
        if (v.time == 0) then
            table.insert(outEffect, k)
        end
    end
    for k,v in pairs(outEffect) do
        dic[v] = nil
    end
    local max = table.maxn(dic)
    if (max == -1) then 
        UIMgr.Dic("HelpView").PlayBDEffect(false, Color.New(1,1,1), 1)
    else
        local color = string.Split(dic[max].color,",")
        UIMgr.Dic("HelpView").PlayBDEffect(true, Color.New(color[1]/255,color[2]/255,color[3]/255), dic[max].cd, dic[max].pic)
    end
end

function HelpView:LoadSceneResource()
end

function HelpView:AddListener()
    self:AddEvent(ED.HelpView_Msg,self.this.Msg)
    self:AddEvent(ED.HelpView_Num,self.this.Num)
    self:AddEvent(ED.HelpView_Money,self.this.Money)
    self:AddEvent(ED.HelpView_MoneyParam,self.this.MoneyParam)
    self:AddEvent(ED.HelpView_Catch,self.this.Catch)
    self:AddEvent(ED.HelpView_RunWord,self.this.RunWord)

    
    self:AddEvent(ED.HelpView_AddBDEffect,self.this.AddBDEffect)
    self:AddEvent(ED.HelpView_RemoveBDEffectInID,self.this.RemoveBDEffectInID)
    self:AddEvent(ED.HelpView_RemoveBDEffectInLv,self.this.RemoveBDEffectInLv)
    self:AddEvent(ED.HelpView_RemoveBDEffectInType,self.this.RemoveBDEffectInType)
    self:AddEvent(ED.HelpView_RemoveBDEffectAll,self.this.RemoveBDEffectAll)
end

function HelpView:BeforeCloseView()
end

function HelpView:Update()
end

function HelpView:OnDestory()
end

function HelpView.OnClickBtn(go)
end


function HelpView.Msg(t)
	UIMgr.Dic("HelpView").GetMsgItem(t)
end
function HelpView.GetMsgItem(t)
    if #UIMgr.Dic("HelpView").MsgItemBox == 0 then
        local temp = LH.GetGoBy(UIMgr.Dic("HelpView").MsgItem,UIMgr.Dic("HelpView").MsgItem.transform.parent.gameObject)
        temp:SetActive(true)
        table.insert(UIMgr.Dic("HelpView").MsgItemBox, temp)
    end
    local temp = UIMgr.Dic("HelpView").MsgItemBox[1]
    temp:SetActive(true)
    temp.transform:FindChild("Point/Label"):GetComponent("UILabel").text = L("{1}",t)
    local tp = temp.transform:FindChild("Point"):GetComponent("TweenPosition")
    tp:ResetToBeginning()
    tp:PlayForward()
    local ta = temp:GetComponent("TweenAlpha")
    ta:ResetToBeginning()
    ta:PlayForward()
    local vp_TimerHandle = LH.UseVP(3.5, 1, 0, UIMgr.Dic("HelpView").BackMsgItem,nil)
    table.remove(UIMgr.Dic("HelpView").MsgItemBox, 1)
    table.insert(UIMgr.Dic("HelpView").MsgItemBoxUse, temp)
    for i = 1, #UIMgr.Dic("HelpView").MsgItemBoxUse do
        UIMgr.Dic("HelpView").MsgItemBoxUse[i].transform.localPosition = Vector3.New(0, 45 *(#UIMgr.Dic("HelpView").MsgItemBoxUse - i), 0)
    end
    return temp
end
function HelpView.BackMsgItem()
    local temp = UIMgr.Dic("HelpView").MsgItemBoxUse[1]
    temp:SetActive(false)
    table.remove(UIMgr.Dic("HelpView").MsgItemBoxUse, 1)
    table.insert(UIMgr.Dic("HelpView").MsgItemBox, temp)
end
--[[重复代码
function HelpView.Num(t)
    local temp = UIMgr.Dic("HelpView").GetNumItem()
    table.remove(UIMgr.Dic("HelpView").NumItemBox, 1)
    table.insert(UIMgr.Dic("HelpView").NumItemBoxUse, temp)
    local v = FishMgr.GetScreenPos(t.fish_obj_id)
    temp.transform.position = v
    temp.transform:FindChild("Pic"):GetComponent("UILabel").text = tostring(t.get_coin)
    LH.SetTweenPosition(temp:GetComponent("TweenPosition"),0.5,0.5,temp.transform.localPosition,temp.transform.localPosition + Vector3.New(0,100,0))
    LH.SetTweenScale(temp:GetComponent("TweenScale"),0,0.3,Vector3.one*2,Vector3.one)
    LH.SetTweenAlpha(temp:GetComponent("TweenAlpha"),0.5,0.5,1,0)

    temp:GetComponent("TimeHelper"):AddTime(1,UIMgr.Dic("HelpView").BackNumItem,{temp})
    if t.role_obj_id == PlayCtrl.GetMainRole().role_obj_id then
        temp.transform:FindChild("Pic"):GetComponent("UILabel").color = Color.New(1,1,1)
    else
        temp.transform:FindChild("Pic"):GetComponent("UILabel").color = Color.New(0,0,0)
    end
end
function HelpView.GetNumItem()
    if #UIMgr.Dic("HelpView").NumItemBox == 0 then
        local temp = LH.GetGoBy(UIMgr.Dic("HelpView").NumItem,UIMgr.Dic("HelpView").NumItem.transform.parent.gameObject)
        temp:SetActive(true)
        table.insert(UIMgr.Dic("HelpView").NumItemBox, temp)
    end
    local temp = UIMgr.Dic("HelpView").NumItemBox[1]
    temp:SetActive(true)
    temp.name = "NumItem"
    return temp
end
function HelpView.BackNumItem(g,t)
    table.remove(UIMgr.Dic("HelpView").NumItemBoxUse, 1)
    table.insert(UIMgr.Dic("HelpView").NumItemBox, t[1])
end
]]

function HelpView.Num(t)
    if FishMgr.GetScreenPos(t.fish_obj_id) ~= nil then
        local v = FishMgr.GetScreenPos(t.fish_obj_id)
        local color = nil
        if t.role_obj_id == PlayCtrl.GetMainRole().role_obj_id then
            color = Color.New(1,1,1)
            local fish = FishMgr.GetFish(t.fish_obj_id)
            if(fish ~= nil) then
                local d = string.Split(fish.fishInfo.ui_Catch,",")
                local delayTime = 2
                if tonumber(d[1]) ~= 0 then
                    delayTime = 4.5
                end
                GunMgr.GetGun(t.role_obj_id):ShowBubbleNumSequence(tonumber(fish.fishInfo.gun_bubble),t.get_coin,nil,delayTime)
            end
        else
            color = Color.New(0,0,0)
        end
        NumItemMgr.ShowNum(v,t.get_coin,color)
    end
end

function HelpView.MoneyParam(t,gold_Icon)
    if FishMgr.GetScreenPos(t.fish_obj_id) ~= nil then
        local pos = FishMgr.GetScreenPos(t.fish_obj_id)
        GoldItemMgr.ShowGolds(pos,gold_Icon,t.role_obj_id)
    end
end
--[[
function HelpView.MoneyParam(t,gold_Icon)
     if FishMgr.GetScreenPos(t.fish_obj_id) ~= nil then
        local d = string.Split(gold_Icon,",")
        local count = tonumber(d[1])
        local v = FishMgr.GetScreenPos(t.fish_obj_id)

        PlaySound(AudioDefine.FishGetGold,nil)

        for i=1,count do
            LH.UseVP(math.random(0,25)/100, 1, 0, function()            
                if  GunMgr.GetGun(t.role_obj_id) == nil then
                    return
                end
                local temp = UIMgr.Dic("HelpView").GetMoneyBoxItem()
                table.remove(UIMgr.Dic("HelpView").MoneyItemBox, 1)
                table.insert(UIMgr.Dic("HelpView").MoneyItemBoxUse, temp)
                temp.transform.localPosition = Vector3.zero
                local pic = temp.transform:FindChild("Coin/Pic")
                local Coin = temp.transform:FindChild("Coin")
                --pic.localEulerAngles = Vector3.New(0,0,math.random(0,360))
                local renderQueue = GetParentPanelRenderQueue(Coin.gameObject)
                if t.role_obj_id == PlayCtrl.GetMainRole().role_obj_id then
                    pic:GetComponent("UISprite").spriteName = "gold_1"
                    UnitEffectMgr.ShowUIEffectInParentByHelper(Coin.gameObject,22001,Vector3.zero,renderQueue,nil,nil)
                else
                    pic:GetComponent("UISprite").spriteName = "silver_1"
                    UnitEffectMgr.ShowUIEffectInParentByHelper(Coin.gameObject,22002,Vector3.zero,renderQueue,nil,nil)
                end
                pic:GetComponent("PicMoveHelper"):Init()
                pic:GetComponent("PicMoveHelper"):SetAutoPlay(true)
                pic:GetComponent("UISprite").width = tonumber(d[2]) 
                pic:GetComponent("UISprite").height = tonumber(d[2])
                local picTP = pic:GetComponent("TweenPosition")
                picTP:ResetToBeginning()
                picTP:PlayForward()
                Coin.transform.parent = temp.transform.parent
                Coin.transform.position = v
                temp.transform.localPosition = GunMgr.GetGun(t.role_obj_id):GetCenterPos()
                Coin.transform.parent = temp.transform
                local tp = Coin:GetComponent("TweenPosition")
                local p_temp = tonumber(d[3])/2
                local t_temp = Coin.localPosition + Vector3.New(math.random(-1 * p_temp,p_temp), math.random(-1 * p_temp,p_temp), 0)
                LH.SetTweenPosition(tp,0,0.2,Coin.localPosition,t_temp)
                temp:GetComponent("GoMoveHelper"):SetGoTo(GunMgr.GetGun(t.role_obj_id).container,GunMgr.GetGun(t.role_obj_id):GetCenterOffset(),0.6,0.6)
                temp:GetComponent("TimeHelper"):AddTime(2,UIMgr.Dic("HelpView").BackMoneyItem,{temp})
            end,nil)
        end
    else
        LogError("鱼已被回收")
    end
end
]]

function HelpView.Money(t)
    if FishMgr.GetScreenPos(t.fish_obj_id) ~= nil then
        local ResData = FishMgr.GetData(t.fish_obj_id)
        UIMgr.Dic("HelpView").MoneyParam(t,ResData.g_Icon)
    else
        LogError("鱼已被回收")
    end
    
end
-- function HelpView.GetMoneyBoxItem()
--     if #UIMgr.Dic("HelpView").MoneyItemBox == 0 then
--         local temp = LH.GetGoBy(UIMgr.Dic("HelpView").MoneyItem,UIMgr.Dic("HelpView").MoneyItem.transform.parent.gameObject)
--         table.insert(UIMgr.Dic("HelpView").MoneyItemBox, temp)
--     end
--     local temp = UIMgr.Dic("HelpView").MoneyItemBox[1]
--     temp:SetActive(true)
--     temp.transform:FindChild("Coin").gameObject:SetActive(true)
--     temp.name = "MoneyItem"
--     return temp
-- end
-- function HelpView.BackMoneyItem(g,t)
--     -- t[1]:SetActive(false)            
--     if  PlayCtrl.GetMainRole() ~= nil then
--         PlaySound(AudioDefine.CallBackGold,nil)
--         t[1].transform:FindChild("Coin").gameObject:SetActive(false)
--         --id 特效ID，p父节点，q渲染深度，lf播放完毕回调，lt回调参数
--         local renderQueue = GetParentPanelRenderQueue(t[1])
--         UnitEffectMgr.ShowUIEffectInParentByHelper(t[1],23001,Vector3.zero,renderQueue + 1, 
--             function() 
--                 t[1]:SetActive(false)
--                 table.remove(UIMgr.Dic("HelpView").MoneyItemBoxUse, 1)
--                 table.insert(UIMgr.Dic("HelpView").MoneyItemBox, t[1])
--             end,nil)
--     else
--         t[1]:SetActive(false)
--         table.remove(UIMgr.Dic("HelpView").MoneyItemBoxUse, 1)
--         table.insert(UIMgr.Dic("HelpView").MoneyItemBox, t[1])
--     end
-- end

-- 1 UI位置：0没有，1中心，2炮上方
-- 2 Icon图片
-- 3 底图
-- 4 横幅
-- 5 边框特效ID
-- 6 自己打死附带特效
-- 7 别人打死附带特效
-- 8 UI背景特效
function HelpView.Catch(t)
    if FishMgr.GetScreenPos(t.fish_obj_id) ~= nil then
        local ResData = FishMgr.GetData(t.fish_obj_id)
        CatchMgr.ShowCatch(t.role_obj_id,t.get_coin,ResData)
        -- local d = string.Split(ResData.ui_Catch,",")
        -- if tonumber(d[1]) == 0 then
        --     return
        -- end

        -- --临时处理，先预下载动画资源
        -- --SpineAnimHelper.PreLoadPath(Res.spineanim[tonumber(d[2])].path)        
        -- LH.UseVP(1, 1, 0, function()
        --     if  PlayCtrl.GetMainRole() == nil then
        --         return
        --     end
        --     if UIMgr.Dic("HelpView").CurCatch ~= nil and UIMgr.Dic("HelpView").CurCatch.activeSelf == true then
        --         -- UIMgr.Dic("HelpView").CurCatch:GetComponent("GoMoveHelper"):SetEnd()
        --     end
        --     local temp = UIMgr.Dic("HelpView").GetCatchBoxItem()
        --     UIMgr.Dic("HelpView").CurCatch = temp
        --     table.remove(UIMgr.Dic("HelpView").CatchItemBox, 1)
        --     table.insert(UIMgr.Dic("HelpView").CatchItemBoxUse, temp)
        --     local catch = temp.transform:FindChild("Catch")
    
        --     local unitGOParent = temp.transform:FindChild("Catch/Effect").gameObject
        --     local renderQueue = GetParentPanelRenderQueue(unitGOParent)
        --     if t.role_obj_id == PlayCtrl.GetMainRole().role_obj_id then
        --         if tonumber(d[6]) ~= 0 then
        --             UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[6]),Vector3.zero,renderQueue + 3,nil,nil)
        --         end            
        --         if tonumber(d[5]) ~= 0 then
        --             EventMgr.SendEvent(ED.HelpView_AddBDEffect,tonumber(d[5]))
        --         end
        --     else
        --         -- LogError("d_7",d[7])
        --         if tonumber(d[7]) ~= 0 then
        --             UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[7]),Vector3.zero,renderQueue + 3,nil,nil)
        --         end
        --     end
        --     UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,tonumber(d[8]),Vector3.zero,renderQueue - 2,nil,nil)

        --     catch.transform.parent = temp.transform.parent
        --     if tonumber(d[1]) == 1 then
        --         catch.transform.localPosition = Vector3.zero
        --         catch.transform.localScale = Vector3.one
        --     elseif tonumber(d[1]) == 2 then
        --         catch.transform.localPosition = GunMgr.GetGun(t.role_obj_id):GetCenterPos() + Vector3.New(0,200,0)
        --         catch.transform.localScale = Vector3.one * 0.5
        --     end
        --     temp.transform.localPosition = GunMgr.GetGun(t.role_obj_id):GetCenterPos()
        --     catch.transform.parent = temp.transform
    
        --     --catch:FindChild("Num"):GetComponent("UILabel").text = tostring(t.get_coin)
        --     local numHelper = catch:FindChild("Num"):GetComponent("ChangeNumberHelper")
        --     numHelper:SetNumber(tonumber(t.get_coin),1)
        --     catch:FindChild("Icon"):GetComponent("UISprite").spriteName = tostring(d[2])
        --     -- catch:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
        --     local ts = catch:FindChild("Icon"):GetComponent("TweenScale")
        --     LH.SetTweenScale(ts,0.5,1,Vector3.one*2,Vector3.one*1.5)
        --     --local spineHelper = catch:FindChild("SpineIcon"):GetComponent("SpineAnimHelper")
        --     --spineHelper:PlayAnim("Idle",true)
        --     --spineHelper:UpdatePath(Res.spineanim[tonumber(d[2])].path)
        --     catch:FindChild("BG"):GetComponent("UISprite").spriteName = tostring(d[3])
        --     catch:FindChild("BG"):GetComponent("UISprite"):MakePixelPerfect()
        --     catch:FindChild("Line"):GetComponent("UISprite").spriteName = tostring(d[4])
        --     catch:FindChild("Line"):GetComponent("UISprite"):MakePixelPerfect()
        --     if(ResData.type ~=  1 and ResData.type ~= 2) then
        --         PlaySound(AudioDefine.BigFishGoldDrop,nil)
        --     end
    
        --     local tp = catch:GetComponent("TweenPosition")
        --     local ts = catch:GetComponent("TweenScale")
        --     LH.SetTweenPosition(tp,0,0.1,catch.transform.localPosition,catch.transform.localPosition)       
        --     if tonumber(d[1]) == 1 then 
        --         LH.SetTweenScale(ts,0,0.5,Vector3.one*2,Vector3.one*1)  
        --     elseif tonumber(d[1]) == 2 then
        --         LH.SetTweenScale(ts,0,0.5,Vector3.one*1,Vector3.one*0.75)
        --     end
        --     temp:GetComponent("GoMoveHelper"):SetGoTo(GunMgr.GetGun(t.role_obj_id).container,GunMgr.GetGun(t.role_obj_id):GetCenterOffset(),0.5,3)
        --     temp:GetComponent("TimeHelper"):AddTime(3.5,UIMgr.Dic("HelpView").BackCatchItem,{temp})
        -- end,nil)
    else
        LogError("子弹已被回收")
    end
end
-- function HelpView.GetCatchBoxItem()
--     if #UIMgr.Dic("HelpView").CatchItemBox == 0 then
--         local temp = LH.GetGoBy(UIMgr.Dic("HelpView").CatchItem,UIMgr.Dic("HelpView").CatchItem.transform.parent.gameObject)
--         local numGo = temp.transform:Find("Catch/Num")
--         numGo.gameObject:AddComponent(typeof(ChangeNumberHelper))
--         local spineIcon = temp.transform:Find("Catch/SpineIcon")
--         local helper = spineIcon.gameObject:AddComponent(typeof(SpineAnimHelper))
--         local panel = GetParentPanel(spineIcon.gameObject)
--         helper:UpdateQueue(panel.startingRenderQueue + 2)
--         table.insert(UIMgr.Dic("HelpView").CatchItemBox, temp)
--     end
--     local temp = UIMgr.Dic("HelpView").CatchItemBox[1]
--     temp:SetActive(true)
--     temp.name = "CatchItem"
--     return temp
-- end
-- function HelpView.BackCatchItem(g,t)
--     t[1]:SetActive(false)
--     t[1].transform:Find("Catch/SpineIcon"):GetComponent("SpineAnimHelper"):Dispose()
--     table.remove(UIMgr.Dic("HelpView").CatchItemBoxUse, 1)
--     table.insert(UIMgr.Dic("HelpView").CatchItemBox, t[1])
-- end

