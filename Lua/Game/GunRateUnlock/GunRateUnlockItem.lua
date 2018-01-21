GunRateUnlockItem = {}
function GunRateUnlockItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function GunRateUnlockItem:Init()
	local go = self.gameObject
	
	self.content = Find(go,"Content")

	self.LabelCost = Find(self.content,"Cost/LabelNum"):GetComponent("UILabel")

	self.ItemGrid = Find(self.content,"Items"):GetComponent("UIGrid")
	self.Item_1 = ItemCell.Create(Find(self.content,"Items/Item_1"))
	self.Item_2 = ItemCell.Create(Find(self.content,"Items/Item_2"))

	self.LabelRate = Find(self.content,"Gun/LabelRate"):GetComponent("UILabel")
	self.GOLock = Find(go,"GOLock")
	self.isFirst = false
	self.Mask = Find(self.content,"Mask")

	Find(self.content,"Cost/Label"):GetComponent("UILabel").text = L("需要")
end

function GunRateUnlockItem:Update(cfg,isFirst)
	self.cfg = cfg
	self.isFirst = isFirst
	local hasUnlockIsland = cfg.unlockIsland > 0
	self.Item_2.Item.transform.parent.gameObject:SetActive(hasUnlockIsland)
	
	self.Item_1.SetValue({id = GlobalDefine.Gold,cnt = cfg.give})
	self.Item_1.Item.transform:FindChild("RightTop").gameObject:SetActive(true)
	self.Item_2.Item.transform:FindChild("RightTop"):GetComponent("UISprite").spriteName = "rt_2"

	if(hasUnlockIsland) then
		self.Item_2.SetValue({id = cfg.unlockIsland,cnt = 1})
		self.Item_2.Item.transform:FindChild("RightTop").gameObject:SetActive(true)
		self.Item_2.Item.transform:FindChild("RightTop"):GetComponent("UISprite").spriteName = "rt_1"
		self.Item_2.Item.transform:FindChild("lbl").gameObject:SetActive(false)
	end

	local cfgCnt = 0
	if(#cfg.use_item == 0) then 
		cfgCnt = 0
	else
		cfgCnt = tonumber(self.cfg.use_item[2])
	end
	self.LabelCost.text = L("x{1}",cfgCnt)
	self.LabelRate.text = L("x{1}倍",cfg.rate)	
	self.GOLock:SetActive(not isFirst)
	self.Mask:SetActive(not isFirst)
	if(isFirst) then
		self.content.transform.localScale = Vector3.New(1,1,1)
	else
		self.content.transform.localScale = Vector3.New(0.8,0.8,0.8)
	end
	local gunID = LoginCtrl.mode.S2CEnterGame.battery_id

	-- local item1_value = {{GlobalDefine.Gold,cfg.give}}
	-- if(cfg.unlockIsland > 0) then
	-- 	table.insert(item1_value,{cfg.unlockIsland,1})
	-- end
	
	self.ItemGrid:Reposition()
end

function GunRateUnlockItem:Hide()
end

function GunRateUnlockItem:Dispose()
	if(self.gameObject ~= nil) then
		UnityEngine.GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end