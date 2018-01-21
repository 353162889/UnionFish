require 'Game/Clock/ClockEvent'
ClockCtrl = CustomEvent()
local this = ClockCtrl


function this.Init()
	local onSecond = function ()
		this.SendEvent(ClockEvent.OnSecond)
	end
	if(this.TimerHandle ~= nil) then
		this.TimerHandle:Cancel()
		this.TimerHandle = nil
	end
	this.TimerHandle = LH.UseVP(0.1, 0, 1,onSecond,nil)

end

function this.ResetData()
	
end