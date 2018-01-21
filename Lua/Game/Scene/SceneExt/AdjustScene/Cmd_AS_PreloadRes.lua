Cmd_AS_PreloadRes = Class(CommandBase)

--ctor这里不需要Cmd_FS_PreloadRes.superclass.ctor(self),Class中有做处理
function Cmd_AS_PreloadRes:ctor()
end

function Cmd_AS_PreloadRes:Execute(context)
	Cmd_AS_PreloadRes.superclass.Execute(self,context)
	--打开loading界面（遮住渔场）
	LoadingCtrl.OpenView(false)
	LoadingCtrl.SetLoadingProgress(100)

	--预加载playview资源
	local names = {SortRes.DicView["GunView"].path}
	--预加载特效资源
	for k,v in pairs(Res.effect) do
		if(v.pre_load == 1) then
			table.insert(names,v.path)
		end
	end
	self.onComplete = function (loader)
		self:OnLoadIslandResComplete(loader)
	end
	AdjustScene.effectResLoader:LoadResList(names,self.onComplete,nil)
end

function Cmd_AS_PreloadRes:OnLoadIslandResComplete(loader)
	--打开playView面板
	--UIMgr.OpenView("GunView")
	UIMgr.OpenView("SkillView")
	ChangeGunCtrl.OpenView()
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_AS_PreloadRes:OnDestroy()
	self.onComplete = nil
	Cmd_AS_PreloadRes.superclass.OnDestroy(self)
end