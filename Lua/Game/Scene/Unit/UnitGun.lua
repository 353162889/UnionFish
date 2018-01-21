require 'Game/Scene/Component/StateComponent'
require 'Game/Scene/Component/BubbleNumComponent'
require "Game/Scene/Cmd/UI/Cmd_GunBubbleNumShow"
require "Game/Scene/Cmd/UI/Cmd_DelayTime"
UnitGun = {}

function UnitGun:New(container)
	local o = {}
	o.tableName = "UnitGun"
	o.bulletExtParam = {}
	o.stateComponent = StateComponent:New(o)
	o.container = container
	o.bubbleNumComponentDic = {}
	for i=1,3 do
		local bubbleTemplate = o.container.transform:FindChild("BubbleNumBox/Template"..i).gameObject
		bubbleTemplate:SetActive(false)
		o.bubbleNumComponentDic[i] = BubbleNumComponent:New(o,bubbleTemplate)
	end
	o.bubbleNumSequence = CommandDynamicSequence.new(false)

	o.tips = o.container.transform:FindChild("Tips").gameObject
	o.tips:SetActive(false)
	o.tipsWidget = o.tips:GetComponent("UIWidget")
	o.tipsTA = o.tips:GetComponent("TweenAlpha")

	local gunObj = o.container.transform:FindChild("Gun")
	o.gun = gunObj
	o.gunTex = gunObj:FindChild("Gun"):GetComponent("UITexture")
	o.collider = o.gun:GetComponent("BoxCollider")
	o.gunModel = UIModelMgr.CreateModel(o.gunTex,false,60,false)
	o.tp = o.container:GetComponent("TweenPosition")
	o.btn_1 = o.container.transform:FindChild("Btn_1"):GetComponent("TweenPosition")
	o.btn_2 = o.container.transform:FindChild("Btn_2"):GetComponent("TweenPosition")
	o.change = o.container.transform:FindChild("Change"):GetComponent("TweenPosition")
	o.label_change = o.container.transform:FindChild("Change/Label"):GetComponent("UILabel")
	o.label_change.text = L("换炮")
	o.label_rate = o.container.transform:FindChild("S/Str"):GetComponent("UILabel")
	o.label_gold = o.container.transform:FindChild("S/Gold"):GetComponent("UILabel")

	o.info = o.container.transform:FindChild("Info")
	local reqOtherInfo = function (go)
		o:OnReqOtherInfo(go)
	end
	LH.AddClickEvent(o.info.gameObject,reqOtherInfo)
	o.infoTP = o.info:GetComponent("TweenPosition")
	o.infoTS = o.info:GetComponent("TweenScale")
	o.playerPic = o.info.transform:FindChild("Icon/Pic"):GetComponent("UISprite")
	o.labelName = o.info.transform:FindChild("LabelName"):GetComponent("UILabel")
	o.labelLevel = o.info.transform:FindChild("LabelLevel"):GetComponent("UILabel")
	o.info.transform:FindChild("LabelDesc"):GetComponent("UILabel").text = L("点击查看详细资料")
	o.spriteVIP = o.info.transform:FindChild("VIP"):GetComponent("UISprite")
	--o.info.gameObject:SetActive(false)
	o.info.transform.localScale = Vector3.zero

	o.effectContainer = o.container.transform:FindChild("Effect").gameObject
	o.btn_1.gameObject:SetActive(false)
	o.btn_2.gameObject:SetActive(false)
	o.change.gameObject:SetActive(false)
	o.btn_1:GetComponent("UIWidget").depth = -1
	o.btn_2:GetComponent("UIWidget").depth = -1
	o.change:GetComponent("UIWidget").depth = -1
	o.hasShowBtns = false
	o.hasShowInfos = false
	o.info.gameObject:SetActive(false)
	o.attackSpeedRate = 1			--攻击速度倍率
	local clickPlusRate = function (go)
		o:OnClickPlusRate(go)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(o.btn_2.gameObject,clickPlusRate)
	local clickSubRate = function (go)
		o:OnClickSubRate(go)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(o.btn_1.gameObject,clickSubRate)
	local clickChangeGun = function (go)
		o:OnClickChangeGun(go)
		LH.Play(go,"Play")
	end
	LH.AddClickEvent(o.change.gameObject,clickChangeGun)

	local dragGun = function (g,v2)
		o:OnDragGun(g,v2)
	end
	LH.AddDragEvent(o.gun.gameObject,dragGun)
	local pressGun = function (g,state)
		o:OnPressGun(g,state)
	end
	LH.AddPressEvent(o.gun.gameObject,pressGun)

	o.sendBulletTime = Time.time
	--o.isOutBreak = false
	o.PressTime = 0
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitGun:GetCenterPos()
	return self.container.transform.localPosition + self.gun.transform.localPosition
end

function UnitGun:GetCenterOffset()
	return self.gun.transform.localPosition
end

function UnitGun:ChangeAttackSpeedRate(rate)
	self.attackSpeedRate = rate
end

function UnitGun:OnInitState(listStateInfo)
	self.stateComponent:Reset()
	for i,v in ipairs(listStateInfo) do
		self.stateComponent:InitState(v.id,v)
	end
end

function UnitGun:ShowBubbleNumSequence(type,num,color,firstDelay)
	if(self.bubbleNumSequence:ChildCount() <= 0) then
		local delayCmd = Cmd_DelayTime.new(firstDelay)
		self.bubbleNumSequence:AddSubCommand(delayCmd)
	end
	local cmd = Cmd_GunBubbleNumShow.new(self,type,num,color)
	self.bubbleNumSequence:AddSubCommand(cmd)
end

function UnitGun:ShowBubbleNum(type,num,color)
	local component = self.bubbleNumComponentDic[type]
	if(component ~= nil) then
		component:ShowNum(Vector3.New(58.7,30,0),num,color)
	else
		LogError("#ff0000","找不到类型为"..type.."的bubble组件")
	end
end

function UnitGun:OnUpdateState(listStateInfo)
	for i,v in ipairs(listStateInfo) do
		self.stateComponent:UpdateState(v.id,v)
	end
end

function UnitGun:OnDeleteState(listStateID)
	for i,v in ipairs(listStateID) do
		self.stateComponent:RemoveState(v)
	end
end

function UnitGun:IsOutBreak()
	local stateID = GlobalDefine.OutBreakID
	return self.stateComponent:HasState(stateID)
	--return self.isOutBreak
end

function UnitGun:GetCurGunRate()
	return self.roleData.gun_level
end

function UnitGun:OnReqOtherInfo(go)
	PersonalCenterCtrl.C2SAttrGetRoleInfo(self.roleData.user_name)
end

function UnitGun:OnClickPlusRate(go)
	--当前炮倍
	local rate = self:GetCurGunRate()
	local index = self:GetRateIndex(rate)
	if(index < 0) then return end
	index = index + 1
	local nextRate
	if(index > #SortRes.Gun_Unlock or SortRes.Gun_Unlock[index].rate > self:GetCurMaxGunRate()) then
		--如果超过最大值
		LogColor("#ff0000","超过最大炮倍",self:GetCurMaxGunRate(),"当前索引",index)
		nextRate = self:GetCurMinGunRate()
	else
		nextRate = SortRes.Gun_Unlock[index].rate
	end
	if(rate == nextRate) then return end
	--发送改变炮倍协议
	PlayCtrl.C2SSceneSetGunLevel(nextRate)
	self:DelayHideBtns()
end

function UnitGun:OnClickSubRate(go)
	--当前炮倍
	local rate = self:GetCurGunRate()
	local index = self:GetRateIndex(rate)
	if(index < 0) then return end
	index = index - 1
	local nextRate
	if(index < 1 or SortRes.Gun_Unlock[index].rate < self:GetCurMinGunRate()) then
		--如果超过最大值
		LogColor("#ff0000","小于最小炮倍",self:GetCurMinGunRate(),"当前索引",index)
		nextRate = self:GetCurMaxGunRate()
	else
		nextRate = SortRes.Gun_Unlock[index].rate
	end
	if(rate == nextRate) then return end
	--发送改变炮倍协议
	PlayCtrl.C2SSceneSetGunLevel(nextRate)
	self:DelayHideBtns()
end

function UnitGun:OnClickChangeGun(go)
	--[[if(self.roleData.weapon == 4000001)then
		PlayCtrl.C2SSceneChangeGun(4000002)
	else
		PlayCtrl.C2SSceneChangeGun(4000001)
	end]]
	local OnChangeGun = function (gunID)
		PlayCtrl.C2SSceneChangeGun(gunID)
		--换炮指引
		if(GuideCtrl.HasGuide()) then
			GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.ChangeGun})
		end
	end
	ChangeGunCtrl.ShowView(OnChangeGun)
	self:DelayHideBtns()
end

function UnitGun:OnDragGun(g,v2)
	if(self:IsMe()) then
		if(Time.time - self.PressTime > 0.15) then
			local v3 = g.transform.parent.localPosition
			g.transform.parent.localPosition = Vector3.New((UnityEngine.Input.mousePosition.x - UnityEngine.Screen.width/2)*(1280/UnityEngine.Screen.width),v3.y,0)
		end
	end
end
function UnitGun:OnPressGun(g,state)
	if(self:IsMe()) then
		if(self.tips.activeSelf) then
			self.tips:SetActive(false)
		end
		if state then
			self.PressTime = Time.time
			if(not self.tips.activeSelf) then
				self.tips:SetActive(true)
				self.tipsWidget.alpha = 0
				self.tipsTA:ResetToBeginning()
				self.tipsTA:PlayForward()
			end
		else
			if(Time.time - self.PressTime < 0.15) then
				self:ShowBtns(not self.hasShowBtns)
			else
				PlayCtrl.C2SSceneMoveGun(g.transform.parent.localPosition.x,g.transform.localEulerAngles.z)
			end
		end
	else
		if state then
			self.PressTime = Time.time
		else
			if(Time.time - self.PressTime < 0.15) then
				self:ShowInfos(not self.hasShowInfos)
			end
		end
	end
end

function UnitGun:GetRateLevel(gunRate)
	local isLandID = MainCtrl.mode.CurIslandId
	local gunRateRange = Res.island[isLandID].gun_rate_range
	local min = gunRateRange[1]
	local max = gunRateRange[2]
	if(gunRate < min or gunRate > max) then
		LogError("gunRate can not to level,gunRate:"..gunRate)
		return -1
	end
	local perRate = (max - min + 1) / 3.0
	local subRate = gunRate - min
	for i=1,3 do
		if(subRate < math.ceil(perRate * i)) then
			return i
		end
	end
	LogError("gunRate can not to level,gunRate:"..gunRate)
	return -1
end

function UnitGun:GetCurMinGunRate()
	local isLandID = MainCtrl.mode.CurIslandId
	local gunRateRange = Res.island[isLandID].gun_rate_range
	return tonumber(gunRateRange[1])
end

function UnitGun:GetCurMaxGunRate()
	local isLandID = MainCtrl.mode.CurIslandId
	local gunRateRange = Res.island[isLandID].gun_rate_range
	local maxGunRate = tonumber(gunRateRange[2])
	if(self.roleData.max_gun_level < maxGunRate) then
		maxGunRate = self.roleData.max_gun_level
	end
	return maxGunRate
end

function UnitGun:GetRateIndex(gunRate)
	local count = #SortRes.Gun_Unlock
	for i=1,count do
		if(gunRate <= SortRes.Gun_Unlock[i].rate) then
			return i
		end
	end
	LogError("not exist gunRate:",gunRate)
	return -1
end

function UnitGun:OnGunRateChange(gunRate)
	local preGunRate = self:GetCurGunRate()
	self.roleData.gun_level = gunRate
	self:RefreshShow()
	local curLevel = self:GetRateLevel(self:GetCurGunRate())
	local preLevel = self:GetRateLevel(preGunRate)
	if(preGunRate > gunRate) then
		--减少炮倍
		PlaySound(AudioDefine.GunDownRate,nil)
		if(curLevel ~= preLevel and not self:IsOutBreak()) then
			if(math.abs(curLevel - preLevel) > 1) then
				--从最大到最小
				self:PlayChangeUpgradeAnim(true)
			else
				--播放降级动画
				self:PlayUpgradeAnim(false)
			end
			
		else
			--播放炮倍改变动画
			self:PlayRateAnim(self:IsOutBreak())
		end
	elseif(preGunRate < gunRate) then
		--增加炮倍
		PlaySound(AudioDefine.GunUpRate,nil)
		if(curLevel ~= preLevel and not self:IsOutBreak()) then
			if(math.abs(curLevel - preLevel) > 1) then
				--从最小到最大
				self:PlayChangeUpgradeAnim(false)
			else
				--播放升级动画
				self:PlayUpgradeAnim(true)
			end
		else
			--播放炮倍改变动画
			self:PlayRateAnim(self:IsOutBreak())
		end
	end
end

function UnitGun:UpdateGunRateShow()
	self.label_rate.text = tostring(self.roleData.gun_level)
end

function UnitGun:UpdateGoldShow()
	self.label_gold.text = tostring(self.roleData.coin)
end

function UnitGun:RefreshShow()
	self:UpdateGunRateShow()
	self:UpdateGoldShow()
end

function UnitGun:IsMe()
	return LoginCtrl.mode.S2CEnterGame.role_id == self.roleData.role_id
end

function UnitGun:OnGunChange(weapon)
	LogColor("#ff0000","OnGunChange")
	self:UpdateWeapon(weapon)
	PlaySound(AudioDefine.ChangeGun,nil)
end

function UnitGun:UpdateGun(roleData)
	self.container.name = roleData.role_id.."_"..roleData.role_obj_id
	local preRoleData = self.roleData
	self.roleData = roleData
	self:RefreshShow()
	self:UpdateGoldShow()

	if(roleData ~= nil and roleData.status_info_list ~= nil) then
		self:OnUpdateState(roleData.status_info_list)
	end
	
	if(preRoleData == nil or preRoleData.weapon ~= self.roleData.weapon) then
		local curPos = self.container.transform.localPosition
		local pos = Vector3.New(self.roleData.pos.p_x,-360,curPos.z)
		LH.SetTweenPosition(self.tp,0,0,pos,pos)
		self:UpdateWeapon(self.roleData.weapon)
	end
end

function UnitGun:UpdateWeapon(weapon)
	local cfg = Res.gun[weapon]
	if(cfg == nil) then
		LogError("can not find gun defineID ",gunID)
		return
	end
	self.cfg = cfg
	self.roleData.weapon = weapon
	self.container.name = self.roleData.role_id.."_"..self.roleData.role_obj_id.."_"..weapon
	if(self:IsMe()) then
		self.gun:GetComponent("UIWidget").depth = 2
		self.gunTex.depth = 2
		self.container.transform.localScale = Vector3.one
	else
		self.container.transform.localScale = Vector3.New(0.9,0.9,0.9)
	end
	self.gunModel.ShowModel(cfg.Gun_path,Vector3.New(0,-3.3,-29.2),Vector3.zero,Vector3.one,nil)
	self:PlayIdleAnim()
end

function UnitGun:ShowAppearEffect()
	local frontEffectId = 40003
	local backEffectId = 40002
	local panel = GetParentPanel(self.effectContainer.gameObject)
	if(panel ~= nil) then
		local OnFECallback = function (playFinish,effect)
			UnitEffectMgr.DisposeEffect(self.frontEffect)
			self.frontEffect = nil
		end
		self.frontEffect = UnitEffectMgr.ShowUIEffectInParent(self.effectContainer,frontEffectId,Vector3.zero,true,panel.startingRenderQueue + 10,OnFECallback)

		local OnBECallback = function (playFinish,effect)
			UnitEffectMgr.DisposeEffect(self.backEffect)
			self.backEffect = nil
		end
		self.backEffect = UnitEffectMgr.ShowUIEffectInParent(self.effectContainer,backEffectId,Vector3.zero,true,panel.startingRenderQueue - 10,OnBECallback)
	end
end

function UnitGun:ShowSelfEffect()
	local panel = GetParentPanel(self.effectContainer.gameObject)
	if(self:IsMe() and panel ~= nil) then
		self.selfEffect = UnitEffectMgr.ShowUIEffectInParent(self.effectContainer,40001,Vector3.zero,true,panel.startingRenderQueue - 10)
	end
end

function UnitGun:ShowBtns(isShow)
	if(self.hasShowBtns ~= isShow) then
		self.hasShowBtns = isShow
		if(not self.hasShowBtns) then
			if(self.DelayHideBtnsTimer ~= nil) then
				self.DelayHideBtnsTimer:Cancel()
			end
			self.btn_1:GetComponent("UIWidget").depth = -1
			self.btn_2:GetComponent("UIWidget").depth = -1
			self.change:GetComponent("UIWidget").depth = -1
			LH.SetTweenPosition(self.btn_1,Vector3.New(-125,40,0),Vector3.New(0,40,0),0.25,function (go)
				go:SetActive(false)
			end)
			LH.SetTweenPosition(self.btn_2,Vector3.New(125,40,0),Vector3.New(0,40,0),0.25,function (go)
				go:SetActive(false)
			end)
			LH.SetTweenPosition(self.change,Vector3.New(0,260,0),Vector3.New(0,60,0),0.25,function (go)
				go:SetActive(false)
			end)
		else
			self.btn_1.gameObject:SetActive(true)
			self.btn_2.gameObject:SetActive(true)
			self.change.gameObject:SetActive(true)
			LH.SetTweenPosition(self.btn_1,Vector3.New(0,40,0),Vector3.New(-125,40,0),0.25,function (go)
				go:GetComponent("UIWidget").depth = 3
			end)
			LH.SetTweenPosition(self.btn_2,Vector3.New(0,40,0),Vector3.New(125,40,0),0.25,function (go)
				go:GetComponent("UIWidget").depth = 3
			end)
			LH.SetTweenPosition(self.change,Vector3.New(0,60,0),Vector3.New(0,260,0),0.25,function (go)
				go:GetComponent("UIWidget").depth = 3
			end)
			self:DelayHideBtns()
		end
	end
end

function UnitGun:ShowInfos(isShow)
	LogColor("#ff0000","ShowInfos",isShow)
	if(self.hasShowInfos ~= isShow) then
		self.hasShowInfos = isShow
		if(not self.hasShowInfos) then
			if(self.DelayHideInfosTimer ~= nil) then
				self.DelayHideInfosTimer:Cancel()
			end
			LH.SetTweenPosition(self.infoTP,Vector3.New(6,260,0),Vector3.New(6,60,0),0.3,function (go)
				--go:SetActive(false)
			end)
			LH.SetTweenScale(self.infoTS,Vector3.one,Vector3.zero,0,0.3,function (go)
				self.infoTS.gameObject:SetActive(false)
			end)
		else
			LogColor("#ff0000","self.hasShowInfos",self.hasShowInfos)
			self.playerPic.spriteName = "HeadIcon_"..self.roleData.head_id
			self.labelName.text = L("姓名：{1}",self.roleData.name)
			self.labelLevel.text = L("等级：{1}",tostring(self.roleData.level))
			self.spriteVIP.spriteName = "vip_"..self.roleData.vip
			-- local gender
			-- if(self.roleData.gender == 1) then
			-- 	gender = "男"
			-- else
			-- 	gender = "女"
			-- end
			--self.info.gameObject:SetActive(true)
			LH.SetTweenPosition(self.infoTP,Vector3.New(6,60,0),Vector3.New(6,260,0),0.3,function (go)
			end)
			self.infoTS.gameObject:SetActive(true)
			LH.SetTweenScale(self.infoTS,Vector3.zero,Vector3.one,0,0.3,function (go)
			end)
			--LH.SetTweenScale(self.infoTS,0,0.4,Vector3.zero,Vector3.one)
			self:DelayHideInfos()
		end
	end
end

function UnitGun:DelayHideBtns()
	if(self.DelayHideBtnsTimer ~= nil) then
		self.DelayHideBtnsTimer:Cancel()
	end
	local OnDelayFinish = function (lt)
		self:ShowBtns(false)
	end
	self.DelayHideBtnsTimer = LH.UseVP(4, 1, 0 ,OnDelayFinish,{})
end

function UnitGun:DelayHideInfos()
	if(self.DelayHideInfosTimer ~= nil) then
		self.DelayHideInfosTimer:Cancel()
	end
	local OnDelayFinish = function (lt)
		self:ShowInfos(false)
	end
	self.DelayHideInfosTimer = LH.UseVP(3, 1, 0 ,OnDelayFinish,{})
end

function UnitGun:ClientSendBullet(d)
	local deltaTime = 1
	local speed
	if(self:IsOutBreak()) then 
		speed = tonumber(self.cfg.OBGunSpeed)
	else 
		speed = tonumber(self.cfg.GunSpeed)
	end
	speed = speed * self.attackSpeedRate

	if(speed ~= nil and speed > 0) then
		deltaTime = 1.0 / speed
	end
	local curTime = Time.time
	if(curTime - self.sendBulletTime < deltaTime) then return end
	--如果是在做暴走动画，不能发射子弹
	if(self.gunModel ~= nil) then
		local animator = self.gunModel.GetAnimator()
		if(animator ~= nil) then
			local stateInfo = animator:GetCurrentAnimatorStateInfo(0)
			local level = self:GetLevel()
			local animOutbreak = level.."_2"
			local animOurbreakRev = level.."_21"
			local shortHash = stateInfo.shortNameHash
			if(shortHash == UnityEngine.Animator.StringToHash(animOutbreak) or shortHash == UnityEngine.Animator.StringToHash(animOurbreakRev)) then
				return
			end
		end
	end

	local pos = self:GetCenterPos()
	--local pos = self.container.transform.localPosition
	local bulletList = {}
	if(self:IsOutBreak())then
		bulletList = self.cfg.Outbreak
	else
		bulletList = self.cfg.Bullet
	end
	--判断当前是否可以发射子弹，如果金币不够，弹出UI
	local cost = 0
	local rate  = self:GetCurGunRate()
	for k,v in pairs(bulletList) do
		cost = cost + Res.bullet[v].useGold * rate
	end
	if(self.roleData.coin < cost and not UIMgr.isOpened("HelpTipView")) then
		if(not PersonalCenterCtrl.ShowDailyYassView()) then
			HelpCtrl.OpenConfirmView(L("金币不足"),L("可以去商城购买金币哦!"),function ()
				UIMgr.OpenView("ShopView",1)
			end,nil,L("商 城"))
		end
		return
	end

	for i=1,#bulletList do
		PlayCtrl.C2SSceneSendBullet(tonumber(bulletList[i]),pos.x,pos.y,d)
	end
	self.sendBulletTime = curTime

	self:ShowBtns(false)
end

function UnitGun:ServerSendBullet(msg)
	self.gun.transform.localEulerAngles = Vector3.New(0,0,msg.angle)
--	LogColor("#ff0000","curGunRate",self:GetCurGunRate())
	self:PlayAttackAnim(self:IsOutBreak())
	BulletMgr.LaunchBullet(msg,self.bulletExtParam)
	local cfg = Res.gun[self.roleData.weapon]
	if(cfg ~= nil and cfg.Sound > 0) then
		PlaySound(cfg.Sound,nil)
	end
end

function UnitGun:SetBulletExtParam(key,value)
	self.bulletExtParam[key] = value
end

function UnitGun:SyncGunPos(gunPosInfo)
	local curPos = self.container.transform.localPosition
	local curAngle = self.gun.transform.localEulerAngles
	LH.SetTweenPosition(self.tp,0,0.25,curPos,Vector3.New(gunPosInfo.point,curPos.y,curPos.z))
	self.gun.transform.localEulerAngles = Vector3.New(curAngle.x,curAngle.y,gunPosInfo.angle)
end

function UnitGun:PlayAnim(animName,speed)
	if(self.gunModel ~= nil) then
--		LogColor("#ff0000","播放动画",animName)
		self.gunModel.Play(animName,speed)
	end
end

function UnitGun:GetLevel()
	local curRate = self:GetCurGunRate()
	if(curRate < self:GetCurMinGunRate()) then
		curRate = self:GetCurMinGunRate()
		LogColor("#ff0000","当前炮倍小于当前渔场的最小炮倍")
	elseif(curRate > self:GetCurMaxGunRate()) then
		curRate = self:GetCurMaxGunRate()
		LogColor("#ff0000","当前炮倍大于当前渔场的最大炮倍")
	end
	return self:GetRateLevel(curRate)
end

--播放id动画
function UnitGun:PlayIdleAnim()
	local animName = self:GetLevel().."_0"
	self:PlayAnim(animName)
end

function UnitGun:PlayAttackAnim(isOutBreak)
	local level = self:GetLevel()
	local speed = 1
	if(isOutBreak) then
		level = 0 
		speed = tonumber(self.cfg.OBGunSpeed)
	else
		speed = tonumber(self.cfg.GunSpeed)
	end
	speed = speed * self.attackSpeedRate
	local animName = level.."_1"
	self:PlayAnim(animName,speed)
end

function UnitGun:PlayOutBreakAnim(isOutBreak)
	local animName = self:GetLevel().."_2"
	if(not isOutBreak) then
		animName = animName.."1"
	end
	self:PlayAnim(animName)
end

function UnitGun:PlayUpgradeAnim(isUpgrade)
	local animName
	local curLevel = self:GetRateLevel(self:GetCurGunRate())
	if(isUpgrade) then
		animName = tostring(curLevel - 1).."_32"
	else
		animName = tostring(curLevel + 1).."_31"
	end
	self:PlayAnim(animName)
end

--播放从最大到最小，最小到最大的动画
function UnitGun:PlayChangeUpgradeAnim(isMaxToMin)
	local animName
	if(isMaxToMin) then
		animName = tostring(self:GetRateLevel(self:GetCurMaxGunRate())).."_32"
	else
		animName = tostring(self:GetRateLevel(self:GetCurMinGunRate())).."_31"
	end
	self:PlayAnim(animName)
end

function UnitGun:PlayRateAnim(isOutBreak)
--	LogColor("#ff0000","[OnClickPlusRate]isOutBreak",isOutBreak)
	local level = self:GetLevel()
	if(isOutBreak) then level = 0 end
	local animName = level.."_33"
	self:PlayAnim(animName)
end

function UnitGun:ShowCollider()
	self.collider.enabled = true
end

function UnitGun:HideCollider()
	self.collider.enabled = false
end


function UnitGun:Dispose()
	for k,v in pairs(self.bubbleNumComponentDic) do
		v:Dispose()
	end
	self.bubbleNumComponentDic = {}
	if(self.bubbleNumSequence ~= nil) then
		self.bubbleNumSequence:OnDestroy()
		self.bubbleNumSequence = nil
	end
	self.bulletExtParam = {}
	if(self.stateComponent ~= nil) then
		self.stateComponent:Clear()
		self.stateComponent = nil
	end
	if(self.DelayHideBtnsTimer ~= nil) then
		self.DelayHideBtnsTimer:Cancel()
	end
	if(self.DelayHideInfosTimer ~= nil) then
		self.DelayHideInfosTimer:Cancel()
	end
	if(self.frontEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.frontEffect)
		self.frontEffect = nil
	end
	if(self.backEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.backEffect)
		self.backEffect = nil
	end
	if(self.selfEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.selfEffect)
		self.selfEffect = nil
	end
	if(self.gunModel ~= nil) then
		self.gunModel.HideModel()
		self.gunModel.DestroyModel()
		self.gunModel = nil
	end
	if(self.container ~= nil) then
		UnityEngine.GameObject.Destroy(self.container)
		self.container = nil
	end
end
