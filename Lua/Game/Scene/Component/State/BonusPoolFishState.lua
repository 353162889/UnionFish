
require 'Game/Scene/Component/State/BaseState'

BonusPoolFishState = Class(BaseState)

--初始化
function BonusPoolFishState:Init(unit,id,...)
	BonusPoolFishState.superclass.Init(self,unit,id,...)
	self.preStateInfo = self.stateInfo
	self.stateInfo = select(1, ...)
	self.listTimesToLevel = {}
	for k,v in pairs(self.cfg.param) do
		table.insert(self.listTimesToLevel,v)
	end
	table.sort(self.listTimesToLevel,function (a,b)
		return a.times < b.times
	end)
end

--更新当前状态数据
function BonusPoolFishState:OnUpdate(...)
	self.preStateInfo = self.stateInfo
	self.stateInfo = select(1, ...)
	LogColor("#ff0000","BonusPoolFishState:times:",self.stateInfo.p2)
	self:UpdateShow()
end

function BonusPoolFishState:OnInit()
	--不做处理
end

--进入当前状态
function BonusPoolFishState:OnEnter()
	LogColor("#ff0000","BonusPoolFishState:OnEnter")
	self:UpdateShow()
end

function BonusPoolFishState:UpdateShow()
	if(self.unit.tableName ~= nil and self.unit.tableName == "UnitFish")then
		local times = self.stateInfo.p2
		local level = nil
		for i=#self.listTimesToLevel,1,-1 do
			if(times >= self.listTimesToLevel[i].times) then
				level = self.listTimesToLevel[i].level
				break
			end
		end
		local level = self:GetLevelInStateInfo(self.stateInfo)
		if(level ~= nil) then
			if(self.preStateInfo == nil) then
				--直接运行level
				LogColor("#ff0000","self.unit:UpdateLevel",level)
				self.unit:UpdateLevel(level)
			else
				local preLevel = self:GetLevelInStateInfo(self.preStateInfo)
				if(preLevel ~= level) then
					if(math.abs(preLevel - level) == 1) then
						if(preLevel > level) then
							self.unit:LevelDown()
						else
							self.unit:LevelUp()
						end
					else
						self.unit:UpdateLevel(level)
					end
				end
			end
		else
			LogError("[BonusPoolFishState]can not find fish status res,times",times)
		end
	end
end

function BonusPoolFishState:GetLevelInStateInfo(stateInfo)
	local times = stateInfo.p2
	local level = nil
	for i=#self.listTimesToLevel,1,-1 do
		if(times >= self.listTimesToLevel[i].times) then
			level = self.listTimesToLevel[i].level
			break
		end
	end
	return level
end

--退出当前状态
function BonusPoolFishState:OnExit()
	LogColor("#ff0000","BonusPoolFishState:OnExit")
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,nil)
end

--销毁状态
function BonusPoolFishState:OnDispose()
	BonusPoolFishState.superclass.OnDispose(self)
end