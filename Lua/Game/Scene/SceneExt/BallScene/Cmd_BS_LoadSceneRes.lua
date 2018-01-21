Cmd_BS_LoadSceneRes = Class(CommandBase)

function Cmd_BS_LoadSceneRes:Execute(context)
	Cmd_BS_LoadSceneRes.superclass.Execute(self,context)

	local scene = Res.scene[BallScene.sceneId]
	self.onLoadFinish = function ()
		self:OnLoadSceneRes()
	end
	self.onProgressChange = function (progress)
		self:OnSceneResProgressChange(progress)
	end
	LuaSceneMgr.LoadUnityScene(scene.name,self.onLoadFinish,self.onProgressChange)
end

function Cmd_BS_LoadSceneRes:OnLoadSceneRes()
	BallScene.sceneRoot = GameObject.Find("SceneBox")
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_BS_LoadSceneRes:OnSceneResProgressChange(progress)
	BallScene.SetLoadingViewSetProgress(progress * 99.9)
end

function Cmd_BS_LoadSceneRes:OnDestroy()
	Cmd_BS_LoadSceneRes.superclass.OnDestroy(self)
	self.onLoadFinish = nil
	self.onProgressChange = nil
end
