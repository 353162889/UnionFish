BagView=Class(BaseView)

function BagView:ConfigUI()
	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	LH.AddClickEvent(self.CloseBtn,self.this.OnClickCloseBtn)
	self.Item = Find(self.gameObject,"ItemBox/Table/Item")
	self.Item:SetActive(false)
	self.ItemWidget = self.Item:GetComponent("UIWidget")
	self.ItemList = {}
	LB(Find(self.gameObject,"ItemInfo/lbl_1"):GetComponent("UILabel"),"物品介绍")
	Find(self.gameObject,"ItemInfo/Btn_1/lbl"):GetComponent("UILabel").text = L("出 售")
	Find(self.gameObject,"ItemInfo/Btn_2/lbl"):GetComponent("UILabel").text = L("使 用")
	self.ItemInfo_lbl_2 = Find(self.gameObject,"ItemInfo/lbl_2")
	self.ItemInfo_lbl_3 = Find(self.gameObject,"ItemInfo/lbl_3")
	self.ItemInfo_lbl_4 = Find(self.gameObject,"ItemInfo/lbl_4")
	self.ItemInfo_Btn_1 = Find(self.gameObject,"ItemInfo/Btn_1")
	LH.AddClickEvent(self.ItemInfo_Btn_1,self.this.OnClickItemInfo_Btn_1)
	self.ItemInfo_Btn_2 = Find(self.gameObject,"ItemInfo/Btn_2")
	LH.AddClickEvent(self.ItemInfo_Btn_2,self.this.OnClickItemInfo_Btn_2)
	self.ItemInfo_ItemCell_Icon = Find(self.gameObject,"ItemInfo/ItemCell/Icon")
	
	for i=1,Res.misc[1].BagBaseCount do
		-- local temp = ItemCell.Create(self.Item.transform.parent.gameObject)
		local parent = LH.GetGoBy(self.Item,self.Item.transform.parent.gameObject)
		parent:SetActive(true)
		local temp = ItemCell.Create(parent)
		temp.SetValue(nil)
		temp.SetName(tostring(i))
		temp.Item.transform:FindChild("Select").gameObject:SetActive(false)
		local itemWidget = temp.Item:GetComponent("UIWidget")
		itemWidget.width = self.ItemWidget.width
		itemWidget.height = self.ItemWidget.height
		LH.AddClickEvent(temp.Item,self.this.OnClickItem)
		table.insert(self.ItemList,temp)
	end
	-- self.Item.transform.parent:GetComponent("UITable"):Reposition()
	self.Item.transform.parent:GetComponent("UIGrid"):Reposition()
	self.Item.transform.parent.parent:GetComponent("UIScrollView"):ResetPosition()
	self.CurItemGo = nil

	Find(self.gameObject,"BG_2/lbl"):GetComponent("UILabel").text = L("背 包")
end

function BagView.OnClickItem(go)
	if go:GetComponent("MonoData").data == nil then
		return
	end
	local s = UIMgr.Dic("BagView")
	if s.CurItemGo ~= nil then
		s.CurItemGo.transform:FindChild("Select").gameObject:SetActive(false)
	end
	s.CurItemGo = go
	s.CurItemGo.transform:FindChild("Select").gameObject:SetActive(true)
	s.UpDate()
end

function BagView.OnClickItemInfo_Btn_1(go)
	local s = UIMgr.Dic("BagView")
	if s.CurItemGo ~= nil then
		BagCtrl.C2SBagSellItem(s.CurItemGo:GetComponent("MonoData").data.id,1)
	end
end

function BagView.OnClickItemInfo_Btn_2(go)
	local s = UIMgr.Dic("BagView")
	if s.CurItemGo ~= nil then
		BagCtrl.C2SBagUseItem(s.CurItemGo:GetComponent("MonoData").data.id,1)
	end
end

function BagView:AfterOpenView(t) 
	UIMgr.Dic("BagView").UpDate()
end

function BagView:UpdateView()

end

function BagView:AddListener()
	self:AddEvent(ED.BagCtrl_S2CBagUpdate,self.this.BagCtrl_S2CBagUpdate)

end

function BagView:BeforeCloseView()
	if self.CurItemGo ~= nil then
		self.CurItemGo.transform:FindChild("Select").gameObject:SetActive(false)
		self.CurItemGo = nil
	end
end

function BagView:OnDestory()

end

function BagView.OnClickCloseBtn(go)
	UIMgr.CloseView("BagView")
end

function BagView.BagCtrl_S2CBagUpdate(t)
	UIMgr.Dic("BagView").UpDate()
end

function BagView.UpDate()
	local s = UIMgr.Dic("BagView")

	for i=1,#s.ItemList do
		if i <= #BagCtrl.mode.S2CBagGetInfoData then
			s.ItemList[i].SetValue(BagCtrl.mode.S2CBagGetInfoData[i])
			if s.CurItemGo == nil then
				s.CurItemGo = s.ItemList[i].Item
				s.CurItemGo.transform:FindChild("Select").gameObject:SetActive(true)
			end
		else
			s.ItemList[i].SetValue(nil)
			-- s.ItemList[i].Item.transform:FindChild("Select").gameObject:SetActive(false)
		end
	end
	if s.CurItemGo == nil or s.CurItemGo:GetComponent("MonoData").data == nil then
		s.ItemInfo_lbl_2:GetComponent("UILabel").text = ""
		s.ItemInfo_lbl_3:GetComponent("UILabel").text = ""
		LB(s.ItemInfo_lbl_4:GetComponent("UILabel"),"数量：{1}","")
		s.ItemInfo_Btn_1:SetActive(false)
		s.ItemInfo_Btn_2:SetActive(false)
		s.ItemInfo_ItemCell_Icon:SetActive(false)
		if s.CurItemGo ~= nil then
			s.CurItemGo.transform:FindChild("Select").gameObject:SetActive(false)
		end
	else
		local _d = Res.item[s.CurItemGo:GetComponent("MonoData").data.id]
		local label_lbl_2 = s.ItemInfo_lbl_2:GetComponent("UILabel")
		LB(label_lbl_2,"{1}",_d.notice)
		LB(s.ItemInfo_lbl_3:GetComponent("UILabel"),"{1}",_d.name)
		LB(s.ItemInfo_lbl_4:GetComponent("UILabel"),"数量：{1}",s.CurItemGo:GetComponent("MonoData").data.cnt)
		s.ItemInfo_ItemCell_Icon:GetComponent("UISprite").spriteName = _d.icon
		s.ItemInfo_Btn_1:SetActive(_d.is_gold > 0)
		s.ItemInfo_Btn_2:SetActive(_d.is_use > 0)
		s.ItemInfo_ItemCell_Icon:SetActive(true)
	end
end