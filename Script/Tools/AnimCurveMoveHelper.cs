using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public struct RemainCurveInfo
{
    public float time;
    public float x;
    public float y;
    public float z;
    public RemainCurveInfo(float time,float x,float y,float z)
    {
        this.time = time;
        this.x = x;
        this.y = y;
        this.z = z;
    }
}

public class AnimCurveMoveHelper : MonoBehaviour
{
    public enum LockType
    {
        None,
        LockPos,
        LockTransform
    }

    public AnimationCurve _xCurve = new AnimationCurve();
    public AnimationCurve _yCurve = new AnimationCurve();
    public AnimationCurve _zCurve = new AnimationCurve();
    private float _curTime = 0;
    private float _MaxTime = 0;
    private List<RemainCurveInfo> _list = new List<RemainCurveInfo>();

    public LockType _lockType = LockType.None;
    private Vector3 _lockPos;
    private Transform _lockTrans;
    private float _unLockStartTime;
    public float unLockTurnToTime = 0.5f;

   
    ////拿到没有走完的曲线
    //public List<RemainCurveInfo> GetRemainCurve()
    //{
    //    _list.Clear();
    //    int count = _xCurve.length;
    //    //Keyframe[] keys = _xCurve.keys;
    //    //将当前位置加入列表
    //    Vector3 pos = transform.localPosition;
    //    _list.Add(new RemainCurveInfo(_curTime, pos.x, pos.y, pos.z));
    //    //获取到没有走完的keys
    //    //if (keys != null && keys.Length > 0)
    //    //{
    //    //    int count = keys.Length;
    //        for (int i = 0; i < count; i++)
    //        {
    //            if (_xCurve[i].time > _curTime)
    //            {
    //                float time = _xCurve[i].time;
    //                float x = _xCurve[i].value;
    //                float y = _yCurve[i].value;
    //                float z = _zCurve[i].value;
    //                RemainCurveInfo info = new RemainCurveInfo(time, x, y, z);
    //                _list.Add(info);
    //            }
    //        }
    //    //}
    //    return _list;
    //}

    public int GetRemainCurveIndex()
    {
        int count = _xCurve.length;
        int i = 0;
        for (i = 0; i < count; i++)
        {
            if (_xCurve[i].time > _curTime)
            {
                return i;
            }
        }
        return i;
    }

    public float GetCurTime()
    {
        return _curTime;
    }

    public void StopMove()
    {
        _curTime = 0;
        _MaxTime = 0;
        _xCurve.keys = null;
        _yCurve.keys = null;
        _zCurve.keys = null;
    }

    public void LockPos(Vector3 pos)
    {
        _lockType = LockType.LockPos;
        _lockPos = pos;
    }

    public void LockTrans(Transform trans)
    {
        _lockType = LockType.LockTransform;
        _lockTrans = trans;
    }

    public void UnLock()
    {
        _lockType = LockType.None;
        _lockTrans = null;
        _lockPos = Vector3.zero;
        _unLockStartTime = Time.time;
    }

    public void Clear()
    {
        _curTime = 0;
        _xCurve.keys = null;
        _yCurve.keys = null;
        _zCurve.keys = null;
        _MaxTime = 0;
        _list.Clear();
        _lockType = LockType.None;
        _lockPos = Vector3.zero;
        _lockTrans = null;
    }

    public void BeginSetCurve()
    {
        _curTime = 0;
        _xCurve.keys = null;
        _yCurve.keys = null;
        _zCurve.keys = null;
    }

    public void EndSetCurve()
    {
        if (_xCurve.length > 0)
        {
            _MaxTime = _xCurve[_xCurve.length - 1].time;
        }
        else
        {
            _MaxTime = 0;
        }
    }

    public void SetOneCurve(float time,float x,float y,float z)
    {
        _xCurve.AddKey(time, x);
        _yCurve.AddKey(time, y);
        _zCurve.AddKey(time, z);
    }

    public void SetCurve(LuaTable lt)
    {
        _curTime = 0;
        _xCurve.keys = null;
        _yCurve.keys = null;
        _zCurve.keys = null;

        //添加新的keys
        LuaArrayTable arrTable = lt.ToArrayTable();
        IEnumerator<object> enumerator = arrTable.GetEnumerator();
        while(enumerator.MoveNext())
        {
            LuaTable posTable = (LuaTable)enumerator.Current;
            float time = (float)(double)posTable[1];
            float x = (float)(double)posTable[2];
            float y = (float)(double)posTable[3];
            float z = (float)(double)posTable[4];
            _xCurve.AddKey(time, x);
            _yCurve.AddKey(time, y);
            _zCurve.AddKey(time, z);
        }
        //foreach (var item in arrTable)
        //{
        //    LuaTable posTable = (LuaTable)item;
        //    float time = (float)(double)posTable[1];
        //    float x = (float)(double)posTable[2];
        //    float y = (float)(double)posTable[3];
        //    float z = (float)(double)posTable[4];
        //    _xCurve.AddKey(time, x);
        //    _yCurve.AddKey(time, y);
        //    _zCurve.AddKey(time, z);
        //}
        arrTable.Dispose();
        lt.Dispose();
        if(_xCurve.length > 0)
        { 
            _MaxTime = _xCurve[_xCurve.length - 1].time;
        }
        else
        {
            _MaxTime = 0;
        }
    }

    void Update()
    {
        if(_MaxTime > 0)
        { 
            _curTime += Time.deltaTime;
            if (_curTime > _MaxTime) _curTime = _MaxTime;
            float x = _xCurve.Evaluate(_curTime);
            float y = _yCurve.Evaluate(_curTime);
            float z = _zCurve.Evaluate(_curTime);
            Vector3 nextPos = new Vector3(x, y, z);
            Vector3 dir = nextPos - transform.localPosition;
            if (dir != Vector3.zero && _lockType == LockType.None)
            {
                float unLockTime = Time.time - _unLockStartTime;
                if (unLockTime >= unLockTurnToTime)
                {
                    Quaternion targetRotate = Quaternion.LookRotation(dir, Vector3.up);
                    float angle = Quaternion.Angle(transform.localRotation, targetRotate);
                    Quaternion quaternion = Quaternion.RotateTowards(transform.localRotation, targetRotate, angle / 0.1f * Time.deltaTime);
                    transform.localRotation = quaternion;
                    //transform.localRotation = Quaternion.LookRotation(dir, Vector3.up);
                }
                else
                {
                    Quaternion targetRotate = Quaternion.LookRotation(dir, Vector3.up);
                    float leaveTime = unLockTurnToTime - unLockTime;
                    float angle = Quaternion.Angle(transform.localRotation, targetRotate);
                    Quaternion quaternion = Quaternion.RotateTowards(transform.localRotation, targetRotate, angle / leaveTime * Time.deltaTime);
                    transform.localRotation = quaternion;
                }
            }
            if (_lockType == LockType.LockPos)
            {
                transform.LookAt(_lockPos);
            }
            else if (_lockType == LockType.LockTransform)
            {
                if (_lockTrans != null)
                {
                    transform.LookAt(_lockTrans);
                }
            }
            //if (dir != Vector3.zero)
            //{
            //    transform.localRotation = Quaternion.LookRotation(dir, Vector3.up);
            //}
            transform.localPosition = nextPos;
        }
    }
}
