GunUnlockItem = {}

function GunUnlockItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function GunUnlockItem:Init()
	self.Content = Find(self.gameObject,"Content")
	self.Tp = self.Content:GetComponent("TweenPosition")
	self.LabelGunRate = Find(self.gameObject,"Content/LabelGunRate"):GetComponent("UILabel")
	self.Item_1 = Find(self.gameObject,"Content/ItemProgress/Item_1")
	self.Item_2 = Find(self.gameObject,"Content/ItemProgress/Item_2")
	self.Item_1_Progress = UIProgress:New(Find(self.Item_1,"Progress"),UIProgressMode.Horizontal)
	self.Item_2_Progress = UIProgress:New(Find(self.Item_2,"Progress"),UIProgressMode.Horizontal)
	self.Item_1_Label = Find(self.Item_1,"Label"):GetComponent("UILabel")
	self.Item_2_Label = Find(self.Item_2,"Label"):GetComponent("UILabel")
	self.SpriteIcon = Find(self.gameObject,"SpriteIcon")
	self.SpriteIcon.gameObject:SetActive(false)
	self.IsShow = false
	self.Content.transform.localPosition = Vector3(-400,0,0)

	local onOpenView = function (go)
		local needOpenView = true
		local cfg = self:GetNextGunRateCfg()
		if(cfg ~= nil) then
			local cfgCnt = 0
			if(#cfg.use_item == 0) then 
				cfgCnt = 0
			else
				cfgCnt = tonumber(cfg.use_item[2])
			end
			local cnt = BagCtrl.GetItemCntById(10006)
			if(cnt >= cfgCnt) then
				needOpenView = false
			end
		end
		if(needOpenView) then
			UIMgr.OpenView("GunRateUnlockView")
		else
			PersonalCenterCtrl.C2SAttrSetBatteryRate(cfg.id)
		end
		-- UIMgr.OpenView("GunRateUnlockView")
	end
	LH.AddClickEvent(self.Content,onOpenView)
end

function GunUnlockItem:Dispose()
	self.Item_1_Progress:Dispose()
	self.Item_2_Progress:Dispose()
	self.IsShow = false
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
end

function GunUnlockItem:Show()
	if(not self.IsShow) then
		self.IsShow = true
		LH.SetTweenPosition(self.Tp,Vector3.New(-400,0,0),Vector3.New(0,0,0),0.1,function (go)
			--UIMgr.Dic("PlayView"):GetGunUnlockBtn().transform.localEulerAngles=Vector3.New(0,90,0)
			UIMgr.Dic("PlayView"):GetGunUnlockBtn():SetActive(false)
			self.SpriteIcon.gameObject:SetActive(true)
		end)
		local OnClose = function ()
			self:Hide()
		end
		self.Close_Handle = LH.UseVP(3, 1, 0 ,OnClose,{})
	end

	local cfg = self:GetNextGunRateCfg()
	if(cfg ~= nil) then
		local cfgCnt = 0
		if(#cfg.use_item == 0) then 
			cfgCnt = 0
		else
			cfgCnt = tonumber(cfg.use_item[2])
		end
		LB(self.LabelGunRate,"点击解锁{1}倍炮",cfg.rate)
		local cnt = BagCtrl.GetItemCntById(10006)
		if(cnt < cfgCnt) then
			self.Item_1:SetActive(false)
			self.Item_2:SetActive(true)

			local percent = cnt / cfgCnt
			self.Item_2_Progress:UpdateProgress(percent)
			self.Item_2_Label.text = L("{1}/{2}",cnt,cfgCnt)
		else
			self.Item_1:SetActive(true)
			self.Item_2:SetActive(false)
			self.Item_1_Progress:UpdateProgress(1)
			self.Item_1_Label.text = cfg.give
		end
	else
		LogColor("#ff0000","已经是最大倍炮了")
	end
end

function GunUnlockItem:GetNextGunRateCfg()
	return GunRateUnlockCtrl.GetNextGunRateCfg()
end

function GunUnlockItem:IsMaxGunRate()
	return GunRateUnlockCtrl.IsMaxGunRate()
end

function GunUnlockItem:Hide()
	if(self.IsShow) then
		self.IsShow = false
		LH.SetTweenPosition(self.Tp,Vector3.New(0,0,0),Vector3.New(-400,0,0),0.1,function (go)
			self.SpriteIcon.gameObject:SetActive(false)
			--IMgr.Dic("PlayView"):GetGunUnlockBtn().transform.localEulerAngles = Vector3.New(0,0,0)
			UIMgr.Dic("PlayView"):GetGunUnlockBtn():SetActive(true)
		end)
	end
	if(self.Close_Handle ~= nil) then
		self.Close_Handle:Cancel()
		self.Close_Handle = nil
	end
end