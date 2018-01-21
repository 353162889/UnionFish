FishSoundMgr = {}
local this = FishSoundMgr

function this.EnterFishScene()
	-- body
end

function this.ExitFishScene()
	if(this.Timer ~= nil) then
		this.Timer:Cancel()
		this.Timer = nil
	end
	this.curSoundId = nil
end

function this.PlayFishSound(unit)
	local soundId = unit.fishInfo.sound_id
	if(this.curSoundId ~= nil and this.curSoundId == soundId) then return end
	if(this.Timer == nil) then
		local value = Res.misc[1].fish_sound
		local rate = value[1]
		local space = value[2]
		if(math.random(1,10000) < rate) then
			this.curSoundId = soundId
			PlaySoundById(soundId)
			--鱼声音冒泡
			local sayCfg = unit.fishInfo.sound_bubble
			local offset = Vector3.New(sayCfg[1][1],sayCfg[1][2],sayCfg[1][3])
			local txt = sayCfg[2]
			txt = string.gsub(txt,"a","")
			local time = tonumber(sayCfg[3])
			unit:Say(offset,txt,time)
			this.Timer = LH.UseVP(space, 1, 0 ,this.OnTimerEnd,nil)
		end
	end
end

function this.CanPlaySound(soundId)
	
end

function this.OnTimerEnd()
	this.Timer = nil
end
