require "Game/Loading/LoadingCtrl"
require "Game/Clock/ClockCtrl"
require "Game/GunRateUnlock/GunRateUnlockCtrl"
require "Game/Guide/GuideCtrl"
require "Game/FishDic/FishCtrl"


Cmd_Init = Class(CommandBase)

function Cmd_Init:ctor()
end

function Cmd_Init:Execute(context)
	Cmd_Init.superclass.Execute(self)
	LogColor("#ff0000","Cmd_Init:Execute")
	self:InitCtrl()
	self:OnExecuteDone(CmdExecuteState.Success)
end

--所有的ctrl的初始化在这里做
function Cmd_Init:InitCtrl()
	--语言包初始化
	self:InitLanguage()
	LoginCtrl.Init()
	ClockCtrl.Init()
	RotationDiscCtrl.Init()
	GunRateUnlockCtrl.Init()
	GuideCtrl.Init()
	SignCtrl.Init()
	ShopCtrl.Init()
	--声音初始化
	for k,v in pairs(Res.audiolayer) do
		AudioMgr.AddKeyCount(v.layer,v.count)
	end
end

function Cmd_Init:InitLanguage()
	local curLanguageCode = Launch.GameConfig.LanguageCode
	local languagePack = LuaLanguagePack.new(curLanguageCode)
	for k,v in pairs(Res.language) do
		languagePack:AddString(v.key,v[curLanguageCode])
	end
	LuaLanguage.SetLanguagePack(languagePack)
end

function Cmd_Init:OnExecuteFinish()
     LogColor("#ff0000","Cmd_Init:OnExecuteFinish")
end
