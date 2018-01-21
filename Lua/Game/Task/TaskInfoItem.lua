require 'Game/Task/TaskGoTo'
TaskInfoItem = {}

function TaskInfoItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function TaskInfoItem:Init()
	self.Icon = Find(self.gameObject,"Icon/Pic"):GetComponent("UISprite")
	self.FishIcon = Find(self.gameObject,"Icon/PicFish"):GetComponent("UISprite")
	self.LabelTaskName = Find(self.gameObject,"LabelTaskName"):GetComponent("UILabel")
	self.LabelProgress = Find(self.gameObject,"LabelProgress"):GetComponent("UILabel")
	self.Progress = Find(self.gameObject,"Progress"):GetComponent("UISprite")
	self.Progress.gameObject:SetActive(false)
	self.Progress_Full = Find(self.gameObject,"Progress_Full")
	self.Progress_Full.gameObject:SetActive(false)
	self.LabelScore = Find(self.gameObject,"Score/Label"):GetComponent("UILabel")

	self.BtnGet = Find(self.gameObject,"BtnGet")
	local onClickGet = function (go)
		LH.Play(go,"Play")
		self:FinishTask()
	end
	LH.AddClickEvent(self.BtnGet,onClickGet)
	Find(self.BtnGet,"Label"):GetComponent("UILabel").text = L("领 取")

	self.BtnGo = Find(self.gameObject,"BtnGo")
	local onClickGo = function (go)
		LH.Play(go,"Play")
		self:GoTask()
	end
	LH.AddClickEvent(self.BtnGo,onClickGo)
	Find(self.BtnGo,"Label"):GetComponent("UILabel").text = L("去完成")

	self.SpriteBonus = Find(self.gameObject,"Bonus/SpriteIcon"):GetComponent("UISprite")
	self.LabelBonus = Find(self.gameObject,"Bonus/LabelNum"):GetComponent("UILabel")
	LB(Find(self.gameObject,"Bonus/Label"):GetComponent("UILabel"),"奖励：")
	self.SpriteFinish = Find(self.gameObject,"SpriteFinish")
	self.Mask = Find(self.gameObject,"Mask")
end

function TaskInfoItem:FinishTask()
	if(self.task == nil) then return end
	TaskCtrl.C2STaskAcceptPrize(self.type,self.task.id)
end

function TaskInfoItem:GoTask()
	if(self.task == nil) then return end
	local cfgs = Res["task"..self.type]
	local cfg = cfgs[self.task.id]
	if(not TaskGoTo.GoTo(cfg.goto.type,cfg.goto.param)) then
		LogError("taskId = "..self.task.id.." GoTo error")
	else
		UIMgr.CloseView("TaskView")
	end
end

function TaskInfoItem:Update(type,task)
	self.type = type
	self.task = task

	local finishType = task.finish_type
	if(finishType == 0) then
		self.BtnGo:SetActive(true)
		self.BtnGet:SetActive(false)
		self.SpriteFinish:SetActive(false)
		self.Mask:SetActive(false)
		self.Progress.gameObject:SetActive(true)
		self.Progress_Full.gameObject:SetActive(false)
	elseif(finishType == 1)then
		self.BtnGo:SetActive(false)
		self.BtnGet:SetActive(true)
		self.SpriteFinish:SetActive(false)
		self.Mask:SetActive(false)
		self.Progress.gameObject:SetActive(false)
		self.Progress_Full.gameObject:SetActive(true)
	elseif(finishType == 2) then
		self.BtnGo:SetActive(false)
		self.BtnGet:SetActive(false)
		self.SpriteFinish:SetActive(true)
		self.Mask:SetActive(true)
		self.Progress.gameObject:SetActive(false)
		self.Progress_Full.gameObject:SetActive(true)
	end

	local cfgs = Res["task"..type]
	local cfg = cfgs[task.id]
	if(tonumber(type) == TaskType.Fish) then
		self.Icon.gameObject:SetActive(false)
		self.FishIcon.gameObject:SetActive(true)
		self.FishIcon.spriteName = cfg.icon_name
	else
		self.Icon.gameObject:SetActive(true)
		self.FishIcon.gameObject:SetActive(false)
		self.Icon.spriteName = cfg.icon_name
		self.Icon:MakePixelPerfect()
	end
	
	LB(self.LabelTaskName,"{1}",cfg.desc)
	local bonusIcon = cfg.bonusIcon
	self.LabelProgress.text = L("{1}/{2}",task.progress,cfg.task_count)
	self.Progress.fillAmount = task.progress / cfg.task_count
	if(#cfg.items > 0) then
		local id = cfg.items[1][1]
		local num = cfg.items[1][2]
		self.SpriteBonus.gameObject:SetActive(true)
		self.LabelBonus.gameObject:SetActive(true)
		if(bonusIcon == nil) then
			self.SpriteBonus.spriteName = Res.item[id].icon
		else
			self.SpriteBonus.spriteName = bonusIcon
		end
		self.SpriteBonus:MakePixelPerfect()
		self.LabelBonus.text = L("x{1}",num)
	else
		self.SpriteBonus.gameObject:SetActive(false)
		self.LabelBonus.gameObject:SetActive(false)
	end

	self.LabelScore.text = tostring(cfg.score)

end

function TaskInfoItem:SetActive(active)
	self.gameObject:SetActive(active)
	if(not active) then
		self.type = nil
		self.task = nil
	end
end