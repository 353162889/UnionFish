RankLeftScrollItem = {}

function RankLeftScrollItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RankLeftScrollItem:Init()
	self.Template = Find(self.gameObject,"ScrollView/Grid/Template")
	self.Template:SetActive(false)
	self.SelectIndex = -1
	self.ListItem = {}
	local listRank = SortRes.Rank
	for i=1,#listRank do
		local item = LH.GetGoBy(self.Template,self.Template.transform.parent.gameObject)
		item:SetActive(true)
		local onClick = function (go)
			LogColor("#f0000","onClick",i)
			self:Update(i)
		end
		LH.AddClickEvent(Find(item,"UnSelect"),onClick)
		self:SetItem(item,listRank[i])
		table.insert(self.ListItem,item)
	end
	self.ScrollView = Find(self.gameObject,"ScrollView"):GetComponent("UIScrollView")
	self.Grid = Find(self.gameObject,"ScrollView/Grid"):GetComponent("UIGrid")

	self.LabelMyRank = Find(self.gameObject,"LabelMyRank"):GetComponent("UILabel")

end

function RankLeftScrollItem:SetItem(item,cfg)
	local selectIcon = Find(item,"Select/Icon"):GetComponent("UISprite")
	local selectName = Find(item,"Select/Label"):GetComponent("UILabel")
	local unSelectIcon = Find(item,"UnSelect/Icon"):GetComponent("UISprite")
	local unSelectName = Find(item,"UnSelect/Label"):GetComponent("UILabel")
	selectIcon.spriteName = "rank_type_select_"..cfg.type
	selectIcon:MakePixelPerfect()
	LB(selectName,"{1}",cfg.name)
	unSelectIcon.spriteName = "rank_type_"..cfg.type
	unSelectIcon:MakePixelPerfect()
	LB(unSelectName,"{1}",cfg.name)
end

function RankLeftScrollItem:SetItemSelect(item,select)
	local selectGO = Find(item,"Select")
	local unSelectGO = Find(item,"UnSelect")
	selectGO:SetActive(select)
	unSelectGO:SetActive(not select)
end

function RankLeftScrollItem:Update(SelectIndex)
	if(self.SelectIndex ~= SelectIndex) then
		self.SelectIndex = SelectIndex
		for i=1,#self.ListItem do
			self:SetItemSelect(self.ListItem[i],SelectIndex == i)
		end
		if(self.SelectIndex > 0) then
			RankCtrl.SendEvent(RankEvent.OnRankTabChange,self.SelectIndex)
		end
		self.Grid:Reposition()
   		self.ScrollView:ResetPosition()
	end
	self:UpdateMyRank()
end

function RankLeftScrollItem:UpdateMyRank()
	local info = RankCtrl.mode.MapRank[self.SelectIndex]
	if(info == nil) then
		LB(self.LabelMyRank,"我的排名：未上榜")
	else
		local num = Res.rank[self.SelectIndex].num
		if(info.own > num) then
			LB(self.LabelMyRank,"我的排名：未上榜")
		else
			LB(self.LabelMyRank,"我的排名：{1}",info.own)
		end
	end
end

