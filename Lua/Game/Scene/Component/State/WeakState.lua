require 'Game/Scene/Component/State/BaseState'

WeakState = Class(BaseState)

--初始化
function WeakState:Init(unit,id,...)
	WeakState.superclass.Init(self,unit,id,...)
	self.stateInfo = select(1, ...)
end

--更新当前状态数据
function WeakState:OnUpdate(...)
	self.stateInfo = select(1,...)
end

function WeakState:OnInit()
	if(self.stateInfo.p1 ~= nil) then
		self.unit:SetAnimSpeed(self.stateInfo.p1 * 0.01)
	end
end

--进入当前状态
function WeakState:OnEnter()
	--LogColor("#ff0000","WeakState:OnEnter")
	if(self.stateInfo.p1 ~= nil) then
		self.unit:SetAnimSpeed(self.stateInfo.p1 * 0.01)
	end
end

--退出当前状态
function WeakState:OnExit()
	self.unit:SetAnimSpeed(1)
	--LogColor("#ff0000","WeakState:OnExit")
end

--销毁状态
function WeakState:OnDispose()
	WeakState.superclass.OnDispose(self)
end