require 'Game/Guide/GuideItem/GuideItem'
require 'Game/Guide/GuideTaskCond/GuideTaskCondition'

GuideShowTask = Class(GuideItem)

function GuideShowTask:OnUpdate(taskInfo)
	GuideShowTask.superclass.OnUpdate(self,taskInfo)
	LogColor("#ff0000","GuideShowTask:OnUpdate")
end

function GuideShowTask:OnEnter(...)
	if(select('#',...) > 0) then
		--任务切换导致进行当前操作
		self.taskEnter = true
	else
		--切场景切换导致进行当前操作
		self.taskEnter = false
	end

	self.cfg = GuideCtrl.GetGuideTaskCfg(self.taskInfo.id)
	local sceneType = self.cfg.handle.param.sceneType

	--任何切场景的操作都导致需要重新检测
	self.onSceneLoaded = function ()
		self:CheckSceneLoaded(sceneType)
	end
	EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)

	--监听客户端任务完成事件
	self.onTaskFinish = function (t)
		self:OnClientTaskFinish(t)
	end
	GuideCtrl.AddEvent(GuideEvent.OnClientFinish,self.onTaskFinish)

	if(sceneType ~= nil) then
		self:CheckSceneLoaded(sceneType)
	else
		self:DoSomething()
	end
	self:CheckFinish()
	GuideShowTask.superclass.OnEnter(self)
	LogColor("#ff0000","GuideShowTask:OnEnter")
end

function GuideShowTask:OnClientTaskFinish(t)
	local key = t[1]
	if(key ~= nil and tonumber(key) == self.cfg.handle.param.TaskKey) then
		if(self.cfg.handle.param.TaskKeyCond == nil) then
			self:ClientTaskFinish()
		else
			local cond = self.cfg.handle.param.TaskKeyCond
			local param = self.cfg.handle.param.TaskKeyParam
			if(GuideTaskCondition.IsCondition(cond,param)) then
				self:ClientTaskFinish()
			end
		end
	end
end

function GuideShowTask:CheckFinish()
	LogColor("#ff0000","CheckFinish",self.cfg.handle.param.TaskKeyCond)
	if(self.cfg.handle.param.TaskKeyCond ~= nil) then
		local cond = self.cfg.handle.param.TaskKeyCond
		local param = self.cfg.handle.param.TaskKeyParam
		if(GuideTaskCondition.IsCondition(cond,param)) then
			self:ClientTaskFinish()
		end
	end
end

function GuideShowTask:ClientTaskFinish()
	if(self.taskInfo.finish_type == 0) then
		TaskCtrl.C2STaskClientTask()
	end
	if(self.cfg.handle.param.GetBonus == 1) then
		if(self.taskInfo.finish_type == 1) then
			TaskCtrl.C2STaskAcceptPrize(TaskType.Guide,self.taskInfo.id)
		end
	end
end

function GuideShowTask:CheckSceneLoaded(sceneType)
	if(LuaSceneMgr.CurSceneId > 0 and Res.scene[LuaSceneMgr.CurSceneId].type == sceneType) then
		self:DoSomething()
	else
		--切场景切换导致进行当前操作
		self.taskEnter = false
		self:RemoveTimer()
		self:RemoveSceneListener()
		if(UIMgr.isOpened("GuideTaskView")) then
			UIMgr.CloseView("GuideTaskView")
		end
		self.onSceneLoaded = function ()
			GuideCtrl.HideArrow()
			self:CheckSceneLoaded(sceneType)
		end
		EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)
	end
end

function GuideShowTask:DoSomething()
	self:RemoveTimer()
	local delay = nil
	if(self.taskEnter) then
		delay = self.cfg.handle.param.taskDelay
	else 
		delay = self.cfg.handle.param.sceneDelay
	end

	if(delay ~= nil and delay > 0) then
		local onDelay = function ()
			-- body
			self.Timer = nil
			self:RealDoSomethine()
		end
		self.Timer = LH.UseVP(delay, 1, 0,onDelay ,nil)
	else
		self:RealDoSomethine()
	end
end

function GuideShowTask:RealDoSomethine()
	if(UIMgr.isOpened("GuideTaskView")) then
		UIMgr.CloseView("GuideTaskView")
	end
	UIMgr.OpenView("GuideTaskView",{self.taskInfo.id})
	if(self.cfg.handle.param.Arrow ~= nil) then
		local cfgArrow = self.cfg.handle.param.Arrow
		local arrowParentType = cfgArrow.ArrowParentType
		local tablePos = cfgArrow.ArrowOffset
		local pos = Vector3.New(tablePos[1],tablePos[2],tablePos[3])
		local angle = cfgArrow.ArrowAngle
		local delay = cfgArrow.ArrowDelay
		local druation = cfgArrow.ArrowDruation
		local desc = cfgArrow.Desc
		local tableDescOffset = cfgArrow.DescOffset
		local descOffset = nil
		if(tableDescOffset ~= nil) then
			descOffset = Vector3.New(tableDescOffset[1],tableDescOffset[2],tableDescOffset[3])
		end
		local isLocal = false
		if(cfgArrow.IsLocal == 1) then isLocal = true end
		GuideCtrl.ShowArrow(arrowParentType,pos,isLocal,angle,delay,druation,desc,descOffset)
	end
	local NeedOpenView = self.cfg.handle.param.OpenView
	LogColor("#ff0000","NeedOpenView",NeedOpenView)
	if(NeedOpenView ~= nil) then
		local delay = self.cfg.handle.param.DelayOpenView
		if(delay ~= nil and delay > 0) then
			local onDelay = function ()
				-- body
				self.Timer = nil
				local param = self:GetViewParam(self.cfg.handle.param.OpenViewType)
				UIMgr.OpenView(NeedOpenView,param)
			end
			self:RemoveTimer()
			self.Timer = LH.UseVP(delay, 1, 0,onDelay ,nil)
		else
			UIMgr.OpenView("FishDicView",{MainCtrl.mode.CurIslandId,1})
			local param = self:GetViewParam(self.cfg.handle.param.OpenViewType)
			UIMgr.OpenView(NeedOpenView,param)
		end
	end
end

function GuideShowTask:GetViewParam(type)
	if(type == 1) then
		return {MainCtrl.mode.CurIslandId,1}
	end
	return nil
end

function GuideShowTask:RemoveTimer()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
end

function GuideShowTask:RemoveSceneListener()
	if(self.onSceneLoaded ~= nil) then 
		EventMgr.RemoveEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)
		self.onSceneLoaded = nil
	end
end

function GuideShowTask:RemoveTaskFinishListener()
	if(self.onTaskFinish ~= nil) then
		GuideCtrl.RemoveEvent(GuideEvent.OnClientFinish,self.onTaskFinish)
		self.onTaskFinish = nil
	end
end

function GuideShowTask:OnExit()
	--显示离开的
	if(self.cfg.handle.param.ArrowEnd ~= nil) then
		local cfgArrow = self.cfg.handle.param.ArrowEnd
		local arrowParentType = cfgArrow.ArrowParentType
		local tablePos = cfgArrow.ArrowOffset
		local pos = Vector3.New(tablePos[1],tablePos[2],tablePos[3])
		local angle = cfgArrow.ArrowAngle
		local delay = cfgArrow.ArrowDelay
		local druation = cfgArrow.ArrowDruation
		local desc = cfgArrow.Desc
		local tableDescOffset = cfgArrow.DescOffset
		local descOffset = nil
		if(tableDescOffset ~= nil) then
			descOffset = Vector3.New(tableDescOffset[1],tableDescOffset[2],tableDescOffset[3])
		end
		local isLocal = false
		if(cfgArrow.IsLocal == 1) then isLocal = true end
		LogColor("#ff0000","delay",delay,"druation",druation)
		GuideCtrl.ShowArrow(arrowParentType,pos,isLocal,angle,delay,druation,desc,descOffset)
	end
	self:RemoveTimer()
	self:RemoveSceneListener()
	self:RemoveTaskFinishListener()
	GuideShowTask.superclass.OnExit(self)
	LogColor("#ff0000","GuideShowTask:OnExit")
end

function GuideShowTask:OnDispose()
	self:RemoveTimer()
	self:RemoveSceneListener()
	self:RemoveTaskFinishListener()
	GuideShowTask.superclass.OnDispose(self)
	LogColor("#ff0000","GuideShowTask:OnDispose")
end