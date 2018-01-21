RandomRateCell = {}

function RandomRateCell:New()
	local o = {}
	o.gameObject = UnityEngine.GameObject("randomRateCell")
	o.path = "View/RandomRateCell.prefab"
	o.labelRate = nil
	setmetatable(o,self)
	self.__index = self
	return o
end

function RandomRateCell:Init(parent,pos,followTarget,offset)
	Ext.AddChildToParent(parent,self.gameObject,false)
	self.gameObject.transform.position = pos
	local helper = self.gameObject:AddComponent(typeof(UIFollowGOHelper))
	helper:SetTargetOffset(followTarget.gameObject,offset)
	
	self.rate = 0
	self.onLoaded = function (res)
		self:OnResLoaded(res)
		self.onLoaded = nil
	end
	ResourceMgr.GetResourceInLua(self.path,self.onLoaded)
end

function RandomRateCell:OnResLoaded(res)
	self.Res = res
	self.Res:Retain()
	local obj = Resource.GetGameObject(res,self.path)
	Ext.AddChildToParent(self.gameObject,obj,false)
	obj.transform.localPosition = Vector3.zero
	obj.transform.localScale = Vector3.one
	obj.transform.localEulerAngles = Vector3.zero
	obj:SetActive(true)
	self.labelRate = obj.transform:Find("Label"):GetComponent("UILabel")
	self.numberHelper = self.labelRate.gameObject:AddComponent(typeof(ChangeNumberHelper))
	self.TS = obj:GetComponent("TweenScale")
	self.TS.enabled = false
	self:UpdateRate(self.rate)
end

function RandomRateCell:UpdateRate(rate)
	local preRate = self.rate
	self.rate = rate
	if(self.labelRate ~= nil)then
		self.labelRate.text = tostring(rate)
	end
	if(self.numberHelper ~= nil) then
		self.numberHelper:SetNumberAtStart(preRate,rate,math.abs(preRate - rate) / 30)
	end
end

function RandomRateCell:ShowAnim()
	if(self.TS ~= nil) then
		self.TS:ResetToBeginning()
		self.TS:PlayForward()
	end
end

function RandomRateCell:Dispose()
	if(self.onLoaded ~= nil) then
	 	ResourceMgr.RemoveListenerInLua(self.path,self.onLoaded)
	 	self.onLoaded = nil
	end
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	 self.gameObject.transform:SetParent(nil)
	 self.onLoaded = nil
	 UnityEngine.GameObject.Destroy(self.gameObject)
end

