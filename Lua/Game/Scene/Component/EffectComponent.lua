EffectComponent = {}
function EffectComponent:New(unit)
	local o = {unit = unit}
	o.listPlayingEffect = {}
	o.listPlayedEffect = {}
	setmetatable(o,self)
	self.__index = self
	return o
end

function EffectComponent:ShowEffect(effectId,layer,mountPointType)
	local parent = self.unit:GetMountPoint(mountPointType)
	local onFinish = function (playFinish,effect)
		self:OnShowEffectFinish(playFinish,effect)
	end
	local effect = UnitEffectMgr.ShowUIEffectInParent(parent,tonumber(effectId),Vector3.zero,true,nil)
	table.insert(self.listPlayingEffect,effect)
	effect:UpdateLayer(layer)
end

function EffectComponent:OnShowEffectFinish(playFinish,effect)
	if(playFinish) then
		for i=#self.listPlayingEffect,1,-1 do
			if(self.listPlayingEffect[i].obj_id == effect.obj_id) then
				table.remove(self.listPlayingEffect,i)
				break
			end
		end
		UnitEffectMgr.DisposeEffect(effect)
	else
		table.insert(self.listPlayedEffect,effect)
	end
end

function EffectComponent:Reset()
	self:Clear()
end

function EffectComponent:Clear()
	for k,v in pairs(self.listPlayingEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	self.listPlayingEffect = {}
	for k,v in pairs(self.listPlayedEffect) do
		UnitEffectMgr.DisposeEffect(v)
	end
	self.listPlayedEffect = {}
end

