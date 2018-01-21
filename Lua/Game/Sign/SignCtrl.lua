require "Protof/NP_CS_Sign_pb"
require "Protof/NP_SC_Sign_pb"
require "Game/Sign/SignEvent"

SignCtrl = CustomEvent()
local this = SignCtrl
this.modeSign = {}

function this.Init()
    GuideCtrl.AddEvent(GuideEvent.OnGuideAllFinish,this.OnGuideAllFinish)
end

function this.OnGuideAllFinish()
    if(this.Timer ~= nil) then 
        return
    end
    local onFinishTaskDelay = function ()
        this.Timer = nil
        if SignCtrl.modeSign~=nil then
          if SignCtrl.modeSign.sign==0 then
            UIMgr.OpenView("SignView")
          end
        end
    end
    this.Timer = LH.UseVP(3, 1, 0, onFinishTaskDelay,nil)
end

function this.ResetData()
  this.modeSign = {}
end

--发送获取签到数据
function this.C2SSignGetInfo()
	local sendData = NP_CS_Sign_pb.C2SSignGetInfo()
    local msg = sendData:SerializeToString()
    LogColor("#ff0000","C2SSignGetInfo")
    LuaMsgHelper.sendBinMsgData(15400, msg)
end


--服务器返回数据
function this.S2CSignGetInfo(data)
	local msg = NP_SC_Sign_pb.S2CSignGetInfo()
    msg:ParseFromString(data)
   	this.modeSign.sign=msg.sign
   	this.modeSign.num=msg.num

    LogColor("#ff0000","S2CSignGetInfo")
end



--发送签到数据
function this.C2SSignSign()
	local sendData = NP_CS_Sign_pb.C2SSignSign()
    local msg = sendData:SerializeToString()
    LogColor("#ff0000","C2SSignSign")
    LuaMsgHelper.sendBinMsgData(15401, msg)
end


--服务器返回签到状态
function this.S2CSignSign(data)
	local msg = NP_SC_Sign_pb.S2CSignSign()
    msg:ParseFromString(data)

    local modeSignData = {}
   	modeSignData.ret=msg.ret
   	modeSignData.index=msg.index

    LogColor("#ff0000","S2CSignSign")
    this.SendEvent(SignEvent.OnSignReceiveBtn,modeSignData)
end