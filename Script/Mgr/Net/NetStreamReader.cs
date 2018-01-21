using UnityEngine;
using System;

public class NetStreamReader
{
    private CNetRecvMsgBuilder _handleMessage;
    public CNetRecvMsgBuilder HandleMessage
    {
        set { _handleMessage = value; }
    }
    private MemoryStreamEx _currentBuffer = new MemoryStreamEx();
    private MemoryStreamEx _nextBuffer = new MemoryStreamEx();
    private MemoryStreamEx _msgContent = new MemoryStreamEx();

    //当前读取位置
    private int _currentPos;

    private bool readNextMessage(byte[] data, int bufferLength)
    {
        if (bufferLength - _currentPos < sizeof(int))
        {
            //没有有效的协议长度
            _currentPos = 0;
            return false;
        }
        //读取协议长度信息
        int msgLen = BitConverter.ToInt32(data, _currentPos);
        _currentPos += sizeof(int);

        if (msgLen < sizeof(short) || msgLen > 1024 * 200)
        {
            //协议有问题,跳过
            Debug.LogError("Wrong Massage Len! Pass " + msgLen);
            _currentPos = 0;
            _currentBuffer.Clear();
            return false;
        }

        if (bufferLength - _currentPos < msgLen)
        {
            //buff内长度不够
            _currentPos = 0;
            return false;
        }

        int msgId = BitConverter.ToInt16(data, _currentPos);
        _currentPos += sizeof(short);

        _msgContent.Clear();
        int contentLen = msgLen - sizeof(short);
        _msgContent.Write(data, _currentPos, contentLen);
        _currentPos += contentLen;

        _nextBuffer.Write(data, _currentPos, bufferLength - _currentPos);
        MemoryStreamEx tmp = _nextBuffer;
        _currentBuffer.Clear();
        _nextBuffer = _currentBuffer;
        _currentBuffer = tmp;
        _currentPos = 0;

        try
        {
            _handleMessage.HandleMessage(msgId, 0, _msgContent);
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
        }

        return true;
    }

    public void DidReadData(byte[] data, int size)
    {
        _currentBuffer.Write(data, 0, size);
        while (readNextMessage(_currentBuffer.GetBuffer(), (int)_currentBuffer.Length))
        {
        }
    }

    public void Reset()
    {
        _currentBuffer.Clear();
        _nextBuffer.Clear();
        _msgContent.Clear();
        _currentPos = 0;
    }
}
