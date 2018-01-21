ChangeGunCtrl = CustomEvent()

local this = ChangeGunCtrl

function this.ResetData()
end

function this.OpenView()
	UIMgr.OpenView("ChangeGunView")
end

function this.CloseView()
	UIMgr.CloseView("ChangeGunView")
end

--OnChangeGun回调当前选中炮的ID   OnChangeGun(gunID)
function this.ShowView(OnChangeGun)
	UIMgr.Dic("ChangeGunView"):Show(OnChangeGun)
end

function this.HideView()
	UIMgr.Dic("ChangeGunView"):Hide()
end