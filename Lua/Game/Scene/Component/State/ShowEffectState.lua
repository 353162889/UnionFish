require 'Game/Scene/Component/State/BaseState'

--显示特效，跟状态没关系
ShowEffectState = Class(BaseState)

--初始化
function ShowEffectState:Init(unit,id,...)
	ShowEffectState.superclass.Init(self,unit,id,...)
	self.DicEffectTarget = {
		[1] = self.ShowSceneEffect,
	}
end

function ShowEffectState:ShowSceneEffect(effectInfo)
	if(self.unit.tableName ~= nil and self.unit.tableName == "UnitFish")then
		local pos = self.unit.gameObject.transform.position
		if(effectInfo.time <= 0) then
			LogColor("#ff0000","特效的持续时间小于0，特效将持续到退出渔场,stateId:",self.id,"effectId",effectInfo.id)
		end
		FishSceneEffectMgr.ShowSceneEffect(effectInfo.id,pos,effectInfo.time,effectInfo.delay)
	end
end

--更新当前状态数据
function ShowEffectState:OnUpdate(...)
end

function ShowEffectState:OnInit()
end

--进入当前状态
function ShowEffectState:OnEnter()
	LogColor("#ff0000","ShowEffectState:OnEnter")
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,tonumber(self.cfg.param[BulletExtParam.SpeedRate]))
	local listEffect = self.cfg.param.ShowEffect
	if(listEffect ~= nil) then
		for k,v in pairs(listEffect) do
			local target = tonumber(v.target)
			if(self.DicEffectTarget[target] ~= nil) then
				self.DicEffectTarget[target](self,v)
			else
				LogError("[EffectState:PlayOneEffect]can not find target:"..target)
			end
		end
	end
end

--退出当前状态
function ShowEffectState:OnExit()
	LogColor("#ff0000","ShowEffectState:OnExit")
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,nil)
end

--销毁状态
function ShowEffectState:OnDispose()
	self.cfg = nil
	ShowEffectState.superclass.OnDispose(self)
end