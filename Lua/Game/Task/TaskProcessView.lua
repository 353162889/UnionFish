
TaskProcessView=Class(BaseView)

function TaskProcessView:ConfigUI()
	self.BtnGo = Find(self.gameObject,"Content/Collider")
	local onClickGo = function (go)
		local taskInfo = TaskCtrl.GetTaskInfo(self.type,self.taskId)
		if(taskInfo.finish_type == 0) then
			TaskCtrl.OpenView(self.type)
		elseif(taskInfo.finish_type == 1) then
			UIMgr.CloseView("TaskProcessView")
			--直接完成任务
			TaskCtrl.C2STaskAcceptPrize(self.type,self.taskId)
		elseif(taskInfo.finish_type == 2) then
			UIMgr.CloseView("TaskProcessView")
		end
	end
	LH.AddClickEvent(self.BtnGo,onClickGo)
	self.TP = Find(self.gameObject,"Content"):GetComponent("TweenPosition")

	self.GoProgress = Find(self.gameObject,"Content/Progress")
	self.LabelTaskName = Find(self.gameObject,"Content/LabelDesc"):GetComponent("UILabel")
	self.SpriteIcon = Find(self.gameObject,"Content/SpriteIcon"):GetComponent("UISprite")
	self.LabelProgress = Find(self.gameObject,"Content/Progress/LabelProgress"):GetComponent("UILabel")
	-- self.SpriteProgress = Find(self.gameObject,"Content/Progress/SpriteProgress"):GetComponent("UISprite")
	self.SpriteProgress = UIProgress:New(Find(self.gameObject,"Content/Progress/SpriteProgress"),UIProgressMode.Horizontal)
	self.SpriteProgress:UpdateProgress(0)
	self.GoFinish = Find(self.gameObject,"Content/GoFinish")
	self.EffectParent = Find(self.GoFinish,"Effect")
	Find(self.gameObject,"Content/GoFinish/Label"):GetComponent("UILabel").text = L("完成任务，点击领奖")
end

function TaskProcessView:AfterOpenView(t)
	self.type = tonumber(t[1])
	self.taskId = tonumber(t[2])
	self:InitListener(true)
	self:UpdateView()
	self:Show(true)
end

function TaskProcessView:Show(isShow)
	if(isShow) then
		LH.SetTweenPosition(self.TP,0,1,Vector3.New(0,200,0),Vector3.zero)
	else
		LH.SetTweenPosition(self.TP,0,1,Vector3.zero,Vector3.New(0,200,0))
	end
end

function TaskProcessView:InitListener(isAdd)
	if(isAdd) then
		self.onChange = function (lt)
			if(tonumber(lt[1]) == self.type and tonumber(lt[2]) == self.taskId) then
				self:UpdateView()
			end
		end
		TaskCtrl.AddEvent(TaskEvent.OnProgressChange,self.onChange)

		self.onCurTaskChange = function (lt)
			self.type = tonumber(lt[1])
			self.taskId = tonumber(lt[2])
			self:UpdateView()
		end
		TaskCtrl.AddEvent(TaskEvent.OnCurTaskChange,self.onCurTaskChange)
	else
		if(self.onChange ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnProgressChange,self.onChange)
			self.onChange = nil
		end
		if(self.onCurTaskChange ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnCurTaskChange,self.onCurTaskChange)
			self.onCurTaskChange = nil
		end
	end
end

function TaskProcessView:BeforeCloseView()
	self:InitListener(false)
	if(self.effect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.effect)
		self.effect = nil
	end
end

function TaskProcessView:UpdateView()
	local taskInfo = TaskCtrl.GetTaskInfo(self.type,self.taskId)
	local cfgs = Res["task"..self.type]
	local cfg = cfgs[self.taskId]
	LB(self.LabelTaskName,"{1}",cfg.desc)
	self.LabelProgress.text = L("{1}/{2}",taskInfo.progress,cfg.task_count)
	-- self.SpriteProgress.fillAmount = taskInfo.progress / cfg.task_count
	self.SpriteProgress:UpdateProgress(taskInfo.progress / cfg.task_count)
	self.SpriteIcon.spriteName = cfg.icon_name

	if(taskInfo.finish_type == 0) then
		self.GoFinish:SetActive(false)
		self.GoProgress:SetActive(true)
		-- if(self.effect == nil) then
		-- 	local renderQueue = GetParentPanelRenderQueue(self.EffectParent)
		-- 	self.effect = UnitEffectMgr.ShowUIEffectInParent(self.EffectParent,54013,Vector3.zero,true,renderQueue)
		-- end
	else
		self.GoFinish:SetActive(true)
		self.GoProgress:SetActive(false)
		TaskCtrl.DelayChangeCurTask(20)
	end
end

function TaskProcessView:OnDestory()
	
end
