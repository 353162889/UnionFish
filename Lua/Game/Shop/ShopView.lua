ShopView=Class(BaseView)

function ShopView:ConfigUI()
	self.CloseBtn = Find(self.gameObject,"CloseBtn")
	LH.AddClickEvent(self.CloseBtn,self.this.OnClickCloseBtn)
	self.Item = Find(self.gameObject,"ItemBox/Grid/Item")
	self.Item:SetActive(false)
	self.ItemList = {}
	self.TabItem = Find(self.gameObject,"TabBox/Item")
	self.TabItem:SetActive(false)
	self.TabItemList = {}
	self.CurTabItem = nil
	self.TabString = {}

	self.ResData = {}
	for i=1,#Res.store do
		if self.ResData[Res.store[i].tab] == nil then
			self.ResData[Res.store[i].tab] = {}
			table.insert(self.TabString,Res.store[i].tab)
		end
		table.insert(self.ResData[Res.store[i].tab],Res.store[i])
	end

	for k,v in pairs(self.ResData) do
		local temp = LH.GetGoBy(self.TabItem,self.TabItem.transform.parent.gameObject)
		temp:SetActive(true)
		temp.name = tostring(k)
		temp.transform:FindChild("Select/lbl"):GetComponent("UILabel").text = k
		temp.transform:FindChild("UnSelect/lbl"):GetComponent("UILabel").text = k
		Find(temp,"Select"):SetActive(false)
		Find(temp,"UnSelect"):SetActive(true)
		LH.AddClickEvent(temp,self.this.OnClickTabBtn)
		table.insert(self.TabItemList,temp)
	end
	self.TabItem.transform.parent:GetComponent("UIGrid"):Reposition()

	self.CurTabIndex = 1
end

--t 1金币  2钻石  3商城
function ShopView:AfterOpenView(t)
	if t ~= nil then
		self.CurTabIndex = t
	else
		self.CurTabIndex = 1
	end
	self.OnClickTabBtn(self.TabItemList[self.CurTabIndex])
end

function ShopView:UpdateView()

end

function ShopView:AddListener()

end

function ShopView:BeforeCloseView()

end

function ShopView:OnDestory()

end

function ShopView.OnClickCloseBtn(go)
	UIMgr.CloseView("ShopView")
end

function ShopView.OnClickTabBtn(go)
	local s = UIMgr.Dic("ShopView")
	if s.CurTabItem ~= nil then
		Find(s.CurTabItem,"Select"):SetActive(false)
		Find(s.CurTabItem,"UnSelect"):SetActive(true)
	end
	s.CurTabItem = go
	Find(s.CurTabItem,"Select"):SetActive(true)
	Find(s.CurTabItem,"UnSelect"):SetActive(false)
	local str = Find(s.CurTabItem,"Select/lbl"):GetComponent("UILabel").text
	local list = s.ResData[str]
	if #s.ItemList < #list then
		local count = #list - #s.ItemList
		for i=1,count do
			local temp = LH.GetGoBy(s.Item,s.Item.transform.parent.gameObject)
			temp:SetActive(true)
			LH.AddClickEvent(temp.transform:FindChild("Btn").gameObject,s.this.OnClickBuyBtn)
			table.insert(s.ItemList,temp)
		end
	end
	for i=1,#s.ItemList do
		if i > #list then
			s.ItemList[i]:SetActive(false)
		else
			s.ItemList[i]:SetActive(true)
			s.ItemList[i].name = tostring(list[i].id)

			s.ItemList[i].transform:FindChild("Btn/lbl"):GetComponent("UILabel").text = tostring(list[i].buy[2])
			s.ItemList[i].transform:FindChild("Btn/P/Icon"):GetComponent("UISprite").spriteName = Res.item[list[i].buy[1]].icon
	 		s.ItemList[i].transform:FindChild("Btn/P/Icon"):GetComponent("UISprite"):MakePixelPerfect()

			s.ItemList[i].transform:FindChild("lbl"):GetComponent("UILabel").text = L("{1}",list[i].title)
			s.ItemList[i].transform:FindChild("Icon"):GetComponent("UISprite").spriteName = list[i].icon
	 		s.ItemList[i].transform:FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
		end
	end
	s.Item.transform.parent:GetComponent("UIGrid"):Reposition()
	s.Item.transform.parent.parent:GetComponent("UIScrollView"):ResetPosition()
end

function ShopView.OnClickBuyBtn(go)
	local id = tonumber(go.transform.parent.name)
	local d = Res.store[id]
	local s_1 = L("{1}{2}",d.buy[2],Res.item[d.buy[1]].name)
	local s_2 = d.title

	HelpCtrl.OpenTipView(L("确认购买"),L("是否使用{1}购买{2}",s_1,s_2),
		function()  
			ShopCtrl.BuyItem(id)
			-- ShopCtrl.C2SStoreBuy(id)  
		end,nil,nil,L("确 定"),L("取 消"))
end

-- function HelpCtrl.OpenTipView(title,content,onConfirmCallback,onCancelCallback,onCloseCallback,confirmLabel,cancelLabel)
-- 	UIMgr.OpenView("HelpTipView",{viewType = 1,title = title,content = content,onConfirmCallback = onConfirmCallback,onCancelCallback = onCancelCallback,onCloseCallback = onCloseCallback})
-- end