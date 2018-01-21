BulletExtParam = {}
local this = BulletExtParam
this.SpeedRate = "SpeedRate"

function this.GetValue(extParam,key)
	if(extParam ~= nil) then
		if(type(extParam) == "table") then
			return extParam[key]
		end
		return nil
	end
	return nil
end