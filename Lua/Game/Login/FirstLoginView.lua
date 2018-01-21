FirstLoginView=Class(BaseView)

function FirstLoginView:ConfigUI()
	self.BtnStartGame = Find(self.gameObject,"BtnStartGame")
end

function FirstLoginView:AfterOpenView(t)
	self.OnLinkLoginSuccess = function ()
		self:OnClickLinkSuccess()
	end
	LinkCtrl.AddEvent(LinkEvent.LinkCtrl_LinkLoginSuccess,self.OnLinkLoginSuccess)
end

function FirstLoginView:AddListener()
	local clickStartGame = function (go)
		self:OnClickStartGame(go)
	end
	LH.AddClickEvent(self.BtnStartGame,clickStartGame)
end

function FirstLoginView:BeforeCloseView()
	LinkCtrl.RemoveEvent(LinkEvent.LinkCtrl_LinkLoginSuccess,self.OnLinkLoginSuccess)
	self.OnLinkLoginSuccess = nil
end

function FirstLoginView:OnDestory()
end

function FirstLoginView:OnClickStartGame(go)
	LH.Play(go,"Play")
	LinkCtrl.ConnectToLoginServer()
end

function FirstLoginView:OnClickLinkSuccess()
	--真正登录
	LoginCtrl.C2SRegister("00000000")
end