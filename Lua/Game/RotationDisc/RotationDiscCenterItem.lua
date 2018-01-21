require 'Game/RotationDisc/RotationDiscDiscItem'
RotationDiscCenterItem = {}

function RotationDiscCenterItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RotationDiscCenterItem:Init()
	self.Point_Left = Find(self.gameObject,"Point_Left")
	self.Point_Right = Find(self.gameObject,"Point_Right")
	self.PointLeftHelper = self.Point_Left:AddComponent(typeof(RDPointHelper))
	self.PointRightHelper = self.Point_Right:AddComponent(typeof(RDPointHelper))
	self.PointLeftHelper:SetVisiable(false)
	self.PointRightHelper:SetVisiable(false)

	self.ShowMaskGO = Find(self.gameObject,"ShowMask")
	self:ShowMask(false)

	self.SelectGO = Find(self.gameObject,"SelectIcon")
	self:ShowSelectIcon(false)

	self.Arrow = Find(self.gameObject,"Arrow")
	self.ArrowHelper = self.Arrow:AddComponent(typeof(RDArrowHelper))
	self.ListDisc = {}
	for i=1,4 do
		local go = Find(self.gameObject,"Discs/Disc_"..i)
		local item = RotationDiscDiscItem:New(go)
		item:Init(i,self)
		self.ListDisc[i] = item
	end

	self.EffectContainer = Find(self.gameObject,"Effect")
	self.EffectStart = Find(self.gameObject,"Effect/EffectStart")
	self.EffectEnd	 = Find(self.gameObject,"Effect/EffectEnd")

	self.onLottoryTabChange = function (index)
		self:Update(index)
	end
	RotationDiscCtrl.AddEvent(RotationDiscEvent.OnLottoryTabChange,self.onLottoryTabChange)
end

function RotationDiscCenterItem:ShowMask(isShow)
	self.ShowMaskGO.gameObject:SetActive(isShow)
end

function RotationDiscCenterItem:ShowSelectIcon(isShow)
	self.SelectGO.gameObject:SetActive(isShow)
end

function RotationDiscCenterItem:AfterOpenView()
end
function RotationDiscCenterItem:BeforeCloseView()
	RotationDiscCtrl.CancelDelayRefreshLuck()	--不延时刷新幸运值
	if(self.FlyEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.FlyEffect)
		self.FlyEffect = nil
	end
	if(self.ShineEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.ShineEffect)
		self.ShineEffect = nil
	end
	self.EffectCallback = nil
end

--增加幸运值的飞入特效
function RotationDiscCenterItem:ShowIncreaseEffect(time,callback)
	self.EffectCallback = callback
	local queue = GetParentPanelRenderQueue(self.EffectContainer)
	if(self.FlyEffect == nil) then
		self.FlyEffect = UnitEffectMgr.ShowUIEffectInParent(self.EffectContainer,24013,self.EffectStart.transform.localPosition,true,queue + 10,nil)
	end
	self.FlyEffect:Hide()
	self.FlyEffect:Show(self.EffectContainer,self.EffectStart.transform.localPosition,true,nil)
	local helper = self.FlyEffect.gameObject:GetComponent("TargetMoveHelper")
	if(helper == nil) then
		helper = self.FlyEffect.gameObject:AddComponent(typeof(TargetMoveHelper))
	end
	local showEffectFinish = function (lt)
		self:OnShowIncreaseEffectFinish(lt)
	end
	helper:SetTarget(self.EffectEnd.transform.position,time,0,showEffectFinish,nil)
end

function RotationDiscCenterItem:OnShowIncreaseEffectFinish(lt)
	if(self.FlyEffect ~= nil) then
		self.FlyEffect:Hide()
	end
	if(self.ShineEffect == nil) then
		local queue = GetParentPanelRenderQueue(self.EffectContainer)
		self.ShineEffect = UnitEffectMgr.ShowUIEffectInParent(self.EffectContainer,23001,self.EffectEnd.transform.localPosition,true,queue + 10,nil)
	end
	self.ShineEffect:Hide()
	self.ShineEffect:Show(self.EffectContainer,self.EffectEnd.transform.localPosition,true,nil)
	if(self.EffectCallback ~= nil) then
		local temp = self.EffectCallback
		self.EffectCallback = nil
		temp()
	end
	--显示完特效，刷新幸运值
	RotationDiscCtrl.SendEvent(RotationDiscEvent.RefreshLuck)
end

--减少幸运值的特效
function RotationDiscCenterItem:ShowDecreaseEffect(time,callback)
	self.EffectCallback = callback
	local queue = GetParentPanelRenderQueue(self.EffectContainer)
	if(self.FlyEffect == nil) then
		self.FlyEffect = UnitEffectMgr.ShowUIEffectInParent(self.EffectContainer,24013,self.EffectEnd.transform.localPosition,true,queue + 10,nil)
	end
	self.FlyEffect:Hide()
	self.FlyEffect:Show(self.EffectContainer,self.EffectEnd.transform.localPosition,true,nil)
	local helper = self.FlyEffect.gameObject:GetComponent("TargetMoveHelper")
	if(helper == nil) then
		helper = self.FlyEffect.gameObject:AddComponent(typeof(TargetMoveHelper))
	end
	local showEffectFinish = function (lt)
		self:showDecreaseEffectFinish(lt)
	end
	helper:SetTarget(self.EffectStart.transform.position,time,0,showEffectFinish,nil)
end

function RotationDiscCenterItem:showDecreaseEffectFinish(lt)
	if(self.FlyEffect ~= nil) then
		self.FlyEffect:Hide()
	end
	if(self.ShineEffect == nil) then
		local queue = GetParentPanelRenderQueue(self.EffectContainer)
		self.ShineEffect = UnitEffectMgr.ShowUIEffectInParent(self.EffectContainer,23001,self.EffectStart.transform.localPosition,true,queue + 10,nil)
	end
	self.ShineEffect:Hide()
	self.ShineEffect:Show(self.EffectContainer,self.EffectStart.transform.localPosition,true,nil)
	if(self.EffectCallback ~= nil) then
		local temp = self.EffectCallback
		self.EffectCallback = nil
		temp()
	end
	--显示完特效，刷新幸运值
	RotationDiscCtrl.SendEvent(RotationDiscEvent.RefreshLuck)
end


function RotationDiscCenterItem:Update(index)
	self.PointLeftHelper:SetVisiable(true)
	self.PointRightHelper:SetVisiable(true)
	for k,v in pairs(self.ListDisc) do
		if(k == index) then
			v:OnVisiable(true,self.PointLeftHelper,self.PointRightHelper,self.ArrowHelper)
		else
			v:OnVisiable(false,nil,nil,nil)
		end
	end
	if(index < 0) then
		self.PointLeftHelper:Clear()
		self.PointRightHelper:Clear()
		self.ArrowHelper:Clear()
	end
end

function RotationDiscCenterItem:Dispose()
	for i=1,#self.ListDisc do
		self.ListDisc[i]:Dispose()
	end
	self.ListDisc = {}
	if(self.onLottoryTabChange ~= nil) then
		RotationDiscCtrl.AddEvent(RotationDiscEvent.OnLottoryTabChange,self.onLottorTabChange)
		self.onLottoryTabChange = nil
	end
	if(self.FlyEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.FlyEffect)
		self.FlyEffect = nil
	end
	if(self.ShineEffect ~= nil) then
		UnitEffectMgr.DisposeEffect(self.ShineEffect)
		self.ShineEffect = nil
	end
end
