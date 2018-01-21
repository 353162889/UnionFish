require "Game/Loading/LoadingEvent"

LoadingCtrl = CustomEvent()
local this = LoadingCtrl
this.Progress = 0

function this.ResetData()
end

function LoadingCtrl.OpenView(isRandomDesc)
	if(not UIMgr.isOpened("LoadingView")) then
		UIMgr.OpenView("LoadingView",{isRandomDesc})
	end
end

function LoadingCtrl.SetLoadingProgress(progress)
	this.Progress = progress
	this.SendEvent(LoadingEvent.OnProgressChange,this.Progress)
	if(this.Progress >= 100) then
		this.SendEvent(LoadingEvent.OnProgressFinish)
	end
end

function LoadingCtrl.ResetLoadingProgress()
	this.Progress = 0
	this.SendEvent(LoadingEvent.OnProgressChange,this.Progress)
end
