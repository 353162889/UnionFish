using Spine.Unity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class SpineAnimHelper : MonoBehaviour
{
    private SkeletonAnimation _skeleton;
    private string _path;
    private int _queue = -1;
    private string _layerName = null;
    private string _animName;
    private bool _isLoop;
    private Renderer _render;

    private void Awake()
    {
        _animName = null;
        _skeleton = gameObject.GetComponent<SkeletonAnimation>();
        if (_skeleton == null)
        { 
            _skeleton = gameObject.AddComponent<SkeletonAnimation>();
        }
    }

    public static void PreLoadPath(string path)
    {
        if (string.IsNullOrEmpty(path)) return;
        ResourceMgr.Instance.GetResource(path);
    }

    public void UpdatePath(string path)
    {
        if (_path == path) return;
        _path = path;
        if(string.IsNullOrEmpty(_path))
        {
            _skeleton.skeletonDataAsset = null;
        }
        else
        { 
            if(_render != null)
            {
                _render.enabled = false;
            }
            ResourceMgr.Instance.GetResource(_path, OnLoadSucc);
        }
    }

    public void UpdateQueue(int queue)
    {
        _queue = queue;
        if (_skeleton != null && _skeleton.skeletonDataAsset != null)
        {
            if (_queue > 0)
            {
                Renderer renderer = _skeleton.GetComponent<Renderer>();
                renderer.material.renderQueue = _queue;
            }
        }
    }

    public void UpdateLayer(string layerName)
    {
        _layerName = layerName;
        if (_skeleton != null && _skeleton.skeletonDataAsset != null)
        {
            if (!string.IsNullOrEmpty(_layerName))
            {
                Renderer renderer = _skeleton.GetComponent<Renderer>();
                renderer.sortingLayerName = _layerName;
            }
        }
    }

    public void PlayAnim(string name,bool loop)
    {
        _animName = name;
        _isLoop = loop;
        if (_skeleton != null && _skeleton.skeletonDataAsset != null)
        {
            if (!string.IsNullOrEmpty(_animName))
            {
                _skeleton.loop = _isLoop;
                _skeleton.AnimationName = _animName;
            }
        }
    }

    public void Update()
    {
        //材质设置有延时
        if (_skeleton != null && _skeleton.skeletonDataAsset != null && _render != null)
        {
            if (_queue > 0)
            {
                _render.material.renderQueue = _queue;
            }
            if(!string.IsNullOrEmpty(_layerName))
            {
                _render.sortingLayerName = _layerName;
            }
        }
    }


    public void Dispose()
    {
        if (!string.IsNullOrEmpty(_path))
        {
            ResourceMgr.Instance.RemoveListener(_path, OnLoadSucc);
            _path = null;
        }
        if (_skeleton != null)
        {
            _skeleton.skeletonDataAsset = null;
        }
        _animName = null;
        _render = null;
    }

    private void OnLoadSucc(Resource res)
    {
        SkeletonDataAsset go = (SkeletonDataAsset)res.GetAsset(_path);
        if(_skeleton != null)
        {
            _skeleton.skeletonDataAsset = go;
            _skeleton.Initialize(true);
            if (!string.IsNullOrEmpty(_animName))
            {
                //必须先设置循环，再播动画
                _skeleton.loop = _isLoop;
                _skeleton.AnimationName = _animName;
            }
            _render = _skeleton.GetComponent<Renderer>();
            if (_render != null)
            {
                _render.enabled = true;
            }
            if (_queue > 0)
            {
                _render.material.renderQueue = _queue;
            }
        }
    }

    private void OnDestroy()
    {
        Dispose();
        _queue = -1;
        _skeleton = null;
    }
}
