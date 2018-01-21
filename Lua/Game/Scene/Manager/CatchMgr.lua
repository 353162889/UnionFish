require 'Game/Scene/Unit/UnitCatch'
require "Game/Scene/Cmd/UI/Cmd_CatchUIShow"

CatchMgr = {}

local this = CatchMgr

this.DicItem = {}
this.PoolItem = {}
this.Template = nil
this.MaxCatch = 4
this.DicSequence = {}

function this.EnterFishScene(template)
	this.Template = template
	EventMgr.AddEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,this.OnPlayLeave)
end

--如果玩家离开场景，移除引用
function this.OnPlayLeave(lt)
	local objId = tonumber(lt[1])
	local list = {}
	for k,v in pairs(this.DicItem) do
		if(v ~= nil and v.roleObjId == objId) then
			table.insert(list,k)
		end
	end
	for k,v in pairs(list) do
		this.DicItem[v]:Dispose()
		this.DicItem[v] = nil
	end
	
end

function this.ExitFishScene()
	for k,v in pairs(this.DicItem) do
		if(v ~= nil) then
			v:Dispose()
		end
	end
	this.DicItem = {}
	for k,v in pairs(this.PoolItem) do
		if(v ~= nil) then
			v:Dispose()
		end
	end
	this.PoolItem = {}
	for k,v in pairs(this.DicSequence) do
		if(v ~= nil) then
			v:OnDestroy()
		end
	end
	this.DicSequence = {}
	this.Template = nil
	EventMgr.RemoveEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,this.OnPlayLeave)
end

function this.ShowCatch(roleObjId,num,fishInfo)
	local d = string.Split(fishInfo.ui_Catch,",")
    if tonumber(d[1]) == 0 then
        return
    end
    local sequence = this.DicSequence[roleObjId]
    if(sequence == nil) then
    	sequence = CommandDynamicSequence.new(false)
    	this.DicSequence[roleObjId] = sequence
    end
    local cmd = Cmd_CatchUIShow.new(roleObjId,num,fishInfo)
    sequence:AddSubCommand(cmd)
end

function this.ShowCatchSelf(roleObjId,num,fishInfo,callback)
	local catch = CatchMgr.GetCatch()
	local afterShow = function (unitCatch)
		this.ShowFinish(unitCatch)
		if(callback ~= nil) then
			local temp = callback
			callback = nil
			temp()
		end
	end
	catch.roleObjId = roleObjId
	catch:Show(roleObjId,num,fishInfo,1,afterShow)
end

function this.ShowFinish(unitCatch)
	this.SaveCatch(unitCatch)
end

function this.GetCatch()
	local item = nil
	if(#this.PoolItem <= 0) then
		local go = LH.GetGoBy(this.Template,this.Template.transform.parent.gameObject)
		go.name = "CatchItem"
        local numGo = go.transform:Find("Catch/Num")
        numGo.gameObject:AddComponent(typeof(ChangeNumberHelper))
		item = UnitCatch:New(go)
	else
		item = this.PoolItem[1]
		table.remove(this.PoolItem,1)
	end
	item.gameObject:SetActive(true)
	local id = item.id
	if(this.DicItem[id] ~= nil) then
		LogError("exist item id "..id.." override id")
	end
	this.DicItem[id] = item
	return item
end

function this.SaveCatch(item)
	item.roleObjId = nil
	item.gameObject:SetActive(false)
	item:Reset()
	this.DicItem[item.id] = nil
	if(#this.PoolItem < this.MaxCatch) then
		table.insert(this.PoolItem,item)
	else
		item:Dispose()
	end
end

