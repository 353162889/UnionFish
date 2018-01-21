using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_LoadRemoteVersion : CommandBase
    {
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            LoadRemoteVersionData();
        }

        private void LoadRemoteVersionData()
        {
            VersionMgr.Instance.LoadRemoteVersionData(OnLoadRemoteVersion);
        }

        private void OnLoadRemoteVersion(bool succ,string txt)
        {
            if(!succ)
            {
                //加载远程文件失败,现在直接热更失败，退出游戏
                LaunchHotTipView.Instance.Open(Language.GetString("提 示"), Language.GetString("网络连接错误，请检查网络，是否需要重试？"), null, Language.GetString("确 认"), Language.GetString("取 消"),
                    () => {
                        LoadRemoteVersionData();
                    },
                    () => {
                        this.OnDone(CommandStatus.Fail);
                        Application.Quit();
                    },
                    () => {
                        this.OnDone(CommandStatus.Fail);
                        Application.Quit();
                    });
            }
            else
            { 
                this.OnDone(CommandStatus.Succeed);
            }
        }

        protected override void OnDoneBefore()
        {
            //停止获取服务器版本数据
            LaunchWWWLoader.Instance.StopLoadRes();
            base.OnDoneBefore();
        }

        public override void OnDestroy()
        {
            base.OnDestroy();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_LoadRemoteVersion:" + status);
            base.OnDone(status);
        }
    }
}
