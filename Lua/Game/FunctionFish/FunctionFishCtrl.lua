require "Protof/NP_CS_Lottery_pb"
require "Protof/NP_SC_Lottery_pb"

FunctionFishCtrl = CustomEvent()
local this = FunctionFishCtrl

function this.S2CLotteryFishLottery(data)
	local msg = NP_SC_Lottery_pb.S2CLotteryFishLottery()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CLotteryFishLottery",msg.id,msg.num)
    local itemId = msg.id
    local itemNum = msg.num

    local show = {{itemId,itemNum}}
   	HelpCtrl.OpenItemGetEffectView(show)
end