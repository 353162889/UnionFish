Cmd_GuideEnterGame = Class(CommandBase)

function Cmd_GuideEnterGame:ctor()
end

function Cmd_GuideEnterGame:Execute(context)
	Cmd_GuideEnterGame.superclass.Execute(self)
	LogColor("#ff0000","Cmd_GuideEnterGame:Execute")
	self.onEnterRoom = function ()
		self:OnRealEnterRoom()
	end
	EventMgr.AddEvent(ED.MainCtrl_S2CRoomEnterRoom,self.onEnterRoom)

	-- local areaId = Res.scene[MainSceneId].area[1]
	-- self.selectIslandID = Res.area[areaId].island[1]

	local areaId,islandId = MainCtrl.GetFitAreaAndIsland()
	self.selectIslandID = islandId

	MainCtrl.C2SRoomEnterRoom(self.selectIslandID,1)
end

function Cmd_GuideEnterGame:OnRealEnterRoom()
	EventMgr.SendEvent(ED.LoadingView_SetProgress,{0})
	LuaSceneMgr.EnterScene(Res.island[self.selectIslandID].playSceneID)
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_GuideEnterGame:OnDestroy()
	Cmd_GuideEnterGame.superclass.OnDestroy(self)
	if(self.onEnterRoom ~= nil) then
		EventMgr.RemoveEvent(ED.MainCtrl_S2CRoomEnterRoom,self.onEnterRoom)
		self.onEnterRoom = nil
	end
end

function Cmd_GuideEnterGame:OnExecuteFinish()
     LogColor("#ff0000","Cmd_GuideEnterGame:OnExecuteFinish")
end



