
HelpBottomView=Class(BaseView)

function HelpBottomView:ConfigUI()    
    self.BulletParent = Find(self.gameObject,"BulletBox")
    self.FishSceneEffectParent = Find(self.gameObject,"FishSceneEffectBox")

    self.NumItem = Find(self.gameObject,"NumBox/Item")
    self.NumItem:SetActive(false)

    self.MoneyItem = Find(self.gameObject,"MoneyBox/Item")
    self.MoneyItem:SetActive(false)

    self.CatchItem = Find(self.gameObject,"CatchBox/Item")
    self.CatchItem:SetActive(false)

    self.UIBox = Find(self.gameObject,"UIBox")

    self.DropItem = Find(self.gameObject,"DropBox/Item")
    self.DropItem:SetActive(false)

    self.SayItem = Find(self.gameObject,"SayBox/Item")
    self.SayItem:SetActive(false)
end

function HelpBottomView:AfterOpenView(t)
end

function HelpBottomView:BeforeCloseView()
end


function HelpBottomView:OnDestory()
end