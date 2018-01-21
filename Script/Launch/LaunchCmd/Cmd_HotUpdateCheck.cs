using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_HotUpdateCheck : CommandBase
    {
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            if(GameConfig.IsHotUpdateMode)
            {
                LoadRemoteVersion();
            }
            else
            {
                //不热更
                this.OnDone(CommandStatus.Fail);
            }

        }

        private void LoadRemoteVersion()
        {
            VersionMgr.Instance.LoadRemoteVersionCode(OnLoadRemoteVersion);
        }

        private void OnLoadRemoteVersion(bool succ, string txt)
        {
            if (!succ)
            {
                //打开提示框，点击后退出游戏?
                LaunchHotTipView.Instance.Open(Language.GetString("提 示"), Language.GetString("网络连接错误，请检查网络，是否需要重试？"), null, Language.GetString("确 认"), Language.GetString("取 消"),
                    () => {
                        LoadRemoteVersion();
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
                if(VersionMgr.Instance.IsPackageNew())
                { 
                    if(VersionMgr.Instance.IsClientNew())
                    {
                        //不热更
                        this.OnDone(CommandStatus.Fail);
                    }
                    else
                    {
                        //热更
                        this.OnDone(CommandStatus.Succeed);
                    }
                }
                else
                {
                    //打开提示框，点击后退出游戏?
                    LaunchHotTipView.Instance.Open(Language.GetString("提 示"), Language.GetString("当前版本过低，请下载最新版本"), null, Language.GetString("去下载"), Language.GetString("取 消"),
                        () => {
                            Application.OpenURL(GameConfig.PkgUpdateUrl);
                            this.OnDone(CommandStatus.Fail);
                            Application.Quit();
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
            LH.Log("Cmd_HotUpdateCheck:" + status);
            if(status == CommandStatus.Succeed)
            {
                LH.Log("execute hotUpdate!");
            }
            base.OnDone(status);
        }
    }
}
