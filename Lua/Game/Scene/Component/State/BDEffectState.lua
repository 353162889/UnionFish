
require 'Game/Scene/Component/State/BaseState'

BDEffectState = Class(BaseState)

function BDEffectState:ctor()
	self.id = nil
	self.listTime = {}
	self.listEffectId = {}
end
--初始化
function BDEffectState:Init(unit,id,...)
	BDEffectState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function BDEffectState:OnUpdate(...)

end

function BDEffectState:OnInit()
	-- body
	self:PlayEffect()
end

--进入当前状态
function BDEffectState:OnEnter()
	LogColor("#ff0000","BDEffectState:OnEnter",self.id)
	self:PlayEffect()
end

--退出当前状态
function BDEffectState:OnExit()
	LogColor("#ff0000","BDEffectState:OnExit",self.id)
	self:Clear()
end

--销毁状态
function BDEffectState:OnDispose()
	self:Clear()
	BDEffectState.superclass.OnDispose(self)
end

function BDEffectState:PlayEffect()
	if(self.cfg.param.Effect ~= nil)then
		local listEffect = self.cfg.param.Effect
		for k,v in pairs(listEffect) do
			if(v.delay ~= nil and v.delay > 0) then
				local OnDelay = function (lt)
					self:PlayOneEffect(v)
				end
				local timer = LH.UseVP(v.delay, 1, 0 ,OnDelay,{})
				table.insert(self.listTime,timer)
			else
				self:PlayOneEffect(v)
			end
		end
	end
end

function BDEffectState:PlayOneEffect(effectInfo)
	if(effectInfo.id ~= nil) then
		if(self.unit.tableName ~= nil and self.unit.tableName == "UnitGun" and self.unit:IsMe())then
			EventMgr.SendEvent(ED.HelpView_AddBDEffect,effectInfo.id)
			table.insert(self.listEffectId,effectInfo.id)
		end
	end
end

function BDEffectState:Clear()
	for k,v in pairs(self.listTime) do
		v:Cancel()
	end
	self.listTime = {}
	for k,v in pairs(self.listEffectId) do
		--移除BD
		EventMgr.SendEvent(ED.HelpView_RemoveBDEffectInID,v)
	end
	self.listEffectId = {}
end