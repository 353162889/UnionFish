require 'Game/Task/TaskInfoItem'
TaskRightItem = {}
function TaskRightItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TaskRightItem:Init()
	self.Template = Find(self.gameObject,"ScrollView/Grid/Template")
	self.Template:SetActive(false)
	self.ScrollView = Find(self.gameObject,"ScrollView"):GetComponent("UIScrollView")
	self.Grid = Find(self.gameObject,"ScrollView/Grid"):GetComponent("UIGrid")

	self.ListItem = {}

	self.taskTabChange = function (index)
		self:OnTaskTabChange(index)
	end
	TaskCtrl.AddEvent(TaskEvent.OnTaskTabChange,self.taskTabChange)

	
end

--taskList，协议中的taskList
function TaskRightItem:Update(taskList)
	for i=1,#self.ListItem do
		self.ListItem[i]:SetActive(false)
	end
	if(taskList == nil or taskList.info == nil) then
		return
	end
	local tempList = {}
	for i,v in ipairs(taskList.info) do
		table.insert(tempList,v)
	end
	table.sort(tempList,function (a,b)
		if(a.finish_type ~= b.finish_type) then
			local tempA = 0
			if(a.finish_type == 0) then
				tempA = 1
			elseif(a.finish_type == 1) then
				tempA = 0
			elseif(a.finish_type == 2) then
				tempA = 2
			end

			local tempB = 0
			if(b.finish_type == 0) then
				tempB = 1
			elseif(b.finish_type == 1) then
				tempB = 0
			elseif(b.finish_type == 2) then
				tempB = 2
			end
			return tempA < tempB
		end
		return a.id < b.id
	end
	)

	local taskType = taskList.type
	local count = 0
	for i,v in ipairs(tempList) do
		count = count + 1
		
		if(#self.ListItem < i) then
			local item = LH.GetGoBy(self.Template,self.Template.transform.parent.gameObject)
			item:SetActive(true)
			local temp = TaskInfoItem:New(item)
			temp:Init()
			table.insert(self.ListItem,temp)
		end
		local taskInfoItem = self.ListItem[i]
		taskInfoItem.gameObject.name = tostring(i)
		taskInfoItem:SetActive(true)
		taskInfoItem:Update(taskList.type,v)
	end

	for i=count + 1,#self.ListItem do
		self.ListItem[i]:SetActive(false)
	end

	self.Grid:Reposition()
   	self.ScrollView:ResetPosition()
end

function TaskRightItem:OnTaskTabChange(index)
	local curType = Res.task_base[index].type
	local taskList = TaskCtrl.GetTasksByType(curType)
	self:Update(taskList)
end


function TaskRightItem:Dispose()
	if(self.taskTabChange ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnRankTabChange,self.taskTabChange)
		self.taskTabChange = nil
	end
	
end
