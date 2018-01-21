UnitNum = {}
function UnitNum:New(go)
	local o = {}
	o.id = go:GetInstanceID()
	o.tableName = "UnitNum"
	o.gameObject = go
	o.transform = o.gameObject.transform
	o.label = o.transform:FindChild("Pic"):GetComponent("UILabel")
	o.tp = o.gameObject:GetComponent("TweenPosition")
	o.ts = o.gameObject:GetComponent("TweenScale")
	o.ta = o.gameObject:GetComponent("TweenAlpha")
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitNum:Show(pos,num,color,callback)
	self.transform.position = pos
    self.label.text = tostring(num)
    LH.SetTweenPosition(self.tp,0.2,0.5,self.transform.localPosition,self.transform.localPosition + Vector3.New(0,70,0))
    LH.SetTweenScale(self.ts,0,0.3,Vector3.one*1.5,Vector3.one)
    LH.SetTweenAlpha(self.ta,0.5,0.2,1,0)
    self.label.color = color

    local onFinish = function ()
		self.TimeHandle = nil
		if(callback ~= nil) then
			callback(self)
		end
	end
	self.TimeHandle = LH.UseVP(1.25, 1, 0 ,onFinish,nil)
end

function UnitNum:Dispose()
	if(self.TimeHandle ~= nil) then
		self.TimeHandle:Cancel()
		self.TimeHandle = nil
	end
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end