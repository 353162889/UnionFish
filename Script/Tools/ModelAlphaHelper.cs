using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ModelAlphaHelper : MonoBehaviour
{
    private float _startAlpha = -1;
    private Renderer _render;
    private float _curTime;
    private float _totalTime;
    private float _targetAlpha;
    private void Start()
    {
        _render = GetRender(gameObject);
        if(_render != null && _render.material.HasProperty("_Color"))
        {
            _startAlpha = _render.material.color.a;
        }
    }

    private Renderer GetRender(GameObject go)
    {
        var renderer = go.GetComponent<Renderer>();
        if (renderer == null)
        {
            int count = go.transform.childCount;
            for (int i = 0; i < count; i++)
            {
                GameObject child = go.transform.GetChild(i).gameObject;
                renderer = GetRender(child);
                if (renderer != null) return renderer;
            }
            
        }
        return renderer;
    }

    public void Reset()
    {
        SetAlpha(_startAlpha);
        _curTime = 0;
        _totalTime = 0;
    }

    private void SetAlpha(float alpha)
    {
        if (_render != null && _startAlpha > 0)
        {
            Color c = _render.material.color;
            c.a = alpha;
            _render.material.color = c;
        }
    }

    public void TransAlpha(float targetAlpha,float time)
    {
        _targetAlpha = targetAlpha;
        _curTime = 0;
        _totalTime = time;
    }

    private void Update()
    {
        if(_render != null && _startAlpha > 0)
        {
            if(_totalTime > 0 && _curTime < _totalTime)
            {
                float alpha = _curTime / _totalTime * (_targetAlpha - _startAlpha);
                alpha = alpha + _startAlpha;
                SetAlpha(alpha);
                _curTime += Time.deltaTime;
            }
        }
    }
}
