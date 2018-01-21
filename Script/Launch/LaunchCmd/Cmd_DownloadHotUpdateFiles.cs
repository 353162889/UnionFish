using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class Cmd_DownloadHotUpdateFiles : CommandBase
    {
        public readonly float TICK_INTERVAL = 0.1f;
        private readonly float SPEED_TIME = 1f;
        private readonly float DownloadIncreaseSP = 0.05f;
        private string UpdateFormationStr;
        private string DownloadDesc;
        private static float ConvertSize = 1024f * 1024f;
        private static float SaveVersionDataSize = 5 * ConvertSize;		//5M保存一下版本文件

        private List<string> _updateList;
        private List<string> _extList;
        private long _curDownLoadLength;
        private long _preDownLoadLength;
        private long _preSaveVersionDataLength;
        private float _totalSize;
        private float _preSpeed;
        private float _curSpeed;
        private int _curIndex;

        private float _curViewProgress;
        private float _useTime;

        private vp_Timer.Handle _timeHandle;
        public override void OnStart(ICommandContext context)
        {
            base.OnStart(context);
            UpdateFormationStr = Language.GetString("正在更新：{0} MB/ {1} MB 速度{2}kb/s");
            DownloadDesc = Language.GetString("游戏版本需要更新，更新内容大小为{0}MB，点击确定进行下载更新，点击取消退出游戏。");
            BeginHotUpdate();
        }

        private void BeginHotUpdate()
        {
            _updateList = VersionMgr.Instance.FindUpdateList();
            if (_updateList.Count > 0)
            {
                BeforeDownload();
            }
            else
            {
                LH.Log("[Cmd_DownloadHotUpdateFiles]no file need hotupdate!");
                //直接更新本地版本号
                VersionMgr.Instance.UpdateLocalToNew();
                VersionMgr.Instance.SaveLocalVersionData();
                VersionMgr.Instance.OnUpdateDone();
                this.OnDone(CommandStatus.Succeed);
            }
        }

        private void BeforeDownload()
        {
            _curIndex = 0;
            _curDownLoadLength = 0;
            _preDownLoadLength = 0;
            _preSaveVersionDataLength = 0;
            _preSpeed = 0f;
            _useTime = 0f;
            _extList = new List<string>(_updateList.Count);
            long fileTotalLength = 0;
            for (int i = 0; i < _updateList.Count; i++)
            {
                FileVersionData versionData = VersionMgr.Instance.remoteVerData.GetFileVersion(_updateList[i]);
                _extList.Add("?vr=" + versionData.crc);
                fileTotalLength += versionData.size;
            }
            _totalSize = fileTotalLength / ConvertSize;
            LH.Log("<color='#ff0000'>[开始准备下载文件]文件总数: " + _updateList.Count + ",文件大小:" + _totalSize + "MB</color>");
            string totalSizeFormat = _totalSize.ToString("#0.0");
            //设置进度条
            SetViewProgress(0);
            //下载描述
            string desc = string.Format(DownloadDesc, totalSizeFormat);
            //下载进度条描述
            
            string loadingTipsDesc = string.Format(UpdateFormationStr, "0.0", totalSizeFormat,"0.0");
            SetViewDesc(loadingTipsDesc);
            NetState netState = AppBridge.Instance.getWifiNetworkState();
            //if(netState == NetState.CONNECTED || netState == NetState.CONNECTING)
            //{
            //    //开始下载
            //    LaunchCoroutineUtility.Instance.WaitAndExecute(0.1f, () =>
            //    {
            //        DownloadUpdateList();
            //    });
            //}
            //else
            //{
                LaunchHotTipView.Instance.Open(Language.GetString("提 示"), desc,
                    null, Language.GetString("确 定"), Language.GetString("取 消"), 
                    () => {
                        //开始下载
                        LaunchCoroutineUtility.Instance.WaitAndExecute(0.1f, () =>
                        {
                            DownloadUpdateList();
                        });
                    }, 
                    () => {
                        Application.Quit();
                    }, 
                    () => {
                        Application.Quit();
                    });
            //}
            
        }

        private void DownloadUpdateList()
        {
            LH.Log("DownloadUpdateList");
            LaunchDownloadMgr.Instance.versionCode = VersionMgr.Instance.remoteVerData.HotVersionCode;
            LaunchDownloadMgr.Instance.StartService();
            _timeHandle = new vp_Timer.Handle();
            vp_Timer.In(0, this.OnTime, 0, TICK_INTERVAL, _timeHandle);

            string remoteRootPath = ResourceFileUtil.Instance.GetRemotePath(GameConfig.ServerUrl,"");
            LaunchDownloadMgr.Instance.AsyncDownloadList(_updateList, remoteRootPath,
                ResourceFileUtil.ResourceLoadPath, OnFileDownload, null);
        }

        private void OnFileDownload(LaunchDownloadTask task)
        {
            if (task.status == LaunchDownloadStatus.Complete)
            {
                LH.Log("OnFileDownload:"+task.file);
                VersionMgr.Instance.UpdateFileToNew(task.file);
                _curDownLoadLength += task.fileLength;

                if (_curDownLoadLength - _preSaveVersionDataLength > SaveVersionDataSize)
                {
                    _preSaveVersionDataLength = _curDownLoadLength;
                    VersionMgr.Instance.SaveLocalVersionData();
                    LH.Log("save local versionData by " + SaveVersionDataSize + " MB");
                }

                if (++_curIndex >= _updateList.Count)
                {
                    OnAllDownloaded();
                }
            }
            else
            {
                LH.Log("Failed:" + _updateList[_curIndex] + "," + task.errorCode.ToString());
                LaunchCoroutineUtility.Instance.WaitAndExecute(0.1f, () => {
                    LaunchDownloadMgr.Instance.StopService();
                    //失败了也需要保存当前已更新的版本数据
                    VersionMgr.Instance.SaveLocalVersionData();
                    if (LaunchDownloadError.DiskFull == task.errorCode)
                    {
                        SetViewDesc(Language.GetString("内存不足，更新失败。"));
                        LaunchHotTipView.Instance.Open(Language.GetString("提 示"), Language.GetString("空间不足，可先清理空间。是否需要重试？"), null, Language.GetString("确 认"), Language.GetString("取 消"),
                            () => {
                                LH.Log("LaunchDownloadMgr.Instance.StartService();");
                                LaunchDownloadMgr.Instance.StartService();
                            },
                            () => {
                                this.OnDone(CommandStatus.Fail);
                                Application.Quit();
                            },
                            () => {
                                this.OnDone(CommandStatus.Fail);
                                Application.Quit();
                            });
                        LH.LogError("下载错误，设备存储空间不足，请先清理系统");
                    }
                    else
                    {
                        SetViewDesc(Language.GetString("更新失败，请检查网络。"));
                        LaunchHotTipView.Instance.Open(Language.GetString("提 示"), Language.GetString("网络连接错误，请检查网络，是否需要重试？"), null, Language.GetString("确 认"), Language.GetString("取 消"),
                            () => {
                                LH.Log("LaunchDownloadMgr.Instance.StartService();");
                                LaunchDownloadMgr.Instance.StartService();
                            },
                            () => {
                                this.OnDone(CommandStatus.Fail);
                                Application.Quit();
                            },
                            () => {
                                this.OnDone(CommandStatus.Fail);
                                Application.Quit();
                            });
                        LH.LogError("网络连接错误，请检查网络情况");
                    }
                });
            }
        }
        //用来做进度条
        private void OnTime()
        {
            _useTime += TICK_INTERVAL;
            long receiveLength;
            if (_curIndex < _updateList.Count && LaunchDownloadMgr.Instance.CurFile == _updateList[_curIndex])
            {
                receiveLength = LaunchDownloadMgr.Instance.CurReceivedLength + _curDownLoadLength;
            }
            else
            {
                receiveLength = _curDownLoadLength;
            }
            float finishDownLoad = receiveLength / ConvertSize;
            float curProgress = GetViewProgress() * _totalSize;
            if (finishDownLoad < curProgress)
            {
                finishDownLoad = curProgress;
            }
            if (finishDownLoad > _totalSize)
                finishDownLoad = (float)_totalSize;
            _curSpeed = (finishDownLoad - curProgress) / 1f;

            if(_totalSize > 0)
            { 
                float realProgress = Mathf.MoveTowards(curProgress, finishDownLoad, _curSpeed * TICK_INTERVAL) / _totalSize;
                //更新进度条
                SetViewProgress(realProgress);
            }
            string finishDownLoadFormat = finishDownLoad.ToString("#0.0");
            string totalSizeFormat = _totalSize.ToString("#0.0");
            string speedStr = (_preSpeed * 1024f).ToString("#0.0");
            if (_useTime > SPEED_TIME)
            {
                _useTime = 0f;
                float speed = DownloadIncreaseSP;
                float subSpeed = Mathf.Abs(_curSpeed - _preSpeed) * 0.2f;
                if (subSpeed > DownloadIncreaseSP)
                {
                    speed = subSpeed;
                }
                _preSpeed = Mathf.MoveTowards(_preSpeed, _curSpeed, speed);
            }
            string desc = string.Format(UpdateFormationStr, finishDownLoadFormat, totalSizeFormat, speedStr);
            //更新当前显示
            SetViewDesc(desc);

           
        }

        //progress的总量是_totalSize
        private void SetViewProgress(float progress)
        {
            _curViewProgress = progress;
            LaunchHotUpdateView.Instance.UpdateProgress(_curViewProgress);
        }

        private float GetViewProgress()
        {
            return _curViewProgress;
        }

        private void SetViewDesc(string desc)
        {
            LaunchHotUpdateView.Instance.UpdateDesc(desc);
        }

        private void OnAllDownloaded()
        {
            _updateList.Clear();
            SetViewProgress(1);
            LaunchDownloadMgr.Instance.StopService();
            if(_timeHandle != null)
            {
                _timeHandle.Cancel();
                _timeHandle = null;
            }

            VersionMgr.Instance.UpdateLocalToNew();
            VersionMgr.Instance.SaveLocalVersionData();
            VersionMgr.Instance.OnUpdateDone();
            VersionMgr.Instance.DeleteUnuseLocal();
            this.OnDone(CommandStatus.Succeed);
        }


        protected override void OnDoneBefore()
        {
            LaunchDownloadMgr.Instance.StopService();
            if (_timeHandle != null)
            {
                _timeHandle.Cancel();
                _timeHandle = null;
            }
            base.OnDoneBefore();
        }

        public override void OnDestroy()
        {
            LaunchDownloadMgr.Instance.StopService();
            base.OnDestroy();
        }

        protected override void OnDone(CommandStatus status)
        {
            LH.Log("Cmd_DownloadHotUpdateFiles:" + status);
            base.OnDone(status);
        }
    }
}
