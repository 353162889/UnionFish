Cmd_AS_MgrInit = Class(CommandBase)

function Cmd_AS_MgrInit:Execute(context)
	Cmd_AS_MgrInit.superclass.Execute(self,context)

	local camera = AdjustScene.sceneRoot.transform:FindChild("Box/Camera")
	local bulletParent = UIMgr.Dic("HelpBottomView").BulletParent
	local sceneEffectParent = UIMgr.Dic("HelpBottomView").FishSceneEffectParent
	local gunItem = UIMgr.Dic("GunView").GunItem
	FishMgr.EnterFishScene(camera)
	BulletMgr.EnterFishScene(bulletParent)
	FishSceneEffectMgr.EnterFishScene(sceneEffectParent,camera)
	FishSceneTimeMgr.EnterFishScene()
	GunMgr.Init(gunItem)
	local curCamera = AdjustScene.sceneRoot:GetComponent("SceneHelper").camera
	CameraMgr.OnEnterScene(curCamera)
	NumItemMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").NumItem)
	GoldItemMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").MoneyItem)
	CatchMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").CatchItem)
	SayMgr.EnterFishScene(UIMgr.Dic("HelpBottomView").SayItem)
	
	FishSoundMgr.EnterFishScene()

	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_AS_MgrInit:OnDestroy()
	Cmd_AS_MgrInit.superclass.OnDestroy(self)
end