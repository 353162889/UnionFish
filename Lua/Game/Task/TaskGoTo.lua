TaskGoTo = {}
local this = TaskGoTo

function this.GoTo(type,param)
	local way = this.DicWay[tonumber(type)]
	if(way == nil) then
		LogError("TaskGoTo type="..type.." not find way")
		return false
	end
	return way(param)
end

function this.OpenView(param)
	if(param == nil or param.name == nil) then 
		LogError("TaskGoTo OpenView param errod")
		return false
	end
	UIMgr.OpenView(param.name,param.ext)
	return true
end

function this.FaskGame(param)
	if(param == nil or param.islandId == nil) then
		LogError("TaskGoTo FaskGame param error")
		return false
	end
	local roomType = 3
	if(GuideCtrl.GuideJoinSigleScene()) then
		roomType = 1
	end
	MainCtrl.C2SRoomEnterRoom(param.islandId,roomType)
	return true
end

function this.FunctionNotOpen(param)
	HelpCtrl.Msg(L("功能尚未开启！"))
	return true
end

this.DicWay = {
	[1] = this.OpenView,
	[2] = this.FaskGame,
	[3] = this.FunctionNotOpen,
}