
TreasureItem = {}

function TreasureItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TreasureItem:Init()
	self.Content = Find(self.gameObject,"Content")
	self.Tp = self.Content:GetComponent("TweenPosition")
	self.LabelTreasure = Find(self.gameObject,"Content/LabelTreasure")
	self.Item_1 = Find(self.gameObject,"Content/ItemProgress/Item_1")
	self.Item_2 = Find(self.gameObject,"Content/ItemProgress/Item_2")
	self.Item_1_Progress = UIProgress:New(Find(self.Item_1,"Progress"),UIProgressMode.Horizontal)
	self.Item_2_Progress = UIProgress:New(Find(self.Item_2,"Progress"),UIProgressMode.Horizontal)
	self.Item_1_Label = Find(self.Item_1,"Label"):GetComponent("UILabel")
	self.Item_2_Label = Find(self.Item_2,"Label"):GetComponent("UILabel")
	self.SpriteIcon = Find(self.gameObject,"SpriteIcon")
	self.SpriteIcon.gameObject:SetActive(false)
	self.EffectContainer = Find(self.gameObject,"Content/Effect").gameObject
	self.IsShow = false
	self.Content.transform.localPosition = Vector3(-400,0,0)

	local onOpenView = function (go)
		UIMgr.OpenView("LookForView")
	end
	LH.AddClickEvent(self.Content,onOpenView)
end

function TreasureItem:Dispose()
	self.Item_1_Progress:Dispose()
	self.Item_2_Progress:Dispose()
	self.IsShow = false
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
	SELF:RemoveEffect()
end

function TreasureItem:Show()
	if(not self.IsShow) then
		self.IsShow = true
		LH.SetTweenPosition(self.Tp,Vector3.New(-400,0,0),Vector3.New(0,0,0),0.1,function (go)
			UIMgr.Dic("PlayView"):GetTreasureBtn():SetActive(false)
			self.SpriteIcon.gameObject:SetActive(true)
		end)
		local OnClose = function ()
			self:Hide()
		end
		self.Close_Handle = LH.UseVP(3, 1, 0 ,OnClose,{})
	end
	self:UpdateInfo()
end

--这里面更新信息
function TreasureItem:UpdateInfo()
	local d = LookForCtrl.mode.S2CTreasureGetInfoData
	if(LookForCtrl.IsCanLookFor()) then
	-- if d.gold_fish >= Res.misc[1].lookfor_count then
		self.Item_1:SetActive(false)
		self.LabelTreasure:SetActive(true)
		self.LabelTreasure:GetComponent("UILabel").text = L("点击免费抽奖")
	else
		self.Item_1:SetActive(true)
		self.LabelTreasure:SetActive(false)
		local percent = d.gold_fish/Res.misc[1].lookfor_count
		self.Item_1_Progress:UpdateProgress(percent)
		self.Item_1_Label.text = L("{1}/{2}",d.gold_fish,Res.misc[1].lookfor_count)
	end
	self.Item_2_Progress:UpdateProgress(d.gold_num / 10000)
	self.Item_2_Label.text = tostring(d.gold_num)
	LogColor("#ff0000","UpdateInfo(TreasureItem)",d.gold_num)
end

function TreasureItem:Hide()
	if(self.IsShow) then
		self.IsShow = false
		LH.SetTweenPosition(self.Tp,Vector3.New(0,0,0),Vector3.New(-400,0,0),0.1,function (go)
			self.SpriteIcon.gameObject:SetActive(false)
			UIMgr.Dic("PlayView"):GetTreasureBtn():SetActive(true)
		end)
	end
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
end

function TreasureItem:AddEffect()
	local btnParent = UIMgr.Dic("PlayView"):GetTreasureBtn().gameObject
	local btnPanel = GetParentPanel(btnParent)
	local btnEffectId = 54001
	self.BtnEffect = UnitEffectMgr.ShowUIEffectInParent(btnParent,btnEffectId,Vector3.zero,true,btnPanel.startingRenderQueue + 10)

	local itemParent = self.EffectContainer
	local itemPanel = GetParentPanel(itemParent)
	local itemEffectId = 54002
	self.ItemEffect = UnitEffectMgr.ShowUIEffectInParent(itemParent,itemEffectId,Vector3.zero,true,itemPanel.startingRenderQueue + 10)
end

function TreasureItem:RemoveEffect()
	if(self.BtnEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.BtnEffect)
		self.BtnEffect = nil
	end
	if(self.ItemEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.ItemEffect)
		self.ItemEffect = nil
	end
end