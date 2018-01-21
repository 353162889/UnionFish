UnitGold = {}
function UnitGold:New(go)
	local o = {}
	o.id = go:GetInstanceID()
	o.tableName = "UnitGold"
	o.gameObject = go
    o.transform = o.gameObject.transform
    o.coinPic = o.gameObject.transform:FindChild("Coin/Pic")
    o.coin = o.gameObject.transform:FindChild("Coin").gameObject
    o.pic_Sprite = o.coinPic:GetComponent("UISprite")
    o.pic_MoveHelper = o.coinPic:GetComponent("PicMoveHelper")
    o.pic_TP = o.coinPic:GetComponent("TweenPosition")
    o.coinTransform = o.coin.transform
    o.coin_TP = o.coin:GetComponent("TweenPosition")
    o.moveHelper = o.gameObject:GetComponent("GoMoveHelper")
    o.timeHelper = o.gameObject:GetComponent("TimeHelper")
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitGold:Show(pos,width,radius,isSelf,originPos,targetContainer,offset,finishCallback)
	self.callback = finishCallback
	self.Timer = LH.UseVP(math.random(0,25)/100, 1, 0, function()            
        self.gameObject.transform.localPosition = Vector3.zero
        local pic = self.coinPic
        local Coin = self.coin
        Coin:SetActive(true)
        --pic.localEulerAngles = Vector3.New(0,0,math.random(0,360))
        local renderQueue = GetParentPanelRenderQueue(Coin)
        if isSelf then
            self.pic_Sprite.spriteName = "gold_1"
            self.GoldEffect = GoldItemMgr.GetGoldEffect()
            if(self.GoldEffect ~= nil) then
                self.GoldEffect:UpdateQueue(renderQueue)
                self.GoldEffect:Show(Coin,Vector3.zero,true,nil)
            end
            --UnitEffectMgr.ShowUIEffectInParentByHelper(Coin.gameObject,22001,Vector3.zero,renderQueue,nil,nil)
        else
            self.pic_Sprite.spriteName = "silver_1"
            --UnitEffectMgr.ShowUIEffectInParentByHelper(Coin.gameObject,22002,Vector3.zero,renderQueue,nil,nil)
        end
        self.pic_MoveHelper:Init()
        self.pic_MoveHelper:SetAutoPlay(true)
        self.pic_Sprite.width = tonumber(width) 
        self.pic_Sprite.height = tonumber(width)
        local picTP = self.pic_TP
        picTP:ResetToBeginning()
        picTP:PlayForward()
        self.coinTransform.parent = self.transform.parent
        self.coinTransform.position = pos
        self.transform.localPosition = originPos
        self.coinTransform.parent = self.gameObject.transform
        local tp = self.coin_TP
        local p_temp = tonumber(radius)
        local t_temp = self.coinTransform.localPosition + Vector3.New(math.random(-1 * p_temp,p_temp), math.random(-1 * p_temp,p_temp), 0)
        LH.SetTweenPosition(tp,0,0.2,self.coinTransform.localPosition,t_temp)
        self.moveHelper:SetGoTo(targetContainer,offset,0.6,0.6)
        local onFinish = function (go,t)
        	self:ShowFinish(go,t)
        end
        self.timeHelper:AddTime(2,onFinish,nil)
    end,nil)
end

function UnitGold:ShowFinish(go,t)
	PlaySound(AudioDefine.CallBackGold,nil)
	self.coin:SetActive(false)
    if(self.GoldEffect ~= nil) then
        GoldItemMgr.SaveGoldEffect(self.GoldEffect)
        self.GoldEffect = nil
    end
    self.GoldCallbackEffect = GoldItemMgr.GetGoldCallbackEffect()
    if(self.GoldCallbackEffect ~= nil) then
        local renderQueue = GetParentPanelRenderQueue(self.gameObject)
        self.GoldCallbackEffect:UpdateQueue(renderQueue + 1)
        local onFinish = function (playFinish,effect)
            if(self.GoldCallbackEffect ~= nil) then
                GoldItemMgr.SaveGoldCallbackEffect(self.GoldCallbackEffect)
                self.GoldCallbackEffect = nil
            end
            if(self.callback ~= nil) then
                local temp = self.callback
                self.callback = nil
                temp(self)
            end
        end
        self.GoldCallbackEffect:Show(self.gameObject,Vector3.zero,true,onFinish)
    else
         if(self.callback ~= nil) then
            local temp = self.callback
            self.callback = nil
            temp(self)
        end
    end
    --id 特效ID，p父节点，q渲染深度，lf播放完毕回调，lt回调参数
    -- UnitEffectMgr.ShowUIEffectInParentByHelper(self.gameObject,23001,Vector3.zero,renderQueue + 1, 
    --     function() 
    --     	if(self.callback ~= nil) then
    --     		local temp = self.callback
    --     		self.callback = nil
    --     		temp(self)
    --     	end
    --     end,nil)
end

function UnitGold:Dispose()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
     if(self.GoldCallbackEffect ~= nil) then
        GoldItemMgr.SaveGoldCallbackEffect(self.GoldCallbackEffect)
        self.GoldCallbackEffect = nil
    end
    if(self.GoldEffect ~= nil) then
        GoldItemMgr.SaveGoldEffect(self.GoldEffect)
        self.GoldEffect = nil
    end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end

    self.callback = nil
end