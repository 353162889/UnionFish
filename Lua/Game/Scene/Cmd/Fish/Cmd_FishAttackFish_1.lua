
Cmd_FishAttackFish_1 = Class(CommandBase)

function Cmd_FishAttackFish_1:ctor(...)
	self.msg = select(1,...)
	self.info = select(2,...)
end

function Cmd_FishAttackFish_1:Execute(context)
	Cmd_FishAttackFish_1.superclass.Execute(self)

	--玩家退场，立即结束
	self.onPlayLeave = function ()
		self:OnExecuteDone(CmdExecuteState.Success)
	end
	EventMgr.AddEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,self.onPlayLeave)

	local animName = self.info.animName
	local effectId = self.info.effectId
	local effectMP = self.info.effectMP
	local delay = self.info.delay
	local icon = self.info.icon
	local offset = GetVector3(self.info.iconOffset)

	local fish = FishMgr.GetFish(self.msg.fish_obj_id)

	fish:PlayAnim(animName)
	--显示特效（这里的特效是根据动作来做的）
	fish:ShowEffect(effectId,effectMP)

	if(delay > 0) then
		local onDelay = function ()
			HelpCtrl.Num(self.msg)--金币数字
			HelpCtrl.Catch(self.msg)
    		--HelpCtrl.MoneyParam(self.msg,icon)--金币图片

    		local curFish = FishMgr.GetFish(self.msg.fish_obj_id)
    		local posSupport = UnityEngine.GameObject("PosSupport")
	    	Ext.AddChildToParent(curFish.gameObject,posSupport,false)
	    	posSupport.transform.localPosition = offset
	    	local pos = LH.WorldPosToUIPos(posSupport.transform.position)
	    	GameObject.Destroy(posSupport)
	    	GoldItemMgr.ShowGolds(pos,icon,self.msg.role_obj_id)--金币图片
    		
    		--local pos = LH.WorldPosToUIPos(curFish.gameObject.transform.position)
    		--显示UI特效
			--FishSceneEffectMgr.ShowUIEffectSelfDestroy(effectId,pos,false,-1)
			--显示场景特效
			--curFish:ShowEffect(effectId)
    		self:OnExecuteDone(CmdExecuteState.Success)
		end
		self.Timer = LH.UseVP(delay, 1, 0, onDelay,nil)
	else
		HelpCtrl.Num(self.msg)--金币数字
		HelpCtrl.Catch(self.msg)
    	--HelpCtrl.Money(self.msg)--金币图片
    	local posSupport = UnityEngine.GameObject("PosSupport")
    	Ext.AddChildToParent(fish.gameObject,posSupport,false)
    	posSupport.transform.localPosition = offset
    	local pos = LH.WorldPosToUIPos(posSupport.transform.position)
    	GameObject.Destroy(posSupport)
    	GoldItemMgr.ShowGolds(pos,icon,self.msg.role_obj_id)--金币图片

    	self:OnExecuteDone(CmdExecuteState.Success)
	end
end

function Cmd_FishAttackFish_1:OnDestroy()
	if(self.onPlayLeave ~= nil) then
		EventMgr.RemoveEvent(ED.PlayCtrl_BeforeS2CSceneObjLeave,self.OnPlayLeave)
		self.onPlayLeave = nil
	end
	self.msg = nil
	self.info = nil
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	Cmd_FishAttackFish_1.superclass.OnDestroy(self)
end
