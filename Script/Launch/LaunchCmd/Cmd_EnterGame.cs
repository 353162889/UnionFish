using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Launch
{
    public class Cmd_EnterGame : CommandBase
    {
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            //初始化时间管理器
            TimeMgr.initMgr();

            //初始化lua管理器
            LuaMgr.instance.Init();

            //初始化网络(放入lua中初始化)
            //Client.Instance.Init();

            //启动lua代码
            LuaMgr.instance.StartGame();

            LaunchHotUpdateView.Instance.Close(true);
            Drive.IsStartGame = true;
            this.OnDone(CommandStatus.Succeed);
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
            LH.Log("Cmd_EnterGame:" + status);
            base.OnDone(status);
        }
    }
}
