using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_LoadLocalVersion : CommandBase
    {
        private static string CompressBundleName = "bundle.zip";
        private CommandBase _cmdRelease;
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            if (ResourceMgr.Instance.ResourcesLoadMode)
            {
                this.OnDone(CommandStatus.Succeed);
            }
            else
            {
                LoadLocalVersion();
            }
        }

        private void LoadLocalVersion()
        {
            //加载本地版本号
            bool succ = VersionMgr.Instance.LoadLocalVerData();
            //如果加载失败，说明本地文件没有或出现错误，删除本地文件，重新释放包内文件
            if (!succ)
            {
                ReleasePkgAsset((bool releaseSucc) => {
                    if (!releaseSucc)
                    {
                        this.OnDone(CommandStatus.Fail);
                        return;
                    }
                    bool loadSucc = VersionMgr.Instance.LoadLocalVerData();
                    if (!loadSucc)
                    {
                        this.OnDone(CommandStatus.Fail);
                        return;
                    }
                    CheckVersionCode();
                });
            }
            else
            {
                CheckVersionCode();
            }
        }

        private void CheckVersionCode()
        {
            //对比包内版本号与本地版本号,如果本地包版本号不等于包内热更版本号或本地热更版本号比包内热更版本号还小，说明本地版本是有问题的(重新释放资源)
            if (VersionMgr.Instance.pkgVerData.PkgVersionCode != VersionMgr.Instance.localVerData.PkgVersionCode
                || VersionMgr.Instance.pkgVerData.HotVersionCode > VersionMgr.Instance.localVerData.HotVersionCode)
            {
                string versionDebug = "包内版本号与本地版本号不对应，重新释放资源,[pkg]pkgVersion:{0},[pkg]hotVersion:{1},[local]pkgVersion:{2},[local]hotVersion:{3}";
                LH.Log(string.Format(versionDebug, VersionMgr.Instance.pkgVerData.PkgVersionCode, VersionMgr.Instance.pkgVerData.HotVersionCode,
                    VersionMgr.Instance.localVerData.PkgVersionCode, VersionMgr.Instance.localVerData.HotVersionCode));
                ReleasePkgAsset((bool releaseSucc)=> {
                    if (!releaseSucc)
                    {
                        this.OnDone(CommandStatus.Fail);
                        return;
                    }
                    bool loadSucc = VersionMgr.Instance.LoadLocalVerData();
                    if (!loadSucc)
                    {
                        this.OnDone(CommandStatus.Fail);
                        return;
                    }
                    this.OnDone(CommandStatus.Succeed);
                });
                
            }
            else
            {
                this.OnDone(CommandStatus.Succeed);
            }
        }

        private void ReleasePkgAsset(Action<bool> callback = null)
        {
            if(_cmdRelease != null)
            {
                _cmdRelease.OnDestroy();
                _cmdRelease = null;
            }
            if(Application.isEditor)
            {
                _cmdRelease = new Cmd_EditorLocalRelease();
            }
            else
            {
                _cmdRelease = new Cmd_PhoneLocalRelease();
            }
            LaunchHotUpdateView.Instance.UpdateDesc(Language.GetString("精彩内容正在加载，不浪费任何流量。"));
            _cmdRelease.OnCmdDone += (CommandBase cmd) => {
                if(callback != null)
                {
                    bool succ = cmd.Status == CommandStatus.Succeed;
                    Action<bool> temp = callback;
                    callback = null;
                    temp.Invoke(succ);
                }
            };
            _cmdRelease.OnStart();
        }

//        protected void ReleasePkgAssetCoroutine(Action<bool> callback = null)
//        {
//            VersionMgr.Instance.DeleteAllLocal();
//            string streamingDir = ResourceFileUtil.StreamingAssetsPath;
//            string localDir = ResourceFileUtil.ResourceLoadPath;
//            LH.Log("释放本地bundle:" + localDir);
//            bool succ = false;
//#if UNITY_EDITOR
//            //如果是editor下，直接拷贝到persistance目录下
//            succ = ResourceFileUtil.Instance.CopyDirectory(streamingDir, localDir);
//            if (callback != null)
//            {
//                Action<bool> temp = callback;
//                callback = null;
//                temp.Invoke(succ);
//            }
//#else
//            string zipFile = ResourceFileUtil.FILE_SYMBOL + streamingDir + CompressBundleName;
//            //先将zipFile文件下载下来
//            LaunchWWWLoader.Instance.WWWRequest(zipFile, null, (WWW www) => {
//                if (string.IsNullOrEmpty(www.error))
//                {
//                    string toDir = ResourceFileUtil.ResourceLoadPath;
//                    LaunchCompress.UnCompress(www.bytes, toDir);
//                    if (callback != null)
//                    {
//                        Action<bool> temp = callback;
//                        callback = null;
//                        temp.Invoke(true);
//                    }
//                }
//                else
//                {
//                    if (callback != null)
//                    {
//                        Action<bool> temp = callback;
//                        callback = null;
//                        temp.Invoke(false);
//                    }
//                }
//            });
//#endif
//        }

        protected override void OnDoneBefore()
        {
            LaunchWWWLoader.Instance.StopLoadRes();
            if(_cmdRelease != null)
            {
                _cmdRelease.OnDestroy();
                _cmdRelease = null;
            }
            base.OnDoneBefore();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_LoadLocalVersion:" + status);
            base.OnDone(status);
        }
    }
}
