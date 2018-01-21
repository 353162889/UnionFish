SayComponent = {}
function SayComponent:New(unit)
	local o = {unit = unit}
	setmetatable(o,self)
	self.__index = self
	return o
end

function SayComponent:Say(offset,txt,time)
	self.unitSay = SayMgr.GetUnitSay()
	local onFinish = function (item)
		if(self.unitSay ~= nil) then
			SayMgr.SaveUnitSay(self.unitSay)
			self.unitSay = nil
		end
	end
	local centerPoint = self.unit:GetMountPoint(UnitFishMPType.Bubble)
	self.unitSay:Show(centerPoint,offset,txt,time,onFinish)
end

function SayComponent:Reset()
	if(self.unitSay ~= nil) then
		SayMgr.SaveUnitSay(self.unitSay)
		self.unitSay = nil
	end
end

function SayComponent:Clear()
	self:Reset()
end
