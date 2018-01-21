using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class SimpleAnimCurveHelper : MonoBehaviour
{
    public AnimationCurve XCurve = new AnimationCurve();
    public AnimationCurve YCurve = new AnimationCurve();
    public AnimationCurve ZCurve = new AnimationCurve();
    private float _curPos = 0;
    private float _targetPos = 0;
    private float _moveTime = 0;
    private float _curTime = 0;
    private LuaFunction _lf;
    private LuaTable _lt;
    private float _speed = 0;

    public void MoveTo(float pos,float time, LuaFunction lf, LuaTable lt)
    {
        _curTime = 0;
        _moveTime = time;
        _lf = lf;
        _lt = lt;
        _targetPos = pos;
        _speed = 0;
        if(_moveTime <= 0)
        {
            _moveTime = 0;
            _curPos = pos;
            float x = XCurve.Evaluate(_curPos);
            float y = YCurve.Evaluate(_curPos);
            float z = ZCurve.Evaluate(_curPos);
            transform.localPosition = new Vector3(x, y, z);
            if(_lf != null)
            {
                LuaFunction temp = _lf;
                LuaTable tempLT = _lt;
                _lf = null;
                _lt = null;
                temp.Call(tempLT);
                temp.Dispose();
            }
        }
        else
        {
            _speed = (_targetPos - pos) / _moveTime;
        }
    }

    private void Update()
    {
        if(_curTime < _moveTime && _speed > 0)
        {
            float nextPos = Mathf.MoveTowards(_curPos, _targetPos,_speed * Time.deltaTime);
            UpdatePos(nextPos);
            _curTime += Time.deltaTime;
            if (_curTime >= _moveTime && _lf != null)
            {
                LuaFunction temp = _lf;
                LuaTable tempLT = _lt;
                _lf = null;
                _lt = null;
                temp.Call(tempLT);
                temp.Dispose();
            }
        }
    }

    private void UpdatePos(float pos)
    {
        _curPos = pos;
        float x = XCurve.Evaluate(_curPos);
        float y = YCurve.Evaluate(_curPos);
        float z = ZCurve.Evaluate(_curPos);
        transform.localPosition = new Vector3(x, y, z);
    }

    private void OnDestroy()
    {
        _lf = null;
        _lt = null;
    }
}
