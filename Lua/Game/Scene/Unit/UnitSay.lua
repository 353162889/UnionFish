
UnitSay = {}
function UnitSay:New(go)
	local o = {}
	o.id = go:GetInstanceID()
	o.tableName = "UnitSay"
	o.gameObject = go
	o.transform = o.gameObject.transform
	o.label = o.transform:FindChild("Content/Label"):GetComponent("UILabel")
	o.ts = o.gameObject:GetComponent("TweenScale")
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitSay:Show(attackObj,offset,txt,time,callback)
	if(self.moveHelper == nil) then
		self.moveHelper = self.gameObject:AddComponent(typeof(UIFollowGOHelper))
	end
	self.moveHelper:SetTargetOffsetByXYZ(attackObj,offset.x,offset.y,offset.z)
    LB(self.label,"{1}",txt)
    LH.SetTweenScale(self.ts,0,0.2,Vector3.zero,Vector3.one)
	local onFinish = function ()
		self.TimeHandle = nil
		LH.SetTweenScale(self.ts,0,0.2,Vector3.one,Vector3.zero)
		local onScaleFinish = function ()
			self:Reset()
			if(callback ~= nil) then
				callback(self)
			end
		end
		self.TimeHandle = LH.UseVP(0.2, 1, 0 ,onScaleFinish,nil)
	end
	self.TimeHandle = LH.UseVP(time, 1, 0 ,onFinish,nil)
end

function UnitSay:Reset()
	if(self.moveHelper ~= nil) then
		self.moveHelper:Clear()
	end
end

function UnitSay:Dispose()
	self:Reset()
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end