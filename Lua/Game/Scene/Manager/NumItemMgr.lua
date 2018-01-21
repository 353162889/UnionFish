require 'Game/Scene/Unit/UnitNum'
NumItemMgr = {}

local this = NumItemMgr

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

function this.ShowNum(pos,num,color)
	local item = this.GetNum()
	local onFinish = function (unitNum)
		this.SaveNum(unitNum)
	end
	item:Show(pos,num,color,onFinish)
end

function this.GetNum()
	local item = nil
	if(#this.PoolItem <= 0) then
		item = UnitNum:New(LH.GetGoBy(this.Template,this.TemplateParent))
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

function this.SaveNum(item)
	item.gameObject:SetActive(false)
	this.DicItem[item.id] = nil
	if(#this.PoolItem < 6) then
		table.insert(this.PoolItem,item)
	else
		item:Dispose()
	end
end