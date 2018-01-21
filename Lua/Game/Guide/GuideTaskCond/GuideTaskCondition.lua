GuideTaskCondition = {}
local this = GuideTaskCondition

function this.IsCondition(type,param)
	local way = this.DicWay[tonumber(type)]
	if(way == nil) then
		LogError("GuideIsCondition type="..type.." not find way")
		return false
	end
	return way(param)
end

function this.GunRateUnlock(param)
	if(param == nil or param.rate == nil) then 
		LogError("TaskGoTo GunRateUnlock param error")
		return true
	end
	local rate = param.rate
	LogColor("#ff0000","GunRateUnlock",LoginCtrl.mode.S2CEnterGame.battery_rate,rate)
	return LoginCtrl.mode.S2CEnterGame.battery_rate >= rate
end

this.DicWay = {
	[1] = this.GunRateUnlock,
}