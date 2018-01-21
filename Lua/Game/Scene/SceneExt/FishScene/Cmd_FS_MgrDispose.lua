Cmd_FS_MgrDispose = Class(CommandBase)

function Cmd_FS_MgrDispose:Execute(context)
	Cmd_FS_MgrDispose.superclass.Execute(self,context)
	--关闭PlayView界面
	UIMgr.CloseView("PlayView")
	FishMgr.ExitFishScene()
	BulletMgr.ExitFishScene()
	GunMgr.Dispose()
	FishSceneEffectMgr.ExitFishScene()
	FishSceneTimeMgr.ExitFishScene()
	ChangeGunCtrl.CloseView()
	SkillCtrl.ResumeSkill()
	CameraMgr.OnExitScene()
	NumItemMgr.ExitFishScene()
	GoldItemMgr.ExitFishScene()
	CatchMgr.ExitFishScene()
	DropItemMgr.ExitFishScene()
	SayMgr.ExitFishScene()
	UIMgr.Dic("GunView"):EnableBG(false)
	TaskCtrl.OnExitScene()
	FishSoundMgr.ExitFishScene()
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_FS_MgrDispose:OnDestroy()
	Cmd_FS_MgrDispose.superclass.OnDestroy(self)
end