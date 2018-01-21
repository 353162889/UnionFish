using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public class ServerTime
{
    private static bool hasInit = false;
    public static bool HasInited { get { return hasInit; } }
    private static TimeSpan offsetDateTime;
    private static readonly DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
    //set the time value of server time fetched from game server
    //10位的时间戳，精确到秒
    public static int CurrentServerSeconds
    {
        get
        {
            return (int)(Now - dtStart).TotalSeconds;
        }
        set
        {
            hasInit = true;
            offsetDateTime = dtStart.AddSeconds(value) - DateTime.Now;
        }
    }

    //13位的时间戳，精确到毫秒
    public static double CurrentServerSecondMs
    {
        get
        {
            return Math.Ceiling((Now - dtStart).TotalMilliseconds);
        }
        set
        {
            hasInit = true;
            offsetDateTime = dtStart.AddMilliseconds(value) - DateTime.Now;
        }
    }

    public static DateTime Now
    {
        get { return GetServerDateTime(); }
    }
    public static TimeSpan NowTimeSpan
    {
        get { return new TimeSpan(ServerTime.Now.Ticks); }
    }
    public static DateTime GetServerDateTime()
    {
        if (!hasInit)
        {
            LH.LogError("ServerTime has not been initialized!");
        }
        return DateTime.Now.Add(offsetDateTime);
    }

    public static DateTime ServerMS2DateTime(long ms)
    {
        return dtStart.AddMilliseconds(ms);
    }
}

