Cmd_FishAttackFish_0 = Class(CommandBase)

function Cmd_FishAttackFish_0:ctor(...)
	self.msg = select(1,...)
	self.info = select(2,...)
end

function Cmd_FishAttackFish_0:Execute(context)
	Cmd_FishAttackFish_0.superclass.Execute(self)

	HelpCtrl.Num(self.msg)--金币数字
    HelpCtrl.Money(self.msg)--金币图片
    HelpCtrl.Catch(self.msg)--捕获UI图片

	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_FishAttackFish_0:OnDestroy()
	self.msg = nil
	self.info = nil
	Cmd_FishAttackFish_0.superclass.OnDestroy(self)
end



