require 'Game/GunRateUnlock/GunRateUnlockItem'
GunRateUnlockView = Class(BaseView)

function GunRateUnlockView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	local onClickClose = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("GunRateUnlockView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)

	self.BtnUnlock = Find(self.gameObject,"Content/BtnUnlock")
	local onUnlock = function (go)
		LH.Play(go,"Play")
		self:OnClickUnLock(go)
	end
	LH.AddClickEvent(self.BtnUnlock,onUnlock)
	Find(self.BtnUnlock,"Label"):GetComponent("UILabel").text = L("解   锁")

	self.LabelProgress = Find(self.gameObject,"Content/Progress/Label"):GetComponent("UILabel")
	self.Progress = UIProgress:New(Find(self.gameObject,"Content/Progress/Progress"),UIProgressMode.Horizontal)
	self.Progress:UpdateProgress(0)

	self.scrollView = Find(self.gameObject,"Content/ScrollView"):GetComponent("UIScrollView")
	self.table = Find(self.gameObject,"Content/ScrollView/Grid"):GetComponent("UITable")
	self.scrollViewRestrict = Find(self.gameObject,"Content/ScrollView"):GetComponent("UIScrollViewRestrict")
	self.item = Find(self.gameObject,"Content/ScrollView/Grid/GunRateItem")
	self.item:SetActive(false)

	self.itemList = {}

	Find(self.gameObject,"Bgs/BG_2/lbl"):GetComponent("UILabel").text = L("解 锁 炮 倍")
	Find(self.gameObject,"Content/Desc"):GetComponent("UILabel").text = L("捕获金色鱼或者大鱼可概率获得")

	self.maxShowNum = 6
	self.GunRateTipKey = LoginCtrl.mode.S2CResult.init_user_name.."_UnionFish_2017_GunRate_Tips_Time"
end

function GunRateUnlockView:OnClickUnLock(go)
	if(self.cfg == nil)then
		return
	end 
	local cnt = BagCtrl.GetItemCntById(GlobalDefine.FishHookId)
	local cfgCnt = 0
	if(#self.cfg.use_item == 0) then 
		cfgCnt = 0
	else
		cfgCnt = tonumber(self.cfg.use_item[2])
	end
	if(cnt < cfgCnt) then
		--弹出钻石不够界面
		local tipValue = UnityEngine.PlayerPrefs.GetString(self.GunRateTipKey,"")
		if(tipValue == nil or tipValue == "" or tonumber(tipValue) < tonumber(tostring(LH.GetDayOffsetTimeTicks(-7)))) then
			HelpCtrl.OpenTipView(L("提   示"),L("金色鱼钩不足，可用{1}钻石购买补足",((cfgCnt - cnt)*Res.item[GlobalDefine.FishHookId].buy_gold)),function ()
				if (cfgCnt - cnt)*Res.item[GlobalDefine.FishHookId].buy_gold <= LoginCtrl.mode.S2CEnterGame.diamond then
					PersonalCenterCtrl.C2SAttrSetBatteryRate(self.cfg.id)
				else
					HelpCtrl.OpenTipView(L("提   示"),L("钻石不足，可从商城中快速获取钻石"),function ()
						UIMgr.OpenView("ShopView",3)
					end,nil,nil,L("去商城购买"),L("取 消"))
				end
			end,nil,nil,L("购 买"),L("取 消"),L("七天内不再提示"),false,function (value)
				LogColor("#ff0000","value",value)
				if(value) then
					UnityEngine.PlayerPrefs.SetString(self.GunRateTipKey,tostring(LH.GetDateTimeTicks()))
				end
			end)
		else
			if (cfgCnt - cnt)*Res.item[GlobalDefine.FishHookId].buy_gold <= LoginCtrl.mode.S2CEnterGame.diamond then
				PersonalCenterCtrl.C2SAttrSetBatteryRate(self.cfg.id)
			else
				HelpCtrl.OpenTipView(L("提   示"),L("钻石不足，可从商城中快速获取钻石"),function ()
					UIMgr.OpenView("ShopView",3)
				end,nil,nil,L("去商城购买"),L("取 消"))
			end
		end
	end
end

function GunRateUnlockView:AddListener()
	local OnGunRateUpdate = function (keys)
		self:OnGunRateUpdate(keys)
	end
	self:AddEvent(ED.MainCtrl_PlayInfoChange,OnGunRateUpdate)

	local onBagUpdate = function ()
		self:OnBagItemUpdate()
	end
	self:AddEvent(ED.BagCtrl_S2CBagUpdate,onBagUpdate)
end

function GunRateUnlockView:OnBagItemUpdate()
	self:UpdateProgress()
end

function GunRateUnlockView:AfterOpenView(t)
	-- self.OnUnlock = function (msg)
	-- 	self:OnGunUnlock(msg)
	-- end
	-- PersonalCenterCtrl.AddEvent(PersonalCenterEvent.GunRateUnlock,self.OnUnlock)

   	self:UpdateInfo()
end

function GunRateUnlockView:BeforeCloseView()
	-- if(self.OnUnlock ~= nil) then
	-- 	PersonalCenterCtrl.RemoveEvent(PersonalCenterEvent.GunRateUnlock,self.OnUnlock)
	-- 	self.OnUnlock = nil
	-- end
	for k,v in pairs(self.itemList) do
		v:Dispose()
	end
	self.itemList = {}
end

function GunRateUnlockView:OnGunUnlock(msg)
	local cfg = Res.gun_unlock[msg.lv]
	local items = {{GlobalDefine.Gold,cfg.give}}
	if(cfg.unlockIsland > 0) then
		table.insert(items,{cfg.unlockIsland,1})
	end
	HelpCtrl.OpenItemGetEffectView(items,L("解锁{1}倍炮",cfg.rate))
end

function GunRateUnlockView:OnGunRateUpdate(keys)
	if(keys ~= nil) then
		if(table.contains(keys,AttrDefine.ATTR_BATTERYRATE)) then
			self:UpdateInfo()
		end
	end
end

function GunRateUnlockView:UpdateInfo()
	local gunRates = {}
	local maxGunRate = LoginCtrl.mode.S2CEnterGame.battery_rate
	for k,v in pairs(Res.gun_unlock) do
		if(v.rate > maxGunRate) then
			table.insert(gunRates,v)
		end
	end
	table.sort(gunRates,function (a,b)
		if(a.rate == b.rate)then return tonumber(a.id) < tonumber(b.id) end
		return tonumber(a.rate) < tonumber(b.rate)
	end)

	if(#gunRates > self.maxShowNum) then
		for i=#gunRates,self.maxShowNum + 1,-1 do
			table.remove(gunRates,i)
		end
	end

	if(#gunRates > #self.itemList) then
		local count = #gunRates - #self.itemList
		for i=1,count do
			local temp = LH.GetGoBy(self.item,self.item.transform.parent.gameObject)
			temp:SetActive(true)
			temp.gameObject.name = (#self.itemList + i)
			local item = GunRateUnlockItem:New(temp)
			item:Init()
			table.insert(self.itemList,item)
		end
	end
	local count = #gunRates
	local index = 0
	for i=1,count do
		index = i
		self.itemList[i].gameObject.name = tostring(i)
		self.itemList[i]:Update(gunRates[i],(i == 1))
	end
	if(index < #self.itemList) then
		for i=#self.itemList,index + 1,-1 do
			self.itemList[i]:Dispose()
			table.remove(self.itemList,i)
		end
	end

	if(#gunRates > 0) then
		self.cfg = gunRates[1] 
	else
		self.cfg = nil
	end

	self:UpdateProgress()

	self.table:Reposition()
    --self.scrollView:ResetPosition()
    self.scrollViewRestrict:ResetToBegin()
end

function GunRateUnlockView:UpdateProgress( )
	local needHookCount
	if(self.cfg ~= nil) then
		if(#self.cfg.use_item == 0) then 
			needHookCount = 0
		else
			needHookCount = tonumber(self.cfg.use_item[2])
		end
	else
		needHookCount = 0
	end
	local cnt = BagCtrl.GetItemCntById(GlobalDefine.FishHookId)
	self.LabelProgress.text = L("{1}/{2}",cnt,needHookCount)
	local progress
	if(needHookCount == 0) then 
		progress = 1
	else
		progress = cnt / needHookCount
	end
	self.Progress:UpdateProgress(progress)
end

function GunRateUnlockView:OnDestory()
	for k,v in pairs(self.itemList) do
		v:Dispose()
	end
	self.itemList = nil
	this.scrollView = nil
	this.table = nil
	this.item = nil
	self.cfg = nil
end