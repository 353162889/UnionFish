Cmd_FS_MgrInit = Class(CommandBase)

function Cmd_FS_MgrInit:Execute(context)
	Cmd_FS_MgrInit.superclass.Execute(self,context)

	local camera = FishScene.sceneRoot.transform:FindChild("Box/Camera")
	local bulletParent = UIMgr.Dic("HelpBottomView").BulletParent
	local sceneEffectParent = UIMgr.Dic("HelpBottomView").FishSceneEffectParent
	local gunItem = UIMgr.Dic("GunView").GunItem
	FishMgr.EnterFishScene(camera)
	BulletMgr.EnterFishScene(bulletParent)
	FishSceneEffectMgr.EnterFishScene(sceneEffectParent,camera)
	FishSceneTimeMgr.EnterFishScene()
	GunMgr.Init(gunItem)
	NumItemMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").NumItem)
	GoldItemMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").MoneyItem)
	CatchMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").CatchItem)
	DropItemMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").DropItem)
	SayMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").SayItem)
	FishSoundMgr.EnterFishScene()


	TaskCtrl.OnEnterScene()
	
	local curCamera = FishScene.sceneRoot:GetComponent("SceneHelper").camera
	CameraMgr.OnEnterScene(curCamera)

	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_FS_MgrInit:OnDestroy()
	Cmd_FS_MgrInit.superclass.OnDestroy(self)
end