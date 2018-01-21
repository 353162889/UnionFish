require 'Game/Scene/Component/State/BaseState'

OutBreakState = Class(BaseState)

--初始化
function OutBreakState:Init(unit,id,...)
	OutBreakState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function OutBreakState:OnUpdate(...)

end

function OutBreakState:OnInit()
	if(self.unit:IsMe()) then
		EventMgr.SendEvent(ED.HelpView_AddBDEffect,6)
	end
	self.unit:PlayOutBreakAnim(true)
end

--进入当前状态
function OutBreakState:OnEnter()
	if(self.unit:IsMe()) then
		EventMgr.SendEvent(ED.HelpView_AddBDEffect,6)
	end
	self.unit:PlayOutBreakAnim(true)
	LogColor("#ff0000","OnEnter","self.unit.roleData.role_obj_id",self.unit.roleData.role_obj_id)
end

--退出当前状态
function OutBreakState:OnExit()
	if(self.unit:IsMe()) then
		EventMgr.SendEvent(ED.HelpView_RemoveBDEffectInLv,3)
	end
	self.unit:PlayOutBreakAnim(false)
	LogColor("#ff0000","OnExit","self.unit.roleData.role_obj_id",self.unit.roleData.role_obj_id)
end

--销毁状态
function OutBreakState:OnDispose()
	self:OnExit()
	OutBreakState.superclass.OnDispose(self)
end
