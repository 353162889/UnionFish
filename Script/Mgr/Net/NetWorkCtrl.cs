using UnityEngine;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.IO;

public class ClientNetWorkState
{
    public const int NOT_CONNECT = 0;
    public const int CONNECTING = 1;
    public const int NORMAL = 2;
    public const int ON_CONNECTED_FAILED = 3;
    public const int ON_DISCONNECTED = 4;
    public int value = 0;
}

public enum EClientNetWorkServerType
{
    INFO,
    LOGIN,
    GAME
}

/// <summary>
/// 网络状态回调
/// </summary>
public delegate void dNetWorkStateCallBack(int a_eState, EClientNetWorkServerType serverType);
/// <summary>
/// 连接socket回调
/// </summary>
public delegate void dNetConnectCallBack(bool result);

public class NetWorkCtrl
{
    private EClientNetWorkServerType m_server_type;
    private IAsyncResult m_ar_Connect = null;
    private Socket m_ClientSocket = null;

    private NetStreamReader m_Reader = null;
    private NetStreamWriter m_Writer = null;

    private CNetRecvMsgBuilder m_RecvBuilder = null;

    private dNetWorkStateCallBack m_StateCallBack = null;
    private dNetConnectCallBack m_ConnectCallBack = null;
    /// <summary>
    /// 接受数据流
    /// </summary>
    //private Queue<MemoryStreamEx> m_ComunicationList = new Queue<MemoryStreamEx>();
    private MemoryStreamEx m_ComunicationMem = new MemoryStreamEx();

    /// <summary>
    /// 发送流
    /// </summary>
    private MemoryStreamEx m_streamBuff = new MemoryStreamEx();

    /// <summary>
    /// 网络状态
    /// </summary>
    private ClientNetWorkState m_NetWorkState = new ClientNetWorkState();
    private float _checkStateInterval;
    /// <summary>
    /// 发送队列
    /// </summary>
    private Queue<byte[]> m_SendQueue = new Queue<byte[]>();
    private Queue<int> m_SendQueueMsgId = new Queue<int>();
    /// <summary>
    /// 接收线程
    /// </summary>
    private Thread m_receiveThread;


    public void init()
    {
        m_RecvBuilder = new CNetRecvMsgBuilder();
        m_Reader = new NetStreamReader();
        m_Reader.HandleMessage = m_RecvBuilder;
        m_Writer = new NetStreamWriter();
    }

    public void Dispose()
    {
        if(m_StateCallBack != null)
        {
            m_StateCallBack = null;
        }
        ReleaseSocket();
    }

    /// <summary>
    /// 是否连接中
    /// </summary>
    /// <returns></returns>
    public bool IsConnected()
    {
        return m_ClientSocket != null ? m_ClientSocket.Connected : false;
    }

    /// <summary>
    /// 注册网络状态监听
    /// </summary>
    /// <param name="callback"></param>
    public void RegisterNetWorkStateLister(dNetWorkStateCallBack callback)
    {
        if (m_StateCallBack == null)
        {
            m_StateCallBack = new dNetWorkStateCallBack(callback);
        }
        else
        {
            m_StateCallBack += callback;
        }
    }

    /// <summary>
    /// 取消网络状态监听
    /// </summary>
    /// <param name="callback"></param>
    public void UnRegisterNetWorkStateLister(dNetWorkStateCallBack callback)
    {
        if (m_StateCallBack != null)
        {
            m_StateCallBack -= callback;
        }
    }

    /// <summary>
    /// 连接服务器
    /// </summary>
    /// <param name="a_strRomoteIP">IP地址</param>
    /// <param name="a_uPort">端口</param>
    /// <returns></returns>
    public bool Connect(string a_strRomoteIP, ushort a_uPort, dNetConnectCallBack connectCallBack,
        EClientNetWorkServerType m_server_type)
    {
        ReleaseSocket();

        this.m_server_type = m_server_type;
        m_ConnectCallBack = connectCallBack;

        string serverIp = a_strRomoteIP;

        try
        {
            AddressFamily newAddressFamily = AddressFamily.InterNetwork;
            serverIp = IPV6Helper.getIPType(a_strRomoteIP, a_uPort.ToString(), out newAddressFamily);
            m_ClientSocket = new Socket(newAddressFamily, SocketType.Stream, ProtocolType.Tcp);
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
            return false;
        }

        Debug.Log("Established Socket " + serverIp);
        m_NetWorkState.value = ClientNetWorkState.CONNECTING;
        m_ar_Connect = m_ClientSocket.BeginConnect(serverIp, a_uPort, ConnectCallback, m_ClientSocket);

        return true;
    }

    /// <summary>
    /// 释放连接
    /// </summary>
    public void ReleaseSocket()
    {
        if (m_receiveThread != null)
        {
            m_receiveThread.Abort();
            m_receiveThread = null;
        }
        if (m_ar_Connect != null)
        {
            m_ar_Connect.AsyncWaitHandle.Close();
            m_ar_Connect = null;
        }
        if (m_ClientSocket != null)
        {
            try
            {
                m_ClientSocket.Shutdown(SocketShutdown.Both);
            }
            catch (Exception e)
            {
                Debug.LogError(e.ToString());
            }
            finally
            {
                try
                {
                    m_ClientSocket.Close();
                }
                catch (Exception e)
                {
                    Debug.LogError(e.ToString());
                }
                finally
                {
                    Debug.Log("Shutdown Socket");
                    m_ClientSocket = null;
                }
            }
        }
        m_NetWorkState.value = ClientNetWorkState.NOT_CONNECT;
        if (m_Reader != null)
        {
            m_Reader.Reset();
        }
        if (m_Writer != null)
        {
            m_Writer.Reset();
        }
    }

    /// <summary>
    /// 更新
    /// </summary>
    public void Update()
    {
        lock (m_ComunicationMem)
        {
            if (m_ComunicationMem.Length > 0)
            {
                if (m_Reader != null)
                {
                    //MemoryStreamEx ms = m_ComunicationList.Dequeue();
                    m_Reader.DidReadData(m_ComunicationMem.GetBuffer(), (int)(m_ComunicationMem.Length));
                    //ms.Clear();
                }
                m_ComunicationMem.Clear();
            }
        }
        _checkStateInterval += Time.unscaledDeltaTime;
        if (_checkStateInterval > 0.1f)
        {
            _checkStateInterval = 0;
            int value = 0;
            lock (m_NetWorkState)
            {
                value = m_NetWorkState.value;
            }
            if (value > ClientNetWorkState.NORMAL)
            {
                Debug.Log("update-->net state-->" + value + "-->m_ClientSocket-->" + m_ClientSocket);
                if (m_StateCallBack != null)
                {
                    m_StateCallBack(value, m_server_type);
                }
                ReleaseSocket();
            }
        }
    }

    public void SetSocketSendNoDeley(bool nodelay)
    {
        if (m_ClientSocket != null)
        {
            m_ClientSocket.SetSocketOption(SocketOptionLevel.Tcp, SocketOptionName.NoDelay, nodelay ? 1 : 0);
        }
    }

    /// <summary>
    /// 连接成功回调
    /// </summary>
    /// <param name="ar"></param>
    private void ConnectCallback(IAsyncResult ar)
    {
        try
        {
            m_ar_Connect.AsyncWaitHandle.Close();
            m_ar_Connect = null;
            m_ClientSocket.EndConnect(ar);
            m_NetWorkState.value = ClientNetWorkState.NORMAL;
            if (this.m_server_type != EClientNetWorkServerType.INFO)
            {
                //开启接受数据的线程
                ThreadStart ts = new ThreadStart(ReveiveSorket);
                m_receiveThread = new Thread(ts);
                m_receiveThread.IsBackground = true;
                m_receiveThread.Start();
            }
            // 连接通知
            if (m_ConnectCallBack != null)
            {
                m_ConnectCallBack(true);
            }
        }
        catch (Exception e)
        {
            //Debug.LogError(e.ToString());
            //m_NetWorkState.value = ClientNetWorkState.ON_CONNECTED_FAILED;
            //if (m_ConnectCallBack != null)
            //{
            //    m_ConnectCallBack(false);
            //}
        }
    }

    #region 发送数据

    /// <summary>
    /// 发送bin数据
    /// </summary>
    /// <param name="data"></param>
    /// <returns></returns>
    public bool SendBinMessage(byte[] data)
    {
        m_streamBuff.Clear();
        m_streamBuff.Write(data, 0, data.Length);
        return SendMessage(m_streamBuff);
    }

    /// <summary>
    /// 发送bin数据
    /// </summary>
    /// <param name="msgID"></param>
    /// <param name="data"></param>
    /// <returns></returns>
    public bool SendBinMessage(int msgID, byte[] data)
    {
        m_streamBuff.Clear();
        m_streamBuff.Write(data, 0, data.Length);
        return SendMessage(msgID, m_streamBuff);
    }

    /// <summary>
    /// 发送数据包，如果队列中为空，则直接请求
    /// </summary>
    public bool SendMessage(MemoryStream data)
    {
        if (m_Writer != null)
        {
            byte[] stream = m_Writer.MakeStream(data);
            lock (m_SendQueue)
            {
                if (m_SendQueue.Count == 0)
                {
                    return Send(stream);
                }
                else
                {
                    m_SendQueue.Enqueue(stream);
                    //m_SendQueueMsgId.Enqueue(msgID);
                    return true;
                }
            }
        }
        return false;
    }

    /// <summary>
    /// 发送数据包，如果队列中为空，则直接请求
    /// </summary>
    public bool SendMessage(int msgID, MemoryStream data)
    {
        if (m_Writer != null)
        {
            byte[] stream = m_Writer.MakeStream(msgID, data);
            lock (m_SendQueue)
            {
                if (m_SendQueue.Count == 0)
                {
                    return Send(msgID, stream);
                }
                else
                {
                    m_SendQueue.Enqueue(stream);
                    m_SendQueueMsgId.Enqueue(msgID);
                    return true;
                }
            }
        }
        return false;
    }


    /// <summary>
    /// 发送数据
    /// </summary>
    private bool Send(byte[] byteData)
    {
        try
        {
            int value = 0;
            lock (m_NetWorkState)
            {
                value = m_NetWorkState.value;
            }
            if (value == ClientNetWorkState.NORMAL)
            {
                //Debug.Log("send msgID-->" + msgID + "-->to ip-port-->" + m_ClientSocket.RemoteEndPoint.ToString());
                int sendResult = m_ClientSocket.Send(byteData);
                OnSendSuccess();
                return true;
            }
        }
        catch (Exception e)
        {
            Debug.Log("-->发送失败！" + e.ToString());
        }
        OnSendSuccess();
        return false;
    }

    /// <summary>
    /// 发送数据
    /// </summary>
    private bool Send(int msgID, byte[] byteData)
    {
        try
        {
            int value = 0;
            lock (m_NetWorkState)
            {
                value = m_NetWorkState.value;
            }
            if (value == ClientNetWorkState.NORMAL)
            {
                //Debug.Log("send msgID-->" + msgID + "-->to ip-port-->" + m_ClientSocket.RemoteEndPoint.ToString());
                int sendResult = m_ClientSocket.Send(byteData);
                OnSendSuccess();
                return true;
            }
        }
        catch (Exception e)
        {
            Debug.Log("MsgID-->" + msgID + "-->发送失败！" + e.ToString());
        }
        OnSendSuccess();
        return false;
    }

    /// <summary>
    /// 发送成功后，检测队列中是否还有数据未发，继续发送
    /// </summary>
    private void OnSendSuccess()
    {
        lock (m_SendQueue)
        {
            if (m_SendQueue.Count > 0)
            {
                Send(m_SendQueue.Dequeue());
                //Send(m_SendQueueMsgId.Dequeue(), m_SendQueue.Dequeue());
            }
        }
    }

    #endregion

    #region 接受数据

    /// <summary>
    /// 接受到数据
    /// </summary>
    private void ReveiveSorket()
    {
        while (true)
        {
            Thread.Sleep(1);
            if (!m_ClientSocket.Connected)
            {
                lock (m_NetWorkState)
                {
                    m_NetWorkState.value = ClientNetWorkState.ON_DISCONNECTED;
                }
                break;
            }
            try
            {
                //Receive方法一直等待服务器消息
                byte[] receivebuff = new byte[1024];
                int len = m_ClientSocket.Receive(receivebuff, 1024, SocketFlags.None);
                //Debug.LogError("Socket Receive Byte: " + len);
                if (len == 0)
                {
                    lock (m_NetWorkState)
                    {
                        m_NetWorkState.value = ClientNetWorkState.ON_DISCONNECTED;
                    }
                }
                else
                {
                    lock (m_ComunicationMem)
                    {
                        //MemoryStreamEx ms = new MemoryStreamEx();
                        //ms.Write(receivebuff, 0, len);
                        //m_ComunicationList.Enqueue(ms);
                        m_ComunicationMem.Write(receivebuff, 0, len);
                    }
                }
            }
            catch (Exception e)
            {
                lock (m_NetWorkState)
                {
                    m_NetWorkState.value = ClientNetWorkState.ON_DISCONNECTED;
                }
                break;
            }
        }
    }

    #endregion
}
