using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class SkillCDHelper : MonoBehaviour
{
    private float _nextTimestamp;
    private float _curCD;
    private UISprite _sprite;
    private UILabel _label;
    private void Awake()
    {
        _nextTimestamp = 0;
        _curCD = 1;
    }

    public void SetUI(UISprite s,UILabel l)
    {
        _sprite = s;
        _label = l;
    }

    public void UpdateCD(float cd)
    {
        _curCD = cd;
    }
    
    public void UpdateNextTimestamp(float timestamp)
    {
        Debug.Log("UpdateNextTimestamp:" + timestamp);
        _nextTimestamp = timestamp;
    }

    public bool IsCDFinish()
    {
        return Time.time > _nextTimestamp;
    }

    private void Update()
    {
        float sub = _nextTimestamp - Time.time;
        if (_sprite != null)
        {
            if(sub <= 0)
            {
                _sprite.fillAmount = 0;
            }
            else
            {
                _sprite.fillAmount = Mathf.Min(1,sub / _curCD);
            }
        }
        if (_label != null)
        {
            if(sub <= 0)
            {
                _label.text = "";
            }
            else
            {
                _label.text = Mathf.CeilToInt(sub).ToString();
            }
        }
    }
}
