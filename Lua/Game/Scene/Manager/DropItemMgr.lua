require 'Game/Scene/Unit/UnitDrop'
DropItemMgr = {}

local this = DropItemMgr
this.DicItem = {}
this.PoolItem = {}
this.Template = nil
this.MaxDropItem = 2

function this.EnterFishScene(template)
	this.Template = template
	PlayCtrl.AddEvent(PlayEvent.PlayCtrl_DropItem,this.OnDropItem)
end

function this.ExitFishScene()
	PlayCtrl.RemoveEvent(PlayEvent.PlayCtrl_DropItem,this.OnDropItem)

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

	this.Template = nil
end

function this.GetParent(itemId)
	if(itemId == GlobalDefine.FishHookId) then
		return UIMgr.Dic("PlayView"):GetGunUnlockBtn()
	elseif(itemId == GlobalDefine.GoldFishDropItemId) then
		return UIMgr.Dic("PlayView"):GetTreasureBtn()
	end
	return nil
end

function this.ShowDropItem(fishObjId,itemId,num)
	local fish = FishMgr.GetFish(fishObjId)
	if(fish == nil) then return end
	local parent = this.GetParent(itemId)
	if(parent == nil) then return end
	local item = this.GetDropItem()
	local pos = LH.WorldPosToUIPos(fish.gameObject.transform.position)
	--local pos = Vector3.zero
	local afterShow = function (unitDrop)
		this.SaveDropItem(unitDrop)
	end
	item:Show(parent,itemId,num,pos,2,1,afterShow)
end

function this.OnDropItem(msg)
	LogColor("#ff0000","OnDropItem",msg.item_id,msg.num)
	this.ShowDropItem(msg.fish_obj_id,msg.item_id,msg.num)
end

function this.GetDropItem()
	local item = nil
	if(#this.PoolItem <= 0) then
		local go = LH.GetGoBy(this.Template,this.Template.transform.parent.gameObject)
		go.name = "DropItem"
		item = UnitDrop:New(go)
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

function this.SaveDropItem(item)
	item.gameObject:SetActive(false)
	Ext.AddChildToParent(this.Template.transform.parent.gameObject,item.gameObject,false)
	this.DicItem[item.id] = nil
	if(#this.PoolItem < this.MaxDropItem) then
		table.insert(this.PoolItem,item)
	else
		item:Dispose()
	end
end