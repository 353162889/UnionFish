
UIProgressMode = {
	Horizontal = 1,
	Vertical = 2
}
UIProgress = {}

function UIProgress:New(go,progressMode)
	local o = {gameObject = go}
	o.onProgressChange = {}
	o.sprite = o.gameObject:GetComponent("UISprite")
	o.percent = -1
	o.progressMode = progressMode
	if(o.progressMode == UIProgressMode.Horizontal) then
		o.totalValue = o.sprite.width
	else
		o.totalValue = o.sprite.height
	end
	setmetatable(o,self)
	self.__index = self
	return o
end

function UIProgress:UpdateProgress(percent)
	if(self.sprite == nil) then return end
	if(percent < 0) then 
		percent = 0
	elseif(percent > 1) then
		percent = 1
	end
	if(percent ~= self.percent) then
		self.percent = percent
		self.sprite.gameObject:SetActive(self.percent ~= 0)
		local changeValue = self:GetPercent() * self.totalValue
		if(self.progressMode == UIProgressMode.Horizontal) then
			self.sprite.width = changeValue
		else
			self.sprite.height = changeValue
		end
		self:ChangeProcess(changeValue)
	end
end

function UIProgress:GetPercent()
	return self.percent
end

--添加进度改变事件
function UIProgress:AddProgressChangeFunc(func)
	if(not table.contains(self.onProgressChange,func)) then
		table.insert(self.onProgressChange,func)
	end
end

--移除进度改变事件
function UIProgress:RemoveProgressChangeFunc(func)
	local index = -1
	for i,v in ipairs(self.onProgressChange) do
		if(v == func) then
			index = i
		end
	end
	if(index > 0) then
		table.remove(self.onProgressChange,index)
	end
end

function UIProgress:ChangeProcess(value)
	if(self.onProgressChange ~= nil) then
		for k,v in pairs(self.onProgressChange) do
			if(v ~= nil) then
				v(value)
			end
		end
	end
end

function UIProgress:Dispose()
	self.onProgressChange = nil
	self.gameObject = nil
	self.sprite = nil
end
