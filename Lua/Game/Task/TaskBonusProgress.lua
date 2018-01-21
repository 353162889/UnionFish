
TaskBonusProgress = {}
function TaskBonusProgress:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TaskBonusProgress:Init()
	local progrossGO = Find(self.gameObject,"Progress")
	self.Progress = UIProgress:New(progrossGO,UIProgressMode.Horizontal)
	self.Progress:UpdateProgress(0)

	self.ListBonusItem = {}

	self.ListBonusCfg = SortRes.Task_Score
	for i=1,#self.ListBonusCfg do
		local itemGO = Find(self.gameObject,"Items/Item_"..i)
		Find(itemGO,"Label"):GetComponent("UILabel").text = tonumber(self.ListBonusCfg[i].task_count)
		local onClick = function (go)
			LogColor("#ff0000","onClick",i)
			self:GetBonus(i)
		end
		LH.AddClickEvent(Find(itemGO,"Bg"),onClick)
		table.insert(self.ListBonusItem,itemGO)
	end
	self.DicEffect = {}

end

function TaskBonusProgress:Update()
	local score = TaskCtrl.mode.TaskInfos.day_score
	local totalScore = self.ListBonusCfg[#self.ListBonusCfg].task_count
	local progress = score / totalScore
	self.Progress:UpdateProgress(progress)
	for i=1,#self.ListBonusCfg do
		local lock = self:HasGetBonus(i)
		local showEffect = self:CanGetBonus(i)
		self:UpdateItem(self.ListBonusItem[i],i,lock,showEffect)
	end
	
end

function TaskBonusProgress:AfterOpenView()

end

function TaskBonusProgress:BeforeCloseView()
	for k,v in pairs(self.DicEffect) do
		if(v ~= nil) then
			UnitEffectMgr.DisposeEffect(v)
		end
	end
	self.DicEffect = {}
end

function TaskBonusProgress:GetBonus(index)
	if(not self:CanGetBonus(index))then return end
	local score = self.ListBonusCfg[index].task_count
	--判断是否已领取物品
	TaskCtrl.C2STaskAcceptPrizeByScore(score)
end

function TaskBonusProgress:CanGetBonus(index)
	--如果达到分数并且没有领取奖励
	if(self:MeetScore(index) and not self:HasGetBonus(index)) then
		return true
	end
	return false
end

function TaskBonusProgress:HasGetBonus(index)
	local cfg = self.ListBonusCfg[index]
	if(cfg == nil) then return false end
	return TaskCtrl.HasGetBonus(cfg.task_count)
end

function TaskBonusProgress:MeetScore(index)
	local cfg = self.ListBonusCfg[index]
	if(cfg == nil) then return false end
	local score = TaskCtrl.mode.TaskInfos.day_score
	return score >= cfg.task_count
end

function TaskBonusProgress:UpdateItem(item,index,lock,showEffect)
	Find(item,"Lock"):SetActive(lock)
	Find(item,"Icon"):GetComponent("TweenScale").enabled = showEffect
	if(showEffect) then
		if(self.DicEffect[index] == nil) then
			local effectGo = Find(item,"Effect")
			local queue = GetParentPanelRenderQueue(effectGo)
			local effect = UnitEffectMgr.ShowUIEffectInParent(effectGo,54013,Vector3.zero,true,queue + 10)
			self.DicEffect[index] = effect
		end
	else
		if(self.DicEffect[index] ~= nil) then
			UnitEffectMgr.DisposeEffect(self.DicEffect[index])
			self.DicEffect[index] = nil
		end
	end

end

function TaskBonusProgress:Dispose()
	-- body
end