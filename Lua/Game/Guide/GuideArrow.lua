
GuideArrow = {}
function GuideArrow:New()
	local o = {}
	o.gameObject = UnityEngine.GameObject("GuideArrow")
	UnityEngine.GameObject.DontDestroyOnLoad(o.gameObject)
	o.transform = o.gameObject.transform
	o.path = "View/GuideArrowCell.prefab"
	o.labelText = nil
	o.angle = nil
	setmetatable(o,self)
	self.__index = self
	return o
end

function GuideArrow:Init()
	self.onLoaded = function (res)
		self:OnResLoaded(res)
		self.onLoaded = nil
	end
	ResourceMgr.GetResourceInLua(self.path,self.onLoaded)
	self:Hide()
end

function GuideArrow:OnResLoaded(res,param)
	self.Res = res
	self.Res:Retain()
	local obj = Resource.GetGameObject(res,self.path)
	Ext.AddChildToParent(self.gameObject,obj,false)
	self.guideArrowTrans = Find(obj,"GuideArrow").transform
	self.descTrans = Find(obj,"Desc").transform
	self.labelDesc = Find(obj,"Desc/Content/Label"):GetComponent("UILabel")
	self.contentGo = Find(obj,"Desc/Content")
	self.contentTrans = self.contentGo.transform
	self:Refresh()
	obj:SetActive(true)
end

function GuideArrow:Refresh()
	if(self.angle ~= nil) then

		if(self.guideArrowTrans ~= nil) then
			self.guideArrowTrans.localEulerAngles = Vector3.New(0,0,self.angle)
		end
		if(self.descTrans ~= nil) then
			self.descTrans.localEulerAngles = Vector3.New(0,0,self.angle)
		end
		if(self.contentTrans ~= nil) then
			self.contentTrans.localEulerAngles = Vector3.New(0,0,-self.angle)
			if(self.labelText == nil or self.labelText == "") then
				self.contentGo:SetActive(false)
			else
				self.contentGo:SetActive(true)
			end
		end
	end
	if(self.labelDesc ~= nil and self.labelText ~= nil) then
		-- self.labelDesc.text = L("{1}",self.labelText)
		LB(self.labelDesc,"{1}",self.labelText)
	end
	if(self.descTrans ~= nil) then
		if(self.descOffset ~= nil) then
			self.descTrans.localPosition = self.descOffset
		else
			self.descTrans.localPosition = Vector3.zero
		end
	end
	
end

function GuideArrow:Show(arrowParentType,pos,isLocal,angle,delay,druation,desc,descOffset)
	if(delay ~= nil and delay > 0) then
		local onFinish = function ()
			self.TimeHandle = nil
			local parent = GuideCtrl.GetArrowParent(arrowParentType)
			if(parent ~= nil) then
				self:ShowPos(parent,pos,isLocal,angle,druation,desc,descOffset)
			 end
		end
		self.TimeHandle = LH.UseVP(delay, 1, 0 ,onFinish,nil)
	else
		local parent = GuideCtrl.GetArrowParent(arrowParentType)
		self:ShowPos(parent,pos,isLocal,angle,druation,desc,descOffset)
	end
end

function GuideArrow:ShowPos(parent,pos,isLocal,angle,druation,desc,descOffset)
	self:Hide()
	Ext.AddChildToParent(parent,self.gameObject,false)
	self.transform.localPosition = pos
	if(not isLocal) then
		Ext.AddChildToParent(UIMgr.Dic("HelpView").GuideBox,self.gameObject,true)
	end
	self.gameObject:SetActive(false)
	self.gameObject:SetActive(true)
	self.angle = angle
	self.labelText = desc
	self.descOffset = descOffset
	self:Refresh()
	local onFinish = function ()
		self.TimeHandle = nil
		self:Hide()
	end
	self.TimeHandle = LH.UseVP(druation, 1, 0 ,onFinish,nil)
end

function GuideArrow:Hide()
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	if(self.gameObject ~= nil) then 
		self.gameObject:SetActive(false)
		self.transform.parent = nil
	end
end

function GuideArrow:Dispose()
	LogColor("#ff0000","GuideArrow:Dispose")
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
	if(self.onLoaded ~= nil) then
		ResourceMgr.RemoveListenerInLua(self.path,self.onLoaded)
		self.path = nil
	end 
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
end