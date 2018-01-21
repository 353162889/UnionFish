require 'Game/Scene/Component/State/BaseState'

ShockBulletState = Class(BaseState)

--初始化
function ShockBulletState:Init(unit,id,...)
	ShockBulletState.superclass.Init(self,unit,id,...)
	self.stateInfo = select(1, ...)
end

--更新当前状态数据
function ShockBulletState:OnUpdate(...)
	self.stateInfo = select(1,...)
end

function ShockBulletState:OnInit()
	
end

--进入当前状态
function ShockBulletState:OnEnter()
	LogColor("#ff0000","ShockBulletState:OnEnter")
	local list = FishMgr.GetVisiableFish()
	PlaySound(AudioDefine.Skill_6_Explode,nil)
	CameraMgr.ShakeDefault()
	PlayCtrl.C2SSceneAttackMultiFish(self.id,list)
end

--退出当前状态
function ShockBulletState:OnExit()
	LogColor("#ff0000","ShockBulletState:OnExit")
end

--销毁状态
function ShockBulletState:OnDispose()
	ShockBulletState.superclass.OnDispose(self)
end