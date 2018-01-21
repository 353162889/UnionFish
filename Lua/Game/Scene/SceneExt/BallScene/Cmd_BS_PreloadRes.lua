
Cmd_BS_PreloadRes = Class(CommandBase)

--ctor这里不需要Cmd_FS_PreloadRes.superclass.ctor(self),Class中有做处理
function Cmd_BS_PreloadRes:ctor()
end

function Cmd_BS_PreloadRes:Execute(context)
	Cmd_BS_PreloadRes.superclass.Execute(self,context)
	BallScene.otherResLoader:Clear()
	--预加载mainview资源
	local names = {SortRes.DicView["MainView"].path}
	self.onComplete = function (loader)
		self:OnLoadIslandResComplete(loader)
	end
	BallScene.otherResLoader:LoadResList(names,self.onComplete,nil)
end

function Cmd_BS_PreloadRes:OnLoadIslandResComplete(loader)
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_BS_PreloadRes:OnDestroy()
	self.onComplete = nil
	Cmd_BS_PreloadRes.superclass.OnDestroy(self)
end