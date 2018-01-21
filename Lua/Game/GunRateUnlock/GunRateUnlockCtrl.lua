GunRateUnlockCtrl = CustomEvent()
local this = GunRateUnlockCtrl


function this.Init()
end

function this.ResetData()
end

function this.GetNextGunRateCfg()
	if(this.IsMaxGunRate()) then return nil end
	local gunRates = {}
	local maxGunRate = LoginCtrl.mode.S2CEnterGame.battery_rate
	for k,v in pairs(Res.gun_unlock) do
		if(v.rate > maxGunRate) then
			table.insert(gunRates,v)
		end
	end
	table.sort(gunRates,function (a,b)
		if(a.rate == b.rate)then return tonumber(a.id) < tonumber(b.id) end
		return tonumber(a.rate) < tonumber(b.rate)
	end)
	if(#gunRates > 0) then
		return gunRates[1]
	end
	return nil
end

function this.IsMaxGunRate()
	local maxGunRate = LoginCtrl.mode.S2CEnterGame.battery_rate
	for k,v in pairs(Res.gun_unlock) do
		if(v.rate > maxGunRate) then
			return false
		end
	end
	return true
end

function this.IsCanUnlockGunRate()
	local cfg = this.GetNextGunRateCfg()
	if(cfg == nil) then
		return false
	end
	if(#cfg.use_item == 0) then return false end
	local id = cfg.use_item[1]
	local num = cfg.use_item[2]
	local item = BagCtrl.GetItem(id)
	if(item ~= nil and item.cnt >= num) then return true end
	return false
end