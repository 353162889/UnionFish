require "Protof/NP_CS_Task_pb"
require "Protof/NP_SC_Task_pb"
require "Game/Task/TaskEvent"

TaskCtrl = CustomEvent()
local this = TaskCtrl
this.mode = {}
this.mode.TaskInfos = {}

function this.Init()
end

function this.ResetData()
    if(this.Timer ~= nil) then
        this.Timer:Cancel()
        this.Timer = nil
    end
    this.mode = {}
    this.mode.TaskInfos = {}
end

function this.OnEnterScene()
    if(not GuideCtrl.HasGuide()) then
        this.DelayChangeCurTask(30)
    else
        GuideCtrl.AddEvent(GuideEvent.OnGuideAllFinish,this.OnGuideAllFinish)
    end
end

function this.OnGuideAllFinish()
    this.DelayChangeCurTask(5)
end

function this.OnExitScene()
    if(this.Timer ~= nil) then
        this.Timer:Cancel()
        this.Timer = nil
    end
    if(UIMgr.isOpened("TaskProcessView")) then
        UIMgr.CloseView("TaskProcessView")
    end
    GuideCtrl.RemoveEvent(GuideEvent.OnGuideAllFinish,this.OnGuideAllFinish)
end

function this.IsCanGetTaskBonus()
    local canGetBonus = false
    for k,v in pairs(Res.task_base) do
        local tasklist = this.GetTasksByType(v.type)
        for k1,v1 in pairs(tasklist.info) do
            if(v1.finish_type == 1) then
                canGetBonus = true
                break
            end
        end
        if(canGetBonus) then
            break
        end
    end

    if(not canGetBonus) then
        local score = this.mode.TaskInfos.day_score
        if(score == nil) then return canGetBonus end
        for k,v in pairs(SortRes.Task_Score) do
            if(score >= v.task_count and not this.HasGetBonus(v.task_count)) then
                canGetBonus = true
                break
            end
        end
    end
    return canGetBonus
end

function this.ChangeCurTask()
    local taskList = this.GetTasksByType(TaskType.Fish)
    if(taskList == nil or taskList.info == nil) then return end
    local curTask = nil
    for i,v in ipairs(taskList.info) do
        if(v.finish_type == 0) then
            curTask = v
            break
        end
    end
    if(curTask ~= nil) then
        if(UIMgr.isOpened("TaskProcessView")) then
            this.SendEvent(TaskEvent.OnCurTaskChange,{TaskType.Fish,curTask.id})
        else
            this.OpenProcessView(curTask.id)
        end
    end
end

function this.DelayChangeCurTask(time)
     LogColor("#ff0000","DelayChangeCurTask",time)
    if(this.Timer ~= nil) then return end
    local onFinishTaskDelay = function ()
        this.Timer = nil
        this.ChangeCurTask()
    end
    this.Timer = LH.UseVP(time, 1, 0, onFinishTaskDelay,nil)
end

function this.HasGetBonus(score)
    if(this.mode.TaskInfos == nil) then return false end
    for i,v in ipairs(this.mode.TaskInfos.accept_day_score) do
        if(v == score) then
            return true
        end
    end
    return false
end

function this.GetTasksByType(type)
	if(this.mode.TaskInfos == nil) then return {} end
	for i,v in ipairs(this.mode.TaskInfos.task_info) do
		if(v.type == type) then
			return v
		end
	end
	return {}
end

function this.GetOrderTaskType(type)
    local list = this.GetTasksByType(type)
    local temp = {}
    for i,v in ipairs(list.info) do
        table.insert(temp,v)
    end
    table.sort(temp,function (a,b)
        return a.id < b.id
    end)
    return temp
end

function this.GetTaskInfo(type,id)
    local list = this.GetTasksByType(type)
    if(list == nil or list.info == nil) then return nil end
    for i,v in ipairs(list.info) do
        if(v.id == id) then return v end
    end
    return nil
end

--打开任务面板  类型
function this.OpenView(type)
	UIMgr.OpenView("TaskView",{type})
end

function this.OpenProcessView(taskId)
    UIMgr.OpenView("TaskProcessView",{TaskType.Fish,taskId})
end

function this.C2STaskGetInfo()
	local sendData = NP_CS_Task_pb.C2STaskGetInfo()
    local msg = sendData:SerializeToString()
   -- LogColor("#ff0000","C2STaskGetInfo")
    LuaMsgHelper.sendBinMsgData(15600, msg)
end

function this.S2CTaskGetInfo(data)
	local msg = NP_SC_Task_pb.S2CTaskGetInfo()
    msg:ParseFromString(data)
    this.mode.TaskInfos = msg
    -- local str = ""
    -- for i,v in ipairs(msg.task_info) do
    -- 	str = str .. v.type..":"
    -- 	for i1,v1 in ipairs(v.info) do
    -- 		str = str .."["..v1.id..","..v1.progress..","..v1.finish_type.."]"
    -- 	end
    -- end
    -- LogColor("#ff0000","S2CTaskGetInfo",str)

    --刷新指引
    GuideCtrl.InitGuidItem()
    this.SendEvent(TaskEvent.OnGetTaskInfo)
end

function this.C2STaskAcceptPrize(type,id)
	local sendData = NP_CS_Task_pb.C2STaskAcceptPrize()
	sendData.type = type
    sendData.id = id
    local msg = sendData:SerializeToString()
    --LogColor("#ff0000","C2STaskGetInfo",type,id)
    LuaMsgHelper.sendBinMsgData(15601, msg)
end

function this.S2CTaskAcceptPrize(data)
	local msg = NP_SC_Task_pb.S2CTaskAcceptPrize()
    msg:ParseFromString(data)
    local taskInfo = this.GetTasksByType(msg.type)
    local bonus = nil 
    for i,v in ipairs(taskInfo.info) do
    	if(v.id == msg.id) then
    		v.finish_type = 2
    		bonus = Res["task"..msg.type][msg.id].items
    		break
    	end
    end
    --打开奖励界面
    if(bonus ~= nil and #bonus > 0) then
    	local show = {{bonus[1][1],bonus[1][2]}}
    	HelpCtrl.OpenItemGetEffectView(show)
    end
    --LogColor("#ff0000","S2CTaskAcceptPrize")
    this.SendEvent(TaskEvent.OnGetTaskBonus)
    this.SendEvent(TaskEvent.OnTaskFinishGetBonus,{msg.type,msg.id})
end

function this.C2STaskAcceptPrizeByScore(score)
	local sendData = NP_CS_Task_pb.C2STaskAcceptPrizeByScore()
	sendData.type = score
    local msg = sendData:SerializeToString()
   -- LogColor("#ff0000","C2STaskAcceptPrizeByScore",score)
    LuaMsgHelper.sendBinMsgData(15602, msg)
end

function this.S2CTaskAcceptPrizeByScore(data)
	local msg = NP_SC_Task_pb.S2CTaskAcceptPrizeByScore()
    msg:ParseFromString(data)
    local scoreItem = SortRes.DicTask_Score[msg.type]
    if(scoreItem ~= nil)then
        HelpCtrl.OpenItemGetEffectView(scoreItem.items,L("获得物品"))
    end
    --LogColor("#ff0000","S2CTaskAcceptPrizeByScore")
    this.SendEvent(TaskEvent.OnGetTaskBonus)
end

function this.S2CTaskUpdateInfo( data )
   local msg = NP_SC_Task_pb.S2CTaskUpdateInfo()
    msg:ParseFromString(data)
    for i,v in ipairs(msg.task_info) do
        for j,task in ipairs(v.info) do
            this.UpdateTaskProgress(v.type,task)
        end
    end
    -- LogColor("#ff0000","S2CTaskUpdateInfo")
end

function this.UpdateTaskProgress(type,taskInfo)
   for i,v in ipairs(this.mode.TaskInfos.task_info) do
        if(v.type == type) then
            for j,task in ipairs(v.info) do
                if(task.id == taskInfo.id) then
                    task.progress = taskInfo.progress
                    local preFinishType = task.finish_type
                    task.finish_type = taskInfo.finish_type
                    if(preFinishType == 0 and task.finish_type == 1) then
                        --完成任务
                        --显示完成特效
                        this.ShowFinishTaskEffect(type,taskInfo.id)
                        this.SendEvent(TaskEvent.OnTaskFinish,{type,taskInfo.id})
                    end
                end
            end
        end
    end
    -- LogColor("#ff0000","UpdateTaskProgress",type,taskInfo.id)
    this.SendEvent(TaskEvent.OnProgressChange,{type,taskInfo.id})
end

function this.ShowFinishTaskEffect(taskType,taskId)
    local cfg = Res["task"..taskType][taskId]
    if(cfg == nil) then return end
    if(cfg.showEffect == nil or cfg.showEffect == 0) then return end
    local curTaskType = nil
    local curTaskId = nil
    if(GuideCtrl.HasGuide()) then
        if(UIMgr.isOpened("GuideTaskView")) then
            curTaskType = UIMgr.Dic("GuideTaskView").type
            curTaskId = UIMgr.Dic("GuideTaskView").taskId
        end
    else
        if(UIMgr.isOpened("TaskProcessView")) then
            curTaskType = UIMgr.Dic("TaskProcessView").type
            curTaskId = UIMgr.Dic("TaskProcessView").taskId
        end
    end
    if(curTaskType ~= taskType or curTaskId ~= taskId) then 
        return
    end

    local parent = UIMgr.Dic("HelpView").EffectBox
    if(this.FinishEffect == nil) then
        local queue = GetParentPanelRenderQueue(parent)
        this.FinishEffect = UnitEffectMgr.ShowUIEffectInParent(parent,54018,Vector3.zero,true,queue + 10)
    end
    this.FinishEffect:Show(parent,Vector3.zero,true,this.OnFinishEffectPlayFinish)
end

function this.OnFinishEffectPlayFinish(playFinish,effect)
    if(effect ~= nil) then
        effect:Hide()
    end
end

function this.C2STaskClientTask()
    LogColor("#ff0000","C2STaskClientTask")
    local sendData = NP_CS_Task_pb.C2STaskClientTask()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15605, msg)
end
