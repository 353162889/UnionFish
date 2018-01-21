require 'Game/Play/RevenueRankView'
require 'Game/Play/GunUnlockItem'
require 'Game/Play/TreasureItem'
GunView=Class(BaseView)

function GunView:ConfigUI()

	self.GunItem = Find(self.gameObject,"PlayerBox/Item")
	self.GunItem:SetActive(false)

	self.BG = Find(self.gameObject,"BG")
	self.SupPoint = UnityEngine.GameObject("supPoint")
	Ext.AddChildToParent(self.BG,self.SupPoint,false)
	local OnSelfPressBG = function (go,state)
		self:OnPressBG(go,state)
	end
	LH.AddPressEvent(self.BG,OnSelfPressBG)

	self:EnableBG(false)
end


function GunView:AfterOpenView(t)
	self.uiCamera = LH.GetMainUICamera()--获取到UI相机
end

function GunView:EnableBG(isEnable)
	self.BG:SetActive(isEnable)
end

function GunView:AddListener()
	self:AddEvent(ED.PlayCtrl_S2CSceneSynObj,self.this.PlayCtrl_S2CSceneSynObj)
end

function GunView:BeforeCloseView()

	if(self.PressTimerHandle ~= nil) then
		self.PressTimerHandle:Cancel()
		self.PressTimerHandle = nil
	end
	self.uiCamera = nil
end

function GunView:OnDestory()
end

function GunView.PlayCtrl_S2CSceneSynObj(t)
	
end

function GunView:OnPressBG(go,state)
	if(state) then
		if(self.PressTimerHandle ~= nil) then
			self.PressTimerHandle:Cancel()
			self.PressTimerHandle = nil
		end
		local OnDelay = function (lt)
			self:SendBullet()
		end
		self.PressTimerHandle = LH.UseVP(0, 0, 0.1 ,OnDelay,nil)
	else
		if(self.PressTimerHandle ~= nil) then
			self.PressTimerHandle:Cancel()
			self.PressTimerHandle = nil
		end
		self:SendBullet()
	end
end

function GunView:SendBullet()
	if(GunMgr.MainGun == nil) then
			return
	end
	local pos = GunMgr.MainGun:GetCenterPos()
	local inputMousePos = UnityEngine.Input.mousePosition
	local inputPos = self.uiCamera:ScreenToWorldPoint(inputMousePos)
	self.SupPoint.transform.position = inputPos
	inputPos = self.SupPoint.transform.localPosition
	local v3 = inputPos - pos;
	v3.z = 0
	local d = Vector3.Angle(v3,Vector3.New(0,1,0))
	if v3.x > 0 then
		d = -1 * d
	else
		d = d - 360
	end
	GunMgr.ClientSendBullet(d)
end

