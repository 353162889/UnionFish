require 'Game/Scene/Component/State/BaseState'

AccSpeedState = Class(BaseState)

--初始化
function AccSpeedState:Init(unit,id,...)
	AccSpeedState.superclass.Init(self,unit,id,...)

end

--更新当前状态数据
function AccSpeedState:OnUpdate(...)
end

function AccSpeedState:OnInit()
	if(self.cfg.param.AttackSpeedRate ~= nil) then
		local rate = tonumber(self.cfg.param.AttackSpeedRate)
		self.unit:ChangeAttackSpeedRate(rate)
	end
end

--进入当前状态
function AccSpeedState:OnEnter()
	LogColor("#ff0000","AccSpeedState:OnEnter")
	if(self.cfg.param.AttackSpeedRate ~= nil) then
		local rate = tonumber(self.cfg.param.AttackSpeedRate)
		self.unit:ChangeAttackSpeedRate(rate)
	end
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,tonumber(self.cfg.param[BulletExtParam.SpeedRate]))
end

--退出当前状态
function AccSpeedState:OnExit()
	LogColor("#ff0000","AccSpeedState:OnExit")
	self.unit:ChangeAttackSpeedRate(1)
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,nil)
end

--销毁状态
function AccSpeedState:OnDispose()
	self.cfg = nil
	AccSpeedState.superclass.OnDispose(self)
end
