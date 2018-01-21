Cmd_AS_MgrDispose = Class(CommandBase)

function Cmd_AS_MgrDispose:Execute(context)
	Cmd_AS_MgrDispose.superclass.Execute(self,context)
	--关闭Gunview面板(永远不关闭)
	--UIMgr.CloseView("GunView")
	UIMgr.CloseView("SkillView")
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
	SayMgr.ExitFishScene()
	UIMgr.Dic("GunView"):EnableBG(false)

	FishSoundMgr.ExitFishScene()
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_AS_MgrDispose:OnDestroy()
	Cmd_AS_MgrDispose.superclass.OnDestroy(self)
end
