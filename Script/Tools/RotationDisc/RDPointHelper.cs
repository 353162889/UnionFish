using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class RDPointHelper : MonoBehaviour
{
    private float _curSpaceTime;
    private float _spaceTime;
    private int _curIndex;
    private bool _order;    //重头开始还是从尾开始
    private List<Vector3> _list = new List<Vector3>();

    private void Awake()
    {
        _spaceTime = 0;
    }

    public void Begin(bool order)
    {
        _order = order;
        _list.Clear();
        _curSpaceTime = 0;
    }

    public void End()
    {
        if(_list.Count > 0)
        {
            if(_order)
            {
                _curIndex = 0;
            }
            else
            {
                _curIndex = _list.Count - 1;
            }
            transform.position = _list[_curIndex];
        }
    }

    public void UpdateSpeed(float spaceTime)
    {
        _spaceTime = spaceTime;
    }

    public void SetVisiable(bool visiable)
    {
        gameObject.SetActive(visiable);
    }

    public void AddPoint(float x,float y,float z)
    {
        _list.Add(new Vector3(x,y,z));
    }

    public void Clear()
    {
        _list.Clear();
        _curSpaceTime = 0;
        _spaceTime = 0;
        _curIndex = 0;
        _order = false;
    }

    private void Update()
    {
        if(_spaceTime > 0 && _list.Count > 0)
        {
            _curSpaceTime += Time.deltaTime;
            if(_curSpaceTime > _spaceTime)
            {
                _curSpaceTime = _curSpaceTime - _spaceTime;
                if(_order)
                { 
                    _curIndex++;
                }
                else
                {
                    _curIndex--;
                }
                _curIndex = _curIndex % _list.Count;
                if (_curIndex < 0) _curIndex += _list.Count;
                transform.position = _list[_curIndex];
            }
        }
    }
}