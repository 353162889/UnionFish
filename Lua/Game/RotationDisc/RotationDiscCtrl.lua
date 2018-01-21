require "Protof/NP_CS_Lottery_pb"
require "Protof/NP_SC_Lottery_pb"
require "Game/RotationDisc/RotationDiscEvent"

RotationDiscCtrl = CustomEvent()
local this = RotationDiscCtrl
this.mode = {}
this.mode.MapLottery = {}
this.timeHandler = nil
this.mode.IsDelayRefreshLuck = false		--是否延时刷新幸运值
this.mode.DelayRefreshMoney = false			--是否延时刷新金币钻石的显示
this.MoneyKey = "RotationDiscKey"

function this.Init()
	ClockCtrl.AddEvent(ClockEvent.OnSecond,this.OnClickSecond)
end

function this.ResetData()
	this.mode = {}
	this.mode.MapLottery = {}
	this.timeHandler = nil
	this.mode.IsDelayRefreshLuck = false		--是否延时刷新幸运值
	this.mode.DelayRefreshMoney = false
end

function this.OnViewOpen()
	this.mode.DelayRefreshMoney = true
end

function this.OnViewClose()
	this.mode.DelayRefreshMoney = false
	this.ClearDelayMoney()
end

function this.ClearDelayMoney()
	MainCtrl.ClearShowOffset(this.MoneyKey)
end

function this.RefreshMoneyShow()
	this.ClearDelayMoney()
	MainCtrl.SendEvent(MainEvent.MainCtrl_RefreshHeadView)
end

function this.OnClickSecond()
	local hasRefresh = false
	for k,v in pairs(this.mode.MapLottery) do
		if(v.time_left > 0) then
			v.time_left = v.time_left - 1
			if(v.time_left <= 0) then
				this.SendEvent(RotationDiscEvent.OnFreeTimeReach,k)
			end
			hasRefresh = true
		end
	end
	if(hasRefresh) then
		this.SendEvent(RotationDiscEvent.OnTimeRefresh)
	end
end

function this.DelayRefreshLuck()
	this.mode.IsDelayRefreshLuck = true
end

function this.CancelDelayRefreshLuck()
	this.mode.IsDelayRefreshLuck = false

end

--当前抽奖类型是否是免费的
function this.IsFreeTime(lv)
	local info = this.mode.MapLottery[lv]
	if(info ~= nil) then
		return info.time_left <= 0
	end
	return true
end

--打开转盘界面type  1、普通转盘，2、银转盘,3、金转盘,4、铂金转盘
function this.OpenRotationDiscView(type)
	UIMgr.OpenView("RotationDiscView",{type})
end

function this.C2SLotteryGetInfo()
	local sendData = NP_CS_Lottery_pb.C2SLotteryGetInfo()
    local msg = sendData:SerializeToString()
    --LogColor("#ff0000","C2SLotteryGetInfo")
    LuaMsgHelper.sendBinMsgData(15500, msg)
end

--type 1免费抽奖 2卷轴抽奖 3消费抽奖
function this.C2SLotteryLottery(lv,type)
	local sendData = NP_CS_Lottery_pb.C2SLotteryLottery()
	sendData.lv = lv
	sendData.type = type
    local msg = sendData:SerializeToString()
    --LogColor("#ff0000","C2SLotteryLottery")
    LuaMsgHelper.sendBinMsgData(15501, msg)
end

function this.S2CLotteryGetInfo(data)
	local msg = NP_SC_Lottery_pb.S2CLotteryGetInfo()
    msg:ParseFromString(data)
    --local str = ""
    this.mode.MapLottery = {}
    for i,v in ipairs(msg.list) do
    	this.mode.MapLottery[v.lv] = v
    	--str = str .. "[lv:"..v.lv..",luck_num:"..v.luck_num..",time_left:"..v.time_left.."]"
    end
    --LogColor("#ff0000","S2CLotteryGetInfo",str)
    this.SendEvent(RotationDiscEvent.GetLottoryInfo)
    --所有有剩余时间的+1s
    for k,v in pairs(this.mode.MapLottery) do
		if(v.time_left > 0) then
			v.time_left = v.time_left + 1
		end
	end
end

function this.S2CLotteryLottery(data)
	local msg = NP_SC_Lottery_pb.S2CLotteryLottery()
    msg:ParseFromString(data)
    --local str = "lv:"..msg.lv..",index:"..msg.index
    --重置时间
    local lotteryData = this.mode.MapLottery[msg.lv]
    if(lotteryData ~= nil and lotteryData.time_left <= 0) then
    	lotteryData.time_left = Res.lottery_base[msg.lv].free_time * 60
    end

    if(this.mode.DelayRefreshMoney) then
    	local cfgs = Res["lottery"..msg.lv]
    	local itemId = tonumber(cfgs[msg.index].item[1])
		local itemNum = tonumber(cfgs[msg.index].item[2])
		LogColor("#ff0000","itemId:",itemId,"itemNum:",itemNum,"lv:",msg.lv,"index:",msg.index)
		if(itemId == GlobalDefine.Gold) then
			MainCtrl.AddShowGoldOffset(this.MoneyKey,-itemNum)
		elseif(itemId == GlobalDefine.DiamondID) then
			MainCtrl.AddShowDiamondOffset(this.MoneyKey,-itemNum)
		end
    end
    --LogColor("#ff0000","S2CLotteryLottery",str)
    this.SendEvent(RotationDiscEvent.OnLottorySucc,msg)
     this.SendEvent(RotationDiscEvent.RefreshView)
end