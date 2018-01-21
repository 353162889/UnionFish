using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class TargetMoveHelper : MonoBehaviour
{
    private Vector3 _target;
    private float _time;
    private float _delay;
    private LuaFunction _lf;
    private LuaTable _lt;
    private float _curTime;
    private float _speed;

    public void SetTarget(Vector3 target,float time,float delay,LuaFunction lf,LuaTable lt)
    {
        _target = target;
        _time = time;
        _delay = delay;
        _lf = lf;
        _lt = lt;
        _speed = Vector3.Distance(transform.position, _target) / _time;
        _curTime = 0;
    }

    private void Update()
    {
        if(_target != null)
        {
            _curTime += Time.deltaTime;
            if(_curTime > _delay)
            {
                float t = _curTime - _delay;
                float leftTime = _time - t;
                float dis = Vector3.Distance(transform.position, _target);
                if (leftTime > 0)
                { 
                    Vector3 nextPos = Vector3.MoveTowards(transform.position, _target, _speed * Time.deltaTime);
                    transform.position = nextPos;
                }
                else
                {
                    CallCallback();
                }
            }
        }
    }

    private void CallCallback()
    {
        if(_lf != null)
        {
            LuaFunction temp = _lf;
            _lf = null;
            temp.Call(_lt);
            _lt = null;
        }
    }

    private void OnDestroy()
    {
        _lf = null;
        _lt = null;
    }
}
