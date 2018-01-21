require 'Framework/Resource/PreloadMgr'
require "DataDef/PreLoadResPath"
Cmd_Preload = Class(CommandBase)

function Cmd_Preload:ctor()
end

function Cmd_Preload:Execute(context)
	Cmd_Preload.superclass.Execute(self,context)
	LogColor("#ff0000","Cmd_Preload:Execute")
	--预下载资源
	local names = PreLoadResPath.Path
	self.onComplete = function (loader)
		self:OnLoadFinish(loader)
	end
	self.onProgress = function (res)
		self:OnLoadProgress(res)
	end
	PreloadMgr.multiLoader:LoadResList(names,self.onComplete,self.onProgress)
end

function Cmd_Preload:OnLoadFinish(loader)
	--命令执行完成
	self:OnExecuteDone(CmdExecuteState.Success)
end

function Cmd_Preload:OnLoadProgress(res)
	Log("preload:path="..res.path)
end

function Cmd_Preload:OnDestroy()
	self.onComplete = nil
	Cmd_AS_PreloadRes.superclass.OnDestroy(self)
end

function Cmd_Preload:OnExecuteFinish()
	 LogColor("#ff0000","Cmd_Preload:OnExecuteFinish")
end
