using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_EditorLocalRelease : CommandBase
    {
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
            ThreadAsync async = LaunchThreadUtility.Instance.DoSomething(DoRelease);

            float totalTime = 20f;
            float curTime = 0;
            float stopProgress = 0.92f;
            while (!async.IsDone)
            {
                curTime += Time.deltaTime;
                if(curTime < totalTime)
                {
                    //更新进度条
                    float percent = Mathf.Min(curTime / totalTime, stopProgress);
                    LaunchHotUpdateView.Instance.UpdateProgress(percent);
                }
                yield return null;
            }
            LH.Log("CopyFileTime:" + curTime);
            if (!string.IsNullOrEmpty(async.Error))
            {
                this.OnDone(CommandStatus.Fail);
                yield break;
            }

            curTime = 0;
            totalTime = 1f;
            float startPercent = LaunchHotUpdateView.Instance.GetProgress();
            while(curTime < totalTime)
            {
                curTime += Time.deltaTime;
                float percent = Mathf.Min(startPercent + (curTime / totalTime) * (1 - startPercent), 1);
                LaunchHotUpdateView.Instance.UpdateProgress(percent);
                yield return null;
            }
            LaunchHotUpdateView.Instance.UpdateProgress(1);

            this.OnDone(CommandStatus.Succeed);
        }

        private string DoRelease(object obj)
        {
            //使用线程做处理
            string streamingDir = ResourceFileUtil.StreamingAssetsPath;
            string localDir = ResourceFileUtil.ResourceLoadPath;
            VersionMgr.Instance.DeleteAllLocal();
            //如果是editor下，直接拷贝到persistance目录下
            bool succ = ResourceFileUtil.Instance.CopyDirectory(streamingDir, localDir);
            return succ ? null : "fail";
        }

        protected override void OnDoneBefore()
        {
            base.OnDoneBefore();
        }

        public override void OnDestroy()
        {
            if (_coroutine != null)
            {
                LaunchCoroutineUtility.Instance.StopCoroutine(_coroutine);
                _coroutine = null;
            }
            base.OnDestroy();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_EditorLocalRelease:" + status);
            base.OnDone(status);
        }
    }
}
