--指引检测，如果有指引，返回成功，否则返回失败
Cmd_CheckGuide = Class(CommandBase)

function Cmd_CheckGuide:ctor()
end

function Cmd_CheckGuide:Execute(context)
	Cmd_CheckGuide.superclass.Execute(self)
	LogColor("#ff0000","Cmd_CheckGuide:Execute")
	if(GuideCtrl.HasGuide()) then
		self:OnExecuteDone(CmdExecuteState.Success)
	else
		self:OnExecuteDone(CmdExecuteState.Fail)
	end
end

function Cmd_CheckGuide:OnExecuteFinish()
     LogColor("#ff0000","Cmd_CheckGuide:OnExecuteFinish")
end

