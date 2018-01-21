UIModel = {}

function UIModel:New()
	local o = {}
	o.gameObject = UnityEngine.GameObject("model")
	setmetatable(o,self)
	self.__index = self
	return self
end

--更新一个UI模型，path是模型的位置,parent是模型的挂载点，渲染层次将用里挂载点最近的父节点的panel的startingRenderQueue
function UIModel:UpdateModel(path,parent,offsetQueue,defaultAnim)
	local panel = self:GetParentPanel(parent)
	if(panel == nil) then
		LogError("UIModel的上级parent必须要有一个UIPanel")
		return
	end
	if(self.path ~= nil) then
		self:Clear()
	end
	self.panel = panel
	self.gameObject.transform:SetParent(parent.transform,false)
	self.queue = panel.startingRenderQueue + offsetQueue
	self.path = path
	self.onResLoaded = function (res)
		self:OnResLoadedFinish(res)
	end
	self.animName = defaultAnim
	ResourceMgr.GetResourceInLua(path,self.onResLoaded)
end

function UIModel:GetParentPanel(go)
	local panel = go:GetComponent("UIPanel")
	if(panel == nil) then
		if(go.transform.parent ~= nil) then
			return self:GetParentPanel(go.transform.parent.gameObject)
		end
		return nil
	else
		return panel
	end
end

function UIModel:Show()
	self.gameObject:SetActive(true)
end

function UIModel:Hide()
	self.gameObject:SetActive(false)
end

function UIModel:PlayAnim(animName)
	self.animName = animName
	if(self.animator ~= nil and self.animName ~= nil) then
		self.animator:Play(tostring(self.animName))
	end
end

function UIModel:SetPos(x,y,z)
	self.gameObject.transform.localPosition = Vector3.New(x,y,z)
end

function UIModel:SetAngle(x,y,z)
	self.gameObject.transform.localEulerAngles = Vector3.New(x,y,z)
end

function UIModel:SetScale(x,y,z)
	self.gameObject.transform.localScale = Vector3.New(x,y,z)
end

function UIModel:UpdateTransform(p,a,s)
	self.gameObject.transform.localPosition = p
	self.gameObject.transform.localEulerAngles = a
	self.gameObject.transform.localScale = s
end

function UIModel:OnResLoadedFinish(res)
	if(res.isSucc) then
		self.res = res
		self.res:Retain()
		self.obj = Resource.GetGameObject(self.res,self.path)
		self.obj.transform:SetParent(self.gameObject.transform,false)
		if(self.queue ~= nil) then
			self:UpdateQueue(self.queue)
		end
		self.animator = self.obj:GetComponent("Animator")
		self:PlayAnim(self.animName)
	end
end

function UIModel:UpdateQueue(offsetQueue)
	if(self.panel ~= nil) then
		self.queue = self.panel.startingRenderQueue + offsetQueue
		self:UpdateRenderQueue(self.gameObject,self.queue)
	else
		LogError("can not find UIPanel")
	end
end

function UIModel:UpdateRenderQueue(go,queue)
	local render = go:GetComponent("Renderer")
	if(render ~= nil and render.material ~= nil) then
		render.material.renderQueue = queue
	end
	local count = go.transform.childCount
    for i=1,count do 
        self:UpdateRenderQueue(go.transform:GetChild(i-1).gameObject,queue)
    end
end

function UIModel:Clear()
	if(self.path ~= nil and self.onResLoaded ~= nil) then
		ResourceMgr.RemoveListenerInLua(self.path,self.onResLoaded)
		self.path = nil
		self.onResLoaded = nil
	end
	self.path = nil
	self.onResLoaded = nil
	if(self.res ~= nil) then
		self.res:Release()
		self.res = nil		
	end
	self.queue = nil

	self.animName = nil

	if(self.obj ~= nil) then
		self.obj.transform.parent = nil
		UnityEngine.GameObject.Destroy(self.obj)
		self.obj = nil
	end

	self.panel = nil
end

function UIModel:Dispose()
	self:Clear()
	if(self.gameObject ~= nil) then
		UnityEngine.GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end