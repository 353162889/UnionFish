require 'Game/Scene/Component/State/BaseState'
require 'Game/Play/RandomRateCell'

RandomRateState = Class(BaseState)

--初始化
function RandomRateState:Init(unit,id,...)
	RandomRateState.superclass.Init(self,unit,id,...)
	self.stateInfo = select(1, ...)
end

--更新当前状态数据
function RandomRateState:OnUpdate(...)
	self.stateInfo = select(1, ...)
	self:UpdateShow()
end

function RandomRateState:OnInit()
	if(self.cell == nil)then
		local parent = UIMgr.Dic("HelpBottomView").UIBox
		self.cell = RandomRateCell:New()
		local offset = Vector3.New(self.cfg.param.offsetX,self.cfg.param.offsetY,self.cfg.param.offsetZ)
		local mountPoint = self.unit:GetMountPoint(UnitFishMPType.Center)
		self.cell:Init(parent,Vector3.zero,mountPoint,offset)
		self:UpdateShow()
	end
end

--进入当前状态
function RandomRateState:OnEnter()
	if(self.cell == nil)then
		local parent = UIMgr.Dic("HelpBottomView").UIBox
		self.cell = RandomRateCell:New()
		local offset = Vector3.New(self.cfg.param.offsetX,self.cfg.param.offsetY,self.cfg.param.offsetZ)
		local mountPoint = self.unit:GetMountPoint(UnitFishMPType.Center)
		self.cell:Init(parent,Vector3.zero,mountPoint,offset)
		self:UpdateShow()
	end
	--LogColor("#ff0000","RandomRateState:OnEnter")
	
end

function RandomRateState:UpdateShow()
	if(self.stateInfo ~= nil) then
		local rate = self.stateInfo.p1
		self.cell:UpdateRate(rate)
	end
end

function RandomRateState:OnTriggerTime(triggerTime)
	if(triggerTime == StateComponent.TriggerTimeEnum.FishDead) then
		self.cell:ShowAnim()
	end
end

--退出当前状态
function RandomRateState:OnExit()
	self:Clear()
	--LogColor("#ff0000","RandomRateState:OnExit")
end

function RandomRateState:Clear()
	if(self.cell ~= nil)then
		self.cell:Dispose()
		self.cell = nil
	end
end

--销毁状态
function RandomRateState:OnDispose()
	self:Clear()
	RandomRateState.superclass.OnDispose(self)
end