require 'Game/LookFor/LookFor_Cmd_ShowFirstBonus'
require 'Game/LookFor/LookFor_Cmd_ShowSelectBonus'
LookForView=Class(BaseView)

function LookForView:ConfigUI()

	Find(self.gameObject,"BG_2/Label"):GetComponent("UILabel").text = L("寻宝抽奖")
	self.Point_1 = Find(self.gameObject,"Point_1")
	Find(self.Point_1,"lbl_1"):GetComponent("UILabel").text = L("当前奖池：")
	self.Point_2 = Find(self.gameObject,"Point_2")
	self.Point_1_BG_1_lbl = Find(self.gameObject,"Point_1/BG_1/lbl")
	self.TabItem = Find(self.gameObject,"Point_1/BG_2/TabBox/TabItem")
	self.TabItem:SetActive(false)
	self.TabItemList = {}
	self.CurTab = nil
	self.Item = Find(self.gameObject,"Point_1/BG_2/ItemBox/Item")
	self.Item:SetActive(false)
	self.ItemList = {}
	self.Point_1_BG_3_lbl = Find(self.gameObject,"Point_1/BG_3/lbl")
	self.Point_1_BG_3_lbl_1 = Find(self.gameObject,"Point_1/BG_3/lbl_1")
	self.Point_1_BG_3_lbl_2 = Find(self.gameObject,"Point_1/BG_3/lbl_2")
	self.Point_1_BG_3_BG = Find(self.gameObject,"Point_1/BG_3/BG")
	self.Point_1_Btn = Find(self.gameObject,"Point_1/Btn")
	self.Point_1_Btn_Sprite = self.Point_1_Btn:GetComponent("UISprite")
	self.Point_1_Btn_lbl = Find(self.gameObject,"Point_1/Btn/lbl"):GetComponent("UILabel")
	LH.AddClickEvent(self.Point_1_Btn,self.this.OnClickPoint_1_Btn)
	self.Point_1_Btn_1 = Find(self.gameObject,"Point_1/Btn_1")
	LH.AddClickEvent(self.Point_1_Btn_1,self.this.OnClickPoint_1_Btn_1)
	
	for i=1,#Res.lotterybox do
		local temp = LH.GetGoBy(self.TabItem,self.TabItem.transform.parent.gameObject)
		temp:SetActive(true)
		temp.name = tostring(Res.lotterybox[i].id)
		temp.transform:FindChild("Pic"):GetComponent("UISprite").spriteName = "com_bt_02_"..Res.lotterybox[i].id
		LH.AddClickEvent(temp,self.this.OnClickTabBtn)
		table.insert(self.TabItemList,temp)
	end
	self.TabItem.transform.parent:GetComponent("UITable"):Reposition()

	self.EffectList = {}
	
	for i=1,6 do
		local temp = LH.GetGoBy(self.Item,self.Item.transform.parent.gameObject)
		local effectContainer = temp.transform:Find("Item/Effect").gameObject
		temp:SetActive(true)
		local effectId = 54003
		local effect = UnitEffectMgr.ShowUIEffectInParent(effectContainer,effectId,Vector3.zero,true,queue)
		effect:UpdateLayer(LayerMask.NameToLayer("UI"))
		effect.gameObject:SetActive(false)
		table.insert(self.EffectList,effect)
		table.insert(self.ItemList,temp)
	end
	self.Item.transform.parent:GetComponent("UITable"):Reposition()

	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	LH.AddClickEvent(self.CloseBtn,self.this.OnClickCloseBtn)

	self.Point_2_Mask = Find(self.gameObject,"Point_2/Mask")
	self.Point_2_Mask_TA = self.Point_2_Mask:GetComponent("TweenAlpha")
	self.Point_2_Mask:SetActive(false)
	self.Point_2_BG_lbl = Find(self.gameObject,"Point_2/BG/lbl")
	self.Point_2_BG = Find(self.gameObject,"Point_2/BG")
	self.Point_2_ItemList = {}
	self.EffectList_2 = {}
	for i=1,6 do
		local temp = Find(self.gameObject,"Point_2/ItemBox/I_"..i)
		local effectContainer = temp.transform:GetChild(0).transform:Find("Effect").gameObject
		local effectId = 54003
		local effect = UnitEffectMgr.ShowUIEffectInParent(effectContainer,effectId,Vector3.zero,true,queue)
		effect:UpdateLayer(LayerMask.NameToLayer("UI"))
		effect.gameObject:SetActive(false)
		table.insert(self.EffectList_2,effect)
		LH.AddClickEvent(temp.transform:Find(tostring(i)).gameObject,self.this.OnClickItemBoxBtn)
		table.insert(self.Point_2_ItemList,temp)
	end

	self.LookForIdx = 0
	self.timeCount = 10

	self.OpenEffect = nil
	self.OpenContinueEffect = nil

	self.AnimSequence = CommandSequence.new()
	self.IsPlayAnim = false
    
end
function LookForView.OnClickItemBoxBtn(go)
	local index = tonumber(go.name)
	UIMgr.Dic("LookForView").OpenShow(index)
	UIMgr.Dic("LookForView").AnimSequence:Clear()
end

function LookForView.OnClickPoint_1_Btn(go)
	-- if go.transform:FindChild("lbl"):GetComponent("UILabel").text == "点击抽奖" then
	-- 	UIMgr.Dic("LookForView").Point_1:SetActive(false)
	-- 	UIMgr.Dic("LookForView").Point_2:SetActive(true)

	-- 	local d = LookForCtrl.mode.S2CTreasureGetInfoData
	-- 	local idx_1 = tonumber(UIMgr.Dic("LookForView").CurTab.name)
	-- 	local idx_2 = 0
	-- 	for i=1,#Res.lotterybox do
	-- 		if Res.lotterybox[i].need_score <= d.gold_num then
	-- 			idx_2 = i
	-- 		end
	-- 	end
	-- 	UIMgr.Dic("LookForView").LookForIdx = math.min(idx_1,idx_2)

	-- 	local d = Res.lotterybox[UIMgr.Dic("LookForView").LookForIdx]
	-- 	go:SetActive(false)
	-- 	LookForCtrl.C2STreasureLottery(UIMgr.Dic("LookForView").LookForIdx)

	-- 	--UIMgr.Dic("LookForView").Point_2_View()
	-- else
	-- 	UIMgr.OpenView("FishDicView",{MainCtrl.mode.CurIslandId,1})
	-- end

	-- UIMgr.Dic("LookForView").Point_1:SetActive(false)
	-- UIMgr.Dic("LookForView").Point_2:SetActive(false)


	local d = LookForCtrl.mode.S2CTreasureGetInfoData
	if(d.gold_fish < Res.misc[1].lookfor_count) then return end
	local idx_1 = tonumber(UIMgr.Dic("LookForView").CurTab.name)
	local idx_2 = 0
	for i=1,#Res.lotterybox do
		if Res.lotterybox[i].need_score <= d.gold_num then
			idx_2 = i
		end
	end
	local index = math.min(idx_1,idx_2)
	if(index == 0 or index ~= idx_2) then return end
	UIMgr.Dic("LookForView").LookForIdx = index
	LookForCtrl.C2STreasureLottery(index)
	LogColor("#ff0000","C2STreasureLottery",index)
end

function LookForView.OnClickPoint_1_Btn_1(go)
	UIMgr.OpenView("FishDicView",{MainCtrl.mode.CurIslandId,1})
end

function LookForView.OnClickCloseBtn(go)
	if(not UIMgr.Dic("LookForView").IsPlayAnim) then
		UIMgr.CloseView("LookForView")
	end
end

function LookForView.OnClickTabBtn(go)
	if UIMgr.Dic("LookForView").CurTab ~= nil then
		local id = tonumber(UIMgr.Dic("LookForView").CurTab.name)
		UIMgr.Dic("LookForView").CurTab.transform:FindChild("Pic"):GetComponent("UISprite").spriteName = "com_bt_02_"..id
		UIMgr.Dic("LookForView").CurTab.transform:FindChild("Pic"):GetComponent("UISprite"):MakePixelPerfect()
	end
	UIMgr.Dic("LookForView").CurTab = go
	UIMgr.Dic("LookForView").CurTab.transform:FindChild("Pic"):GetComponent("UISprite").spriteName = "com_bt_01_"..tonumber(go.name)
	UIMgr.Dic("LookForView").CurTab.transform:FindChild("Pic"):GetComponent("UISprite"):MakePixelPerfect()
	UIMgr.Dic("LookForView").UpDateItemView()
end

function LookForView.UpDateItemView()
	if  UIMgr.Dic("LookForView").CurTab == nil then
		return
		LogError("未选中寻宝标签")
	end
	local idx = tonumber(UIMgr.Dic("LookForView").CurTab.name)
	local d = Res.lotterybox[idx]
	local panel = UIMgr.Dic("LookForView").gameObject:GetComponent("UIPanel")
	local queue = panel.startingRenderQueue + 10
	for i=1,#UIMgr.Dic("LookForView").ItemList do
	 	local g = UIMgr.Dic("LookForView").ItemList[i]
	 	local ts = g.transform:FindChild("Item"):GetComponent("TweenScale")
	 	UIMgr.Dic("LookForView").EffectList[i].gameObject:SetActive(false)
	 	UIMgr.Dic("LookForView").EffectList[i]:UpdateQueue(queue)
	 	LH.SetTweenScale(ts,Vector3.zero,Vector3.one,(i- 1) * 0.1,0.25,function (go)
	 		UIMgr.Dic("LookForView").EffectList[i].gameObject:SetActive(true)
	 	end)
	 	g.transform:FindChild("Item/Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[i][2]].icon
	 	g.transform:FindChild("Item/Icon"):GetComponent("UISprite"):MakePixelPerfect()
	 	g.transform:FindChild("Item/lbl"):GetComponent("UILabel").text = L("x{1}",d.items[i][3])
	end 
	UIMgr.Dic("LookForView").Point_1_BG_1_lbl:GetComponent("UILabel").text = L("{1}/{2}",tostring(LookForCtrl.mode.S2CTreasureGetInfoData.gold_num),d.need_score)
	LogColor("#ff0000","UpDateItemView(LookForView)",LookForCtrl.mode.S2CTreasureGetInfoData.gold_num)

	local _d = LookForCtrl.mode.S2CTreasureGetInfoData
	local _idx = 0
	for i=1,#Res.lotterybox do
		if Res.lotterybox[i].need_score <= _d.gold_num then
			_idx = i
		end
	end

	-- if idx ~= _idx then
	-- 	-- UIMgr.Dic("LookForView").Point_1_Btn_lbl:GetComponent("UILabel").text = "查看奖金鱼"
	-- else
	-- 	if _d.gold_fish < Res.misc[1].lookfor_count then
	-- 		-- UIMgr.Dic("LookForView").Point_1_Btn_lbl:GetComponent("UILabel").text = "查看奖金鱼"
	-- 	else
	-- 		-- UIMgr.Dic("LookForView").Point_1_Btn_lbl:GetComponent("UILabel").text = "点击抽奖"
	-- 	end
	-- end
	if(_idx ~= 0) then
		UIMgr.Dic("LookForView").Point_1_Btn_lbl.text = L("{1}抽奖",Res.lotterybox[_idx].desc)
	else
		UIMgr.Dic("LookForView").Point_1_Btn_lbl.text = L("点击抽奖")
	end
	if(_idx ~= 0 and idx == _idx and _d.gold_fish >= Res.misc[1].lookfor_count) then
		UIMgr.Dic("LookForView").Point_1_Btn_Sprite.spriteName = "com_bt_m_01"
	else
		UIMgr.Dic("LookForView").Point_1_Btn_Sprite.spriteName = "com_huianniu"
	end
	UIMgr.Dic("LookForView").Point_1_Btn_Sprite:MakePixelPerfect()
end

function LookForView:AfterOpenView(t)
	self.IsPlayAnim = false
	self.Point_1:SetActive(true)
	self.Point_2:SetActive(false)
	self.this.Point_1_View()
end

function LookForView.Point_1_View()
	local d = LookForCtrl.mode.S2CTreasureGetInfoData
	local idx = 0
	if d.gold_fish < Res.misc[1].lookfor_count then
		UIMgr.Dic("LookForView").Point_1_BG_3_lbl:GetComponent("UILabel").text = L("{1}/{2}",d.gold_fish,Res.misc[1].lookfor_count)
		UIMgr.Dic("LookForView").Point_1_BG_3_BG:GetComponent("UISprite").fillAmount = d.gold_fish/Res.misc[1].lookfor_count
		UIMgr.Dic("LookForView").Point_1_BG_3_lbl_1:GetComponent("UILabel").text = L("击杀奖金鱼数量不足")
		UIMgr.Dic("LookForView").Point_1_BG_3_lbl_2:GetComponent("UILabel").text = ""
	else
		for i=1,#Res.lotterybox do
			if Res.lotterybox[i].need_score <= d.gold_num then
				idx = i
			end
		end

		-- local d_temp = Res.lotterybox[idx+1]
		-- if idx >= #Res.lotterybox then
		-- 	d_temp = Res.lotterybox[#Res.lotterybox]
		-- end
		-- UIMgr.Dic("LookForView").Point_1_BG_3_lbl_1:GetComponent("UILabel").text = "击杀奖金鱼可继续累积奖池"
		-- UIMgr.Dic("LookForView").Point_1_BG_3_lbl_2:GetComponent("UILabel").text = d_temp.desc .. "抽奖"
		UIMgr.Dic("LookForView").Point_1_BG_3_lbl:GetComponent("UILabel").text = L("{1}/{2}",d.gold_fish,Res.misc[1].lookfor_count)
		UIMgr.Dic("LookForView").Point_1_BG_3_BG:GetComponent("UISprite").fillAmount = d.gold_fish/Res.misc[1].lookfor_count

	end
	if idx == 0 then
		-- UIMgr.Dic("LookForView").Point_1_Btn_lbl:GetComponent("UILabel").text = "查看奖金鱼"
		UIMgr.Dic("LookForView").OnClickTabBtn(UIMgr.Dic("LookForView").TabItemList[1])
	else
		-- UIMgr.Dic("LookForView").Point_1_Btn_lbl:GetComponent("UILabel").text = "点击抽奖"
		UIMgr.Dic("LookForView").OnClickTabBtn(UIMgr.Dic("LookForView").TabItemList[idx])
	end
end

-- function LookForView.Point_2_View()
-- 	local d = Res.lotterybox[UIMgr.Dic("LookForView").LookForIdx]
-- 	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
-- 		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
-- 		local item = d.items[i]
-- 		local ts = g:GetComponent("TweenScale")
-- 		local childTP = g.transform:GetChild(0):GetComponent("TweenPosition")
-- 		g.transform:GetChild(0):FindChild("Effect").gameObject:SetActive(false)
-- 		g.transform:GetChild(0):FindChild("Icon").gameObject:SetActive(true)
-- 		g.transform:GetChild(0):FindChild("lbl").gameObject:SetActive(true)
-- 		g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[i][2]].icon
-- 	 	g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
-- 	 	g.transform:GetChild(0):FindChild("lbl"):GetComponent("UILabel").text = "×"..d.items[i][3]
-- 		g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite").spriteName = "com_baoxiang_02"
-- 	 	g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite"):MakePixelPerfect()
-- 	 	g.transform:GetChild(0):GetComponent("BoxCollider").enabled = false
-- 		ts:ResetToBeginning()
-- 		ts:PlayForward()
-- 		childTP:ResetToBeginning()
-- 		childTP:PlayForward()
-- 	end

-- 	UIMgr.Dic("LookForView").Point_2_BG:SetActive(false)
-- 	for k,v in pairs(UIMgr.Dic("LookForView").EffectList_2) do
-- 		v.gameObject:SetActive(false)
-- 	end
-- end


function LookForView:UpdateView()
end

function LookForView:AddListener()
	self:AddEvent(ED.LookForCtrl_S2CTreasureLottery,self.this.LookForCtrl_S2CTreasureLottery)
end

function LookForView:BeforeCloseView()
	if(self.AnimSequence ~= nil) then
		self.AnimSequence:Clear()	
	end
	if(self.OpenEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.OpenEffect)
		self.OpenEffect = nil
	end
	if(self.OpenTimer ~= nil) then
		self.OpenTimer:Cancel()
		self.OpenTimer = nil
	end
	if(self.spineHelper ~= nil) then
		self.spineHelper:Dispose()
	end
end

function LookForView:OnDestory()
	if(self.AnimSequence ~= nil) then
		self.AnimSequence:OnDestory()	
	end
	for k,v in pairs(self.EffectList) do
		UnitEffectMgr.DisposeEffect(self.EffectList[i])
	end
	self.EffectList = {}

	for k,v in pairs(self.EffectList_2) do
		UnitEffectMgr.DisposeEffect(self.EffectList_2[i])
	end
	self.EffectList_2 = {}
end


function LookForView.LookForCtrl_S2CTreasureLottery(t)
	LogColor("#ff0000","LookForCtrl_S2CTreasureLottery")
	UIMgr.Dic("LookForView").Point_1:SetActive(false)
	UIMgr.Dic("LookForView").Point_2:SetActive(true)
	
	local anim1 = LookFor_Cmd_ShowFirstBonus.new()
	local anim2 = LookFor_Cmd_ShowSelectBonus.new()
	UIMgr.Dic("LookForView").IsPlayAnim = true
	UIMgr.Dic("LookForView").AnimSequence:AddSubCommand(anim1)
	UIMgr.Dic("LookForView").AnimSequence:AddSubCommand(anim2)
	UIMgr.Dic("LookForView").AnimSequence:Execute()
end

function LookForView.OpenShow(index)
	local data = LookForCtrl.mode.S2CTreasureLotteryData
	if data ~= nil then
		LogColor("#ff0000","data.index",data.index)
		UIMgr.Dic("LookForView").Point_2_BG:SetActive(false)
		local d = Res.lotterybox[data.type]
		for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
			local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
			local item = d.items[i]
		 	g.transform:GetChild(0):FindChild("lbl"):GetComponent("UILabel").text = L("x{1}",d.items[i][3])
			g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[i][2]].icon
		 	g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
            g.transform:GetChild(0):GetComponent("TimeHelper"):AddTime(1,
               	function(go,lt)
					g.transform:GetChild(0):FindChild("Icon").gameObject:SetActive(true)
					g.transform:GetChild(0):FindChild("lbl").gameObject:SetActive(true)
					g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite").spriteName = "com_baoxiang_03"
		 			g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite"):MakePixelPerfect()
		 			g.transform:GetChild(0):GetComponent("BoxCollider").enabled = false

		 			local panel = UIMgr.Dic("LookForView").gameObject:GetComponent("UIPanel")
					local queue = panel.startingRenderQueue + 10
					local curEffect = UIMgr.Dic("LookForView").EffectList_2[tonumber(lt[2])]
					curEffect:UpdateQueue(queue)
		 			curEffect.gameObject:SetActive(true)
               	end,{temp,i})
		end
		if index ~= 0 then
			local g = UIMgr.Dic("LookForView").Point_2_ItemList[index]
		 	g.transform:GetChild(0):FindChild("lbl"):GetComponent("UILabel").text = L("x{1}",d.items[data.index][3])
			g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[data.index][2]].icon
		 	g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
			local g = UIMgr.Dic("LookForView").Point_2_ItemList[data.index]
		 	g.transform:GetChild(0):FindChild("lbl"):GetComponent("UILabel").text = L("x{1}",d.items[index][3])
			g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[index][2]].icon
		 	g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
		end
		local panel = UIMgr.Dic("LookForView").gameObject:GetComponent("UIPanel")
		local queue = panel.startingRenderQueue + 10
		if index == 0 then
			UIMgr.Dic("LookForView").Point_2_ItemList[data.index].transform:GetChild(0):GetComponent("TimeHelper"):ExcuteTime()
			UIMgr.Dic("LookForView").Point_2_ItemList[data.index].transform:GetChild(0):FindChild("Effect").gameObject:SetActive(true)
			local effContainer = UIMgr.Dic("LookForView").Point_2_ItemList[data.index].transform:GetChild(0):FindChild("Effect").gameObject
			if(UIMgr.Dic("LookForView").OpenEffect == nil) then
				UIMgr.Dic("LookForView").OpenEffect = UnitEffectMgr.ShowUIEffectInParent(effContainer,54007,Vector3.zero,true,queue)
			else
				UIMgr.Dic("LookForView").OpenEffect:Show(effContainer,Vector3.zero,true)
			end
		else
			UIMgr.Dic("LookForView").Point_2_ItemList[index].transform:GetChild(0):GetComponent("TimeHelper"):ExcuteTime()
			UIMgr.Dic("LookForView").Point_2_ItemList[index].transform:GetChild(0):FindChild("Effect").gameObject:SetActive(true)
			local effContainer = UIMgr.Dic("LookForView").Point_2_ItemList[index].transform:GetChild(0):FindChild("Effect").gameObject
			if(UIMgr.Dic("LookForView").OpenEffect == nil) then
				UIMgr.Dic("LookForView").OpenEffect = UnitEffectMgr.ShowUIEffectInParent(effContainer,54007,Vector3.zero,true,queue)
			else
				UIMgr.Dic("LookForView").OpenEffect:Show(effContainer,Vector3.zero,true)
			end
		end

		UIMgr.Dic("LookForView").OpenTimer = LH.UseVP(2, 1, 0,
		function()
			local tempData =LookForCtrl.mode.S2CTreasureLotteryData
			local getItem = Res.lotterybox[tempData.type].items[tempData.index]
			UIMgr.CloseView("LookForView")
			HelpCtrl.OpenItemGetEffectView({{getItem[2],getItem[3]}},L("获得物品"))
			--寻宝抽奖指引
			if(GuideCtrl.HasGuide()) then
				GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.LookFor})
			end
			UIMgr.Dic("LookForView").IsPlayAnim = false
		end,{})
	end
end