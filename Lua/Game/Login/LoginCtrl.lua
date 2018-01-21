require "Game/Login/LoginEvent"

LoginMode = {
    visitor = 1,
    Phone = 2
}

local _userNameKey = "UnionFish_2017_user_name"
local _userPasswordKey = "UnionFish_2017_user_password"

LoginCtrl = CustomEvent()

local this = LoginCtrl

this.mode = {}
this.mode.S2CResult = nil
this.mode.S2CEnterGame = nil
this.mode.GunList = {}
this.mode.LocalInfo = nil

function this.Init()
    LinkCtrl.AddEvent(LinkEvent.LinkCtrl_LinkLoginSuccess,this.OnLinkLoginSuccess)
    LinkCtrl.AddEvent(LinkEvent.LinkCtrl_LinkLoginFail,this.OnLinkLoginFail)
    LinkCtrl.AddEvent(LinkEvent.LinkCtrl_LinkGameSuccess,this.OnLinkGameSuccess)
    LinkCtrl.AddEvent(LinkEvent.LinkCtrl_LinkGameFail,this.OnLinkGameFail)
    --SDK登录成功事件
    SDKMgr.RegisterLuaListener(SDKEventStatus.LoginSuccess,this.OnSDKLoginSuccess)
    --SDK登录失败事件
    SDKMgr.RegisterLuaListener(SDKEventStatus.LoginNetworkError,this.OnSDKLoginFail)
    SDKMgr.RegisterLuaListener(SDKEventStatus.LoginNoNeed,this.OnSDKLoginFail)
    SDKMgr.RegisterLuaListener(SDKEventStatus.LoginFail,this.OnSDKLoginFail)
    SDKMgr.RegisterLuaListener(SDKEventStatus.LoginCancel,this.OnSDKLoginFail)

    --SDK登出事件
    SDKMgr.RegisterLuaListener(SDKEventStatus.LogoutSuccess,this.OnSDKLogoutSuccess)
    SDKMgr.RegisterLuaListener(SDKEventStatus.LogoutFail,this.OnSDKLogoutFail)

    --游戏SDK退出事件
    SDKMgr.RegisterLuaListener(SDKEventStatus.ExitPage,this.OnSDKExit)
    SDKMgr.RegisterLuaListener(SDKEventStatus.GameExitPage,this.OnSDKGameExit)
end

function this.IsLogined()
    return this.mode.S2CEnterGame ~= nil
end

function this.OnSDKLogoutSuccess(result)
    LogColor("#ff0000","OnSDKLogoutSuccess",result)
end

function this.OnSDKLogoutFail(result)
    LogColor("#ff0000","OnSDKLogoutFail",result)
end

function this.OnSDKExit(result)
     if (result == "onGameExit" or result == "onNo3rdExiterProvide") then
        --弹出退出游戏框
        HelpCtrl.OpenTipView(L("提   示"),L("确定退出游戏么？"),function ()
            UnityEngine.Application.Quit()
        end,nil,nil,nil,L("确 定"),L("取 消"))
    else
        UnityEngine.Application.Quit()
    end
end

function this.OnSDKGameExit(result)
    HelpCtrl.OpenTipView(L("提   示"),L("确定退出游戏么？"),function ()
        UnityEngine.Application.Quit()
    end,nil,nil,nil,L("确 定"),L("取 消"))
end

function this.ResetData()
    this.mode = {}
    this.GunList = {}
end

function this.HasGetGun(id)
    local hasGetGun = false
    for i,v in ipairs(this.mode.GunList) do
        if(v ~= nil and v.id == id) then
            hasGetGun = true
            break
        end
    end
    return hasGetGun
end

function this.IsCurGun(id)
    return id == this.GetCurGunId()
end

function this.GetCurGunId()
    return this.mode.S2CEnterGame.battery_id
end

function this.CheckLocalInfo()
    this.mode.LocalInfo = nil
    local hasLocalInfo = UnityEngine.PlayerPrefs.HasKey(_userNameKey) and UnityEngine.PlayerPrefs.HasKey(_userPasswordKey)
    if(not hasLocalInfo) then return false end
    local info = {}
    info.userName = UnityEngine.PlayerPrefs.GetString(_userNameKey,"")
    info.password = UnityEngine.PlayerPrefs.GetString(_userPasswordKey,"")
    if(info.userName == "" or info.password == "") then return false end
    this.mode.LocalInfo = info
    return true
end

function this.UpdateLocalInfo(userName,password)
    if(userName == nil or userName == "" and password == nil and password == "") then
        LogError("[UpdateLocalInfo] param can not nil!")
        return 
    end
    UnityEngine.PlayerPrefs.SetString(_userNameKey,userName)
    UnityEngine.PlayerPrefs.SetString(_userPasswordKey,password)
    UnityEngine.PlayerPrefs.Save()
    this.mode.LocalInfo = nil
end

function this.DeleteLocalInfo()
    UnityEngine.PlayerPrefs.DeleteKey(_userNameKey)
    UnityEngine.PlayerPrefs.DeleteKey(_userPasswordKey)
    this.mode.LocalInfo = nil
end

function this.Login()
    LinkCtrl.ConnectToLoginServer()
end

function this.CheckAndSDKLogin()
    if(not SDKMgr.IsLogined()) then
         SDKMgr.Login()
    end
end

--登录start
function this.C2SLogin(init_user_name,user_pwd)
    local sendData = NP_ClientServer_pb.C2SLogin()
    sendData.init_user_name = init_user_name
    sendData.user_pwd = user_pwd
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(2002, msg)
end

function this.C2SPlatformLogin(line_no,init_user_name,verify_param)
    local sendData = NP_ClientServer_pb.C2SPlatformLogin()
    sendData.line_no = line_no
    sendData.init_user_name = init_user_name
    sendData.verify_param = verify_param
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(2003, msg)
end

function this.S2CLoginResult(data) 
    local msg = NP_ServerClient_pb.S2CLoginResult()
    msg:ParseFromString(data)
    --判断登录结果
    if(msg.reulst ~= GlobalDefine.RetSucc) then
        HelpCtrl.Msg(L("登录失败，请重新登录"))
        return
    end

    this.mode.S2CResult = msg
    this.UpdateLocalInfo(msg.init_user_name,msg.user_pwd)
    LuaMsgHelper.connectToGameServer(msg.ip, msg.port)
end
--登录end

--内部方法写在下面

--注册（包含登录）start

function this.C2SRegister(line_no)--注册
    local sendData = NP_ClientServer_pb.C2SRegister()
    sendData.line_no = line_no
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(2001, msg)
end

function this.S2CRegisterResult(data)--注册返回
    -- local msg = NP_ServerClient_pb.S2CRegisterResult()
    -- msg:ParseFromString(data)
    -- this.mode.S2CResult = msg
    -- this.UpdateLocalInfo(msg.init_user_name,msg.user_pwd)
    -- LuaMsgHelper.connectToGameServer(msg.ip, msg.port)
end
--注册end


--进入游戏服务器start
function this.OnLinkGameSuccess()
    this.C2SEnterGame(this.mode.S2CResult.init_user_name,this.mode.S2CResult.user_pwd)
end

function this.OnLinkGameFail()
    HelpCtrl.OpenConfirmView(L("提   示"),L("连接服务器失败，请重新登录"),nil,nil,L("确 定"))
end

--进入登录服务器
function this.OnLinkLoginSuccess()
    -- body
    --登录
    if(Launch.GameConfig.IsUsedSDK) then
        if(SDKMgr.IsLogined()) then
            this.OnSDKLoginSuccess(nil)
        else
             SDKMgr.Login()
        end
    else
        if(this.CheckLocalInfo()) then
            LoginCtrl.C2SLogin(this.mode.LocalInfo.userName,this.mode.LocalInfo.password)
        else
            this.C2SRegister("00000000")
        end
    end
end

function this.OnSDKLoginSuccess(result) 
    local line_no = SDKMgr.GetCustomParam()
    local channel_id = SDKMgr.GetChannelId()
    local init_user_name = channel_id.."_"..SDKMgr.GetUserId()
    local verify_param = SDKMgr.GetVerfyParam()
    this.C2SPlatformLogin(line_no,init_user_name,verify_param)
end

function this.OnSDKLoginFail()
    LogColor("#ff0000","OnSDKLoginFail")
end


function this.OnLinkLoginFail()
    HelpCtrl.OpenConfirmView(L("提   示"),L("连接服务器失败，请重新登录"),nil,nil,L("确 定"))
end

function this.C2SEnterGame(init_user_name,user_pwd)
    local sendData = NP_ClientServer_pb.C2SEnterGame()
    sendData.init_user_name = init_user_name
    sendData.user_pwd = user_pwd
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(10004, msg)
end

function this.S2CEnterGame(data)    --进入游戏返回
    local msg = NP_ServerClient_pb.S2CEnterGame()
    msg:ParseFromString(data)
    this.mode.S2CEnterGame = msg
    LH.SetStatisticUserId(msg.user_name,msg.name)
    this.mode.GunList = {}
    for i,v in ipairs(msg.battery_list) do
        table.insert(this.mode.GunList,v)
    end
    this.GetGameData()
    this.SendEvent(LoginEvent.LoginCtrl_S2CEnterGame)
end

--游戏中拿初始数据在这里拿
function this.GetGameData()
    LogColor("#ff0000","GetGameData")
    LookForCtrl.C2STreasureGetInfo()
    SkillCtrl.C2SSkillGetInfo()
    BagCtrl.C2SBagGetInfo()
    RankCtrl.C2SRankGetInfo()
    RotationDiscCtrl.C2SLotteryGetInfo()
    OnlineCtrl.C2SSignGetSceneInfo()
    SignCtrl.C2SSignGetInfo()
    TaskCtrl.C2STaskGetInfo()

    --最终数据获取完成（收到这条消息的回复时，表示前面所有消息都应该收到了）
    PersonalCenterCtrl.C2SAttrEnterRoom2()
end

--进入游戏end


function this.S2CCodeNotice(data)
    local msg = NP_ServerClient_pb.S2CCodeNotice()
    msg:ParseFromString(data)
    if msg.code_type == 0 then
        local str = Res.code_def[msg.code_id].explain
        local explainType = string.Split(Res.code_def[msg.code_id].index_ttpe, ",")
        for i=1,#msg.list do
            if tonumber(explainType[i]) == 1 then
                str = string.gsub(str, "@"..msg.list[i].id.." ", msg.list[i].param)
            elseif tonumber(explainType[i]) == 2 then
                local name = Res.item[tonumber(msg.list[i].param)].name
                str = string.gsub(str, "@"..msg.list[i].id.." ", name)
            elseif tonumber(explainType[i]) == 3 then
                str = string.gsub(str, "@"..msg.list[i].id.." ", msg.list[i].param)
            end
        end
        HelpCtrl.Msg(str)
    elseif msg.code_type == 1 then
        if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
            return
        end   
        local str = Res.notice_def[msg.code_id].explain
        local explainType = string.Split(Res.notice_def[msg.code_id].index_ttpe, ",")
        for i=1,#msg.list do
            if tonumber(explainType[i]) == 1 then
                str = string.gsub(str, "@"..msg.list[i].id.." ", msg.list[i].param)
            elseif tonumber(explainType[i]) == 2 then
                local name = Res.item[tonumber(msg.list[i].param)].name
                str = string.gsub(str, "@"..msg.list[i].id.." ", name)
            elseif tonumber(explainType[i]) == 3 then
                str = string.gsub(str, "@"..msg.list[i].id.." ", msg.list[i].param)
            end
        end
        HelpCtrl.RunWord(str)
    end
end
