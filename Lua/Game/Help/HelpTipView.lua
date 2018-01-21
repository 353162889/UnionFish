HelpTipView=Class(BaseView)

function HelpTipView:ConfigUI()    
    self.LabelTitle = Find(self.gameObject,"LabelTitle"):GetComponent("UILabel")
    self.LabelTitle.text = L("提   示")
    self.LabelContent = Find(self.gameObject,"LabelContent"):GetComponent("UILabel")
    self.BtnClose = Find(self.gameObject,"BtnClose")
    local onClose = function (go)
    	self:OnClickClose(go)
    end
    LH.AddClickEvent(self.BtnClose,onClose)
    self.BtnConfirm = Find(self.gameObject,"BtnConfirm")
    local onConfirm = function (go)
    	self:OnClickConfirm(go)
    end
    self.LabelConfirm = Find(self.BtnConfirm,"Label"):GetComponent("UILabel")
    LH.AddClickEvent(self.BtnConfirm,onConfirm)

    self.BtnCancel = Find(self.gameObject,"BtnCancel")
    local onCancel = function (go)
    	self:OnClickCancel(go)
    end
    self.LabelCancel = Find(self.BtnCancel,"Label"):GetComponent("UILabel")
    LH.AddClickEvent(self.BtnCancel,onCancel)

    self.BtnCenterConfirm = Find(self.gameObject,"BtnCenterConfirm")
    self.LabelCenterConfirm = Find(self.BtnCenterConfirm,"Label"):GetComponent("UILabel")
    LH.AddClickEvent(self.BtnCenterConfirm,onConfirm)

    self.CheckGO = Find(self.gameObject,"Check")
    self.CheckToggle = self.CheckGO:GetComponent("UIToggle")
    self.LabelCheck = Find(self.CheckGO,"Label"):GetComponent("UILabel")

    self.CloseCallback = nil
    self.ConfirmCallback = nil
    self.CancelCallback = nil
    self.CheckCallback = nil
end
function HelpTipView:OnClickClose(go)
	local closeCal = self.CloseCallback
	UIMgr.CloseView("HelpTipView")
	if(closeCal ~= nil) then
		closeCal()
	end
end

function HelpTipView:OnClickConfirm(go)
	local confirmCal = self.ConfirmCallback
	local checkCal = self.CheckCallback
	UIMgr.CloseView("HelpTipView")
	if(confirmCal ~= nil) then
		confirmCal()
	end
	if(checkCal ~= nil) then
		checkCal(self.CheckToggle.value)
	end
end

function HelpTipView:OnClickCancel(go)
	local cancelCal = self.CancelCallback
	UIMgr.CloseView("HelpTipView")
	if(cancelCal ~= nil) then
		cancelCal()
	end
end

function HelpTipView:AfterOpenView(t)
	self.ViewType = t.viewType
	if(self.ViewType == 1) then
		self.BtnConfirm.gameObject:SetActive(true)
		self.BtnCancel.gameObject:SetActive(true)
		self.BtnCenterConfirm.gameObject:SetActive(false)
		if(t.confirmLabel ~= nil) then
			self.LabelConfirm.text = L("{1}",t.confirmLabel)
		else
			self.LabelConfirm.text = L("确 认")
		end
		if(t.cancelLabel ~= nil) then
			self.LabelCancel.text = L("{1}",t.cancelLabel)
		else
			self.LabelCancel.text = L("取 消")
		end
	elseif(self.ViewType == 2) then
		self.BtnConfirm.gameObject:SetActive(false)
		self.BtnCancel.gameObject:SetActive(false)
		self.BtnCenterConfirm.gameObject:SetActive(true)
		if(t.confirmLabel ~= nil) then
			self.LabelCenterConfirm.text = L("{1}",t.confirmLabel)
		else
			self.LabelCenterConfirm.text = L("确 认")
		end
	end
	if(t.checkContent == nil or t.checkContent == "") then
		self.CheckGO:SetActive(false)
		t.checkContent = ""
	else
		self.CheckGO:SetActive(true)

	end
	self.CloseCallback = t.onCloseCallback
	self.ConfirmCallback = t.onConfirmCallback
	self.CancelCallback = t.onCancelCallback
	self.LabelTitle.text = L("{1}",t.title)
	LFix(self.LabelContent,L("{1}",t.content))
	self.LabelCheck.text = L("{1}",t.checkContent)
	if(t.checkValue == nil or t.checkValue == false) then
		self.CheckToggle.value = false
	else
		self.CheckToggle.value = true
	end
	self.CheckCallback = t.checkCallback
end

function HelpTipView:BeforeCloseView()
	self.CloseCallback = nil
	self.ConfirmCallback = nil
	self.CancelCallback = nil
	self.CheckCallback = nil
end

function HelpTipView:OnDestory()
	self.CloseCallback = nil
	self.ConfirmCallback = nil
	self.CancelCallback = nil
	self.CheckCallback = nil
end