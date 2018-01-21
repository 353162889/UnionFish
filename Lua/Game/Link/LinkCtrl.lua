require "Protof/NP_ClientServer_pb"
require "Protof/NP_ServerClient_pb"
require "Game/Link/LinkEvent"

LinkCtrl = CustomEvent()
local this = LinkCtrl
this.mode = {}

this.mode.time = ""

function this.ResetData()
end

function LinkCtrl.ConnectToLoginServer()
    --LuaMsgHelper.connectToLoginServer("192.168.1.45", 15001)
    --LuaMsgHelper.connectToLoginServer("120.24.73.222", 19001)
    --LuaMsgHelper.connectToLoginServer("192.168.1.136", 19001)
    --LuaMsgHelper.connectToLoginServer("192.168.1.71", 19001)
    LuaMsgHelper.connectToLoginServer(Launch.GameConfig.GameServer, Launch.GameConfig.GamePort)
end

function LinkCtrl.LinkLoginSuccess()
    Log("连接登录服务器成功")
    this.SendEvent(LinkEvent.LinkCtrl_LinkLoginSuccess)
end
function LinkCtrl.LinkLoginFail()
    LogError("连接登录服务器失败")
    this.SendEvent(LinkEvent.LinkCtrl_LinkLoginFail)
end

function LinkCtrl.LinkGameSuccess()
    Log("连接游戏服务器成功")
    this.SendEvent(LinkEvent.LinkCtrl_LinkGameSuccess)
    LuaMsgHelper.beginHeartBeat()
end
function LinkCtrl.LinkGameFail()
    LogError("连接游戏服务器失败")
    this.SendEvent(LinkEvent.LinkCtrl_LinkGameFail)
end

function LinkCtrl.C2SHeartBeat()--心跳
    local sendData = NP_ClientServer_pb.C2SHeartBeat()
    local msg = sendData:SerializeToString()
    if(ServerTime.HasInited) then
        this.beatTime = ServerTime.CurrentServerSecondMs
    end
    LuaMsgHelper.sendBinMsgData(10005, msg)
end
function LinkCtrl.S2CHeartBeat(data)--心跳返回
    local msg = NP_ServerClient_pb.S2CHeartBeat()
    msg:ParseFromString(data)
    this.mode.time = msg.time
    ServerTime.CurrentServerSeconds = msg.time
    if(this.beatTime ~= nil) then
        local ping = ServerTime.CurrentServerSecondMs - this.beatTime
        if(ping < 0) then ping = 0 end
        this.SendEvent(LinkEvent.LinkCtrl_PintChange,{ping})
        --LogColor("#ff0000","ping",ping)
    end
end

function LinkCtrl.LinkDisconnect()
    LogColor("#ff0000","LinkDisconnect")
    if(LoginCtrl.IsLogined()) then
        HelpCtrl.OpenConfirmView(L("提   示"),L("网络断开连接，请重新进入游戏"),LinkCtrl.OnDisconnect,LinkCtrl.OnDisconnect,L("确 定"))
    else
        HelpCtrl.Msg(L("登录失败，请重新登录"))
    end
end

function LinkCtrl.OnApplicationPause(isPause)
    LogColor("#ff0000","OnApplicationPause",isPause)
end

function LinkCtrl.OnDisconnect()
    UnityEngine.Application.Quit()
end

function LinkCtrl.OnExitGame()
    -- HelpCtrl.OpenTipView(L("提   示"),L("确定退出游戏?"),LinkCtrl.OnDisconnect,nil,L("确 定"),L("取 消"))
end