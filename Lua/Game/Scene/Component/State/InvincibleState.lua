
require 'Game/Scene/Component/State/BaseState'

InvincibleState = Class(BaseState)

--初始化
function InvincibleState:Init(unit,id,...)
	InvincibleState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function InvincibleState:OnUpdate(...)
end

function InvincibleState:OnInit()
	
end

--进入当前状态
function InvincibleState:OnEnter()
	LogColor("#ff0000","InvincibleState:OnEnter")
	
end

--退出当前状态
function InvincibleState:OnExit()
	LogColor("#ff0000","InvincibleState:OnExit")
end

--销毁状态
function InvincibleState:OnDispose()
	InvincibleState.superclass.OnDispose(self)
end