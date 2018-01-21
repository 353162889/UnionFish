--播放显示宝箱动画
LookFor_Cmd_ShowFirstBonus = Class(CommandBase)

function LookFor_Cmd_ShowFirstBonus:ctor(...)
end

function LookFor_Cmd_ShowFirstBonus:Execute(context)
	LookFor_Cmd_ShowFirstBonus.superclass.Execute(self)

	UIMgr.Dic("LookForView").Point_2_Mask:SetActive(true)

	LH.SetTweenAlpha(UIMgr.Dic("LookForView").Point_2_Mask_TA,0,1,0,1)
	

	--隐藏倒计时与特效显示
	UIMgr.Dic("LookForView").Point_2_BG:SetActive(false)
	for k,v in pairs(UIMgr.Dic("LookForView").EffectList_2) do
		v.gameObject:SetActive(false)
	end

	--显示关闭样式
	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
		local ts = g:GetComponent("TweenScale")
		local childTP = g.transform:GetChild(0):GetComponent("TweenPosition")
		g.transform:GetChild(0):FindChild("Effect").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("Icon").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("lbl").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite").spriteName = "com_baoxiang_01"
	 	g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite"):MakePixelPerfect()
	 	g.transform:GetChild(0):GetComponent("BoxCollider").enabled = false
		ts:ResetToBeginning()
		ts:PlayForward()
		childTP:ResetToBeginning()
		childTP:PlayForward()
	end

	local onFinish = function ()
		self:ShowBonus()
	end
	self.Timer = LH.UseVP(1,1,0,onFinish,nil)
end

function LookFor_Cmd_ShowFirstBonus:ShowBonus()
	self.Timer = nil
	--显示与打开样式
	local d = Res.lotterybox[UIMgr.Dic("LookForView").LookForIdx]
	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
		local item = d.items[i]
		g.transform:GetChild(0):FindChild("Icon").gameObject:SetActive(true)
		g.transform:GetChild(0):FindChild("lbl").gameObject:SetActive(true)
		g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite").spriteName = Res.item[d.items[i][2]].icon
	 	g.transform:GetChild(0):FindChild("Icon"):GetComponent("UISprite"):MakePixelPerfect()
	 	g.transform:GetChild(0):FindChild("lbl"):GetComponent("UILabel").text = L("x{1}",d.items[i][3])
		g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite").spriteName = "com_baoxiang_02"
	 	g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite"):MakePixelPerfect()
	end

	local onFinish = function ()
		self:ShowFinish()
	end
	self.Timer = LH.UseVP(2,1,0,onFinish,nil)
end

function LookFor_Cmd_ShowFirstBonus:ShowFinish()
	self.Timer = nil
	--显示关闭样式
	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
		g.transform:GetChild(0):FindChild("Effect").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("Icon").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("lbl").gameObject:SetActive(false)
		g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite").spriteName = "com_baoxiang_01"
	 	g.transform:GetChild(0):FindChild("Box"):GetComponent("UISprite"):MakePixelPerfect()
	end

	local onFinish = function ()
		UIMgr.Dic("LookForView").Point_2_Mask:SetActive(false)
		self:OnExecuteDone(CmdExecuteState.Success)
	end
	LH.SetTweenAlpha(UIMgr.Dic("LookForView").Point_2_Mask_TA,0,1,1,0)
	self.Timer = LH.UseVP(1,1,0,onFinish,nil)
end

function LookFor_Cmd_ShowFirstBonus:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	UIMgr.Dic("LookForView").Point_2_Mask:SetActive(false)
	LookFor_Cmd_ShowFirstBonus.superclass.OnDestroy(self)
end