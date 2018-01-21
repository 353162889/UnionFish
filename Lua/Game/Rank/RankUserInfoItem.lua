
RankUserInfoItem = {}

function RankUserInfoItem:New(go)
	local o = {gameObject = go}
	setmetatable(o,self)
	self.__index = self
	return o
end

function RankUserInfoItem:Init()
	self.LabelRank = Find(self.gameObject,"Rank"):GetComponent("UILabel")
	self.SpriteRank = Find(self.gameObject,"Rank"):GetComponent("UISprite")
	self.HeadPic = Find(self.gameObject,"HeadIcon/Pic"):GetComponent("UISprite")
	self.VipPic = Find(self.gameObject,"VIP/SpriteVIP"):GetComponent("UISprite")
	self.VipGO = Find(self.gameObject,"VIP")
	self.Vip_0_GO = Find(self.gameObject,"VIP_0")
	self.Vip_0_GO:SetActive(false)
	self.LabelName = Find(self.gameObject,"LabelName"):GetComponent("UILabel")
	self.ScoreIcon = Find(self.gameObject,"Score/Icon"):GetComponent("UISprite")
	self.ScoreNum = Find(self.gameObject,"Score/Num"):GetComponent("UILabel")
	self.Select = Find(self.gameObject,"Select")
	self.BtnInfo = Find(self.gameObject,"HeadIcon/Mask")
	local OnClickBtn = function (go)
		LogColor("#ff0000","OpenOtherInfoView")
		if(self.rankInfo ~= nil) then
			PersonalCenterCtrl.C2SAttrGetRoleInfo(self.rankInfo.user_name)
		end
		--PersonalCenterCtrl.OpenView(LoginCtrl.mode.S2CEnterGame,true)
	end
	LH.AddClickEvent(self.BtnInfo,OnClickBtn)
end

function RankUserInfoItem:Update(type,own,rankInfo)
	self.rankInfo = rankInfo
	self.gameObject.name = tostring(rankInfo.rank)
	if(self.LabelRank ~= nil) then 
		self.LabelRank.text = tostring(rankInfo.rank)
	end
	if(self.SpriteRank ~= nil) then
		self.SpriteRank.spriteName = "rank_num_"..rankInfo.rank
	end
	self.HeadPic.spriteName = "HeadIcon_"..rankInfo.head_id
	local showVIP0 = rankInfo.vip_level <= 0
	self.Vip_0_GO:SetActive(showVIP0)
	self.VipGO:SetActive(not showVIP0)
	self.VipPic.spriteName = "vip_"..rankInfo.vip_level
	self.LabelName.text = rankInfo.name
	self.ScoreIcon.spriteName = "rank_score_"..type
	self.ScoreNum.text = tostring(rankInfo.score)
	self.Select:SetActive(own == rankInfo.rank)
end

function RankUserInfoItem:SetActive(active)
	self.gameObject:SetActive(active)
	if(not active) then
		self.rankInfo = nil
	end
end