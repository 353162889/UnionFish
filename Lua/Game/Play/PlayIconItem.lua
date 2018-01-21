PlayIconItem = {}

function PlayIconItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function PlayIconItem:Init()
	self.Content = Find(self.gameObject,"Content")
	self.Tp = self.Content:GetComponent("TweenPosition")
	self.SpriteIcon = Find(self.gameObject,"SpriteIcon")
	self.SpriteIcon.gameObject:SetActive(false)
	self.BgWidget = Find(self.gameObject,"Content/Bgs/Bg1"):GetComponent("UIWidget")

	self.IsShow = false
	self.Content.transform.localPosition = Vector3(-self.BgWidget.width,0,0)

	local OnClickBtn = function (go)
		LH.Play(go,"Play")
		self:OnClickIcon(go.name)
	end
	self.Icon_1 = Find(self.gameObject,"Content/Icons/Icon_1")
	LH.AddClickEvent(self.Icon_1,OnClickBtn)
	self.Icon_2 = Find(self.gameObject,"Content/Icons/Icon_2")
	LH.AddClickEvent(self.Icon_2,OnClickBtn)
	self.Icon_3 = Find(self.gameObject,"Content/Icons/Icon_3")
	LH.AddClickEvent(self.Icon_3,OnClickBtn)

end

function PlayIconItem:GetOnlineBonusBtn()
	return self.Icon_1
end

function PlayIconItem:GetFishDicBtn()
	return self.Icon_3
end

function PlayIconItem:GetTaskBtn()
	return self.Icon_2
end

function PlayIconItem:OnClickIcon(name)
	if(name == "Icon_1") then
		UIMgr.OpenView("OnlineView")
	elseif(name == "Icon_2") then
		TaskCtrl.OpenView(1)
	elseif(name == "Icon_3") then
		UIMgr.OpenView("FishDicView",{MainCtrl.mode.CurIslandId,0})
	end
end

function PlayIconItem:Dispose()
	self.IsShow = false
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
end

function PlayIconItem:Show()
	if(not self.IsShow) then
		self.IsShow = true
		LH.SetTweenPosition(self.Tp,Vector3.New(-self.BgWidget.width,0,0),Vector3.New(0,0,0),0.1,function (go)
			UIMgr.Dic("PlayView"):GetPlayIconBtn():SetActive(false)
			self.SpriteIcon.gameObject:SetActive(true)
		end)
		local OnClose = function ()
			self:Hide()
		end
		self.Close_Handle = LH.UseVP(3, 1, 0 ,OnClose,{})
	end
	self:UpdateInfo()
end

function PlayIconItem:UpdateInfo()
end

function PlayIconItem:Hide()
	if(self.IsShow) then
		self.IsShow = false
		LH.SetTweenPosition(self.Tp,Vector3.New(0,0,0),Vector3.New(-self.BgWidget.width,0,0),0.1,function (go)
			self.SpriteIcon.gameObject:SetActive(false)
			UIMgr.Dic("PlayView"):GetPlayIconBtn():SetActive(true)
		end)
	end
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
end