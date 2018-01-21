require 'Game/PersonalCenter/PersonalCenterIconItem'
ChangeHeadIconView=Class(BaseView)

function ChangeHeadIconView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"BtnClose")
	local onClickClose = function (go)
		UIMgr.CloseView("ChangeHeadIconView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)

	self.scrollView = Find(self.gameObject,"ScrollView"):GetComponent("UIScrollView")
	self.grid = Find(self.gameObject,"ScrollView/Grid"):GetComponent("UIGrid")
	self.item = Find(self.gameObject,"ScrollView/Grid/IconItem")
	self.item:SetActive(false)

	self.itemList = {}

	local maxID = tonumber(Res.misc[1].HeadIconMaxID)

	for i=1,maxID do
		local temp = LH.GetGoBy(self.item,self.item.transform.parent.gameObject)
		temp:SetActive(true)
		temp.gameObject.name = (i)
		local item = PersonalCenterIconItem:New(temp)
		item:Init(i)
		table.insert(self.itemList,item)
	end
end

function ChangeHeadIconView:AfterOpenView(t)
	self.curSelectId = t
	self:UpdateInfo()
	self.OnCloseSelf = function (msg)
		if(msg.ret == GlobalDefine.RetSucc) then
			UIMgr.CloseView("ChangeHeadIconView")
		end
	end
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.PlayerIconChange,self.OnCloseSelf)
end

function ChangeHeadIconView:UpdateInfo()
	for k,v in pairs(self.itemList) do
		local isSelect = (v.id == self.curSelectId)
		v:UpdateInfo(isSelect)
	end
	self.grid:Reposition()
    self.scrollView:ResetPosition()
end

function ChangeHeadIconView:BeforeCloseView()
	if(self.OnCloseSelf ~= nil) then
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.PlayerIconChange,self.OnCloseSelf)
		self.OnCloseSelf = nil
	end
end

function ChangeHeadIconView:OnDestory()
	self.itemList = nil
	this.scrollView = nil
	this.grid = nil
	this.item = nil
end