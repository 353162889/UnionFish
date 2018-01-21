using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class AnimSpeedHelper : MonoBehaviour
{
    private Dictionary<int, float> _speedDic = new Dictionary<int, float>();
    private Animator _animator;

    private void Awake()
    {
        _animator = gameObject.GetComponent<Animator>();
    }

    public void SetAnimSpeed(string anim,float speed)
    {
        int hash = Animator.StringToHash(anim);
        if(_speedDic.ContainsKey(hash))
        {
            _speedDic[hash] = speed;
        }
        else
        {
            _speedDic.Add(hash, speed);
        }
    }

    private void Update()
    {
        if(_animator != null)
        {
            AnimatorStateInfo stateInfo = _animator.GetCurrentAnimatorStateInfo(0);
            if(_speedDic.ContainsKey(stateInfo.shortNameHash))
            {
                _animator.speed = _speedDic[stateInfo.shortNameHash];
            }
            else
            {
                _animator.speed = 1;
            }
        }
    }
}
