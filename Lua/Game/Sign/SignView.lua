require 'Game/Sign/SignSevenDaysView'

SignView=Class(BaseView)



function SignView:ConfigUI()
	self.SignName=Find(self.gameObject,"SignSevenItemGrid/SignName"):GetComponent("UILabel")
	LB(self.SignName,"7天签到")

	self.SignName30=Find(self.gameObject,"SignThirtyItemGrid/SignName"):GetComponent("UILabel")
	LB(self.SignName30,"30天签到")

	self.CloseBtn = Find(self.gameObject,"SignCloseBtn")
	local onCloseBtn = function (go)
		LH.Play(go,"Play")
		UIMgr.CloseView("SignView")
	end
	LH.AddClickEvent(self.CloseBtn,onCloseBtn)

	self.ReceiveBtn = Find(self.gameObject,"SignReceiveBtn")
	local onReceiveBtn = function (go)
		LH.Play(go,"Play")
		self:OnReceiveBtnClick()
	end
	LH.AddClickEvent(self.ReceiveBtn,onReceiveBtn)
	Find(self.ReceiveBtn,"Label"):GetComponent("UILabel").text = L("领 取")

	local signSevenDay = Find(self.gameObject,"CategoryType/SignSevenDay")
	local sevenDays= Find(self.gameObject,"SignSevenItemGrid")
	self.SevenItemGrid = SignSevenDaysView:New(sevenDays)
	self.SevenItemGrid:Init(signSevenDay)

	local label7 = Find(self.gameObject,"CategoryType/SignSevenDay/DayShow"):GetComponent("UILabel")
	LB(label7,"7天签到")
	local label30 = Find(self.gameObject,"CategoryType/SignThirtyDay/DayShow"):GetComponent("UILabel")
	LB(label30,"30天签到")
	Find(self.gameObject,"SignThirtyItemGrid/Label"):GetComponent("UILabel").text = L("未开放")
end


function SignView:AfterOpenView(t)
	self:InitListener(true)

	if SignCtrl.modeSign~=nil then
		self.SevenItemGrid:UpdataItem(SignCtrl.modeSign.num)
		if SignCtrl.modeSign.sign==0 then
			self.SevenItemGrid:UpdataSignHint(SignCtrl.modeSign.num+1,true)
		else
			self.SevenItemGrid:UpdataSignHint(SignCtrl.modeSign.num,false)
		end
	end
end


--添加或移除事件
function SignView:InitListener(isAdd)
	if isAdd then
		self.ClickReceiveBtn = function (data)
			self:OnSignReceiveBtn(data)
		end
		SignCtrl.AddEvent(SignEvent.OnSignReceiveBtn,self.ClickReceiveBtn)
	else
		if(self.ClickReceiveBtn ~= nil) then
			SignCtrl.RemoveEvent(SignEvent.OnSignReceiveBtn,self.ClickReceiveBtn)
			self.ClickReceiveBtn = nil
		end
	end
end

--事件函数
function SignView:OnSignReceiveBtn(data)
	if data~=nil then
		if data.ret==0 then		--签到成功
			--发放礼品
			HelpCtrl.OpenItemGetEffectView(SortRes.DicSign7[data.index].items,L("签到成功，获得物品"))
			self.SevenItemGrid:UpdataItem(data.index)
			self.SevenItemGrid:UpdataSignHint(data.index,false)
			self.SevenItemGrid:CloseEffect()

			local SignReceiveOk = true
			SignCtrl.SendEvent(SignEvent.OnSignReceiveHint,SignReceiveOk)

			SignCtrl.modeSign = {}
			SignCtrl.C2SSignGetInfo()
		else
			--签到失败
			print("sr__________________________________签到失败！！！")
		end
	end
end

--点击签到领取物品
function SignView:OnReceiveBtnClick()
	SignCtrl.C2SSignSign()
end


function SignView:BeforeCloseView()
	self:InitListener(false)
	self.SevenItemGrid:CloseEffect()
end