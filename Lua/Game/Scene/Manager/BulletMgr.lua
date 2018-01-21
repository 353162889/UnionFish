require 'Game/Scene/Unit/UnitBullet'
BulletMgr = {}

local this = BulletMgr

this.BulletPool = nil
this.BulletTempPool = nil
this.BulletDic = nil
this.BulletContainer = nil
this.SupportObj = nil
this.SupportObjTransform = nil


--子弹场景方面Start
function this.EnterFishScene(parentContainer)
	this.BulletPool = {}
	this.BulletTempPool = {}
	this.BulletDic = {}
	this.BulletContainer = parentContainer
	this.SupportObj = UnityEngine.GameObject("supportObj")
	this.SupportObjTransform = this.SupportObj.transform
	Ext.AddChildToParent(parentContainer,this.SupportObj,false)
	EventMgr.AddEvent(ED.PlayCtrl_S2CSceneObjLeave,this.PlayCtrl_S2CSceneObjLeave)
end

--场景对象离开场景时，移除该对象的所有子弹
function this.PlayCtrl_S2CSceneObjLeave(t)
	local roleObjId = t[1]
	if(not PlayCtrl.IsMainRole(roleObjId)) then
		for k,bullet in pairs(this.BulletDic) do
			if(bullet ~= nil and bullet.role_obj_id == roleObjId) then
				--直接真正回收所有子弹
				this.ServerRecycleBullet(bullet.obj_id)
			end
		end
	end
end

function this.NeedHelpSendBullet()
	-- body
end

function this.ExitFishScene()
	--移除所有子弹
	for k,v in pairs(this.BulletDic) do
		if(v ~= nil) then
			v:Dispose()
		end
	end
	this.BulletDic = nil

	-- for k,v in pairs(this.BulletTempPool) do
	-- 	if(v ~= nil) then
	-- 		v:Dispose()
	-- 	end
	-- end
	this.BulletTempPool = nil

	for k,v in pairs(this.BulletPool) do
		for i,bullet in pairs(v) do
			bullet:Dispose()
		end
	end
	this.BulletPool = nil

	if(this.SupportObj ~= nil) then
		UnityEngine.GameObject.Destroy(this.SupportObj)
		this.SupportObj = nil
		this.SupportObjTransform = nil
	end

	this.BulletContainer = nil
	EventMgr.RemoveEvent(ED.PlayCtrl_S2CSceneObjLeave,this.PlayCtrl_S2CSceneObjLeave)
end
--子弹场景方面End
function this.GetBulletNum(roleObjId)
	local count = 0
	for k,bullet in pairs(this.BulletDic) do
		if(bullet.role_obj_id == roleObjId)then
			count = count + 1
		end
	end
	return count
end

--子弹回收方面Start
function this.ClientRecycleBullet(bulletObjId)
	local bullet = this.BulletDic[bulletObjId]
	if(bullet == nil) then
		LogError("[Client Recycle Bullet in Dic]can not find! bulletObjId:"..bulletObjId)
		return
	end
	local roleObjId = bullet.role_obj_id
	bullet:Reset()
	bullet:SetActive(false)
	this.BulletDic[bulletObjId] = nil

	if(this.BulletTempPool[bulletObjId] ~= nil and this.BulletTempPool[bulletObjId] == true) then
		LogError("[Recycle Bullet in tempPool] exist bullet! bulletObjId:"..bulletObjId)
	end
	this.BulletTempPool[bulletObjId] = true
	--告诉服务器回收子弹
	PlayCtrl.C2SSceneGetBackBullet(roleObjId,bulletObjId)
	if(this.BulletPool[bullet.id] == nil) then
		this.BulletPool[bullet.id] = {}
	end
	if(#this.BulletPool[bullet.id] < Res.bullet[bullet.id].CacheNum) then
		table.insert(this.BulletPool[bullet.id],bullet)
	else
		bullet:Dispose()
	end
end

function this.ServerRecycleBullet(bulletObjId)
	--LogColor("#ff0000","ServerRecycleBullet,bulletObjId:"..bulletObjId)
	local bullet = this.BulletDic[bulletObjId]
	if(bullet == nil) then
		if(this.BulletTempPool[bulletObjId] == nil) then
			LogError("[Server Recycle Bullet in tempPool]can not find! bulletObjId:"..bulletObjId)
			return
		end
		local bulletTemp = this.BulletTempPool[bulletObjId]
		this.BulletTempPool[bulletObjId] = nil
	else
		this.BulletDic[bulletObjId] = nil
		bullet:Reset()
		bullet:SetActive(false)
		if(this.BulletPool[bullet.id] == nil) then
			this.BulletPool[bullet.id] = {}
		end
		if(#this.BulletPool[bullet.id] < Res.bullet[bullet.id].CacheNum) then
			table.insert(this.BulletPool[bullet.id],bullet)
		else
			bullet:Dispose()
		end
	end
end


--子弹回收方面End


--子弹BulletHelper回调方面Start
function this.OnLifeTimeOver(bulletObjId)
	--Log("OnLifeTimeOver,bulletObjId:"..bulletObjId)
	this.ClientRecycleBullet(bulletObjId)
end

function this.OnReboundOver(bulletObjId)
	--Log("OnReboundOver,bulletObjId:"..bulletObjId)
	this.ClientRecycleBullet(bulletObjId)
end

function this.OnHitFish(bulletObjId,fishObjId)
	--Log("OnHitFish,bulletObjId:"..bulletObjId..",fishObjId:"..fishObjId)
	FishMgr.OnFishBeHit(fishObjId)
	local bullet = this.GetBullet(bulletObjId)
	if(bullet == nil) then
		LogError("[OnHitFish]can not find bullet! bulletObjId:"..bulletObjId)
		return
	end
	local roleObjId = bullet.role_obj_id
	local fish = FishMgr.GetFish(fishObjId)
	PlayCtrl.C2SSceneAttackFish(roleObjId,bulletObjId,fishObjId)

	local sound = bullet.bulletInfo.HitSound
	if(sound > 0) then
		PlaySound(sound,nil)
	end

	--判断是否要回收鱼
	if(bullet.bulletHelper.PenetrateNum <= 0)then
		--释放网特效
		FishSceneEffectMgr.ShowUIEffectSelfDestroy(bullet.bulletInfo.NetID,bullet.transform.localPosition,true,-10)
		this.ClientRecycleBullet(bulletObjId)
	end
end

--子弹BulletHelper回调方面End

function this.GetBullet(bulletObjId)
	local bullet = this.BulletDic[bulletObjId]
	if(bullet == nil) then
		Log("[GetBullet]can not find! bulletObjId:"..bulletObjId)
		return nil
	end
	return bullet
end

--子弹同步方面Start
function this.OnBulletTick(curTimestamp)
	local timestamp = curTimestamp / 1000.0
	--LogColor("#ff0000","OnBulletTick,timestamp:"..timestamp)
	for k,bullet in pairs(this.BulletDic) do
		bullet.bulletHelper:SetTargetTimestamp(timestamp + 1.0,1.1)
	end
end
--子弹同步方面End


--子弹创建方面Start
function this.CreateBullet(bulletId)
	local bullet
	if(this.BulletPool[bulletId] == nil) then
		this.BulletPool[bulletId] = {}
	end
	if(#this.BulletPool[bulletId] > 0) then
		bullet = this.BulletPool[bulletId][1]
		table.remove(this.BulletPool[bulletId],1)
	else
		bullet = UnitBullet:New()
		bullet:Init(bulletId)
	end
	bullet:Reset()
	bullet:SetActive(true)
	return bullet
end

function this.LaunchBullet(bulletData,extParam)
	--LogColor("#ff0000","LaunchBullet,bulletData:"..bulletData.bullet_type)
	local timestamp = bulletData.start_time / 1000.0
	local bullets = this.CreateBullets(bulletData,extParam)
	for k,bullet in pairs(bullets) do
		--子弹开始运算
		--子弹计算1s的时间
		if(bullet ~= nil) then
			bullet.bulletHelper:SetTargetTimestamp(timestamp + 1.0,1.1)
		end
	end
end

function this.InitEnterSceneBullet(listBullet,curTimestamp)
	local timestamp = curTimestamp / 1000.0
	--LogColor("#ff0000","InitEnterSceneBullet,listBullet:"..#listBullet.."curTimestamp:"..timestamp)
	if(listBullet ~= nil and #listBullet > 0)then
		for i,bulletData in ipairs(listBullet) do
			local bullets = this.CreateBullets(bulletData,nil)
			if(bullets ~= nil) then
				for k,bullet in pairs(bullets) do
					--子弹开始运算（这个可能会卡）
					if(bullet ~= -1) then
						bullet.bulletHelper:SetTargetTimestamp(timestamp,0)
					end
				end
			end
		end
	end
	--LogColor("#ff0000","子弹初始化结束")
end

--根据服务器信息创建子弹（列表里面可能有空子弹，是已被移除的）
function this.CreateBullets(bulletData,extParam)
	local bulletId = bulletData.bullet_type
	local bulletInfo = Res.bullet[tonumber(bulletId)]
	if(bulletInfo == nil) then
		LogError("找不到后端创建子弹的id",bulletId,"role_obj_id",bulletData.role_obj_id,"start_time",bulletData.start_time)
		return
	end
	
	local bullets = this.BulletCreate[tonumber(bulletInfo.Type)](bulletInfo,bulletData)
	for k,bullet in pairs(bullets) do
		--如果创建子弹成功才初始化值
		if(bullet ~= -1) then
			bullet:UpdateInfo(k,bulletData,extParam)
			bullet:UpdateInitObjInfo(bullet.transform.localPosition,bullet.transform.localEulerAngles,bullet.transform.localScale)
			--将子弹放入总池中
			local bulletObjId = bullet.obj_id
			if (this.BulletDic[bulletObjId] ~= nil) then
				LogError("子弹的唯一id已经存在，进行覆盖...  ",bulletObjId,this.BulletDic[bulletObjId],#this.BulletDic)
			end
			this.BulletDic[bulletObjId] = bullet
		end
	end
	return bullets
end

function this.BulletCreateType1(bulletInfo,bulletData)
	local pos = Vector3.New(bulletData.point_x,bulletData.point_y,0)
	local angle = bulletData.angle
	this.SupportObjTransform.localPosition = pos

	local listBullet = {}
	local bulletId = bulletInfo.id
	for i=1,bulletInfo.Count do
		local bullet = -1
		--后端分配了唯一id的时候才创建子弹（否则就是子弹已被移除）
		if(bulletData.only_key_list[i] > 0) then
			bullet = this.CreateBullet(bulletId)
			Ext.AddChildToParent(this.SupportObj,bullet.gameObject,false)
			bullet.transform.localPosition = Vector3.New(bulletInfo.OffsetX, bulletInfo.OffsetY, 0) - Vector3.New((bulletInfo.Count - 1) * bulletInfo.Space / 2 - (i-1) * bulletInfo.Space, 0, 0)
			this.SupportObjTransform.localEulerAngles = Vector3.New(0, 0, angle + bulletInfo.OffsetR)
			bullet:AttachParent(this.BulletContainer)
			this.SupportObjTransform.localEulerAngles = Vector3.zero
		end
		table.insert(listBullet,bullet)
	end
	return listBullet
end

function this.BulletCreateType2(bulletInfo,bulletData)
	local pos = Vector3.New(bulletData.point_x,bulletData.point_y,0)
	local angle = bulletData.angle
	this.SupportObjTransform.localPosition = pos

	local listBullet = {}
	local bulletId = bulletInfo.id
	for i=1,bulletInfo.Count do
		--后端分配了唯一id的时候才创建子弹（否则就是子弹已被移除）,将该值设为-1
		local bullet = -1
		if(bulletData.only_key_list[i] > 0) then
			bullet = this.CreateBullet(bulletId)
			Ext.AddChildToParent(this.SupportObj,bullet.gameObject,false)
			bullet.transform.localPosition = Vector3.New(bulletInfo.OffsetX, bulletInfo.OffsetY, 0)
			this.SupportObjTransform.localEulerAngles = Vector3.New(0, 0, angle + bulletInfo.OffsetR) - Vector3.New(0, 0, (bulletInfo.Count - 1) * bulletInfo.Space / 2 - (i-1) * bulletInfo.Space)
			bullet:AttachParent(this.BulletContainer)
			this.SupportObjTransform.localEulerAngles = Vector3.zero
		end
		table.insert(listBullet,bullet)
	end
	return listBullet
end

--函数定义要在这个之前
this.BulletCreate = {
	[1] =  this.BulletCreateType1,
	[2] =  this.BulletCreateType2 
}
--子弹创建方面End


