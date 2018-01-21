require 'Game/Scene/Unit/UnitBubble'
require "Game/Scene/Cmd/UI/Cmd_ComponentBubbleNumShow"
BubbleNumComponent = {}
function BubbleNumComponent:New(unit,template)
	local o = {unit = unit}
	o.DicItem = {}
	o.PoolItem = {}
	o.Template = template
	o.TemplateParent = o.Template.transform.parent.gameObject
	o.sequence = CommandDynamicSequence.new(false)
	setmetatable(o,self)
	self.__index = self
	return o
end


function BubbleNumComponent:Dispose()
	self.sequence:OnDestroy()
	for k,v in pairs(self.DicItem) do
		if(v ~= nil) then
			v:Dispose()
		end
	end
	self.DicItem = {}
	for k,v in pairs(self.PoolItem) do
		if(v ~= nil) then
			v:Dispose()
		end
	end
	self.PoolItem = {}
	self.Template = nil
	self.TemplateParent = nil
end

function BubbleNumComponent:ShowNumSequence(pos,num,color)
	local cmd = Cmd_ComponentBubbleNumShow.new(self,pos,num,color)
	self.sequence:AddSubCommand(cmd)
end

function BubbleNumComponent:ShowNum(pos,num,color)
	local item = self:GetItem()
	local onFinish = function (unitBubble)
		self:SaveItem(unitBubble)
	end
	item:Show(pos,num,color,onFinish)
end

function BubbleNumComponent:GetItem()
	local item = nil
	if(#self.PoolItem <= 0) then
		item = UnitBubble:New(LH.GetGoBy(self.Template,self.TemplateParent))
	else
		item = self.PoolItem[1]
		table.remove(self.PoolItem,1)
	end
	item.gameObject:SetActive(true)
	if(self.DicItem[item.id] ~= nil) then
		LogError("exist item id "..item.id.." override id")
	end
	self.DicItem[item.id] = item
	return item
end

function BubbleNumComponent:SaveItem(item)
	item.gameObject:SetActive(false)
	self.DicItem[item.id] = nil
	if(#self.PoolItem < 4) then
		table.insert(self.PoolItem,item)
	else
		item:Dispose()
	end
end