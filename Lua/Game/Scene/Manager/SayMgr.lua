require 'Game/Scene/Unit/UnitSay'
SayMgr = {}

local this = SayMgr

this.DicItem = {}
this.PoolItem = {}
this.Template = nil
this.TemplateParent = nil

function this.EnterFishScene(template)
	this.Template = template
	this.TemplateParent = this.Template.transform.parent.gameObject
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
	this.Template = nil
	this.TemplateParent = nil
end

function this.GetUnitSay()
	local item = nil
	if(#this.PoolItem <= 0) then
		item = UnitSay:New(LH.GetGoBy(this.Template,this.TemplateParent))
	else
		item = this.PoolItem[1]
		table.remove(this.PoolItem,1)
	end
	item.gameObject:SetActive(true)
	if(this.DicItem[item.id] ~= nil) then
		LogError("exist item id "..item.id.." override id")
	end
	this.DicItem[item.id] = item
	return item
end

function this.SaveUnitSay(item)
	item.gameObject:SetActive(false)
	item:Reset()
	this.DicItem[item.id] = nil
	if(#this.PoolItem < 1) then
		table.insert(this.PoolItem,item)
	else
		item:Dispose()
	end
end
