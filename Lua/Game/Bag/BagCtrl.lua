require "Protof/NP_CS_Bag_pb"
require "Protof/NP_SC_Bag_pb"

BagCtrl = CustomEvent()

local this = BagCtrl

this.mode = {}
this.mode.S2CBagGetInfoData = nil

function this.ResetData()
    this.mode = {}
    this.mode.S2CBagGetInfoData = nil
end

function this.GetItems(listIds)
    if(this.mode.S2CBagGetInfoData == nil) then return {} end
    local list = {}
    for i=1,#this.mode.S2CBagGetInfoData do
        for j=1,#listIds do
            if (this.mode.S2CBagGetInfoData[i].id == listIds[j]) then
                list[listIds[j]] = this.mode.S2CBagGetInfoData[i]
            end
        end
    end
    return list
end

function this.GetItem(id)
    if(this.mode.S2CBagGetInfoData == nil) then return nil end
    local item = nil
    for i=1,#this.mode.S2CBagGetInfoData do
        if (this.mode.S2CBagGetInfoData[i].id == id) then
            item = this.mode.S2CBagGetInfoData[i]
        end
    end
    return item
end

function this.GetItemConfig(id)
    local item = Res.item[id]
    if(item == nil) then
        LogError("can not find item cfg id:"..id)
        return nil
    else
        return item
    end
end

function this.GetMoneyItem(id)
    if(id == GlobalDefine.Gold) then
        return {id=id,cnt=LoginCtrl.mode.S2CEnterGame.gold}
    elseif(id == GlobalDefine.DiamondID) then
        return {id=id,cnt=LoginCtrl.mode.S2CEnterGame.diamond}
    else
        return nil
    end
end

function this.C2SBagGetInfo()--15300
    --LogError("C2SBagGetInfo")
    local sendData = NP_CS_Bag_pb.C2SBagGetInfo()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15300, msg)
end

function this.S2CBagGetInfo(data)
    --LogError("S2CBagGetInfo")
    local msg = NP_SC_Bag_pb.S2CBagGetInfo()
    msg:ParseFromString(data)
    this.mode.S2CBagGetInfoData = msg.list
end
-- message item_data
-- {
-- 	required uint32 only_key		= 1;
-- 	required uint32 id 				= 2;
-- 	required uint32 cnt 			= 3;
-- }

function this.S2CBagUpdate(data)
   -- LogError("S2CBagUpdate")
    local msg = NP_SC_Bag_pb.S2CBagUpdate()
    msg:ParseFromString(data)
    for i=#msg.list,1,-1 do
        if(msg.list[i].id == GlobalDefine.FishHookId) then
        end
    	for j=1,#this.mode.S2CBagGetInfoData do
    		if this.mode.S2CBagGetInfoData[j].only_key == msg.list[i].only_key then
    			this.mode.S2CBagGetInfoData[j] = msg.list[i]
                table.remove(msg.list,i)
                break
    		end
    	end
    end
    for i=1,#msg.list do
        table.insert(this.mode.S2CBagGetInfoData,msg.list[1])
    end
    for i=#this.mode.S2CBagGetInfoData,1,-1 do
        if this.mode.S2CBagGetInfoData[i].cnt == 0 then
            table.remove(this.mode.S2CBagGetInfoData,i)
        end
    end
    EventMgr.SendEvent(ED.BagCtrl_S2CBagUpdate,nil)
end
function this.S2CBagDelete(data)
   -- LogError("S2CBagDelete")
    local msg = NP_SC_Bag_pb.S2CBagDelete()
    msg:ParseFromString(data)
    for i=1,#msg.list do
    	for j=#this.mode.S2CBagGetInfoData,1,-1 do
    		if this.mode.S2CBagGetInfoData[j].only_key == msg.list[i].only_key then
    			table.remove(this.mode.S2CBagGetInfoData,j)
    		end
    	end
    end
    EventMgr.SendEvent(ED.BagCtrl_S2CBagUpdate,nil)
end

function this.C2SBagUseItem(id,num)--15301使用物品
    --LogError("C2SBagUseItem",id,num)
    local sendData = NP_CS_Bag_pb.C2SBagUseItem()
    sendData.id = id
    sendData.num = num
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15301, msg)
end
function this.S2CBagUseItem(data)
    --LogError("S2CBagUseItem")
    local msg = NP_SC_Bag_pb.S2CBagUseItem()
    msg:ParseFromString(data)
    local d = Res.item[msg.id]
    HelpCtrl.Msg(L("使用{1} × {2}成功！",d.name,msg.num))
end

function this.C2SBagSellItem(id,num)--15302物品卖出
    --LogError("C2SBagSellItem",id,num)
    local sendData = NP_CS_Bag_pb.C2SBagSellItem()
    sendData.id = id
    sendData.num = num
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15302, msg)
end
function this.S2CBagSellItem(data)
    --LogError("S2CBagSellItem")
    local msg = NP_SC_Bag_pb.S2CBagSellItem()
    msg:ParseFromString(data)
    local d = Res.item[msg.id]
    HelpCtrl.Msg(L("出售{1} × {2}成功！",d.name,msg.num))
end

function this.GetItemCntById(id)
    local t = this.mode.S2CBagGetInfoData
    local r = 0
    for i=1,#t do
        if t[i].id == id then
            r = r + t[i].cnt
        end
    end
    return r
end