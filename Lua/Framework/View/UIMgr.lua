

UIMgr = {}
local this = UIMgr

this.DicBaseView = {}
this.BaseViewList = {}
this.InOpen = {}
this.ViewRoot = Drive.drive

function this.isOpened(ViewName)
    if this.InOpen[ViewName] == nil then
        this.InOpen[ViewName] = 0
    end
    if this.DicBaseView[ViewName] ~= nil then
        return this.DicBaseView[ViewName].isOpened
    else
        return false
    end
end
function this.OpenView(ViewName,t)
    local view = this.GetView(ViewName)
    if view == nil then
        return
    end
    if not view:ReadResView(ViewName, t) then
        LogError(ViewName.."在配置Res.View中未定义")
        return nil
    end
    view.this = view
    if view ~= nil then
        if view:OpenView() then
            this.LoadViewRes(view)
        end
    end
end

function this.LoadViewRes(view)
    this.DicBaseView[view.ViewName] = view
    table.insert(this.BaseViewList,view)
    view.gameObject:SetActive(true)
    local ts = view.gameObject:GetComponent("TweenScale")
    if(ts ~= nil) then
        LH.SetTweenScale(ts,0,0.2,Vector3.New(0.8,0.8,0.8),Vector3.one)
    end
    view.isOpened = true
    this.UpDataViewLayer()
    view:AddAllEvent()
    view:AfterOpenView(view.t)
    if view.OpenSound ~= 0 then
        PlaySound(view.OpenSound,nil)
    end
end
function this.GetView(ViewName)            
    for i=#this.BaseViewList,1,-1 do
        if this.BaseViewList[i].ViewName == ViewName then
            table.remove(this.BaseViewList,i)
        end
    end
    for k,v in pairs(this.DicBaseView) do
        if k == ViewName then
            this.DicBaseView[k] = nil
            return v
        end
    end
    if this.InOpen[ViewName] == 1 then
        return nil
    end
    this.InOpen[ViewName] = 1
    return loadstring("return "..ViewName..".new()")()
end
function this.UpDataViewLayer()
    local index = 1
    for i=1,#this.BaseViewList do
        if(this.isOpened(this.BaseViewList[i].ViewName)) then
            LH.SetDataViewLayer(this.BaseViewList[i].gameObject,index,this.BaseViewList[i].Lv)
            index = index + 1
        end
    end
end
function this.CloseView(ViewName)
    for i=#this.BaseViewList,1,-1 do
        if this.BaseViewList[i].ViewName == ViewName then
            table.remove(this.BaseViewList,i)
        end
    end
    if this.DicBaseView[ViewName] ~= nil then
        this.DicBaseView[ViewName]:Close()
        Log(ViewName..".isDestory="..this.DicBaseView[ViewName].isDestory)
        if this.DicBaseView[ViewName].isDestory == 1 then
            this.DicBaseView[ViewName]:OnDispose()
            this.DicBaseView[ViewName]:OnDestory()
            LH.DestoryGameObject(this.DicBaseView[ViewName].gameObject)
            this.DicBaseView[ViewName] = nil
        end
    end
    this:UpDataViewLayer()
end

function this.Dic(ViewName)
    return this.DicBaseView[ViewName]
end

function this.CloseAll()
    for i=#this.BaseViewList,1,-1 do
        this.CloseView(this.BaseViewList[i].ViewName)
    end
end