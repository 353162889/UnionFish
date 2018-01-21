Cmd_GunBubbleNumShow = Class(CommandBase)

function Cmd_GunBubbleNumShow:ctor(...)
	self.gun = select(1,...)
	self.type = select(2,...)
	self.num = select(3,...)
	self.color = select(4,...)
end

function Cmd_GunBubbleNumShow:Execute(context)
	Cmd_GunBubbleNumShow.superclass.Execute(self)
	local onFinish = function ()
		self:ShowFinish()
	end
	local delayTime = 0.5
	if(self.parent ~= nil) then
		local count = self.parent:ChildCount()
		if(count > 4) then
			delayTime = 0.2
		end
	end
	self.Timer = LH.UseVP(delayTime,1,0,onFinish,nil)
	self.gun:ShowBubbleNum(self.type,self.num,self.color)
end

function Cmd_GunBubbleNumShow:ShowFinish()
	self.Timer = nil
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_GunBubbleNumShow:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	self.gun = nil
	Cmd_GunBubbleNumShow.superclass.OnDestroy(self)
end