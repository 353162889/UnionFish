require 'Game/Scene/Component/State/BaseState'

ForbidSkillState = Class(BaseState)

--初始化
function ForbidSkillState:Init(unit,id,...)
	ForbidSkillState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function ForbidSkillState:OnUpdate(...)
end

function ForbidSkillState:OnInit()
	-- body
	SkillCtrl.ForbidSkill()
end


--进入当前状态
function ForbidSkillState:OnEnter()
	LogColor("#ff0000","ForbidSkillState:OnEnter")
	SkillCtrl.ForbidSkill()
end

--退出当前状态
function ForbidSkillState:OnExit()
	LogColor("#ff0000","ForbidSkillState:OnExit")
	SkillCtrl.ResumeSkill()
end

--销毁状态
function ForbidSkillState:OnDispose()
	self:OnExit()
	ForbidSkillState.superclass.OnDispose(self)
end