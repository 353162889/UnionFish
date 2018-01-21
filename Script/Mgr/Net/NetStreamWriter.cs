using System.IO;
using System;
public class NetStreamWriter
{
    private MemoryStreamEx m_Buffer = new MemoryStreamEx();
    private byte[] m_NotUseByte = new byte[2] { 0, 0 };
    private byte[] m_NotUseByte2 = new byte[4] { 0, 0, 0, 0 };
    //-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    public byte[] MakeStream(MemoryStream data)
    {
        m_Buffer.Clear();
        int net_data_size = data != null ? (int)data.Length : 0;
        byte[] net_Data_Size_byte = BitConverter.GetBytes(net_data_size);
        m_Buffer.Write(net_Data_Size_byte, 0, net_Data_Size_byte.Length);
        if (data != null)
            m_Buffer.Write(data.GetBuffer(), 0, (int)data.Length);
        return m_Buffer.ToArray();
    }

    public byte[] MakeStream(int msgID, MemoryStream data)
    {
        m_Buffer.Clear();
        short net_msgID = (short)msgID;
        byte[] net_MsgID_byte = BitConverter.GetBytes(net_msgID);
        int net_data_size = net_MsgID_byte.Length + m_NotUseByte.Length + m_NotUseByte2.Length + (data != null ? (int)data.Length : 0);
        byte[] net_Data_Size_byte = BitConverter.GetBytes(net_data_size);
        m_Buffer.Write(net_Data_Size_byte, 0, net_Data_Size_byte.Length);
        m_Buffer.Write(net_MsgID_byte, 0, net_MsgID_byte.Length);
        m_Buffer.Write(m_NotUseByte, 0, m_NotUseByte.Length);
        m_Buffer.Write(m_NotUseByte2, 0, m_NotUseByte2.Length);
        //Debuger.Log("m_Buffer-->" + m_Buffer.Length);
        if (data != null)
            m_Buffer.Write(data.GetBuffer(), 0, (int)data.Length);
        //Debuger.Log("m_Buffer-->" + m_Buffer.Length);
        return m_Buffer.ToArray();
    }

    public void Reset()
    {
        m_Buffer.Clear();
    }
}
