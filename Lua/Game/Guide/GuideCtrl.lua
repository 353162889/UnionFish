require 'Game/Guide/GuideItem/GuideWelcome'
require 'Game/Guide/GuideItem/GuideShowTask'
require 'Game/Guide/GuideEvent'
require 'Game/Guide/GuideArrow'

GuideCtrl = CustomEvent()
local this = GuideCtrl
this.mode = {}
this.mode.guideItem = nil
this.GuideArrow = nil

function this.Init()
	this.DicGuideItem = {
		[1] = GuideWelcome,
		[2] = GuideShowTask,
	}

	this.DicArrowParent = {
		[1] = this.GetGunRateBtn,
		[2] = this.GetSkillBtn,
		[3] = this.GetFishDicBtn,
		[4] = this.GetGunContainer,
		[5] = this.GetLookForBtn,
		[6] = this.GetRotationDiscBtn,
		[7] = this.GetExitBtn,
		[8] = this.GetJoinFishSceneBtn
	}

	TaskCtrl.AddEvent(TaskEvent.OnTaskFinishGetBonus,this.OnGuideFinish)
end

function this.OnGuideFinish(t)
	local taskType = tonumber(t[1])
	local taskId = tonumber(t[2])
	if(taskType ~= TaskType.Guide) then return end
	if(this.mode.guideItem ~= nil) then
		this.mode.guideItem:OnExit()
		this.mode.guideItem:OnDispose()
		this.mode.guideItem = nil
	end
	local taskInfo = this.GetGuideTaskInfo()
	if(taskInfo ~= nil) then
		this.EnterGuide(taskInfo)
	else
		this.SendEvent(GuideEvent.OnGuideAllFinish)
	end
end

function this.ResetData()
	this.HideArrow()
	if(this.mode.guideItem ~= nil) then
		this.mode.guideItem:OnDispose()
		this.mode.guideItem = nil
	end
	this.mode={}
end

function this.GetGuideTaskCfg(id)
	return Res["task"..TaskType.Guide][id]
end

function this.GetGuideTaskInfo()
	local list = TaskCtrl.GetOrderTaskType(TaskType.Guide)
	local taskInfo = nil
	for i=1,#list do
		if(list[i].finish_type == 0 or list[i].finish_type == 1) then
			taskInfo = list[i]
			break
		end
	end
	return taskInfo
end

function this.InitGuidItem()
	local taskInfo = this.GetGuideTaskInfo()
	if(taskInfo ~= nil) then
		if(this.mode.guideItem ~= nil) then
			--如果当前指引数据的任务id与现在的不一致，销毁掉，否则更新
			if(this.mode.guideItem.taskInfo.id ~= taskInfo.id) then
				this.EnterGuide(taskInfo)
			else
				if(this.mode.guideItem.taskInfo.finish_type ~= taskInfo.finish_type) then
					this.mode.guideItem:OnUpdate(taskInfo)
				end
			end
		else
			--进入指引
			this.EnterGuide(taskInfo)
		end
		if(this.GuideArrow == nil) then
			this.GuideArrow	= GuideArrow:New()
			this.GuideArrow:Init()
		end
	else
		if(this.mode.guideItem ~= nil) then
			this.mode.guideItem:OnDispose()
			this.mode.guideItem = nil
		end
		if(this.GuideArrow ~= nil) then
			this.GuideArrow:Dispose()
			this.GuideArrow = nil
		end
	end
end

function this.EnterGuide(taskInfo)
	local preTaskId = nil
	if(this.mode.guideItem ~= nil) then
		preTaskId = this.mode.guideItem.taskInfo.id
		this.mode.guideItem:OnDispose()
		this.mode.guideItem = nil
	end
	LogColor("#ff0000","EnterGuide,taskInfo.id",taskInfo.id)
	local cfg = this.GetGuideTaskCfg(taskInfo.id)
	local handle = this.DicGuideItem[cfg.handle.type]
	if(handle == nil) then
		LogError("can not find guide item type "..cfg.handle.type)
	else
		this.mode.guideItem = handle.new(taskInfo)
		this.mode.guideItem:OnEnter(preTaskId)
	end
end

function this.HasGuide()
	return this.mode.guideItem ~= nil
end

function this.GuideJoinSigleScene()
	return this.HasGuide() and this.mode.guideItem.taskInfo.id <= 12
end

function this.ShowArrow(arrowParentType,pos,isLocal,angle,delay,druation,desc,descOffset)
	if(this.GuideArrow ~= nil) then
		this.GuideArrow:Show(arrowParentType,pos,isLocal,angle,delay,druation,desc,descOffset)
	end
end

function this.HideArrow()
	if(this.GuideArrow ~= nil) then
		this.GuideArrow:Hide()
	end
end

function this.GetGunRateBtn()
	if(UIMgr.isOpened("PlayView")) then
		return UIMgr.Dic("PlayView"):GetGunUnlockBtn()
	end
	return nil
end

function this.GetSkillBtn()
	if(UIMgr.isOpened("PlayView")) then
		return UIMgr.Dic("PlayView"):GetSkillBtn()
	end
	return nil
end

function this.GetFishDicBtn()
	if(UIMgr.isOpened("PlayView")) then
		UIMgr.Dic("PlayView").PlayIconItem:Show()
		return UIMgr.Dic("PlayView"):GetFishDicBtn()
	end
	return nil
end

function this.GetGunContainer()
	if(GunMgr.MainGun ~= nil) then
		return GunMgr.MainGun.container
	end
	return nil
end

function this.GetLookForBtn()
	if(UIMgr.isOpened("PlayView")) then
		return UIMgr.Dic("PlayView"):GetTreasureBtn()
	end
	return nil
end

function this.GetRotationDiscBtn()
	if(UIMgr.isOpened("MainView")) then
		return UIMgr.Dic("MainView"):GetRotationDiscBtn()
	end
	return nil
end

function this.GetExitBtn()
	if(UIMgr.isOpened("PlayView")) then
		return UIMgr.Dic("PlayView"):GetExitBtn()
	end
	return nil
end

function this.GetJoinFishSceneBtn()
	if(UIMgr.isOpened("MainView")) then
		return UIMgr.Dic("MainView"):GetJoinFishSceneBtn()
	end
	return nil
end

function this.GetArrowParent(type)
	local way = this.DicArrowParent[type]
	if(way ~= nil) then
		return way()
	else
		LogError("can not find guideArrowParent type "..type)
	end
end