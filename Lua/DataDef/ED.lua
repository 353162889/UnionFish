ED = {}

local this = ED

this.MainCtrl_S2CRoomEnterRoom = "MainCtrl_S2CRoomEnterRoom"
this.LoadingView_SetProgress = "LoadingView_SetProgress"    --进度条控制
this.LuaSceneMgr_SceneLoaded = "LuaSceneMgr_SceneLoaded"	--场景加载完成事件
this.BallScene_IsLandsLoaded = "BallScene_IsLandsLoaded"	--岛屿加载完成事件 抛出id:go的table

this.HelpView_Msg = "HelpView_Msg"--飘字提示
this.HelpView_Num = "HelpView_Num"--数字提示
this.HelpView_Money = "HelpView_Money"--金币提示
this.HelpView_MoneyParam = "HelpView_MoneyParam"--金币提示（带参数）
this.HelpView_Catch = "HelpView_Catch"--捕捉UI
this.HelpView_RunWord = "HelpView_RunWord"--跑马灯

this.HelpView_AddBDEffect = "HelpView_AddBDEffect"--添加边框特效
this.HelpView_RemoveBDEffectInID = "HelpView_RemoveBDEffectInID"--用ID移除
this.HelpView_RemoveBDEffectInLv = "HelpView_RemoveBDEffectInLv"
this.HelpView_RemoveBDEffectInType = "HelpView_RemoveBDEffectInType"
this.HelpView_RemoveBDEffectAll = "HelpView_RemoveBDEffectAll"--移出所有边框特效

this.LookForCtrl_S2CTreasureGetInfo = "LookForCtrl_S2CTreasureGetInfo"--寻宝信息获取
this.LookForCtrl_S2CTreasureLottery = "LookForCtrl_S2CTreasureLottery"--开启宝箱

this.PlayCtrl_S2CSceneEnterScene = "PlayCtrl_S2CSceneEnterScene"
this.PlayCtrl_S2CSceneLeaveScene = "PlayCtrl_S2CSceneLeaveScene"
this.PlayCtrl_S2CSceneRoleEnterScene = "PlayCtrl_S2CSceneRoleEnterScene"
this.PlayCtrl_S2CSceneFishEnterScene = "PlayCtrl_S2CSceneFishEnterScene"
this.PlayCtrl_S2CSceneSynRole = "PlayCtrl_S2CSceneSynRole"
this.PlayCtrl_S2CSceneSynchroUpdate = "PlayCtrl_S2CSceneSynchroUpdate"
this.PlayCtrl_S2CSceneSynObj = "PlayCtrl_S2CSceneSynObj"
this.PlayCtrl_BeforeS2CSceneObjLeave = "PlayCtrl_BeforeS2CSceneObjLeave"
this.PlayCtrl_S2CSceneObjLeave = "PlayCtrl_S2CSceneObjLeave"
this.PlayCtrl_S2CSceneSendBullet = "PlayCtrl_S2CSceneSendBullet"
this.PlayCtrl_S2CSceneBackBullet = "PlayCtrl_S2CSceneBackBullet"
this.PlayCtrl_S2CSceneAttackFish = "PlayCtrl_S2CSceneAttackFish"
this.BagCtrl_S2CBagUpdate = "BagCtrl_S2CBagUpdate"--物品更新

this.MainCtrl_PlayInfoChange = "MainCtrl_PlayInfoChange"		--玩家信息改变
this.OnlineView_NewView = "OnlineView_NewView" --在线时长奖励刷新
this.OnlineView_GetInfo = "OnlineView_GetInfo" --在线时长奖励刷新
