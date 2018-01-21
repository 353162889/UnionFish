require 'Game/Scene/Component/State/BaseState'

FrozenState = Class(BaseState)

--初始化
function FrozenState:Init(unit,id,...)
	FrozenState.superclass.Init(self,unit,id,...)
	self.stateInfo = select(1, ...)
end

--更新当前状态数据
function FrozenState:OnUpdate(...)
	self.stateInfo = select(1,...)
end

function FrozenState:OnInit()
	-- body
	if(self.unit ~= nil and self.unit.tableName == "UnitFish") then
		self.unit:BeFrozen()
	end
end

--进入当前状态
function FrozenState:OnEnter()
	if(self.unit ~= nil and self.unit.tableName == "UnitFish") then
		self.unit:BeFrozen()
	end
	--self:PlayUIEffect()
end

--退出当前状态
function FrozenState:OnExit()
	if(self.unit ~= nil and self.unit.tableName == "UnitFish") then
		self.unit:UnBeFrozen(self.stateInfo.end_time)
	end
end

--销毁状态
function FrozenState:OnDispose()
	self:OnExit()
	FrozenState.superclass.OnDispose(self)
end
