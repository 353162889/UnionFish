HeadView=Class(BaseView)

function HeadView:ConfigUI()
	self.TP = Find(self.gameObject,"Widget"):GetComponent("TweenPosition")
	self.Head_Pic = Find(self.gameObject,"Widget/HeadBox/Pic"):GetComponent("UISprite")
	self.Head_LvLabel = Find(self.gameObject,"Widget/HeadBox/Lv"):GetComponent("UILabel")
	self.SpriteVip = Find(self.gameObject,"Widget/HeadBox/VIP"):GetComponent("UISprite")
	self.Money_1Label = Find(self.gameObject,"Widget/MoneyBox/Type_1/Value"):GetComponent("UILabel")
	self.Money_2Label = Find(self.gameObject,"Widget/MoneyBox/Type_2/Value"):GetComponent("UILabel")
	self.NameLabel = Find(self.gameObject,"Widget/NameBox/Name"):GetComponent("UILabel")
	self.Btn_1 = Find(self.gameObject,"Widget/MoneyBox/Type_1/Btn_1")
	LH.AddClickEvent(self.Btn_1,self.this.OnClickBtn)
	self.Btn_2 = Find(self.gameObject,"Widget/MoneyBox/Type_2/Btn_2")
	LH.AddClickEvent(self.Btn_2,self.this.OnClickBtn)
	self.BtnPersonalCenter = Find(self.gameObject,"Widget/HeadBox/Mask")
	LH.AddClickEvent(self.BtnPersonalCenter,self.this.OnClickBtn)

	self.isShow = true
	self.onVisiable = function (isShow,transition)
		self:ShowVisiable(isShow,transition)
	end
	MainCtrl.AddEvent(MainEvent.MainCtrl_ChangeHeadViewVisiable,self.onVisiable)
end

function HeadView:ShowVisiable(isShow,transition)
	if(self.isShow == isShow) then return end
	self.isShow = isShow
	if(transition) then
		if(self.isShow) then
			LH.SetTweenPosition(self.TP,0,0.5,Vector3.New(0,150,0),Vector3.New(0,0,0))
		else
			LH.SetTweenPosition(self.TP,0,0.5,Vector3.New(0,0,0),Vector3.New(0,150,0))
		end
	else
		if(self.isShow) then
			self.TP.transform.localPosition = Vector3.New(0,0,0)
		else
			self.TP.transform.localPosition = Vector3.New(0,150,0)
		end
	end
end

function HeadView:AfterOpenView(t) 
	self:UpdateView()
	
	self.PlayInfoChange = function (t)
		self:UpdateView()
	end
	EventMgr.AddEvent(ED.MainCtrl_PlayInfoChange,self.PlayInfoChange)

	self.OnFishSceneRoleUpdate = function (msg)
		self:OnFishSceneUpdate(msg)
	end
	EventMgr.AddEvent(ED.PlayCtrl_S2CSceneSynchroUpdate,self.OnFishSceneRoleUpdate)
	self.OnRefreshView = function ()
		self:UpdateView()
	end
	MainCtrl.AddEvent(MainEvent.MainCtrl_RefreshHeadView,self.OnRefreshView)
end

function HeadView:AddListener()

end

function HeadView:BeforeCloseView()
	if(self.PlayInfoChange ~= nil) then
		EventMgr.RemoveEvent(ED.MainCtrl_PlayInfoChange,self.PlayInfoChange)
		self.PlayInfoChange = nil
	end
	if(self.OnFishSceneRoleUpdate ~= nil) then
		EventMgr.RemoveEvent(ED.PlayCtrl_S2CSceneSynchroUpdate,self.OnFishSceneRoleUpdate)
		self.OnFishSceneRoleUpdate = nil
	end
	if(self.OnRefreshView ~= nil) then
		MainCtrl.RemoveEvent(MainEvent.MainCtrl_RefreshHeadView,self.OnRefreshView)
		self.OnRefreshView = nil
	end
end

function HeadView:OnDestory()
	if(self.onVisiable ~= nil) then
		MainCtrl.RemoveEvent(MainEvent.MainCtrl_ChangeHeadViewVisiable,self.onVisiable)
		self.onVisiable = nil
	end

end

function HeadView.OnClickBtn(go)
	if go.name == "Btn_1" then
		UIMgr.OpenView("ShopView",1)
	elseif go.name == "Btn_2" then
		UIMgr.OpenView("ShopView",3)
    elseif go.name == "Mask" then
    	PersonalCenterCtrl.OpenView(LoginCtrl.mode.S2CEnterGame,true)
	end
end

function HeadView:UpdateView()
	local data = LoginCtrl.mode.S2CEnterGame
	self.Head_LvLabel.text = tostring(data.level)
	self.SpriteVip.spriteName = "vip_"..data.vip_level
	self.Money_1Label.text = MainCtrl.GetShowGold(LoginCtrl.mode.S2CEnterGame.gold)
	self.Money_2Label.text = MainCtrl.GetShowDiamond(LoginCtrl.mode.S2CEnterGame.diamond)
	self.NameLabel.text = data.name
	local headId = data.head_id
	if(headId < 1 or headId > Res.misc[1].HeadIconMaxID) then
		LogError("role id = "..roleInfo.role_id.." head_id < 1 or >"..Res.misc[1].HeadIconMaxID)
		headId = 1
	end
	self.Head_Pic.spriteName = "HeadIcon_"..headId
end

function HeadView:OnFishSceneUpdate(msg)
	if(MainCtrl.mode.CurIslandId ~= nil and Res.island[MainCtrl.mode.CurIslandId].type == IslandType.TestFish) then return end
	if(GunMgr.MainGun ~= null and GunMgr.MainGun.roleData.role_obj_id == msg.obj_id) then
		self.Money_1Label.text = MainCtrl.GetShowGold(msg.coin)
		self.Money_2Label.text = MainCtrl.GetShowDiamond(msg.diamond)
	end		
end