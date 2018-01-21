require 'Game/Scene/Component/State/BaseState'

ShakeCameraState = Class(BaseState)

--初始化
function ShakeCameraState:Init(unit,id,...)
	ShakeCameraState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function ShakeCameraState:OnUpdate(...)

end

function ShakeCameraState:OnInit()
	--不做处理
end

--进入当前状态
function ShakeCameraState:OnEnter()
	LogColor("#ff0000","ShakeCameraState:OnEnter")
	local delay = self.cfg.param.Delay
	if(delay ~= nil and tonumber(delay) > 0) then
		self.handler = FishSceneTimeMgr.AddTimer(delay,1,0,function (lt)
			self:Shake()
			if(self.handler ~= nil)then
				FishSceneTimeMgr.RemoveTimer(self.handler)
				self.handler = nil
			end
		end,{})
	else
		self:Shake()
	end
end

function ShakeCameraState:Shake()
	if(self.cfg.param.ShakeParam == nil) then
		CameraMgr.ShakeDefault()
	else
		local shakeParam = self.cfg.param.ShakeParam
		CameraMgr.Shake(tonumber(shakeParam[1]),tonumber(shakeParam[2]),tonumber(shakeParam[3]),tonumber(shakeParam[4]),0)
	end
end

--退出当前状态
function ShakeCameraState:OnExit()
	LogColor("#ff0000","ShakeCameraState:OnExit")
	if(self.handler ~= nil)then
		FishSceneTimeMgr.RemoveTimer(self.handler)
		self.handler = nil
	end
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,nil)
end

--销毁状态
function ShakeCameraState:OnDispose()
	LogColor("#ff0000","ShakeCameraState:OnDispose")
	if(self.handler ~= nil)then
		FishSceneTimeMgr.RemoveTimer(self.handler)
		self.handler = nil
	end
	ShakeCameraState.superclass.OnDispose(self)
end