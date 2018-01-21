UnitBossClownFish = Class(UnitFish)

function UnitBossClownFish:Init(fishId)
	UnitBossClownFish.superclass.Init(self,fishId)
end

function UnitBossClownFish:InitMountPoint()
	UnitBossClownFish.superclass.InitMountPoint(self)
	self:RegisterMountPoint(UnitFishMPType.Head,"HeadMP")
end

function UnitBossClownFish:IsCanBeHit()
	if(self:IsCurAnim(UnitFishAnim.standby03)) then
		return false
	end
	return UnitBossClownFish.superclass.IsCanBeHit(self)
end

function UnitBossClownFish:PlayAnim(anim)
	--不做特殊动作
	if(anim == UnitFishAnim.standby01) then return end
	UnitBossClownFish.superclass.PlayAnim(self,anim)
end