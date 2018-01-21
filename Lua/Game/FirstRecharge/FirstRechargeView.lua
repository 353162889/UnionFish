FirstRechargeView=Class(BaseView)

function FirstRechargeView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	local onClickClose = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("FirstRechargeView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)

	self.BtnRecharge = Find(self.gameObject,"Content/BtnRecharge")
	local onClickRecharge = function (go)
		
		local taskInfo = TaskCtrl.GetTaskInfo(TaskType.Main,GlobalDefine.FirstRechargeTaskId)
		if(taskInfo ~= nil) then
			if(taskInfo.finish_type == 0) then
				LH.Play(go,"Play")
				UIMgr.OpenView("ShopView",3)
			elseif(taskInfo.finish_type == 1) then
				LH.Play(go,"Play")
				TaskCtrl.C2STaskAcceptPrize(TaskType.Main,GlobalDefine.FirstRechargeTaskId)
			end
		end
	end
	LH.AddClickEvent(self.BtnRecharge,onClickRecharge)
	self.LabelRecharge = Find(self.BtnRecharge,"Label"):GetComponent("UILabel")

	self.ItemTemplate = Find(self.gameObject,"Content/Panel/Items/Template")
	self.ItemTemplate:SetActive(false)
	
	self.Grid = Find(self.gameObject,"Content/Panel/Items"):GetComponent("UIGrid")

	self.ListItem = {}

	self.Effect_1 = Find(self.gameObject,"Content/Effects/Effect_1")
	self.Effect_2 = Find(self.gameObject,"Content/Effects/Effect_2")

	self.BgPanel = Find(self.gameObject,"Content/Panel"):GetComponent("UIPanel")

	self.Effect_1_Item = nil
	self.Effect_2_Item = nil

	self.ListEffect = {}

end

function FirstRechargeView:AfterOpenView(t)
	self.id = tonumber(t[1])
	local item = Res.item[self.id]
	if(item ~= nil and item.type == ItemType.GiftBag) then
		local items = item.items
		local count = #items
		for i=1,count do
			if(i > #self.ListItem) then
				local templateGO = LH.GetGoBy(self.ItemTemplate,self.ItemTemplate.transform.parent.gameObject)
				table.insert(self.ListItem,templateGO)
			end
			local go = self.ListItem[i]

			go:SetActive(true)
			local temp = items[i]
			self:SetItem(go,{id=tonumber(temp[1]),cnt=tonumber(temp[2])})
		end
		for i=count + 1,#self.ListItem do
			self.ListItem[i]:SetActive(false)
		end
	else
		for k,v in pairs(self.ListItem) do
			v:SetActive(false)
		end
	end
	self.Grid:Reposition()

	local renderQueue = self.BgPanel.startingRenderQueue
	self.Effect_1_Item = UnitEffectMgr.ShowUIEffectInParent(self.Effect_1,54011,Vector3.zero,true,renderQueue - 1)
	self.Effect_2_Item = UnitEffectMgr.ShowUIEffectInParent(self.Effect_2,54012,Vector3.zero,true,renderQueue - 1)

	self:UpdateBtn()
	self.onTaskUpdate = function (t)
		local taskType = t[1]
		local taskId = t[2]
		if(taskType == TaskType.Main and taskId == GlobalDefine.FirstRechargeTaskId) then
			self:UpdateBtn()
		end
	end
	self.onTaskFinish = function (t)
		local taskType = t[1]
		local taskId = t[2]
		if(taskType == TaskType.Main and taskId == GlobalDefine.FirstRechargeTaskId) then
			UIMgr.CloseView("FirstRechargeView")
			MainCtrl.SendEvent(MainEvent.MainCtrl_RefreshView)
		end
	end
	TaskCtrl.AddEvent(TaskEvent.OnProgressChange,self.onTaskUpdate)
	TaskCtrl.AddEvent(TaskEvent.OnTaskFinish,self.onTaskFinish)
	self.onTaskFinishGetBonus = function (t)
		local taskType = t[1]
		local taskId = t[2]
		if(taskType == TaskType.Main and taskId == GlobalDefine.FirstRechargeTaskId) then
			UIMgr.CloseView("FirstRechargeView")
			MainCtrl.SendEvent(MainEvent.MainCtrl_RefreshView)
		end
	end
	TaskCtrl.AddEvent(TaskEvent.OnTaskFinishGetBonus,self.onTaskFinishGetBonus)
end

function FirstRechargeView:UpdateBtn()
	local taskInfo = TaskCtrl.GetTaskInfo(TaskType.Main,GlobalDefine.FirstRechargeTaskId)
	if(taskInfo ~= nil) then
		if(taskInfo.finish_type == 0) then
			self.LabelRecharge.text = L("充 值")
		elseif(taskInfo.finish_type == 1) then
			self.LabelRecharge.text = L("领 取")
		else
			self.LabelRecharge.text = L("已领取")
		end
	end
end

function FirstRechargeView:SetItem(go,item)
	local itemCfg = BagCtrl.GetItemConfig(item.id)
	local iconGO = Find(go,"Icon")
	if(itemCfg ~= nil) then
		iconGO:GetComponent("UISprite").spriteName = itemCfg.icon
	end
	local label = Find(go,"Label"):GetComponent("UILabel")
	if(item.cnt > 1) then
		label.gameObject:SetActive(true)
		label.text = L("x{1}",item.cnt)
	else
		label.gameObject:SetActive(false)
	end
	local renderQueue = self.BgPanel.startingRenderQueue
	local parent = Find(go,"Effect")
	local effect = UnitEffectMgr.ShowUIEffectInParent(parent,54010,Vector3.zero,true,renderQueue + 10)
	table.insert(self.ListEffect,effect)
end

function FirstRechargeView:BeforeCloseView()
	for k,v in pairs(self.ListItem) do
		v:SetActive(false)
	end
	if(self.Effect_1_Item ~= nil) then
		UnitEffectMgr.DisposeEffect(self.Effect_1_Item)
		self.Effect_1_Item = nil
	end
	if(self.Effect_2_Item ~= nil) then
		UnitEffectMgr.DisposeEffect(self.Effect_2_Item)
		self.Effect_2_Item = nil
	end
	for k,v in pairs(self.ListEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	self.ListEffect = {}

	if(self.onTaskUpdate ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnProgressChange,self.onTaskUpdate)
		self.onTaskUpdate = nil
	end
	if(self.onTaskFinish ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnTaskFinish,self.onTaskFinish)
		self.onTaskFinish = nil
	end
	if(self.onTaskFinishGetBonus ~= nil) then 
		TaskCtrl.RemoveEvent(TaskEvent.OnTaskFinishGetBonus,self.onTaskFinishGetBonus)
		self.onTaskFinishGetBonus = nil
	end
end

function FirstRechargeView:OnDestory()
end

