RotationDiscLeftTabItem = {}

function RotationDiscLeftTabItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RotationDiscLeftTabItem:Init()
	self.ListItem = {}
	for i=1,4 do
		local item = Find(self.gameObject,"Tab_"..i)
		item:SetActive(true)
		local onClick = function (go)
			self:Update(i)
		end
		LH.AddClickEvent(Find(item,"UnSelect"),onClick)
		table.insert(self.ListItem,item)
	end
end

function RotationDiscLeftTabItem:SetItemSelect(item,select)
	local selectGO = Find(item,"Select")
	local unSelectGO = Find(item,"UnSelect")
	selectGO:SetActive(select)
	unSelectGO:SetActive(not select)
end

function RotationDiscLeftTabItem:Update(SelectIndex)
	if(self.SelectIndex ~= SelectIndex) then
		self.SelectIndex = SelectIndex
		for i=1,#self.ListItem do
			self:SetItemSelect(self.ListItem[i],SelectIndex == i)
		end
		--if(self.SelectIndex > 0) then
			RotationDiscCtrl.SendEvent(RotationDiscEvent.OnLottoryTabChange,self.SelectIndex)
		--end
	end
end

function RotationDiscLeftTabItem:Dispose()
	
end

