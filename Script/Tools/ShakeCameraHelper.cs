using UnityEngine;
using System.Collections;
using System.Collections.Generic;
public class ShakeCameraHelper : MonoBehaviour
{

    private float _shakeTime = 0.5f;
    private float _fps = 20.0f;
    private float _frameTime = 0.0f;
    private float _shakeDelta = 0.005f;
    private List<Camera> _listCamera;
    private bool _isShakeCamera = false;
    private float _delay = 0;

    private float _curShakeTime;
    private float _curFrameTime;
    // Use this for initialization
    void Start()
    {
        _shakeTime = 0.5f;
        _fps = 20.0f;
        _frameTime = 0.03f;
        _shakeDelta = 0.005f;
        _listCamera = new List<Camera>();
        GetCameras(gameObject, ref _listCamera);
    }

    private void GetCameras(GameObject go,ref List<Camera> list)
    {
        Camera c = go.GetComponent<Camera>();
        if(c != null)
        {
            list.Add(c);
        }
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            GetCameras(child,ref list);
        }
    }

    public void SetShakeParam(float shakeTime,float fps,float frameTime,float shakeDelta,float delay)
    {
        this._shakeTime = shakeTime;
        this._fps = fps;
        this._frameTime = frameTime;
        this._shakeDelta = shakeDelta;
        this._delay = delay;
    }

    public void SetShakeCamera()
    {
        _isShakeCamera = true;
        _curShakeTime = _shakeTime;
        _curFrameTime = _frameTime;
    }

    void Update()
    {
        if (_isShakeCamera)
        {
            if (_curShakeTime > 0)
            {
                _curShakeTime -= Time.deltaTime;
                if (_curShakeTime <= 0)
                {
                    Rect rect = new Rect(0.0f, 0.0f, 1.0f, 1.0f);
                    for (int i = 0; i < _listCamera.Count; i++)
                    {
                        _listCamera[i].rect = rect;
                    }
                    _isShakeCamera = false;
                }
                else if(_curShakeTime < _shakeTime - _delay)
                {
                    _curFrameTime += Time.deltaTime;

                    if (_curFrameTime > 1.0 / _fps)
                    {
                        _curFrameTime = 0;
                        Rect rect = new Rect(_shakeDelta * (-1.0f + 2.0f * Random.value), _shakeDelta * (-1.0f + 2.0f * Random.value), 1.0f, 1.0f);
                        for (int i = 0; i < _listCamera.Count; i++)
                        {
                            _listCamera[i].rect = rect;
                        }
                    }
                }
            }
        }
    }
}