require "Game/Link/LinkCtrl"
require "Game/Login/LoginCtrl"
require "Game/Help/HelpCtrl"
require "Game/MainUI/MainCtrl"
require "Game/Play/PlayCtrl"
require "Game/LookFor/LookForCtrl"
require "Game/Shop/ShopCtrl"
require "Game/PersonalCenter/PersonalCenterCtrl"
require "Game/ChangeGun/ChangeGunCtrl"
require "Game/Bag/BagCtrl"
require "Game/Skill/SkillCtrl"
require "Game/Rank/RankCtrl"
require "Game/RotationDisc/RotationDiscCtrl"
require "Game/FirstRecharge/FirstRechargeCtrl"
require "Game/Online/OnlineCtrl"
require "Game/Sign/SignCtrl"
require "Game/Task/TaskCtrl"
require "Game/FunctionFish/FunctionFishCtrl"

NetEventMgr = CustomEvent()
Network = { }
local this = Network

-- 注册网络监听--
function this.RegisterEvent()
    Log("Network.RegisterEvent!")
    ------------------------------登录相关---------------------------------------------
    NetEventMgr.AddEvent("20001", LoginCtrl.S2CRegisterResult)
    NetEventMgr.AddEvent("20002", LoginCtrl.S2CLoginResult)
    NetEventMgr.AddEvent("20020", LoginCtrl.S2CEnterGame)
    NetEventMgr.AddEvent("20009", LinkCtrl.S2CHeartBeat)
    NetEventMgr.AddEvent("25050", MainCtrl.S2CRoomEnterRoom)

    NetEventMgr.AddEvent("20021", PlayCtrl.S2CSceneEnterScene)
    NetEventMgr.AddEvent("20022", PlayCtrl.S2CSceneLeaveScene)
    NetEventMgr.AddEvent("20023", PlayCtrl.S2CSceneRoleEnterScene)
    NetEventMgr.AddEvent("20024", PlayCtrl.S2CSceneFishEnterScene)
    NetEventMgr.AddEvent("20025", PlayCtrl.S2CSceneSynRole)
    NetEventMgr.AddEvent("20026", PlayCtrl.S2CSceneSynObj)
    NetEventMgr.AddEvent("20027", PlayCtrl.S2CSceneObjLeave)
    NetEventMgr.AddEvent("20028", PlayCtrl.S2CSceneSendBullet)
    NetEventMgr.AddEvent("20029", PlayCtrl.S2CSceneBackBullet)
    NetEventMgr.AddEvent("20030", PlayCtrl.S2CSceneAttackFish)
    NetEventMgr.AddEvent("20033", PlayCtrl.S2CSceneFishLock)

    NetEventMgr.AddEvent("20038", PlayCtrl.S2CSceneSetGunRet)
    NetEventMgr.AddEvent("20037", PlayCtrl.S2CSceneOutBreak)
    NetEventMgr.AddEvent("20032", PlayCtrl.S2CSceneChangeGun)
    NetEventMgr.AddEvent("20031", PlayCtrl.S2CSceneMoveGun)

    NetEventMgr.AddEvent("20039", PlayCtrl.S2CSceneRefStatus)
    NetEventMgr.AddEvent("20040", PlayCtrl.S2CSceneDelStatus)

    NetEventMgr.AddEvent("20041",PlayCtrl.S2CSceneSynchroUpdate)

    NetEventMgr.AddEvent("20042",PlayCtrl.S2CSceneFuncAttackFish)
    NetEventMgr.AddEvent("20044",PlayCtrl.S2CSceneAddItem)

    NetEventMgr.AddEvent("25100", LookForCtrl.S2CTreasureGetInfo)
    NetEventMgr.AddEvent("25101", LookForCtrl.S2CTreasureLottery)

    NetEventMgr.AddEvent("25200", PersonalCenterCtrl.S2CAttrSetHeadIdRet)
    NetEventMgr.AddEvent("25201", PersonalCenterCtrl.S2CAttrSetNameRet)
    NetEventMgr.AddEvent("25202", PersonalCenterCtrl.S2CAttrSetGenderRet)
    NetEventMgr.AddEvent("25205", PersonalCenterCtrl.S2CAttrSetBatteryRateRet)
    NetEventMgr.AddEvent("25206", PersonalCenterCtrl.S2CAttrGetRoleInfoRet)
    NetEventMgr.AddEvent("25207", PersonalCenterCtrl.S2CAttrSyncRole)
    NetEventMgr.AddEvent("25209", PersonalCenterCtrl.S2CAttrUnlockBattery)
    NetEventMgr.AddEvent("25210", PersonalCenterCtrl.S2CAttrEnterRoom2)

    NetEventMgr.AddEvent("25150", ShopCtrl.S2CStoreBuy)

    NetEventMgr.AddEvent("20052", LoginCtrl.S2CCodeNotice)

    NetEventMgr.AddEvent("25250", SkillCtrl.S2CSkillGetInfo)
    NetEventMgr.AddEvent("25251", SkillCtrl.S2CSkillUnlockSkill)
    NetEventMgr.AddEvent("25252", SkillCtrl.S2CSkillSetSkill)
    NetEventMgr.AddEvent("25253", SkillCtrl.S2CSkillUseSkill)
    NetEventMgr.AddEvent("25254", SkillCtrl.S2CSkillUseSkillGold)
    NetEventMgr.AddEvent("25255", SkillCtrl.S2CSkillUseSceneSkill)
    NetEventMgr.AddEvent("25256", SkillCtrl.S2CSkillSwapSkill)

    NetEventMgr.AddEvent("25300", BagCtrl.S2CBagGetInfo)
    NetEventMgr.AddEvent("25301", BagCtrl.S2CBagUpdate)
    NetEventMgr.AddEvent("25302", BagCtrl.S2CBagDelete)
    NetEventMgr.AddEvent("25303", BagCtrl.S2CBagUseItem)
    NetEventMgr.AddEvent("25304", BagCtrl.S2CBagSellItem)
    
    NetEventMgr.AddEvent("25402", OnlineCtrl.S2CSignGetSceneInfo)
    NetEventMgr.AddEvent("25403", OnlineCtrl.S2CSignAcceptPrizeByScene)
    NetEventMgr.AddEvent("25404", OnlineCtrl.S2CSignAcceptPrizeByTime)
    NetEventMgr.AddEvent("25405", OnlineCtrl.S2CSignAcceptPrizeByAll)

    NetEventMgr.AddEvent("25550",RankCtrl.S2CRankGetInfo)

    NetEventMgr.AddEvent("25500",RotationDiscCtrl.S2CLotteryGetInfo)
    NetEventMgr.AddEvent("25501",RotationDiscCtrl.S2CLotteryLottery)

    --签到
    NetEventMgr.AddEvent("25400",SignCtrl.S2CSignGetInfo)
    NetEventMgr.AddEvent("25401",SignCtrl.S2CSignSign)

    --任务
    NetEventMgr.AddEvent("25600",TaskCtrl.S2CTaskGetInfo)
    NetEventMgr.AddEvent("25601",TaskCtrl.S2CTaskAcceptPrize)
    NetEventMgr.AddEvent("25602",TaskCtrl.S2CTaskAcceptPrizeByScore)
    NetEventMgr.AddEvent("25605",TaskCtrl.S2CTaskUpdateInfo)

    NetEventMgr.AddEvent("25504",FunctionFishCtrl.S2CLotteryFishLottery)
end
-- Socket消息派发--
function this.OnDispatch(type,data)
    NetEventMgr.SendEvent(tostring(type), data)
end