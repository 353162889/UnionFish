using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ChangeGunHelper : MonoBehaviour
{
    private Vector3 _fixedAngle = Vector3.zero;
    private bool _init = false;
    public void SetFixedAngle(float x,float y,float z)
    {
        _init = true;
        _fixedAngle = new Vector3(x,y,z);
    }

    void Update()
    {
        if(_init)
        { 
            transform.eulerAngles = _fixedAngle;
        }
    }
}
