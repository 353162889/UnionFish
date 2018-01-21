using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_InitAssetBundleMgr : CommandBase
    {
        private static string MainEntryFile = "asset_bundle_entry.xml";

        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            if (!ResourceMgr.Instance.ResourcesLoadMode)
            {
                ResourceMgr.Instance.GetResource(MainEntryFile, OnLoadEntryFile, OnLoadEntryFile, ResourceType.Text);
            }
            else
            { 
                this.OnDone(CommandStatus.Succeed);
            }
        }

        private void OnLoadEntryFile(Resource res)
        {
            if(res.isSucc)
            { 
                string str = res.GetText();
                AssetBundleMgr.Instance.Init(str);
                //加载依赖文件
                ResourceMgr.Instance.GetResource(AssetBundleMgr.Instance.MainAssetBundlePath, OnLoadDependFile, OnLoadDependFile);
            }
            else
            {
                this.OnDone(CommandStatus.Fail);
            }
        }

        private void OnLoadDependFile(Resource res)
        {
            if (res.isSucc)
            {
                AssetBundleManifest manifest = (AssetBundleManifest)res.GetAsset(null);
                AssetBundleMgr.Instance.AddAssetBundleManifest(manifest);
                this.OnDone(CommandStatus.Succeed);
            }
            else
            {
                this.OnDone(CommandStatus.Fail);
                LH.LogError("加载依赖文件失败!path=" + AssetBundleMgr.Instance.MainAssetBundlePath);
            }
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
            LH.Log("Cmd_InitAssetBundleMgr:" + status);
            base.OnDone(status);
        }
    }
}
