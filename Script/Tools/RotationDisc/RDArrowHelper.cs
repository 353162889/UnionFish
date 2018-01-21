using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class RDArrowHelper : MonoBehaviour
{
    private List<float> _listMin = new List<float>();
    private List<float> _listMax = new List<float>();
    private List<Transform> _listTarget = new List<Transform>();
    private Transform _rotateTarget;
    private bool _isStart;
    private float _targetAngle;
    private float _moveSpeed;
    private void Awake()
    {
        _isStart = false;
    }

    public void Begin()
    {
        Clear();
    }

    public void SetRotateTarget(Transform rotateTarget,float speed)
    {
        _rotateTarget = rotateTarget;
        _moveSpeed = speed;
    }

    public void AddTarget(float min,float max,Transform lookTarget)
    {
        _listMin.Add(min);
        _listMax.Add(max);
        _listTarget.Add(lookTarget);
    }

    public void End()
    {
        
    }

    public void Clear()
    {
        _listMax.Clear();
        _listMin.Clear();
        _listTarget.Clear();
        _rotateTarget = null;
        _isStart = false;
        transform.localEulerAngles = Vector3.zero;
    }

    public void ArrowEnable(bool enable)
    {
        _isStart = enable;
    }

    private void Update()
    {
        if (_isStart)
        {
            float preTarget = _targetAngle;
            if (_rotateTarget != null && _listTarget.Count > 0)
            {
                float rotate = _rotateTarget.localEulerAngles.z;
                rotate = rotate % 360;
                if (rotate < 0) rotate += 360;
                float angle = 360 - rotate;
                int count = _listMin.Count;
                int i = 0;
                for (i = 0; i < count; i++)
                {
                    if (angle > _listMin[i] && angle < _listMax[i])
                    {
                        break;
                    }
                }
                if (i >= count)
                {
                    transform.localEulerAngles = new Vector3(0, 0, 0);
                }
                else
                {
                    Vector3 dir = _listTarget[i].position - transform.position;
                    dir.z = 0;
                    _targetAngle = -Vector3.Angle(Vector3.down, dir);
                }
            }
            else
            {
                _targetAngle = 0;
            }
           transform.localEulerAngles = new Vector3(0,0,_targetAngle);
        }
        else
        {
            float rotate = transform.localEulerAngles.z;
            rotate = rotate % 360;
            if (rotate < 0) rotate += 360;
            if(rotate > 180)
            {
                rotate = rotate - 360;
            }
            float angle = Mathf.MoveTowards(rotate, 0, Time.deltaTime * _moveSpeed * Mathf.Sign(0 - rotate));
            transform.localEulerAngles = new Vector3(0,0, angle);
            //transform.localEulerAngles = Vector3.MoveTowards(transform.localEulerAngles, Vector3.zero, Time.deltaTime * _moveSpeed);
        }
        
    }
}
