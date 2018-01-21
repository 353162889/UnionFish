using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_PhoneLocalRelease : CommandBase
    {
        private static string CompressBundleName = "bundle.zip";
        private Coroutine _coroutine;
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            LH.Log("释放本地bundle:" + ResourceFileUtil.ResourceLoadPath);
            _coroutine = LaunchCoroutineUtility.Instance.StartCoroutine(DoRealseCoroutine());
        }

        private IEnumerator DoRealseCoroutine()
        {
            LaunchHotUpdateView.Instance.UpdateProgress(0);
            float startPercent = 0;
            float stopPercent = 0.1f;
            float useTime = 1f;
            float curTime = 0;

            //先将zipFile文件下载下来
            string streamingDir = ResourceFileUtil.StreamingAssetsPath;
            string zipFile = ResourceFileUtil.FILE_SYMBOL + streamingDir + CompressBundleName;
            WWW www = new WWW(zipFile);
            while(!www.isDone)
            {
                curTime += Time.deltaTime;
                if(curTime < useTime)
                {
                    float percent = Mathf.Min(startPercent + (curTime / useTime) * (1 - startPercent), stopPercent);
                    LaunchHotUpdateView.Instance.UpdateProgress(percent);
                }
                yield return null;
            }
            LH.Log("DownloadTime:"+curTime);
            if (!string.IsNullOrEmpty(www.error))
            {
                LH.LogError("Load resource [" + zipFile + "] failed .error:" + www.error);
                this.OnDone(CommandStatus.Fail);
                yield break;
            }

            ThreadAsync async = LaunchThreadUtility.Instance.DoSomething(DoRelease,www.bytes);

            startPercent = LaunchHotUpdateView.Instance.GetProgress();
            stopPercent = 0.92f;
            useTime = 20f;
            curTime = 0f;
            while (!async.IsDone)
            {
                curTime += Time.deltaTime;
                if (curTime < useTime)
                {
                    //更新进度条
                    float percent = Mathf.Min(startPercent + (curTime / useTime) * (1 - startPercent), stopPercent);
                    LaunchHotUpdateView.Instance.UpdateProgress(percent);
                }
                yield return null;
            }
            LH.Log("UnCompressTime:" + curTime);
            if (!string.IsNullOrEmpty(async.Error))
            {
                LH.LogError("release pkg [" + zipFile + "] failed .error:" + async.Error);
                this.OnDone(CommandStatus.Fail);
                yield break;
            }

            startPercent = LaunchHotUpdateView.Instance.GetProgress();
            stopPercent = 0.92f;
            useTime = 1f;
            curTime = 0f;
            while (curTime < useTime)
            {
                curTime += Time.deltaTime;
                float percent = Mathf.Min(startPercent + (curTime / useTime) * (1 - startPercent), stopPercent);
                LaunchHotUpdateView.Instance.UpdateProgress(percent);
                yield return null;
            }
            LaunchHotUpdateView.Instance.UpdateProgress(1);
            _coroutine = null;
            this.OnDone(CommandStatus.Succeed);
        }

        private string DoRelease(object obj)
        {
            VersionMgr.Instance.DeleteAllLocal();
            byte[] bytes = (byte[])obj;
            string toDir = ResourceFileUtil.ResourceLoadPath;
            try
            { 
                LaunchCompress.UnCompress(bytes, toDir);
                return null;
            }catch(Exception e)
            {
                return e.Message+"\n"+e.StackTrace;
            }
        }

        protected override void OnDoneBefore()
        {
            base.OnDoneBefore();
        }

        public override void OnDestroy()
        {
            if(_coroutine != null)
            {
                LaunchCoroutineUtility.Instance.StopCoroutine(_coroutine);
                _coroutine = null;
            }
            base.OnDestroy();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_PhoneLocalRelease:" + status);
            base.OnDone(status);
        }
    }
}
