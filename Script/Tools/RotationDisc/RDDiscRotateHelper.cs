using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

//整个算法以Atan函数为核心，已y轴为时间，x轴为角度
public class RDDiscRotateHelper : MonoBehaviour
{
    private float _curRotateAngle;  //当前的旋转角度
    private float _curTime;     //当前已过去的时间

    private float _totalTime;   //旋转所需要的总时间
    private float _totalAngle;  //旋转的总角度
    private float _midTime; //时间中分点，一般来说一般为总时间的二分之一（现在可传）

    private float _angleScale; //角度的一个缩放
    private float _accAngleOffset;   //加速阶段的偏移，级在curveMid前端时间走过的缩放的角度

    private float _preRotateAngle;

    private bool _finish;

    private float _timeScale;
    private LuaFunction _lf;
    private LuaTable _lt;

    //public float totalAngle;
    //public float totalTime;
    //public float midTime;
    //public float timeScale;

    //private void OnEnable()
    //{
    //    Rotate(totalAngle, totalTime, midTime, timeScale);
    //}

    //private void OnDisable()
    //{
    //    _finish = true;
    //}

    public void ResetPos()
    {
        _curRotateAngle = 0;
        transform.localEulerAngles = Vector3.zero;
        _preRotateAngle = 0;
        _finish = true;
        _lf = null;
        _lt = null;
    }

    public void RotateInLua(float totalAngle, float totalTime, float midTime, float timeScale, LuaFunction lf,LuaTable lt)
    {
        _lf = lf;
        _lt = lt;
        Rotate(totalAngle, totalTime, midTime,timeScale);
    }

    public void Rotate(float totalAngle,float totalTime,float midTime,float timeScale)
    {
        _totalAngle = totalAngle;
        _totalTime = totalTime;
        _midTime = midTime;
        _timeScale = timeScale;
        if (_midTime < 0 || _midTime > _totalTime) _midTime = totalTime / 2;

        _preRotateAngle = _curRotateAngle % 360;
        if (_preRotateAngle < 0) _preRotateAngle += 360;
        _totalAngle = _totalAngle - _preRotateAngle;

        _curTime = 0;

        _accAngleOffset = Mathf.Atan(-_midTime / _timeScale);
        _angleScale = _totalAngle / (Mathf.Atan((_totalTime - _midTime) / _timeScale) - _accAngleOffset);

        _finish = false;
    }

    private void Update()
    {
        if(_curTime < _totalTime && !_finish)
        {
            _curTime += Time.deltaTime;
            float curRotateAngle = _angleScale * (Mathf.Atan((_curTime - _midTime) / _timeScale) - _accAngleOffset);
            _curRotateAngle = curRotateAngle + _preRotateAngle;
            transform.localEulerAngles = new Vector3(0, 0,_curRotateAngle);
        }
        else
        {
            if(!_finish)
            {
                _curRotateAngle = _totalAngle + _preRotateAngle;
                transform.localEulerAngles = new Vector3(0,0, _curRotateAngle);
                _finish = true;
                if(_lf != null)
                {
                    LuaFunction temp = _lf;
                    _lf = null;
                    temp.Call(_lt);
                }
            }
        }
    }
}
