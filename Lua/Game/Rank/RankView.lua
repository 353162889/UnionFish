require 'Game/Rank/RankLeftScrollItem'
require 'Game/Rank/RankRightScrollItem'

RankView=Class(BaseView)

function RankView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	local onClickClose = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("RankView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)
	local leftGo = Find(self.gameObject,"Content/Left")
	self.LeftItem = RankLeftScrollItem:New(leftGo)
	self.LeftItem:Init()
	local rightGo = Find(self.gameObject,"Content/Right")
	self.RightItem = RankRightScrollItem:New(rightGo)
	self.RightItem:Init()
	Find(self.gameObject,"Bgs/BG_2/lbl"):GetComponent("UILabel").text = L("排 行 榜")
end

function RankView:AfterOpenView(t)
	self:InitListener(true)
	self.LeftItem:Update(1)
	RankCtrl.mode.RelocatedType = {}	--清空重定位问题
	RankCtrl.C2SRankGetInfo()
end

function RankView:InitListener(isAdd)
	if(isAdd) then
		self.rankChange = function (listChangedType)
			self:OnRankChange(listChangedType)
		end
		RankCtrl.AddEvent(RankEvent.OnRankChange,self.rankChange)
	else
		if(self.rankChange ~= nil) then
			RankCtrl.RemoveEvent(RankEvent.OnRankChange,self.rankChange)
			self.rankChange = nil
		end
	end
end

function RankView:BeforeCloseView()
	self:InitListener(false)
	self.LeftItem:Update(-1)
end

function RankView:OnRankChange(listChangedType)
	if(self.LeftItem.SelectIndex < 1) then return end
	self.RightItem:OnRankTabChange(self.LeftItem.SelectIndex)
	self.LeftItem:UpdateMyRank()
end

function RankView:OnDestory()
end

