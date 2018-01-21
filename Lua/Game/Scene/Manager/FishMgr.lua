require "Game/Scene/Unit/UnitFish"
require "Game/Scene/Unit/UnitFishExt/UnitLevelFish"		--子类必须在父类之后
require "Game/Scene/Unit/UnitFishExt/UnitBossClownFish"	

require "Game/Scene/Cmd/Fish/Cmd_FishAttackFish_0"
require "Game/Scene/Cmd/Fish/Cmd_FishAttackFish_1"

FishMgr = {}
local this = FishMgr

this.FishPool = nil
this.FishTempPool = nil
this.FishDelayDestroyPool = nil

this.FishDic = nil
this.FGParent = nil
this.CameraFishBox = nil
this.IsInScene = false
this.RefreshTotalTime = 0	--刷新鱼的模型，每秒至少一条，5秒内刷出所鱼
this.DelayDestroyTime = 5	--延时销毁时间，每条鱼死后延时n秒再销毁，如果当前销毁池里面已经有对象了，那么延时时间是最后一条鱼的死亡时间+n秒
this.PoolCapacity = 0
this.DestroyPoolCapacity = 10
this.IsFirstEnterScene = false
this.ListDelayRefreshFishRes = nil

FishMgr.FishHandleType = {
	[1] = UnitFish,
	[2] = UnitLevelFish,
	[3] = UnitBossClownFish,
}

function this.EnterFishScene(Camera)
	this.FGParent = UnityEngine.GameObject("FishBox")
	this.FishDic = {}
	this.FishPool = {}
	this.FishTempPool = {}
	this.FishDelayDestroyPool = {}
	this.ListDelayRefreshFishRes = {}
	this.IsInScene = true
	this.CameraFishBox = UnityEngine.GameObject("CameraFishBox")
	this.CameraFishBox.transform.parent = Camera.transform
	this.CameraFishBox.transform.localPosition = Vector3.zero
	this.CameraFishBox.transform.localEulerAngles = Vector3.zero
	this.CameraFishBox.transform.localScale = Vector3.one
	this.enabledCollider = true
	this.IsFirstEnterScene = true
	ClockCtrl.AddEvent(ClockEvent.OnSecond,this.OnSecond)
end

function this.OnSecond()
	local time = Time.time
	--移除应该需要移除的鱼
	for k,fishs in pairs(this.FishDelayDestroyPool) do
		local count = #fishs
		for i=count,1,-1 do
			if(time > fishs[i].DestroyTime) then
				this.DestroyFish(fishs[i])
				table.remove(fishs,i)
			end
		end
	end

	--刷新鱼的模型，每秒至少一条，5秒内刷出所鱼
	local fishCount = #this.ListDelayRefreshFishRes
	if(this.RefreshTotalTime > 0) then
		fishCount = math.ceil(#this.ListDelayRefreshFishRes / this.RefreshTotalTime)
	end

	local index = 1
	local count = 1
	local total = #this.ListDelayRefreshFishRes
	while(count <= fishCount and index <= total)
		do
		local fish = this.ListDelayRefreshFishRes[index]
		if(fish:CheckUpdateFishRes()) then
			--LogColor("#ff0000","刷新鱼资源")
			count = count + 1
		end
		index = index + 1
	end
	for i=count - 1,1,-1 do
		table.remove(this.ListDelayRefreshFishRes,i)
	end

	--更新当前看到的鱼
	this.UpdateVisiableFishNum()
end

function this.ExitFishScene()
	for k,v in pairs(this.FishTempPool) do
		if(v ~= nil) then
			this.DestroyFish(v)
		end
	end

	for k,v in pairs(this.FishDic) do
		this.DestroyFish(v)
	end

	for k,fishs in pairs(this.FishPool) do
		for i,v in pairs(fishs) do
			this.DestroyFish(v)
		end
	end

	for k,fishs in pairs(this.FishDelayDestroyPool) do
		for k,v in pairs(fishs) do
			this.DestroyFish(v)
		end
	end
	this.ListDelayRefreshFishRes = nil

	this.FGParent.transform.parent = nil
	UnityEngine.GameObject.Destroy(this.FGParent)
	UnityEngine.GameObject.Destroy(this.CameraFishBox)
	this.FishPool = nil
	this.FishDelayDestroyPool = nil
	this.FishDic = nil
	this.FishTempPool = nil
	this.FGParent = nil
	this.CameraFishBox = nil
	this.IsInScene = false
	this.IsFirstEnterScene = false
	ClockCtrl.RemoveEvent(ClockEvent.OnSecond,this.OnSecond)
end

--[[function this.SceneAttackFishWay_0(msg,fish,info)
	HelpCtrl.Num(msg)--金币数字
    HelpCtrl.Money(msg)--金币图片
    HelpCtrl.Catch(msg)--捕获UI图片
end

function this.SceneAttackFishWay_1(msg,fish,info)
	if(info == nil)then return end
	local anim = info.animName
	local effectId = info.effectId
	local delay = info.delay
	fish:PlayAnim(anim)

	HelpCtrl.Num(msg)--金币数字
    HelpCtrl.Money(msg)--金币图片
    HelpCtrl.Catch(msg)--捕获UI图片
end

this.SceneAttackFishEffectWay = {
	[0] =  this.SceneAttackFishWay_0,
	[1] =  this.SceneAttackFishWay_1 
}
]]
function this.ShowSceneAttackFishEffect(msg)
    local fish = this.GetFish(msg.fish_obj_id)
    if(fish ~= nil) then
    	fish:OnAttackFinish(msg)
    	--[[local info = fish.fishInfo.break_out_gold[msg.atk_type]
    	if(info == nil) then
    		LogError("fish.xls not find break_out_gold key = "..msg.atk_type.." value!")
    	end
    	this.SceneAttackFishEffectWay[msg.atk_type](msg,fish,info)
    	]]
    end
   
end

function this.EnableAllFishCollider(isEnabled)
	this.enabledCollider = isEnabled
	for k,v in pairs(this.FishDic) do
		if(v ~= nil) then
			v:SetCanBeHit(this.enabledCollider)
		end
	end
end

function this.OnFuncAttackFish(func_type,listFish,pos)
	local listPos = {}
	for i,v in ipairs(listFish) do
		local onlyId = v
		local fish = this.GetFish(onlyId)
		if(fish ~= nil) then
			table.insert(listPos,fish.gameObject.transform.position)
		end
	end
	if(func_type == 1) then	--鱼王
		local startPos = LH.WorldPosToUIPos(pos)
		-- for i=1,#listPos do
		-- 	local endPos = LH.WorldPosToUIPos(listPos[i])
		-- 	FishSceneEffectMgr.ShowMoveEffect(24013,startPos,endPos,1,0)
		-- end
		FishSceneEffectMgr.ShowUIEffectSelfDestroy(24015,startPos,false,-1)
		--更新死亡小鱼身上的特效
		for i,v in ipairs(listFish) do
			local onlyId = v
			local fish = this.GetFish(onlyId)
			if(fish ~= nil) then
				fish:OnUpdateState({{id=1023}})
				--延时死亡
				fish:DelayDie(1)
			end
		end
	elseif(func_type == 2) then	--炸弹鱼
	elseif(func_type == 3) then	--冰冻鱼
	elseif(func_type == 4) then	--闪电鱼
		local startPos = LH.WorldPosToUIPos(pos)
		startPos.z = 10
		for i=1,#listPos do
			local endPos = LH.WorldPosToUIPos(listPos[i])
			endPos.z = 10
			FishSceneEffectMgr.ShowLinkEffect(24062,startPos,endPos,1,0,0)
		end
	end
end

function this.OnUpdateState(refStateInfo)
	local obj_id = refStateInfo.obj_id
	local fish = this.GetFish(obj_id)
	if(fish == nil) then
		LogColor("#ff0000","OnUpdateState",refStateInfo.info_list[1].id)
	end
	if(fish ~= nil) then
		fish:OnUpdateState(refStateInfo.info_list)
	end
end

function this.OnDeleteState(delStateInfo)
	local obj_id = delStateInfo.obj_id
	local fish = this.GetFish(obj_id)
	if(fish ~= nil) then
		fish:OnDeleteState(delStateInfo.id_list)
	end
end

function this.OnServerCreateFish(fishDatas)
	for k,v in ipairs(fishDatas) do
		local fish = this.CreateFish(v)
		fish:SetCanBeHit(this.enabledCollider)
		if(fish ~= nil) then
			if (this.FishDic[fish.obj_id] ~= nil) then
				this.RemoveFish(fish.obj_id)
				LogError("鱼的唯一id已经存在，进行覆盖...  ",v.fish_obj_id,this.FishDic[v.fish_obj_id],#this.FishDic)
			end
			
			this.FishDic[fish.obj_id] = fish
		end
	end
	this.UpdateFishNum()
	this.IsFirstEnterScene = false
end

function this.UpdateFishNum()
	local num = 0
	for k,v in pairs(this.FishDic) do
		if(v ~= nil) then
			num = num + 1
		end
	end
	LH.SetFishCount(num)
end

function this.UpdateVisiableFishNum()
	local num = 0
	for k,v in pairs(this.FishDic) do
		if(v ~= nil and v:GetVisiableInCamera()) then
			num = num + 1
		end
	end
	LH.SetVisiableFishCount(num)
end

function this.CreateFish(fishData)
	--Log("CreateFish,id=",fishData.fish_obj_id)
	local fishId,onlyId,pos = fishData.fish_id,fishData.fish_obj_id,fishData.pos
	if(Res.fish[fishId] == nil) then
		LogColor("#ff0000","找不到鱼的定义ID："..fishId)
		for k,v in pairs(Res.fish) do
			if(v ~= nil) then
				fishId = v.id
				break
			end
		end
	end
	local fishCfg = Res.fish[fishId]
	local name = fishCfg.name
	if this.FishPool[fishId] == nil then
	   	this.FishPool[fishId] = {}
	end
	local fish = nil
	if #this.FishPool[fishId] > 0 then
		fish = this.FishPool[fishId][1]
		table.remove(this.FishPool[fishId],1)
	else
		--fish = UnitFish:New()
		local handle = FishMgr.FishHandleType[fishCfg.handle_type]
		fish = handle.new()
		--fish = UnitFish.new()
		fish:Init(fishId)
	end
	--首次进入场景，立即刷出鱼的模型
	if(this.IsFirstEnterScene) then
		fish:CheckUpdateFishRes()
	else
		--否则，延时刷出鱼的模型
		if(fish.fishRes == nil) then
			--LogColor("#ff0000","进入延时刷新资源")
			table.insert(this.ListDelayRefreshFishRes,fish)
		end
	end
	if(fishData.is_camera == 1) then 
		fish.gameObject.transform.parent = this.CameraFishBox.transform
	else
		fish.gameObject.transform.parent = this.FGParent.transform
	end
	fish:UpdateInfo(fishData)
	fish:UpdateImmadiate(pos)
	fish:SetActive(true)
	--Log("CreateFish,curTotalFishNum:",#this.FishDic,"obj_id:",onlyId,",curPoolFishNum:",#this.FishPool[fish.id])
	 return fish
end 

function this.SyncFishPos(objs,time)
	if(not this.IsInScene) then
		LogError("current is not fishScene,can not sync fish pos")
		return
	end
	for k,v in pairs(objs) do
		local fish = this.FishDic[v.obj_id]
		if (fish ~= nil) then
			--Log("id为:",fish.id,"鱼同步位置")
			--fish:UpdatePos(v.obj_pos)
			if(v.obj_pos.p_x ~= v.obj_pos.p_x) then
				LogColor("#ff0000","同步的鱼的坐标",v.obj_id,v.obj_pos.p_x,v.obj_pos.p_y,v.obj_pos.p_z)
			else
				fish:UpdateCurvePos(v,time)
			end
		--else
		--	LogError("id为"..v.obj_id.."的鱼找不到")
		end
	end
end

function this.OnServerLockFish(fishLockData)
	if(not this.IsInScene) then
		LogError("current is not fishScene,can not sync fish LockData")
		return
	end
	local fish = this.FishDic[fishLockData.fish_id]
	if (fish ~= nil) then
		fish:LockDir(fishLockData.lock_list)
	else
		LogError("[同步lock数据]id为"..fishLockData.fish_id.."的鱼找不到")
	end
end

function this.RemoveFish(onlyId)
	local fish = this.FishDic[onlyId]
	if (fish == nil) then LogError("找不到该移除的鱼",onlyId) return end
	this.FishDic[onlyId] = nil
	this.RemoveOneFish(fish)
	--Log("RemoveFish,curTotalFishNum:",#this.FishDic,"obj_id:",onlyId,",curPoolFishNum:",#this.FishPool[fish.id])
end

function this.OnFishDead(roleId,onlyId)
	local fish = this.FishDic[onlyId]
	if (fish == nil) then LogError("找不到该死的鱼",onlyId) return end
	--播放鱼死亡的特效
	local effectStr = fish.fishInfo.catch_e
	local effectArr = string.Split(effectStr,",")
	local selfEffectId = tonumber(effectArr[1])
	local otherEffectId = tonumber(effectArr[2])
	local effectId
	if(PlayCtrl.IsMainRoleInRoleId(roleId)) then
		effectId = selfEffectId
	else
		effectId = otherEffectId
	end
	if(effectId > 0) then
		local pos = LH.WorldPosToUIPos(fish.gameObject.transform.position)
		FishSceneEffectMgr.ShowUIEffectSelfDestroy(effectId,pos,false,-1)
		--震屏
		if(fish.fishInfo.shake == 1) then
			local shakeParam = fish.fishInfo.shakeParam
			local delay = shakeParam[5]
			if(delay == nil) then delay = 0 end
			CameraMgr.Shake(shakeParam[1],shakeParam[2],shakeParam[3],shakeParam[4],delay)
		end
		--FishSceneEffectMgr.ShowCamera3DEffectSelfDestroy(effectId,fish.gameObject.transform.position)
		if(fish.fishInfo.type == 6) then
			PlaySound(AudioDefine.BossFishSpecialBonus,nil)
		else
			PlaySound(AudioDefine.BigFishSpecialBonus,nil)
		end
	end

	-- if(PlayCtrl.IsMainRoleInRoleId(roleId) and fish.fishInfo.type == UnitFishType.GoldFish) then
	-- 	local playView = UIMgr.Dic("PlayView")
	-- 	if(playView ~= nil) then
	-- 		local startPos = LH.WorldPosToUIPos(fish.gameObject.transform.position)
	-- 		local endPos = playView:GetTreasureBtn().transform.position
	-- 		local parent = playView:GetTreasureBtn()
	-- 		local queue = GetParentPanelRenderQueue(parent)
	-- 		UnitEffectMgr.ShowMoveEffect(parent,24013,23002,startPos,endPos,3,1,queue + 10,nil)
	-- 	end
	-- end
	-- if(PlayCtrl.IsMainRoleInRoleId(roleId) and (fish.fishInfo.type == UnitFishType.BigFish or 
	-- 	fish.fishInfo.type == UnitFishType.EliteFish or 
	-- 	fish.fishInfo.type == UnitFishType.ThemeFish or 
	-- 	fish.fishInfo.type == UnitFishType.BossFish)) then

	-- 	local playView = UIMgr.Dic("PlayView")
	-- 	if(playView ~= nil) then
	-- 		local startPos = LH.WorldPosToUIPos(fish.gameObject.transform.position)
	-- 		local endPos = playView:GetGunUnlockBtn().transform.position
	-- 		local parent = playView:GetGunUnlockBtn()
	-- 		local queue = GetParentPanelRenderQueue(parent)
	-- 		local time = Vector3.Distance(startPos,endPos) / 4 * 5
	-- 		time = math.max(1,time)
	-- 		UnitEffectMgr.ShowMoveEffect(parent,9999,23002,startPos,endPos,time,2.5,queue + 10,nil)
	-- 	end
	-- end
	if(PlayCtrl.IsMainRoleInRoleId(roleId) and fish.fishInfo.id == GlobalDefine.EnergyFishID) then
		local playView = UIMgr.Dic("PlayView")
		if(playView ~= nil) then
			local startPos = LH.WorldPosToUIPos(fish.gameObject.transform.position)
			local endPos = playView.SkillEffectParent.transform.position
			local parent = playView.SkillEffectParent
			local queue = GetParentPanelRenderQueue(parent)
			UnitEffectMgr.ShowMoveEffect(parent,24013,23002,startPos,endPos,1,0,queue + 10,nil)
		end
	end

	this.FishDic[onlyId] = nil
	this.FishTempPool[onlyId] = fish
	fish:Dead(FishMgr.OnDeadAnimFinish)
end

function FishMgr.OnDeadAnimFinish(fish)
	this.FishTempPool[fish.obj_id] = nil
	this.RemoveOneFish(fish)
	--table.insert(this.FishPool[fish.id],fish)
end

--内部使用
function FishMgr.RemoveOneFish(fish)
	fish:Reset()
	fish:SetActive(false)
	--检测当前鱼是否在this.ListDelayRefreshFishRes中
	local count = #this.ListDelayRefreshFishRes
	for i=1,count do
		if(this.ListDelayRefreshFishRes[i].instanceId == fish.instanceId) then
			table.remove(this.ListDelayRefreshFishRes,i)
			break
		end
	end
	if(this.FishPool[fish.id] == nil) then this.FishPool[fish.id] = {} end
	if(this.FishDelayDestroyPool[fish.id] == nil) then this.FishDelayDestroyPool[fish.id] = {} end
	if(#this.FishPool[fish.id] < Res.fish[fish.id].cache_num) then
		table.insert(this.FishPool[fish.id],fish)
	elseif(#this.FishDelayDestroyPool[fish.id] < this.DestroyPoolCapacity) then
		if(#this.FishDelayDestroyPool[fish.id] == 0) then
			fish.DestroyTime = Time.time + this.DelayDestroyTime
		else
			local count = #this.FishDelayDestroyPool[fish.id]
			fish.DestroyTime = this.FishDelayDestroyPool[fish.id][count].DestroyTime + this.DelayDestroyTime
		end
		table.insert(this.FishDelayDestroyPool[fish.id],fish)
	else
		this.DestroyFish(fish)
	end
	this.UpdateFishNum()
end

function FishMgr.DestroyFish(fish)
	fish.gameObject.transform.parent = nil
	fish:Dispose()
	UnityEngine.GameObject.Destroy(fish.gameObject)
end

function this.OnFishBeHit(onlyId)
	local fish = this.FishDic[onlyId]
	if (fish == nil) then LogWarn("找不到受击的鱼",onlyId) return end
	fish:BeHit()
end

function this.GetVisiableFish()
	local result = {}
	for k,v in pairs(this.FishDic) do
		if(v ~= nil)then
			if(v:GetVisiableInCamera()) then
				table.insert(result,k)
			end
		end
	end
	return result
end

function this.GetData(fishOnlyId)
	local fish = this.FishDic[fishOnlyId]
	if (fish == nil) then 
		LogError("[GetData]can not find fish_obj_id:",fishOnlyId)
		return nil 
	end
	return fish.fishInfo
end

function this.GetScreenPos(fishOnlyId)
	local fish = this.FishDic[fishOnlyId]
	if (fish == nil) then
	LogError("[GetScreenPos]can not find fish_obj_id:",fishOnlyId)
	return nil 
	end
	return LH.WorldPosToUIPos(fish.gameObject.transform.position)
end

function this.GetFish(fishOnlyId)
	local fish = this.FishDic[fishOnlyId]
	if (fish == nil) then 
		LogError("[GetFish]can not find fish_obj_id:",fishOnlyId)
		return nil 
	end
	return fish
end