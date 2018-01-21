using UnityEngine;
using System.Collections;

public class LuaMsgHelper
{
    /************************************************************
    * LUA调用
    **********************************************************/
    //Net
    public static void connectToLoginServer(string ip, uint port)
    {
        ClientSendManager.connectToLoginServer(ip, port);
    }

    public static void connectToGameServer(uint ip, uint port)
    {
        ClientSendManager.connectToGameServer(ip, port);
    }

    //public static bool sendBinMsgData(LuaInterface.LuaByteBuffer data)
    //{
    //    return Client.Instance.SendBinMessage(data.buffer);
    //}

    public static bool sendBinMsgData(int msgID, LuaInterface.LuaByteBuffer data)
    {
        return Client.Instance.SendBinMessage(msgID, data.buffer);
    }

    public static void beginHeartBeat()
    {
        Client.Instance.beginHeartBeat();
    }

    /************************************************************
    * 发送
    **********************************************************/

    //public static void transferDataToLua(byte[] data)
    //{
    //    LuaMgr.instance.CallFunction("Network.OnDispatch", new LuaInterface.LuaByteBuffer(data));
    //}

    public static void transferDataToLua(int msgID, byte[] data)
    {
        LuaMgr.instance.CallFunction("Network.OnDispatch", msgID, new LuaInterface.LuaByteBuffer(data));
    }
}
