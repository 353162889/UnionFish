using Launch;
using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class SDKMgr : MonoBehaviour
{
    public static bool IsInit = false;

    private static Action<bool> _callback;

    private static Dictionary<int, List<Action<string>>> _map = new Dictionary<int, List<Action<string>>>();
    private static Dictionary<int, List<LuaFunction>> _mapLua = new Dictionary<int, List<LuaFunction>>();

    public static void Init(Action<bool> callback)
    {
        IsInit = false;
        if (!GameConfig.IsUsedSDK)
        {
            callback.Invoke(true);
            return;
        }
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("InitSDK");
#endif
        _callback = callback;
    }
    #region normal
    public static void OnCallback(int msgKey, string result)
    {
        LH.Log("UserExternalCall," + msgKey + ",result:" + result);
        if (msgKey > -1)
        {
            if (msgKey == (int)SDKMsgKey.InitSuccess)
            {
                IsInit = true;
                if (_callback != null)
                {
                    Action<bool> temp = _callback;
                    _callback = null;
                    temp.Invoke(true);
                }
            }
            else if (msgKey == (int)SDKMsgKey.InitFail)
            {
                if (_callback != null)
                {
                    Action<bool> temp = _callback;
                    _callback = null;
                    temp.Invoke(false);
                }
            }

            List<Action<string>> list;
            _map.TryGetValue(msgKey, out list);
            if (list != null)
            {
                for (int i = 0; i < list.Count; i++)
                {
                    list[i].Invoke(result);
                }
            }

            List<LuaFunction> luaList;
            _mapLua.TryGetValue(msgKey, out luaList);
            if (luaList != null)
            {
                for (int i = 0; i < luaList.Count; i++)
                {
                    luaList[i].Call(result);
                }
            }
        }
    }

    public static void RegisterListener(int msgKey, Action<string> callback)
    {
        List<Action<string>> list;
        _map.TryGetValue(msgKey, out list);
        if (list == null)
        {
            list = new List<Action<string>>();
            _map.Add(msgKey, list);
        }
        if (!list.Contains(callback))
        {
            list.Add(callback);
        }
    }

    public static void UnRegisterListener(int msgKey, Action<string> callback)
    {
        List<Action<string>> list;
        _map.TryGetValue(msgKey, out list);
        if (list != null)
        {
            list.Remove(callback);
        }
        _map.Remove(msgKey);
    }

    public static void RegisterLuaListener(int msgKey, LuaFunction callback)
    {
        List<LuaFunction> list;
        _mapLua.TryGetValue(msgKey, out list);
        if (list == null)
        {
            list = new List<LuaFunction>();
            _mapLua.Add(msgKey, list);
        }
        if (!list.Contains(callback))
        {
            list.Add(callback);
        }
    }

    public static void ClearLuaListener(int msgKey)
    {
        _map.Remove(msgKey);
    }

    public static void Dispose()
    {

    }
    #endregion

    #region user

    /**
	* 登录
	*/
    public static void Login()
    {

#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("Login");
#endif
    }

    /**
     * 注销
     */
    public static void Logout()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("Logout");
#endif
    }

    public static void Exit()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("AnySDKExit");
#endif
    }

    /**
     * 显示Toolbar,参数ToolBarPlace
     */
    public static void ShowToolBar()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("ShowToolBar");
#endif
    }

    /**
     * 切换账号
     */
    public static void AccountSwitch()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("AccountSwitch");
#endif
    }

    private static void UserCallFunc(string funcName)
    {
        LH.Log("UserCallFunc[Before]:" + funcName);
        if (IsInit)
        {
            LH.Log("UserCallFunc:" + funcName);
            AppBridge.Instance.Call(funcName);
        }
    }

    private static T UserCallFunc<T>(string funcName, params object[] arg)
    {
        LH.Log("UserCallFunc<T>[Before]:" + funcName);
        if (IsInit)
        {
            LH.Log("UserCallFunc<T>:" + funcName);
            return AppBridge.Instance.Call<T>(funcName);
        }
        return default(T);
    }

    /// <summary>
    /// 获取客户端参数
    /// </summary>
    /// <returns></returns>
    public static string GetCustomParam()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        return UserCallFunc<string>("GetCustomParam");
#endif
        return default(string);
    }
    /// <summary>
    /// 获取渠道编号
    /// </summary>
    /// <returns></returns>
    public static string GetChannelId()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        return UserCallFunc<string>("GetChannelId");
#endif
        return default(string);
    }
    /// <summary>
    /// 获取额外参数
    /// </summary>
    /// <returns></returns>
    public static string GetVerfyParam()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        if (!GameConfig.IsUsedSDK) return "";
        return "";
#endif
        return default(string);
    }

    /// <summary>
    /// 是否已登录
    /// </summary>
    /// <returns></returns>
    public static bool IsLogined()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        return UserCallFunc<bool>("IsLogined");
#endif
        return default(bool);
    }

    public static string GetUserId()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        return UserCallFunc<string>("GetUserID");
#endif
        return default(string);
    }

    #endregion

    #region pay
    public static void ResetPayState()
    {
#if !UNITY_EDITOR && (UNITY_ANDROID)
        UserCallFunc("ResetPayState");
#endif
    }

    /**
    * 支付
    */
    public static void PayForProduct(SDKPayInfo payInfo)
    {
        LH.Log("PayForProduct[Before]:");
        if (IsInit)
        {
            Dictionary<string, string> products = new Dictionary<string, string>();
            products["Product_Id"] = payInfo.ProductId;
            products["Product_Name"] = payInfo.ProductName;
            products["Product_Price"] = payInfo.ProductPrice;
            products["Product_Count"] = payInfo.ProductCount;
            products["Product_Desc"] = payInfo.ProductDesc;
            products["Coin_Name"] = payInfo.CoinName;
            products["Coin_Rate"] = payInfo.CoinRate;
            products["Role_Id"] = payInfo.RoleId;
            products["Role_Name"] = payInfo.RoleName;
            products["Role_Grade"] = payInfo.RoleGrade;
            products["Role_Balance"] = payInfo.RoleBalance;
            products["Vip_Level"] = payInfo.VIPLevel;
            products["Party_Name"] = payInfo.PartyName;
            products["Server_Id"] = payInfo.ServerId;
            products["Server_Name"] = payInfo.ServerName;
            products["EXT"] = payInfo.Ext;
            string msg = BridgeUtil.dictionaryToString(products);
            LH.Log("PayForProduct:" + msg);
#if !UNITY_EDITOR && (UNITY_ANDROID)
            AppBridge.Instance.Call("PayForProduct",msg);
#endif
        }

    }

    public static void PayForSelf(SDKPaySelfInfo paySelfInfo)
    {
        //Dictionary<string, string> products = new Dictionary<string, string>();
        //products["total_free"] = paySelfInfo.Total_fee;
        //products["body"] = WWW.EscapeURL(paySelfInfo.Body);
        //products["playerid"] = paySelfInfo.PlayerId;
        //products["type"] = paySelfInfo.Type;
        //products["gameid"] = paySelfInfo.GameId;
        //LH.Log("PayForSelf[Before],url:" + GameConfig.PayForSelfUrl + ",values:" + paySelfInfo.ToString());
        //string url = GameConfig.PayForSelfUrl;
        //HttpMgr.Instance.PostURL(url, products);

        string mURL = GameConfig.PayForSelfUrl;

        string PostData = "total_fee=" + paySelfInfo.Total_fee + "&body=" + WWW.EscapeURL(paySelfInfo.Body) + "&playerid=" + paySelfInfo.PlayerId + "&type=" + paySelfInfo.Type + "&gameid=" + paySelfInfo.GameId;
        HttpMgr.Instance.PostURL(mURL, PostData);
    }
}
#endregion
