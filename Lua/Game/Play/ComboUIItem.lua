ComboUIItem = {}

function ComboUIItem:New(go)
	local o = {}
	o.gameObject = go
	o.gameObject.name = "ComBoUIItem"
	o.tp = o.gameObject:GetComponent("TweenPosition")
	o.ta = o.gameObject:GetComponent("TweenAlpha")
	o.ts = o.gameObject:GetComponent("TweenScale")
	o.numBoxLabel = o.gameObject.transform:FindChild("NumBox"):GetComponent("UILabel")
	o.timeHelper = o.gameObject:GetComponent("TimeHelper")
	o.effectParent = o.gameObject.transform:FindChild("Effect").gameObject
	o.renderQueue =  GetParentPanelRenderQueue(o.effectParent)
	setmetatable(o,self)
	self.__index = self
	return o
end

function ComboUIItem:SetEffectActive(active)
	if(self.effectParentActive == nil or self.effectParentActive ~= active) then
		self.effectParentActive = active
		self.effectParent:SetActive(active)
	end
end

function ComboUIItem:SetActive(active)
	if(self.active == nil or self.active ~= active) then
		self.active = active
		self.gameObject:SetActive(active)
	end
end

function ComboUIItem:Dispose()
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end