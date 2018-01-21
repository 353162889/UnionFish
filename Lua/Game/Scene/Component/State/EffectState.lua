EffectState = Class(BaseState)

function EffectState:ctor()
	self.id = nil
	self.listTime = {}
	self.listEffect = {}
end

--初始化
function EffectState:Init(unit,id,...)
	EffectState.superclass.Init(self,unit,id,...)
	self.DicEffectTarget = {
		[1] = self.ShowMainPlayUIEffect,
		[2] = self.ShowFishEffect,
		[3] = self.ShowGunEffect,
		[4] = self.ShowUIEffect,
		[5] = self.ShowUIFollowFishEffect,
		[6] = self.ShowFishUIEffect
	}
end

function EffectState:ShowFishUIEffect( effectInfo )
	if(self.unit.tableName ~= nil and self.unit.tableName == "UnitFish")then
		local mountPoint = self.unit:GetMountPoint(UnitFishMPType.Center)
		local pos = LH.WorldPosToUIPos(mountPoint.transform.position)
		local parent = UIMgr.Dic("HelpBottomView").FishSceneEffectParent
		local panel = GetParentPanel(parent)
		local effect = UnitEffectMgr.ShowUIEffectInParent(parent,tonumber(effectInfo.id),pos,false,panel.startingRenderQueue + 10)
		table.insert(self.listEffect,effect)
	end
end

function EffectState:ShowUIFollowFishEffect(effectInfo)
	if(self.unit.tableName ~= nil and self.unit.tableName == "UnitFish")then
		local parent = UIMgr.Dic("HelpBottomView").FishSceneEffectParent
		local panel = GetParentPanel(parent)
		local effect = UnitEffectMgr.ShowUIEffectInParent(parent,tonumber(effectInfo.id),Vector3.zero,true,panel.startingRenderQueue + 50)
		local helper = effect.gameObject:AddComponent(typeof(UIFollowGOHelper))
		local mountPoint = self.unit:GetMountPoint(UnitFishMPType.Center)
		helper:SetTarget(mountPoint)
		table.insert(self.listEffect,effect)
	end
end

function EffectState:ShowMainPlayUIEffect( effectInfo )
	if(self.unit.tableName ~= nil and self.unit.tableName == "UnitGun" and self.unit:IsMe())then
		local parent = UIMgr.Dic("HelpView").EffectBox
		local panel = GetParentPanel(parent)
		local effect = UnitEffectMgr.ShowUIEffectInParent(parent,tonumber(effectInfo.id),Vector3.zero,true,panel.startingRenderQueue + 100)
		table.insert(self.listEffect,effect)
	end
end

function EffectState:ShowUIEffect(effectInfo)
	local parent = UIMgr.Dic("HelpBottomView").FishSceneEffectParent
	local panel = GetParentPanel(parent)
	local effect = UnitEffectMgr.ShowUIEffectInParent(parent,tonumber(effectInfo.id),Vector3.zero,true,panel.startingRenderQueue + 100)
	table.insert(self.listEffect,effect)
end

function EffectState:ShowFishEffect(effectInfo)
	local layer
	if(self.unit.isCamera == 1) then
		layer = LayerMask.NameToLayer("CameraFish")
	else
		layer = LayerMask.NameToLayer("Fish")
	end
	local mountPoint = self.unit:GetMountPoint(UnitFishMPType.Center)
	local effect = UnitEffectMgr.ShowUIEffectInParent(mountPoint,tonumber(effectInfo.id),Vector3.zero,true,nil)
	local scale = Vector3.one
	if(Res.effect[effectInfo.id].scale ~= 0) then
		scale = GetVector3(self.unit.fishInfo.ee_s)
	end
	local pos = GetVector3(self.unit.fishInfo.ee_p)
	effect.gameObject.transform.localPosition = pos
	effect.gameObject.transform.localScale = scale
	effect:UpdateLayer(layer)
	table.insert(self.listEffect,effect)
end

function EffectState:ShowGunEffect(effectInfo)
	local parent = self.unit.effectContainer
	if(parent ~= nil) then
		local panel = GetParentPanel(parent)
		local queue = 0
		if(effectInfo.offsetQueue ~= nil) then
			queue = tonumber(effectInfo.offsetQueue)
		end
		local effect = UnitEffectMgr.ShowUIEffectInParent(parent.gameObject,tonumber(effectInfo.id),Vector3.zero,true,panel.startingRenderQueue + queue)
		table.insert(self.listEffect,effect)
	end 
end

--更新当前状态数据
function EffectState:OnUpdate(...)

end

function EffectState:OnInit()
	-- body
	self:PlayEffect()
end

--进入当前状态
function EffectState:OnEnter()
	--LogColor("#ff0000","EffectState:OnEnter",self.id)
	self:PlayEffect()
end

--退出当前状态
function EffectState:OnExit()
	--LogColor("#ff0000","EffectState:OnExit",self.id)
	self:Clear()
end

--销毁状态
function EffectState:OnDispose()
	--LogColor("#ff0000","OnDispose")
	self:Clear()
end

function EffectState:PlayEffect()
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

function EffectState:PlayOneEffect(effectInfo)
	if(effectInfo.target ~= nil) then
		local target = tonumber(effectInfo.target)
		if(self.DicEffectTarget[target] ~= nil) then
			self.DicEffectTarget[target](self,effectInfo)
		else
			LogError("[EffectState:PlayOneEffect]can not find target:"..target)
		end
	end
end

function EffectState:Clear()
	for k,v in pairs(self.listTime) do
		v:Cancel()
	end
	self.listTime = {}
	for k,v in pairs(self.listEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	self.listEffect = {}
end