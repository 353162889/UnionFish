Cmd_FS_WaitRoleEnterScene = Class(CommandBase)

function Cmd_FS_WaitRoleEnterScene:Execute(context)
	Cmd_FS_WaitRoleEnterScene.superclass.Execute(self,context)

	self.onRoleEnter = function (msg)
		self:OnRoleEnterScene(msg)
	end
	EventMgr.AddEvent(ED.PlayCtrl_S2CSceneEnterScene,self.onRoleEnter)

	self.onFishEnter = function (msg)
		self:OnFishEnterScene(msg)
	end
	EventMgr.AddEvent(ED.PlayCtrl_S2CSceneFishEnterScene,self.onFishEnter)
	--告诉后端开始刷新对象
	MainCtrl.C2SRoomStartRefresh()	
end

function Cmd_FS_WaitRoleEnterScene:OnRoleEnterScene(msg)
	--创建主玩家的炮
	GunMgr.CreateGun(msg.role_info)
	--创建其他玩家
	for i,v in ipairs(msg.role_info_list) do
		GunMgr.CreateGun(v)
	end
	--创建当前屏幕的子弹
	BulletMgr.InitEnterSceneBullet(msg.bullet_cache_list,msg.enter_time)
	--初始化相机的位置
	CameraMgr.Init(msg.camera_pos,msg.camera_status)
	--[[local cameraPos = msg.camera_pos
	UIMgr.Dic("PlayView").Camera.transform.parent.localPosition = Vector3.New(cameraPos.p_x,cameraPos.p_y,cameraPos.p_z)
	UIMgr.Dic("PlayView").Camera.gameObject.transform.localEulerAngles = Vector3.New(cameraPos.d_x,cameraPos.d_y,cameraPos.d_z)]]
end

function Cmd_FS_WaitRoleEnterScene:OnFishEnterScene(msg)
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_FS_WaitRoleEnterScene:OnDestroy()
	if(self.onRoleEnter ~= nil) then
		EventMgr.RemoveEvent(ED.PlayCtrl_S2CSceneEnterScene,self.onRoleEnter)
		self.onRoleEnter = nil
	end
	if(self.onFishEnter ~= nil) then
		EventMgr.RemoveEvent(ED.PlayCtrl_S2CSceneFishEnterScene,self.onFishEnter)
		self.onFishEnter = nil
	end
	Cmd_FS_WaitRoleEnterScene.superclass.OnDestroy(self)
end