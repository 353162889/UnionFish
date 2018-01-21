require "Protof/NP_CS_Store_pb"
require "Protof/NP_SC_Store_pb"

ShopCtrl = CustomEvent()

local this = ShopCtrl

this.mode = {}

function this.Init()
    --初始化
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayInitSuccess,this.OnPayInitSuccess)
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayInitFail,this.OnPayInitFail)
    --支付
    SDKMgr.RegisterLuaListener(SDKEventStatus.PaySuccess,this.OnPaySuccess)
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayFail,this.OnPayFail)
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayCancel,this.OnPayCancel)
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayNetworkError,this.OnPayNetworkError)
    SDKMgr.RegisterLuaListener(SDKEventStatus.PayProductionInforIncomplete,this.OnPayProductionInforIncomplete)

    SDKMgr.RegisterLuaListener(SDKEventStatus.PayNowPaying,this.OnPayNowPaying)
end

--初始化成功
function this.OnPayInitSuccess(result)
    LogColor("#ff0000","OnPayInitSuccess",result)
end

--初始化失败
function this.OnPayInitFail(result)
    LogColor("#ff0000","OnPayInitFail",result)
end

--支付成功
function this.OnPaySuccess(result)
    LogColor("#ff0000","OnPaySuccess",result)
    if(UIMgr.isOpened("ItemGetEffectView")) then
        return 
    end
    if(UIMgr.isOpened("HelpTipView")) then
        UIMgr.CloseView("HelpTipView")
    end
    HelpCtrl.OpenConfirmView(L("支付成功"),L("支付成功，努力发放商品中，请稍后。"),nil,nil,L("确 定"))
end

--支付失败
function this.OnPayFail(result)
    LogColor("#ff0000","OnPayFail",result)
    if(UIMgr.isOpened("HelpTipView")) then
        UIMgr.CloseView("HelpTipView")
    end
    HelpCtrl.OpenConfirmView(L("支付失败"),L("对不起，支付失败了，客官请再试一次吧。"),nil,nil,L("确 定"))
end

--支付取消
function this.OnPayCancel(result)
    LogColor("#ff0000","OnPayCancel",result)
    if(UIMgr.isOpened("HelpTipView")) then
        UIMgr.CloseView("HelpTipView")
    end
    HelpCtrl.OpenConfirmView(L("支付取消"),L("这位高富帅！请慎重。"),nil,nil,L("确 定"))
end

--支付网络错误
function this.OnPayNetworkError(result)
    LogColor("#ff0000","OnPayNetworkError",result)
    if(UIMgr.isOpened("HelpTipView")) then
        UIMgr.CloseView("HelpTipView")
    end
    HelpCtrl.OpenConfirmView(L("网络错误"),L("好像网络有点慢，再试一次吧。"),nil,nil,L("确 定"))
end

--支付信息未完成
function this.OnPayProductionInforIncomplete(result)
    LogColor("#ff0000","OnPayProductionInforIncomplete",result)
    if(UIMgr.isOpened("HelpTipView")) then
        UIMgr.CloseView("HelpTipView")
    end
    HelpCtrl.OpenConfirmView(L("支付信息未完成"),L("信息有误，请检查是否有漏填。"),nil,nil,L("确 定"))
end

--正在支付
function this.OnPayNowPaying(result)
    LogColor("#ff0000","OnPayNowPaying",result)
    SDKMgr.ResetPayState()
end

function this.ResetData()
	this.mode = {}
end

function this.BuyItem(id)
    local cfg = Res.store[id]
    if(cfg == nil) then return end
    if(cfg.buy[1] == GlobalDefine.RMBId) then
        if(Launch.GameConfig.IsUsedSDK) then
            this.BuyRMB(cfg)
        else
            this.BuyInSelf(cfg)
        end
    else
        this.C2SStoreBuy(id)
    end
end

function this.BuyRMB(cfg)
    local info = SDKPayInfo.New()
    info.ProductId = tostring(cfg.id)
    info.ProductName = tostring(cfg.title)
    info.ProductPrice = tostring(cfg.buy[2])
    info.ProductCount = tostring(1)
    info.ProductDesc = tostring(cfg.title)
    info.CoinName = tostring(Res.item[cfg.get[1]].name)
    info.CoinRate = tostring(10)
    info.RoleId = tostring(LoginCtrl.mode.S2CEnterGame.user_name)
    info.RoleName = tostring(LoginCtrl.mode.S2CEnterGame.name)
    info.RoleGrade = tostring(LoginCtrl.mode.S2CEnterGame.level)
    info.RoleBalance = tostring(LoginCtrl.mode.S2CEnterGame.diamond)
    info.VIPLevel = tostring(LoginCtrl.mode.S2CEnterGame.vip_level)
    info.PartyName = tostring("无")
    info.ServerId = tostring(1)
    info.ServerName = tostring("server01")
    info.Ext = tostring(LoginCtrl.mode.S2CEnterGame.user_name).."-"..cfg.id.."-"..tostring(LoginCtrl.mode.S2CResult.gameid).."-1-"..tostring(LH.GetDateTimeTicksToString())
    LogColor("#ff0000",info:ToString())
    SDKMgr.PayForProduct(info)
end

function this.BuyInSelf(cfg)
    local info = SDKPaySelfInfo.New()
    info.Total_fee = tostring(tonumber(cfg.buy[2]) * 100)
    info.Body = tostring(cfg.title)
    info.PlayerId = tostring(LoginCtrl.mode.S2CEnterGame.user_name)
    info.Type = tostring(cfg.id)
    info.GameId = tostring(LoginCtrl.mode.S2CResult.gameid)
    LogColor("#ff0000",info:ToString())
    SDKMgr.PayForSelf(info)
end

function this.C2SStoreBuy(id)
    local sendData = NP_CS_Store_pb.C2SStoreBuy()
    sendData.id = id
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15150, msg)
end

function this.S2CStoreBuy(data)
    local msg = NP_SC_Store_pb.S2CStoreBuy()
    msg:ParseFromString(data)
    if CheckCode(msg.money_code) then
        local cfg = Res.store[msg.id]
        if(cfg.buy[1] == GlobalDefine.RMBId) then
            if(UIMgr.isOpened("HelpTipView")) then
                UIMgr.CloseView("HelpTipView")
            end
            if(UIMgr.isOpened("ItemGetEffectView")) then
                UIMgr.CloseView("ItemGetEffectView")
            end
            local ids = {{cfg.get[1],cfg.get[2]}}
            HelpCtrl.OpenItemGetEffectView(ids,L("获得物品"))
        else
            HelpCtrl.Msg(L("购买{1}成功！",cfg.title))
        end
    end
end