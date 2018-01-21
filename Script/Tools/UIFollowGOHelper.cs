using UnityEngine;
using System.Collections;

public class UIFollowGOHelper : MonoBehaviour {
    private GameObject _target;
    private Vector3 _offset;

	// Use this for initialization
	void Start () {
	
	}

    public void SetTarget(GameObject target)
    {
        _target = target;
        _offset = Vector3.zero;
        if(_target != null)
        {
            UpdatePosition();
        }
    }

    public void SetTargetOffsetByXYZ(GameObject target,float x,float y,float z)
    {
        SetTargetOffset(target, new Vector3(x,y,z));
    }

    public void SetTargetOffset(GameObject target,Vector3 offset)
    {
        _target = target;
        _offset = offset;
        if (_target != null)
        {
            UpdatePosition();
        }
    }

    public void Clear()
    {
        _target = null;
        _offset = Vector3.zero;
    }

    // Update is called once per frame
    void Update () {
	    if(_target != null)
        {
            if (gameObject.activeSelf != _target.activeSelf)
            {
                gameObject.SetActive(_target.activeSelf);
            }
            if (_target.activeSelf)
            {
                UpdatePosition();
            }
        }
	}

    private void UpdatePosition()
    {
        Vector3 pos = LH.WorldPosToUIPos(_target.transform.position);
        transform.position = pos + _offset;
    }
}
