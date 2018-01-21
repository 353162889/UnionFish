using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class UnitEffectHelper : MonoBehaviour
{
    private string _path;
    private int _queue;
    private float _time;
    private float _startTime;
    private LuaFunction _lf;
    private LuaTable _lt;
    private GameObject _go;

    public void ShowEffect(string path,int queue,float time, LuaFunction lf,LuaTable lt)
    {
        if (_path != path)
        { 
            _path = path;
            ResourceMgr.Instance.GetResource(path, OnLoadSucc);
        }
        _time = time;
        _startTime = 0;
        _lf = lf;
        _lt = lt;
        UpdateQueue(queue);
        gameObject.SetActive(false);
        gameObject.SetActive(true);
    }

    public string GetCurrentPath()
    {
        return _path;
    }

    public void UpdateQueue(int queue)
    {
        _queue = queue;
        if(_go != null)
        {
            LH.SetQueue(_go, _queue);
        }
    }

    public bool IsFinish()
    {
        return _time < -1f;
    }

    public void Update()
    {
        if(_time > 0)
        {
            if(_startTime < _time)
            { 
                _startTime += Time.deltaTime;
            }
            else
            {
                _time = -1f;
                gameObject.SetActive(false);
                if (_lf != null)
                {
                    _lf.Call(_lt);
                    _lf.Dispose();
                    _lf = null;
                    if(_lt != null)
                    {
                        _lt.Dispose();
                        _lt = null;
                    }
                }
            }
        }
    }

    public void Dispose()
    {
        if (!string.IsNullOrEmpty(_path))
        {
            ResourceMgr.Instance.RemoveListener(_path, OnLoadSucc);
            _path = null;
        }
        if(_lf != null)
        {
            _lf.Dispose();
            _lf = null;
        }
        if(_lt != null)
        {
            _lt.Dispose();
            _lt = null;
        }
        if (_go != null)
        {
            GameObject.Destroy(_go);
            _go = null;
        }
        _time = -1;
        _startTime = 0;

    }

    private void OnLoadSucc(Resource res)
    {
        GameObject prefab = (GameObject)res.GetAsset(_path);
        GameObject go = GameObject.Instantiate<GameObject>(prefab);
        go.transform.SetParent(transform, false);
        go.transform.localPosition = Vector3.zero;
        go.transform.localEulerAngles = Vector3.zero;
        go.transform.localScale = Vector3.one;
        if(_go != null)
        {
            GameObject.Destroy(_go);
            _go = null;
        }
        _go = go;
        UpdateQueue(_queue);
    }

    private void OnDestroy()
    {
        Dispose();
    }
}
