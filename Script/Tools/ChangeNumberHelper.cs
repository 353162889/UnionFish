using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ChangeNumberHelper : MonoBehaviour
{
    private UILabel _label;
    private int _startNum;
    private int _num;
    private float _time;
    private float _curTime;
    private void Awake()
    {
        _label = GetComponent<UILabel>();
        _curTime = 0;
    }

    public void SetNumberAtStart(int startNum,int endNum,float time)
    {
        if(startNum == endNum)
        {
            time = 0;
        }
        _startNum = startNum;
        _num = endNum;
        _time = time;
        _curTime = time;
        if (_label != null)
        {
            if (_time <= 0)
            {
                _label.text = _num.ToString();
            }
            else
            {
                _label.text = _startNum.ToString();
            }
        }
    }

    public void SetNumber(int num,float time)
    {
        SetNumberAtStart(0, num, time);
    }

    private void Update()
    {
        if(_curTime > 0 && _label != null)
        {
            _curTime -= Time.deltaTime;
            int num = Mathf.CeilToInt((_time - _curTime) / _time * (_num - _startNum));
            num = num + _startNum;
            _label.text = Mathf.Clamp(num, Mathf.Min(_startNum, _num), Mathf.Max(_startNum,_num)).ToString();
        }
    }
}
