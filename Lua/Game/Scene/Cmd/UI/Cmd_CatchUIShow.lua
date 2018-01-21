Cmd_CatchUIShow = Class(CommandBase)

function Cmd_CatchUIShow:ctor(...)
	self.roleObjId = select(1,...)
	self.num = select(2,...)
	self.fishInfo = select(3,...)
end

function Cmd_CatchUIShow:Execute(context)
	Cmd_CatchUIShow.superclass.Execute(self)
	local onFinish = function ()
		self:ShowFinish()
	end
	self.Timer = LH.UseVP(2,1,0,onFinish,nil)
	CatchMgr.ShowCatchSelf(self.roleObjId,self.num,self.fishInfo,nil)
end

function Cmd_CatchUIShow:ShowFinish()
	self.Timer = nil
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_CatchUIShow:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	Cmd_CatchUIShow.superclass.OnDestroy(self)
end