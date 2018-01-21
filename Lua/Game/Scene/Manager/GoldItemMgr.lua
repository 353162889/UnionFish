require 'Game/Scene/Unit/UnitGold'

GoldItemMgr = {}

local this = GoldItemMgr

this.DicItem = {}
this.PoolItem = {}
this.EffectCount = 0
this.MaxEffectCount = 3
this.ListCallbackEffect = {}

this.GoldEffectCount = 0
this.MaxGoldEffectCount = 10
this.ListGoldEffect = {}
this.Template = nil

this.MaxGold = 40

function this.EnterFishScene(template)
	this.Template = template
	this.ListCallbackEffect = {}
	this.EffectCount = 0
	this.ListGoldEffect = {}
	this.GoldEffectCount = 0
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
	for k,v in pairs(this.ListCallbackEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	this.ListCallbackEffect = {}

	for k,v in pairs(this.ListGoldEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	this.ListGoldEffect = {}
	this.Template = nil
	EventMgr.RemoveEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,this.OnPlayLeave)
end

function this.ShowGolds(pos,gold_Icon,backRoleId)
    local d = string.Split(gold_Icon,",")
    PlaySound(AudioDefine.FishGetGold,nil)
    local isSelf = backRoleId == PlayCtrl.GetMainRole().role_obj_id
    local originPos = GunMgr.GetGun(backRoleId):GetCenterPos()
    local targetContainer = GunMgr.GetGun(backRoleId).container
    local offset = GunMgr.GetGun(backRoleId):GetCenterOffset()
    local count = tonumber(d[1])
    for i=1,count do
    	local item = this.GetGold()
    	item.roleObjId = backRoleId
    	item:Show(pos,tonumber(d[2]),tonumber(d[3])/2,isSelf,originPos,targetContainer,offset,this.ShowFinish)
    end
end

function this.GetGoldCallbackEffect()
	local effect = nil
	if(#this.ListCallbackEffect <= 0) then
		if(this.EffectCount < this.MaxEffectCount) then
			this.EffectCount = this.EffectCount + 1
			effect = UnitEffectMgr.CreateEffectObj(23001,nil)
		end
	else
		effect = this.ListCallbackEffect[1]
		table.remove(this.ListCallbackEffect,1)
	end
	return effect
end

function this.SaveGoldCallbackEffect(effect)
	effect:Reset()
	table.insert(this.ListCallbackEffect,effect)
end

function this.GetGoldEffect()
	if(#this.ListGoldEffect <= 0) then
		if(this.GoldEffectCount < this.MaxGoldEffectCount) then
			this.GoldEffectCount = this.GoldEffectCount + 1
			local effect = UnitEffectMgr.CreateEffectObj(22001,nil)
			table.insert(this.ListGoldEffect,effect)
		end
	end
	local effect = nil
	if(#this.ListGoldEffect > 0) then
		if(this.GoldEffectCount <= this.MaxGoldEffectCount or #this.ListGoldEffect >= this.MaxGoldEffectCount / 2) then
			effect = this.ListGoldEffect[1]
			table.remove(this.ListGoldEffect,1)
		else
			if(math.random(0,100) * 0.01 < 10) then
				effect = this.ListGoldEffect[1]
				table.remove(this.ListGoldEffect,1)
			end
		end
	end
	return effect
end

function this.SaveGoldEffect(effect)
	effect:Reset()
	table.insert(this.ListGoldEffect,effect)
end

function this.ShowFinish(unitGold)
	this.SaveGold(unitGold)
end

function this.GetGold()
	local item = nil
	if(#this.PoolItem <= 0) then
		local go = LH.GetGoBy(this.Template,this.Template.transform.parent.gameObject)
		go.name = "GoldItem"
		item = UnitGold:New(go)
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

function this.SaveGold(item)
	item.roleObjId = nil
	item.gameObject:SetActive(false)
	this.DicItem[item.id] = nil
	if(#this.PoolItem < this.MaxGold) then
		table.insert(this.PoolItem,item)
	else
		item:Dispose()
	end
end