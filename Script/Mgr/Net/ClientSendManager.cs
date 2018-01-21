using UnityEngine;
using System.Collections;
using System;
using System.Net;
using LuaInterface;

public class ClientSendManager
{
    private static int _reConnectTimes;
    private static Timer _reConnectTimer;
    private static Timer _failTimer;

    /// <summary>
    /// 连接至登录服务器
    /// </summary>
    /// <param name="datas"></param>
    public static void connectToLoginServer(params object[] datas)
    {
        if (_reConnectTimer != null)
        {
            _reConnectTimer.Stop();
            _reConnectTimer = null;
        }

        if (_failTimer != null)
        {
            _failTimer.Stop();
            _failTimer = null;
        }

        string ip = datas[0] as string;
        Client.Instance.loginServer_ip = ip;
        uint port = (uint)datas[1];
        Client.Instance.loginServer_port = port;
        if (Application.internetReachability == NetworkReachability.NotReachable)
        {
            Debugger.LogError("无法连接网络!");
            LuaMgr.instance.CallFunction("LinkCtrl.OnConnectLoginFail");
        }
        else
        {
            Client.Instance.Connect(ip, (ushort)port, delegate (bool result)
            {
                if (_failTimer != null)
                {
                    _failTimer.Stop();
                    _failTimer = null;
                }

                if (result == true)
                {
                    //只能从主线程调用
                    _reConnectTimer = TimeMgr.addTimerFunc(0, 0, 1, null, onConnectedToLoginServer, ip, port);
                }
                else
                {
                    _reConnectTimes++;
                    if (_reConnectTimes < 2)
                    {
                        _reConnectTimer = TimeMgr.addTimerFunc(1, 0, 1, null, connectToLoginServer, ip, port);
                    }
                    else
                    {
                        _reConnectTimer = TimeMgr.addTimerFunc(0, 0, 1, null, onConnectedToLoginServerFail, ip, port);
                    }
                }
            }, EClientNetWorkServerType.LOGIN);
            _failTimer = TimeMgr.addTimerFunc(10, 0, 1, null, waitLoginServerFail, ip, port);
        }
    }


    private static void onConnectedToLoginServer(params object[] datas)
    {
        Debugger.Log("Connect To Login Server Success!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkLoginSuccess");
    }

    private static void onConnectedToLoginServerFail(params object[] datas)
    {
        Debugger.Log("Connect To Login Server Fail!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkLoginFail");
    }

    private static void waitLoginServerFail(params object[] datas)
    {
        Debugger.Log("Wait Login Server Fail!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkLoginFail");
    }



    /// <summary>
    /// 连接至游戏服务器
    /// </summary>
    public static void connectToGameServer(params object[] datas)
    {
        if (_reConnectTimer != null)
        {
            _reConnectTimer.Stop();
            _reConnectTimer = null;
        }

        if (_failTimer != null)
        {
            _failTimer.Stop();
            _failTimer = null;
        }

        uint ip_uint = (uint)datas[0];
        Client.Instance.gameServer_ip = ip_uint;
        IPAddress ipaddress = IPAddress.Parse(ip_uint.ToString());
        string ip = ipaddress.ToString();
        uint port = (uint)datas[1];
        Client.Instance.gameServer_port = port;
        if (Application.internetReachability == NetworkReachability.NotReachable)
        {
            Debugger.LogError("无法连接网络!");
        }
        else
        {
            Client.Instance.Connect(ip, (ushort)port, delegate (bool result)
            {
                if (_failTimer != null)
                {
                    _failTimer.Stop();
                    _failTimer = null;
                }

                if (result == true)
                {
                    Client.isConnected = true;
                    //只能从主线程调用
                    _reConnectTimer = TimeMgr.addTimerFunc(0, 0, 1, null, onConnectedToGameServer);
                }
                else
                {
                    _reConnectTimes++;
                    if (_reConnectTimes < 5)
                    {
                        _reConnectTimer = TimeMgr.addTimerFunc(1, 0, 1, null, connectToGameServer, datas);
                    }
                    else
                    {
                        _reConnectTimer = TimeMgr.addTimerFunc(0, 0, 1, null, onConnectedToGameServerFail);
                    }
                }
            }, EClientNetWorkServerType.GAME);
            _failTimer = TimeMgr.addTimerFunc(10, 0, 1, null, waitGameServerFail, ip, port);
        }
    }

    private static void onConnectedToGameServer(object[] datas)
    {
        Debugger.Log("Connect To Game Server Success!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkGameSuccess");
    }

    private static void onConnectedToGameServerFail(object[] datas)
    {
        Debugger.Log("Connect To Game Server Fail!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkGameFail");
    }

    private static void waitGameServerFail(params object[] datas)
    {
        Debugger.Log("Wait Login Server Fail!");
        LuaMgr.instance.CallFunction("LinkCtrl.LinkGameFail");
        LuaMgr.instance.CallFunction("Tools.SetLoadingViewSetProgress",100);
    }

    /// <summary>
    /// 心跳包
    /// </summary>
    /// <returns></returns>
    public static void SendHeartBeat(params object[] datas)
    {
        LuaMgr.instance.CallFunction("LinkCtrl.C2SHeartBeat");
    }
}