require 'Game/Scene/Unit/UnitEffect'

UnitEffectMgr = {}
local this = UnitEffectMgr
this.EffectPool = {}

this.DicEffectNum = {}

--如果该特效可能出现多次，可使用RecycleEffect方法重用特效，否则，播完后需要自己调用UnitEffect:Dispose方法
--parent:父容器，effectId:特效ID，pos:位置，isLocalPos:是否是局部位置,queue:渲染队列,播放完后的回调（如果配置表中有配置cd，那么将会在cd后回调，否则，立即回调callback(playFinish,effect)）
function this.ShowUIEffectInParent(parent,effectId,pos,isLocalPos,queue,callback)
	local effect = this.CreateEffectObj(effectId,queue)
	effect:Show(parent,pos,isLocalPos,callback)
	return effect
end

--外部创建特效
function this.CreateEffectObj(effectId,queue)
	if(this.container == nil) then
		this.container = UnityEngine.GameObject("UnitEffectContainer")
		UnityEngine.GameObject.DontDestroyOnLoad(this.container)
	end
	local effect = this.CreateEffect(effectId,this.container)
	if(queue ~= nil) then
		effect:UpdateQueue(queue)
	end
	this.AddEffectNum(effect)
	return effect
end

function this.ShowUIEffectInParentByHelper(parent,effectId,pos,queue,lf,lt)
	if(parent == nil)then return end
	local effectInfo = Res.effect[tonumber(effectId)]
	if(effectInfo == nil) then
		LogError("can not find effectId:"..effectId)
		return
	end
	local path = effectInfo.path
	local cd = effectInfo.cd
	local helper = this.GetFinishEffectByPath(parent,path)
	if(helper == nil) then
		local helperGO = UnityEngine.GameObject("Effect_"..effectId)
		Ext.AddChildToParent(parent,helperGO,false)
		helper = helperGO:AddComponent(typeof(UnitEffectHelper))
	end
	helper.transform.localPosition = pos
	helper:ShowEffect(path,queue,cd,lf,lt)
end

function this.ShowMoveEffect(parent,effectId,destEffectId,pos,targetPos,time,delay,queue,callback)
	local effect = this.ShowUIEffectInParent(parent,effectId,pos,false,queue,nil)
	local helper = effect.gameObject:AddComponent(typeof(TargetMoveHelper))
	helper:SetTarget(targetPos,time,delay,this.ShowMoveEffectFinish,{effect,destEffectId,callback})
end

function this.ShowMoveEffectFinish(lt)
	local effect = lt[1]
	local curPos = effect.gameObject.transform.position
	local parent = effect.gameObject.transform.parent.gameObject
	local queue = effect.queue
	local destEffectId = lt[2]
	local callback = lt[3]
	if(effect ~= nil) then
		this.DisposeEffect(effect)
	end
	if(destEffectId > 0) then
		--显示到达特效
		this.ShowUIEffectInParent(parent,destEffectId,curPos,false,queue,this.OnMoveEffectFinish)
	end
	if(callback ~= nil) then
		local temp = callback
		callback = nil
		temp()
	end
end

function this.OnMoveEffectFinish(playFinish,effect)
	if(effect ~= nil) then
		this.DisposeEffect(effect)
	end
end


function this.GetFinishEffectByPath(go,path)
	local trans = go.transform
	local count = trans.childCount

	for i=1,count do
		local helper = trans:GetChild(i - 1):GetComponent("UnitEffectHelper")
		if(helper ~= nil and helper:GetCurrentPath() == path) then
			return helper
		end
	end
	return nil
end

function this.RecycleEffect(effect)
	if(this.EffectPool[effect.id] == nil) then
		this.EffectPool[effect.id] = {}
	end
	effect:Reset()
	if(#this.EffectPool[effect.id] < Res.effect[effect.id].cache_num) then
		table.insert(this.EffectPool[effect.id],effect)
	else
		this.DisposeEffect(effect)
	end
end

function this.DisposeEffect(effect)
	if(effect ~= nil) then
		this.RemoveEffectNum(effect)
		effect:Dispose()
	end
end

function this.CreateEffect(effectId,parent)
	if(this.EffectPool[effectId] == nil) then
		this.EffectPool[effectId] = {}
	end
	local effect
	if(#this.EffectPool[effectId] > 0) then
		effect = this.EffectPool[effectId][1]
		table.remove(this.EffectPool[effectId],1)
	else
		effect = UnitEffect:New()
		effect:Init(effectId,parent)
	end
	return effect
end

function this.ClearPoolEffectByID(effectId)
	local temp = this.EffectPool[effectId]
	if(temp ~= nil) then
		for k,v in pairs(temp) do
			v:Dispose()
		end
		this.EffectPool[effectId] = nil
	end
end

function this.GetCountByEffectID(effectId)
	local temp = this.EffectPool[effectId]
	if(temp ~= nil) then
		return #temp
	end
	return 0
end

function this.AddEffectNum(effect)
	if(this.DicEffectNum[effect.id] == nil )then
		this.DicEffectNum[effect.id] = 1
	else
		this.DicEffectNum[effect.id] = this.DicEffectNum[effect.id] + 1
	end
end

function this.RemoveEffectNum(effect)
	this.DicEffectNum[effect.id] = this.DicEffectNum[effect.id] - 1
end

function this.GetEffectNum()
	local num = 0
	for k,v in pairs(this.DicEffectNum) do
		if(v ~= nil) then
			num = num + v
		end
	end
	for k,v in pairs(this.EffectPool) do
		if(v ~= nil) then
			num = num + #v
		end
	end
	return num
end

function this.GetEffectDesc()
	str = "(poos)"
	for k,v in pairs(this.EffectPool) do
		if(v ~= nil and #v > 0) then
			str = str .. "[id="..k..",num="..#v.."]"
		end
	end
	str = str.. "(dic)"
	for k,v in pairs(this.DicEffectNum) do
		if(v ~= nil and v > 0) then
			str = str .. "[id="..k..",num="..v.."]"
		end
	end
	
	return str
end