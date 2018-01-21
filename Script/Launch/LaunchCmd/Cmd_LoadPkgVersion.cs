using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_LoadPkgVersion : CommandBase
    {
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            if(ResourceMgr.Instance.ResourcesLoadMode)
            {
                this.OnDone(CommandStatus.Succeed);
            }
            else
            {
                LoadPkgVersion();
            }
        }

        private void LoadPkgVersion()
        {
            //加载包内版本号
            bool succ = VersionMgr.Instance.LoadPkgVerData();
            //如果加载失败，说明打包就有问题，直接退出游戏
            if (!succ)
            {
                LaunchHotTipView.Instance.OpenCenter(Language.GetString("提 示"), Language.GetString("版本不对，请重新下载游戏。"),null, Language.GetString("确 认"),
                    ()=>{
                        this.OnDone(CommandStatus.Fail);
                        Application.Quit();
                    },()=>{
                        this.OnDone(CommandStatus.Fail);
                        Application.Quit();
                    });
            }
            else
            {
                this.OnDone(CommandStatus.Succeed);
            }
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_LoadPkgVersion:" + status);
            base.OnDone(status);
        }
    }
}
