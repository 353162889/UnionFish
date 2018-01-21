FishDicView=Class(BaseView)

function FishDicView:ConfigUI()
	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	Find(self.gameObject,"BG_2/lbl"):GetComponent("UILabel").text = L("鱼图鉴")
	LH.AddClickEvent(self.CloseBtn,self.this.OnClickCloseBtn)
	self.ScrollView = Find(self.gameObject,"ItemBox"):GetComponent("UIScrollView")
	self.Item = Find(self.gameObject,"ItemBox/Grid/Item")
	self.GoldLabel = Find(self.gameObject,"GoldFishLabel")
	Find(self.GoldLabel,"Label1"):GetComponent("UILabel").text = L("捕获彩金鱼会将2%的金币灌入奖池")
	Find(self.GoldLabel,"Label2"):GetComponent("UILabel").text = L("炮台倍率越高，灌入奖金池的奖金数越高")
	self.GoldDesc = Find(self.gameObject,"GoldFishDesc")
	Find(self.GoldDesc,"Item1/Label"):GetComponent("UILabel").text = L("BOSS鱼")
	Find(self.GoldDesc,"Item2/Label"):GetComponent("UILabel").text = L("彩金鱼")
	Find(self.GoldDesc,"Item3/Label"):GetComponent("UILabel").text = L("特殊鱼")
	Find(self.GoldDesc,"Item4/Label"):GetComponent("UILabel").text = L("普通鱼")
	self.GoldLabel:SetActive(false)
	self.Item:SetActive(false)
	self.ItemList = {}
	self.fishs = {}
	for k,v in pairs(Res.fish) do
		table.insert(self.fishs,v)
	end
	self.Map = {
		[1] = 1,		--小鱼
		[2] = 2,		--中鱼
		[3] = 3,		--大鱼
		[4] = 4,		--精英
		[5] = 5,		--主题
		[6] = 12,		--BOSS
		[7] = 11,		--彩金鱼
		[8] = 10,		--特殊鱼
		[9] = 6,		--功能鱼
		[10] = 9,		--鱼王
		[11] = 8,		--分裂鱼
		[12] = 7,		--随机倍率鱼
	}
	table.sort(self.fishs,function (a,b)
		local aIndex = self.Map[a.type]
		if(aIndex == nil ) then 
			aIndex = 0 
			--LogError("fish id="..a.id.." can not find sort Type="..a.type)
		end
		local bIndex = self.Map[b.type]
		if(bIndex == nil) then 
			bIndex = 0 
			--LogError("fish id="..b.id.." can not find sort Type="..b.type)
		end
		if(aIndex ~= bIndex) then
			return aIndex > bIndex
		end
		return a.id < b.id
	end)
	for i=1,#self.fishs do
		local v = self.fishs[i]
		local temp = LH.GetGoBy(self.Item,self.Item.transform.parent.gameObject)
		temp:SetActive(true)
		temp.name = tostring(i)
		temp.transform:FindChild("lbl"):GetComponent("UILabel").text = L("{1}",v.name)
		temp.transform:FindChild("value"):GetComponent("UILabel").text = L("{1}",v.rate_desc)
		temp.transform:FindChild("Icon"):GetComponent("UISprite").spriteName = "f_"..v.id
		temp.transform:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
		temp.transform:FindChild("BG"):GetComponent("UISprite").spriteName = v.bg_name
		--temp.transform:FindChild("Type"):GetComponent("UISprite").spriteName = "dic_type_"..v.type
		table.insert(self.ItemList,temp)
	end
	-- for k,v in pairs(Res.fish) do
	-- 	local temp = LH.GetGoBy(self.Item,self.Item.transform.parent.gameObject)
	-- 	temp:SetActive(true)
	-- 	temp.name = tostring(v.id)
	-- 	temp.transform:FindChild("lbl"):GetComponent("UILabel").text = v.name
	-- 	temp.transform:FindChild("value"):GetComponent("UILabel").text = tostring(v.rate)
	-- 	temp.transform:FindChild("Icon"):GetComponent("UISprite").spriteName = "f_"..v.id
	-- 	temp.transform:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
	-- 	table.insert(self.ItemList,temp)
	-- end
	self.Item.transform.parent:GetComponent("UIGrid"):Reposition()
end

function FishDicView.OnClickCloseBtn(go)
	UIMgr.CloseView("FishDicView")
end

function FishDicView:AfterOpenView(t)
	if t ~= nil then
		self.GoldLabel:SetActive(t[2] == 1)
		self.GoldDesc:SetActive(t[2] ~= 1)
		for i=1,#self.ItemList do
			local cfg = self.fishs[i]
			local b = false
			for j=1,#cfg.inScene do
				if t[1] == cfg.inScene[j] then

					b = true
				end
			end
			if b and t[2] == 1 then
				-- b = (cfg.type == UnitFishType.GoldFish)
				b = (cfg.is_gold == 1)
			end
			-- self.ItemList[i]:SetActive(#Res.fish[id].inScene>0)
			self.ItemList[i]:SetActive(b)
		end
		self.Item.transform.parent:GetComponent("UIGrid"):Reposition()
		self.ScrollView:ResetPosition()
	end
	--指引
	if(GuideCtrl.HasGuide()) then
		GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.FishDic})
	end
end

function FishDicView:UpdateView()

end

function FishDicView:AddListener()
	-- self:AddEvent(ED.LookForCtrl_S2CTreasureLottery,self.this.LookForCtrl_S2CTreasureLottery)
end

function FishDicView:BeforeCloseView()	

end

function FishDicView:OnDestory()

end