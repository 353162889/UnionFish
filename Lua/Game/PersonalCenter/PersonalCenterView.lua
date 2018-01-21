PersonalCenterView=Class(BaseView)

function PersonalCenterView:ConfigUI()
	self.Content = Find(self.gameObject,"Content")
	self.BtnClose = Find(self.Content,"BtnClose")
	local closeView = function (go)
		UIMgr.CloseView("PersonalCenterView")
	end
	LH.AddClickEvent(self.BtnClose,closeView)

	self.LabelTitle = Find(self.Content,"LabelTitle"):GetComponent("UILabel")

	self.SpriteHead = Find(self.Content,"SpriteHead/Pic"):GetComponent("UISprite")
	self.BtnChangeHeadIcon = Find(self.Content,"BtnChangeHeadIcon")
	local changeIcon = function (go)
		UIMgr.OpenView("ChangeHeadIconView",self.roleInfo.head_id)
	end
	LH.AddClickEvent(self.BtnChangeHeadIcon,changeIcon)
	Find(self.BtnChangeHeadIcon,"Label"):GetComponent("UILabel").text = L("更换头像")

	self.LabelName = Find(self.Content,"LabelName"):GetComponent("UILabel")
	self.BtnChangeName = Find(self.Content,"BtnChangeName")
	local changeName = function (go)
		UIMgr.OpenView("ChangePlayNameView")
	end
	LH.AddClickEvent(self.BtnChangeName,changeName)

	self.LabelID = Find(self.Content,"LabelID"):GetComponent("UILabel")
	self.LabelSex = Find(self.Content,"LabelSex"):GetComponent("UILabel")
	self.ToggleSex = Find(self.Content,"ToggleSex")
	self.TogMale = Find(self.ToggleSex,"Male"):GetComponent("UIToggle")
	self.TogFemale = Find(self.ToggleSex,"Female"):GetComponent("UIToggle")
	Find(self.TogMale.gameObject,"Label"):GetComponent("UILabel").text = L("男")
	Find(self.TogFemale.gameObject,"Label"):GetComponent("UILabel").text = L("女")

	self.LabelLv = Find(self.Content,"LabelLv"):GetComponent("UILabel")
	self.ExpProgress = Find(self.Content,"ExpProgress"):GetComponent("UISprite")
	self.LabelVIPLv = Find(self.Content,"LabelVIPLv"):GetComponent("UILabel")
	self.BtnVIPLv = Find(self.Content,"BtnVIPLv")
	local findVIPLv = function (go)
		HelpCtrl.Msg(L("功能尚未开启！"))
	end
	LH.AddClickEvent(self.BtnVIPLv,findVIPLv)

	self.LabelGold = Find(self.Content,"LabelGold"):GetComponent("UILabel")

	self.BtnGold = Find(self.Content,"BtnGold")
	local getGold = function (go)
		UIMgr.OpenView("ShopView",1)
	end
	LH.AddClickEvent(self.BtnGold,getGold)

	self.LabelDiamond = Find(self.Content,"LabelDiamond"):GetComponent("UILabel")
	self.BtnDiamond = Find(self.Content,"BtnDiamond")
	local getDiamond = function (go)
		UIMgr.OpenView("ShopView",3)
	end
	LH.AddClickEvent(self.BtnDiamond,getDiamond)
	
	self.BtnChange = Find(self.Content,"BtnChange")
	local changeSetting = function (go)
		self:OnClickChangeSetting(go)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(self.BtnChange,changeSetting)

	self.LabelGunLv = Find(self.Content,"LabelGunLv"):GetComponent("UILabel")
	self.LabelGunRate = Find(self.Content,"LabelGunRate"):GetComponent("UILabel")
	self.LabelGunName = Find(self.Content,"LabelGunName"):GetComponent("UILabel")

	self.GunTex = Find(self.Content,"GunModel/Tex"):GetComponent("UITexture")
	self.GunModel = UIModelMgr.CreateModel(self.GunTex,false,60,false)

	self.BtnAddFriend = Find(self.Content,"BtnAddFriend")
	local addFriend = function (go)
		LH.Play(go,"Play")
		HelpCtrl.Msg(L("功能尚未开启！"))
	end
	LH.AddClickEvent(self.BtnAddFriend,addFriend)

	self.BtnSendMsg = Find(self.Content,"BtnSendMsg")
	local sendMsg = function (go)
		LH.Play(go,"Play")
		HelpCtrl.Msg(L("功能尚未开启！"))
	end
	LH.AddClickEvent(self.BtnSendMsg,sendMsg)


	LB(Find(self.gameObject,"Content/Static/LblLevel"):GetComponent("UILabel"),"等        级：")
	LB(Find(self.gameObject,"Content/Static/LblVIPLevel"):GetComponent("UILabel"),"VIP 等 级：")
	LB(Find(self.gameObject,"Content/Static/LblGold"):GetComponent("UILabel"),"金        币：")
	LB(Find(self.gameObject,"Content/Static/LblDiamond"):GetComponent("UILabel"),"钻        石：")
	LB(Find(self.gameObject,"Content/Item_1/Label"):GetComponent("UILabel"),"财富榜：{1}",L("未上榜"))
	LB(Find(self.gameObject,"Content/Item_2/Label"):GetComponent("UILabel"),"荣誉榜：{1}",L("未上榜"))
	LB(Find(self.gameObject,"Content/Item_3/Label"):GetComponent("UILabel"),"击杀boss：{1}",0)
	Find(self.gameObject,"Content/BtnChange/Label"):GetComponent("UILabel").text = L("保存修改")
	Find(self.gameObject,"Content/BtnAddFriend/Label"):GetComponent("UILabel").text = L("添加好友")
	Find(self.gameObject,"Content/BtnSendMsg/Label"):GetComponent("UILabel").text = L("发送消息")

end

function PersonalCenterView:AfterOpenView(t)
	self.roleInfo = t[1]
	self.isSelfPlay = t[2]

	self:UpdateGunModel()

	self:UpdateInfo()

	self.OnUpdate = function ()
		self:UpdateInfo()
	end
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.PlayerIconChange,self.OnUpdate)
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.PlayerNameChange,self.OnUpdate)
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.PlayerSexChange,self.OnUpdate)
end

function PersonalCenterView:IsMainPlay()
	return self.isSelfPlay
end

function PersonalCenterView:CanChangeName()
	return self.roleInfo.is_name == 0
end

function PersonalCenterView:CanChangeSex()
	return self.roleInfo.is_gender == 0
end

function PersonalCenterView:UpdateGunModel()
	local modePath = Res.gun[self.roleInfo.battery_id].Gun_path
	self.GunModel.ShowModel(modePath,Vector3.New(0,0,-28),Vector3.New(0,0,0),Vector3.one,"3_0")
	self.GunModel.Play("3_0",0)
	self.GunModel.AutoRotate(0,60,0)
	self.GunModel.SetResInfo(Vector3.New(0,0,0),Vector3.New(-20,0,0),Vector3.one)
end

function PersonalCenterView:OnClickChangeSetting(go)
	--这里现在只保存性别
	local curSex
	if(self.TogMale.value) then
		curSex = 1
	else
		curSex = 2
	end
	PersonalCenterCtrl.C2SAttrSetGender(curSex)
end

function PersonalCenterView:UpdateVisiable()
	-- body
	local isMainPlay = self:IsMainPlay()
	local canChangeName = self:CanChangeName()
	local canChangeSex = self:CanChangeSex()

	self.BtnChangeHeadIcon:SetActive(isMainPlay)
	self.BtnChangeName:SetActive(isMainPlay and canChangeName)
	self.BtnVIPLv:SetActive(isMainPlay)
	self.BtnGold:SetActive(isMainPlay)
	self.BtnDiamond:SetActive(isMainPlay)
	self.BtnChange:SetActive(isMainPlay and canChangeSex)

	self.LabelSex.gameObject:SetActive((not isMainPlay) or (isMainPlay and (not canChangeSex)))
	self.ToggleSex.gameObject:SetActive(isMainPlay and canChangeSex)

	self.BtnAddFriend:SetActive(not isMainPlay)
	self.BtnSendMsg:SetActive(not isMainPlay)
end

function PersonalCenterView:UpdateInfo()
	self:UpdateVisiable()
	if(self:IsMainPlay()) then
		self.LabelTitle.text = L("个人中心")
	else
		self.LabelTitle.text = L("查看信息")
	end

	local roleInfo = self.roleInfo
	local headId = roleInfo.head_id
	if(headId < 1 or headId > Res.misc[1].HeadIconMaxID) then
		LogError("role id = "..roleInfo.user_name.." head_id < 1 or >"..Res.misc[1].HeadIconMaxID)
		headId = 1
	end
	self.SpriteHead.spriteName = "HeadIcon_"..headId
	self.LabelName.text = roleInfo.name
	self.LabelID.text = "ID："..roleInfo.user_name
	local curSex
	if(roleInfo.gender == 1) then
	 	curSex = "男"
	 	self.TogMale.value = true
	 	self.TogFemale.value = false
	else
		curSex = "女"
		self.TogMale.value = false
		self.TogFemale.value = true
	end
	self.LabelSex.text = L("性别：{1}",L(curSex))
	self.LabelLv.text = L("LV{1}",roleInfo.level)
	local percent = 0
	self.ExpProgress.fillAmount = percent
	self.LabelVIPLv.text = L("VIP {1}",roleInfo.vip_level)

	self.LabelGold.text = roleInfo.gold
	self.LabelDiamond.text = roleInfo.diamond
	LB(self.LabelGunLv,"炮台等级：{1}",roleInfo.battery_level)
	LB(self.LabelGunRate,"炮台倍率：{1}",roleInfo.battery_rate)
	self.LabelGunName.text = L("{1}",Res.gun[roleInfo.battery_id].name)
end

function PersonalCenterView:BeforeCloseView()
	if(self.GunModel ~= nil) then
		self.GunModel.ResetModel()
	end

	if(self.OnUpdate ~= nil) then
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.PlayerIconChange,self.OnUpdate)
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.PlayerNameChange,self.OnUpdate)
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.PlayerSexChange,self.OnUpdate)
		self.OnUpdate = nil
	end
end

function PersonalCenterView:OnDestory()
	if(self.GunModel ~= nil)then
		self.GunModel.DestroyModel()
		self.GunModel = nil
	end
end