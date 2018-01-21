FishSceneTimeMgr = {}
local this = FishSceneTimeMgr
this.listTime = nil
this.id = 0

function this.EnterFishScene()
	this.id = 0
	this.listTime = {}
end

function this.ExitFishScene()
	this.id = 0
	for k,v in pairs(this.listTime) do
		if(v.handler ~= nil) then
			v.handler:Cancel()
			v.handler = nil
		end
	end
	this.listTime = {}
end

function this.AddTimer(delay,times,t,callback,callbackTable)
	local handler = LH.UseVP(delay,times,t,callback,callbackTable)
	local result = {id = this.id,handler = handler}
	table.insert(this.listTime,result)
	this.id = this.id + 1
	return result
end

function this.RemoveTimer(timeHandler)
	if(timeHandler ~= nil) then
		for i=#this.listTime,1,-1 do
			if(this.listTime[i].id == timeHandler.id) then
				if(this.listTime[i].handler ~= nil) then
					this.listTime[i].handler:Cancel()
					this.listTime[i].handler = nil
				end
				table.remove(this.listTime,i)
				break
			end
		end
	end
end