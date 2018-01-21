require 'Game/Scene/Component/State/BaseState'
require 'Game/Scene/Component/State/OutBreakState'
require 'Game/Scene/Component/State/AccSpeedState'
require 'Game/Scene/Component/State/WeakState'
require 'Game/Scene/Component/State/FrozenState'
require 'Game/Scene/Component/State/EffectState'
require 'Game/Scene/Component/State/ShockBulletState'
require 'Game/Scene/Component/State/ForbidSkillState'
require 'Game/Scene/Component/State/FishComeState'
require 'Game/Scene/Component/State/BDEffectState'
require 'Game/Scene/Component/State/RandomRateState'
require 'Game/Scene/Component/State/BonusPoolFishState'
require 'Game/Scene/Component/State/FishDieState'
require 'Game/Scene/Component/State/ShowEffectState'
require 'Game/Scene/Component/State/InvincibleState'
require 'Game/Scene/Component/State/ShakeCameraState'
StateComponent = {}

StateComponent.StateType = {}
StateComponent.StateType.Invincible = 18

StateComponent.Handles = {
	[0] = BaseState,
	[2] = AccSpeedState,
	[3] = WeakState,
	[4] = FrozenState,
	[6] = ShockBulletState,
	[9] = OutBreakState,
	[10] = EffectState,
	[11] = BDEffectState,
	[12] = ForbidSkillState,
	[13] = FishComeState,
	[14] = RandomRateState,
	[15] = BonusPoolFishState,
	[16] = FishDieState,
	[17] = ShowEffectState,
	[18] = InvincibleState,
	[19] = ShakeCameraState,
}

StateComponent.ClearTimeEnum = {
	FishDead = 1
}

StateComponent.TriggerTimeEnum = {
	FishDead = 1
}

function StateComponent:New(unit)
	local o = {states = {},unit = unit}
	setmetatable(o,self)
	self.__index = self
	return o
end

function StateComponent:InitState(id,...)
	local statusType = Res.status[id].type
	local class = StateComponent.Handles[statusType]
	if(class ~= nil) then
		local newState = class.new()
		newState:Init(self.unit,id,...)
		self.states[id] = newState
		newState:OnInit()
	else
		LogError("[InitState]can not find stateHandleType",statusType,"id",id)
	end
end

function StateComponent:UpdateState(id,...)
	if(self.states[id] ~= nil) then
		local state = self.states[id]
		state:OnUpdate(...)
	else
		local statusType = Res.status[id].type
		local class = StateComponent.Handles[statusType]
		if(class ~= nil) then
			local newState = class.new()
			newState:Init(self.unit,id,...)
			self.states[id] = newState
			newState:OnEnter()
		else
			LogError("[UpdateState]can not find stateHandleType",statusType,"id",id)
		end
	end
end

function StateComponent:RemoveState(id)
	if(self.states[id] ~= nil) then
		local state = self.states[id]
		self.states[id] = nil
		state:OnExit()
		state:OnDispose()
	else
		LogColor("#ff0000","[RemoveState]can not find state id:"..id)
	end
end

function StateComponent:HasState(id)
	return self.states[id] ~= nil
end

function StateComponent:HasStateType(type)
	for k,v in pairs(self.states) do
		if(v ~= nil) then
			if(v.cfg.type == type) then
				return true
			end
		end
	end
	return false
end

function StateComponent:Reset()
	for k,v in pairs(self.states) do
		if(v ~= nil) then
			v:OnDispose()
		end
	end
	self.states = {}
end

function StateComponent:Clear()
	self:Reset()
	self.unit = nil
end

function StateComponent:OnTriggerTime(triggerTime)
	for k,v in pairs(self.states) do
		if(v ~= nil) then
			v:OnTriggerTime(triggerTime)
		end
	end
end

function StateComponent:ClearByTime(clearTime)
	local list = {}
	for k,v in pairs(self.states) do
		if(v ~= nil) then
			if(v.cfg.clearTime == clearTime) then
				table.insert(list,k)
			end
		end
	end
	for i=1,#list do
		self:RemoveState(list[i])
	end
end