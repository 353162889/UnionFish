BaseView=Class()

function BaseView:ctor()
	self.gameObject = nil
	self.isOpened = false
	self.isDestory = false
	self.path = ""
	self.ViewName = ""
	self.OpenSound = 0
	self.viewInfo = nil
	self.EventDic = {}
	self.Res = nil
end

function BaseView:ReadResView(ViewName, t)
	for k,v in pairs(Res.view) do
		if v.ViewName == ViewName then
			self.isDestory = v.isDestory
			self.ViewName = v.ViewName
			self.path = v.path
			self.Lv = v.Lv
			self.OpenSound = v.OpenSound
			self.viewInfo = v
			self.t = t
			return true
		end
	end
	return false
end

function BaseView:OpenView()--（UIManager调用）
	if self.isOpened then
		return true
	end
	if self.gameObject == nil then
		local param = {}
		param["self"] = self
		self.onResFinish = function (res)
			self.LoadViewRes(res,param)
			self.onResFinish = nil
		end
		ResourceMgr.GetResourceInLua(self.path,self.onResFinish)
		return false
	else
		UIMgr.LoadViewRes(self)
		return false
	end
end

local InitViewParam = function(res, param)
	param["self"].Res = res
	res:Retain()
	local obj = Resource.GetGameObject(res,param["self"].path)
    param["self"].gameObject = obj
    if(param["self"].viewInfo.isOpenAnim == 1) then
    	local ts = obj:GetComponent("TweenScale")
    	if(ts == nil) then
    		local ts = obj.gameObject:AddComponent(typeof(TweenScale))
    		local curve = ts.animationCurve
    		curve.keys = nil
    		curve:AddKey(0, 0.5)
    		curve:AddKey(0.5, 0)
    		curve:AddKey(1, 1)
    	end
    end
	param["self"].gameObject.name = param["self"].ViewName
    param["self"].gameObject.transform:SetParent(UIMgr.ViewRoot.transform)
    param["self"].gameObject.transform.localScale = Vector3.one
    param["self"].gameObject.transform.localPosition = Vector3.zero
	param["self"]:ConfigUI()
	param["self"]:AddListener()

	UIMgr.LoadViewRes(param["self"])
end

function BaseView.LoadViewRes(res, param)
	InitViewParam(res, param)
end

function BaseView:Close()--（UIManager调用）
	if not self.isOpened then
		return
	end
	if self.gameObject == nil then
		return
	end
	self.isOpened = false
	self:BeforeCloseView()
	self.gameObject:SetActive(false)
	self:RemoveAllEvent()
end

function BaseView:AddEvent(key, action)
	if (self.EventDic[key] == nil and type(action) == "function") then
		self.EventDic[key] = action
	end
end

function BaseView:AddAllEvent()
	for k,v in pairs(self.EventDic) do
		EventMgr.AddEvent(k,v)
	end
end

function BaseView:RemoveEvent(key, action)
	EventMgr.RemoveEvent(key,action)
end

function BaseView:RemoveAllEvent()
	for k,v in pairs(self.EventDic) do
		EventMgr.RemoveEvent(k,v)
	end
end

function BaseView:OnDispose()
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	if(self.onResFinish ~= nil) then
		ResourceMgr.RemoveListenerInLua(self.path,self.onResFinish)
		self.onResFinish = nil
	end
end

function BaseView:ConfigUI()	end
function BaseView:AfterOpenView(t)	end
function BaseView:AddListener()	end
function BaseView:BeforeCloseView()	end
function BaseView:Update()	end
function BaseView:OnDestory()	
end