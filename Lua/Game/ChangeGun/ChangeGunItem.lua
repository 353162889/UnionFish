ChangeGunItem = {}

function ChangeGunItem:New(go)
	local o = {gun = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function ChangeGunItem:Init(parentView,index)
	self.parentView = parentView
	self.index = index
	self.gunTex = self.gun.transform:FindChild("Tex"):GetComponent("UITexture")
	self.gunTS = self.gun.transform:FindChild("Tex"):GetComponent("TweenScale")
	self.labelName = self.gun.transform:FindChild("LabelName"):GetComponent("UILabel")
	self.labelUnlock = self.gun.transform:FindChild("LabelUnlock"):GetComponent("UILabel")

	self.helper = self.gun:AddComponent(typeof(ChangeGunHelper))
	self.helper:SetFixedAngle(0,0,0)
	self.defaultScale = Vector3.New(0.75,0.75,1)
	self.scale = Vector3.New(1,1,1)
	--self.collider = self.gun:GetComponent("BoxCollider")
	self.gunModel = UIModelMgr.CreateModel(self.gunTex,false,60,false)
	self.isSelect = nil
	self.needScale = false

	local clickItem = function (go)
		self:OnClickSelect(go)
	end
	LH.AddClickEvent(self.gun,clickItem)

	local dragItem = function (go,delta)
		self:OnDrag(go,delta)
	end
	local endDragItem = function (go)
		self:OnEndDrag(go)
	end
	LH.AddDragEvent(self.gun,dragItem)
	LH.AddDragEndEvent(self.gun,endDragItem)
end

function ChangeGunItem:ShowGun(gunID,needScale,isShow)
	if(self.cfg == nil or self.cfg.id ~= gunID)then 
		local cfg = Res.gun[gunID]
		if(cfg == nil) then
			LogError("can not find gun config id:"..gunID)
			return 
		end
		self.cfg = cfg
		self.labelName.text = L("{1}",self.cfg.name)
		self.labelUnlock.text = L("未解锁")
		self.gunModel.ShowModel(cfg.Gun_path,Vector3.New(0,-2.5,-16.9),Vector3.zero,Vector3.one,"0_0")
	end
	self.gun:SetActive(isShow)
	--if(self.needScale ~= needScale) then
		self.needScale = needScale
		if(self.needScale) then
			self.gunTS.enabled = false
			self.gunTex.transform.localScale = self.defaultScale
		else
			LH.SetTweenScale(self.gunTS,0,0.1,self.defaultScale,self.scale)
		end
	--end
	self:UpdateAnim()
	self.labelName.gameObject:SetActive(self.needScale)
	self.labelUnlock.gameObject:SetActive(self.needScale and (not LoginCtrl.HasGetGun(gunID)))
end

function ChangeGunItem:OnClickSelect(go)
	self.parentView:OnClickSelectItem(self.index,true)
end

function ChangeGunItem:OnDrag(go,delta)
	self.parentView:OnRotate(delta.x)
end

function ChangeGunItem:OnEndDrag(go)
	self.parentView:ResetPosition()
end

--[[function ChangeGunItem:UpdatePos(posIndex,trans)
	local pos = self.ListPos[posIndex]
	if(trans and math.abs(self.posIndex - posIndex) == 1) then
		self.moveHelper:MoveTo(pos,0.1)
	else
		self.moveHelper:MoveTo(pos,0)
	end
	self.posIndex = posIndex
end
]]

function ChangeGunItem:UpdateAnim()
	local isSelect = (not self.needScale) and self.parentView.CanPlayOutBreakAnim
	--if(self.isSelect ~= isSelect) then
		self.isSelect = isSelect
		if(self.gunModel ~= nil) then
			if(self.isSelect) then
				self.gunModel.Play("1_2")
			else
				self.gunModel.Play("1_0")
			end
		end
	--end
end

function ChangeGunItem:Reset()
	if(self.gunModel ~= nil) then
		self.gunModel.ResetModel()
	end
	self.gun:SetActive(false)
	self.cfg = nil
	self.isSelect = nil
end

function ChangeGunItem:Dispose()
	if(self.gunModel ~= nil) then
		self.gunModel.DestroyModel()
		self.gunModel = nil
	end
	self.gun = nil
	self.gun = nil
	self.gunTex = nil
	self.collider = nil
	self.parentView = nil
end
