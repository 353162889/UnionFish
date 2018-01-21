UnitDrop = {}
function UnitDrop:New(go)
	local o = {}
	o.id = go:GetInstanceID()
	o.tableName = "UnitDrop"
	o.gameObject = go
	o.tp = o.gameObject:GetComponent("TweenPosition")
	o.icon = o.gameObject.transform:FindChild("Item/Icon").gameObject
	o.effectParent = o.gameObject.transform:FindChild("Item/Effect").gameObject
	o.item_tp = o.gameObject.transform:FindChild("Item"):GetComponent("TweenPosition")
	o.item_ts = o.gameObject.transform:FindChild("Item"):GetComponent("TweenScale")
	setmetatable(o,self)
	self.__index = self
	return o
end

--显示掉落物品，回到0,0点
function UnitDrop:Show(parent,id,num,pos,delay,time,callback)
	self.callback = callback
	Ext.AddChildToParent(parent,self.gameObject,false)
	self.icon:SetActive(true)
	self.icon:GetComponent("UISprite").spriteName = Res.item[id].icon
	self.icon:GetComponent("UISprite"):MakePixelPerfect()
	
	local renderQueue = GetParentPanelRenderQueue(parent.gameObject)
	if(self.startEffect == nil) then
		self.startEffect = UnitEffectMgr.ShowUIEffectInParent(self.effectParent,24013,Vector3.zero,true,nil)
	end
	self.startEffect:Show(self.effectParent,Vector3.zero,true)
	self.startEffect:UpdateQueue(renderQueue)

	self.gameObject.transform.position = pos
	local onFinish = function ()
		self:OnMoveFinish(renderQueue)
	end
	time = Vector3.Distance(self.gameObject.transform.localPosition,Vector3.zero) / 640
	LH.SetTweenPosition(self.item_tp,0,0.5,Vector3.New(0,-1,0),Vector3.New(0,1,0))
	LH.SetTweenScale(self.item_ts,0,0.5,Vector3.New(0.5,0.5,0.5),Vector3.New(1,1,1))
	LH.SetTweenPositionInDelay(self.tp,self.gameObject.transform.localPosition,Vector3.zero,delay,time,onFinish)
end

function UnitDrop:OnMoveFinish(renderQueue)
	self.icon:SetActive(false)
	if(self.startEffect ~= nil) then
		self.startEffect:Hide()
	end
	if(self.endEffect == nil) then
		self.endEffect = UnitEffectMgr.ShowUIEffectInParent(self.effectParent,23002,Vector3.zero,false,renderQueue)
	end
	local onFinish = function (playFinish,effect )
		self:OnEndEffectFinish(playFinish,effect)
	end
	self.endEffect:Show(self.effectParent,Vector3.zero,true,onFinish)
end

function UnitDrop:OnEndEffectFinish(playFinish,effect)
	if(self.endEffect ~= nil) then
		self.endEffect:Hide()
	end
	if(self.callback ~= nil) then
		local temp = self.callback
		self.callback = nil
		temp(self)
	end
end

function UnitDrop:Dispose()
	if(self.startEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.startEffect)
		self.startEffect = nil
	end
	if(self.endEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.endEffect)
		self.endEffect = nil
	end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end