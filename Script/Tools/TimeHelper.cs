using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class TimeHelper : MonoBehaviour
{
    private class TimeData : System.ICloneable
    {
        public float time = -1;
        public LuaFunction function;
        public LuaTable luaTable;

        public TimeData(float time, LuaFunction function, LuaTable luaTable)
        {
            if (time == -1 || function == null)
            {
                throw new System.ArgumentException("TimeData参数不符合");
            }
            this.luaTable = luaTable;
            this.function = function;
            this.time = time;
        }

        public object Clone()
        {
            return MemberwiseClone();
        }
    }

    //private List<TimeData> bpTimeList = new List<TimeData>();
    private List<TimeData> timeList = new List<TimeData>();
    public float time = -1;
    public int index = -1;
    public int count = 0;
    //public bool isLoop = false;
    //public bool isStop = false;
    //private TimeData curData;

    void Start()
    {
        //bpTimeList = new List<TimeData>();
        //timeList = new List<TimeData>();
    }

    void Update()
    {
        UpdateTime();
    }


    public void AddTime(float time, LuaFunction function, LuaTable luaTable)
    {
        TimeData td = new TimeData(time, function, luaTable);
        timeList.Add(td);
        //bpTimeList.Add(td.Clone() as TimeData);
        //if (curData == null) curData = td;
    }

    public void ExcuteTime(int index)
    {
        if (Warn(index)) return;
        //if (timeList[index].function != null)
        timeList[index].function.Call(gameObject, timeList[index].luaTable);
        timeList.RemoveAt(index);
    }
    public void ExcuteTime()
    {
        if (Warn(0)) return;
        timeList[0].function.Call(gameObject, timeList[0].luaTable);
        timeList.RemoveAt(0);
    }
    public void RemoveTime(int index)
    {
        if (Warn(index)) return;
        timeList.RemoveAt(index);
    }
    public void RemoveTime()
    {
        if (Warn(0)) return;
        timeList.RemoveAt(0);
    }
    public void ClearTime(bool isExcute)
    {
        if (isExcute)
        {
            for (int i = 0; i < timeList.Count; i++)
            {
                ExcuteTime(i);
            }
        }
        timeList.Clear();
    }
    public void ClearTime()
    {
        timeList.Clear();
    }

    void UpdateTime()
    {
        if (timeList.Count <= 0)
        {
            //if (isLoop)
            //{
                //foreach (var item in bpTimeList)
                //{
                //    Debug.LogError(item.time);
                //}
                //timeList = new List<TimeData>(bpTimeList);
            //}
            return;
        }
        for (int i = 0; i < timeList.Count; i++)
        {
            //if (timeList[i].time == -1) break;
            timeList[i].time -= RealTime.deltaTime;
            time = timeList[i].time;
            index = i;
            count = timeList.Count;
            if (timeList[i].time > 0) break;
            ExcuteTime(i);
            i--;
        }
    }

    bool Warn(int index)
    {
        if (index >= timeList.Count || index < 0)
        {
            //Debug.LogError("超出后续事件列表范围");
            return true;
        }
        return false;
            //throw new System.OutOfMemoryException("超出后续事件列表范围");
    }


}
