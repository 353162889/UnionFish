using UnityEngine;
using System.Collections;
using System.Net.Sockets;
using System;
using System.Runtime.InteropServices;

public class IPV6Helper
{
    [DllImport("__Internal")]
    private static extern string getIPv6(string mHost, string mPort);

    public static string GetIPv6(string mHost, string mPort)
    {

#if UNITY_IPHONE && !UNITY_EDITOR
		string mIPv6 = getIPv6(mHost, mPort);
		return mIPv6;
#else
        return mHost + "&&ipv4";
#endif
    }

    public static string getIPType(string serverIp, string serverPorts, out AddressFamily mIPType)
    {
        mIPType = AddressFamily.InterNetwork;
        string newServerIp = serverIp;
        try
        {
            string mIPv6 = GetIPv6(serverIp, serverPorts);
            Debug.Log("Connect IPV6------" + mIPv6);
            if (!string.IsNullOrEmpty(mIPv6))
            {
                string[] m_StrTemp = System.Text.RegularExpressions.Regex.Split(mIPv6, "&&");
                if (m_StrTemp != null && m_StrTemp.Length >= 2)
                {
                    string IPType = m_StrTemp[1];
                    if (IPType == "ipv6")
                    {
                        newServerIp = m_StrTemp[0];
                        mIPType = AddressFamily.InterNetworkV6;
                    }
                }
            }
        }
        catch (Exception e)
        {
            Debug.LogError(e.ToString());
        }

        return newServerIp;

    }
}
