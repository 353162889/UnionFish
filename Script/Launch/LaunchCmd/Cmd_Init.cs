using UnityEngine;
using System.Collections;

namespace Launch
{ 
    public class Cmd_Init : CommandBase {
        

        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            this.OnInit();
            //初始化SDK
            Drive.drive.AddComponent<AppBridge>();
            SDKMgr.Init(OnSDKInit);
        }

        private void OnSDKInit(bool succ)
        {
            if(succ)
            {
                this.OnDone(CommandStatus.Succeed);
            }
            else
            {
                LH.Log("SDK初始化失败");
                this.OnDone(CommandStatus.Fail);
            }
        }

        private void OnInit()
        {
            //适配界面
            UISelfAdaption();
            //初始化热更界面
            Drive.drive.AddComponent<LaunchHotUpdateView>();
            Drive.drive.AddComponent<LaunchHotTipView>();
            Drive.drive.AddComponent<LaunchWWWLoader>();
            Drive.drive.AddComponent<LaunchCoroutineUtility>();
            Drive.drive.AddComponent<HttpConnnection>();
            Drive.drive.AddComponent<HttpMgr>();
            GameObject drive = GameObject.Find("UIRoot/Drive");
            GameObject updateView = drive.transform.FindChild("HotUpdateLoadingView").gameObject;
            LaunchHotUpdateView.Instance.Init(updateView);
            GameObject tipView = drive.transform.FindChild("HotUpdateTipView").gameObject;
            LaunchHotTipView.Instance.Init(tipView);
            LaunchHotUpdateView.Instance.Show();
            LaunchHotUpdateView.Instance.UpdateProgress(0);

            //初始化游戏配置
            GameConfig.Load();
            StatisticsMgr.Instance.SetUrl(GameConfig.StatisticServerUrl);
            StatisticsMgr.Instance.SetIsOpen(GameConfig.StatisticServerOpen);
            StatisticsMgr.Instance.RegisterErrorLog();//开始统计报错信息

#if (UNITY_EDITOR || UNITY_STANDALONE_WIN || UNITY_STANDALONE_OSX || UNITY_EDITOR_WIN)
            GameConfig.IsUsedSDK = false;
#endif
            //初始化资源管理器
            ResourceMgr.Instance.Init(GameConfig.IsResourceLoadMode);
            VersionMgr.Instance.Init();

            Language.Init(GameConfig.LanguageCode);

            string platform = "0";
            if(GameConfig.IsUsedSDK)
            {
                platform = SDKMgr.GetChannelId();
            }
            StatisticsMgr.Instance.SetPlatform(platform);
            StatisticsMgr.Instance.SetLanguage(GameConfig.LanguageCode);
            LaunchHotUpdateView.Instance.UpdateDesc(Language.GetString("初始化")+"...");
        }

        public readonly static int refWidth = 1280;
        public readonly static int refHeight = 720;
        public static float zoom { private set; get; }
        public void UISelfAdaption()
        {
            LH.Log("开始适配");
            //设置自适应
            GameObject uiRoot = GameObject.Find("UIRoot");
            UIRoot root = uiRoot.GetComponent<UIRoot>();
            int screenWidth = Screen.width;
            int screenHeight = Screen.height;
            LH.Log(string.Format("当前机器分辨率为：{0}X{1}", screenWidth, screenHeight));
            if (screenWidth * refHeight / screenHeight < refWidth)
            {
                LH.Log("需要重新计算高度");
                int val = refWidth * screenHeight / screenWidth;
                LH.Log(string.Format("设置高度为：{0}", val));
                //重新计算高度
                root.manualHeight = val;
                root.minimumHeight = val;
                root.maximumHeight = val;
            }
            else
            {
                LH.Log("不需要适配");
            }
            zoom = screenHeight / (float)refHeight;
        }

        protected override void OnDoneBefore()
        {
            base.OnDoneBefore();
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_Init:" + status);
            base.OnDone(status);
        }
    }
}
