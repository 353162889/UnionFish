require "Protof/NP_CS_Room_pb"
require "Protof/NP_SC_Room_pb"
require "Protof/NP_CS_Scene_pb"
require "Protof/NP_SC_Scene_pb"
require "Game/Play/PlayEvent"

PlayCtrl = CustomEvent()

local this = PlayCtrl

this.mode = {}
this.mode.RoleInfoList = {}
this.mode.CurSceneID = 0
this.mode.CameraID = 0
this.mode.CameraPos = 0
this.mode.MyGunItem = nil
this.mode.MyGunData = nil
this.mode.GunItemList = {}

function this.ResetData()
    this.mode = {}
    this.mode.RoleInfoList = {}
    this.mode.CurSceneID = 0
    this.mode.CameraID = 0
    this.mode.CameraPos = 0
    this.mode.MyGunItem = nil
    this.mode.MyGunData = nil
    this.mode.GunItemList = {}
end

--打开刷鱼界面type: 2.鱼群   1.boss    ...  如果当前type = 1，那么需要传入boss的ID
function this.OpenFishComeView(type,...)
    UIMgr.OpenView("FishComeView",{type,...})
end

function this.CloseFishComeView()
    UIMgr.CloseView("FishComeView")
end

function this.IsMainRole(roleObjId)
    if(GunMgr.MainGun == nil) then return false end
    return roleObjId == GunMgr.MainGun.roleData.role_obj_id 
end

function this.IsRobotRole(roleObjId)
    local gun = GunMgr.GetGun(roleObjId)
    if(gun == nil) then return false end
    return gun.roleData.ai_type == 1
end

function this.IsMainPlayOperateRobotRole(roleObjId)
    if(this.IsRobotRole(roleObjId)) then
        if(GunMgr.MainGun == nil) then return false end
        return GunMgr.MainGun.roleData.ai_type == 2 
    end
    return false
end

function this.IsOperateRobotRole(roleObjId)
    local gun = GunMgr.GetGun(roleObjId)
    if(gun == nil) then return false end
    LogColor("#ff0000","IsOperateRobotRole",gun.roleData.ai_type)
    return gun.roleData.ai_type == 2
end

function this.IsMainRoleInRoleId(roleId)
    if(GunMgr.MainGun == nil) then return false end
    return roleId == LoginCtrl.mode.S2CEnterGame.role_id
end

--获取到主玩家的信息（协议里面的Role信息）
function this.GetMainRole()
    if(GunMgr.MainGun == nil)then return nil end
    return GunMgr.MainGun.roleData
end

function this.C2SSceneMoveGun(point,angle)
    local sendData = NP_CS_Scene_pb.C2SSceneMoveGun()
    sendData.point = point
    sendData.angle = angle
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14000, msg)
end

function this.S2CSceneEnterScene(data)
    local msg = NP_SC_Scene_pb.S2CSceneEnterScene()
    msg:ParseFromString(data)
    this.mode.RoleInfoList = {}
    table.insert(this.mode.RoleInfoList,msg.role_info)
    for i,v in ipairs(msg.role_info_list) do
        table.insert(this.mode.RoleInfoList,v)
    end
    -- LogError(msg.role_info)
    this.mode.CurSceneID = msg.scene_id
    this.mode.CameraID = msg.camera_obj_id
    this.mode.CameraPos = msg.camera_pos
    EventMgr.SendEvent(ED.PlayCtrl_S2CSceneEnterScene,msg)

    --主玩家进入场景时会收到子弹列表(子弹初始化要在炮台数据之后)
    --BulletMgr.InitEnterSceneBullet(msg.bullet_cache_list,msg.enter_time)
end

function this.S2CSceneLeaveScene(data)
    Log("S2CSceneLeaveScene,num:",#this.mode.RoleInfoList)
    local msg = NP_SC_Scene_pb.S2CSceneLeaveScene()
    msg:ParseFromString(data)
    --直接回到球形场景界面
    local areaId,islandId = MainCtrl.GetFitAreaAndIsland()
    LuaSceneMgr.EnterScene(GlobalDefine.BallSceneID,areaId,islandId)
    -- LuaSceneMgr.EnterScene(GlobalDefine.BallSceneID)

    --EventMgr.SendEvent(ED.PlayCtrl_S2CSceneLeaveScene)
    this.mode.RoleInfoList = {}
    this.mode.CurSceneID = 0
    this.mode.CameraID = 0
    this.mode.CameraPos = 0
    this.mode.MyGunItem = nil
    this.mode.MyGunData = nil
end

function this.S2CSceneRoleEnterScene(data)
    local msg = NP_SC_Scene_pb.S2CSceneRoleEnterScene()
    msg:ParseFromString(data)
    table.insert(this.mode.RoleInfoList,msg.role_info)
    GunMgr.CreateGun(msg.role_info)
    EventMgr.SendEvent(ED.PlayCtrl_S2CSceneRoleEnterScene,{msg.role_info})
end

function this.S2CSceneFishEnterScene(data)
   -- LogError("this.S2CSceneFishEnterScene(data)")
    local msg = NP_SC_Scene_pb.S2CSceneFishEnterScene()
    msg:ParseFromString(data)
    FishMgr.OnServerCreateFish(msg.data) 
    EventMgr.SendEvent(ED.PlayCtrl_S2CSceneFishEnterScene,msg)
end

function this.S2CSceneSynRole(data)
    local msg = NP_SC_Scene_pb.S2CSceneSynRole()
    msg:ParseFromString(data)
    for i=1,#this.mode.RoleInfoList do
        if this.mode.RoleInfoList[i].role_obj_id == msg.role_info.role_obj_id then
            this.mode.RoleInfoList[i] = msg.role_info
            GunMgr.UpdateGunData(msg.role_info)
            EventMgr.SendEvent(ED.PlayCtrl_S2CSceneSynRole,{msg.role_info.role_obj_id})
        end
    end
end

function this.S2CSceneSynchroUpdate(data)
    local msg = NP_SC_Scene_pb.S2CSceneSynchroUpdate()
    msg:ParseFromString(data)
    for i=1,#this.mode.RoleInfoList do
        if this.mode.RoleInfoList[i].role_obj_id == msg.obj_id then
            this.mode.RoleInfoList[i].coin = msg.coin
            this.mode.RoleInfoList[i].diamond = msg.diamond
            GunMgr.OnRefreshShow(msg.obj_id)
            EventMgr.SendEvent(ED.PlayCtrl_S2CSceneSynchroUpdate,msg)
        end
    end
end

function this.S2CSceneSynObj(data)
    local msg = NP_SC_Scene_pb.S2CSceneSynObj()
    msg:ParseFromString(data)
    EventMgr.SendEvent(ED.PlayCtrl_S2CSceneSynObj,{msg.objs_pos})
    FishMgr.SyncFishPos(msg.objs_pos,msg.new_time)
    BulletMgr.OnBulletTick(msg.new_time)
    CameraMgr.SyncPos(msg.objs_pos)   
end

function this.S2CSceneObjLeave(data)
    local msg = NP_SC_Scene_pb.S2CSceneObjLeave()
    msg:ParseFromString(data)
    -- LogError("this.S2CSceneObjLeave(data)",msg.obj_id)
    local isRole = false
    for i=#this.mode.RoleInfoList,1,-1 do
        if this.mode.RoleInfoList[i].role_obj_id == msg.obj_id then
            table.remove(this.mode.RoleInfoList,i)
            isRole = true
             EventMgr.SendEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,{msg.obj_id})
            GunMgr.RemoveGun(msg.obj_id)
            EventMgr.SendEvent(ED.PlayCtrl_S2CSceneObjLeave,{msg.obj_id})
        end
    end
    if(not isRole) then
        if msg.is_die == 0 then
            FishMgr.RemoveFish(msg.obj_id)
        elseif msg.is_die == 1 then
            local role_id = this.GetMainRole().role_obj_id
            FishMgr.OnFishDead(msg.role_id,msg.obj_id)
        end
    end
end

function this.C2SSceneSendBullet(bullet_type,point_x,point_y,angle)
    local sendData = NP_CS_Scene_pb.C2SSceneSendBullet()
    sendData.bullet_type = bullet_type
    sendData.point_x = point_x
    sendData.point_y = point_y
    sendData.angle = angle
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14002, msg)
end

function this.S2CSceneSendBullet(data)
    local msg = NP_SC_Scene_pb.S2CSceneSendBullet()
    msg:ParseFromString(data)
    GunMgr.ServerSendBullet(msg)
   -- EventMgr.SendEvent(ED.PlayCtrl_S2CSceneSendBullet,{msg})
end

function this.C2SSceneGetBackBullet(role_obj_id,bullet_only_key)
   -- 如果是玩家自己或机器人
    if(this.IsMainRole(role_obj_id)) then
        local sendData = NP_CS_Scene_pb.C2SSceneGetBackBullet()
        sendData.bullet_only_key = bullet_only_key
        local msg = sendData:SerializeToString()
        LuaMsgHelper.sendBinMsgData(14003, msg)
    elseif(this.IsMainPlayOperateRobotRole(role_obj_id)) then
        local sendData = NP_CS_Scene_pb.C2SSceneAIGetBackBullet()
        sendData.role_id = GunMgr.GetGun(role_obj_id).roleData.role_id
        sendData.bullet_only_key = bullet_only_key
        local msg = sendData:SerializeToString()
        LuaMsgHelper.sendBinMsgData(14012, msg)
    end
end

function this.S2CSceneBackBullet(data)
    local msg = NP_SC_Scene_pb.S2CSceneBackBullet()
    msg:ParseFromString(data)
    --LogColor("#ff0000","S2CSceneBackBullet",msg.bullet_only_key)
    BulletMgr.ServerRecycleBullet(msg.bullet_only_key)  --服务器回收子弹
end

function this.C2SSceneAttackFish(role_obj_id,bullet_only_key,fish_obj_id)
    if(this.IsMainRole(role_obj_id)) then
        local sendData = NP_CS_Scene_pb.C2SSceneAttackFish()
        sendData.bullet_only_key = bullet_only_key
        sendData.fish_obj_id = fish_obj_id
        local msg = sendData:SerializeToString()
        LuaMsgHelper.sendBinMsgData(14004, msg)
    elseif(this.IsMainPlayOperateRobotRole(role_obj_id)) then
        local sendData = NP_CS_Scene_pb.C2SSceneAIAttackFish()
        sendData.role_id = GunMgr.GetGun(role_obj_id).roleData.role_id
        sendData.bullet_only_key = bullet_only_key
        sendData.fish_obj_id = fish_obj_id
        local msg = sendData:SerializeToString()
        LuaMsgHelper.sendBinMsgData(14011, msg)
    end
end
function this.S2CSceneAttackFish(data) 
    local msg = NP_SC_Scene_pb.S2CSceneAttackFish() 
    msg:ParseFromString(data)
    FishMgr.ShowSceneAttackFishEffect(msg)
    EventMgr.SendEvent(ED.PlayCtrl_S2CSceneAttackFish,msg)
    

    -- BulletMgr.RealGetBackBullet(msg.bullet_only_key)

    -- required uint32 role_obj_id     = 1; 
    -- required uint32 get_coin        = 2; 
    -- required uint32 bullet_only_key = 3; 
    -- required uint32 fish_obj_id     = 4; 
    -- required uint32 combo           = 5; 
    -- required uint32 energy          = 6; 
end


function this.S2CSceneFishLock(data)
    local msg = NP_SC_Scene_pb.S2CSceneFishLock()
    msg:ParseFromString(data)
    FishMgr.OnServerLockFish(msg)
end

--设置炮倍
function this.C2SSceneSetGunLevel(rate)
    local sendData = NP_CS_Scene_pb.C2SSceneSetGunLevel()
    sendData.lv = rate
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14006, msg)
end

--设置炮倍返回
function this.S2CSceneSetGunRet(data)
    local msg = NP_SC_Scene_pb.S2CSceneSetGunRet()
    msg:ParseFromString(data)
    GunMgr.OnGunRateChange(msg.obj_id,msg.gun_lv)
end

--发送暴走
function this.C2SSceneOutBreak()
    local sendData = NP_CS_Scene_pb.C2SSceneOutBreak()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14008, msg)
end

--收到暴走
function this.S2CSceneOutBreak(data)
    local msg = NP_SC_Scene_pb.S2CSceneOutBreak()
    msg:ParseFromString(data)
    --GunMgr.OnOutBreak(msg.obj_id)
end

function this.C2SSceneChangeGun(weapon)
    local sendData = NP_CS_Scene_pb.C2SSceneChangeGun()
    sendData.weapon = weapon
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14001, msg)
end

function this.S2CSceneChangeGun(data)
    local msg = NP_SC_Scene_pb.S2CSceneChangeGun()
    msg:ParseFromString(data)
    GunMgr.OnGunChange(msg.obj_id,msg.weapon)
    this.SendEvent(PlayEvent.PlayCtrl_ChangeGun,{msg.obj_id,msg.weapon})
end

function this.S2CSceneMoveGun(data)
    local msg = NP_SC_Scene_pb.S2CSceneMoveGun()
    msg:ParseFromString(data)
    GunMgr.SyncGunPos(msg)
end

function this.S2CSceneRefStatus(data)
    local msg = NP_SC_Scene_pb.S2CSceneRefStatus()
    msg:ParseFromString(data)
    --玩家
    if(msg.obj_type == 1) then
        GunMgr.OnUpdateState(msg)
    elseif(msg.obj_type == 3) then
        FishMgr.OnUpdateState(msg)
    elseif(msg.obj_type == 2) then
        CameraMgr.OnUpdateState(msg)
    end
end

function this.S2CSceneDelStatus(data)
     local msg = NP_SC_Scene_pb.S2CSceneDelStatus()
    msg:ParseFromString(data)
     --玩家
    if(msg.obj_type == 1) then
         GunMgr.OnDeleteState(msg)
    elseif(msg.obj_type == 3) then
        FishMgr.OnDeleteState(msg)
    elseif(msg.obj_type == 2) then
        CameraMgr.OnDeleteState(msg)
    end
end

function this.C2SSceneAttackMultiFish(stateID,listFishObjId)
    local sendData = NP_CS_Scene_pb.C2SSceneAttackMultiFish()
    sendData.status_id = stateID
    for i=1,#listFishObjId do
        sendData.fish_obj_id_list:append(listFishObjId[i])
    end
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(14009, msg)
end

function this.C2SSceneFunctionFish(type,listFishObjId,pos)
    local sendData = NP_CS_Scene_pb.C2SSceneFunctionFish()
    sendData.func_type = type
    for i=1,#listFishObjId do
        sendData.fish_obj_id_list:append(listFishObjId[i])
    end
    sendData.params = tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z)
    local msg = sendData:SerializeToString()
    LogColor("#ff0000","C2SSceneFunctionFish",type)
    LuaMsgHelper.sendBinMsgData(14010, msg)
end

function this.S2CSceneFuncAttackFish(data)
    LogColor("#ff0000","S2CSceneFuncAttackFish")
    local msg = NP_SC_Scene_pb.S2CSceneFuncAttackFish()
    msg:ParseFromString(data)
    local func_type = msg.type
    local listFish = msg.id_list
    local pos = GetVector3(msg.params)
    FishMgr.OnFuncAttackFish(func_type,listFish,pos)
end

function this.S2CSceneAddItem(data)
    local msg = NP_SC_Scene_pb.S2CSceneAddItem()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CSceneAddItem",msg.fish_obj_id,msg.item_id,msg.num)
    this.SendEvent(PlayEvent.PlayCtrl_DropItem,msg)
end