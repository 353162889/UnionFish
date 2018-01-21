using UnityEngine;
using System.Collections;
using System;


namespace Launch
{
    public delegate void HttpConnCallback(bool isSuccess, string msg);

    public class HttpConnnection : SingletonMonoBehaviour<HttpConnnection>
    {
        public void RequestWithForm(string url, WWWForm form, HttpConnCallback callback = null)
        {
            StartCoroutine(AysnRequest(url, form, callback));
        }

        IEnumerator AysnRequest(string url, WWWForm form, HttpConnCallback callback)
        {
            WWW www;
            if (form == null)
            {
                www = new WWW(url);
            }
            else
            {
                www = new WWW(url, form);
            }

            yield return www;

            if (callback != null)
            {
                if (!string.IsNullOrEmpty(www.error))
                {
                    LH.LogError("request url:"+url+" error,errorInfo:"+www.error);
                    callback(false, www.error);
                }
                else
                {
                    callback(true, www.text);
                }
            }
        }
    }
}
