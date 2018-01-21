--播放选择宝箱动画
LookFor_Cmd_ShowSelectBonus = Class(CommandBase)

function LookFor_Cmd_ShowSelectBonus:ctor(...)
end

function LookFor_Cmd_ShowSelectBonus:Execute(context)
	LookFor_Cmd_ShowSelectBonus.superclass.Execute(self)

	--开启碰撞框
	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
	 	g.transform:GetChild(0):GetComponent("BoxCollider").enabled = true
	end

	--开启倒计时
	UIMgr.Dic("LookForView").Point_2_BG:SetActive(true)

	UIMgr.Dic("LookForView").timeCount = 10
	self.Timer = LH.UseVP(0, UIMgr.Dic("LookForView").timeCount, 1 ,
		function()
			UIMgr.Dic("LookForView").timeCount = UIMgr.Dic("LookForView").timeCount - 1
			UIMgr.Dic("LookForView").Point_2_BG_lbl:GetComponent("UILabel").text = L("请选择宝箱:{1}秒",tostring(UIMgr.Dic("LookForView").timeCount))
			if UIMgr.Dic("LookForView").timeCount == 0 then
				UIMgr.Dic("LookForView").Point_2_BG:SetActive(false)
				UIMgr.Dic("LookForView").OpenShow(0)
			end
			
		end,{})
	local onFinish = function ()
		self:ShowFinish()
	end
	self.DelayTimer = LH.UseVP(10,1,0,onFinish,nil)
end

function LookFor_Cmd_ShowSelectBonus:ShowFinish()
	self.Timer = nil
	self:OnExecuteDone(CmdExecuteState.Success)
end

function LookFor_Cmd_ShowSelectBonus:OnDestroy()
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	--关闭碰撞框
	for i=1,#UIMgr.Dic("LookForView").Point_2_ItemList do
		local g = UIMgr.Dic("LookForView").Point_2_ItemList[i]
	 	g.transform:GetChild(0):GetComponent("BoxCollider").enabled = false
	end
	UIMgr.Dic("LookForView").Point_2_BG:SetActive(false)
	LookFor_Cmd_ShowSelectBonus.superclass.OnDestroy(self)
end