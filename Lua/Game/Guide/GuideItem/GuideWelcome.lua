require 'Game/Guide/GuideItem/GuideItem'

GuideWelcome = Class(GuideItem)

function GuideWelcome:OnUpdate(taskInfo)
	GuideWelcome.superclass.OnUpdate(self,taskInfo)
	LogColor("#ff0000","GuideWelcome:OnUpdate")
end

function GuideWelcome:OnEnter(...)
	self.cfg = GuideCtrl.GetGuideTaskCfg(self.taskInfo.id)
	local sceneType = self.cfg.handle.param.sceneType

	--任何切场景的操作都导致需要重新检测
	self.onSceneLoaded = function ()
		self:CheckSceneLoaded(sceneType)
	end
	EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)

	if(sceneType ~= nil) then
		self:CheckSceneLoaded(sceneType)
	else
		self:OpenView()
	end
	
	GuideWelcome.superclass.OnEnter(self)
	LogColor("#ff0000","GuideWelcome:OnEnter")
end

function GuideWelcome:CheckSceneLoaded(sceneType)
	if(LuaSceneMgr.CurSceneId > 0 and Res.scene[LuaSceneMgr.CurSceneId].type == sceneType) then
		self:OpenView()
	else
		self:RemoveSceneListener()
		self.onSceneLoaded = function ()
			self:CheckSceneLoaded(sceneType)
		end
		EventMgr.AddEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)
	end
end

function GuideWelcome:OpenView()
	UIMgr.OpenView("GuideWelcomeView",{self.taskInfo.id})
	
end

function GuideWelcome:RemoveSceneListener()
	if(self.onSceneLoaded ~= nil) then 
		EventMgr.RemoveEvent(ED.LuaSceneMgr_SceneLoaded,self.onSceneLoaded)
		self.onSceneLoaded = nil
	end
end

function GuideWelcome:OnExit()
	self:RemoveSceneListener()
	if(UIMgr.isOpened("GuideWelcomeView")) then
		UIMgr.CloseView("GuideWelcomeView")
	end
	GuideWelcome.superclass.OnExit(self)
	LogColor("#ff0000","GuideWelcome:OnExit")
end

function GuideWelcome:OnDispose()
	self:RemoveSceneListener()
	if(UIMgr.isOpened("GuideWelcomeView")) then
		UIMgr.CloseView("GuideWelcomeView")
	end
	GuideWelcome.superclass.OnDispose(self)
	LogColor("#ff0000","GuideWelcome:OnDispose")
end