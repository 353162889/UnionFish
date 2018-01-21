using UnityEngine;
using System.Collections;

public class Client
{
    private bool _inited = false;
    public static bool isLog = false;
    public static bool isConnected;

    private static Client _instance;
    public static Client Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new Client();
            }
            return _instance;
        }
    }

    //服务器返回的协议
    public static string NetRecv = "";

    private NetWorkCtrl _netWork;

    private Timer _heartBeatTimer;

    public string loginServer_ip;
    public uint loginServer_port;
    public uint gameServer_ip;
    public uint gameServer_port;

    public static void InitClient()
    {
        Client.Instance.Init();
    }

    public static void DisposeClient()
    {
        Client.Instance.Dispose();
    }

    private void ClientListenNetWork(int a_eState, EClientNetWorkServerType type)
    {
        Debug.Log("<color='#ff0000'>断开" + a_eState+"</color>");
        if (a_eState == ClientNetWorkState.ON_DISCONNECTED)
        {
            isConnected = false;
            if (type == EClientNetWorkServerType.GAME)
            {
                LH.Log("<color='#ff0000'>Disconnect From Game Server!!!</color>");
                //this.Dispose();
                LuaMgr.instance.CallFunction("LinkCtrl.LinkDisconnect");
            }
        }
        else if (a_eState == ClientNetWorkState.ON_CONNECTED_FAILED)
        {
            isConnected = false;
            if (type == EClientNetWorkServerType.GAME)
            {
                Debug.LogError("<color='#ff0000'>Connect Game Server Failed!!!</color>");
                //this.Dispose();
                LuaMgr.instance.CallFunction("LinkCtrl.LinkDisconnect");
            }
        }
    }

    public void Init()
    {
        if (_inited == false)
        {
            //ClientHandleManager.initMsgHandles();
            _netWork = new NetWorkCtrl();
            _netWork.init();
            _netWork.RegisterNetWorkStateLister(ClientListenNetWork);
            _inited = true;
        }
    }

    public void Dispose()
    {
        if(_inited)
        {
            _inited = false;
            if(_netWork != null)
            {
                _netWork.Dispose();
                _netWork = null;
            }
            if (_heartBeatTimer != null)
            {
                TimeMgr.Instance.removeTimer(_heartBeatTimer);
                _heartBeatTimer = null;
            }
        }
    }

    /// <summary>
    /// 网络连接
    /// </summary>
    public void Connect(string a_strRomoteIP, ushort a_uPort, dNetConnectCallBack connectCallBack, EClientNetWorkServerType m_server_type)
    {
        Debug.Log("connect-->a_strRomoteIP-->" + a_strRomoteIP + "-->a_uPort-->" + a_uPort);
        _netWork.Connect(a_strRomoteIP, a_uPort, connectCallBack, m_server_type);
    }

    public void Close()
    {
        if (_netWork == null)
            return;
        _netWork.UnRegisterNetWorkStateLister(ClientListenNetWork);
        _netWork.ReleaseSocket();
    }

    public void Disconnect()
    {
        if (_netWork == null)
            return;
        _netWork.ReleaseSocket();
    }

    /// <summary>
    /// 注册网络状态监听方法
    /// </summary>
	public void RegisterNetWorkStateLister(dNetWorkStateCallBack lister)
    {
        _netWork.RegisterNetWorkStateLister(lister);
    }

    /// <summary>
    /// 取消网络状态监听方法
    /// </summary>
	public void UnRegisterNetWorkStateLister(dNetWorkStateCallBack lister)
    {
        _netWork.UnRegisterNetWorkStateLister(lister);
    }

    /// <summary>
    /// 发送二进制消息
    /// </summary>
    public bool SendBinMessage(byte[] data)
    {
        return _netWork.SendBinMessage(data);
    }

    /// <summary>
    /// 发送二进制消息
    /// </summary>
    public bool SendBinMessage(int msgID, byte[] data)
    {
        if (isLog)
        {
            Debug.Log("Send Bin Message: " + msgID);
        }

        return _netWork.SendBinMessage(msgID, data);
    }

    public void beginHeartBeat()
    {
        if (_heartBeatTimer != null)
        {
            TimeMgr.Instance.removeTimer(_heartBeatTimer);
        }
        _heartBeatTimer = TimeMgr.addTimerFunc(0, 1, 0, ClientSendManager.SendHeartBeat, null);
    }

    /// <summary>
    /// 更新
    /// </summary>
    public void Update()
    {
        if (_inited)
        {
            _netWork.Update();
        }
    }
}
