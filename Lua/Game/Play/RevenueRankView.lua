require 'Game/Play/RevenueRankItem'

RevenueRankView = {}

local this = RevenueRankView

this.go = nil
this.moveTP = nil
this.item = nil
this.isShow = false
this.grid = nil
this.scrollView = nil
this.itemList = nil
this.mask = nil

function this:ConfigUI(gameobject)
	this.go = gameobject
	this.moveGO = Find(this.go,"Widget")
	this.moveTP = this.moveGO:GetComponent("TweenPosition")
	this.scrollView = Find(this.go,"Widget/ScrollView"):GetComponent("UIScrollView")
	this.grid = Find(this.go,"Widget/ScrollView/Grid"):GetComponent("UIGrid")
	this.item = Find(this.go,"Widget/ScrollView/Grid/Item")
	this.itemParent = this.item.transform.parent.gameObject
	this.item:SetActive(false)
	this.isShow = false
	this.itemList = {}
	this.mask = Find(this.go,"Mask")
	this.mask:SetActive(false)

	Find(this.go,"Widget/Bgs/title"):GetComponent("UILabel").text = L("玩家列表")

	local clickMask = function (go)
		this:Hide()
	end
	LH.AddClickEvent(this.mask,clickMask)
end

function this:AfterOpenView(t)
	LH.SetTweenPosition(this.moveTP,Vector3.New(850,-2,0),Vector3.New(850,-2,0),0.01,nil)
	this.mask:SetActive(false)
	this.isShow = false
end

function this:BeforeCloseView()
	LH.SetTweenPosition(this.moveTP,Vector3.New(850,-2,0),Vector3.New(850,-2,0),0.01,nil)
	this.mask:SetActive(false)
	if(this.Close_Handle ~= nil) then
		this.Close_Handle:Cancel()
		this.Close_Handle = nil
	end
end

function this:Show()
	this:UpdateInfo()
    this.grid:Reposition()
    this.scrollView:ResetPosition()

	if(not this.isShow) then
		this.isShow = true
		this.mask:SetActive(true)
		LH.SetTweenPosition(this.moveTP,Vector3.New(850,-2,0),Vector3.New(438,-2,0),0.25,nil)

		local OnClose = function ()
			this.Hide()
		end
		this.Close_Handle = LH.UseVP(5, 1, 0 ,OnClose,{})
	end
end

function this:UpdateInfo()
	local roleInfoList = PlayCtrl.mode.RoleInfoList
	local tempList = {}
	for k,v in pairs(PlayCtrl.mode.RoleInfoList) do
		table.insert(tempList,v)
	end
	table.sort(tempList, this.compare)

	if #tempList > #this.itemList then
        local count = #tempList - #this.itemList
        for i = 1, count do
            local temp = LH.GetGoBy(this.item, this.itemParent)
            local item = RevenueRankItem:New(temp)
            item:SetActive(true)
            item.gameObject.name = (#this.itemList + i)
            table.insert(this.itemList, item)
        end
    end
    for i = 1, #this.itemList do
        if i <= #tempList then
            this:SetItemInfo(i, this.itemList[i], tempList[i])
        else
            this:SetItemInfo(i, this.itemList[i], nil)
        end
    end
end

function this:Hide()
	if(this.isShow) then
		this.isShow = false
		this.mask:SetActive(false)
		LH.SetTweenPosition(this.moveTP,Vector3.New(438,-2,0),Vector3.New(850,-2,0),0.25,nil)
	end
	if(this.Close_Handle ~= nil) then
		this.Close_Handle:Cancel()
		this.Close_Handle = nil
	end
end

function this.compare(a, b)
	return tonumber(a.coin) > tonumber(b.coin)
 end


function this:SetItemInfo(rank,item,info)
	if(info ~= nil) then
		item:SetActive(true)
		item:Update(rank,info)
	else
		item:SetActive(false)
	end
end


function this:OnDestory()
	this.go = nil
	this.moveTP = nil
	this.item = nil
	this.grid = nil
	this.scrollView = nil
	for k,v in pairs(this.itemList) do
		v:Dispose()
	end
	this.itemList = nil
	if(this.Close_Handle ~= nil) then
		this.Close_Handle:Cancel()
		this.Close_Handle = nil
	end
end

