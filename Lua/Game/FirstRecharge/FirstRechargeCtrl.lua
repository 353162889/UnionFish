FirstRechargeCtrl = CustomEvent()
local this = FirstRechargeCtrl

--id 礼包id
function this.OpenView(id)
	UIMgr.OpenView("FirstRechargeView",{id})
end

function this.ResetData()
end
