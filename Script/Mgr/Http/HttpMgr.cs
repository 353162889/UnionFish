using Launch;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class HttpMgr : SingletonMonoBehaviour<HttpMgr>
{
    public delegate void WebViewCallback(string url);
    public event WebViewCallback OnLoadFail;
    public event WebViewCallback OnLoadFinish;
    public event WebViewCallback OnLoadStart;

    private WebViewBehavior webView;
    private HttpCallback callback;
    private bool _isVisiable;
    public bool IsVisiable { get { return _isVisiable; } }
    protected override void Awake()
    {
        base.Awake();
        webView = gameObject.AddComponent<WebViewBehavior>();
        callback = new HttpCallback(this);
        webView.setCallback(callback);
        _isVisiable = false;
    }

    protected void OnUrlLoadFail(string url)
    {
        if (OnLoadFail != null)
        {
            OnLoadFail(url);
        }
    }

    protected void OnUrlLoadFinish(string url)
    {
        if (OnLoadFinish != null)
        {
            OnLoadFinish(url);
        }
    }

    protected void OnUrlLoadStart(string url)
    {
        if (OnLoadStart != null)
        {
            OnLoadStart(url);
        }
    }

    public void SetMargins(int left, int top, int right, int bottom)
    {
        webView.SetMargins(left, top, right, bottom);
    }

    public void SetVisibility(bool state)
    {
        webView.SetVisibility(state);
        _isVisiable = state;
    }

    public void LoadURL(string url)
    {
        url = url.Replace(" ", "%20");
        LH.Log("httpMgr:[LoadURL],url:" + url);
        webView.LoadURL(url);
        this.SetVisibility(true);
    }

    public void PostURL(string url, Dictionary<string, string> dic)
    {
        url = url.Replace(" ", "%20");
        LH.Log("httpMgr:[PostURL],url:" + url);
        webView.ClearView();
        webView.PostURL(url, dic);
        this.SetVisibility(true);
    }

    public void PostURL(string url, string param)
    {
        url = url.Replace(" ", "%20");
        LH.Log("httpMgr:[PostURL],url:" + url);
        webView.ClearView();
        webView.PostURL(url, param);
        this.SetVisibility(true);
    }

    public void EvaluateJS(string js)
    {
        webView.EvaluateJS(js);
    }

    public class HttpCallback : Kogarasi.WebView.IWebViewCallback
    {
        private HttpMgr mgr;
        public HttpCallback(HttpMgr mgr)
        {
            this.mgr = mgr;
        }

        public void onLoadFail(string url)
        {
            LH.Log("httpMgr:[onLoadFail],url:" + url);
            this.mgr.SetVisibility(false);
            this.mgr.OnUrlLoadFail(url);
        }

        public void onLoadFinish(string url)
        {
            LH.Log("httpMgr:[onLoadFinish],url:" + url);
            this.mgr.OnUrlLoadFinish(url);
        }

        public void onLoadStart(string url)
        {
            LH.Log("httpMgr:[onLoadStart],url:" + url);
            this.mgr.OnUrlLoadStart(url);
        }
    }
}
