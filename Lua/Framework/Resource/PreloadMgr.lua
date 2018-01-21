require 'Framework/Resource/MultiResLoader'
PreloadMgr = {}

local this = PreloadMgr

this.multiLoader = MultiResLoader:New()

--拿到实例化的对象
function this.GetAsset(path)
	local res = this.multiLoader:TryGetRes(path)
	return Resource.GetGameObject(res,path)
end