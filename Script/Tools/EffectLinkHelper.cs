using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class EffectLinkHelper : MonoBehaviour
{
    private LightningHelper _lightHelper;
    private Vector3 _start = Vector3.zero;
    private Vector3 _end = Vector3.zero;

    public void SetStartAndEnd(Vector3 start,Vector3 end)
    {
        _start = start;
        _end = end;
        UpdateHelper();
    }

    private void Update()
    {
        if(_lightHelper == null)
        {
            _lightHelper = GetChildHelper(transform);
            if(_lightHelper != null)
            {
                UpdateHelper();
            }
        }
       
    }

    private void UpdateHelper()
    {
        if (_lightHelper != null)
        {
            if (Vector3.Distance(_start, _end) < 0.0001f)
            {
                _lightHelper.gameObject.SetActive(false);
            }
            else
            {
                _lightHelper.gameObject.SetActive(true);
                _lightHelper.SetStartAndTarget(_start, _end);
            }
        }
    }

    private LightningHelper GetChildHelper(Transform tf)
    {
        int childCount = tf.childCount;
        for (int i = 0; i < childCount; i++)
        {
            Transform child = tf.GetChild(i);
            if(child != null)
            {
                LightningHelper helper = child.GetComponent<LightningHelper>();
                if(helper != null)
                {
                    return helper;
                }
                else
                {
                    return GetChildHelper(child);
                }
            }
        }
        return null;
    }
}
