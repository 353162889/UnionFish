UnitBullet = {}
function UnitBullet:New()
	local o = {}
	o.tableName = "UnitBullet"
	o.gameObject = UnityEngine.GameObject("bullet")
	o.isActive = o.gameObject.activeSelf
	o.transform = o.gameObject.transform
	o.multiResLoader = MultiResLoader:New()
	o.bulletHelper = Ext.AddComponentOnce(o.gameObject,typeof(BulletHelper));
	o.parent = nil
	setmetatable(o,self)
	self.__index = self
	return o
end

function UnitBullet:Init(bulletId)
	self.id = bulletId
	self.bulletInfo = Res.bullet[tonumber(bulletId)]
	local bulletResId = self.bulletInfo.BulletID
	self.bulletPath = "Bullet/Pre/" .. bulletResId..".prefab"
	self.bulletEffectPath = Res.effect[bulletResId].path
	self:Reset()

	local names = {}
	table.insert(names,self.bulletPath)
	table.insert(names,self.bulletEffectPath)

	self.OnResLoadComplete = function (loader)
		self:OnResLoadedFinish(loader)
	end
	self.multiResLoader:LoadResList(names,self.OnResLoadComplete,nil)
end

--index是子弹个数里面的第几个,bulletData是服务端发送的子弹数据,extParam是子弹的额外参数具体参数
function UnitBullet:UpdateInfo(index,bulletData,extParam)
	--LogColor("#ff0000","UpdateInfo",index,"timestamp:",(bulletData.start_time / 1000.0))
	self.bulletData = bulletData
	self.index = index
	self.obj_id = bulletData.only_key_list[index]
	self.role_obj_id = bulletData.role_obj_id
	self.gameObject.name = "bullet_"..bulletData.role_obj_id.."_"..self.id.."_"..self.obj_id
	--更新bulletHelper的数据
	local helper = self.bulletHelper
	local bulletInfo = self.bulletInfo
	helper.IsSelf = PlayCtrl.IsMainRole(self.role_obj_id)
	helper.RoleObjId = self.role_obj_id
	helper.BulletObjId = self.obj_id
	helper.BirthTimestamp = bulletData.start_time / 1000.0		--赋值初始时间戳
	helper.DefineId = bulletInfo.id
	helper.Type = bulletInfo.Type
	helper.Index = index
	helper.ReboundNum = bulletInfo.ReboundNum
	helper.LifeTime = bulletInfo.LifeTime
	helper.PenetrateNum = bulletInfo.PenetrateNum
	helper.PenetrateSpace = bulletInfo.PenetrateSpace
	helper.GunFace = bulletInfo.GunFace
	local speedRate = BulletExtParam.GetValue(BulletExtParam.SpeedRate)
	local speed = bulletInfo.Speed
	if(speedRate ~= nil) then
		speed = speed * speedRate
	end
	if(bulletData.speed ~= nil) then
		speed = speed * bulletData.speed
	end
	helper.Speed = speed
	helper.AccSpeed = bulletInfo.AccSpeed
	helper.AccTime = bulletInfo.AccTime
	helper.WidthSpeed = bulletInfo.WidthSpeed
	helper.WidthTime = bulletInfo.WidthTime
	helper.HeightSpeed = bulletInfo.HeightSpeed
	helper.HeightTime = bulletInfo.HeightTime
	helper.AddX = bulletInfo.AddX
	helper.AddXTime = bulletInfo.AddXTime
	helper.AddY = bulletInfo.AddY
	helper.AddYTime = bulletInfo.AddYTime
	helper.AddTurn = bulletInfo.AddTurn
	helper.AddTurnTime = bulletInfo.AddTurnTime
	helper.AddSpeed = bulletInfo.AddSpeed
	helper.AddSpeedTime = bulletInfo.AddSpeedTime
	helper.LifeOver = bulletInfo.LifeOver
	helper.HitOver = bulletInfo.HitOver
	helper.MinUpdateTime = 0.03
	helper.MaxRayDistance = 1000
	helper:Init()
end

--更新子弹的初始信息
function UnitBullet:UpdateInitObjInfo(initPos,initAngle,initScale)
	self.initPos = initPos
	self.initAngle = initAngle
	self.initScale = initScale
end

function UnitBullet:OnResLoadedFinish(loader)
	local res = loader:TryGetRes(self.bulletPath,nil)
	local obj = Resource.GetGameObject(res,self.bulletPath)
	Ext.AddChildToParent(self.gameObject,obj,false)
	self.bulletHelper.RayGo = obj

	res = loader:TryGetRes(self.bulletEffectPath,nil)
	obj = Resource.GetGameObject(res,self.bulletEffectPath)
	Ext.AddChildToParent(self.gameObject,obj,false)
	self:UpdateSortingOrder()
end

function UnitBullet:SetActive(active)
	self.isActive = active
	self.bulletHelper.enabled = active
	if(not active) then
		self.gameObject.transform.localPosition = Vector3.New(10000,0,0)
	end
	--self.gameObject:SetActive(active)
end

function UnitBullet:AttachParent(parent)
	self.parent = parent
	Ext.AddChildToParent(parent,self.gameObject,true)
	--self:UpdateRenderQueueByParent(parent,-20)
end

function UnitBullet:UpdateSortingOrder()
	-- body
	local bulletResId = self.bulletInfo.BulletID
	LH.SetSortingOrder(self.gameObject,Res.effect[bulletResId].order_offset)
end

function UnitBullet:UpdateRenderQueueByParent(parent,queue)
	--更改特效的渲染层次
	--这里拿parent的parent才能拿到UIPanel
	local uiPanel = parent.transform.parent:GetComponent("UIPanel")
	if(uiPanel ~= nil) then
		local startQueue = uiPanel.startingRenderQueue
		--self:UpdateRenderQueue(self.gameObject,startQueue - queue)
	else
		LogError("bullet parent is not uiPanel")
	end
end

function UnitBullet:UpdateRenderQueue(go,queue)
	local render = go:GetComponent("Renderer")
	if(render ~= nil and render.material ~= nil) then
		render.material.renderQueue = queue
	end
	local count = go.transform.childCount
    for i=1,count do 
        self:UpdateRenderQueue(go.transform:GetChild(i-1).gameObject,queue)
    end
end

function UnitBullet:Reset()
	self.bulletData = nil
	self.index = -1
	self.obj_id = -1
	self.role_obj_id = -1
	self.gameObject.name = "bullet"
	self.gameObject.transform.localPosition = Vector3.zero
	self.gameObject.transform.localEulerAngles = Vector3.zero
	self.gameObject.transform.localScale = Vector3.one
	self.bulletHelper:Init()
end

function UnitBullet:Dispose()
	self.multiResLoader:Clear()
	self.multiResLoader = nil
	self.bulletHelper.RayGo = nil
	self.transform:SetParent(nil)
	self.parent = nil
	self.bulletInfo = nil
	UnityEngine.GameObject.Destroy(self.gameObject)
	self.gameObject = nil
	self.transform = nil

end