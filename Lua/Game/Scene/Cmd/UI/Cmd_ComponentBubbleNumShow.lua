Cmd_ComponentBubbleNumShow = Class(CommandBase)

function Cmd_ComponentBubbleNumShow:ctor(...)
	self.component = select(1,...)
	self.pos = select(2,...)
	self.num = select(3,...)
	self.color = select(4,...)
end

function Cmd_ComponentBubbleNumShow:Execute(context)
	Cmd_ComponentBubbleNumShow.superclass.Execute(self)
	local onFinish = function ()
		self:ShowFinish()
	end
	self.Timer = LH.UseVP(0.5,1,0,onFinish,nil)
	self.component:ShowNum(self.pos,self.num,self.color)
end

function Cmd_ComponentBubbleNumShow:ShowFinish()
	self.Timer = nil
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_ComponentBubbleNumShow:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	self.component =nil
	Cmd_ComponentBubbleNumShow.superclass.OnDestroy(self)
end