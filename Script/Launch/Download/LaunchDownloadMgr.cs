using UnityEngine;
using System.Collections.Generic;
using System;
using System.IO;

namespace Launch
{
	public class LaunchDownloadMgr:Singleton<LaunchDownloadMgr>
	{
		public readonly float TICK_INTERVAL = 1f;

		public long versionCode = 0;

		private LaunchDownloadThread _downloadThread;
		private Queue<LaunchDownloadTask> _pendingTasks;
		private Queue<LaunchDownloadTask> _finishedTasks;
		private Queue<LaunchDownloadTask> _tempTasks;

		public string CurFile{get{ return _downloadThread.CurFile;}}
		public long CurReceivedLength{ get{return _downloadThread.CurReceivedLength; }}
		public long CurTotalLength{get{ return _downloadThread.CurTotalLength;}}

        private vp_Timer.Handle _timeHandle;

        public LaunchDownloadMgr()
		{
			_pendingTasks = new Queue<LaunchDownloadTask>();
			_finishedTasks = new Queue<LaunchDownloadTask>();
			_tempTasks = new Queue<LaunchDownloadTask> ();
			_downloadThread = new LaunchDownloadThread(_pendingTasks,_finishedTasks);
		}

		public void StartService()
		{
            if (_timeHandle != null) return;
            _downloadThread.Start();
            //使用时间定时器（现在用的是外部的）
            _timeHandle = new vp_Timer.Handle();
            vp_Timer.In(0.1f, this.Tick, 0, TICK_INTERVAL, _timeHandle);
		}

		public void StopService()
		{
            LH.Log("StopService,_timeHandle=null:"+ (_timeHandle == null));
            if(_timeHandle != null)
            {
                _timeHandle.Cancel();
                _timeHandle = null;
            }
            _downloadThread.Stop();
		}

		private void Tick()
		{
			_tempTasks.Clear ();
			lock(_finishedTasks)
			{
				while (_finishedTasks.Count > 0)
				{
					_tempTasks.Enqueue (_finishedTasks.Dequeue());
				}
			}
            //LH.Log("Tick,tempTasks:"+_tempTasks.Count);
			while (_tempTasks.Count > 0)
			{
				LaunchDownloadTask task = _tempTasks.Dequeue ();
				if(task != null)
				{
					task.onFinish(task);
				}
			}
		}

		public void AsyncDownloadList(List<string> list,string remoteDir,string localDir,Action<LaunchDownloadTask> onFinish,List<string> exts = null)
		{
			lock(_pendingTasks)
			{
				int count = list.Count;
				string url;
				for(int i = 0; i<count; ++i)
				{
					url = list[i];
					LaunchDownloadTask task = new LaunchDownloadTask();
					task.file = url;
					if(exts != null && exts.Count > i)
						url += exts[i];
					task.url = remoteDir+url;
					task.localPath = localDir+url;
					task.onFinish = onFinish;
					_pendingTasks.Enqueue(task);
//					Debug.Log ("<color='#ff0000'>[正在下载文件: " + task.url + "</color>");
				}

				if(_downloadThread.isWaitting)
				{
					_downloadThread.Notify();	
				}
			}
		}

		public void AsyncDownload(string url,string localPath,Action<LaunchDownloadTask> onFinish)
		{
			LaunchDownloadTask task = new LaunchDownloadTask();
			task.url = url;
			task.localPath = localPath;
			task.onFinish = onFinish;

			EnqueueTask(task);
		}

		private void EnqueueTask(LaunchDownloadTask task)
		{
			lock(_pendingTasks)
			{
				_pendingTasks.Enqueue(task);

				if(_downloadThread.isWaitting)
				{
					_downloadThread.Notify();	
				}
			}
		}
	}

}
