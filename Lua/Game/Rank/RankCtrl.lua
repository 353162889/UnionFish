require "Protof/NP_CS_Rank_pb"
require "Protof/NP_SC_Rank_pb"
require "Game/Rank/RankEvent"

RankCtrl = CustomEvent()
local this = RankCtrl
this.mode = {}
this.mode.MapRank = {}		--排行榜字典
this.mode.RelocatedType = {}

function this.ResetData()
    this.mode = {}
    this.mode.MapRank = {}      --排行榜字典
    this.mode.RelocatedType = {}
end

function this.C2SRankGetInfo()
	local sendData = NP_CS_Rank_pb.C2SRankGetInfo()
    local msg = sendData:SerializeToString()
    LogColor("#ff0000","C2SRankGetInfo")
    LuaMsgHelper.sendBinMsgData(15550, msg)
end

function this.S2CRankGetInfo(data)
	local msg = NP_SC_Rank_pb.S2CRankGetInfo()
    msg:ParseFromString(data)

    local changedRankInfo = {}
    for i,v in ipairs(msg.info) do
    	this.mode.MapRank[v.type] = v
    	table.insert(changedRankInfo,v.type)
    end
    LogColor("#ff0000","S2CRankGetInfo")
    this.SendEvent(RankEvent.OnRankChange,changedRankInfo)
end