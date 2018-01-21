ItemType = {}
ItemType.Money = 1	--货币类型
ItemType.Item = 2  	--物品类型
ItemType.Show = 3	--前端显示类型
ItemType.GiftBag = 4	--礼包类型
ItemType.Func = 5		--功能类型

UnitFishAnim = {}
UnitFishAnim.standby01='standby01'
UnitFishAnim.standby02='standby02'
UnitFishAnim.standby03='standby03'
UnitFishAnim.swim='swim'
UnitFishAnim.hit='hit'
UnitFishAnim.dead='dead'
UnitFishAnim.levelup = 'levelup'
UnitFishAnim.leveldown = 'leveldown'

UnitFishLayer = {}
UnitFishLayer.CameraFishLayer = LayerMask.NameToLayer("CameraFish")
UnitFishLayer.FishLayer = LayerMask.NameToLayer("Fish")

UnitFishType = {}
UnitFishType.GoldFish = 7	--彩金鱼
UnitFishType.BigFish = 3	--大鱼
UnitFishType.EliteFish = 4	--精英
UnitFishType.ThemeFish = 5	--主题
UnitFishType.BossFish = 6	--boss

UnitFishMPType = {}
UnitFishMPType.Center = 1	--中心挂点
UnitFishMPType.Head = 2	--头顶挂点
UnitFishMPType.Bubble = 3 -- 说话挂点

IslandType = {}
IslandType.TestFish = 2	--测试渔场
IslandType.Normal = 3	--一般渔场

TaskType = {}
TaskType.Fish = 1	--专业捕鱼
TaskType.Guide = 6	--引导任务
TaskType.Main = 5	--主线任务


GuideClientTaskKeyType = {}		--指引类型
GuideClientTaskKeyType.FishDic = 1 --查看鱼图鉴
GuideClientTaskKeyType.ChangeGun = 2 -- 换炮
GuideClientTaskKeyType.LookFor = 3 -- 完成寻宝抽奖
GuideClientTaskKeyType.RotationDisc = 4 -- 完成转盘抽奖
GuideClientTaskKeyType.JoinFishScene = 5 -- 重返渔场
GuideClientTaskKeyType.GunRateUnlock = 6	--炮倍解锁

SortingLayer = {}
SortingLayer.UI = "UI"

ResourceType = {}
ResourceType.AssetBundle = 1
ResourceType.Bytes = 2
ResourceType.AudioClip = 3
ResourceType.Movie = 4
ResourceType.Text = 5
ResourceType.Texture = 6
ResourceType.UnKnow = 7

SDKEventStatus = {}
--用户
SDKEventStatus.InitSuccess = 0	--SDK初始化成功事件
SDKEventStatus.InitFail = 1 	--SDK初始化失败事件
SDKEventStatus.LoginSuccess = 2	--SDK登录成功时间
SDKEventStatus.LoginNetworkError = 3 	--登陆失败回调
SDKEventStatus.LoginNoNeed = 4		--登陆失败回调
SDKEventStatus.LoginFail = 5 		--登陆失败回调
SDKEventStatus.LoginCancel = 6 		--登陆取消回调
SDKEventStatus.LogoutSuccess = 7 	--登出成功回调
SDKEventStatus.LogoutFail = 8		--登出失败回调
SDKEventStatus.PlatformEnter = 9	--平台中心进入回调
SDKEventStatus.PlatformBack = 10	--平台中心退出回调
SDKEventStatus.PausePage = 11		--暂停界面回调
SDKEventStatus.ExitPage = 12		--退出游戏回调
SDKEventStatus.AntiAddictionQuery = 13	--防沉迷查询回调
SDKEventStatus.RealNameRegister = 14	--实名注册回调
SDKEventStatus.AccountSwitchSuccess = 15 	--切换账号成功回调
SDKEventStatus.AccountSwitchFail = 16	--切换账号失败回调
SDKEventStatus.OpenShop = 17			--应用汇  悬浮窗点击粮饷按钮回调
SDKEventStatus.AccountSwitchCancel = 18	--切换账号取消
SDKEventStatus.GameExitPage = 19		--退出游戏页
--支付
SDKEventStatus.PaySuccess = 1000		-- 支付成功 
SDKEventStatus.PayFail=1001				-- 支付失败 
SDKEventStatus.PayCancel=1002			-- 支付取消 
SDKEventStatus.PayNetworkError=1003		--  支付网络出现错误 
SDKEventStatus.PayProductionInforIncomplete=1004-- 支付信息提供不完全
SDKEventStatus.PayInitSuccess=1005		--支付初始化成功 
SDKEventStatus.PayInitFail=1006			--支付初始化失败 
SDKEventStatus.PayNowPaying=1007		--正在支付 
SDKEventStatus.PayRechargeSuccess=1008-- value is callback of  succeeding in recharging. 


SDKUserInfoType = {}
SDKUserInfoType.JoinGame = 1 	--进入游戏
SDKUserInfoType.CreateRole = 2 	--创建角色
SDKUserInfoType.RoleLevelUp = 3 	--角色升级
SDKUserInfoType.Eixt = 4 			--退出
