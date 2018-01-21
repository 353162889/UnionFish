Cmd_FS_PlayEnterAnim = Class(CommandBase)

function Cmd_FS_PlayEnterAnim:Execute(context)
	Cmd_FS_PlayEnterAnim.superclass.Execute(self,context)
	UIMgr.CloseView("LoadingView")
	MainCtrl.SendEvent(MainEvent.MainCtrl_ChangeHeadViewVisiable,false,false)
	UIMgr.Dic("GunView"):EnableBG(false)
	LogColor("#ff0000","播放入场动画")
	if(GunMgr.MainGun ~= nil)then
		local onDelay = function (t)
			self.Timer = nil
			self:OnAnimPlayFinish()
		end
		self.Timer = LH.UseVP(2, 1, 0 ,onDelay,{})
		GunMgr.MainGun:ShowAppearEffect()
	else
		self:OnAnimPlayFinish()
	end
	
end

function Cmd_FS_PlayEnterAnim:OnAnimPlayFinish()
	--显示PlayViewUI
	PlayCtrl.SendEvent(PlayEvent.PlayCtrl_ChangeBtnsVisiable,true)
	UIMgr.Dic("GunView"):EnableBG(true)
	MainCtrl.SendEvent(MainEvent.MainCtrl_ChangeHeadViewVisiable,true,true)
	if(GunMgr.MainGun ~= nil) then
		GunMgr.MainGun:ShowSelfEffect()
	end
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_FS_PlayEnterAnim:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	Cmd_FS_PlayEnterAnim.superclass.OnDestroy(self)
end