using Launch;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public enum NetState
{
    CONNECTED = 0,
    CONNECTING = 1,
    DISCONNECTED = 2,
    DISCONNECTING = 3,
    SUSPENDED = 4,
    UNKNOWN = 5
}

public class AppBridge : SingletonMonoBehaviour<AppBridge>
{
    private AndroidJavaObject bridgeObj = null;
    protected override void Awake()
    {
        base.Awake();

#if !UNITY_EDITOR && (UNITY_ANDROID)
        if (bridgeObj == null)
        {
             using (AndroidJavaClass appClass = new AndroidJavaClass("com.zhongju.buyu.app.UnityAppBridge"))
            {
                bridgeObj = appClass.GetStatic<AndroidJavaObject>("curAppBridge");
            }
        }
#endif
    }

    public T Call<T>(string method,params object[] param)
    {
        try
        {
            return bridgeObj.Call<T>(method, param);
        }
        catch (Exception e)
        {
            LH.LogError(e.Message+"\n"+e.StackTrace);
        }
        return default(T);
    }

    public void Call(string method,params object[] param)
    {

        try
        {
            bridgeObj.Call(method, param);
        }
        catch (Exception e)
        {
            LH.LogError(e.Message + "\n" + e.StackTrace);
        }
    }

    public T CallStatic<T>(string method, params object[] param)
    {
        try
        {
            return bridgeObj.CallStatic<T>(method, param);
        }
        catch (Exception e)
        {
            LH.LogError(e.Message + "\n" + e.StackTrace);
        }
        return default(T);
    }

    public void CallStatic(string method, params object[] param)
    {
        try
        {
            bridgeObj.CallStatic(method, param);
        }
        catch (Exception e)
        {
            LH.LogError(e.Message + "\n" + e.StackTrace);
        }
    }

    public NetState GetMobileNetworkState()
    {
        int value = (int)NetState.UNKNOWN;

#if UNITY_ANDROID && (!UNITY_EDITOR)
			value = bridgeObj.CallStatic<int>("getMobileNetworkState");
#elif UNITY_IOS && (!UNITY_EDITOR)
			
#else
        if (Application.internetReachability == NetworkReachability.NotReachable)
        {
            value = (int)NetState.DISCONNECTED;
        }
        else
        {
            value = (int)NetState.CONNECTED;
        }
#endif
        return (NetState)value;
    }

    public NetState getWifiNetworkState()
    {
        int value = (int)NetState.UNKNOWN;

#if UNITY_ANDROID && (!UNITY_EDITOR)
			value = bridgeObj.CallStatic<int>("getWifiNetworkState");
#elif UNITY_IOS && (!UNITY_EDITOR)
#else
        if (Application.internetReachability == NetworkReachability.NotReachable)
        {
            value = (int)NetState.DISCONNECTED;
        }
        else
        {
            value = (int)NetState.CONNECTED;
        }
#endif

        return (NetState)value;
    }

    public void openWifiSetting()
    {
#if UNITY_ANDROID && (!UNITY_EDITOR)
			bridgeObj.CallStatic("openWifiSetting");
#elif UNITY_IOS && (!UNITY_EDITOR)
#endif
    }

    public void openWirelessSetting()
    {
#if UNITY_ANDROID && (!UNITY_EDITOR)
			bridgeObj.CallStatic("openWirelessSetting");
#elif UNITY_IOS && (!UNITY_EDITOR)
#endif
    }

    protected void OnAppLog(string msg)
    {
        LH.Log(msg);
    }

    protected void OnAppCallback(string msg)
    {
        Debug.Log("OnAppCallback(" + msg + ")");
        Dictionary<string, string> dic = BridgeUtil.stringToDictionary(msg);
        int code = Convert.ToInt32(dic["code"]);
        string result = dic["msg"];
        int msgKey = -1;
        switch (code)
        {
            case (int)AppCode.InitSuccess://初始化SDK成功回调
                msgKey = (int)SDKMsgKey.InitSuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.InitFail://初始化SDK失败回调
                msgKey = (int)SDKMsgKey.InitFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LoginSuccess://登陆成功回调
                msgKey = (int)SDKMsgKey.LoginSuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LoginNetworkError://登陆失败回调
                msgKey = (int)SDKMsgKey.LoginNetworkError;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LoginCancel://登陆取消回调
                msgKey = (int)SDKMsgKey.LoginCancel;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LoginFail://登陆失败回调
                msgKey = (int)SDKMsgKey.LoginFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LogoutSuccess://登出成功回调
                msgKey = (int)SDKMsgKey.LogoutSuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.LogoutFail://登出失败回调
                msgKey = (int)SDKMsgKey.LogoutFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PlatformEnter://平台中心进入回调
                msgKey = (int)SDKMsgKey.PlatformEnter;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PlatformBack://平台中心退出回调
                msgKey = (int)SDKMsgKey.PlatformBack;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PausePage://暂停界面回调
                msgKey = (int)SDKMsgKey.PausePage;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.ExitPage://退出游戏回调
                msgKey = (int)SDKMsgKey.ExitPage;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.AntiAddictionQuery://防沉迷查询回调
                msgKey = (int)SDKMsgKey.AntiAddictionQuery;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.RealNameRegister://实名注册回调
                msgKey = (int)SDKMsgKey.RealNameRegister;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.AccountSwitchSuccess://切换账号成功回调
                msgKey = (int)SDKMsgKey.AccountSwitchSuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.AccountSwitchFail://切换账号成功回调
                msgKey = (int)SDKMsgKey.AccountSwitchFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.OpenShop://应用汇  悬浮窗点击粮饷按钮回调
                msgKey = (int)SDKMsgKey.OpenShop;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayInitSuccess:
                msgKey = (int)SDKMsgKey.PayInitSuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayInitFail:
                msgKey = (int)SDKMsgKey.PayInitFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PaySuccess://支付成功回调
                msgKey = (int)SDKMsgKey.PaySuccess;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayFail://支付失败回调
                msgKey = (int)SDKMsgKey.PayFail;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayCancel://支付取消回调
                msgKey = (int)SDKMsgKey.PayCancel;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayNetworkError://支付超时回调
                msgKey = (int)SDKMsgKey.PayNetworkError;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayProductionInforIncomplete://支付信息不完整
                msgKey = (int)SDKMsgKey.PayProductionInforIncomplete;
                SDKMgr.OnCallback(msgKey, result);
                break;
            case (int)AppCode.PayNowPaying:
                msgKey = (int)SDKMsgKey.PayNowPaying;
                SDKMgr.OnCallback(msgKey, result);
                break;
            default:
                break;
        }
    }
}
