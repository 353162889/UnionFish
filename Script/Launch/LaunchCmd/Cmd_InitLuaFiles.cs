using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_InitLuaFiles : CommandBase
    {
        private static string ResourceLuaFiles = "LuaCode/LuaCodes.bytes";
        private static string LuaAssetBundleFile = "luacode/luacode.assetbundle";

        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            if (ResourceMgr.Instance.ResourcesLoadMode)
            {
                //Editor下直接运行游戏
                if (!Application.isEditor)
                {
                    LaunchHotUpdateView.Instance.UpdateProgress(0);
                }
            }
            LaunchPreload.Instance.PreloadLua(OnFinish,OnProgress);
        }

        private void OnProgress(float percent)
        {
            LaunchHotUpdateView.Instance.UpdateProgress(percent);
        }

        private void OnFinish(bool succ)
        {
            if (succ)
            {
                LaunchHotUpdateView.Instance.UpdateProgress(1);
                this.OnDone(CommandStatus.Succeed);
            }
            else
            {
                this.OnDone(CommandStatus.Fail);
            }
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_InitLuaFiles:" + status);
            base.OnDone(status);
        }
    }
}
