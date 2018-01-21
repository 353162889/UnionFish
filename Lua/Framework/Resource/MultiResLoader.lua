MultiResLoader = {}

function MultiResLoader:New()
	local o = {}
	o.loadedCount = 0
	o.loadList = {}
	o.onCompleteFunc = nil
	o.onProgressFunc = nil
	o.mapRes = {}
	o.mapTryGetRes = {}
	o.mapResCallback = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function MultiResLoader:LoadResList(names,onComplete,OnProgress)
	if(names == nil or #names == 0) then return end
	for i,v in ipairs(names) do
		if table.contains(self.loadList,v) then
			LogError("Can not has same name in one MultiResLoader")
			return
		else
			table.insert(self.loadList,v)
		end
	end
	self.onCompleteFunc = onComplete
	self.onProgressFunc = OnProgress
	for i,v in ipairs(names) do
		self.mapResCallback[v] = function (res)
			self:OnLoadFinish(res)
		end
		ResourceMgr.GetResourceInLua(v,self.mapResCallback[v])
	end
end

function MultiResLoader:GetResources()
	local result = {}
	for k,v in pairs(self.mapRes) do
		table.insert(result,v)
	end
	return result
end

--尝试去哪资源，当资源加载完后，会调用callback返回资源
function MultiResLoader:TryGetRes(path,callback)
	local res = self.mapRes[path]
	if(res ~= nil) then
		if(callback ~= nil) then
			callback(res)
		end
		return res
	end

	if(callback ~= nil) then
		local listCallback = self.mapTryGetRes[path]
		if(listCallback == nil) then
			listCallback = {}
			table.insert(self.mapTryGetRes,listCallback)
		end
		if(not table.contains(listCallback,callback)) then
			table.insert(listCallback,callback)
		end
	end
	return nil
end

function MultiResLoader:OnLoadFinish(res)
	if(res.isSucc) then
		res:Retain()
		self.mapRes[res.path] = res
	else
		LogError("[MultiResourceLoader] load "..res.path.." fail!")
	end
	self.loadedCount = self.loadedCount + 1
	local list = self.mapTryGetRes[res.path]
	if(list ~= nil) then
		self.mapTryGetRes[res.path] = nil
		for k,v in pairs(list) do
			v(res)
		end
	end
	if(self.onProgressFunc ~= nil) then
		local tempOnProgress = self.onProgressFunc
		tempOnProgress(res)
	end

	if(self.loadedCount == #self.loadList) then
		for key,value in pairs(self.mapTryGetRes) do
			local tempRes = self.mapRes[k]
			if(tempRes ~= nil) then
				for k,v in pairs(value) do
					v(tempRes)
				end
			end
		end
		self.mapTryGetRes = {}
		if(self.onCompleteFunc ~= nil) then
			local tempComplete = self.onCompleteFunc
			self.onCompleteFunc = nil
			tempComplete(self)
		end
		self.onProgressFunc = nil
	end

end

function MultiResLoader:Clear()
	if(self.loadedCount < #self.loadList) then
		for k,v in pairs(self.loadList) do
			ResourceMgr.RemoveListenerInLua(v,self.mapResCallback[v])
		end
	end
	self.mapResCallback = {}
	self.mapTryGetRes = {}
	self.loadedCount = 0
	self.loadList = {}
	for k,v in pairs(self.mapRes) do
		v:Release()
	end
	self.mapRes = {}
	self.onCompleteFunc = nil
	self.onProgressFunc = nil
end




