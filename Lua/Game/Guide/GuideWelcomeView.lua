GuideWelcomeView=Class(BaseView)

function GuideWelcomeView:ConfigUI()
	self.Content = Find(self.gameObject,"Content")
	self.Content:SetActive(false)
	self.TS = self.Content:GetComponent("TweenScale")
   	self.BtnConfirm = Find(self.gameObject,"Content/BtnConfirm")
   	self.MaskSprite = Find(self.gameObject,"Mask"):GetComponent("UISprite")
   	local onClickConfirm = function (go)
   		LH.Play(go,"Play")
		TaskCtrl.C2STaskClientTask()
	end
	LH.AddClickEvent(self.BtnConfirm,onClickConfirm)
	Find(self.BtnConfirm,"Label"):GetComponent("UILabel").text = L("确 定")
end

function GuideWelcomeView:AfterOpenView(t)
	self.type = TaskType.Guide
	self.taskId = tonumber(t[1])
	self.Content:SetActive(false)
	self.MaskSprite.alpha = 0.01

	self:RemoveTimer()
	self.cfg = GuideCtrl.GetGuideTaskCfg(self.taskId)
	local delay = self.cfg.handle.param.delay
	if(delay ~= nil and delay > 0) then
		local onDelay = function ()
			-- body
			self.Timer = nil
			self:RealOpen()
		end
		self.Timer = LH.UseVP(delay, 1, 0,onDelay ,nil)
	else
		self:RealOpen()
	end
end

function GuideWelcomeView:RemoveTimer()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
end

function GuideWelcomeView:RealOpen()
	self.Content:SetActive(true)
	self.MaskSprite.alpha = 1
	self.TS:ResetToBeginning()
   	self.TS:PlayForward()
	self.onGetTaskBonus = function (param)
		local taskType = tonumber(param[1])
		local taskId = tonumber(param[2])
		if(taskType == self.type and self.taskId == taskId) then
			UIMgr.CloseView("GuideWelcomeView")
		end
	end
	TaskCtrl.AddEvent(TaskEvent.OnTaskFinishGetBonus,self.onGetTaskBonus)

	self.onTaskChange = function (param)
		local taskType = tonumber(param[1])
		local taskId = tonumber(param[2])
		if(taskType == self.type and self.taskId == taskId) then
			self:OnFinishTask(taskType,taskId)
		end
	end
	TaskCtrl.AddEvent(TaskEvent.OnProgressChange,self.onTaskChange)
end


function GuideWelcomeView:OnFinishTask(type,id)
	TaskCtrl.C2STaskAcceptPrize(type,id)
end

function GuideWelcomeView:BeforeCloseView()
	self:RemoveTimer()
	if(self.onGetTaskBonus ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnTaskFinishGetBonus,self.onGetTaskBonus)
		self.onGetTaskBonus = nil
	end
	if(self.onTaskChange ~= nil) then
		TaskCtrl.RemoveEvent(TaskEvent.OnProgressChange,self.onTaskChange)
		self.onTaskChange = nil
	end
end

function GuideWelcomeView:OnDestory()
end