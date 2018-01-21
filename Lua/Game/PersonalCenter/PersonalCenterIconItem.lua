PersonalCenterIconItem = {}

function PersonalCenterIconItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function PersonalCenterIconItem:Init(id)
	self.id = id
	local onClickSelect = function (go)
		--UIMgr.CloseView("ChangeHeadIconView")
		--PersonalCenterCtrl.SendEvent(PersonalCenterEvent.PlayerIconChange,id)
		--发送更改头像协议
		PersonalCenterCtrl.C2SAttrSetHeadId(id)
	end
	LH.AddClickEvent(self.gameObject,onClickSelect)

	self.SpriteIcon = Find(self.gameObject,"Pic"):GetComponent("UISprite")
	self.SpriteIcon.spriteName = "HeadIcon_"..id
	self.Select = Find(self.gameObject,"Select")
end

function PersonalCenterIconItem:UpdateInfo(isSelect)
	self.Select.gameObject:SetActive(isSelect)
end
