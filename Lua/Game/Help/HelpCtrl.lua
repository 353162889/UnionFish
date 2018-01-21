HelpCtrl = {}

local this = HelpCtrl

this.mode = {}

function this.ResetData()
end

function HelpCtrl.Msg(str)
    EventMgr.SendEvent(ED.HelpView_Msg,str)
end
function HelpCtrl.RunWord(str)
    EventMgr.SendEvent(ED.HelpView_RunWord,str)
end
function HelpCtrl.Num(data)
    EventMgr.SendEvent(ED.HelpView_Num,data)
end
function HelpCtrl.Money(data)
    EventMgr.SendEvent(ED.HelpView_Money,data)
end

function HelpCtrl.MoneyParam(data,param)
	EventMgr.SendEvent(ED.HelpView_MoneyParam,data,param)
end

function HelpCtrl.Catch(data)
    EventMgr.SendEvent(ED.HelpView_Catch,data)
end

--打开确定取消框
function HelpCtrl.OpenTipView(title,content,onConfirmCallback,onCancelCallback,onCloseCallback,confirmLabel,cancelLabel,checkContent,checkValue,checkCallback)
	UIMgr.OpenView("HelpTipView",{viewType = 1,title = title,content = content,
		onConfirmCallback = onConfirmCallback,onCancelCallback = onCancelCallback,
		onCloseCallback = onCloseCallback,confirmLabel = confirmLabel,
		cancelLabel = cancelLabel,checkContent = checkContent,checkValue = checkValue,checkCallback = checkCallback})
end

--打开确定框
function HelpCtrl.OpenConfirmView(title,content,onConfirmCallback,onCloseCallback,confirmLabel)
	UIMgr.OpenView("HelpTipView",{viewType = 2,title = title,content = content,onConfirmCallback = onConfirmCallback,onCloseCallback = onCloseCallback,confirmLabel = confirmLabel})
end

--打开通用物品获得面板（有特效）  ids格式为  {{id,num},{id,num}}
function HelpCtrl.OpenItemGetEffectView(ids,title)
	UIMgr.OpenView("ItemGetEffectView",{ids,title})
end

function HelpCtrl.OpenDiamondNotEnoughView()
	HelpCtrl.OpenTipView(L("提   示"),L("钻石不足，可从商城中快速获取钻石"),function ()
		UIMgr.OpenView("ShopView",3)
	end,nil,nil,L("去商城购买"),L("取 消"))
end

function HelpCtrl.OpenGoldNotEnoughView()
	HelpCtrl.OpenTipView(L("提   示"),L("金币不足，可从商城中快速获取金币"),function ()
		UIMgr.OpenView("ShopView",1)
	end,nil,nil,L("去商城购买"),L("取 消"))
end