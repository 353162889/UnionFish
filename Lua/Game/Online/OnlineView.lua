OnlineView=Class(BaseView)

function OnlineView:ConfigUI()
	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	LH.AddClickEvent(self.CloseBtn,self.this.OnClickCloseBtn)
	self.Item = Find(self.gameObject,"ItemBox/Grid/Item")
	self.Item:SetActive(false)
	self.ItemList = {}
	self.TimeLabelItemList = {}
	self.TimeItem = Find(self.gameObject,"TimeBox/Grid/Item")
	self.TimeItem:SetActive(false)
	self.TimeItemList = {}

	LH.AddClickEvent(Find(self.gameObject,"Bgs/BG_8"),self.this.OnClickBtnAll)
	Find(self.gameObject,"Bgs/BG_8/lbl"):GetComponent("UILabel").text = L("全部领取")

	local C_d = OnlineCtrl.mode.S2CSignGetSceneInfoData
	for i=1,#Res.scene_sign do
		local d = Res.scene_sign[i]
		local temp = LH.GetGoBy(self.Item,self.Item.transform.parent.gameObject)
		temp:SetActive(true)
		temp.name = tostring(i)
		temp.transform:FindChild("lbl_1"):GetComponent("UILabel").text = L("{1}",d.title)
		temp.transform:FindChild("lbl_2"):GetComponent("UILabel").text = L("{1}",d.desc)
		temp.transform:FindChild("Icon"):GetComponent("UISprite").spriteName = d.icon
	 	temp.transform:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()

	 	for j=1,#C_d do
	 		if C_d[j].type == 1 and C_d[j].id == Res.scene_sign[i].id then
	 			temp.transform:FindChild("Btn_0").gameObject:SetActive(C_d[j].state == 0)
	 			temp.transform:FindChild("Btn_1").gameObject:SetActive(C_d[j].state == 1)
	 			temp.transform:FindChild("Btn_2").gameObject:SetActive(C_d[j].state == 2)
	 			temp.transform:FindChild("Btn_1/lbl"):GetComponent("UILabel").text = L("领 取")
	 			temp.transform:FindChild("Btn_2/lbl"):GetComponent("UILabel").text = L("已领取")
	 		end
	 	end
	 	local  labelBtn0 = temp	.transform:FindChild("Btn_0/lbl"):GetComponent("UILabel")
	 	table.insert(self.TimeLabelItemList,labelBtn0)

		LH.AddClickEvent(temp.transform:FindChild("Btn_0").gameObject,self.this.OnClickItemBtn)
		LH.AddClickEvent(temp.transform:FindChild("Btn_1").gameObject,self.this.OnClickItemBtn)
		LH.AddClickEvent(temp.transform:FindChild("Btn_2").gameObject,self.this.OnClickItemBtn)
		table.insert(self.ItemList,temp)
	end
	self.Item.transform.parent:GetComponent("UIGrid"):Reposition()

	for i=1,#Res.time_sign do
		local d = Res.time_sign[i]
		local temp = LH.GetGoBy(self.TimeItem,self.TimeItem.transform.parent.gameObject)
		temp:SetActive(true)
		temp.name = tostring(i)
		temp.transform:FindChild("lbl_2"):GetComponent("UILabel").text = L("{1}",d.title)
		temp.transform:FindChild("lbl_1"):GetComponent("UILabel").text = L("{1}",d.desc)
		temp.transform:FindChild("lbl_1_mask"):GetComponent("UILabel").text = L("{1}",d.desc)
		temp.transform:FindChild("Icon"):GetComponent("UISprite").spriteName = d.icon
	 	temp.transform:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
		-- LH.AddClickEvent(temp,self.this.OnClickItem)
		local showMask = false
		for j=1,#C_d do
	 		if C_d[j].type == 2 and C_d[j].id == Res.time_sign[i].id then
	 			temp.transform:FindChild("Mask").gameObject:SetActive(C_d[j].state == 2)
	 			showMask = C_d[j].state == 2
	 		end
	 	end
	 	temp.transform:FindChild("lbl_1").gameObject:SetActive(not showMask)
	 	temp.transform:FindChild("lbl_1_mask").gameObject:SetActive(showMask)
	 	
		LH.AddClickEvent(temp,self.this.OnClickTimeItemBtn)
		table.insert(self.TimeItemList,temp)
	end
	self.TimeItem.transform.parent:GetComponent("UIGrid"):Reposition()

	Find(self.gameObject,"Bgs/BG_4"):GetComponent("UILabel").text = L("捕鱼时长奖励")
	Find(self.gameObject,"Bgs/BG_6"):GetComponent("UILabel").text = L("每天的12点，18点重置奖励")

end

function OnlineView:AfterOpenView(t)
	self.this.NewView()
	self:InitUpdateTime()
end

function OnlineView:InitUpdateTime()
	--初始化当前所剩余的时间
	self.TimeList = {}
	local data = OnlineCtrl.mode.S2CSignGetSceneInfoData
	local updateTime = OnlineCtrl.mode.UpDateTime
	local updateId =  OnlineCtrl.mode.UpdateTimeId
	local curCfg = Res.scene_sign[updateId]
	for i=1,#Res.scene_sign do
		local cfg = Res.scene_sign[i]
		for i=1,#data do
			local info = data[i]
			if(info.type == 1 and cfg.id == info.id) then
			 	if updateTime~= -1 then
			 		local subTime = (cfg.time - curCfg.time) * 1000
			 		if(subTime >= 0) then
			 			local leaveTime = subTime + updateTime
			 			table.insert(self.TimeList,leaveTime * 0.001)
			 		else
			 			table.insert(self.TimeList,0)
			 		end
		    	else
		    		table.insert(self.TimeList,0)
		    	end
	    	end
    	end
	end
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	--开始计时
	local onTick = function ()
		self:OnUpdateLabel()
	end
	self.Timer = LH.UseVP(0, 0, 1, onTick,nil)
end

function OnlineView:OnUpdateLabel()
	for i=1,#self.TimeList do
		if(self.TimeList[i] > 0) then
			self.TimeList[i] = self.TimeList[i] - 1
			if(self.TimeList[i] < 0) then self.TimeList[i] = 0 end
			self.TimeLabelItemList[i].text = tostring(LH.GetTimeFormat(self.TimeList[i]))
		end
	end
end

function OnlineView:UpdateView()

end

function OnlineView:AddListener()
	self:AddEvent(ED.OnlineView_NewView,self.this.NewView)
	self:AddEvent(ED.OnlineView_GetInfo,self.this.GetInfo)
end

function OnlineView:BeforeCloseView()
	--关闭计时
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	self.TimeList = {}
end

function OnlineView:OnDestory()

end

function OnlineView.OnClickCloseBtn(go)
	UIMgr.CloseView("OnlineView")
end

function OnlineView.OnClickItemBtn(go)
	if go.name == "Btn_0" then
		HelpCtrl.Msg(L("捕鱼时长未达到领奖要求"))
	elseif go.name == "Btn_1" then
		OnlineCtrl.C2SSignAcceptPrizeByScene(tonumber(go.transform.parent.name))
	elseif go.name == "Btn_2" then

	end
end
function OnlineView.OnClickTimeItemBtn(go)
	local index = tonumber(go.name)
	local curId = Res.time_sign[index].id
	local C_d = OnlineCtrl.mode.S2CSignGetSceneInfoData
	local canGet = false
	for i=1,#C_d do
		if(C_d[i].id == curId and C_d[i].state == 1) then
			canGet = true
			break
		end
	end
	if(canGet) then
		OnlineCtrl.C2SSignAcceptPrizeByTime(index)
	end
end

function OnlineView.GetInfo()
	
	UIMgr.Dic("OnlineView"):InitUpdateTime()
end

function OnlineView.NewView(d)
	local s = UIMgr.Dic("OnlineView")
	local C_d = OnlineCtrl.mode.S2CSignGetSceneInfoData
	for i=1,#s.ItemList do
		for j=1,#C_d do
	 		if C_d[j].type == 1 and C_d[j].id == tonumber(s.ItemList[i].name) then
	 			s.ItemList[i].transform:FindChild("Btn_0").gameObject:SetActive(C_d[j].state == 0)
	 			s.ItemList[i].transform:FindChild("Btn_1").gameObject:SetActive(C_d[j].state == 1)
	 			s.ItemList[i].transform:FindChild("Btn_2").gameObject:SetActive(C_d[j].state == 2)
	 		end
	 	end
	end

	for i=1,#s.TimeItemList do
		for j=1,#C_d do
	 		if C_d[j].type == 2 and C_d[j].id == tonumber(s.TimeItemList[i].name) then
	 			s.TimeItemList[i].transform:FindChild("Mask").gameObject:SetActive(C_d[j].state == 2)
	 			s.TimeItemList[i].transform:FindChild("L").gameObject:SetActive(C_d[j].state == 1)
	 		end
	 	end
	end

end

function OnlineView.OnClickBtnAll(go)
	local C_d = OnlineCtrl.mode.S2CSignGetSceneInfoData
	local canGet = false
	for i=1,#C_d do
		if(C_d[i].state == 1) then
			canGet = true
			break
		end
	end
	if(canGet) then
		OnlineCtrl.C2SSignAcceptPrizeByAll()
	else
		HelpCtrl.Msg(L("当前没有可领取的奖励"))
	end
end