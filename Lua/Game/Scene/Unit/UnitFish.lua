require 'Game/Scene/Component/StateComponent'
require 'Game/Scene/Component/EffectComponent'
require 'Game/Scene/Component/SayComponent'
UnitFish = Class()

function UnitFish:ctor()
	self.tableName = "UnitFish"
	self.stateComponent = StateComponent:New(self)
	self.effectComponent = EffectComponent:New(self)
	self.sayComponent = SayComponent:New(self)
	self.gameObject = UnityEngine.GameObject("fish")
	self.transform = self.gameObject.transform
	self.instanceId = self.gameObject:GetInstanceID()
	self.animMoveHelper = self.gameObject:AddComponent(typeof(AnimCurveMoveHelper))
	self.visiableHelper = nil
	self.monoData = self.gameObject:AddComponent(typeof(MonoData))
	self.AttackFinishSequence = CommandDynamicSequence.new(false)

	self.SceneAttackFishEffectWay = {
		[0] =  Cmd_FishAttackFish_0,
		[1] =  Cmd_FishAttackFish_1 
	}
end

--[[
function UnitFish:New()
	local o = {}
	o.tableName = "UnitFish"
	o.stateComponent = StateComponent:New(o)
	o.gameObject = UnityEngine.GameObject("fish")
	--o.moveHelper = o.gameObject:AddComponent(typeof(FishMoveHelper))
	o.animMoveHelper = o.gameObject:AddComponent(typeof(AnimCurveMoveHelper))
	o.visiableHelper = nil
	o.monoData = o.gameObject:AddComponent(typeof(MonoData))
	setmetatable(o,self)
	self.__index = self
	return o
end
]]

function UnitFish:InitMountPoint()
	self.dicMountPoint = {}
	self:RegisterMountPoint(UnitFishMPType.Center,"CenterMP")
	self:RegisterMountPoint(UnitFishMPType.Bubble,"BubbleMP")
end

function UnitFish:RegisterMountPoint(type,name)
	local mountPoint = UnityEngine.GameObject(name)
	Ext.AddChildToParent(self.gameObject,mountPoint,false)
	self.dicMountPoint[type] = mountPoint
end

function UnitFish:GetMountPoint(type)
	local mountPoint = self.dicMountPoint[type]
	if(mountPoint ~= nil) then
		return mountPoint
	else
		return self.dicMountPoint[UnitFishMPType.Center]
	end
end

function UnitFish:DetachMountPoint()
	for k,v in pairs(self.dicMountPoint) do
		Ext.AddChildToParent(self.gameObject,v,false)
	end
end

function UnitFish:AttachMountPoint()
	if(self.fishRes == nil) then return end
	for k,v in pairs(self.dicMountPoint) do
		local go = LH.GetChildByName(self.fishRes,v.name)
		if(go ~= nil) then
			Ext.AddChildToParent(go,v,true)
			--重置位置与旋转，不重置缩放
			v.transform.localPosition = Vector3.zero
			v.transform.localEulerAngles = Vector3.zero
		end
	end
end

function UnitFish:OnAttackFinish(msg)
	local info = self.fishInfo.break_out_gold[msg.atk_type]
	if(info == nil) then
		LogError("fish.xls not find break_out_gold key = "..msg.atk_type.." value!")
	end
	local cmd = self.SceneAttackFishEffectWay[msg.atk_type].new(msg,info)
	self.AttackFinishSequence:AddSubCommand(cmd)
end

function UnitFish:OnInitState(listStateInfo)
	self.stateComponent:Reset()
	for i,v in ipairs(listStateInfo) do
		self.stateComponent:InitState(v.id,v)
	end
end

function UnitFish:OnUpdateState(listStateInfo)
	for i,v in ipairs(listStateInfo) do
		--LogColor("#ff0000","[OnUpdateState]fishObjID",self.obj_id,"stateID",v.id,"listCount",#listStateInfo)
		self.stateComponent:UpdateState(v.id,v)
	end
end

function UnitFish:OnDeleteState(listStateID)
	for i,v in ipairs(listStateID) do
		--LogColor("#ff0000","[OnDeleteState]fishObjID",self.obj_id,"stateID",v)
		self.stateComponent:RemoveState(v)
	end
end

function UnitFish:Init(fishId)
	self.id = fishId
	self:InitMountPoint()
	local tempT = {}

	self.monoData.data = tempT
	self.fishInfo = Res.fish[fishId]
	local strHitColor = self.fishInfo.h_c
	local t = string.Split(strHitColor,",")
	self.hitColor = Color(tonumber(t[1]) / 255.0,tonumber(t[2]) / 255.0,tonumber(t[3]) / 255.0,tonumber(t[4]) / 255.0)
	self.animName = nil
	self.animSpeed = 1
	tempT.fish_obj_id = nil

	self:Reset()

	--self:UpdateFishRes(self.fishInfo.res)
end

function UnitFish:CheckUpdateFishRes()
	if(self.resPath == nil) then
		self:UpdateFishRes(self.fishInfo.res)
		return true
	end
	return false
end

function UnitFish:UpdateFishRes(path)
	if(self.resPath ~= nil) then
		if(self.resPath == path and self.fishRes ~= nil) then return end
		ResourceMgr.RemoveListenerInLua(self.resPath,self.resLoad)
		self.resPath = nil
		self.OnResLoaded = nil
	end
	self.resPath = path
	self.resLoad = function (res)
		self:OnResLoaded(res)
	end
	ResourceMgr.GetResourceInLua(self.resPath,self.resLoad)
end

function UnitFish:OnResLoaded( res )
	if(self.fishRes ~= nil) then
		self:DetachMountPoint()
		self.visiableHelper = nil
		self.fishRes.name = nil
		self.fishRes.transform.parent = nil
		self.animator = nil
		UnityEngine.GameObject.Destroy(self.fishRes)
		self.fishRes = nil
	end
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	self.Res = res
	self.Res:Retain()
	local obj = Resource.GetGameObject(res,self.resPath)
	local fish = self
	fish.fishRes = obj
	local fishResTransform = fish.fishRes.transform
	fishResTransform.parent = fish.transform
	fishResTransform.localPosition = Vector3.zero
	fishResTransform.localRotation = Quaternion.identity
	self:AttachMountPoint()
	fish.animator = obj:GetComponent("Animator")
	fish:SetCanBeHit(self.enableCollider)
	local renderGO = LH.GetChildRender(fish.fishRes.gameObject)
	fish.visiableHelper = renderGO:AddComponent(typeof(VisiableHelper))
	if(Ext.HasColorInShader(fish.gameObject)) then
		fish.defaultColor = Ext.GetColor(fish.gameObject)
	end
	if(fish.animName ~= nil) then
		fish:PlayAnim(fish.animName)
	end
	fish.alphaHelper = renderGO:AddComponent(typeof(ModelAlphaHelper))
	fish:SetAnimSpeed(fish.animSpeed)
	fish:UpdateLayer()
	self.resPath = nil
	self.resLoad = nil
end

function UnitFish:GetVisiableInCamera()
	return self.visiableHelper ~= nil and self.visiableHelper.isVisiable
end

function UnitFish:UpdateLayer()
	if(self.isCamera == 1) then
		LH.SetLayer(self.gameObject,UnitFishLayer.CameraFishLayer)
	else
		LH.SetLayer(self.gameObject,UnitFishLayer.FishLayer)
	end
end

function UnitFish:UpdateInfo(fishData)
	local onlyId = fishData.fish_obj_id
	self.obj_id = onlyId
	self.isCamera = fishData.is_camera
	local tempT = self.monoData.data
	tempT.fish_obj_id = onlyId
	self.gameObject.name = "fish_"..self.id.."_"..onlyId

	--初始化开始运动的时间戳
	local timestamp = tonumber(fishData.pos.res_time / 1000.0)
	self.startTimestamp = timestamp
	self.endTimestamp = timestamp

	self.isLock = (tonumber(fishData.lock_list.lock_type) == 1)
	if(self.isLock) then
		--设置与的转向
		local x,y,z = fishData.lock_list.n_x,fishData.lock_list.n_y,fishData.lock_list.n_z
		if(not IsZero(math.abs(x)) or not IsZero(math.abs(y)) or not IsZero(math.abs(z))) then
			local dir = Vector3.New(x,y,z)
			local desRotation = Quaternion.LookRotation(dir)
			self.transform.localRotation = desRotation
		end
		self.animMoveHelper:LockTrans(nil)
	end
	if(fishData.status_info_list ~= nil) then
		self:OnInitState(fishData.status_info_list)
	end
	self:UpdateLayer()
end

function UnitFish:Reset()
	
	if(self.stateComponent ~= nil) then
		self.stateComponent:Reset()
	end
	if(self.effectComponent ~= nil) then
		self.effectComponent:Reset()
	end
	if(self.sayComponent ~= nil) then
		self.sayComponent:Reset()
	end
	self.animMoveHelper:Clear()
	self:StopCoroutine()
	self.obj_id = -1
	self.isCamera = -1
	self.transform.localPosition = Vector3.New(0,0,0)
	self.transform.localRotation = Quaternion.identity
	self.startTimestamp = -1		--开始运动的时间戳
	self.endTimestamp = -1			--结束运动的时间戳
	self.isLock = false
	self.enableCollider = true
	self.animName = nil
	self.animSpeed = 1
	if(self.fishRes ~= nil and Ext.HasColorInShader(self.gameObject) and self.defaultColor ~= nil) then
		Ext.SetColor(self.gameObject,self.defaultColor)
	end
	self.frozenRemainCurve = nil
	self.DelayDieTime = nil
	self.AttackFinishSequence:Clear()
	if(self.alphaHelper ~= nil) then
		self.alphaHelper:Reset()
	end
	-- self.monoData.data.data.fish_obj_id = -1
end

function UnitFish:SetCanBeHit(isCanBeHit)
	self.enableCollider = isCanBeHit
	LH.EnableCollider(self.gameObject,self.enableCollider)
end


function UnitFish:Dispose()
	if(self.Res ~= nil) then
		self.Res:Release()
		self.Res = nil
	end
	if(self.stateComponent ~= nil) then
		self.stateComponent:Clear()
		self.stateComponent = nil
	end
	if(self.effectComponent ~= nil) then
		self.effectComponent:Clear()
		self.effectComponent = nil
	end
	if(self.sayComponent ~= nil) then
		self.sayComponent:Clear()
		self.sayComponent = nil
	end
	self:StopCoroutine()
	self.id = -1
	self.obj_id = -1
	self.isCamera = -1
	self.startTimestamp = -1		--开始运动的时间戳
	self.endTimestamp = -1			--结束运动的时间戳

	self.animator = nil
	if(self.fishRes ~= nil) then
		self.visiableHelper = nil
		self.fishRes.name = nil
		self.fishRes.transform.parent = nil
		UnityEngine.GameObject.Destroy(self.fishRes)
		self.fishRes = nil
	else
		if(self.resPath ~= nil) then
			ResourceMgr.RemoveListenerInLua(self.resPath,self.resLoad)
			self.resPath = nil
			self.OnResLoaded = nil
		end
	end	
	UnityEngine.GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil
	self.fishInfo = nil
	self.monoData = nil
	self.frozenRemainCurve = nil
	if(self.AttackFinishSequence ~= nil) then
		self.AttackFinishSequence:OnDestroy()
		self.AttackFinishSequence = nil
	end
	self.CurListPos = nil
end

function UnitFish:StopCoroutine()
	if(self.beHitAnimCoroutine ~= nil) then
		coroutine.stop(self.beHitAnimCoroutine)
		self.beHitAnimCoroutine = nil
	end
	if(self.beHitColorCoroutine ~= nil) then
		coroutine.stop(self.beHitColorCoroutine)
		self.beHitColorCoroutine = nil
	end
	if(self.diedAnimCoroutine ~= nil) then
		coroutine.stop(self.diedAnimCoroutine)
		self.diedAnimCoroutine = nil
	end
end

function UnitFish:LockDir(lockPoslist)
	self.isLock = (tonumber(lockPoslist.lock_type) == 1)
	if(self.isLock)then
		self.animMoveHelper:LockTrans(nil)
	else
		self.animMoveHelper:UnLock()
	end
end

function UnitFish:BeFrozen()
	-- local remainCurves = self.animMoveHelper:GetRemainCurve()
	-- local remainCount = remainCurves.Count
	-- local listPos = {}
	-- local subTimestamp = self.endTimestamp - self.startTimestamp
	-- if(self.endTimestamp > 0 and subTimestamp >= 0 and remainCount > 0) then
	-- 	for i=1,remainCount do
	-- 		local remain = remainCurves[i - 1]
	-- 		local time = remain.time
	-- 		local x = remain.x
	-- 		local y = remain.y
	-- 		local z = remain.z
	-- 		local realTimestamp = self.startTimestamp  + time * subTimestamp / 1.2
	-- 		local temp = {realTimestamp,x,y,z}
	-- 		table.insert(listPos,temp)
	-- 	end
	-- end

	local listPos = {}
	local subTimestamp = self.endTimestamp - self.startTimestamp
	if(self.endTimestamp > 0 and subTimestamp >= 0) then
		local time = self.animMoveHelper:GetCurTime()
		local pos = self.transform.localPosition
		local realTimestamp = self.startTimestamp  + time * subTimestamp / 1.2
		local temp = {realTimestamp,pos.x,pos.y,pos.z}
		table.insert(listPos,temp)
		if(self.CurListPos ~= nil) then
			--local index = self.animMoveHelper:GetRemainCurveIndex()
			for i=1,#self.CurListPos do
				local curTemp = self.CurListPos[i]
				if(curTemp[1] > time) then
					curTemp[1] = self.startTimestamp  + curTemp[1] * subTimestamp / 1.2
					table.insert(listPos,curTemp)
				end
			end
		end
		self.CurListPos = nil
	end

	if(#listPos > 0) then
		local minTimestamp = listPos[1][1]
		for i=1,#listPos do
			listPos[i][1] = listPos[i][1] - minTimestamp
		end
	end
	self.frozenRemainCurve = listPos
	self.animMoveHelper:StopMove()
	self:SetAnimSpeed(0)
end

function UnitFish:UnBeFrozen(timestamp)
	if(self.frozenRemainCurve ~= nil) then
		local listPos = self.frozenRemainCurve
		self.frozenRemainCurve = nil
		if(#listPos < 1)then return end
		local maxTimestamp = listPos[#listPos][1]
		for i=1,#listPos do
			--转换为当前时间戳
			listPos[i][1] = listPos[i][1] - maxTimestamp + timestamp / 1000.0
		end

		self.startTimestamp = listPos[1][1]
		self.endTimestamp = listPos[#listPos][1]
		subTimestamp = self.endTimestamp - self.startTimestamp
		for i=1,#listPos do
			if(subTimestamp <= 0) then
				listPos[i][1] = 0
			else
				listPos[i][1] = (listPos[i][1] - self.startTimestamp) / subTimestamp * 1.2
			end
		end

		--self.animMoveHelper:SetCurve(listPos)

		self.animMoveHelper:BeginSetCurve()
		for i=1,#listPos do
			self.animMoveHelper:SetOneCurve(listPos[i][1],listPos[i][2],listPos[i][3],listPos[i][4])
		end
		self.animMoveHelper:EndSetCurve()
		self.CurListPos = listPos
	end
	self:SetAnimSpeed(1)
end

function UnitFish:UpdateCurvePos(objPos,timestamp)
	--if(#serverPosData <= 0) then return end
	local listPos = {}
	local subTimestamp = self.endTimestamp - self.startTimestamp
	if(self.endTimestamp > 0 and subTimestamp >= 0) then
		local time = self.animMoveHelper:GetCurTime()
		local pos = self.transform.localPosition
		local realTimestamp = self.startTimestamp  + time * subTimestamp / 1.2
		local temp = {realTimestamp,pos.x,pos.y,pos.z}
		table.insert(listPos,temp)
		if(self.CurListPos ~= nil) then
			--local index = self.animMoveHelper:GetRemainCurveIndex()
			for i=1,#self.CurListPos do
				local curTemp = self.CurListPos[i]
				if(curTemp[1] > time) then
					curTemp[1] = self.startTimestamp  + curTemp[1] * subTimestamp / 1.2
					table.insert(listPos,curTemp)
				end
			end
		end
		self.CurListPos = nil
	end

	-- local remainCurves = self.animMoveHelper:GetRemainCurve()
	-- local remainCount = remainCurves.Count
	-- local listPos = {}
	-- local subTimestamp = self.endTimestamp - self.startTimestamp
	-- if(self.endTimestamp > 0 and subTimestamp >= 0 and remainCount > 0) then
	-- 	for i=1,remainCount do
	-- 		local remain = remainCurves[i - 1]
	-- 		local time = remain.time
	-- 		local x = remain.x
	-- 		local y = remain.y
	-- 		local z = remain.z
	-- 		local realTimestamp = self.startTimestamp  + time * subTimestamp / 1.2
	-- 		local temp = {realTimestamp,x,y,z}
	-- 		table.insert(listPos,temp)
	-- 	end
	-- end

	--获取到服务器的所有节点与位置，将其插入到listPos中
	if(objPos.fish_old_step_list ~= nil and #objPos.fish_old_step_list > 0) then
		--local str = ""
		local tempIndex = 1
		for i,v in ipairs(objPos.fish_old_step_list) do
			if(tempIndex ~= 1) then
				local temp = {tonumber(v.res_time / 1000.0),v.p_x,v.p_y,v.p_z}
				--str = str .. "(".. tonumber(v.res_time / 1000.0) ..",".. v.p_x .. "," .. v.p_y .. "," ..v.p_z ..")"
				table.insert(listPos,temp)
			end
			tempIndex = tempIndex + 1
		end
		--LogColor("#ff0000",str)
	end
	--LogColor("#ff0000","timestamp",tonumber(timestamp/1000.0))

	local temp = {tonumber(timestamp/1000.0),objPos.obj_pos.p_x,objPos.obj_pos.p_y,objPos.obj_pos.p_z}
	local hasSameTimeStamp = false
	for i=#listPos,1,-1 do
		if(listPos[i][1] == temp[1]) then
			--table.remove(listPos,i)
			hasSameTimeStamp = true
			--LogColor("#ff0000","时间戳相等","索引",i,"总数量",#listPos)
		end
	end
	table.insert(listPos,temp)

	--将listPos排序(如果后端给的是有顺序的，不需要排序)排序要保证稳定（相等的时候）
	table.sort(listPos, function (a,b) 
		if(a[1] == b[1]) then 
			return false 
		end
		return a[1] < b[1] 
	end )

	--更新最新的最小时间戳和最大时间戳
	if(#listPos < 1) then return end
	if(math.abs(listPos[1][1] - listPos[#listPos][1]) < 0.0001)then
		--[[LogColor("#ff0000","时间相等","#listPos",#listPos)
		if(math.abs(listPos[1][2] - listPos[#listPos][2]) < 0.0001 and math.abs(listPos[1][3] - listPos[#listPos][3]) < 0.0001 and math.abs(listPos[1][4] - listPos[#listPos][4]) < 0.0001) then
			LogColor("#ff0000","位置相等")
		else
			LogColor("#ff0000","位置不相等")
		end]]
	 	return 
	end
	self.startTimestamp = listPos[1][1]
	self.endTimestamp = listPos[#listPos][1]
	subTimestamp = self.endTimestamp - self.startTimestamp
	for i=1,#listPos do
		if(subTimestamp <= 0) then
			listPos[i][1] = 0
		else
			listPos[i][1] = (listPos[i][1] - self.startTimestamp) / subTimestamp * 1.2
		end
	end

	--self.animMoveHelper:SetCurve(listPos)
	self.animMoveHelper:BeginSetCurve()
	for i=1,#listPos do
		self.animMoveHelper:SetOneCurve(listPos[i][1],listPos[i][2],listPos[i][3],listPos[i][4])
	end
	-- for i,v in ipairs(listPos) do
	-- 	self.animMoveHelper:SetOneCurve(v[1],v[2],v[3],v[4])
	-- end
	self.animMoveHelper:EndSetCurve()
	self.CurListPos = listPos
end

--显示自身特效（不用status管理特效时，可用这个）
function UnitFish:ShowEffect(effectId,mountPointType)
	if(self.effectComponent ~= nil) then
		local layer
		if(self.isCamera == 1) then
			layer = UnitFishLayer.CameraFishLayer
		else
			layer = UnitFishLayer.FishLayer
		end
		self.effectComponent:ShowEffect(effectId,layer,mountPointType)
	end
end

function UnitFish:Say(offset,txt,time)
	if(self.sayComponent ~= nil) then
		self.sayComponent:Say(offset,txt,time)
	end
end


function UnitFish:UpdateImmadiate(pos)
	if(pos.p_x ~= pos.p_x) then
		LogError("收到的鱼同步坐标为Nan")
		return
	end

	self.transform.localPosition = Vector3.New(pos.p_x,pos.p_y,pos.p_z)
end

function UnitFish:SetActive(active)
	self.gameObject:SetActive(active)
end

function UnitFish:PlayAnim(anim)
	local animName = anim
	if(self.animator ~= nil) then
		self.animator:Play(tostring(animName))
	end
	self.animName = anim
	if(#self.fishInfo.anim_e > 0) then
		for k,v in pairs(self.fishInfo.anim_e) do
			if(v.AnimName == anim) then
				self:ShowEffect(v.EffectID,v.MountPointType)
				break
			end
		end
	end
end

function UnitFish:CanPlayAnim(anim)
	return true
end

function UnitFish:IsCurAnim(animName)
	if(self.animator ~= nil) then
		local stateInfo = self.animator:GetCurrentAnimatorStateInfo(0)
		local shortHash = stateInfo.shortNameHash
		if(shortHash == UnityEngine.Animator.StringToHash(animName)) then
			return true
		end
	end
	return false
end

function UnitFish:SetAnimSpeed(speed)
	if(self.animator ~= nil) then
		self.animator.speed = speed
	end
	self.animSpeed = speed
end

function UnitFish:SetAnimSpeedTemp(speed)
	if(self.animator ~= nil) then
		self.animator.speed = speed
	end
end

function UnitFish:IsCanBeHit()
	if(self.stateComponent ~= nil) then
		if(self.stateComponent:HasStateType(StateComponent.StateType.Invincible)) then
			return false
		end
	end
	return true
end

function UnitFish:IsCanBeHitAnim()
	if(self.beHitAnimCoroutine ~= nil) then
		--死亡不做受击动作
		return false
	end
	if(self:IsCurAnim(UnitFishAnim.standby01) or self:IsCurAnim(UnitFishAnim.standby02)) then
		--特殊动作不做受击动作
		return false
	end
	return true
end

function UnitFish:IsCanBeHitColor()
	if(self.beHitColorCoroutine ~= nil or self.defaultColor == nil) then
		--死亡不做受击动作颜色
		return false
	end
	return true
end

function UnitFish:BeHit()
	if(not self:IsCanBeHit()) then return end

	if(self:IsCanBeHitAnim()) then 
		self.beHitAnimCoroutine = coroutine.start(self.BeHitAnimCoroutine,self)
	end
	
	if(Ext.HasColorInShader(self.gameObject))then
		if(self:IsCanBeHitColor()) then
			self.beHitColorCoroutine = coroutine.start(self.BeHitColorCoroutine,self)
		end
	end
end

function UnitFish.BeHitAnimCoroutine(self)
	--临时将播放速度改为1
	self:SetAnimSpeedTemp(1)
	self:PlayAnim(UnitFishAnim.hit)
	coroutine.wait(self.fishInfo.h_a_t)
	--将动画播放速度改回原来
	self:SetAnimSpeed(self.animSpeed)
	self:PlayAnim(UnitFishAnim.standby01)
	--播放鱼的声音
	if(self.fishInfo.sound_id > 0) then
		FishSoundMgr.PlayFishSound(self)
	end
	

	if(self.fishInfo.h_t > self.fishInfo.h_a_t) then
		coroutine.wait(self.fishInfo.h_t - self.fishInfo.h_a_t)
	end
	
	self.beHitAnimCoroutine = nil
end

function UnitFish.BeHitColorCoroutine(self)
	Ext.SetColor(self.gameObject,self.hitColor)
	coroutine.wait(self.fishInfo.h_c_t)
	Ext.SetColor(self.gameObject,self.defaultColor)
	self.beHitColorCoroutine = nil
end

function UnitFish:DelayDie(time)
	self.DelayDieTime = time
end

function UnitFish:Dead(callback)
	if(self.diedAnimCoroutine ~= nil) then return end
	--死亡时停止受击动作
	if(self.beHitAnimCoroutine ~= nil) then
		coroutine.stop(self.beHitAnimCoroutine)
		self.beHitAnimCoroutine = nil
	end
	if(self.beHitColorCoroutine ~= nil) then
		coroutine.stop(self.beHitColorCoroutine)
		if(self.defaultColor ~= nil) then
			Ext.SetColor(self.gameObject,self.defaultColor)
		end
		self.beHitColorCoroutine = nil
	end
	if(self.stateComponent ~= nil) then
		self.stateComponent:OnTriggerTime(StateComponent.TriggerTimeEnum.FishDead)
		self.stateComponent:ClearByTime(StateComponent.ClearTimeEnum.FishDead)
	end
	if(self.AttackFinishSequence ~= nil) then
		self.AttackFinishSequence:Clear()
	end
	--不再移动
	--self.moveHelper.moveSpeed = 0
	--self.moveHelper.rotateSpeed = 0
	--停止移动
	self.animMoveHelper:Clear()
	self:SetCanBeHit(false)
	self.diedAnimCoroutine = coroutine.start(self.DiedAnimCoroutine,self,callback)
end

function UnitFish.DiedAnimCoroutine(self,callback)
	self:SetAnimSpeedTemp(1)
	if(self.DelayDieTime ~= nil and self.DelayDieTime > 0) then
		coroutine.wait(self.DelayDieTime)
	end
	self:PlayAnim(UnitFishAnim.dead)
	coroutine.wait(self.fishInfo.d_t * 0.5)
	if(self.alphaHelper ~= nil) then
		self.alphaHelper:TransAlpha(0,self.fishInfo.d_t * 0.5)
	end
	coroutine.wait(self.fishInfo.d_t * 0.5)
	self:SetCanBeHit(true)
	if(callback ~= nil) then
		local temp = callback
		callback = nil
		temp(self)
	end
	self.diedAnimCoroutine = nil
end




