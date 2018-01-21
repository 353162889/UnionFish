UnitIsland = {}

function UnitIsland:New(isLandId,gameObject)
	local o = {id = isLandId,go = gameObject}
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitIsland:Init()
	local modelPlay = self.go.transform:Find("Model_Play")
	local childCount = modelPlay.transform.childCount
	local anims = {}
	for i=1,childCount do
		local child = modelPlay.transform:GetChild(i - 1)
		local anim = child:GetComponent("Animator")
		if(anim ~= nil) then
			table.insert(anims,anim) 
		end
	end
	self.selectAnims = anims
	self.selectEffect = self.go.transform:Find("Effect_Select")
	self.lockEffect = self.go.transform:Find("Effect_Lock")
	self.boxCollider = self.go.transform:Find("BoxCollider")
	self.isSelect = false
	self.isOpen = false
	self.selectEffect.gameObject:SetActive(false)
	for k,anim in pairs(self.selectAnims) do
		anim:Play("Normal")
	end
	self:Refresh()
end

function UnitIsland:Dispose()
	self.id = -1
	self.selectAnims = nil
	self.selectEffect = nil
	self.lockEffect = nil
	self.isSelect = false
	self.isOpen = false
	if(self.go ~= nil) then
		UnityEngine.GameObject.Destroy(self.go)
		self.go = nil
	end
end

function UnitIsland:UpdateSelect(isSelect)
	if(isSelect) then
		for k,anim in pairs(self.selectAnims) do
			anim:Play("Select")
		end
	else
		for k,anim in pairs(self.selectAnims) do
			anim:Play("Normal")
		end
	end
	
	self.selectEffect.gameObject:SetActive(isSelect)
	self.isSelect = isSelect
end

function UnitIsland:Refresh()
	-- local islandData = Res.island[self.id]
	-- local isOpen = true
	-- if(#islandData.OpenType > 0) then
	-- 	local count = #islandData.OpenType
	-- 	for i=1,count do
	-- 		local cond = islandData.OpenType[i]
	-- 		local openCondInt = tonumber(cond[1])
	-- 		local openValue = tonumber(cond[2])
	-- 		if openCondInt == 1 then
	-- 			isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.level >= openValue)
	-- 		elseif openCondInt == 2 then
	-- 			isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.gold >= openValue)
	-- 		elseif openCondInt == 3 then
	-- 			isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.battery_rate >= openValue)
	-- 		end
	-- 	end
	-- end
	local isOpen = MainCtrl.IsIslandOpen(self.id)
	self.isOpen = isOpen
	self.lockEffect.gameObject:SetActive(not self.isOpen)
	if(self.boxCollider ~= nil) then
		--self.boxCollider.gameObject:SetActive(self.isOpen)
	end
end


