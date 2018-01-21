using System;
using UnityEngine;
using System.Collections;


namespace Launch
{
    public class StatisticsMgr : Singleton<StatisticsMgr>
    {
        private string _userId = "";
        private string _userName = "";
        private string _url;
        private bool _isOpen = false;
        private string _preErrorMsg;
        private string _platform;
        private string _language;

        public void SetUserId(string userId, string userName)
        {
            _userId = userId;
            _userName = userName;
            PlayerPrefs.SetString("LastUserId", _userId.ToString());
            PlayerPrefs.SetString("LastUserName", _userName);
            PlayerPrefs.Save();
        }

        public void SetUrl(string url)
        {
            _url = url;
        }

        public void SetIsOpen(bool isOpen)
        {
            _isOpen = isOpen;
        }

        public void SetPlatform(string platform)
        {
            this._platform = platform;
        }

        public void SetLanguage(string language)
        {
            this._language = language;
        }

        public StatisticsMgr()
        {
            _userId = PlayerPrefs.GetString("LastUserId", "unknown");
            _userName = PlayerPrefs.GetString("LastUserName", "unknown");
        }

        public void RegisterErrorLog()
        {
            if (Application.isMobilePlatform || _isOpen)
            {
                Application.logMessageReceived += OnUnityLog;
            }
        }

        private void OnUnityLog(string message, string stackTrace, LogType type)
        {
            if (type == LogType.Error || type == LogType.Exception)
            {
                string errorMsg = message + "\n" + stackTrace;
                SendErrorLog(errorMsg);
            }
        }

        //private void AddHeader(WWWForm form, string data)
        //{
        //    string result = string.Format("userId={0},userName={1}\r\n{3}",_userId,_userName,data);
        //    form.AddField("data", result);
        //    //form.AddField("userid", _userId);
        //    //form.AddField("username", _userName);
        //    //form.AddField("platform", _platform.ToString());
        //    //form.AddField("opcode", ((int)opcode).ToString());
        //    //form.AddField("qdata", data);
        //}

        private void SendErrorLog(string errorMsg)
        {
            if(string.IsNullOrEmpty(_preErrorMsg) || (string.IsNullOrEmpty(_preErrorMsg) && errorMsg.Length != _preErrorMsg.Length))
            {
                LH.logRecorder.LogError(errorMsg);

                if (!string.IsNullOrEmpty(_url))
                {
                    WWWForm form = new WWWForm();
                    string result = string.Format("userId={0},userName={1}\n{2}", _userId, _userName, errorMsg);
                    form.AddField("data", result);
                    form.AddField("ClientName", string.Format("{0}_{1}",_platform,_language));
                    HttpConnnection.Instance.RequestWithForm(_url, form);
                }
            }
            
        }
    }
}
