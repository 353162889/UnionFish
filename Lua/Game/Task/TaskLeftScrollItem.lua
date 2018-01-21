TaskLeftScrollItem = {}

function TaskLeftScrollItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TaskLeftScrollItem:Init()
	self.Template = Find(self.gameObject,"ScrollView/Grid/Template")
	self.Template:SetActive(false)
	self.SelectIndex = -1
	self.ListItem = {}
	local listTask = SortRes.Task_Base
	for i=1,#listTask do
		local item = LH.GetGoBy(self.Template,self.Template.transform.parent.gameObject)
		item:SetActive(true)
		local onClick = function (go)
			self:Update(i)
		end
		LH.AddClickEvent(Find(item,"UnSelect"),onClick)
		self:SetItem(item,listTask[i])
		table.insert(self.ListItem,item)
	end
	self.ScrollView = Find(self.gameObject,"ScrollView"):GetComponent("UIScrollView")
	self.Grid = Find(self.gameObject,"ScrollView/Grid"):GetComponent("UIGrid")

	self.LabelMyFinish = Find(self.gameObject,"LabelMyFinish"):GetComponent("UILabel")
	self.Grid:Reposition()
   	self.ScrollView:ResetPosition()
end

function TaskLeftScrollItem:SetItem(item,cfg)
	local selectIcon = Find(item,"Select/Icon"):GetComponent("UISprite")
	local selectName = Find(item,"Select/Label"):GetComponent("UILabel")
	local unSelectIcon = Find(item,"UnSelect/Icon"):GetComponent("UISprite")
	local unSelectName = Find(item,"UnSelect/Label"):GetComponent("UILabel")
	selectIcon.spriteName = "task_type_select_"..cfg.type
	-- selectName.text = L("{1}",cfg.name)
	LB(selectName,"{1}",cfg.name)
	unSelectIcon.spriteName = "task_type_"..cfg.type
	-- unSelectName.text = L("{1}",cfg.name)
	LB(unSelectName,"{1}",cfg.name)
end

function TaskLeftScrollItem:SetItemSelect(item,select)
	local selectGO = Find(item,"Select")
	local unSelectGO = Find(item,"UnSelect")
	selectGO:SetActive(select)
	unSelectGO:SetActive(not select)
end

function TaskLeftScrollItem:Update(SelectIndex)
	if(self.SelectIndex ~= SelectIndex) then
		self.SelectIndex = SelectIndex
		for i=1,#self.ListItem do
			self:SetItemSelect(self.ListItem[i],SelectIndex == i)
		end
		if(self.SelectIndex > 0) then
			TaskCtrl.SendEvent(TaskEvent.OnTaskTabChange,self.SelectIndex)
		end
		self.Grid:Reposition()
   		self.ScrollView:ResetPosition()
	end
end

function TaskLeftScrollItem:UpdateMyTask()
	self.LabelMyFinish.text = L("今日积分：{1}",TaskCtrl.mode.TaskInfos.day_score)
end

function TaskLeftScrollItem:Dispose()
	-- body
end
