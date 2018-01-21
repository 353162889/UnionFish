
Cmd_DelayTime = Class(CommandBase)

function Cmd_DelayTime:ctor(...)
	self.delay = select(1,...)
end

function Cmd_DelayTime:Execute(context)
	Cmd_DelayTime.superclass.Execute(self)
	local onFinish = function ()
		self:ShowFinish()
	end
	self.Timer = LH.UseVP(self.delay,1,0,onFinish,nil)
end

function Cmd_DelayTime:ShowFinish()
	self.Timer = nil
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_DelayTime:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	Cmd_DelayTime.superclass.OnDestroy(self)
end