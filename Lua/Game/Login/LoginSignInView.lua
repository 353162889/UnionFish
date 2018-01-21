LoginSignInView=Class(BaseView)

function LoginSignInView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	self.BtnLogin = Find(self.gameObject,"Content/BtnLogin")
	self.ForgetPassword = Find(self.gameObject,"Content/ForgetPassword")
	self.InputCount = Find(self.gameObject,"Content/InputCount")
	self.InputPassword = Find(self.gameObject,"Content/InputPassword")
end

function LoginSignInView:AfterOpenView(t)

end

function LoginSignInView:AddListener()
	local onLogin = function (go)
		self:OnClickLogin(go)
	end
	LH.AddClickEvent(self.BtnLogin,onLogin)

	local onClose = function (go)
		self:OnClickClose(go)
	end
	LH.AddClickEvent(self.BtnClose,onClose)

	local onForget = function (go)
		self:OnClickForget(go)
	end
	LH.AddClickEvent(self.ForgetPassword,onForget)
end

function LoginSignInView:BeforeCloseView()
end

function LoginSignInView:OnDestory()
end

function LoginSignInView:OnClickLogin(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("LoginSignInView")
	LoginCtrl.DeleteLocalInfo()
end

function LoginSignInView:OnClickClose(go)
	LH.Play(go,"Play")
	UIMgr.CloseView("LoginSignInView")
end

function LoginSignInView:OnClickForget(go)
	UIMgr.CloseView("LoginSignInView")
	UIMgr.OpenView("PasswordFindView")
end
