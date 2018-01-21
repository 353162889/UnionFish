
UnitEffect = {}
function UnitEffect:New()
	local o = {}
	o.gameObject = UnityEngine.GameObject("effect")
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitEffect:Init(effectId,container)
	self.gameObject.name = "effect_"..effectId
	self.obj_id = self.gameObject:GetInstanceID()
	self.id = effectId
	self.queue = nil
	self.effectInfo = Res.effect[tonumber(effectId)]
	self.container = container
	self:Reset()
	self.onLoaded = function (res)
		self:OnResLoaded(res)
		self.onLoaded = nil
	end
	ResourceMgr.GetResourceInLua(self.effectInfo.path,self.onLoaded)
end

function UnitEffect:OnResLoaded(res)
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	self.Res = res
	self.Res:Retain()
	local obj = Resource.GetGameObject(res,self.effectInfo.path)
	Ext.AddChildToParent(self.gameObject,obj,false)
	obj.transform.localPosition = Vector3.zero
	obj.transform.localScale = Vector3.one
	obj.transform.localEulerAngles = Vector3.zero
	obj:SetActive(true)
	if(self.queue ~= nil) then
		self:UpdateQueue(self.queue)
	end
	if(self.effectInfo.use_queue == 0) then
		LH.SetSortingOrder(self.gameObject,self.effectInfo.order_offset)
	end
	if(self.layer ~= nil) then
		self:UpdateLayer(self.layer)
	end
	self:UpdateSortingLayer()
end

--显示特效，如果当前特效有延时销毁，那么会延时一定的时间回调endCallback,如果没有延时销毁，立即调用endCallback,
--isLocalPos表示传入的是局部坐标还是世界坐标，如果有将空间坐标转换为世界坐标的操作，应该传true
function UnitEffect:Show(parent,pos,isLocalPos,endCallback)
	self:Hide()
	Ext.AddChildToParent(parent,self.gameObject,false)
	if(isLocalPos) then
		self.gameObject.transform.localPosition = pos
	else
		self.gameObject.transform.position = pos
	end
	if(self.queue ~= nil) then
		self:UpdateQueue(self.queue)
	end
	if(self.layer ~= nil) then
		self:UpdateLayer(self.layer)
	end
	self.gameObject:SetActive(true)
	self.endCallback = endCallback
	if(self.effectInfo.cd > 0) then
		local OnPlayFinish = function (lt)
			self:OnEffectFinish(true)
		end
		self.timer = LH.UseVP(self.effectInfo.cd, 1, 0 ,OnPlayFinish,{})
	else
		self:OnEffectFinish(false)
	end
end

function UnitEffect:ShowByTime(parent,pos,time,delay,endCallback)
	self:Hide()
	Ext.AddChildToParent(parent,self.gameObject,false)
	self.gameObject.transform.position = pos
	if(self.queue ~= nil) then
		self:UpdateQueue(self.queue)
	end
	if(self.layer ~= nil) then
		self:UpdateLayer(self.layer)
	end
	self.endCallback  = endCallback
	if(delay > 0) then
		local onDelay = function (lt)
			self:OnDelay()
		end
		self.delayTimer = LH.UseVP(delay, 1, 0 ,onDelay,{})
	else
		self.gameObject:SetActive(true)
	end
	if(time + delay > 0) then
		local OnPlayFinish = function (lt)
			self:OnEffectFinish(true)
		end
		self.timer = LH.UseVP(time + delay, 1, 0 ,OnPlayFinish,{})
	else
		self:OnEffectFinish(false)
	end
end

function UnitEffect:OnDelay()
	self.gameObject:SetActive(true)
end

function UnitEffect:OnEffectFinish(playFinish)
	if(self.endCallback ~= nil) then
		local callback = self.endCallback
		self.endCallback = nil
		callback(playFinish,self)
	end
	self.timer = nil
	self.delayTimer = nil
end

function UnitEffect:Hide()
	self.gameObject:SetActive(false)
	if(self.timer ~= nil) then
		self.timer:Cancel()
		self.timer =nil
	end
	if(self.delayTimer ~= nil) then
		self.delayTimer:Cancel()
		self.delayTimer =nil
	end
end

function UnitEffect:Reset()
	self.gameObject.transform:SetParent(self.container.transform)
	self.gameObject.transform.localPosition = Vector3.zero
	self.gameObject.transform.localEulerAngles = Vector3.zero
	self.gameObject.transform.localScale = Vector3.one
	self:Hide()
end

function UnitEffect:Dispose()
	if(self.gameObject == nil) then
		LogError("effect has released!id=",self.id)
		return
	end
	if(self.onLoaded ~= nil) then
	 	ResourceMgr.RemoveListenerInLua(self.effectInfo.path,self.onLoaded)
		 self.onLoaded = nil
	end
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	 self.gameObject.transform:SetParent(nil)
	 self.onLoaded = nil
	 self:Reset()
	 self.obj_id = -1
	 self.id = -1
	 UnityEngine.GameObject.Destroy(self.gameObject)
	 self.gameObject = nil
end

function UnitEffect:UpdateQueue(queue)
	self.queue = queue
	if(self.effectInfo.use_queue == 1) then
		self:UpdateRenderQueue(self.gameObject,self.queue)
	end
end

function UnitEffect:UpdateLayer(layer)
	self.layer = layer
	LH.SetLayer(self.gameObject,layer)
end

function UnitEffect:UpdateSortingLayer()
	LH.SetSortingLayer(self.gameObject,self.effectInfo.soringLayer)
end

function UnitEffect:UpdateRenderQueue(go,queue)
	local render = go:GetComponent("Renderer")
	if(render ~= nil and render.material ~= nil) then
		render.material.renderQueue = queue
	end
	local count = go.transform.childCount
    for i=1,count do 
        self:UpdateRenderQueue(go.transform:GetChild(i-1).gameObject,queue)
    end
end

