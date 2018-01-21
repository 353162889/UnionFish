require 'Framework/Tool/Tools'
require 'Framework/Resource/MultiResLoader'
require 'Framework/EventDispatcher/EventMgr'
require 'Framework/EventDispatcher/CustomEvent'
require 'Framework/Base/Class'
require 'Framework/View/BaseView'
require 'Framework/View/UIMgr'
require "Framework/UI/UIModelMgr"
require 'Framework/UI/UIProgress'
require 'Framework/Language/LuaLanguage'
require 'DataList'
require 'DataDef/SortRes'
require 'DataDef/ED'
require 'DataDef/AttrDefine'
require 'DataDef/GlobalDefine'
require 'DataDef/AudioDefine'
require 'DataDef/BulletExtParam'
require 'DataDef/GameEnum'
require 'DataDef/GlobalWay'
require "Net/Network"
require 'Game/Scene/LuaSceneMgr'
require 'Game/Scene/Manager/UnitEffectMgr'
require "Game/Scene/Manager/BulletMgr"
require "Game/Scene/Manager/EffectMgr"
require "Game/Scene/Manager/FishMgr"
require "Game/Scene/Manager/FishSceneEffectMgr"
require "Game/Scene/Manager/FishSceneTimeMgr"
require "Game/Scene/Manager/GunMgr"
require "Game/Scene/Manager/CameraMgr"
require "Game/Scene/Manager/NumItemMgr"
require "Game/Scene/Manager/GoldItemMgr"
require "Game/Scene/Manager/CatchMgr"
require "Game/Scene/Manager/DropItemMgr"
require "Game/Scene/Manager/FishSoundMgr"
require "Game/Scene/Manager/SayMgr"

require 'Game/Login/LoginView'
require 'Game/MainUI/MainView'
require 'Game/MainUI/HeadView'
require 'Game/Help/HelpView'
require 'Game/Help/HelpBottomView'
require 'Game/Loading/LoadingView'
require 'Game/Play/PlayView'
require 'Game/Login/LoginSignInView'
require 'Game/Login/PasswordFindView'
require 'Game/PublicNotice/PublicNoticeView'
require 'Game/Login/FirstLoginView'
require 'Game/GunRateUnlock/GunRateUnlockView'
require 'Game/Help/HelpTipView'
require 'Game/LookFor/LookForView'
require 'Game/Shop/ShopView'
require 'Game/PersonalCenter/PersonalCenterView'
require 'Game/PersonalCenter/ChangeHeadIconView'
require 'Game/PersonalCenter/ChangePlayNameView'
require 'Game/ChangeGun/ChangeGunView'
require 'Game/Help/ItemGetEffectView'
require 'Game/Play/GunView'
require 'Game/FishDic/FishDicView'
require 'Game/Online/OnlineView'
require 'Game/HP/HPView'

require 'Game/Skill/SkillView'
require 'Game/Bag/BagView'
require 'Game/Bag/ItemCell'
require 'Game/Test/TestView'
require 'Game/Play/FishComeView'
require 'Game/Rank/RankView'
require 'Game/RotationDisc/RotationDiscView'
require 'Game/FirstRecharge/FirstRechargeView'
require 'Game/Sign/SignView'
require 'Game/Task/TaskView'
require 'Game/Task/TaskProcessView'
require 'Game/Guide/GuideTaskView'
require 'Game/Guide/GuideWelcomeView'

require 'GameStarter/GameStarter'
--require 'Game/Set/SetView'
--require 'Game/HP/HPView'
--require 'Game/Notice/NoticeView'
--require 'Game/Notice/MainNoticeView'



-- require "Game/Sign/SignView"

local test = CustomEvent()

function Main()
	-- 注册网络事件
    Network:RegisterEvent()
    
	GameStarter.RunInStart()
end

--场景切换通知
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end 