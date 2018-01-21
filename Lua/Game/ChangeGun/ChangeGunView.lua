require 'Game/ChangeGun/ChangeGunItem'
ChangeGunView=Class(BaseView)

function ChangeGunView:ConfigUI()
	self.TP = Find(self.gameObject,"Content"):GetComponent("TweenPosition")
	self.Mask = Find(self.gameObject,"Mask")
	local onClickClose = function (go)
		local gunID = self:GetGunID(self.CurSelectGunIndex)
		-- if(GunMgr.MainGun ~= nil and GunMgr.MainGun.roleData.weapon ~= gunID)then
		-- 	if(self.OnChangeGunCallback ~= nil) then
		-- 		self.OnChangeGunCallback(gunID)
		-- 	end
		-- end
		-- ChangeGunCtrl.HideView()

		if(LoginCtrl.HasGetGun(gunID)) then
			if(GunMgr.MainGun ~= nil and GunMgr.MainGun.roleData.weapon ~= gunID and self.OnChangeGunCallback ~= nil)then
				local temp = self.OnChangeGunCallback
				self.OnChangeGunCallback = nil
				temp(gunID)
			end
			ChangeGunCtrl.HideView()
		else
			HelpCtrl.OpenTipView(L("提   示"),L("炮台未解锁，可在商城购买哦！"),function ()
				ChangeGunCtrl.HideView()
				UIMgr.OpenView("ShopView",2)
			end,function ()
				ChangeGunCtrl.HideView()
			end,function ()
				ChangeGunCtrl.HideView()
			end,L("商 城"),L("确 定"))
		end
	end
	LH.AddClickEvent(self.Mask,onClickClose)

	self.Info = Find(self.gameObject,"Info")
	self.InfoTS = self.Info.gameObject:GetComponent("TweenScale")
	self.LabelName = Find(self.Info,"Table/Items/ItemName/LabelName"):GetComponent("UILabel")
	self.DescItemTemplate = Find(self.Info,"Table/Items/Item")
	self.DescItemTemplate.gameObject:SetActive(false)
	self.ListDescItem = {}
	self.InfoTable = Find(self.Info,"Table"):GetComponent("UITable")
	self.ItemTable = Find(self.Info,"Table/Items"):GetComponent("UITable")
	
	self.ContainerTR = Find(self.gameObject,"Content/Container"):GetComponent("TweenRotation")

	self.GunTemplate = Find(self.gameObject,"Content/Container/Gun")
	self.GunTemplate:SetActive(false)

	self.ListItem = {}
	self.GunItemNum = 8
	self.Radius = 260
	self.PerDegree  = 360.0 / self.GunItemNum
	--初始化8个Item
	for i=1,self.GunItemNum do
		local temp = LH.GetGoBy(self.GunTemplate,self.GunTemplate.transform.parent.gameObject)
		temp:SetActive(true)
		local degree = math.rad((i - 1) * self.PerDegree)
		local x = self.Radius * math.sin(degree)
		local y = self.Radius * math.cos(degree)
		temp.transform.localPosition = Vector3.New(x,y,0)
		local item = ChangeGunItem:New(temp)
		item:Init(self,i)
		self.ListItem[i] = item
	end

	self.IsShow = false

	self.ListGun = {}
	--self.ListGun = {4000001,4000002}

	self.CurSelectGunIndex = nil
	
end

function ChangeGunView:AfterOpenView(t)
	self.Mask:SetActive(false)
	self.Info.gameObject:SetActive(false)
	LH.SetTweenPosition(self.TP,Vector3.New(0,-300,0),Vector3.New(0,-300,0),0,nil)
	for k,v in pairs(self.ListItem) do
		if(v~=nil) then
			v:Reset()
		end
	end
end

function ChangeGunView:UpdateSelectInfo()
	-- body
end

function ChangeGunView:Show(OnChangeGun)
	-- local ids = LoginCtrl.mode.GunList
	self.ListGun = {}
	for i,v in ipairs(SortRes.Gun) do
		table.insert(self.ListGun,tonumber(v.id))
	end
	self.CanPlayOutBreakAnim = true
	if(not self.IsShow) then
		self.IsShow = true
		self.Mask:SetActive(true)
		LH.SetTweenPosition(self.TP,Vector3.New(0,-300,0),Vector3.New(0,0,0),0.25,function (go)
			--显示Info
			self:UpdateSelectInfo()
			self.Info.gameObject:SetActive(true)
			self.ItemTable:Reposition()
			self.InfoTable:Reposition()
		end)
		local gunIndex = 1
		if(GunMgr.MainGun ~= nil)then
			local gunID = GunMgr.MainGun.roleData.weapon
			for k,v in pairs(self.ListGun) do
				if(v == gunID)then
					gunIndex = k
					break
				end
			end
		end
		self:InitFirstSelect(gunIndex)
	end
	self.OnChangeGunCallback = OnChangeGun
end

function ChangeGunView:InitFirstSelect(gunIndex)
	--默认初始化旋转为0（gunItem默认第一个）
	self.ContainerTR.transform.localEulerAngles = Vector3.New(0,0,0)

	local index = self:GetIndexByDegree(0)
	self:UpdateGunTex(index,gunIndex)
	self:UpdateAnim()
	--改变图片的缩放
	self:UpdateTexScale()
	--更新选中炮
	self:UpdateSelectGunInfo(gunIndex)
end

function ChangeGunView:Hide()
	if(self.IsShow) then
		self.IsShow = false
		self.Info.gameObject:SetActive(false)
		LH.SetTweenPosition(self.TP,Vector3.New(0,0,0),Vector3.New(0,-300,0),0.25,function (go)
			self.Mask:SetActive(false)
			for k,v in pairs(self.ListItem) do
				v:Reset()
			end
		end)
	end
	self.OnChangeGunCallback = nil
end

--获取要显示的炮的数量
function ChangeGunView:GetGunNum()
	return #self.ListGun
end

function ChangeGunView:GetGunID(gunIndex)
	return self.ListGun[gunIndex]
end

function ChangeGunView:OnRotate(deltaX)
	self.Info.gameObject:SetActive(false)
	self.CanPlayOutBreakAnim = false

	local degree = -deltaX / self.Radius * 90
	if(math.abs(degree) > self.PerDegree) then return end
	local curAngles = self.ContainerTR.transform.localEulerAngles
	local nextRotateZ = curAngles.z + degree
	local preIndex = self:GetIndexByDegree(curAngles.z)
	local nextIndex = self:GetIndexByDegree(nextRotateZ)
	--先旋转
	self.ContainerTR.transform.localEulerAngles = Vector3.New(0,0,nextRotateZ)
	
	self:UpdateGunItem(preIndex,nextIndex)
end

function ChangeGunView:UpdateGunItem(preIndex,nextIndex)
	if(nextIndex ~= preIndex) then
		
		--刷新所有炮
		local tempIndex
		if(math.abs(nextIndex - preIndex) > self.GunItemNum / 2) then
			local sub = self:GetGunNum() - math.abs(nextIndex - preIndex)
			tempIndex = self.CurSelectGunIndex - 1 - sub
		else
			tempIndex = (nextIndex - preIndex + self.CurSelectGunIndex) - 1  --因为是从1开始的
		end
		tempIndex = tempIndex % self:GetGunNum()
		if(tempIndex < 0) then tempIndex = tempIndex + self:GetGunNum() end 
		local nextSelectGunIndex = tempIndex + 1
		--更新显示图片
		self:UpdateGunTex(nextIndex,nextSelectGunIndex)

		self:UpdateSelectGunInfo(nextSelectGunIndex)
	end
end

function ChangeGunView:UpdateSelectGunInfo(selectGunIndex)
	--更新选中炮的描述
		local selectGunID = self:GetGunID(selectGunIndex)
		local cfg = Res.gun[selectGunID]
		local index = 1
		if(cfg ~= nil)then
			local gunName = L("{1}",cfg.name)
			if(not LoginCtrl.HasGetGun(cfg.id)) then
				gunName = gunName.."("..L("未解锁")..")"
			end
			self.LabelName.text = gunName
			if(cfg.Desc ~= nil) then
				local count = #cfg.Desc - #self.ListDescItem
				if(count > 0)then
					for i=1,count do
						local temp = LH.GetGoBy(self.DescItemTemplate,self.DescItemTemplate.transform.parent.gameObject)
						table.insert(self.ListDescItem,temp)
					end
				end
			end
			
			for k,v in pairs(cfg.Desc) do
				local go = self.ListDescItem[index]
				local labelTitle = Find(go,"Bg/LabelTitle"):GetComponent("UILabel")
				local labelDesc = Find(go,"LabelDesc"):GetComponent("UILabel")
				labelTitle.text = L("{1}",tostring(v[2]))
				LB(labelDesc,"{1}",tostring(v[3]))
				go.gameObject:SetActive(true)
				index = index + 1
			end
			
		end
		for i=index,#self.ListDescItem do
			self.ListDescItem[i].gameObject:SetActive(false)
		end
		self.ItemTable:Reposition()
		self.InfoTable:Reposition()
		LH.SetTweenScale(self.InfoTS,0,0.25,Vector3.New(0,1,1),Vector3.New(1,1,1))
end

--当前选择的GunItem需要显示gunIndex的gun,itemIndex是当前选择的GunItem，gunIndex是当前选择的GunItem需要显示的gunModel
function ChangeGunView:UpdateGunTex(itemIndex,gunIndex)
	self.CurSelectGunIndex = gunIndex
	local count = #self.ListItem
	for i=1,count do
		local curShowGunID 
		local sub = i - itemIndex
		local offset
		if(math.abs(sub) > (count / 2)) then
			sub = count - math.abs(sub)
			if(itemIndex > i) then
				offset = math.abs(sub)
			else
				offset = -math.abs(sub)
			end
		else
			offset = sub
		end
		local nextGunIndex = gunIndex + offset
		--将nextGunIndex转换为1-GetGunNum()	
		nextGunIndex = (nextGunIndex - 1) % self:GetGunNum() 
		if(nextGunIndex< 0) then nextGunIndex = nextGunIndex + self:GetGunNum() end
		nextGunIndex = nextGunIndex + 1
		curShowGunID = self:GetGunID(nextGunIndex)
		--LogColor("#ff0000","ShowGunID",curShowGunID)
		local needScale = (itemIndex ~= i)
		local show = (math.abs(offset) < 2)
		self.ListItem[i]:ShowGun(curShowGunID,needScale,true)
	end
end

function ChangeGunView:ResetPosition()
	self.Info.gameObject:SetActive(true)
	self.CanPlayOutBreakAnim = true
	local curAngles = self.ContainerTR.transform.localEulerAngles
	local index = self:GetIndexByDegree(curAngles.z)
	self:SelectItem(index,true)
end

function ChangeGunView:GetCurIndex()
	return self:GetIndexByDegree(self.ContainerTR.transform.localEulerAngles.z)
end

function ChangeGunView:GetIndexByDegree(degree)
	local rotateZ = degree % 360
	if(rotateZ < 0) then rotateZ = rotateZ + 360 end
	local index = 1
	for i=1,self.GunItemNum do
		local degree = (i - 1) * self.PerDegree
		if(math.abs(rotateZ - degree) <= (self.PerDegree / 2))then
			index = i
			break
		end
	end
	return index
end

function ChangeGunView:OnClickSelectItem(itemIndex,trans)
	local curItemIndex = self:GetCurIndex()
	if(itemIndex == curItemIndex) then
		local gunID = self:GetGunID(self.CurSelectGunIndex)
		if(LoginCtrl.HasGetGun(gunID)) then
			if(GunMgr.MainGun ~= nil and GunMgr.MainGun.roleData.weapon ~= gunID and self.OnChangeGunCallback ~= nil)then
				local temp = self.OnChangeGunCallback
				self.OnChangeGunCallback = nil
				temp(gunID)
			end
			ChangeGunCtrl.HideView()
		else
			HelpCtrl.OpenTipView(L("提   示"),L("炮台未解锁，可在商城购买哦！"),function ()
				ChangeGunCtrl.HideView()
				UIMgr.OpenView("ShopView",2)
			end,nil,nil,L("商 城"),L("确 定"))
		end
	else
		self:SelectItem(itemIndex,trans)
	end
end

function ChangeGunView:SelectItem(itemIndex,trans)
	local curAngles = self.ContainerTR.transform.localEulerAngles
	local rotateZ = curAngles.z % 360
	if(rotateZ < 0) then rotateZ = rotateZ + 360 end
	local nextRotateZ = (itemIndex - 1) * self.PerDegree
	local sub = math.abs(nextRotateZ - rotateZ)

	if(sub > 180) then
		if(nextRotateZ > rotateZ) then
			rotateZ = rotateZ + 360
		else
			rotateZ = rotateZ - 360
		end
	end
	if(trans) then
		LH.SetTweenRotation(self.ContainerTR,Vector3.New(0,0,rotateZ),Vector3.New(0,0,nextRotateZ),0.25,function (go)
			--改变图片的缩放
			self:UpdateTexScale()
			self:UpdateAnim()
		end)
	else
		self.ContainerTR.transform.localEulerAngles = Vector3.New(0,0,nextRotateZ)
		--改变图片的缩放
		self:UpdateTexScale()
		self:UpdateAnim()
	end
	local preIndex = self:GetIndexByDegree(curAngles.z)
	local nextIndex = self:GetIndexByDegree(nextRotateZ)
	self:UpdateGunItem(preIndex,nextIndex)
	if(preIndex ~= nextIndex) then
		PlaySound(AudioDefine.SwitchGun,nil)
	end
end

function ChangeGunView:UpdateAnim()
	local count = #self.ListItem
	local curIndex = self:GetCurIndex()
	for k,v in pairs(self.ListItem) do
		v:UpdateAnim()
	end
end

function ChangeGunView:UpdateTexScale()
	-- body
end

function ChangeGunView:BeforeCloseView()

end

function ChangeGunView:OnDestory()

end