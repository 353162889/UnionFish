require "Protof/NP_CS_Sign_pb"
require "Protof/NP_SC_Sign_pb"

OnlineCtrl = CustomEvent()

local this = OnlineCtrl

this.mode = {}
this.mode.S2CSignGetSceneInfoData = nil--在线时长奖励，时间段奖励
this.mode.TimerTick = nil--计时器
this.mode.UpDateTime = -1--时间到重新请求
this.mode.UpdateTimeId = -1

function this.ResetData()
    if(this.mode.TimerTick ~= nil) then
        this.mode.TimerTick:Cancel()
        this.mode.TimerTick = nil
    end
    this.mode = {}
    this.mode.S2CSignGetSceneInfoData = nil
    this.mode.UpDateTime = -1
    this.mode.UpdateTimeId = -1
end

function this.C2SSignGetSceneInfo()--15402
    -- LogColor("#ff0000","C2SSignGetSceneInfo")
    local sendData = NP_CS_Sign_pb.C2SSignGetSceneInfo()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15402, msg)
end

function this.S2CSignGetSceneInfo(data)
    -- LogColor("#ff0000","S2CSignGetSceneInfo")
    local msg = NP_SC_Sign_pb.S2CSignGetSceneInfo()
    msg:ParseFromString(data)
    this.mode.S2CSignGetSceneInfoData = msg.info
	local C_d = this.mode.S2CSignGetSceneInfoData
	this.mode.UpDateTime = -1
     this.mode.UpdateTimeId = -1
    for i=1,#C_d do
	 	if C_d[i].type == 1 then
	 		--LogError("··············",this.mode.UpDateTime , C_d[i].left_time)
	 		if this.mode.UpDateTime == -1 or this.mode.UpDateTime > C_d[i].left_time then
	 			if C_d[i].left_time ~= 0 then
	 				this.mode.UpDateTime = C_d[i].left_time
                    this.mode.UpdateTimeId = C_d[i].id
	 			end
	 		end
    	end
    end
	if(this.mode.TimerTick ~= nil) then
		this.mode.TimerTick:Cancel()
		this.mode.TimerTick = nil
	end
	-- LogError("开始在线奖励计时器")
	if this.mode.UpDateTime > 0 then
    	this.mode.TimerTick = LH.UseVP(1, 0, 1, OnlineCtrl.TickVP,nil)
	end
    EventMgr.SendEvent(ED.OnlineView_NewView,nil)
    EventMgr.SendEvent(ED.OnlineView_GetInfo,nil)
end

function this.TickVP()
	this.mode.UpDateTime = this.mode.UpDateTime - 1000
	-- LogError("this.mode.UpDateTime",this.mode.UpDateTime)
	if this.mode.UpDateTime <= 0 and this.mode.UpDateTime > -1000 then
		this.C2SSignGetSceneInfo()
	end
end

function this.C2SSignAcceptPrizeByScene(id)--15403
    -- LogError("C2SSignAcceptPrizeByScene",id)
    local sendData = NP_CS_Sign_pb.C2SSignAcceptPrizeByScene()
    sendData.id = id
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15403, msg)
end

function this.S2CSignAcceptPrizeByScene(data)
    -- LogError("S2CSignAcceptPrizeByScene")
    local msg = NP_SC_Sign_pb.S2CSignAcceptPrizeByScene()
    msg:ParseFromString(data)
    local tempList = this.mode.S2CSignGetSceneInfoData

    for i=1,#tempList do
    	if tempList[i].id == msg.info.id and msg.info.type == 1 then
    		tempList[i] = msg.info
    		HelpCtrl.OpenItemGetEffectView(Res.scene_sign[tempList[i].id].items,L("获得物品"))
    	end
    end
    EventMgr.SendEvent(ED.OnlineView_NewView,nil)
end

function this.C2SSignAcceptPrizeByTime(id)--15404
    -- LogError("C2SSignAcceptPrizeByTime",id)
    local sendData = NP_CS_Sign_pb.C2SSignAcceptPrizeByScene()
    sendData.id = id
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15404, msg)
end

function this.S2CSignAcceptPrizeByTime(data)
    -- LogError("S2CSignAcceptPrizeByTime")
    local msg = NP_SC_Sign_pb.S2CSignAcceptPrizeByTime()
    msg:ParseFromString(data)
    local tempList = this.mode.S2CSignGetSceneInfoData

    for i=1,#tempList do
    	if tempList[i].id == msg.info.id and msg.info.type == 2 then
    		tempList[i] = msg.info
    		HelpCtrl.OpenItemGetEffectView(Res.time_sign[tempList[i].id].items,L("获得物品"))
    	end
    end
    EventMgr.SendEvent(ED.OnlineView_NewView,nil)
end

function this.C2SSignAcceptPrizeByAll()--15405
    -- LogError("C2SSignAcceptPrizeByAll",id)
    local sendData = NP_CS_Sign_pb.C2SSignAcceptPrizeByAll()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15405, msg)
end

function this.S2CSignAcceptPrizeByAll(data)
    local msg = NP_SC_Sign_pb.S2CSignAcceptPrizeByAll()
    msg:ParseFromString(data)
    local tempList = this.mode.S2CSignGetSceneInfoData
    -- LogError("S2CSignAcceptPrizeByAll",msg)
    local t = {}
    for i=1,#tempList do
    	for j=1,#msg.info do
    		if tempList[i].id == msg.info[j].id and tempList[i].type == msg.info[j].type then
    			tempList[i] = msg.info[j]
    			if tempList[i].type == 1 then
    				local tt = Res.scene_sign[tempList[i].id].items
    				for i=1,#tt do
    					-- LogError("1",tt[i][1],tt[i][2])
    					table.insert(t,tt[i])
    				end
    			elseif tempList[i].type == 2 then
    				local tt = Res.time_sign[tempList[i].id].items
    				for i=1,#tt do
    					-- LogError("2",tt[i][1],tt[i][2])
    					table.insert(t,tt[i])
    				end
    			end
    		end
    	end
    end
    -- LogError("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    -- for i=1,#tempList do
    -- 	LogError(tempList[i].id,tempList[i].type,tempList[i].state)
    -- end
    -- LogError("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    if #t > 0 then
    	HelpCtrl.OpenItemGetEffectView(t,"恭喜获得")
    end
    EventMgr.SendEvent(ED.OnlineView_NewView,nil)
end

function this.IsShowE()
	local C_d = this.mode.S2CSignGetSceneInfoData
    for i=1,#C_d do
    	if C_d[i].state == 1 then
    		return true
    	end
    end
    return false
end