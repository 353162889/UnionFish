require 'Game/Scene/Component/State/BaseState'

FishComeState = Class(BaseState)

--初始化
function FishComeState:Init(unit,id,...)
	FishComeState.superclass.Init(self,unit,id,...)
	self.stateInfo = select(1, ...)
end

--更新当前状态数据
function FishComeState:OnUpdate(...)
	self.stateInfo = select(1, ...)
end

function FishComeState:OnInit()
	--boss战斗声音
	PlaySound(AudioDefine.BossFight)
end

--进入当前状态
function FishComeState:OnEnter()
	LogColor("#ff0000","FishComeState:OnEnter")
	if(self.cfg.param.FishType ~= nil) then
		local fishType = tonumber(self.cfg.param.FishType)
		
		local OnDelay = function (lt)
			--boss战斗声音
			PlaySound(AudioDefine.BossFight)
		end
		--boss需要拿到boss的id
		local fishID = nil
		if(fishType == 1) then
			fishID = self.stateInfo.p1
			if(fishID == nil) then
				LogError("没有收到后端的fishID")
			end
		end
		PlayCtrl.OpenFishComeView(fishType,fishID)
		--boss出现声音
		PlaySound(AudioDefine.BossFishAppear)
		local time = Res.audio[AudioDefine.BossFishAppear].time
		if(time <= 0) then
			time = 2
		end
		self.Timer = LH.UseVP(time, 1, 0 ,OnDelay,{})
	end
end

--退出当前状态
function FishComeState:OnExit()
	LogColor("#ff0000","FishComeState:OnExit")
	PlayCtrl.CloseFishComeView()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	--还原场景的声音
	local sound = Res.scene[LuaSceneMgr.CurSceneId].sound
	if(sound > 0) then
		PlaySound(sound,nil)
	end
end

--销毁状态
function FishComeState:OnDispose()
	PlayCtrl.CloseFishComeView()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	FishComeState.superclass.OnDispose(self)
end