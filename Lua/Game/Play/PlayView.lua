require 'Game/Play/RevenueRankView'
require 'Game/Play/GunUnlockItem'
require 'Game/Play/TreasureItem'
require 'Game/Play/PlayIconItem'
require 'Game/Play/ComboUIItem'
PlayView=Class(BaseView)

function PlayView:ConfigUI()

	-- self.GunItem = Find(self.gameObject,"GunBox/PlayerBox/Item")
	-- self.GunItem:SetActive(false)


	self.GunDown = false
	self.VP_Handle = nil
	-- self.BG = Find(self.gameObject,"BG")
	-- self.SupPoint = UnityEngine.GameObject("supPoint")
	-- Ext.AddChildToParent(self.BG,self.SupPoint,false)
	-- local OnSelfPressBG = function (go,state)
	-- 	self:OnPressBG(go,state)
	-- end
	-- LH.AddPressEvent(self.BG,OnSelfPressBG)
    self.BulletBox = Find(self.gameObject,"BulletBox")

	local revenueRankObj = Find(self.gameObject,"RevenueRanking")
	RevenueRankView:ConfigUI(revenueRankObj)
	self.RevenueRank = RevenueRankView

	self.LeftBtnsTP = Find(self.gameObject,"BtnBox/LeftBtns"):GetComponent("TweenPosition")
	self.RightBtnsTP = Find(self.gameObject,"BtnBox/RightBtns"):GetComponent("TweenPosition")
	self.SkillBoxGo = Find(self.gameObject,"SkillBox")
	self.SkillBoxTP = Find(self.gameObject,"SkillBox"):GetComponent("TweenPosition")
	LH.SetTweenPosition(self.LeftBtnsTP,0,0.1,Vector3.New(-689.1,-19,0),Vector3.New(-689.1,-19,0))
	LH.SetTweenPosition(self.RightBtnsTP,0,0.1,Vector3.New(772.2,-26,0),Vector3.New(772.2,-26,0))
	LH.SetTweenPosition(self.SkillBoxTP,0,0.1,Vector3.New(630,520,0),Vector3.New(630,520,0))
	self.IsShowUI = false

	self.Btn_1 = Find(self.gameObject,"BtnBox/LeftBtns/Btn_1")
	LH.AddClickEvent(self.Btn_1,self.this.OnClickBtn)
	self.Btn_2 = Find(self.gameObject,"BtnBox/RightBtns/Btn_2")
	LH.AddClickEvent(self.Btn_2,self.this.OnClickBtn)
	self.Btn_3 = Find(self.gameObject,"BtnBox/LeftBtns/Btn_3")
	LH.AddClickEvent(self.Btn_3,self.this.OnClickBtn)
	self.Btn_4 = Find(self.gameObject,"BtnBox/RightBtns/Btn_4")
	LH.AddClickEvent(self.Btn_4,self.this.OnClickBtn)
	self.Btn_5 = Find(self.gameObject,"BtnBox/LeftBtns/Btn_5")
	LH.AddClickEvent(self.Btn_5,self.this.OnClickBtn)
	self.Btn_6 = Find(self.gameObject,"BtnBox/RightBtns/Btn_6")
	LH.AddClickEvent(self.Btn_6,self.this.OnClickBtn)

	--胡彰self.Btn_5下面挂特效

	self.GunUnlockItem = GunUnlockItem:New(Find(self.gameObject,"GunUnlockItem"))
	self.GunUnlockItem:Init()

	self.TreasureItem = TreasureItem:New(Find(self.gameObject,"TreasureItem"))
	self.TreasureItem:Init()

	self.PlayIconItem = PlayIconItem:New(Find(self.gameObject,"PlayIconItem"))
	self.PlayIconItem:Init()

	self.onChangeVisiable = function (t)
		if(t) then
			self:ShowBtns()
		else
			self:HideBtns()
		end
	end
	PlayCtrl.AddEvent(PlayEvent.PlayCtrl_ChangeBtnsVisiable,self.onChangeVisiable)

	self.onEnablePressBG = function (t)
		self:EnableBG(t)
	end
	PlayCtrl.AddEvent(PlayEvent.PlayCtrl_EnablePressBG,self.onEnablePressBG)


	self.BtnEnergy = Find(self.gameObject,"SkillBox/BtnEnergy")
	local OnClickBtnEnergy = function (go)
		self:AddEnergy()
	end
	LH.AddClickEvent(self.BtnEnergy,OnClickBtnEnergy)

	self.SkillUIProgress =  UIProgress:New(Find(self.gameObject,"SkillBox/Progress"),UIProgressMode.Horizontal)
	self.SkillEffectParent = Find(self.gameObject,"SkillBox/Effect")
	self.ProgressEffectParent = Find(self.gameObject,"SkillBox/Progress/ProgressEffect")
	self.CurContainer = Find(self.gameObject,"SkillBox/CurContainer").transform
	local count = self.CurContainer.childCount
	self.ListCurSkillItem = {}
	local onClickSkill = function (go)
		local helper = go:GetComponent("SkillCDHelper")
		if(helper:IsCDFinish()) then
			local index = tonumber(go.name)
			self:OnReleaseSkill(helper,index)
		end
	end
	for i=1,count do
		local item = self.CurContainer:GetChild(i - 1)
		LH.AddClickEvent(item.gameObject,onClickSkill)
		local helper = item.gameObject:AddComponent(typeof(SkillCDHelper))
		local skillSprite = item.transform:Find("Mask"):GetComponent("UISprite")
		local skillLabel = item.transform:Find("Mask/Label"):GetComponent("UILabel")
		helper:SetUI(skillSprite,skillLabel)
		item.name = tostring(i)
		table.insert(self.ListCurSkillItem,item)
	end

	
	self.ComBoUIItem = Find(self.gameObject,"ComBoBox/Item")
	self.ComBoUIItemParent = self.ComBoUIItem.transform.parent.gameObject
	self.ComBoUIItem:SetActive(false)
	self.ComBoUIItem_Lv_A = Find(self.gameObject,"ComBoBox/Lv_A")
	self.ComBoUIItem_Lv_A:SetActive(false)
	self.ComBoUIItem_Lv_A_TimeHelper = self.ComBoUIItem_Lv_A:GetComponent("TimeHelper")
	self.ComBoUIItem_Lv_A_Run_TF = self.ComBoUIItem_Lv_A.transform:FindChild("Run"):GetComponent("TweenFill")
	self.ComBoUIItem_Lv_B = Find(self.gameObject,"ComBoBox/Lv_B")
	self.ComBoUIItem_Lv_B:SetActive(false)
	self.ComBoUIItem_Lv_B_TimeHelper = self.ComBoUIItem_Lv_B:GetComponent("TimeHelper")
	self.ComBoUIItem_Lv_B_Run_TF = self.ComBoUIItem_Lv_B.transform:FindChild("Run"):GetComponent("TweenFill")
	self.ComBoUIExtra = Find(self.gameObject,"ComBoBox/Extra")
	self.ComBoUIExtra:SetActive(false)
	self.ComBoUILabel = Find(self.ComBoUIExtra,"LabelGold"):GetComponent("UILabel")
	self.ComBoUILabelChangeNumHelper = Find(self.ComBoUIExtra,"LabelGold"):AddComponent(typeof(ChangeNumberHelper))
	self.ComBoExtraCount = 0
	self.ComBoUIItemBox = {}
	self.ComBoUIItemBoxUse = {}
	local unitGOParent = self.ComBoUIItem_Lv_A.transform:FindChild("Effect").gameObject
	local renderQueue = GetParentPanelRenderQueue(unitGOParent)
	UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,52001,Vector3.zero,renderQueue + 1,nil,nil)
	unitGOParent = self.ComBoUIItem_Lv_B.transform:FindChild("Effect").gameObject
	renderQueue = GetParentPanelRenderQueue(unitGOParent)
	UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,52011,Vector3.zero,renderQueue + 1,nil,nil)

	self.SkillTipKey = LoginCtrl.mode.S2CResult.init_user_name.."_UnionFish_2017_Skill_Tips_Time"
end

function PlayView:AddEnergy()
	local item = BagCtrl.GetItem(GlobalDefine.EnergyCardId)
	if(item ~= nil and item.cnt > 0) then
		HelpCtrl.OpenTipView(L("提   示"),L("是否使用能量卡？"),function ()
			BagCtrl.C2SBagUseItem(GlobalDefine.EnergyCardId,1)
		end,nil,nil,L("确 定"),L("取 消"))
	else
		HelpCtrl.OpenTipView(L("提   示"),L("能量卡不足,可从商城中快速获取能量卡"),function ()
			UIMgr.OpenView("ShopView",3)
		end,nil,nil,L("去商城购买"),L("取 消"))
	end
end

function PlayView:GetGunUnlockBtn()
	return self.Btn_5
end

function PlayView:GetTreasureBtn()
	return self.Btn_3
end

function PlayView:GetPlayIconBtn()
	return self.Btn_1
end

function PlayView:GetOnlineBonusBtn()
	return self.PlayIconItem:GetOnlineBonusBtn()
end

function PlayView:GetFishDicBtn()
	return self.PlayIconItem:GetFishDicBtn()
end

function PlayView:GetTaskBtn()
	return self.PlayIconItem:GetTaskBtn()
end

function PlayView:GetSkillBtn()
	return self.SkillBoxGo
end

function PlayView:GetExitBtn()
	return self.Btn_6
end

function PlayView:OnReleaseSkill(helper,index)
	local skillID = SkillCtrl.mode.SkillList[index]
	if(skillID ~= nil) then
		if(SkillCtrl.IsSkillForbid(skillID)) then return end
		if(table.contains(GlobalDefine.LockSkill,skillID)) then
			HelpCtrl.Msg(L("功能尚未开启！"))
			return
		end
		if(table.contains(SkillCtrl.mode.UnLockSkillList,skillID))then
			local curSP = LoginCtrl.mode.S2CEnterGame.sp
			local needSP = Res.skill[skillID].use_sp * Res.misc[1].base_sp
			LogColor("#ff0000","curSP",curSP,"needSP",needSP)
			if(curSP >= needSP) then
				SkillCtrl.C2SSkillUseSkill(skillID)
				helper:UpdateNextTimestamp(Time.time + Res.skill[skillID].cd)
			else
				local curDiamond = LoginCtrl.mode.S2CEnterGame.diamond
				local needDiamond = Res.skill[skillID].use_gold
				LogColor("#ff0000","curDiamond",curDiamond,"needDiamond",needDiamond)
				local tipValue = UnityEngine.PlayerPrefs.GetString(self.SkillTipKey,"")
				LogColor("#ff0000","self.SkillTipKey[get]",tonumber(tipValue))
				if(tipValue == nil or tipValue == "" or tonumber(tipValue) < tonumber(tostring(LH.GetDayOffsetTimeTicks(-7)))) then
					HelpCtrl.OpenTipView(L("提   示"),L("能量不够，你要花费{1}钻石释放技能吗？",needDiamond),function ()
						if(curDiamond >= needDiamond) then
							SkillCtrl.C2SSkillUseSkillGold(skillID)
							helper:UpdateNextTimestamp(Time.time + Res.skill[skillID].cd)
						else
							HelpCtrl.OpenDiamondNotEnoughView()
						end
					end,nil,nil,L("确 认"),L("取 消"),L("七天内不再提示"),false,function (value)
						LogColor("#ff0000","value",value)
						if(value) then
							LogColor("#ff0000","self.SkillTipKey[set]",tostring(LH.GetDateTimeTicks()))
							UnityEngine.PlayerPrefs.SetString(self.SkillTipKey,tostring(LH.GetDateTimeTicks()))
						end
					end)
				else 
					if(curDiamond >= needDiamond) then
						SkillCtrl.C2SSkillUseSkillGold(skillID)
						helper:UpdateNextTimestamp(Time.time + Res.skill[skillID].cd)
					else
						HelpCtrl.OpenDiamondNotEnoughView()
					end
				end
				
			end
		else
			HelpCtrl.Msg(L("当前技能未解锁"))
		end
	end
end

function PlayView:UpdateSkillBox()
	local list = SkillCtrl.mode.SkillList
	local index =1
	for i=1,#list do
		local skillID = list[i]
		local go = self.ListCurSkillItem[i].gameObject
		go:SetActive(true)
		local helper = go:GetComponent("SkillCDHelper")
		helper:UpdateCD(Res.skill[skillID].cd)
		local isLock = not table.contains(SkillCtrl.mode.UnLockSkillList,skillID)
		self:UpdateSkillIcon(go,skillID,isLock)
		index = index + 1
	end
	for i=index,#self.ListCurSkillItem do
		self.ListCurSkillItem[i].gameObject:SetActive(false)
	end
	local percent = LoginCtrl.mode.S2CEnterGame.sp / Res.misc[1].max_sp
	self.SkillUIProgress:UpdateProgress(percent)
	--显示特效
	if(percent >= 1) then
		if(self.SkillProgressFinishEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(self.SkillEffectParent)
			self.SkillProgressFinishEffect = UnitEffectMgr.ShowUIEffectInParent(self.SkillEffectParent,54015,Vector3.zero,true,renderQueue + 10)
		end
		self.SkillProgressFinishEffect:Show(self.SkillEffectParent,Vector3.zero,true)
		if(self.SkillProgressEffect ~= nil) then
			self.SkillProgressEffect:Hide()
		end
	else
		if(self.SkillProgressFinishEffect ~= nil) then
			self.SkillProgressFinishEffect:Hide()
		end
		if(self.SkillProgressEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(self.ProgressEffectParent)
			self.SkillProgressEffect = UnitEffectMgr.ShowUIEffectInParent(self.ProgressEffectParent,54014,Vector3.zero,true,renderQueue + 10)
		end
		self.SkillProgressEffect:Show(self.ProgressEffectParent,Vector3.zero,true)
	end
end

function PlayView:UpdateSkillIcon(go,skillId,isLock)
	local sprite = go.transform:Find("Icon"):GetComponent("UISprite")
	sprite.spriteName = "skillID_"..skillId
	local maskGO = go.transform:Find("Mask").gameObject
	local lockGO = go.transform:Find("Lock").gameObject
	maskGO:SetActive(not isLock)
	lockGO:SetActive(isLock)

	if LoginCtrl.mode.S2CEnterGame.sp > Res.skill[skillId].use_sp * 2000 then
		sprite.color = Color.white
	else
		sprite.color = Color.black
	end
end

function PlayView.OnClickBtn(go)
	-- SoundFxManager.PlaySoundById(1,2,nil)
	if go.name == "Btn_1" then
    	UIMgr.Dic("PlayView").PlayIconItem:Show()
	elseif go.name == "Btn_2" then
    	if(UIMgr.Dic("PlayView").RevenueRank.isShow) then
			UIMgr.Dic("PlayView").RevenueRank.Hide()
		else
			UIMgr.Dic("PlayView").RevenueRank.Show()
		end
	elseif go.name == "Btn_3" then
		UIMgr.Dic("PlayView").TreasureItem:Show()
    	
	elseif go.name == "Btn_4" then
		UIMgr.OpenView("FishDicView",{MainCtrl.mode.CurIslandId,0})
	elseif go.name == "Btn_5" then
    	UIMgr.Dic("PlayView").GunUnlockItem:Show()
	elseif go.name == "Btn_6" then
		HelpCtrl.OpenTipView(L("提   示"),L("确认退出渔场？"),function ()
			MainCtrl.C2SRoomExitRoom()
		end,nil,nil,L("确 认"),L("取 消"))
	end
	LH.Play(go,"Play")
end

function PlayView:AfterOpenView(t)
	self.RevenueRank:AfterOpenView(t)

	--先隐藏按钮
	self.LeftBtnsTP.value = Vector3.New(-700,-6.1,0)
	self.RightBtnsTP.value = Vector3.New(760,-6.1,0)
	self.SkillBoxTP.value = Vector3.New(630,520,0)
	self.IsShowUI = false

	self:UpdateSkillBox()

	UIMgr.Dic("PlayView").CheckShowEffect()

	self.uiCamera = LH.GetMainUICamera()--获取到UI相机

	self.OnUnlock = function (msg)
		self:OnGunUnlock(msg)
	end
	PersonalCenterCtrl.AddEvent(PersonalCenterEvent.GunRateUnlock,self.OnUnlock)

	self.OnGetTaskInfo = function ()
		self:OnTaskUpdate()
	end
	TaskCtrl.AddEvent(TaskEvent.OnGetTaskInfo,self.OnGetTaskInfo)

	self:UpdateGunRateShow()
end

function PlayView:OnGunUnlock(msg)
	local cfg = Res.gun_unlock[msg.lv]
	local items = {{GlobalDefine.Gold,cfg.give}}
	if(cfg.unlockIsland > 0) then
		table.insert(items,{cfg.unlockIsland,1})
	end
	HelpCtrl.OpenItemGetEffectView(items,L("解锁{1}倍炮",cfg.rate))
	--关闭小界面
	self.GunUnlockItem:Hide()
	UIMgr.Dic("PlayView").CheckShowUnlockGunRateEffect()
end

function PlayView:OnTaskUpdate()
	UIMgr.Dic("PlayView").CheckShowTaskEffect()
	UIMgr.Dic("PlayView").CheckShowPlayIconEffect()
end

function PlayView:EnableBG(isEnable)
	self.BG:SetActive(isEnable)
end

function PlayView:ShowBtns()
	if(not self.IsShowUI) then
		self.IsShowUI = true
		LH.SetTweenPosition(self.LeftBtnsTP,0,0.5,Vector3.New(-700,-6.1,0),Vector3.New(-570,-6.1,0))
		LH.SetTweenPosition(self.RightBtnsTP,0,0.5,Vector3.New(760,-6.1,0),Vector3.New(625,-6.1,0))
		LH.SetTweenPosition(self.SkillBoxTP,0,0.5,Vector3.New(630,520,0),Vector3.New(630,350,0))
	end
end

function PlayView:HideBtns()
	if(self.IsShowUI) then
		self.IsShowUI = false
		LH.SetTweenPosition(self.LeftBtnsTP,0,0.5,Vector3.New(-570,-6.1,0),Vector3.New(-700,-6.1,0))
		LH.SetTweenPosition(self.RightBtnsTP,0,0.5,Vector3.New(625,-6.1,0),Vector3.New(760,-6.1,0))
		LH.SetTweenPosition(self.SkillBoxTP,0,0.5,Vector3.New(630,350,0),Vector3.New(630,520,0))
	end
end


function PlayView:AddListener()
	self:AddEvent(ED.PlayCtrl_S2CSceneAttackFish,self.this.PlayCtrl_S2CSceneAttackFish)
	self:AddEvent(ED.PlayCtrl_S2CSceneSynObj,self.this.PlayCtrl_S2CSceneSynObj)
	self:AddEvent(ED.PlayCtrl_S2CSceneSynRole,self.this.PlayCtrl_S2CSceneSynRole)
	self:AddEvent(ED.PlayCtrl_S2CSceneEnterScene,self.this.PlayCtrl_S2CSceneEnterScene)
	self:AddEvent(ED.PlayCtrl_S2CSceneRoleEnterScene,self.this.PlayCtrl_S2CSceneRoleEnterScene)
	self:AddEvent(ED.PlayCtrl_S2CSceneObjLeave,self.this.PlayCtrl_S2CSceneObjLeave)
	self:AddEvent(ED.OnlineView_NewView,self.this.OnlineView_NewView)
	self:AddEvent(ED.BagCtrl_S2CBagUpdate,self.this.OnBagUpdate)
	self:AddEvent(ED.LookForCtrl_S2CTreasureGetInfo,self.this.OnLookForUpdate)

	local onPlayAttrChange = function (keys)
		if(keys ~= nil and table.contains(keys,AttrDefine.ATTR_SP)) then
			self:UpdateSkillBox()
		end
		if(keys ~= nil and table.contains(keys,AttrDefine.ATTR_BATTERYRATE)) then
			self:UpdateGunRateShow()
		end
	end
	self:AddEvent(ED.MainCtrl_PlayInfoChange,onPlayAttrChange)
end

function PlayView:UpdateGunRateShow()
	if(self.GunUnlockItem:IsMaxGunRate()) then
		self:GetGunUnlockBtn():SetActive(false)
	else
		local cfg = self.GunUnlockItem:GetNextGunRateCfg()
		Find(self:GetGunUnlockBtn(),"LabelRate"):GetComponent("UILabel").text = L("{1}倍",cfg.rate)
	end
end

function PlayView.PlayCtrl_S2CSceneAttackFish(t)
	local ResD = Res.misc[1].combo_value
	if t.combo ~= nil and t.role_obj_id == GunMgr.MainGun.roleData.role_obj_id then    	 
    	local P_ComBoUIItem = UIMgr.Dic("PlayView").ComBoUIItem.transform.parent:FindChild("ComBoUIItem")
		if P_ComBoUIItem ~= nil then
    		P_ComBoUIItem:GetComponent("TimeHelper"):ExcuteTime(0)
		end
		if(t.combo == 1) then UIMgr.Dic("PlayView").ComBoExtraCount = 0 end
		local preComBoExtraCount = UIMgr.Dic("PlayView").ComBoExtraCount
		UIMgr.Dic("PlayView").ComBoExtraCount = UIMgr.Dic("PlayView").ComBoExtraCount + t.combo_gold
		UIMgr.Dic("PlayView").ComBoUILabel.text = "x"..tostring(UIMgr.Dic("PlayView").ComBoExtraCount)
		local numShowTime = 0
		if(math.abs(UIMgr.Dic("PlayView").ComBoExtraCount - preComBoExtraCount) > 1) then
			numShowTime = 1
		end
		UIMgr.Dic("PlayView").ComBoUILabelChangeNumHelper:SetNumberAtStart(preComBoExtraCount,UIMgr.Dic("PlayView").ComBoExtraCount,numShowTime)
    	local temp = UIMgr.Dic("PlayView").GetComBoUIItem()
		table.remove(UIMgr.Dic("PlayView").ComBoUIItemBox, 1)
    	table.insert(UIMgr.Dic("PlayView").ComBoUIItemBoxUse, temp)			

		local tp = temp.tp
		tp.from = Vector3.New(400,155,0)
		tp.to = Vector3.New(400,155,0)
		tp.duration = 0.1
		tp.delay = 0
		tp:ResetToBeginning()
		tp:PlayForward() 
		local ta = temp.ta
		ta.from = 1
		ta.to = 1
		ta.duration = 0.1
		ta.delay = 0
		ta:ResetToBeginning()
		ta:PlayForward() 
    	temp.numBoxLabel.text = tostring(t.combo)
    	local ts = temp.ts
    	ts:ResetToBeginning()
    	ts:PlayForward()
		--temp:GetComponent("TimeHelper"):AddTime(ResD[3],UIMgr.Dic("PlayView").BackComBoUIItem,{temp})
		temp.timeHelper:AddTime(0.2,UIMgr.Dic("PlayView").BackComBoUIItem,{temp})

    	UIMgr.Dic("PlayView").ComBoUIItem_Lv_A_TimeHelper:ExcuteTime(0)
    	UIMgr.Dic("PlayView").ComBoUIItem_Lv_B_TimeHelper:ExcuteTime(0)
    	if tonumber(t.combo) < ResD[1][1] then
    		temp:SetEffectActive(false)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_A:SetActive(false)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_B:SetActive(false)
			UIMgr.Dic("PlayView").ComBoUIExtra:SetActive(false)
    	elseif tonumber(t.combo) >=ResD[1][1] and tonumber(t.combo) < ResD[2][1] then
    		temp:SetEffectActive(true)
    		local unitGOParent = temp.effectParent
			local renderQueue = temp.renderQueue
			UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,52002,Vector3.zero,renderQueue + 1,nil,nil)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_A:SetActive(true)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_B:SetActive(false)
			UIMgr.Dic("PlayView").ComBoUIExtra:SetActive(true)
			local tf = UIMgr.Dic("PlayView").ComBoUIItem_Lv_A_Run_TF
			tf.from = 1
			tf.to = 0
			tf.duration = ResD[3]
			tf.delay = 0
			tf:ResetToBeginning()
			tf:PlayForward()
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_A_TimeHelper:AddTime(5,UIMgr.Dic("PlayView").BackComBoUILv,{UIMgr.Dic("PlayView").ComBoUIItem_Lv_A})
    	elseif tonumber(t.combo) >= ResD[2][1] then
    		temp:SetEffectActive(true)
    		local unitGOParent = temp.effectParent
			local renderQueue = temp.renderQueue
			UnitEffectMgr.ShowUIEffectInParentByHelper(unitGOParent,52012,Vector3.zero,renderQueue + 1,nil,nil)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_A:SetActive(false)
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_B:SetActive(true)
			UIMgr.Dic("PlayView").ComBoUIExtra:SetActive(true)
			local tf = UIMgr.Dic("PlayView").ComBoUIItem_Lv_B_Run_TF
			tf.from = 1
			tf.to = 0
			tf.duration = ResD[3]
			tf.delay = 0
			tf:ResetToBeginning()
			tf:PlayForward()
			UIMgr.Dic("PlayView").ComBoUIItem_Lv_B_TimeHelper:AddTime(5,UIMgr.Dic("PlayView").BackComBoUILv,{UIMgr.Dic("PlayView").ComBoUIItem_Lv_B})
    	end
    end
end
function PlayView.GetComBoUIItem()
    if #UIMgr.Dic("PlayView").ComBoUIItemBox == 0 then
        local temp = LH.GetGoBy(UIMgr.Dic("PlayView").ComBoUIItem,UIMgr.Dic("PlayView").ComBoUIItemParent)
        local item = ComboUIItem:New(temp)
        item:SetActive(true)
        table.insert(UIMgr.Dic("PlayView").ComBoUIItemBox, item)
    end
    local item = UIMgr.Dic("PlayView").ComBoUIItemBox[1]
    item:SetActive(true)
    return item
end
function PlayView.BackComBoUIItem(g,t)
	local item = t[1]
	local tp = item.tp
	tp.from = Vector3.New(400,155,0)
	tp.to = Vector3.New(400,200,0)
	tp.duration = 0.5
	tp.delay = 0
	tp:ResetToBeginning()
	tp:PlayForward() 
	local ta = item.ta
	ta.from = 1
	ta.to = 0
	ta.duration = 0.5
	ta.delay = 0
	ta:ResetToBeginning()
	ta:PlayForward() 
	item.timeHelper:AddTime(0.5,UIMgr.Dic("PlayView").BackComBoUIItemEnd,{item})
    table.remove(UIMgr.Dic("PlayView").ComBoUIItemBoxUse, 1)
end
function PlayView.BackComBoUIItemEnd(g,t)
	local item = t[1]
    item:SetActive(false)
    table.insert(UIMgr.Dic("PlayView").ComBoUIItemBox, item)
end

function PlayView.BackComBoUILv(g,t)
	t[1]:SetActive(false)
	UIMgr.Dic("PlayView").ComBoUIExtra:SetActive(false)
end

function PlayView:BeforeCloseView()

	if(self.OnUnlock ~= nil) then
		PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.GunRateUnlock,self.OnUnlock)
		self.OnUnlock = nil
	end

	if(self.OnGetTaskInfo ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnGetTaskInfo,self.OnGetTaskInfo)
		self.OnGetTaskInfo = nil
	end

	self.RevenueRank:BeforeCloseView()
	self.GunUnlockItem:Hide()
	self.TreasureItem:Hide()
	self.PlayIconItem:Hide()
	if(self.PressTimerHandle ~= nil) then
		self.PressTimerHandle:Cancel()
		self.PressTimerHandle = nil
	end

	if(self.OnlineEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.OnlineEffect)
		self.OnlineEffect = nil
	end
	if(self.UnlockGunRateEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.UnlockGunRateEffect)
		self.UnlockGunRateEffect = nil
	end
	if(self.SkillProgressFinishEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.SkillProgressFinishEffect)
		self.SkillProgressFinishEffect = nil
	end
	if(self.SkillProgressEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.SkillProgressEffect)
		self.SkillProgressEffect = nil
	end
	if(self.PlayIconEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.PlayIconEffect)
		self.PlayIconEffect = nil
	end
	if(self.LookForEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.LookForEffect)
		self.LookForEffect = nil
	end
	if(self.TaskEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.TaskEffect)
		self.TaskEffect = nil
	end
	self.uiCamera = nil
 end
function PlayView:Update()end
function PlayView:OnDestory()
	self.SkillUIProgress:Dispose()
	self.RevenueRank:OnDestory()
	self.GunUnlockItem:Dispose()
	self.TreasureItem:Dispose()
	self.PlayIconItem:Dispose()
	if(self.onChangeVisiable ~= nil) then
		PlayCtrl.RemoveEvent(PlayEvent.PlayCtrl_ChangeBtnsVisiable,self.onChangeVisiable)
		self.onChangeVisiable = nil
	end
	if(self.onEnablePressBG ~= nil) then
		PlayCtrl.RemoveEvent(PlayEvent.PlayCtrl_EnablePressBG,self.onEnablePressBG)
		self.onEnablePressBG = nil
	end
	if(self.OnlineEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.OnlineEffect)
		self.OnlineEffect = nil
	end
	if(self.UnlockGunRateEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.UnlockGunRateEffect)
		self.UnlockGunRateEffect = nil
	end
	if(self.SkillProgressFinishEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.SkillProgressFinishEffect)
		self.SkillProgressFinishEffect = nil
	end
	if(self.SkillProgressEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.SkillProgressEffect)
		self.SkillProgressEffect = nil
	end
	if(self.PlayIconEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.PlayIconEffect)
		self.PlayIconEffect = nil
	end
	if(self.LookForEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.LookForEffect)
		self.LookForEffect = nil
	end
	if(self.TaskEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.TaskEffect)
		self.TaskEffect = nil
	end
end

function PlayView.PlayCtrl_S2CSceneSynObj(t)
end

function PlayView.PlayCtrl_S2CSceneEnterScene(t)
	--更新收益界面
	UIMgr.Dic("PlayView").RevenueRank:UpdateInfo()

end

function PlayView.PlayCtrl_S2CSceneRoleEnterScene(t)
	--其他人进入渔场播放声音
	PlaySound(AudioDefine.OtherJoinFishScene)
	--更新收益界面
	UIMgr.Dic("PlayView").RevenueRank:UpdateInfo()
end

function PlayView.PlayCtrl_S2CSceneSynRole(t)
	--更新收益界面
	UIMgr.Dic("PlayView").RevenueRank:UpdateInfo()
end

function PlayView.PlayCtrl_S2CSceneObjLeave(t)
	--更新收益界面
	UIMgr.Dic("PlayView").RevenueRank:UpdateInfo()
end

function PlayView.OnlineView_NewView(t)
	--胡彰b为是否显示特效标记
	UIMgr.Dic("PlayView").CheckShowOnlineEffect()
	UIMgr.Dic("PlayView").CheckShowPlayIconEffect()
end

function PlayView.OnBagUpdate()
	UIMgr.Dic("PlayView").CheckShowUnlockGunRateEffect()
end

function PlayView.OnLookForUpdate()
	UIMgr.Dic("PlayView").CheckShowLookForEffect()
end

function PlayView.CheckShowOnlineEffect()
	local b = OnlineCtrl.IsShowE()
	if(b) then
		if(UIMgr.Dic("PlayView").OnlineEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(UIMgr.Dic("PlayView"):GetOnlineBonusBtn())
			UIMgr.Dic("PlayView").OnlineEffect = UnitEffectMgr.ShowUIEffectInParent(UIMgr.Dic("PlayView"):GetOnlineBonusBtn(),54013,Vector3.zero,true,renderQueue + 1)
		end
		UIMgr.Dic("PlayView").OnlineEffect:Show(UIMgr.Dic("PlayView"):GetOnlineBonusBtn(),Vector3.zero,true)
	else
		if(UIMgr.Dic("PlayView").OnlineEffect ~= nil) then
			UIMgr.Dic("PlayView").OnlineEffect:Hide()
		end
	end
	return b
end

function PlayView.CheckShowTaskEffect()
	local b = TaskCtrl.IsCanGetTaskBonus()
	if(b) then
		if(UIMgr.Dic("PlayView").TaskEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(UIMgr.Dic("PlayView"):GetTaskBtn())
			UIMgr.Dic("PlayView").TaskEffect = UnitEffectMgr.ShowUIEffectInParent(UIMgr.Dic("PlayView"):GetTaskBtn(),54013,Vector3.zero,true,renderQueue + 1)
		end
		UIMgr.Dic("PlayView").TaskEffect:Show(UIMgr.Dic("PlayView"):GetTaskBtn(),Vector3.zero,true)
	else
		if(UIMgr.Dic("PlayView").TaskEffect ~= nil) then
			UIMgr.Dic("PlayView").TaskEffect:Hide()
		end
	end
	return b
end

function PlayView.CheckShowLookForEffect()
	local b = LookForCtrl.IsCanLookFor()
	if(b) then
		if(UIMgr.Dic("PlayView").LookForEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(UIMgr.Dic("PlayView"):GetTreasureBtn())
			UIMgr.Dic("PlayView").LookForEffect = UnitEffectMgr.ShowUIEffectInParent(UIMgr.Dic("PlayView"):GetTreasureBtn(),54013,Vector3.zero,true,renderQueue + 1)
		end
		UIMgr.Dic("PlayView").LookForEffect:Show(UIMgr.Dic("PlayView"):GetTreasureBtn(),Vector3.zero,true)
	else
		if(UIMgr.Dic("PlayView").LookForEffect ~= nil) then
			UIMgr.Dic("PlayView").LookForEffect:Hide()
		end
	end
	return b
end

function PlayView.CheckShowUnlockGunRateEffect()
	local b = GunRateUnlockCtrl.IsCanUnlockGunRate()
	if(b) then
		if(UIMgr.Dic("PlayView").UnlockGunRateEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(UIMgr.Dic("PlayView"):GetGunUnlockBtn())
			UIMgr.Dic("PlayView").UnlockGunRateEffect = UnitEffectMgr.ShowUIEffectInParent(UIMgr.Dic("PlayView"):GetGunUnlockBtn(),54013,Vector3.zero,true,renderQueue + 1)
		end
		UIMgr.Dic("PlayView").UnlockGunRateEffect:Show(UIMgr.Dic("PlayView"):GetGunUnlockBtn(),Vector3.zero,true)
	else
		if(UIMgr.Dic("PlayView").UnlockGunRateEffect ~= nil) then
			UIMgr.Dic("PlayView").UnlockGunRateEffect:Hide()
		end
	end
	return b
end

function PlayView.CheckShowPlayIconEffect()
	local b = OnlineCtrl.IsShowE() or TaskCtrl.IsCanGetTaskBonus()
	if(b) then
		if(UIMgr.Dic("PlayView").PlayIconEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(UIMgr.Dic("PlayView"):GetPlayIconBtn())
			UIMgr.Dic("PlayView").PlayIconEffect = UnitEffectMgr.ShowUIEffectInParent(UIMgr.Dic("PlayView"):GetPlayIconBtn(),54013,Vector3.zero,true,renderQueue + 1)
		end
		UIMgr.Dic("PlayView").PlayIconEffect:Show(UIMgr.Dic("PlayView"):GetPlayIconBtn(),Vector3.zero,true)
	else
		if(UIMgr.Dic("PlayView").PlayIconEffect ~= nil) then
			UIMgr.Dic("PlayView").PlayIconEffect:Hide()
		end
	end
	return b
end

function PlayView.CheckShowEffect()
	UIMgr.Dic("PlayView").CheckShowOnlineEffect()
	UIMgr.Dic("PlayView").CheckShowUnlockGunRateEffect()
	UIMgr.Dic("PlayView").CheckShowPlayIconEffect()
	UIMgr.Dic("PlayView").CheckShowLookForEffect()
	UIMgr.Dic("PlayView").CheckShowTaskEffect()
end

-- function PlayView:OnPressBG(go,state)
-- 	if(state) then
-- 		if(self.PressTimerHandle ~= nil) then
-- 			self.PressTimerHandle:Cancel()
-- 			self.PressTimerHandle = nil
-- 		end
-- 		local OnDelay = function (lt)
-- 			self:SendBullet()
-- 		end
-- 		self.PressTimerHandle = LH.UseVP(0, 0, 0.1 ,OnDelay,nil)
-- 	else
-- 		if(self.PressTimerHandle ~= nil) then
-- 			self.PressTimerHandle:Cancel()
-- 			self.PressTimerHandle = nil
-- 		end
-- 		self:SendBullet()
-- 	end
-- end

-- function PlayView:SendBullet()
-- 	if(GunMgr.MainGun == nil) then
-- 			return
-- 	end
-- 	--local pos = GunMgr.MainGun.container.transform.localPosition
-- 	local pos = GunMgr.MainGun:GetCenterPos()
-- 	local inputMousePos = UnityEngine.Input.mousePosition
-- 	local inputPos = self.uiCamera:ScreenToWorldPoint(inputMousePos)
-- 	self.SupPoint.transform.position = inputPos
-- 	inputPos = self.SupPoint.transform.localPosition
-- 	local v3 = inputPos - pos;
-- 	v3.z = 0
-- 	--local v3 = UnityEngine.Input.mousePosition - Vector3.New(UnityEngine.Screen.width/2,UnityEngine.Screen.height/2) - Vector3.New(pos.x,pos.y)
-- 	local d = Vector3.Angle(v3,Vector3.New(0,1,0))
-- 	if v3.x > 0 then
-- 		d = -1 * d
-- 	else
-- 		d = d - 360
-- 	end
-- 	GunMgr.ClientSendBullet(d)
-- end

