require "Protof/NP_CS_Treasure_pb"
require "Protof/NP_SC_Treasure_pb"

LookForCtrl = CustomEvent()

local this = LookForCtrl

this.mode = {}
this.mode.S2CTreasureGetInfoData=nil
this.mode.S2CTreasureLotteryData=nil

function this.ResetData()
    this.mode = {}
end

function this.C2STreasureGetInfo()--15100
    -- LogError("C2STreasureGetInfo")
    local sendData = NP_CS_Treasure_pb.C2STreasureGetInfo()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15100, msg)
end
function this.C2STreasureLottery(type)--15101
    -- LogError("C2STreasureLottery",type)
    local sendData = NP_CS_Treasure_pb.C2STreasureLottery()
    sendData.type = type
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15101, msg)
end

function this.S2CTreasureGetInfo(data)
    -- LogError("S2CTreasureGetInfo")
    local msg = NP_SC_Treasure_pb.S2CTreasureGetInfo()
    msg:ParseFromString(data)
    this.mode.S2CTreasureGetInfoData = {}
    this.mode.S2CTreasureGetInfoData.gold_fish = msg.gold_fish
    this.mode.S2CTreasureGetInfoData.gold_num = msg.gold_num
    EventMgr.SendEvent(ED.LookForCtrl_S2CTreasureGetInfo,nil)
end

function this.S2CTreasureLottery(data)
    -- LogError("S2CTreasureLottery")
    local msg = NP_SC_Treasure_pb.S2CTreasureLottery()
    msg:ParseFromString(data)
    if msg.ret == GlobalDefine.RetSucc then
        this.mode.S2CTreasureLotteryData = msg
        EventMgr.SendEvent(ED.LookForCtrl_S2CTreasureLottery,nil)
    else
        this.mode.S2CTreasureLotteryData = nil
    end
end

function this.IsCanLookFor()
    local data = this.mode.S2CTreasureGetInfoData
    if(data == nil) then return false end
    local goldMeet = false
    for i=1,#Res.lotterybox do
        if Res.lotterybox[i].need_score <= data.gold_num then
            goldMeet = true
            break
        end
    end
    if goldMeet and data.gold_fish >= Res.misc[1].lookfor_count then
        return true
    end
    return false
end