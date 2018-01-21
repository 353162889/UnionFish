require 'Game/Scene/Unit/UnitGun'
GunMgr = {}
local this = GunMgr

this.GunContainerTemplate = nil
this.GunDic = {}
this.MainGun = nil

function this.Init(template)
	this.GunContainerTemplate = template
end

function this.Dispose()
	GuideCtrl.HideArrow()--最快的办法处理炮移除前，箭头需要隐藏
	this.GunContainerTemplate = nil
	for k,v in pairs(this.GunDic) do
		v:Dispose()
	end
	this.GunDic = {}
	this.MainGun = nil
	this.IsDelayCreateGun = false
end

function this.UpdateGunData(roleData)
	local obj_id = roleData.role_obj_id
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:UpdateGun(roleData)
	end
end

function this.OnUpdateState(refStateInfo)
	local obj_id = refStateInfo.obj_id
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:OnUpdateState(refStateInfo.info_list)
	else
		LogError("[OnUpdateState]Can not find gunObjID:"..obj_id)
	end
end

function this.OnDeleteState(delStateInfo)
	local obj_id = delStateInfo.obj_id
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:OnDeleteState(delStateInfo.id_list)
	else
		LogError("[OnDeleteState]Can not find gunObjID:"..obj_id)
	end
end

function this.CreateGun(roleData)
	local obj_id = roleData.role_obj_id
	LogColor("#ff0000","CreateGun",obj_id)
	if(this.GunDic[obj_id] ~= nil) then
		LogError("[CreateGun]exist gun obj_id:"..obj_id)
		return
	end
	local container = LH.GetGoBy(this.GunContainerTemplate,this.GunContainerTemplate.transform.parent.gameObject)
	container:SetActive(true)
	local gun = UnitGun:New(container)
	gun:UpdateGun(roleData)
	this.GunDic[obj_id] = gun
	if(roleData.role_id == LoginCtrl.mode.S2CEnterGame.role_id) then
		this.MainGun = gun
	end
	return gun
	
end

function this.RemoveGun(role_obj_id)
	if(this.GunDic[role_obj_id] == nil) then
		LogError("[RemoveGun]not exist gun obj_id:"..role_obj_id)
		return
	end
	local gun = this.GunDic[role_obj_id]
	gun:Dispose()
	this.GunDic[role_obj_id] = nil
end

function this.IsGun(obj_id)
	return this.GunDic[obj_id] ~= nil
end

function this.GetGun(obj_id)
	if(not this.IsGun(obj_id)) then
		LogError("can not find gun obj_id:"..obj_id)
		return nil
	end
	return this.GunDic[obj_id]
end

function this.ServerSendBullet(msg)
	local gun = this.GetGun(msg.role_obj_id)
	if(gun ~= nil) then
		gun:ServerSendBullet(msg)
	end

end

function this.ClientSendBullet(d)
	local count = BulletMgr.GetBulletNum(this.MainGun.roleData.role_obj_id)
	if (count > this.MainGun.cfg.BulletCount) then
    	return
    end
    this.MainGun:ClientSendBullet(d)
   
end

function this.SyncGunPos(gunMoveInfo)
	local gun = this.GunDic[gunMoveInfo.obj_id]
	if(gun == nil) then
		LogError("can not find gun_obj_id:",gunMoveInfo.obj_id)
		return
	end
	gun:SyncGunPos(gunMoveInfo)
end

function this.OnGunRateChange(obj_id,gun_lv)
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:OnGunRateChange(gun_lv)
	end
end

function this.OnOutBreak(obj_id)
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:OnOutBreak(gun_lv)
	end
end

function this.OnGunChange(obj_id,weapon)
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:OnGunChange(weapon)
	end
end

function this.OnRefreshShow(obj_id)
	local gun = this.GetGun(obj_id)
	if(gun ~= nil) then
		gun:RefreshShow()
	end
end

