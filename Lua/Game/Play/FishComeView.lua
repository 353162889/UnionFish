FishComeView=Class(BaseView)

function FishComeView:ConfigUI()
	self.Normal = Find(self.gameObject,"Normal")
	self.Boss = Find(self.gameObject,"Boss")
	self.BossTS = self.Boss:GetComponent("TweenScale")
	self.BossTP = self.Boss:GetComponent("TweenPosition")
	self.BossTex = Find(self.gameObject,"Boss/Texture"):GetComponent("UITexture")
	self.NormalTS = Find(self.gameObject,"Normal/Container"):GetComponent("TweenScale")
	LH.SetTweenPosition(self.BossTP,0,0,Vector3.zero,Vector3.zero)
	LH.SetTweenScale(self.BossTS,0,0,Vector3.one,Vector3.one)
end

function FishComeView:AfterOpenView(t)
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	if(t[1] == 2) then  	--鱼阵
		self.Normal.gameObject:SetActive(true)
		self.Boss.gameObject:SetActive(false)
		LH.SetTweenScale(self.NormalTS,0,0.5,Vector3.New(1,0,1),Vector3.one)
		local OnHide = function (lt)
			LH.SetTweenScale(self.NormalTS,0,0.5,Vector3.one,Vector3.New(1,0,1))
		end
		self.Timer = LH.UseVP(2,1,0,OnHide,{})
	elseif(t[1] == 1) then	--boss
		self.Normal.gameObject:SetActive(false)
		self.Boss.gameObject:SetActive(true)
		self.OnGetRes = function (res)
			self:OnResLoaded(res)
		end
		local languageCode = Launch.GameConfig.LanguageCode
		self.BossPath = "Texture/Boss_"..t[2].."_"..languageCode..".png"
		--self.BossPath = "Texture/Boss_1001201"
		ResourceMgr.GetResourceInLuaByType(self.BossPath,self.OnGetRes,ResourceType.Texture)
	end
end

function FishComeView:OnResLoaded(res,lt)
	local tex = res:GetAsset(self.BossPath)
	self.BossTex.mainTexture = tex
	self.BossTex:MakePixelPerfect()

	self.BossTP.transform.localPosition = Vector3.zero
	LH.SetTweenScale(self.BossTS,0,0.25,Vector3.New(1.3,1.3,1.3),Vector3.one)
	EventMgr.SendEvent(ED.HelpView_AddBDEffect,GlobalDefine.FishComeBDID)
	local OnHide = function (lt)
		LH.SetTweenPosition(self.BossTP,0,0.5,Vector3.zero,Vector3.New(1200,0,0))
	end
	self.Timer = LH.UseVP(2,1,0,OnHide,{})
end

function FishComeView:BeforeCloseView()
	if(self.BossPath ~= nil and self.OnGetRes ~= nil) then
		ResourceMgr.RemoveListenerInLua(self.BossPath,self.OnGetRes)
		self.BossPath = nil
		self.OnGetRes = nil
	end
	self.BossTex.mainTexture = nil
	if(self.Timer ~= nil) then
		self.Timer:Cancel()
		self.Timer = nil
	end
	--移除边框效果
	EventMgr.SendEvent(ED.HelpView_RemoveBDEffectInID,GlobalDefine.FishComeBDID)
end

function FishComeView:OnDestory()
end