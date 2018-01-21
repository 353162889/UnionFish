require 'Game/Task/TaskLeftScrollItem'
require 'Game/Task/TaskRightItem'
require 'Game/Task/TaskBonusProgress'
TaskView=Class(BaseView)

function TaskView:ConfigUI()
	self.BtnClose = Find(self.gameObject,"Content/BtnClose")
	local onClickClose = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("TaskView")
	end
	LH.AddClickEvent(self.BtnClose,onClickClose)

	local leftGo = Find(self.gameObject,"Content/Left")
	self.LeftItem = TaskLeftScrollItem:New(leftGo)
	self.LeftItem:Init()

	local rightGo = Find(self.gameObject,"Content/Right")
	self.RightItem = TaskRightItem:New(rightGo)
	self.RightItem:Init()

	local bonusProgressGo = Find(self.gameObject,"Content/BonusProgress")
	self.BonusProgress = TaskBonusProgress:New(bonusProgressGo)
	self.BonusProgress:Init()

	Find(self.gameObject,"Bgs/BG_2/lbl"):GetComponent("UILabel").text = L("每 日 任 务")
end

function TaskView:AfterOpenView(t)
	self:InitListener(true)
	local taskType = tonumber(t[1])
	if(taskType == nil) then taskType = 1 end
	self.LeftItem:Update(taskType)
	self.LeftItem:UpdateMyTask()
	self.BonusProgress:AfterOpenView()
	TaskCtrl.C2STaskGetInfo()
end

function TaskView:InitListener(isAdd)
	if(isAdd) then
		self.getTaskInfo = function ()
			self:UpdateView()
		end
		TaskCtrl.AddEvent(TaskEvent.OnGetTaskInfo,self.getTaskInfo)

		self.taskGetBonus = function ()
			self:UpdateView()
		end
		TaskCtrl.AddEvent(TaskEvent.OnGetTaskBonus,self.taskGetBonus)
	else
		if(self.getTaskInfo ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnGetTaskInfo,self.getTaskInfo)
			self.getTaskInfo = nil
		end
		if(self.taskGetBonus ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnGetTaskBonus,self.taskGetBonus)
			self.taskGetBonus = nil
		end
	end
end

function TaskView:BeforeCloseView()
	self:InitListener(false)
	self.BonusProgress:BeforeCloseView()
	self.LeftItem:Update(-1)
end

function TaskView:UpdateView()
	self.BonusProgress:Update()
	if(self.LeftItem.SelectIndex < 1) then return end
	self.RightItem:OnTaskTabChange(self.LeftItem.SelectIndex)
	self.LeftItem:UpdateMyTask()
end

function TaskView:OnRankChange(listChangedType)
	
end

function TaskView:OnDestory()
	self.LeftItem:Dispose()
	self.RightItem:Dispose()
	self.BonusProgress:Dispose()
end
