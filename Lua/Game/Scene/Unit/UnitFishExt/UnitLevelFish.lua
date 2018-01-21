UnitLevelFish = Class(UnitFish)

function UnitLevelFish:Init(fishId)
	self.level = 0
	UnitLevelFish.superclass.Init(self,fishId)
end

function UnitLevelFish:UpdateInfo(fishData)
	UnitLevelFish.superclass.UpdateInfo(self,fishData)
end

function UnitLevelFish:UpdateLevel(level)
	self.level = level
	if(self.animName ~= nil) then
		--self:PlayAnim(self.animName)
	end
end

function UnitLevelFish:LevelUp()
	local level = self.fishInfo.handle_param.MaxLevel
	if(level == nil) then
		LogColor("#ff0000","没有找到当前鱼的最高状态等级,fishId:"..self.id)
		return
	end
	level = tonumber(level)
	if(self.level >= level) then
		LogColor("#ff0000","已是最高状态了")
		return
	end
	local anim = UnitFishAnim.levelup
	if(self.level > 0) then
		anim = anim.."_"..self.level
	end
	--self:PlayAnim(anim)
	self.level = self.level + 1
end

function UnitLevelFish:LevelDown()
	if(self.level == 0) then 
		LogColor("#ff0000","已是最低状态了")
		return 
	end
	local anim = UnitFishAnim.leveldown
	anim = anim.."_"..self.level
	--self:PlayAnim(anim)
	self.level = self.level - 1
end


function UnitLevelFish:PlayAnim(anim)
	local realAnim = anim
	if(self.level > 0) then
		--realAnim = realAnim.."_"..self.level
	end
	UnitLevelFish.superclass.PlayAnim(self,realAnim)
end