require 'Game/Scene/Component/State/BaseState'

FishDieState = Class(BaseState)

--初始化
function FishDieState:Init(unit,id,...)
	FishDieState.superclass.Init(self,unit,id,...)
end

--更新当前状态数据
function FishDieState:OnUpdate(...)

end

function FishDieState:OnInit()
	--不做处理
end

--进入当前状态
function FishDieState:OnEnter()
	LogColor("#ff0000","FishDieState:OnEnter")
	local fishType = self.cfg.param.FishType
	local distance = self.cfg.param.Distance
	local listFishId = {}
	local curPos = self.unit.gameObject.transform.position
	if(distance == nil) then
		local listFish = FishMgr.GetVisiableFish()
		for i=1,#listFish do
			table.insert(listFishId,listFish[i])
		end
	else
		local tempListFish = FishMgr.GetVisiableFish()
		for i=1,#tempListFish do
			local fish = FishMgr.GetFish(tempListFish[i])
			if(fish ~= nil) then
				local tempPos = fish.gameObject.transform.position
				local dis = Vector3.Distance(curPos,tempPos)
				if(dis < distance) then
					table.insert(listFishId,tempListFish[i])
				end
			end
		end
	end
	local delay = self.cfg.param.Delay
	if(delay ~= nil and tonumber(delay) > 0) then
		self.handler = FishSceneTimeMgr.AddTimer(delay,1,0,function (lt)
			PlayCtrl.C2SSceneFunctionFish(fishType,listFishId,curPos)
			if(self.handler ~= nil)then
				FishSceneTimeMgr.RemoveTimer(self.handler)
				self.handler = nil
			end
		end,{})
	else
		PlayCtrl.C2SSceneFunctionFish(fishType,listFishId,curPos)
	end
	
end

--退出当前状态
function FishDieState:OnExit()
	LogColor("#ff0000","FishDieState:OnExit")
	--self.unit:SetBulletExtParam(BulletExtParam.SpeedRate,nil)
end

--销毁状态
function FishDieState:OnDispose()
	FishDieState.superclass.OnDispose(self)
end