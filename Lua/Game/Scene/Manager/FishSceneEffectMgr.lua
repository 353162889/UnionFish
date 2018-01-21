require 'Game/Scene/Unit/UnitEffect'

FishSceneEffectMgr = {}
local this = FishSceneEffectMgr
this.EffectPool = {}
this.EffectDic = {}
this.uiContainer = nil
this.cameraContainer = nil
this.sceneContainer = nil
this.DicPoolNum = {
	
}

function this.EnterFishScene(uiContainer,camera)
	this.uiContainer = uiContainer
	this.cameraContainer = UnityEngine.GameObject("cameraContainer")
	this.sceneContainer = UnityEngine.GameObject("sceneContainer")
	this.cameraContainer.transform.parent = camera
	this.EffectPool = {}
	this.EffectDic = {}
	local uiPanel = uiContainer.transform.parent:GetComponent("UIPanel")
	this.startQueue = uiPanel.startingRenderQueue
end

function this.ExitFishScene()
	for k,effects in pairs(this.EffectPool) do
		for k,v in pairs(effects) do
			v:Dispose()
		end
	end
	this.EffectPool = nil
	for k,v in pairs(this.EffectDic) do
		v:Dispose()
	end
	this.EffectPool = {}
	this.EffectDic = {}
	this.uiContainer = nil
	UnityEngine.GameObject.Destroy(this.cameraContainer)
	UnityEngine.GameObject.Destroy(this.sceneContainer)
	this.cameraContainer = nil
end

function this.AddEffect(effect)
	this.EffectDic[effect.obj_id] = effect
end

--显示UI特效，根据特效时间自我销毁（默认父容器是ui的最底层）
function this.ShowUIEffectSelfDestroy(effectId,pos,isLocalPos,offsetQueue)
	local effect = this.CreateEffect(effectId,this.uiContainer)
	effect:UpdateQueue(this.startQueue + offsetQueue)
	this.AddEffect(effect)
	effect:Show(this.uiContainer,pos,isLocalPos,this.OnShowEffectFinish)
	return effect
end
--显示相机3D特效，根据特效时间自我销毁（挂载相机下，并离相机一定距离）此效果将只能用镜头鱼的相机看到（改变层次）
function this.ShowCamera3DEffectSelfDestroy(effectId,pos)
	local effect = this.CreateEffect(effectId,this.cameraContainer)
	this.AddEffect(effect)
	local camera = LH.GetMainCamera()
	local screenPos = camera:WorldToScreenPoint(pos)
	if(effect.effectInfo.param.zOffset ~= nil) then
		screenPos.z = tonumber(effect.effectInfo.param.zOffset)
	else
		screenPos.z = 0
	end
	local showPos = camera:ScreenToWorldPoint(screenPos)
	effect:UpdateLayer(LayerMask.NameToLayer("CameraFish"))
	effect:Show(this.cameraContainer,showPos,false,this.OnShowEffectFinish)
	return effect
end

function this.ShowMoveEffect(effectId,pos,targetPos,time,offsetQueue)
	local effect = this.CreateEffect(effectId,this.uiContainer)
	effect:UpdateQueue(this.startQueue + offsetQueue)
	this.AddEffect(effect)
	effect:Show(this.uiContainer,pos,false,nil)
	local helper = effect.gameObject:AddComponent(typeof(TargetMoveHelper))
	helper:SetTarget(targetPos,time,0,this.ShowMoveEffectFinish,{effect})
end

function this.ShowMoveEffectFinish(lt)
	local effect = lt[1]
	if(effect ~= nil) then
		this.EffectDic[effect.obj_id] = nil
		effect:Dispose()
	end
end

function this.ShowLinkEffect(effectId,startPos,targetPos,time,delay,offsetQueue)
	local effect = this.CreateEffect(effectId,this.uiContainer)
	effect:UpdateQueue(this.startQueue + offsetQueue)
	this.AddEffect(effect)
	local helper = effect.gameObject:GetComponent("EffectLinkHelper")
	if(helper == nil) then
		helper = effect.gameObject:AddComponent(typeof(EffectLinkHelper))
	end
	helper:SetStartAndEnd(startPos,targetPos)
	effect:ShowByTime(this.uiContainer,startPos,time,delay,this.OnShowEffectFinish)
	--effect:ShowByTime(this.uiContainer,startPos,time,delay,nil)
end

function this.ShowSceneEffect(effectId,pos,time,delay)
	local effect = this.CreateEffect(effectId,this.sceneContainer)
	effect:UpdateLayer(LayerMask.NameToLayer("CameraFish"))
	this.AddEffect(effect)
	effect:ShowByTime(this.sceneContainer,pos,time,delay,this.OnShowEffectFinish)
	return effect
end

function this.OnShowEffectFinish(playFinish,effect)
	if(playFinish) then
		this.RecycleEffect(effect)
	end
end

function this.RecycleEffect(effect)
	this.EffectDic[effect.obj_id] = nil
	if(this.EffectPool[effect.id] == nil) then
		this.EffectPool[effect.id] = {}
	end
	effect:Reset()
	if(#this.EffectPool[effect.id] < Res.effect[effect.id].cache_num) then
		table.insert(this.EffectPool[effect.id],effect)
	else
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


function this.GetEffectNum()
	local num = 0
	for k,v in pairs(this.EffectDic) do
		if(v ~= nil) then
			num = num + 1
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
	local str = "(pool)"
	for k,v in pairs(this.EffectPool) do
		if(v ~= nil and #v > 0) then
			str = str .. "[id="..k..",num="..#v.."]"
		end
	end
	str = str .. "(dic)"
	local temp = {}
	for k,v in pairs(this.EffectDic) do
		if(v ~= nil) then
			if(temp[k] == nil) then temp[k] = 0 end
			temp[k] = temp[k] + 1
		end
	end
	for k,v in pairs(temp) do
		str = str .. "[id="..k..",num="..v.."]"
	end
	return str
end