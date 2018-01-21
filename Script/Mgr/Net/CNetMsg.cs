using System.IO;
using UnityEngine;

public class MemoryStreamEx : MemoryStream
{
    public void Clear()
    {
        SetLength(0);
    }
}

/// <summary>
/// 数据接收封装类
/// </summary>
public class CNetRecvMsg
{
    /// <summary>
    /// 消息号
    /// </summary>
	public int m_nMsgID = 0;
    /// <summary>
    /// 消息数据
    /// </summary>
	public MemoryStream m_DataMsg;

    //public T DeSerializeProtocol<T>()
    //{
    //    m_DataMsg.Position = 0;
    //    return ProtoBuf.Serializer.Deserialize<T>(m_DataMsg);
    //}
}

/// <summary>
/// 处理读取流中的数据
/// </summary>
public class CNetRecvMsgBuilder
{
    private CNetRecvMsg clientNetMsg = new CNetRecvMsg();

    //public void HandleMessage(int dataType, MemoryStream data)
    //{
    //    clientNetMsg.m_DataMsg = data;

    //    ClientHandleMessage(clientNetMsg);

    //    clientNetMsg.m_DataMsg = null;
    //}

    public void HandleMessage(int msgID, int dataType, MemoryStream data)
    {
        clientNetMsg.m_nMsgID = msgID;
        clientNetMsg.m_DataMsg = data;

        ClientHandleMessage(clientNetMsg);

        clientNetMsg.m_nMsgID = 0;
        clientNetMsg.m_DataMsg = null;
    }

    //public static void ClientHandleMessage(CNetRecvMsg msg)
    //{
    //    msg.m_DataMsg.Position = 0;
    //    LuaMsgHelper.transferDataToLua(msg.m_DataMsg.ToArray());
    //}

    public static void ClientHandleMessage(CNetRecvMsg msg)
    {
        if (Client.isLog)
        {
            Debug.Log("Receive Message: " + msg.m_nMsgID);
        }

        if (msg.m_nMsgID >= 0)
        {
            msg.m_DataMsg.Position = 0;
            LuaMsgHelper.transferDataToLua(msg.m_nMsgID, msg.m_DataMsg.ToArray());
        }
        else
        {
            Debug.LogError("Msg ID doesn't exist: " + msg.m_nMsgID);
        }
    }
}
