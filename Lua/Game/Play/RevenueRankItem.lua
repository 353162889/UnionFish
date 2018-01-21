RevenueRankItem = {}
function RevenueRankItem:New(go)
	local o = {}
	o.gameObject = go
	o.spriteRank = o.gameObject.transform:FindChild("RankSprite"):GetComponent("UISprite")
	o.labelName = o.gameObject.transform:FindChild("NameLabel"):GetComponent("UILabel")
	o.labelGold = o.gameObject.transform:FindChild("GoldLabel"):GetComponent("UILabel")
	o.spriteHeadIcon = o.gameObject.transform:FindChild("HeadIcon/Pic"):GetComponent("UISprite")
	setmetatable(o,self)
	self.__index = self
	return o
end

function RevenueRankItem:Update(rank,info)
	if(info ~= nil) then
		self:SetActive(true)
		self.spriteRank.spriteName = "play_"..rank
		self.labelName.text = info.name
		self.labelGold.text = info.coin
		self.spriteHeadIcon.spriteName = "HeadIcon_"..info.head_id
	else
		self:SetActive(false)
	end
	-- body
end

function RevenueRankItem:SetActive(active)
	if(self.active == nil or self.active ~= active) then
		self.active = active
		self.gameObject:SetActive(active)
	end
end

function RevenueRankItem:Dispose()
	if(self.gameObject ~= nil) then
		GameObject.Destroy(self.gameObject)
		self.gameObject = nil
	end
end