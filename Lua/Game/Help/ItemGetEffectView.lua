
ItemGetEffectView=Class(BaseView)

function ItemGetEffectView:ConfigUI()    
    self.BtnConfirm = Find(self.gameObject,"BtnConfirm")
    local onConfirm = function (go)
    	self:OnClickConfirm(go)
    end
    LH.AddClickEvent(self.BtnConfirm,onConfirm)
    Find(self.BtnConfirm,"Label"):GetComponent("UILabel").text = L("确 认")

    self.ItemTemplate = Find(self.gameObject,"Container/Items/Item")
    self.ItemTemplate.gameObject:SetActive(false)

    self.ListItem = {}
    self.ListItemCell = {}

    self.TableContainer = Find(self.gameObject,"Container"):GetComponent("UITable")
    self.TableItems = Find(self.gameObject,"Container/Items"):GetComponent("UITable")

    self.TimeHandle = nil
    self.ShowIndex = 0

    self.ShowEffectID = 54005
    self.CacheCount = 2
    self.ListEffect = {}
    self.ids = nil

    self.LabelTitle = Find(self.gameObject,"LabelTitle"):GetComponent("UILabel")
end

function ItemGetEffectView:OnClickConfirm(go)
	UIMgr.CloseView("ItemGetEffectView")
end

function ItemGetEffectView:AfterOpenView(t)
	self:CacheEffect()
	
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	local title = t[2]
	if(title ~= nil) then
		self.LabelTitle.text = L("{1}",title)
	else
		self.LabelTitle.text = L("获得物品")
	end
	local ids = t[1]
	self.ids = ids
	local count = #self.ids - #self.ListItem
	if(count > 0) then
		for i=1,count do
			local temp = LH.GetGoBy(self.ItemTemplate,self.ItemTemplate.transform.parent.gameObject)
			local itemCell = ItemCell.Create(temp.transform:Find("Item").gameObject)
			itemCell.SetName("ItemCell")
			table.insert(self.ListItem,temp)
			table.insert(self.ListItemCell,itemCell)
		end
	end
	local index = 1
	for i=1,#self.ids do
		self.ListItem[i].gameObject:SetActive(true)
		self.ListItemCell[i].SetValue({id=self.ids[i][1],cnt=self.ids[i][2]})
		index = index + 1
	end

	for i=index,#self.ListItem do
		self.ListItem[i].gameObject:SetActive(false)
	end
	self.TableItems:Reposition()
	self.TableContainer:Reposition()
	for i=1,#self.ListItem do
		self.ListItem[i].gameObject:SetActive(false)
	end

	--self.BtnConfirm.gameObject:SetActive(false)

	self.ShowIndex = 1
	local OnDelay = function (lt)
		self:OnDelayShow()
	end
	--self.TimeHandle = LH.UseVP(0, #self.ids + 1, 0.5 ,OnDelay,{})
	self.TimeHandle = LH.UseVP(0, #self.ids, 0.15 ,OnDelay,{})

	local OnClose = function (lt)
		self.CloseTimeHandle = nil
		UIMgr.CloseView("ItemGetEffectView")
	end
	self.CloseTimeHandle = LH.UseVP(#self.ids * 0.2 + 2.2,1,0,OnClose,{})
	local OnHideItem = function (lt)
		self.HideItemTimeHandle = nil
		self:OnDelayHide()
	end
	self.HideItemTimeHandle = LH.UseVP(#self.ids * 0.2 + 2.1,1,0,OnHideItem,{})
end

function ItemGetEffectView:OnDelayShow()
	if(self.ShowIndex <= #self.ids) then
		local go = self.ListItem[self.ShowIndex].gameObject
		go:SetActive(true)
		local ts = go.transform:Find("Item"):GetComponent("TweenScale")
		local effectContainer = go.transform:Find("EffectContainer").gameObject
		local panel = GetParentPanel(effectContainer)
		if(panel ~= nil) then
			local effect = UnitEffectMgr.ShowUIEffectInParent(effectContainer,self.ShowEffectID,Vector3.zero,true,panel.startingRenderQueue - 10)
			table.insert(self.ListEffect,effect)
		end
		LH.SetTweenScale(ts,0,0.2,Vector3.zero,Vector3.one)
		--ts:ResetToBeginning()
		--ts:PlayForward()
	--else
	--	self.BtnConfirm.gameObject:SetActive(true)
	end
	self.ShowIndex = self.ShowIndex + 1
end

function ItemGetEffectView:OnDelayHide()
	local count = #self.ListItem
	for i=1,count do
		local ts = self.ListItem[i].transform:Find("Item"):GetComponent("TweenScale")
		LH.SetTweenScale(ts,0,0.2,Vector3.one,Vector3.zero)
	end
end

function ItemGetEffectView:BeforeCloseView()
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	if(self.CloseTimeHandle ~= nil) then
		self.CloseTimeHandle:Cancel()
		self.CloseTimeHandle = nil
	end
	if(self.HideItemTimeHandle ~= nil)then
		self.HideItemTimeHandle:Cancel()
		self.HideItemTimeHandle = nil
	end
	self:CacheEffect()
	self.ids = nil
end

function ItemGetEffectView:CacheEffect()
	if(self.ListEffect ~= nil) then
		for k,v in pairs(self.ListEffect) do
			if(UnitEffectMgr.GetCountByEffectID(self.ShowEffectID) > self.CacheCount)then
				UnitEffectMgr.DisposeEffect(v)
			else
				UnitEffectMgr.RecycleEffect(v)
			end
		end
		self.ListEffect = {}
	end
end

function ItemGetEffectView:DisposeEffect()
	if(self.ListEffect ~= nil) then
		for k,v in pairs(self.ListEffect) do
			UnitEffectMgr.DisposeEffect(v)
		end
		self.ListEffect = {}
	end
end

function ItemGetEffectView:OnDestory()
	self:DisposeEffect()
end