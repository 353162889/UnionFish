require "Protof/NP_CS_Room_pb"
require "Protof/NP_SC_Room_pb"
require 'Game/MainUI/MainEvent'

MainCtrl = CustomEvent()

local this = MainCtrl

this.mode = {}
this.mode.CurIslandId = nil
this.mode.ShowGoldOffsetDic = {}
this.mode.ShowDiamondOffsetDic = {}

function this.ResetData()
    this.mode = {}
    this.mode.ShowGoldOffsetDic = {}
    this.mode.ShowDiamondOffsetDic = {}
end

function this.AddShowGoldOffset(key,offset)
    local value = this.mode.ShowGoldOffsetDic[key]
    if(value == nil) then
        this.mode.ShowGoldOffsetDic[key] = offset
    else
        this.mode.ShowGoldOffsetDic[key] = value + offset
    end    
end

function this.ClearShowGoldOffset(key)
    if(this.mode.ShowGoldOffsetDic[key] ~= nil) then
        this.mode.ShowGoldOffsetDic[key] = nil
    end
end

function this.GetShowGold(num)
    local curGold = num
    for k,v in pairs(this.mode.ShowGoldOffsetDic) do
        if(v ~= nil) then
            curGold = curGold + v
        end
    end
    return curGold
end

function this.AddShowDiamondOffset(key,offset)
    local value = this.mode.ShowDiamondOffsetDic[key]
    if(value == nil) then
        this.mode.ShowDiamondOffsetDic[key] = offset
    else
        this.mode.ShowDiamondOffsetDic[key] = value + offset
    end
end

function this.ClearShowDiamondOffset(key)
    if(this.mode.ShowDiamondOffsetDic[key] ~= nil) then
        this.mode.ShowDiamondOffsetDic[key] = nil
    end
end

function this.ClearShowOffset(key)
    this.ClearShowGoldOffset(key)
    this.ClearShowDiamondOffset(key)
end

function this.GetShowDiamond(num)
    local curDiamond =  num
    for k,v in pairs(this.mode.ShowDiamondOffsetDic) do
        if(v ~= nil) then
            curDiamond = curDiamond + v
        end
    end
    return curDiamond
end

function this.GetFitAreaAndIsland()
    local curIsland = nil
    for k,v in pairs(Res.island) do
        if(v.type == IslandType.Normal) then
            if(curIsland ~= nil) then
                if(this.IsCanEnterIsland(v.id)) then
                    if(this.IsLevelGreater(v,curIsland)) then
                        curIsland = v
                    end
                end
            else
                if(this.IsCanEnterIsland(v.id)) then
                    curIsland = v
                end
            end
        end
    end
    local islandId = curIsland.id
    local areaId = nil
    for k,v in pairs(Res.area) do
        if(table.contains(v.island,islandId)) then
            areaId = k
            break
        end
    end
    return areaId,islandId
end

function this.IsIslandOpen(islandId)
    local islandData = Res.island[islandId]
    local isOpen = true
    if(#islandData.OpenType > 0) then
        local count = #islandData.OpenType
        for i=1,count do
            local cond = islandData.OpenType[i]
            local openCondInt = tonumber(cond[1])
            local openValue = tonumber(cond[2])
            if openCondInt == 1 then
                isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.level >= openValue)
            elseif openCondInt == 2 then
                isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.gold >= openValue)
            elseif openCondInt == 3 then
                isOpen = isOpen and (LoginCtrl.mode.S2CEnterGame.battery_rate >= openValue)
            end
        end
    end
    return isOpen
end

function this.IsCanEnterIsland(islandId)
    if(this.IsIslandOpen(islandId)) then
        local islandData = Res.island[islandId]
        if(LoginCtrl.mode.S2CEnterGame.gold >= islandData.gold_enter) then
            return true
        end
    end
    return false
end

--暂时以金币数量比较
function this.IsLevelGreater(a,b)
    if(a.gold_enter > b.gold_enter) then
        return true
    end
    return false
end

function this.C2SRoomEnterRoom(room_type_id,type)--15050
    -- LogError("this.C2SRoomEnterRoom(room_type_id)",room_type_id,type)
    local sendData = NP_CS_Room_pb.C2SRoomEnterRoom()
    sendData.room_type_id = room_type_id
    sendData.room_type = tonumber(type)

    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15050, msg)
end
function this.S2CRoomEnterRoom(data)--25050  0:成功; 1:已经在房间; 2：
    -- LogError("this.S2CRoomEnterRoom(data)")
    local msg = NP_SC_Room_pb.S2CRoomEnterRoom()
    msg:ParseFromString(data)
    this.mode.CurIslandId = msg.island_id
    if msg.ret == 0 then
        EventMgr.SendEvent(ED.MainCtrl_S2CRoomEnterRoom,{msg.island_id})
    else
        HelpCtrl.Msg(L("进入岛屿失败"))
    end
end

function this.C2SRoomStartRefresh()--15051
    local sendData = NP_CS_Room_pb.C2SRoomStartRefresh()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15051, msg)
end

function this.C2SRoomExitRoom()--15052
    local sendData = NP_CS_Room_pb.C2SRoomExitRoom()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15052, msg)
end
