RotationDiscDiscItem = {}

function RotationDiscDiscItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RotationDiscDiscItem:Init(index,parent)
	self.index = index
	self.parent = parent

	self.TemplateIcon = Find(self.gameObject,"TemplateIcon")
	self.TemplateIcon.gameObject:SetActive(false)

	self.LeftGO = Find(self.gameObject,"Left")
	self.ListLeftPos = {}	--左边坐标列表
	local count = self.LeftGO.transform.childCount
	for i=1,count do
		local pos = Find(self.LeftGO,i).transform.position
		table.insert(self.ListLeftPos,pos)
	end

	self.RightGO = Find(self.gameObject,"Right")
	self.ListRightPos = {}	--右边坐标列表
	local count = self.RightGO.transform.childCount
	for i=1,count do
		local pos = Find(self.RightGO,i).transform.position
		table.insert(self.ListRightPos,pos)
	end
	self.DiscGO = Find(self.gameObject,"Disc")
	self.rotateHelper = self.DiscGO:AddComponent(typeof(RDDiscRotateHelper))

	self.Btn = Find(self.gameObject,"Btn")
	local onClick = function (go)
		LH.Play(go,"Play")
		self:OnClickStart()
	end
	LH.AddClickEvent(self.Btn,onClick)

	self.LabelFreeInBtn = Find(self.Btn,"Label")
	local labelFree = self.LabelFreeInBtn:GetComponent("UILabel")
	LB(labelFree,"免费抽奖")
	self.IconDepth = Find(self.Btn,"Icon"):GetComponent("UIWidget").depth
	self.ItemInBtn = Find(self.Btn,"Item")
	self.ItemLabelInBtn = Find(self.Btn,"Item/Label"):GetComponent("UILabel")
	self.ItemIconInBtn = Find(self.Btn,"Item/Icon"):GetComponent("UISprite")
	self.Lock = Find(self.Btn,"Lock")

	self.IsPlayAnim = false

	--初始化物品
	self.ListCfg = {}
	self.ListItem = {}
	local cfgs = Res["lottery"..self.index]
	for k,v in pairs(cfgs) do
		table.insert(self.ListCfg,v)
	end
	table.sort(self.ListCfg,function (a,b)
		return a.sort < b.sort
	end)
	local count = #self.ListCfg
	local perAngle = 360 / count
	local radius = 200
	local discDepth = self.DiscGO:GetComponent("UIWidget").depth
	for i=1,count do
		local curAngle = (i - 1) * perAngle
		local x = -radius * math.sin(math.rad(curAngle))
		local y = radius * math.cos(math.rad(curAngle))
		local pos = Vector3.New(x,y,0)
		local go = UnityEngine.GameObject(tostring(i))
		Ext.AddChildToParent(self.DiscGO,go,false)
		go.transform.localPosition = pos
		go.transform.localEulerAngles = Vector3.New(0,0,curAngle)
		local itemGO = LH.GetGoBy(self.TemplateIcon,go)
		itemGO:SetActive(true)
		local bonus = self.ListCfg[i].item
		local itemID = tonumber(bonus[1])
		local itemCount = tonumber(bonus[2])
		itemGO:GetComponent("UISprite").spriteName = Res.item[itemID].icon
		Find(itemGO,"Label"):GetComponent("UILabel").text = L("{1}",self:GetCurNumberDesc(itemCount))
		Find(itemGO,"Color"):GetComponent("UISprite").spriteName = cfgs[i].bg
		table.insert(self.ListItem,go)
	end

	self.curPerAngle = perAngle

	self.gameObject:SetActive(false)
end

function RotationDiscDiscItem:GetCurNumberDesc(number)
    if(number >= 10000) then
        local result = number / 10000.0
        local remain = number % 10000
        if(result < 10 and remain >= 1000) then
            result = string.format("%.1f",result)
            if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
            	 return result.."\n"..L("万")
		    else
		    	 return result..L("万")
		   	end
        else
        	if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
            	 return math.floor(result).."\n"..L("万")
		    else
		    	 return math.floor(result)..L("万")
		   	end
            
        end
    end
    return tostring(number)    
end

function RotationDiscDiscItem:SetActive(active)
	self.gameObject:SetActive(active)
end

function RotationDiscDiscItem:OnVisiable(visiable,PointLeftHelper,PointRightHelper,ArrowHelper)
	if(visiable) then
		if(not self.gameObject.activeSelf) then
			self.IsPlayAnim = false
			self.parent:ShowSelectIcon(false)
			self.rotateHelper:ResetPos()
			self.gameObject:SetActive(true)
			self.rotateHelper:ResetPos()
			self.parent.PointLeftHelper:Begin(true)
			for k,v in pairs(self.ListLeftPos) do
				self.parent.PointLeftHelper:AddPoint(v.x,v.y,v.z)
			end
			self.parent.PointLeftHelper:End()

			self.parent.PointRightHelper:Begin(false)
			for k,v in pairs(self.ListRightPos) do
				self.parent.PointRightHelper:AddPoint(v.x,v.y,v.z)
			end
			self.parent.PointRightHelper:End()

			self.parent.PointLeftHelper:UpdateSpeed(0.5)
			self.parent.PointRightHelper:UpdateSpeed(0.5)

			self.parent.ArrowHelper:Begin()
			self.parent.ArrowHelper:SetRotateTarget(self.DiscGO.transform,360)
			local count = #self.ListCfg
			for i=1,count do
				local curAngle = (i - 1) * self.curPerAngle
				local maxAngle = curAngle - self.curPerAngle * 0.25
				local minAngle = curAngle - self.curPerAngle * 0.75
				maxAngle = LH.GetRadiusIn360(maxAngle)
				minAngle = LH.GetRadiusIn360(minAngle)
				self.parent.ArrowHelper:AddTarget(minAngle,maxAngle,self.ListItem[i].transform)
			end
			self.parent.ArrowHelper:End()

			--添加事件
			self.onFreeTimeReach = function (lv)
				self:OnFreeTimeReachFinish(lv)
			end
			RotationDiscCtrl.AddEvent(RotationDiscEvent.OnFreeTimeReach,self.onFreeTimeReach)

			--抽奖成功事件
			self.lotterySucc = function (msg)
				self:OnLotterySucc(msg)
			end
			RotationDiscCtrl.AddEvent(RotationDiscEvent.OnLottorySucc,self.lotterySucc)
		end
	else
		self.IsPlayAnim = false
		self.gameObject:SetActive(false)
		self.rotateHelper:ResetPos()
		if(self.onFreeTimeReach ~= nil) then
			RotationDiscCtrl.RemoveEvent(RotationDiscEvent.OnFreeTimeReach,self.onFreeTimeReach)
			self.onFreeTimeReach = nil
		end

		if(self.lotterySucc ~= nil) then
			RotationDiscCtrl.RemoveEvent(RotationDiscEvent.OnLottorySucc,self.lotterySucc)
			self.lotterySucc = nil
		end
		if(self.Timer ~= nil) then
			self.Timer:Cancel()
			self.Timer = nil
		end
	end

	if(visiable) then
		self:Refresh()
	end
end

function RotationDiscDiscItem:OnFreeTimeReachFinish(lv)
	LogColor("#ff0000","OnFreeTimeReachFinish")
	self:Refresh()
end

function RotationDiscDiscItem:OnLotterySucc(msg)
	if(msg.lv == self.index) then
		local index = msg.index
		--计算旋转角度
		LogColor("#ff0000","抽奖索引",index)
		local cfgs = Res["lottery"..self.index]
		local itemId = tonumber(cfgs[index].item[1])
		local itemNum = tonumber(cfgs[index].item[2])
		local sortIndex = cfgs[index].sort
		local angle = -(sortIndex - 1) * self.curPerAngle
		local totalAngle = 360 * 5 + angle
		--播放抽奖动画
		self.parent.PointLeftHelper:UpdateSpeed(0.075)
		self.parent.PointRightHelper:UpdateSpeed(0.075)
		self.IsPlayAnim = true
		self.parent.ArrowHelper:ArrowEnable(true)
		self.parent:ShowMask(true)
		self.parent:ShowSelectIcon(false)
		
		RotationDiscCtrl.DelayRefreshLuck()	--延时刷新幸运值
		self.rotateHelper:RotateInLua(totalAngle,8,3,0.5,function (lt)
			self.parent.PointLeftHelper:UpdateSpeed(0.5)
			self.parent.PointRightHelper:UpdateSpeed(0.5)
			self.parent.ArrowHelper:ArrowEnable(false)
			self.parent:ShowSelectIcon(true)
			local OnDelay = function ()
				RotationDiscCtrl.CancelDelayRefreshLuck()	--不延时刷新幸运值
				self.IsPlayAnim = false
				self.parent:ShowMask(false)
				HelpCtrl.OpenItemGetEffectView({{itemId,itemNum}},L("获得物品"))
				--寻宝抽奖指引
				if(GuideCtrl.HasGuide()) then
					GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.RotationDisc})
				end
				--清除当前延时
				RotationDiscCtrl.RefreshMoneyShow()
			end
			local delayTime = 1
			if(cfgs[index].effect == 0) then
				self.parent:ShowIncreaseEffect(0.5)
				delayTime = 1.5
			elseif(cfgs[index].effect == 1) then
				self.parent:ShowDecreaseEffect(0.5)
				delayTime = 1.5
			end
			self.Timer = LH.UseVP(delayTime, 1, 0 ,OnDelay,nil)
		end,nil)
	end
end



function RotationDiscDiscItem:Refresh()
	--初始化按钮
	local isFree = RotationDiscCtrl.IsFreeTime(self.index)
	self.LabelFreeInBtn.gameObject:SetActive(isFree)
	self.ItemInBtn.gameObject:SetActive(not isFree)
	local lotteryData = Res.lottery_base[self.index]
	if(not isFree) then
		local useItems = lotteryData.use
		local id = tonumber(useItems[1][1])
		local num = tonumber(useItems[1][2])
		local item = BagCtrl.GetItem(id)
		if(item == nil or item.cnt < num) then
			id = tonumber(useItems[2][1])
			num = tonumber(useItems[2][2])
		end
		self.ItemIconInBtn.spriteName = Res.item[id].icon
		self.ItemLabelInBtn.text = "x"..num
	end
	local isOpen = true
	if(#lotteryData.OpenType > 0) then
		local count = #lotteryData.OpenType
		for i=1,count do
		end
	end
	self.Lock.gameObject:SetActive(not isOpen)
end

function RotationDiscDiscItem:OnClickStart()
	if(self.IsPlayAnim) then return end
	local isFree = RotationDiscCtrl.IsFreeTime(self.index)
	if(isFree)then
		RotationDiscCtrl.C2SLotteryLottery(self.index,1)
	else 
		local useItems = Res.lottery_base[self.index].use
		local id = tonumber(useItems[1][1])
		local num = tonumber(useItems[1][2])
		local item = BagCtrl.GetItem(id)
		if(item == nil or item.cnt < num) then
			id = tonumber(useItems[2][1])
			num = tonumber(useItems[2][2])
			local moneyItem = BagCtrl.GetMoneyItem(id)
			if(moneyItem ~=nil and moneyItem.cnt >= num) then
				--金币或钻石足够的话
				RotationDiscCtrl.C2SLotteryLottery(self.index,3)
			else
				if(id == GlobalDefine.Gold) then
					HelpCtrl.OpenTipView(L("提   示"),L("金币不足，可从商城中快速获取金币"),function ()
						UIMgr.OpenView("ShopView",1)
					end,nil,nil,L("去商城购买"),L("取 消"))
				elseif(id == GlobalDefine.DiamondID) then
					HelpCtrl.OpenTipView(L("提   示"),L("钻石不足，可从商城中快速获取钻石"),function ()
						UIMgr.OpenView("ShopView",3)
					end,nil,nil,L("去商城购买"),L("取 消"))
				else
					local itemCfg = Res.item[id]
					if(itemCfg ~= nil) then
						HelpCtrl.OpenTipView(L("提   示"),L("{1}不足",itemCfg.name),nil,nil,nil,L("确 认"),L("取 消"))
					else
						LogError("找不到ID为"..id.."的物品")
					end
				end
			end
		else
			--抽奖券足够的话
			RotationDiscCtrl.C2SLotteryLottery(self.index,2)
		end
	end
end

function RotationDiscDiscItem:Dispose()
	-- body
end
