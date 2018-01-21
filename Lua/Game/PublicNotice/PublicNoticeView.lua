
PublicNoticeView=Class(BaseView)

function PublicNoticeView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	self.BtnConfirm = Find(self.gameObject,"Content/BtnConfirm")
	self.BtnReturn = Find(self.gameObject,"Content/BtnReturn")
	self.BtnCancel = Find(self.gameObject,"Content/BtnCancel")
	self.LabelTitle = Find(self.gameObject,"Content/LabelTitle")
end

function PublicNoticeView:AfterOpenView(t)

end

function PublicNoticeView:AddListener()
	local onConfirm = function (go)
		self:OnClickConfirm(go)
	end
	LH.AddClickEvent(self.BtnConfirm,onConfirm)

	local onClose = function (go)
		self:OnClickClose(go)
	end
	LH.AddClickEvent(self.BtnClose,onClose)

	local onReturn = function (go)
		self:OnClickReturn(go)
	end
	LH.AddClickEvent(self.BtnReturn,onReturn)

	local onCancel = function (go)
		self:OnClickCancel(go)
	end
end

function PublicNoticeView:BeforeCloseView()
end

function PublicNoticeView:OnDestory()
end

function PublicNoticeView:OnClickConfirm(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("PublicNoticeView")
end

function PublicNoticeView:OnClickReturn(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("PublicNoticeView")
end

function PublicNoticeView:OnClickClose(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("PublicNoticeView")
end

function PublicNoticeView:OnClickCancel(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("PublicNoticeView")
end

