SkillView=Class(BaseView)

function SkillView:ConfigUI()  
	self.UIProgress =  UIProgress:New(Find(self.gameObject,"CurSkill/Progress"),UIProgressMode.Horizontal)
	self.CurContainer = Find(self.gameObject,"CurSkill/CurContainer").transform
	local count = self.CurContainer.childCount
	self.ListCurSkillItem = {}
	local curItemStartDragFunc = function (lt,go)
		self:OnItemStartChangeDepth(go)
	end

	local curItemReleaseFunc = function (lt,curentGO,targetGO)
		self:OnCurItemRelease(lt,curentGO,targetGO)
	end
	for i=1,count do
		local item = self.CurContainer:GetChild(i - 1)
		item.name = tostring(i)
		local helper = item.gameObject:AddComponent(typeof(UIDragDropItemHelper))
		helper.cloneOnDrag = true
		helper:SetReleaseFunc(curItemReleaseFunc,nil)
		helper:SetStartFunc(curItemStartDragFunc,nil)
		table.insert(self.ListCurSkillItem,item)
	end

	self.BtnEnergy = Find(self.gameObject,"CurSkill/BtnEnergy")
	local OnClickBtnEnergy = function (go)
		self:AddEnergy()
	end
	LH.AddClickEvent(self.BtnEnergy,OnClickBtnEnergy)
	
	self.SkillContainer = Find(self.gameObject,"Skills/SkillContainer").transform
	local count = self.SkillContainer.childCount
	self.ListSkillItem = {}
	local skillItemStartDragFunc = function (lt,go)
		self:OnItemStartChangeDepth(go)
		local skillID = tonumber(go.name)
		self:SelectSkillIcon(skillID)
	end
	local skillItemReleaseFunc = function (lt,curentGO,targetGO)
		self:OnSkillItemRelease(lt,curentGO,targetGO)
	end
	local onSelect = function (go)
		local skillID = tonumber(go.name)
		self:SelectSkillIcon(skillID)
	end
	local listSkill = {}
	for i=1,#SortRes.Skill do
		table.insert(listSkill,SortRes.Skill[i])
	end
	table.sort(listSkill,function (a,b)
		local aLock = table.contains(GlobalDefine.LockSkill,a.id)
		local bLock = table.contains(GlobalDefine.LockSkill,b.id)
		if(aLock ~= bLock) then
			return not aLock
		else
			return a.id < b.id
		end
	end)
	
	for i=1,count do
		local item = self.SkillContainer:GetChild(i - 1)
		if(i <= #listSkill) then
			item.name = tostring(listSkill[i].id)
			self:UpdateSkillIcon(item,listSkill[i].id)
			local helper = item.gameObject:AddComponent(typeof(UIDragDropItemHelper))
			helper.cloneOnDrag = true
			helper:SetReleaseFunc(skillItemReleaseFunc,nil)
			helper:SetStartFunc(skillItemStartDragFunc,nil)
			LH.AddClickEvent(item.gameObject,onSelect)
			table.insert(self.ListSkillItem,item)
		else
			item.gameObject:SetActive(false)
		end
	end

	local descGO = Find(self.gameObject,"Skills/Desc")
	self.SelectSkillItem = Find(descGO,"Item_Select")
	self.LabelSelectName = Find(descGO,"LabelName"):GetComponent("UILabel")
	self.LabelSelectCost = Find(descGO,"LabelCost"):GetComponent("UILabel")
	self.LabelSelectContinue = Find(descGO,"LabelContinue"):GetComponent("UILabel")
	self.LabelSelectDesc = Find(descGO,"LabelDesc"):GetComponent("UILabel")
	self.BtnRelease = Find(self.gameObject,"Skills/BtnRelease")
	local releaseSkill = function (go)
		--如果现在禁止使用技能，那么
		if(SkillCtrl.IsSkillForbid(self.curSelectSkillCfg.id)) then return end
		self:OnReleaseSkill(self.curSelectSkillCfg.id)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(self.BtnRelease,releaseSkill)
	Find(self.BtnRelease,"Label"):GetComponent("UILabel").text = L("释放技能")

	self.BtnExit = Find(self.gameObject,"BtnExit")
	local exitScene = function (go)
		LH.Play(go,"Play")
		 MainCtrl.C2SRoomExitRoom()
	end
	LH.AddClickEvent(self.BtnExit,exitScene)

	self.BtnGunLeft = Find(self.gameObject,"Guns/BtnLeft")
	self.BtnGunRight = Find(self.gameObject,"Guns/BtnRight")
	local changeGunAdd = function (go)
		LH.Play(go,"Play")
		self:ChangeGun(1)
	end
	local changeGunSub = function (go)
		LH.Play(go,"Play")
		self:ChangeGun(-1)
	end
	LH.AddClickEvent(self.BtnGunLeft,changeGunSub)
	LH.AddClickEvent(self.BtnGunRight,changeGunAdd)

	self.BtnChangeGun = Find(self.gameObject,"Guns/BtnChange")
	local changeGun = function (go)
		self:OnClickChangeGun()
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(self.BtnChangeGun,changeGun)

	self.BtnUseGun = Find(self.gameObject,"Guns/GunInfo/Container/BtnUse")
	local useGun = function (go)
		LH.Play(go,"Play")
		PlayCtrl.C2SSceneChangeGun(self.curSelectGunCfg.id)
		LogColor("#ff0000","UseGun",self.curSelectGunCfg.id)
	end
	LH.AddClickEvent(self.BtnUseGun,useGun)
	Find(self.BtnUseGun,"Label"):GetComponent("UILabel").text = L("装配炮台")

	self.BtnHasUsedGun = Find(self.gameObject,"Guns/GunInfo/Container/BtnHasUsed")
	Find(self.BtnHasUsedGun,"Label"):GetComponent("UILabel").text = L("已装配")

	self.BtnGetGun = Find(self.gameObject,"Guns/GunInfo/Container/BtnGet")
	local getGun = function (go)
		LH.Play(go,"Play")
		LogColor("#ff0000","GetGun",self.curSelectGunCfg.id)
	end
	LH.AddClickEvent(self.BtnGetGun,getGun)
	Find(self.BtnGetGun,"Label"):GetComponent("UILabel").text = L("获取炮台")

	self.LabelGunDesc = Find(self.gameObject,"Guns/GunInfo/Container/Desc/Label"):GetComponent("UILabel")
	self.LabelGunName = Find(self.gameObject,"Guns/LabelGunName"):GetComponent("UILabel")
	self.GunItemTemplate = Find(self.gameObject,"Guns/GunInfo/Container/Items/Item")
	self.GunItemTemplate.gameObject:SetActive(false)

	self.ListGunItem = {}
	self.ContainerTable = Find(self.gameObject,"Guns/GunInfo/Container"):GetComponent("UITable")
	self.ItemsTable = Find(self.gameObject,"Guns/GunInfo/Container/Items"):GetComponent("UITable")

	--界面显示炮的配置
	self.curSelectGunCfg = nil
	--当前选择场景炮的索引
	self.curShowGunIndex = nil
	self.curSelectSkillCfg = nil
end

function SkillView:AddEnergy()
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

function SkillView:OnCurItemRelease(lt,curentGO,targetGO)
	LogColor("#ff0000","OnCurItemRelease",targetGO.transform.parent.name)
	if(targetGO.transform.parent.name == self.CurContainer.name)then
		if(curentGO.name ~= targetGO.name)then
			--向后端发送交换协议
			local firstIndex = tonumber(curentGO.name)
			local secondIndex = tonumber(targetGO.name)
			if(firstIndex ~= secondIndex and firstIndex ~= 4 and secondIndex ~= 4) then
				--发送更换技能
				SkillCtrl.C2SSkillSwapSkill(firstIndex,secondIndex)
			elseif(firstIndex == 4 or secondIndex == 4) then
				HelpCtrl.Msg(L("不能替换固定技能位置"))
			end
		end
	end
end

function SkillView:OnSkillItemRelease(lt,curentGO,targetGO)
	if(targetGO.transform.parent.name == self.CurContainer.name)then
		local skillID = tonumber(curentGO.name)
		local index = tonumber(targetGO.name)
		if(not table.contains(SkillCtrl.mode.SkillList,skillID)) then
			if(index == 4) then
				HelpCtrl.Msg(L("不能替换固定技能位置"))
			else
				SkillCtrl.C2SSkillSetSkill(index,skillID)
			end
		else
			HelpCtrl.Msg(L("此技能已装配"))
		end
		LogColor("#ff0000","index",index,"skillID",skillID)
	end
end

function SkillView:OnItemStartChangeDepth(go)
	local count = go.transform.childCount
	for i=1,count do
		local widget = go.transform:GetChild(i - 1):GetComponent("UIWidget")
		widget.depth = widget.depth + 50
	end
end

function SkillView:OnReleaseSkill(skillID)
	if(table.contains(GlobalDefine.LockSkill,skillID)) then
		HelpCtrl.Msg(L("功能尚未开启！"))
		return
	end
	SkillCtrl.C2SSkillUseSceneSkill(skillID)
end

function SkillView:UpdateSkillIcon(go,skillId)
	local sprite = go.transform:Find("Icon"):GetComponent("UISprite")
	local isLock = table.contains(GlobalDefine.LockSkill,skillId)
	local collider = go:GetComponent("BoxCollider")
	if(collider ~= nil) then
		collider.enabled = not isLock
	end
	local lock = go.transform:Find("Lock")
	if(lock ~= nil) then
		lock.gameObject:SetActive(isLock)
	end
	sprite.spriteName = "skillID_"..skillId
end

function SkillView:SelectSkillIcon(skillId)
	self.curSelectSkillCfg = Res.skill[skillId]

	for k,v in pairs(self.ListSkillItem) do
		local isSelect = tonumber(v.name) == skillId
		local selectGO = v.transform:Find("Select")
		selectGO.gameObject:SetActive(isSelect)
	end

	--更新选择信息
	self:UpdateSkillIcon(self.SelectSkillItem,self.curSelectSkillCfg.id)
	LB(self.LabelSelectName,"{1}",self.curSelectSkillCfg.name)
	LB(self.LabelSelectCost,"消耗能量:{1}格",self.curSelectSkillCfg.use_sp)
	local continueStr
	if(self.curSelectSkillCfg.run_time <= 0) then
		continueStr = L("持续时间:无")
	else
		continueStr = L("持续时间:{1}秒",self.curSelectSkillCfg.run_time)
	end
	LFix(self.LabelSelectContinue,continueStr)
	-- self.LabelSelectDesc.text = L("技能描述:{1}",self.curSelectSkillCfg.description)
	LB(self.LabelSelectDesc,"技能描述:{1}",self.curSelectSkillCfg.description)
end

function SkillView:AfterOpenView(t)
	--更新当前选择的技能列表
	self:UpdateCurSkillListItem()

	--选择技能
	for i=1,#SortRes.Skill do
		if(not table.contains(GlobalDefine.LockSkill,SortRes.Skill[i].id)) then
			self:SelectSkillIcon(SortRes.Skill[i].id)
			break
		end
	end
	--更新当前炮
	self:UpdateUIGun()

	--添加事件
	self:InitListener(true)
end

function SkillView:InitListener(isAdd)
	if(isAdd) then
		self.OnSetSkill = function (index,skillID)
			-- body
			self:UpdateCurSkillListItem()
		end
		SkillCtrl.AddEvent(SkillEvent.OnSetSkill,self.OnSetSkill)
		self.OnUseSceneSkill = function (skillID)
			-- body
		end
		SkillCtrl.AddEvent(SkillEvent.OnUseSceneSkill,self.OnUseSceneSkill)
		self.OnSwapSkill = function (index1,index2)
			-- body
			self:UpdateCurSkillListItem()
		end
		SkillCtrl.AddEvent(SkillEvent.OnSwapSkill,self.OnSwapSkill)

		--[[self.OnSceneChangeGun = function (objID,gunID)
			local index = 1
			for i=1,#SortRes.Gun do
				if(SortRes.Gun[i] == gunID)then
					index = i
					break
				end
			end
		--	self:UpdateGunByIndex(index)
		end
		PlayCtrl.AddEvent(PlayEvent.PlayCtrl_ChangeGun,self.OnSceneChangeGun)]]

		
		self.OnPlayInfoChange = function (keys)
			--更新当前显示炮(界面)
			--self:UpdateUIGun()
			if(keys ~= nil) then
				if(table.contains(keys,AttrDefine.ATTR_BATTERYID)) then
					local curGunID = LoginCtrl.GetCurGunId()
					LogColor("#ff0000","OnPlayInfoChange",curGunID)
					self:UpdateUIGunByCfg(Res.gun[curGunID])
				end
			end
			
		end
		EventMgr.AddEvent(ED.MainCtrl_PlayInfoChange,self.OnPlayInfoChange)
		
		self.OnSceneChangeGun = function (t)
			LogColor("#ff0000","OnSceneChangeGun",t[2])
			self:UpdateUIGunByCfg(Res.gun[t[2]])
		end
		PlayCtrl.AddEvent(PlayEvent.PlayCtrl_ChangeGun,self.OnSceneChangeGun)
	else
		SkillCtrl.RemoveEvent(SkillEvent.OnSetSkill,self.OnSetSkill)
		SkillCtrl.RemoveEvent(SkillEvent.OnUseSceneSkill,self.OnUseSceneSkill)
		SkillCtrl.RemoveEvent(SkillEvent.OnSwapSkill,self.OnSwapSkill)

		--PlayCtrl.RemoveEvent(PlayEvent.PlayCtrl_ChangeGun,self.OnSceneChangeGun)

		EventMgr.RemoveEvent(ED.MainCtrl_PlayInfoChange,self.OnPlayInfoChange)

		PlayCtrl.RemoveEvent(PlayEvent.PlayCtrl_ChangeGun,self.OnSceneChangeGun)

		self.OnSetSkill = nil
		self.OnUseSceneSkill = nil
		self.OnSwapSkill = nil
		--self.OnSceneChangeGun = nil
		self.OnPlayInfoChange = nil
		self.OnSceneChangeGun = nil

	end
end

function SkillView:UpdateCurSkillListItem()
	local list = SkillCtrl.mode.SkillList
	local index =1
	for i=1,#list do
		local skillID = list[i]
		local go = self.ListCurSkillItem[i].gameObject
		go:SetActive(true)
		self:UpdateSkillIcon(go,skillID)
		index = index + 1
	end
	for i=index,#self.ListCurSkillItem do
		self.ListCurSkillItem[i].gameObject:SetActive(false)
	end
	local percent = LoginCtrl.mode.S2CEnterGame.sp / Res.misc[1].max_sp
	self.UIProgress:UpdateProgress(percent)
end

function SkillView:UpdateUIGun()
	local curGunID = LoginCtrl.GetCurGunId()
	local index = 1
	for i=1,#SortRes.Gun do
		if(SortRes.Gun[i] == curGunID)then
			index = i
			break
		end
	end
	self:UpdateGunByIndex(index)
	--更新当前显示炮(界面)
	self:UpdateUIGunByCfg(Res.gun[curGunID])
end


function SkillView:UpdateUIGunByCfg(cfg)
	self.curSelectGunCfg = cfg
	LB(self.LabelGunDesc,"{1}",cfg.DetailDesc)
	LB(self.LabelGunName,"{1}",cfg.name)

	local hasGetGun = LoginCtrl.HasGetGun(cfg.id)
	local IsCurGun = LoginCtrl.IsCurGun(cfg.id)
	LogColor("#ff0000","IsCurGun",IsCurGun)
	self.BtnUseGun.gameObject:SetActive(hasGetGun and not IsCurGun)
	self.BtnHasUsedGun.gameObject:SetActive(hasGetGun and IsCurGun)
	self.BtnGetGun.gameObject:SetActive(not hasGetGun)

	local count = #cfg.Desc - #self.ListGunItem
	if(count > 0) then
		for i=1,count do
			local temp = LH.GetGoBy(self.GunItemTemplate,self.GunItemTemplate.transform.parent.gameObject)
			table.insert(self.ListGunItem,temp)
		end
	end
	local index = 1
	for i=1,#cfg.Desc do
		self.ListGunItem[i].gameObject:SetActive(true)
		self:UpdateUIGunItemDesc(self.ListGunItem[i].gameObject,cfg.Desc[i])
		index = index + 1
	end
	for i=index,#self.ListGunItem do
		self.ListGunItem[i].gameObject:SetActive(false)
	end
	self.ItemsTable:Reposition()
	self.ContainerTable:Reposition()

	for i=1,#SortRes.Gun do
		if(SortRes.Gun[i].id == cfg.id) then
			self.curShowGunIndex = i
			break
		end
	end
end

function SkillView:UpdateUIGunItemDesc(go,info)
	local sprite = go.transform:Find("Icon"):GetComponent("UISprite")
	local label = go.transform:Find("Label"):GetComponent("UILabel")
	sprite.spriteName = "bulletDesc_"..info[1]
	LB(label,"{1}",info[3])
end

function SkillView:UpdateGunByIndex(index)
	if(self.curShowGunIndex == index)then return end
	local id = SortRes.Gun[index].id
	PersonalCenterCtrl.C2SAttrSetSceneBatteryId(id)
	--PlayCtrl.C2SSceneChangeGun(id)
end

function SkillView:ChangeGun(offset)
	local index = self.curShowGunIndex + offset
	index = (index - 1) % #SortRes.Gun
	LogColor("#ff0000","BeforeChangeGun",index)
	if(index < 0)then index = index + #SortRes.Gun end
	index = index + 1
	LogColor("#ff0000","ChangeGun",index)
	self:UpdateGunByIndex(index)
end

function SkillView:OnClickChangeGun()
	local onChange = function (gunID)
		PersonalCenterCtrl.C2SAttrSetSceneBatteryId(gunID)
	end
	ChangeGunCtrl.ShowView(onChange)
end

function SkillView:BeforeCloseView()
	self:InitListener(false)
	self.curSelectGunCfg = nil
	self.curShowGunIndex = nil
	self.curSelectSkillCfg = nil
end

function SkillView:OnDestory()
	self.UIProgress:Dispose()
end