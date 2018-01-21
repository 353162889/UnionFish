SignSevenDaysView={}


--基本信息
function SignSevenDaysView:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

--初始化
function SignSevenDaysView:Init(dayGo)
	self.DayEffect=54008
	self.SevenDayEffect=54009

	self.ItemGridParent=Find(self.gameObject,"SignItemUIGrid")
	self.ItemGrid=Find(self.gameObject,"SignItemUIGrid/ItemGrid")
	self.ItemGrid:SetActive(false)
	self.SevenDay=Find(self.gameObject,"SignSevenDay")

	self.HintShow=Find(dayGo,"SignHintShow")


	self.ItemGridList={}
	local listSign = SortRes.DicSign7
	for i=1,#listSign do
		if i<#listSign then
			local item = LH.GetGoBy(self.ItemGrid,self.ItemGridParent)
			item:SetActive(true)
			table.insert(self.ItemGridList,item)

			self:SetItem(item,listSign[i])
		else
			table.insert(self.ItemGridList,self.SevenDay)
			self:SetItem(self.SevenDay,listSign[7])
		end
	end
end	


--赋值  item、数值
function SignSevenDaysView:SetItem(item,data)
	local goodsIcon = Find(item,"GoodsIcon"):GetComponent("UISprite")
	local goodsCount = Find(item,"GoodsCount"):GetComponent("UILabel")
	local goodsDay= Find(item,"GoodsDay"):GetComponent("UILabel")

	goodsIcon.spriteName=data.icon 
	goodsIcon:MakePixelPerfect()
	goodsCount.text=L("{1}",data.bonusDesc)
	goodsDay.text=L("{1}",data.desc)
end


--更新 是否已签到领取
function SignSevenDaysView:UpdataItem(index)
	for i=1,#self.ItemGridList do
		local receiveOk = Find(self.ItemGridList[i],"ReceiveOk")
		-- Find(receiveOk,"Label"):GetComponent("UILabel").text = L("已领取")
		if i<=index then
			receiveOk:SetActive(true)
		else
			receiveOk:SetActive(false)
		end
	end
end


--显示提示可签到
function SignSevenDaysView:UpdataSignHint(index,isSign)
	for i=1,#self.ItemGridList do
		if i==index and isSign then
			--显示特效
			local effectContainer = Find(self.ItemGridList[i],"EffectContainer")
			local panel = GetParentPanel(effectContainer)
			if(panel ~= nil) then
				if(self.effect ~= nil) then
					UnitEffectMgr.DisposeEffect(self.effect)
					self.effect = nil
				end
				if i<#self.ItemGridList then
					self.effect = UnitEffectMgr.ShowUIEffectInParent(effectContainer,self.DayEffect,Vector3.zero,true,panel.startingRenderQueue+10)
				else
					self.effect = UnitEffectMgr.ShowUIEffectInParent(effectContainer,self.SevenDayEffect,Vector3.zero,true,panel.startingRenderQueue+10)
				end
			end
		end
	end

	if isSign then
		self.HintShow:SetActive(true)
	else
		self.HintShow:SetActive(false)
	end
end


function SignSevenDaysView:CloseEffect()
	if(self.effect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.effect)
		self.effect = nil
	end
end

