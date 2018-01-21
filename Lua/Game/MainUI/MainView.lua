require 'Game/Scene/Unit/UnitBullet'
MainView=Class(BaseView)

function MainView:ConfigUI()
	self.Left = Find(self.gameObject,"View/Left")
	self.LeftTweenPosition = self.Left:GetComponent("TweenPosition")

	--签到提示
	self.SignHintIcon=Find(self.gameObject,"View/BtnBox/Btn_10/SingHintIcon")

	self.Btn_1 = Find(self.gameObject,"View/BtnBox/Btn_1")
	LH.AddClickEvent(self.Btn_1,self.this.OnClickBtn)
	self.Btn_2 = Find(self.gameObject,"View/BtnBox/Btn_2")
	LH.AddClickEvent(self.Btn_2,self.this.OnClickBtn)
	self.Btn_3 = Find(self.gameObject,"View/BtnBox/Btn_3")
	LH.AddClickEvent(self.Btn_3,self.this.OnClickBtn)
	self.Btn_4 = Find(self.gameObject,"View/BtnBox/Btn_4")
	LH.AddClickEvent(self.Btn_4,self.this.OnClickBtn)
	self.Btn_5 = Find(self.gameObject,"View/BtnBox/Btn_5")
	LH.AddClickEvent(self.Btn_5,self.this.OnClickBtn)
	self.Btn_6 = Find(self.gameObject,"View/BtnBox/Btn_6")
	LH.AddClickEvent(self.Btn_6,self.this.OnClickBtn)
	self.Btn_7 = Find(self.gameObject,"View/BtnBox/Btn_7")
	LH.AddClickEvent(self.Btn_7,self.this.OnClickBtn)
	self.Btn_8 = Find(self.gameObject,"View/BtnBox/Btn_8")
	LH.AddClickEvent(self.Btn_8,self.this.OnClickBtn)
	self.Btn_9 = Find(self.gameObject,"View/BtnBox/Btn_9")
	LH.AddClickEvent(self.Btn_9,self.this.OnClickBtn)
	self.Btn_10 = Find(self.gameObject,"View/BtnBox/Btn_10")
	LH.AddClickEvent(self.Btn_10,self.this.OnClickBtn)
	self.Btn_11 = Find(self.gameObject,"View/BtnBox/Btn_11")
	LH.AddClickEvent(self.Btn_11,self.this.OnClickBtn)
	self.Btn_12 = Find(self.gameObject,"View/BtnBox/Btn_12")
	LH.AddClickEvent(self.Btn_12,self.this.OnClickBtn)
	self.Btn_13 = Find(self.gameObject,"View/BtnBox/Btn_13")
	LH.AddClickEvent(self.Btn_13,self.this.OnClickBtn)
	self.Btn_14 = Find(self.gameObject,"View/BtnBox/Btn_14")
	LH.AddClickEvent(self.Btn_14,self.this.OnClickBtn)


	self.Bottom_SpriteTR = Find(self.gameObject,"View/Bottom/Sprite"):GetComponent("TweenRotation")

	self.Bottom_Container = Find(self.gameObject,"View/Bottom/Container")
	local clickBottomCenterBtn = function (go)
		self:OnClickBottomCenterBtn(go)
	end
	LH.AddClickEvent(self.Bottom_Container,clickBottomCenterBtn)

	self.BtnStart = Find(self.gameObject,"View/Bottom/Container_1/BtnStart")
	local clickQuickStart = function (go)
		LH.Play(go,"Play")
		local areaId,islandId = MainCtrl.GetFitAreaAndIsland()
		--寻宝抽奖指引
		local roomType = 3
		if(GuideCtrl.HasGuide()) then
			GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.JoinFishScene})
		end
		if(GuideCtrl.GuideJoinSigleScene()) then
			roomType = 1
		end
		MainCtrl.C2SRoomEnterRoom(islandId,roomType)
	end
	LH.AddClickEvent(self.BtnStart,clickQuickStart)
	self.Bottom_Btn_1 = Find(self.gameObject,"View/Bottom/Container/Btn_1")
	self.Bottom_Btn_2 = Find(self.gameObject,"View/Bottom/Container/Btn_2")
	self.Bottom_Btn_3 = Find(self.gameObject,"View/Bottom/Container/Btn_3")
	local clickBottomBtn = function (go)
		self:OnClickBottomBtn(go)
	end
	LH.AddClickEvent(self.Bottom_Btn_1,clickBottomBtn)
	LH.AddClickEvent(self.Bottom_Btn_2,clickBottomBtn)
	LH.AddClickEvent(self.Bottom_Btn_3,clickBottomBtn)
	self.Bottom_Label = Find(self.Bottom_Container,"Label")
	
	self.Bottom_Mask = Find(self.Bottom_Container,"Mask")
	self.Bottom_Mask:SetActive(false)
	--self.Bottom_Container_TS = self.Bottom_Container:GetComponent("TweenScale")
	self.Bottom_Container_TR = self.Bottom_Container:GetComponent("TweenRotation")
	--[[self.uiCamera = LH.GetMainUICamera()--获取到UI相机
	self.Bottom_Container_pos = self.uiCamera:WorldToScreenPoint(self.Bottom_Container.transform.position)
	self.Bottom_Btn_1_pos = self.uiCamera:WorldToScreenPoint(self.Bottom_Btn_1.transform.position)
	self.Bottom_Btn_2_pos = self.uiCamera:WorldToScreenPoint(self.Bottom_Btn_2.transform.position)
	self.Bottom_Btn_3_pos = self.uiCamera:WorldToScreenPoint(self.Bottom_Btn_3.transform.position)
	self.Bottom_Container:SetActive(false)]]

	self.Camera = nil
	self.SceneGO = nil
	self.IslandTable = {}

	self.CtrlPic = Find(self.gameObject,"ScrollView/Pic")
	local t = string.Split(Res.misc[1].BallRun,",")
	self.CtrlPic:GetComponent("UIWidget").width = t[2]*5 + LH.ScreenWidth()
	self.CtrlPic:GetComponent("UIWidget").height = t[1]*10 + LH.ScreenHeight()
	--self.CtrlPic.transform.localPosition = Vector3.New(0,220,0)
	self.ScrollView = Find(self.gameObject,"ScrollView")
	self.SpringPanel = self.ScrollView:GetComponent("SpringPanel")

	self.IsLandTitleLabel = Find(self.Left,"Title"):GetComponent("UILabel")
	self.IsLandCoinLabel = Find(self.Left,"CheckBox1/Label"):GetComponent("UILabel")
	self.IsLandCondLabel = Find(self.Left,"CheckBox2/Label"):GetComponent("UILabel")
	self.NotOpenGo = Find(self.Left,"BtnNotOpen")

	self.CheckBox1Yes = Find(self.Left,"CheckBox1/SpriteYes")
	self.CheckBox1No = Find(self.Left,"CheckBox1/SpriteNo")
	self.CheckBox2Yes = Find(self.Left,"CheckBox2/SpriteYes")
	self.CheckBox2No = Find(self.Left,"CheckBox2/SpriteNo")

	self.OpenGo = Find(self.gameObject,"View/Left/BtnOpen")
	LH.AddClickEvent(self.OpenGo,self.this.OnClickLeftBtn)

	self.AnimFishIcon = Find(self.Left,"FishIcon")
	self.AnimFishIconHelper = self.AnimFishIcon:AddComponent(typeof(SpineAnimHelper))

	self.Ctrl = Find(self.gameObject,"Ctrl")
	local onPress = function (go,state)
		self:OnPressCtrlBtn(go,state)
	end
	LH.AddPressEvent(self.Ctrl,onPress)
	--LH.AddPressEvent(self.Ctrl,self.this.OnPressCtrlBtn)
	self.PressTime = 0
	self.PressPoint = Vector3.zero
	self.AreaID = -1
	self.SelectID = -1
end

function MainView:AfterOpenView(t)
	self.SceneGO = LuaSceneMgr.SceneRoot
	self.Camera = self.SceneGO:GetComponent("SceneHelper").camera
	self.ScrollView:GetComponent("BallHelper")._Camera = self.Camera.transform.parent.gameObject

	self.AreaID = t.areaID
	self.SelectID = t.islandID
	self.CurScene = t.scene

	LH.SetTweenPosition(self.LeftTweenPosition,0,0.1,Vector3.New(720,0,0),Vector3.New(720,0,0))
	--初始化海港的位置鱼选择
	if(self.SelectID > 0) then
		local isLandInfo = Res.island[self.SelectID]
		local turn_p = GetVector3(isLandInfo.turn_p)
		--self.SpringPanel.Begin(self.ScrollView,turn_p,8)

		self.ScrollView.transform.localPosition = turn_p
	else
		--self.SpringPanel.Begin(self.ScrollView,Vector3.New(-60,-340,0),8)
		--海港位置暂时变更
		self.SpringPanel.Begin(self.ScrollView,Vector3.New(-22,-600,0),5)
	end
	
	self:UpdateSceneSelectIslandID(self.SelectID)
	if(self.SelectID > 0) then
		self:ShowIslandPanel()
	end

	--签到显示提示
	if SignCtrl.modeSign~=nil then
		if SignCtrl.modeSign.sign==0 then
			self.SignHintIcon:SetActive(true)
		else
			self.SignHintIcon:SetActive(false)
		end
	end

	self:InitListener(true)
	self:RefreshView()
end


function MainView:GetRotationDiscBtn()
	return self.Btn_8
end

function MainView:GetJoinFishSceneBtn()
	return self.Bottom_Container
end

function MainView:AddListener()
	self:AddEvent(ED.MainCtrl_S2CRoomEnterRoom,self.this.MainCtrl_S2CRoomEnterRoom)
end

function MainView:RefreshView()
	local taskInfo = TaskCtrl.GetTaskInfo(TaskType.Main,GlobalDefine.FirstRechargeTaskId)
	if(taskInfo ~= nil) then
		if(taskInfo.finish_type == 2) then
			self.Btn_9:SetActive(false)
		else
			self.Btn_9:SetActive(true)
		end
	end
end

--添加签到提示事件
function MainView:InitListener(isAdd)
	if isAdd then
		self.SignReceiveHint = function (data)
			self:OnSignReceiveHint(data)
		end
		SignCtrl.AddEvent(SignEvent.OnSignReceiveHint,self.SignReceiveHint)
		self.onRefresh = function ()
			self:RefreshView()
		end
		MainCtrl.AddEvent(MainEvent.MainCtrl_RefreshView,self.onRefresh)
		self.onTaskFinishGetBonus = function (t)
			local taskType = t[1]
			local taskId = t[2]
			if(taskType == TaskType.Main and taskId == GlobalDefine.FirstRechargeTaskId) then
				self:RefreshView()
			end
		end
		TaskCtrl.AddEvent(TaskEvent.OnTaskFinishGetBonus,self.onTaskFinishGetBonus)
	else
		if(self.SignReceiveHint ~= nil) then
			SignCtrl.RemoveEvent(SignEvent.OnSignReceiveHint,self.SignReceiveHint)
			self.SignReceiveHint = nil
		end
		if(self.onRefresh ~= nil) then
			MainCtrl.RemoveEvent(MainEvent.MainCtrl_RefreshView,self.onRefresh)
			self.onRefresh = nil
		end
		if(self.onTaskFinishGetBonus ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnTaskFinishGetBonus,self.onTaskFinishGetBonus)
			self.onTaskFinishGetBonus = nil
		end
	end
end

--关闭签到提示
function MainView:OnSignReceiveHint(data)
	if data then
		self.SignHintIcon:SetActive(false)
	end
end



function MainView:BeforeCloseView()
	if(self.Anim_Handle ~= nil) then
		self.Anim_Handle:Cancel()
		self.Anim_Handle = nil
	end
	self:InitListener(false)
end


function MainView:OnDestory()
	if(self.AnimFishIconHelper ~= nil) then
		self.AnimFishIconHelper:Dispose()
		self.AnimFishIconHelper = nil
	end
end

function MainView.MainCtrl_S2CRoomEnterRoom(t)
    EventMgr.SendEvent(ED.LoadingView_SetProgress,{0})
	--UIMgr.OpenView("PlayView",t)
	UIMgr.CloseView("MainView")
	LuaSceneMgr.EnterScene(Res.island[t[1]].playSceneID)
	--LuaSceneMgr.EnterScene(t[1])
end

function MainView.OnClickBtn(go)
	-- SoundFxManager.PlaySoundById(1,2,nil)
	if go.name == "Btn_1" then
		HelpCtrl.Msg(L("功能尚未开启！"))
	elseif go.name == "Btn_2" then
		TaskCtrl.OpenView(1)
	elseif go.name == "Btn_3" then
    	UIMgr.OpenView("BagView")
	elseif go.name == "Btn_4" then
    	MainCtrl.C2SRoomEnterRoom(GlobalDefine.AdjustFishIslandID,2)
	elseif go.name == "Btn_5" then
		UIMgr.OpenView("ShopView")
	elseif go.name == "Btn_6" then
		HelpCtrl.Msg(L("功能尚未开启！"))
		--UIMgr.OpenView("SetView")
	elseif go.name == "Btn_7" then
    	UIMgr.OpenView("RankView")
	elseif go.name == "Btn_8" then
    	RotationDiscCtrl.OpenRotationDiscView(1)
	elseif go.name == "Btn_9" then
		FirstRechargeCtrl.OpenView(Res.misc[1].FirstRechargeId)
	elseif go.name == "Btn_10" then
    	UIMgr.OpenView("SignView")
	elseif go.name == "Btn_11" then
		HelpCtrl.Msg(L("功能尚未开启！"))
		--UIMgr.OpenView("HPView")
	elseif go.name == "Btn_12" then
		HelpCtrl.Msg(L("功能尚未开启！"))
	elseif go.name == "Btn_13" then
		HelpCtrl.Msg(L("功能尚未开启！"))
	--elseif go.name == "Btn_14" then
		--UIMgr.OpenView("MainNoticeView")
	end
	LH.Play(go,"Play")
end

function MainView.OnClickLeftBtn(go)
	-- SoundFxManager.PlaySoundById(1,2,nil)
	local isLandInfo = Res.island[UIMgr.Dic("MainView").SelectID]
	if(LoginCtrl.mode.S2CEnterGame.gold < isLandInfo.gold_enter) then
		HelpCtrl.Msg(L("您的金币不足"))
		return
	end
	--播放点击声音
	PlaySound(AudioDefine.JoinFishScene,nil)
	local islandID = UIMgr.Dic("MainView").SelectID
	local roomType = 3
	if(GuideCtrl.GuideJoinSigleScene()) then
		roomType = 1
	end
	MainCtrl.C2SRoomEnterRoom(islandID,roomType)
end

function MainView:UpdateSceneSelectIslandID(islandID)
	BallScene.UpdateSelect(islandID)
end

--更改场景的区域id与选择岛屿ID
function MainView:UpdateSceneArea(areaID,islandID)
	if(self.Anim_Handle ~= nil) then
		self.Anim_Handle:Cancel()
		self.Anim_Handle = nil
	end
	--取消当前选择
	if self.SelectID ~= -1 then
		self:HideIslandPanel()
		self:UpdateSceneSelectIslandID(-1)
	end
	local preAreaID = self.AreaID
	self.AreaID = areaID
	self.SelectID = islandID
	local OnPlayAnim = function (lt)
		self.Anim_Handle = nil
		
		if(preAreaID ~= self.AreaID) then 
			self:SceneResUpdate()
		else
			--如果是同一个区域，直接回到海港，取消所有选中
			self.SelectID = -1
			--self:CloseContainerUI()
			self:ShowBottomItem()
		end 
	end
	--回到海港(播放UI动画)
	LH.SetTweenRotation(self.Bottom_Container_TR,0,0.5,Vector3.zero,Vector3.New(0,0,-360))
	LH.SetTweenRotation(self.Bottom_SpriteTR,0,0.5,Vector3.zero,Vector3.New(0,0,360))
	--暂时注释掉
	--self.SpringPanel.Begin(self.ScrollView,Vector3.New(-200,0,0),5)
	--海港位置暂时变更
	self.SpringPanel.Begin(self.ScrollView,Vector3.New(-22,-600,0),5)
	self.Anim_Handle = LH.UseVP(1, 1, 0 ,OnPlayAnim,{})
	self:HideBottomItem()
	PlaySound(AudioDefine.ReturnSeaport,nil)
end

--场景更换资源
function MainView:SceneResUpdate()
	local onResLoadFinish = function ()
		self:OnIslandLoadFinish()
	end
	BallScene.UpdateArea(self.AreaID,onResLoadFinish)
end

--回到选择岛屿id
function MainView:OnIslandLoadFinish()
	if(self.SelectID > 0) then
		self:ShowIslandPanel()
		local isLandInfo = Res.island[self.SelectID]
		local turn_p = GetVector3(isLandInfo.turn_p)
		self.SpringPanel.Begin(self.ScrollView,turn_p,5)
	end
	local OnDelay = function ()
		self:UpdateSceneSelectIslandID(self.SelectID)
		--self:CloseContainerUI()
		self:ShowBottomItem()
	end
	self.Anim_Handle = LH.UseVP(0.3, 1, 0 ,OnDelay,{})
end

function MainView:OnPressCtrlBtn(go,state)
	if state then
		self.PressTime  = os.time()
		self.PressPoint = UnityEngine.Input.mousePosition
	else
		local isClick = os.time() - self.PressTime <= 1 and Vector3.Distance(self.PressPoint,UnityEngine.Input.mousePosition) < 25 --判断是点击还是拖拽
		if(isClick)then
			local hitGo = LH.GetRay(self.Camera.gameObject)--发射线返回点击物体
			if(hitGo  ~= nil and hitGo.name == "BoxCollider") then
				local TempSelectID = tonumber(hitGo.transform.parent.gameObject.name)
				if TempSelectID ~= self.SelectID then--是否选中同一个
					self.SelectID = TempSelectID
					self:UpdateSceneSelectIslandID(self.SelectID)

					self:ShowIslandPanel()

					local isLandInfo = Res.island[self.SelectID]
					local turn_p = GetVector3(isLandInfo.turn_p)
					self.SpringPanel.Begin(self.ScrollView,turn_p,8)
				end
			else
				if self.SelectID ~= -1 then
					--取消当前选择
					self:HideIslandPanel()
					self.SelectID = -1
					self:UpdateSceneSelectIslandID(self.SelectID)
				end
			end
		else
			if self.SelectID ~= -1 then
				--取消当前选择
				self:HideIslandPanel()
				self.SelectID = -1
				self:UpdateSceneSelectIslandID(self.SelectID)
			end
		end
		self.PressTime = 0
		self.PressPoint = Vector3.zero
	end
end

function MainView:ShowIslandPanel()

	--更新弹出面板信息start
	local isLandInfo = Res.island[self.SelectID]
	PlaySound(isLandInfo.click_sound,nil)
	self.IsLandTitleLabel.text = L("{1}",isLandInfo.name)
	local desc = ""
	if(#isLandInfo.OpenType > 0) then
		local count = #isLandInfo.OpenType
		for i=1,count do
			local cond = isLandInfo.OpenType[i]
			local openCondInt = tonumber(cond[1])
			local openValue = cond[2]
			if openCondInt == 1 then
				desc = L("需要等级{1}",openValue)
			elseif openCondInt == 2 then
				desc = L("需要金币{1}",openValue)
			elseif openCondInt == 3 then
				desc = L("需要炮倍{1}",openValue)
			end
		end
	end

	LB(self.IsLandCoinLabel,"需要金币{1}",isLandInfo.gold_enter)

	local check1Yes = LoginCtrl.mode.S2CEnterGame.gold >= isLandInfo.gold_enter
	
	LogColor("#ff0000","check1Yes",check1Yes,self.SelectID)
	self.CheckBox1Yes:SetActive(check1Yes)
	self.CheckBox1No:SetActive(not check1Yes)

	local check2Yes = MainCtrl.IsIslandOpen(self.SelectID)
	self.CheckBox2Yes:SetActive(check2Yes)
	self.CheckBox2No:SetActive(not check2Yes)

	LFix(self.IsLandCondLabel,desc)
	if(BallScene.IsIslandOpen(self.SelectID)) then
		self.NotOpenGo:SetActive(false)
		self.OpenGo:SetActive(true)
	else
		self.NotOpenGo:SetActive(true)
		self.OpenGo:SetActive(false)
	end
	local fishAnimId = isLandInfo.fish
	self.AnimFishIconHelper:UpdatePath(Res.spineanim[fishAnimId].path)
    self.AnimFishIconHelper:UpdateLayer(SortingLayer.UI)
    local renderQueue = GetParentPanelRenderQueue(self.AnimFishIcon)
    self.AnimFishIconHelper:UpdateQueue(renderQueue + 10)
    self.AnimFishIconHelper:PlayAnim("Idle",true)

	--更新弹出面板信息end

	--选中岛屿面板显示Start
	LH.SetTweenPosition(self.LeftTweenPosition,0,0.25,Vector3.New(720,0,0),Vector3.New(37,24,0))
	--选中岛屿面板显示End
end

function MainView:HideIslandPanel()
	LH.SetTweenPosition(self.LeftTweenPosition,0,0.25,Vector3.New(37,24,0),Vector3.New(720,0,0))--面板
end

function MainView:HideBottomItem()
	self.Bottom_Mask:SetActive(true)
	self.Bottom_Label:SetActive(false)
end

function MainView:ShowBottomItem()
	self.Bottom_Mask:SetActive(false)
	self.Bottom_Label:SetActive(true)
end

--[[function MainView:OpenContainerUI()
	self.Bottom_Container:SetActive(true)
	LH.SetTweenScale(self.Bottom_Container_TS,0,0.2,Vector3.zero,Vector3.one)
end


function MainView:CloseContainerUI()
	-- body
	LH.SetTweenScale(self.Bottom_Container_TS,0,0.2,Vector3.one,Vector3.zero)
end
]]

function MainView:OnClickBottomBtn(go)
	if(go.name == "Btn_1") then
		self:UpdateSceneArea(1,2001001)
	elseif(go.name == "Btn_2") then
		--self:UpdateSceneArea(2,2001001)
	else
	end
end

function MainView:OnClickBottomCenterBtn(go)
	self:UpdateSceneArea(self.AreaID,-1)
end
--[[function MainView:OnPressBottomBtn(go,state)
	if(state) then
		--弹出UI
		self:OpenContainerUI()
	else
		local mp = self.uiCamera:WorldToScreenPoint(self.Bottom_Btn.transform.position)
		if(Vector3.Distance(self.Bottom_Container_pos,mp) < 40) then
			--回到港口
			self:UpdateSceneArea(self.AreaID,-1)
		elseif(Vector3.Distance(self.Bottom_Btn_1_pos,mp) < 40 and self.AreaID ~= 1) then
			self:UpdateSceneArea(1,2001001)
		elseif(Vector3.Distance(self.Bottom_Btn_2_pos,mp) < 40 and self.AreaID ~= 2) then
			self:UpdateSceneArea(2,2001001)
		elseif(Vector3.Distance(self.Bottom_Btn_3_pos,mp) < 40) then
			--self:UpdateSceneArea(1,2001001)
			self:CloseContainerUI()
		else
			self:CloseContainerUI()
		end
		go.transform.localPosition = Vector3.zero
	end
end]]

--[[function MainView:OnDragBottomBtn(go,delta)

	local centerPoint = self.Bottom_Container.transform.localPosition
	local inputPos = UnityEngine.Input.mousePosition
	inputPos.z = 1
	local nextPos = self.uiCamera:ScreenToWorldPoint(inputPos)
	go.transform.position = nextPos
	nextPos = go.transform.localPosition
	local nextDir = nextPos - centerPoint
	nextDir.z = 0--这里必须赋值为0，不然对magnitude产生影响
	if(nextDir.magnitude > 130) then
		nextPos = nextDir.normalized * 130 + centerPoint
	end
	go.transform.localPosition = nextPos
end
]]

