LoginView=Class(BaseView)

function LoginView:ConfigUI()
	self.BtnStartGame = Find(self.gameObject,"BtnStartGame")
	local clickStartGame = function (go)
		self:OnClickStartGame(go)
	end
	LH.AddClickEvent(self.BtnStartGame,clickStartGame)
	self.LabelStartGame = Find(self.BtnStartGame,"Label"):GetComponent("UILabel")
	self.LabelStartGame.text = L("开始游戏")

	self.BtnClearAccount = Find(self.gameObject,"BtnClearAccount")
	local clickClearAccount = function (go)
		HelpCtrl.Msg("删除账号缓存成功")
		LoginCtrl.DeleteLocalInfo()
	end
	LH.AddClickEvent(self.BtnClearAccount,clickClearAccount)
	if(LH.IsDebugMode()) then
		self.BtnClearAccount:SetActive(true)
	else
		self.BtnClearAccount:SetActive(false)
	end
end

function LoginView:AfterOpenView(t)
	LoginCtrl.CheckAndSDKLogin()
end


function LoginView:BeforeCloseView()
end

function LoginView:OnDestory()
end


function LoginView:OnClickStartGame(go)
	LH.Play(go,"Play")
	LoginCtrl.Login()
end

