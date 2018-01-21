RotationDiscRightItem = {}

function RotationDiscRightItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RotationDiscRightItem:Init()
	self.SpriteLuck = Find(self.gameObject,"Luck/SpriteValue"):GetComponent("UISprite")
	self.LabelLuck = Find(self.gameObject,"Luck/LabelValue"):GetComponent("UILabel")
	self.LabelTime = Find(self.gameObject,"Time/LabelTime"):GetComponent("UILabel")
	self.SpriteTime = Find(self.gameObject,"Time/TimeProgress"):GetComponent("UISprite")
	self.LabelDesc = Find(self.gameObject,"Time/LabelDesc"):GetComponent("UILabel")
	self.LabelBefore = Find(self.gameObject,"Time/LabelBefore"):GetComponent("UILabel")
	self.LabelBefore.text = L("还有")
	self.onLottoryTabChange = function (index)
		self:UpdateIndex(index)
	end
	RotationDiscCtrl.AddEvent(RotationDiscEvent.OnLottoryTabChange,self.onLottoryTabChange)

	self.ListItem = {}
	self.ListLabel = {}
	for i=1,4 do
		local item = Find(self.gameObject,"Cards/Item"..i)
		item:SetActive(true)
		local use = Res.lottery_base[i].use[1]
		Find(item,"Icon"):GetComponent("UISprite").spriteName = Res.item[use[1]].icon
		table.insert(self.ListLabel,Find(item,"Label"):GetComponent("UILabel"))
		table.insert(self.ListItem,item)
	end
end

function RotationDiscRightItem:AfterOpenView()
	self.onTimeRefresh = function ()
		self:OnUpdateTime()
	end
	RotationDiscCtrl.AddEvent(RotationDiscEvent.OnTimeRefresh,self.onTimeRefresh)

	self.onRefreshLuck = function ()
		self:OnRefreshLuck()
	end
	RotationDiscCtrl.AddEvent(RotationDiscEvent.RefreshLuck,self.onRefreshLuck)

	self.onBagUpadte = function ()
		self:UpdateCards()
	end
	EventMgr.AddEvent(ED.BagCtrl_S2CBagUpdate,self.onBagUpadte)
	--[[
	self.onFreeTimeReach = function (lv)
		
	end
	RotationDiscCtrl.AddEvent(RotationDiscEvent.OnFreeTimeReach,self.onFreeTimeReach)
	]]
end

function RotationDiscRightItem:BeforeCloseView()
	if(self.onTimeRefresh ~= nil) then
		RotationDiscCtrl.RemoveEvent(RotationDiscEvent.OnTimeRefresh,self.onTimeRefresh)
		self.onTimeRefresh = nil
	end
	if(self.onRefreshLuck ~= nil) then
		RotationDiscCtrl.RemoveEvent(RotationDiscEvent.RefreshLuck,self.onRefreshLuck)
		self.onRefreshLuck = nil
	end
	if(self.onBagUpadte ~= nil) then
		EventMgr.RemoveEvent(ED.BagCtrl_S2CBagUpdate,self.onBagUpadte)
		self.onBagUpadte = nil
	end
	
	--[[
	if(self.onFreeTimeReach ~= nil) then
		RotationDiscCtrl.RemoveEvent(RotationDiscEvent.OnFreeTimeReach,self.onFreeTimeReach)
		self.onFreeTimeReach = nil
	end
	]]
	self.lottery_data = nil
end

function RotationDiscRightItem:UpdateIndex(index)
	if(index > 0) then
		local lottery_data = RotationDiscCtrl.mode.MapLottery[index]
		self:Update(lottery_data)
	end
end

function RotationDiscRightItem:UpdateCards()
	for k,v in pairs(self.ListLabel) do
		local id = Res.lottery_base[k].use[1][1]
		local item = BagCtrl.GetItem(id)
		local count = 0
		if(item ~= nil) then
			count = item.cnt
		end
		self.ListLabel[k].text = tostring(count)
	end
end

function RotationDiscRightItem:Update(lottery_data)
	self.lottery_data = lottery_data
	if(not RotationDiscCtrl.mode.IsDelayRefreshLuck) then
		self:OnRefreshLuck()
	end
	self:UpdateCards()
	self:UpdateTime(lottery_data.lv,lottery_data.time_left)
end

function RotationDiscRightItem:OnRefreshLuck()
	if(self.lottery_data == nil) then return end
	self.LabelLuck.text = tostring(self.lottery_data.luck_num)
	self.SpriteLuck.fillAmount = self.lottery_data.luck_num * 0.005
end

function RotationDiscRightItem:UpdateTime(lv,time)
	if(time > 0) then
		self.LabelBefore.gameObject:SetActive(true)
		self.LabelTime.gameObject:SetActive(true)
		local str = LH.GetTimeFormat(time)
		self.LabelTime.text = str
		self.LabelDesc.text = L("可获得{1}一次",Res.lottery_base[lv].desc)
	else
		self.LabelBefore.gameObject:SetActive(false)
		self.LabelTime.gameObject:SetActive(false)
		self.LabelDesc.text = L("可免费{1}一次",Res.lottery_base[lv].desc)
	end
	
	local freeTime = Res.lottery_base[lv].free_time * 60
	local fillAmount = (freeTime - time) / freeTime
	fillAmount = math.max(0,fillAmount)
	self.SpriteTime.fillAmount = fillAmount
end

function RotationDiscRightItem:OnUpdateTime()
	if(self.lottery_data ~= nil) then
		self:UpdateTime(self.lottery_data.lv,self.lottery_data.time_left)
	end
end

function RotationDiscRightItem:Dispose()
	if(self.onLottoryTabChange ~= nil) then
		RotationDiscCtrl.AddEvent(RotationDiscEvent.OnLottoryTabChange,self.onLottorTabChange)
		self.onLottoryTabChange = nil
	end
end

