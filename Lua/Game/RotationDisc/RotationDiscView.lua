require 'Game/RotationDisc/RotationDiscLeftTabItem'
require 'Game/RotationDisc/RotationDiscRightItem'
require 'Game/RotationDisc/RotationDiscCenterItem'

RotationDiscView=Class(BaseView)

function RotationDiscView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	local onClickClose = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("RotationDiscView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)

	local leftGo = Find(self.gameObject,"Content/Left")
	self.LeftItem = RotationDiscLeftTabItem:New(leftGo)
	self.LeftItem:Init()

	local rightGo = Find(self.gameObject,"Content/Right")
	self.RightItem = RotationDiscRightItem:New(rightGo)
	self.RightItem:Init()

	local centerGo = Find(self.gameObject,"Content/Center")
	self.CenterItem = RotationDiscCenterItem:New(centerGo)
	self.CenterItem:Init()

end

function RotationDiscView:AfterOpenView(t)
	local lottoryType = tonumber(t[1])
	self:InitListener(true)
	self.LeftItem:Update(lottoryType)
	self.RightItem:AfterOpenView()
	self.CenterItem:AfterOpenView()

	--每次打开面板那一次数据,更新用
	RotationDiscCtrl.C2SLotteryGetInfo()
	RotationDiscCtrl.OnViewOpen()
end

function RotationDiscView:InitListener(isAdd)
	if(isAdd) then
		self.getLottoryInfo = function ()
			self:Refresh()
		end
		RotationDiscCtrl.AddEvent(RotationDiscEvent.GetLottoryInfo,self.getLottoryInfo)

		self.refreshView = function ()
			self:Refresh()
		end
		RotationDiscCtrl.AddEvent(RotationDiscEvent.RefreshView,self.refreshView)
	else
		if(self.getLottoryInfo ~= nil) then
			RotationDiscCtrl.RemoveEvent(RotationDiscEvent.GetLottoryInfo,self.getLottoryInfo)
			self.getLottoryInfo = nil
		end
		if(self.refreshView ~= nil) then
			RotationDiscCtrl.RemoveEvent(RotationDiscEvent.RefreshView,self.refreshView)
			self.refreshView = nil
		end

	end
end

function RotationDiscView:BeforeCloseView()
	self:InitListener(false)
	self.LeftItem:Update(-1)
	self.RightItem:BeforeCloseView()
	self.CenterItem:BeforeCloseView()
	RotationDiscCtrl.OnViewClose()
end

function RotationDiscView:Refresh()
	if(self.LeftItem.SelectIndex < 1) then return end
	local index = self.LeftItem.SelectIndex
	self.CenterItem:Update(index)
	self.RightItem:UpdateIndex(index)
end

function RotationDiscView:OnDestory()
	self.LeftItem:Dispose()
	self.RightItem:Dispose()
	self.CenterItem:Dispose()
end

