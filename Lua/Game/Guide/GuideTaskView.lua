GuideTaskView=Class(BaseView)

function GuideTaskView:ConfigUI()
	self.BtnGo = Find(self.gameObject,"Content/Collider")
	local onClickGo = function (go)
		local taskInfo = TaskCtrl.GetTaskInfo(self.type,self.taskId)
		if(taskInfo.finish_type == 1) then
			TaskCtrl.C2STaskAcceptPrize(self.type,self.taskId)
		end
	end
	LH.AddClickEvent(self.BtnGo,onClickGo)
	self.TP = Find(self.gameObject,"Content"):GetComponent("TweenPosition")
	self.TS = Find(self.gameObject,"Content"):GetComponent("TweenScale")
	self.MaskTA = Find(self.gameObject,"Mask"):GetComponent("TweenAlpha")
	self.MaskTS = Find(self.gameObject,"Mask"):GetComponent("TweenScale")

	self.GoProgress = Find(self.gameObject,"Content/Progress")
	self.LabelTaskName = Find(self.gameObject,"Content/LabelDesc"):GetComponent("UILabel")
	self.SpriteIcon = Find(self.gameObject,"Content/SpriteIcon"):GetComponent("UISprite")
	self.LabelBonus = Find(self.gameObject,"Content/LabelBonus"):GetComponent("UILabel")
	self.LabelProgress = Find(self.gameObject,"Content/Progress/LabelProgress"):GetComponent("UILabel")
	self.SpriteProgress = UIProgress:New(Find(self.gameObject,"Content/Progress/SpriteProgress"),UIProgressMode.Horizontal)
	self.SpriteProgress:UpdateProgress(0)
	self.GoFinish = Find(self.gameObject,"Content/GoFinish")
	self.EffectParent = Find(self.GoFinish,"Effect")
	self.BonusEffectParent = Find(self.GoFinish,"BonusEffect")
	Find(self.gameObject,"Content/GoFinish/Label"):GetComponent("UILabel").text = L("点击领取奖励")
end

function GuideTaskView:AfterOpenView(t)
	self.taskId = tonumber(t[1])
	self.type = TaskType.Guide
	self:InitListener(true)
	self:UpdateView()
	self.TP:ResetToBeginning()
    self.TP:PlayForward()

    self.TS:ResetToBeginning()
    self.TS:PlayForward()

    self.MaskTA:ResetToBeginning()
    self.MaskTA:PlayForward()

    self.MaskTS:ResetToBeginning()
    self.MaskTS:PlayForward()
end

function GuideTaskView:InitListener(isAdd)
	if(isAdd) then
		self.onChange = function (lt)
			if(tonumber(lt[1]) == self.type and tonumber(lt[2]) == self.taskId) then
				self:UpdateView()
			end
		end
		TaskCtrl.AddEvent(TaskEvent.OnProgressChange,self.onChange)

		self.onGetTaskBonus = function (param)
			local taskType = tonumber(param[1])
			local taskId = tonumber(param[2])
			if(taskType == self.type and self.taskId == taskId) then
				UIMgr.CloseView("GuideTaskView")
			end
		end
		TaskCtrl.AddEvent(TaskEvent.OnTaskFinishGetBonus,self.onGetTaskBonus)
	else
		if(self.onChange ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnProgressChange,self.onChange)
			self.onChange = nil
		end
		if(self.onGetTaskBonus ~= nil) then
			TaskCtrl.RemoveEvent(TaskEvent.OnTaskFinishGetBonus,self.onGetTaskBonus)
			self.onGetTaskBonus = nil
		end
	end
end

function GuideTaskView:BeforeCloseView()
	self:InitListener(false)
	if(self.effect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.effect)
		self.effect = nil
	end
	if(self.bonusEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.bonusEffect)
		self.bonusEffect = nil
	end
end

function GuideTaskView:UpdateView()
	local taskInfo = TaskCtrl.GetTaskInfo(self.type,self.taskId)
	local cfgs = Res["task"..self.type]
	local cfg = cfgs[self.taskId]
	LB(self.LabelTaskName,"{1}",cfg.desc)
	self.LabelProgress.text = L("{1}/{2}",taskInfo.progress,cfg.task_count)
	self.SpriteProgress:UpdateProgress(taskInfo.progress / cfg.task_count)
	self.SpriteIcon.spriteName = cfg.bonusIcon
	self.SpriteIcon:MakePixelPerfect()
	self.LabelBonus.text = L("x{1}",tostring(cfg.items[1][2]))

	if(taskInfo.finish_type == 0) then
		self.GoFinish:SetActive(false)
		self.GoProgress:SetActive(true)
		
	else
		self.GoFinish:SetActive(true)
		self.GoProgress:SetActive(false)
		-- if(self.effect == nil) then
		-- 	local renderQueue = GetParentPanelRenderQueue(self.EffectParent)
		-- 	self.effect = UnitEffectMgr.ShowUIEffectInParent(self.EffectParent,54013,Vector3.zero,true,renderQueue)
		-- end
		if(self.bonusEffect == nil) then
			local renderQueue = GetParentPanelRenderQueue(self.BonusEffectParent)
			self.bonusEffect = UnitEffectMgr.ShowUIEffectInParent(self.BonusEffectParent,54013,Vector3.zero,true,renderQueue)
		end
	end
end

function GuideTaskView:OnDestory()
	
end
