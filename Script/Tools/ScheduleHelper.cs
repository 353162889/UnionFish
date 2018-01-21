using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ScheduleHelper : MonoBehaviour
{
    private float _curTime;
    private LuaFunction _lf;
    private LuaTable _lt;
    private float _delay = -1;

    public void TimeSchedule(float delay,LuaFunction lf,LuaTable lt)
    {
        if(_delay > 0)
        {
            LH.LogError("ScheduleHelper is delaying,will not call callback");
        }
        _delay = delay;
        _lf = lf;
        _lt = lt;
        _curTime = 0;
    }

    void Update()
    {
        if (_delay < 0) return;
        _curTime += Time.deltaTime;
        if(_curTime > _delay)
        {
            LuaFunction lf = _lf;
            LuaTable lt = _lt;
            _lf = null;
            _lt = null;
            _delay = -1;
            _curTime = 0;
            lf.Call(this.gameObject,lt);
        }
    }
}
