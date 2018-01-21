
ChangePlayNameView=Class(BaseView)

function ChangePlayNameView:ConfigUI()
	self.InputName = Find(self.gameObject,"InputName"):GetComponent("UIInput")
	self.BtnClose = Find(self.gameObject,"BtnClose")
	local close = function (go)
		UIMgr.CloseView("ChangePlayNameView")
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(self.BtnClose,close)
	self.BtnConfirm = Find(self.gameObject,"BtnConfirm")
	local confirm = function (go)
		self:OnClickConfirm(go)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(self.BtnConfirm,confirm)

	Find(self.gameObject,"LblDesc"):GetComponent("UILabel").text = L("请输入6个字的昵称（只能修改一次）")
	Find(self.gameObject,"BtnConfirm/Label"):GetComponent("UILabel").text = L("确 定",1)
	Find(self.gameObject,"InputName/Label"):GetComponent("UILabel").text = L("请输入昵称")
end

function ChangePlayNameView:AfterOpenView(t)
	self.OnPlayerNameChange = function (msg)
		self:OnNameChange(msg)
	end
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.PlayerNameChange,self.OnPlayerNameChange)
end

function ChangePlayNameView:OnNameChange(msg)
	if(msg.ret == GlobalDefine.RetSucc) then
		UIMgr.CloseView("ChangePlayNameView")
	else
		HelpCtrl.Msg(L("重命名失败"))
	end
end

function ChangePlayNameView:OnClickConfirm(go)
	LogColor("#ff0000","OnClickConfirm")
	local name = self.InputName.value
	if(name == nil or name == "") then
		HelpCtrl.Msg(L("名字不能为空"))
		return
	end
	if(GetStringWordNum(name) > 12) then
		HelpCtrl.Msg(L("名字超过最大长度"))
		return
	end
	PersonalCenterCtrl.C2SAttrSetName(name)
end

function ChangePlayNameView:BeforeCloseView()
	if(self.OnPlayerNameChange ~= nil) then
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.PlayerNameChange,self.OnPlayerNameChange)
		self.OnPlayerNameChange = nil
	end
end

function ChangePlayNameView:OnDestory()

end