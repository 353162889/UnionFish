require 'Game/Rank/RankUserInfoItem'
RankRightScrollItem = {}

function RankRightScrollItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RankRightScrollItem:Init()
	self.Templates = Find(self.gameObject,"ScrollView/Grid/Templates")
	self.Panel = Find(self.gameObject,"ScrollView"):GetComponent("UIPanel")
	self.ScrollView = Find(self.gameObject,"ScrollView"):GetComponent("UIScrollView")
	self.Grid = Find(self.gameObject,"ScrollView/Grid"):GetComponent("UIGrid")
	local count = self.Templates.transform.childCount
	self.DicTemp = {}
	for i=1,count do
		local child = self.Templates.transform:GetChild(i - 1)
		child.gameObject:SetActive(false)
		local tempId = tonumber(child.name)
		self.DicTemp[tempId] = child.gameObject
	end

	self.ListSpecialItem = {}
	self.ListItem = {}

	self.rankTableChange = function (index)
		self:OnRankTabChange(index)
	end
	RankCtrl.AddEvent(RankEvent.OnRankTabChange,self.rankTableChange)
end

function RankRightScrollItem:Update(rank_list)
	if(rank_list == nil) then
		for i=1,#self.ListSpecialItem do
			self.ListSpecialItem[i]:SetActive(false)
		end
		for i=1,#self.ListItem do
			self.ListItem[i]:SetActive(false)
		end
		return
	end
	local rankType = rank_list.type
	local ownRank = rank_list.own
	local norTempId = SortRes.DicRank[rankType].templateId
	local specialTempId = SortRes.DicRank[rankType].specialTemplateId
	local norTemp = self.DicTemp[norTempId]
	local specialTemp = self.DicTemp[specialTempId]
	local selfUserInfoItem = nil
	local count = 0
	for i,v in ipairs(rank_list.rank) do
		count = count + 1
		local userInfoItem = nil
		if(v.rank < 4) then
			userInfoItem = self:GetUserInfoItemInList(self.ListSpecialItem,i,specialTemp)
		else
			userInfoItem = self:GetUserInfoItemInList(self.ListItem,i - 3,norTemp)
		end
		userInfoItem:SetActive(true)
		userInfoItem:Update(rankType,ownRank,v)
		if(ownRank == v.rank) then
			selfUserInfoItem = userInfoItem
		end
	end

	if(count < #self.ListSpecialItem) then
		for i=count + 1,#self.ListSpecialItem do
			self.ListSpecialItem[i]:SetActive(false)
		end
	end
	local start = count - 3
	if(start < 0) then start = 0 end
	for i=start + 1,#self.ListItem do
		self.ListItem[i]:SetActive(false)
	end
	
	self.Grid:Reposition()
   	self.ScrollView:ResetPosition()
	if(not table.contains(RankCtrl.mode.RelocatedType,rankType) and selfUserInfoItem ~= nil) then
		--self.Panel.transform.localPosition = Vector3.New(-self.Panel.clipOffset.x,-selfUserInfoItem.gameObject.transform.localPosition.y)
		--self.Panel.clipOffset = Vector2.New(self.Panel.clipOffset.x,selfUserInfoItem.gameObject.transform.localPosition.y)
		--self.ScrollView:RestrictWithinBounds(false)
		LH.RestrictWithinView(self.ScrollView,self.Grid.transform,selfUserInfoItem.gameObject.transform,false,Vector3.New(0,self.Grid.transform.localPosition.y,0))
		table.insert(RankCtrl.mode.RelocatedType,rankType)
   	end
end

function RankRightScrollItem:GetUserInfoItemInList(listItem,index,temp)
	if(index <= #listItem) then
		return listItem[index]
	else
		local item = self:GetUserInfoItem(temp)
		table.insert(listItem,item)
		return item
	end
end

function RankRightScrollItem:GetUserInfoItem(temp)
	local item = LH.GetGoBy(temp,self.Templates.transform.parent.gameObject)
	local userInfoItem = RankUserInfoItem:New(item)
	userInfoItem:Init()
	return userInfoItem
end

function RankRightScrollItem:OnRankTabChange(index)
	local curType = Res.rank[index].type
	local rank_list = RankCtrl.mode.MapRank[curType]
	self:Update(rank_list)
end

function RankRightScrollItem:Dispose()
	if(self.rankTableChange ~= nil) then
		RankCtrl.RemoveEvent(RankEvent.OnRankTabChange,self.rankTableChange)
		self.rankTableChange = nil
	end
end