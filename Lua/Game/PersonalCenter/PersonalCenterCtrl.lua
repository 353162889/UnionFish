require "Protof/NP_CS_Attr_pb"
require "Protof/NP_SC_Attr_pb"
require 'Game/PersonalCenter/PersonalCenterEvent'
PersonalCenterCtrl = CustomEvent()

local this = PersonalCenterCtrl

function this.ResetData()
    
end

--显示救济金面板，（如果返回false，说明今天的救济金已经全部领完）
function this.ShowDailyYassView()
    LogColor("#ff0000","daily_Ass",LoginCtrl.mode.S2CEnterGame.daily_Ass)
    if(LoginCtrl.mode.S2CEnterGame.daily_Ass > 0) then
        HelpCtrl.OpenConfirmView(L("金币不足"),L("可领取救济金{1}金币!\n金币不够的时候可以在商城购买哦。",Res.misc[1].BasePlayUse[2]),function ()
            this.C2SAttrGetDailyAss()
        end,nil,L("确 认"))
        return true
    end
    return false
end

function this.OpenView(roleInfo,isMainPlay)
    UIMgr.OpenView("PersonalCenterView",{roleInfo,isMainPlay})
end

function this.C2SAttrSetHeadId(id)
	LogColor("#ff0000","C2SAttrSetHeadId",id)
	local sendData = NP_CS_Attr_pb.C2SAttrSetHeadId()
    sendData.id = id
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15200, msg)
end

function this.S2CAttrSetHeadIdRet(data)
	local msg = NP_SC_Attr_pb.S2CAttrSetHeadIdRet()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CAttrSetHeadIdRet",msg.ret)
    if(msg.ret == GlobalDefine.RetSucc) then
         --改变当前的头像id
        LoginCtrl.mode.S2CEnterGame.head_id = msg.id
        EventMgr.SendEvent(ED.MainCtrl_PlayInfoChange)
    end
    this.SendEvent(PersonalCenterEvent.PlayerIconChange,msg)
end

function this.C2SAttrSetName(name)
    LogColor("#ff0000","C2SAttrSetName",name)
	local sendData = NP_CS_Attr_pb.C2SAttrSetName()
    sendData.name = name
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15201, msg)
end

function this.S2CAttrSetNameRet(data)
	local msg = NP_SC_Attr_pb.S2CAttrSetNameRet()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CAttrSetNameRet",msg.ret)
    if(msg.ret == GlobalDefine.RetSucc) then
        --改变当前的名字
        LoginCtrl.mode.S2CEnterGame.name = msg.name
        LoginCtrl.mode.S2CEnterGame.is_name = 1
        EventMgr.SendEvent(ED.MainCtrl_PlayInfoChange)
    end
    this.SendEvent(PersonalCenterEvent.PlayerNameChange,msg)
end

function this.C2SAttrSetGender(sex)
	LogColor("#ff0000","C2SAttrSetGender",sex)
	local sendData = NP_CS_Attr_pb.C2SAttrSetGender()
    sendData.type = sex
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15202, msg)
end

function this.S2CAttrSetGenderRet(data)
	local msg = NP_SC_Attr_pb.S2CAttrSetGenderRet()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CAttrSetGenderRet",msg.ret)
    if(msg.ret == GlobalDefine.RetSucc) then
        --改变当前的性别
        LoginCtrl.mode.S2CEnterGame.gender = msg.type
        LoginCtrl.mode.S2CEnterGame.is_gender = 1
        EventMgr.SendEvent(ED.MainCtrl_PlayInfoChange)
    end
    this.SendEvent(PersonalCenterEvent.PlayerSexChange,msg)
end

function this.C2SAttrGetRoleInfo(username)
    LogColor("#ff0000","C2SAttrGetRoleInfo",username)
    local sendData = NP_CS_Attr_pb.C2SAttrGetRoleInfo()
    sendData.user_name = username
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15206, msg)
end

function this.S2CAttrGetRoleInfoRet(data)
    local msg = NP_SC_Attr_pb.S2CAttrGetRoleInfoRet()
    msg:ParseFromString(data)
    this.OpenView(msg,false)
end

function this.C2SAttrSetBatteryRate(id)
    local sendData = NP_CS_Attr_pb.C2SAttrSetBatteryRate()
    sendData.lv = id
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15205, msg)
end

function this.S2CAttrSetBatteryRateRet(data)
    local msg = NP_SC_Attr_pb.S2CAttrSetBatteryRateRet()
    msg:ParseFromString(data)
    if(CheckCode(msg.ret))then
        local cfg = Res.gun_unlock[msg.lv]
        if(cfg ~= nil) then
            this.SendEvent(PersonalCenterEvent.GunRateUnlock,msg)
        end
    end
end

function this.ChangeCoin(value)
    LoginCtrl.mode.S2CEnterGame.gold = tonumber(value)
end
function this.ChangeDiamond(value)
    LoginCtrl.mode.S2CEnterGame.diamond = tonumber(value)
end
function this.ChangeGunID(value)
    LoginCtrl.mode.S2CEnterGame.battery_id = tonumber(value)
end
function this.ChangeGunRate(value)
   LoginCtrl.mode.S2CEnterGame.battery_rate = tonumber(value)
   --炮倍改变时
    if(GuideCtrl.HasGuide()) then
        GuideCtrl.SendEvent(GuideEvent.OnClientFinish,{GuideClientTaskKeyType.GunRateUnlock})
    end
end
function this.ChangeDailyass(value)
   LoginCtrl.mode.S2CEnterGame.daily_Ass = tonumber(value)
end
function this.ChangeSP(value)
   LoginCtrl.mode.S2CEnterGame.sp = tonumber(value)
end
function this.ChangeRMB(value)
    LogColor("更新人民币(前端没属性)")
end

this.AttrKeyDic = {
    [AttrDefine.ATTR_COIN] = this.ChangeCoin,
    [AttrDefine.ATTR_DIAMOND] = this.ChangeDiamond,
    [AttrDefine.ATTR_BATTERYID] = this.ChangeGunID,
    [AttrDefine.ATTR_BATTERYRATE] = this.ChangeGunRate,
    [AttrDefine.ATTR_DAILYASS] = this.ChangeDailyass,
    [AttrDefine.ATTR_SP] = this.ChangeSP,
    [AttrDefine.ATTR_RMB] = this.ChangeRMB,
}
function this.S2CAttrSyncRole(data)
    local msg = NP_SC_Attr_pb.S2CAttrSyncRole()
    msg:ParseFromString(data)
    local keys = {}
    for i,v in ipairs(msg.item) do
        local key = tonumber(v.key)
        if(this.AttrKeyDic[key] ~= nil) then
            this.AttrKeyDic[key](v.val)
            table.insert(keys,key)
        else
            LogError("can not find AttrKey:"..key)
        end
    end
     EventMgr.SendEvent(ED.MainCtrl_PlayInfoChange,keys)
end

--测试场景设置炮台id（假的）
function this.C2SAttrSetSceneBatteryId(gunID)
     local sendData = NP_CS_Attr_pb.C2SAttrSetSceneBatteryId()
    sendData.id = gunID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15208, msg)
end

function this.S2CAttrUnlockBattery(data)
    local msg = NP_SC_Attr_pb.S2CAttrUnlockBattery()
    msg:ParseFromString(data)
     LogColor("#ff0000","S2CAttrUnlockBattery",#msg.list)
    local gunList = {}
    for i,v in ipairs(msg.list) do
        table.insert(gunList,v)
    end
    LoginCtrl.mode.GunList = gunList
end

function this.C2SAttrGetDailyAss()
    local sendData = NP_CS_Attr_pb.C2SAttrGetDailyAss()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15207, msg)
end

--进入游戏拿去数据的确认
function this.C2SAttrEnterRoom2()
    LogColor("#ff0000","C2SAttrEnterRoom2")
    local sendData = NP_CS_Attr_pb.C2SAttrEnterRoom2()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15209, msg)
end

function this.S2CAttrEnterRoom2( data )
    LogColor("#ff0000","S2CAttrEnterRoom2")
    this.SendEvent(PersonalCenterEvent.GetAllData)
end