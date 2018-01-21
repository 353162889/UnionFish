
PasswordFindView=Class(BaseView)

function PasswordFindView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	self.BtnConfirm = Find(self.gameObject,"Content/BtnConfirm")
	self.BtnSendCode = Find(self.gameObject,"Content/BtnSendCode")
	self.InputPhone = Find(self.gameObject,"Content/BtnPhone")
	self.InputPassword = Find(self.gameObject,"Content/InputPassword")
	self.InputCode = Find(self.gameObject,"Content/InputCode")
end

function PasswordFindView:AfterOpenView(t)

end

function PasswordFindView:AddListener()

	local onClose = function (go)
		self:OnClickClose(go)
	end
	LH.AddClickEvent(self.BtnClose,onClose)

	local onConfirm = function (go)
		self:OnClickConfirm(go)
	end
	LH.AddClickEvent(self.BtnConfirm,onConfirm)

	local onSendCode = function (go)
		self:OnClickSendCode(go)
	end
	
end

function PasswordFindView:BeforeCloseView()
end

function PasswordFindView:OnDestory()
end

function PasswordFindView:OnClickClose(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("PasswordFindView")
end

function PasswordFindView:OnClickConfirm(go)
	LH.Play(go,"Play")
	-- body
end

function PasswordFindView:OnClickSendCode(go)
	LH.Play(go,"Play")
	-- body
end

