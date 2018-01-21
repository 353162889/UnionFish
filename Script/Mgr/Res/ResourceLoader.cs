using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class ResourceLoader : MonoBehaviour
{
    private static int MaxLoaderCount = 5;

    public event Action<Resource> OnDone;
    private InResourcesLoader _inResourcesLoader;
    private WWWResLoader _wwwLoader;
    private LinkedList<Resource> _waitingList;
    private LinkedList<Resource> _loadingList;

    public static ResourceLoader GetResLoader(GameObject go)
    {
        ResourceLoader loader = go.AddMissingComponent<ResourceLoader>();
        loader.Init();
        return loader;
    }

    protected void Init()
    {
        _inResourcesLoader = this.gameObject.AddMissingComponent<InResourcesLoader>();
        _wwwLoader = this.gameObject.AddMissingComponent<WWWResLoader>();
        _inResourcesLoader.OnResourceDone += OnResourceDone;
        _wwwLoader.OnResourceDone += OnResourceDone;

        _waitingList = new LinkedList<Resource>();
        _loadingList = new LinkedList<Resource>();
    }

    private void OnResourceDone(Resource res)
    {
        if(_loadingList.Count > 0 && _loadingList.First.Value == res)
        {
            while(_loadingList.Count > 0 && _loadingList.First.Value.isDone)
            {
                Resource first = _loadingList.First.Value;
                _loadingList.RemoveFirst();
                if (OnDone != null)
                {
                    OnDone.Invoke(first);
                }
            }
        }
        LoadNext();
        //bool succ = _loadingList.Remove(res);
        //if (succ)
        //{
        //    if (OnDone != null)
        //    {
        //        OnDone.Invoke(res);
        //    }
        //}
        //LoadNext();
    }

    public void Load(Resource res)
    {
        if (_waitingList.Contains(res) || _loadingList.Contains(res))
            return;
        _waitingList.AddLast(res);
        LoadNext();
    }

    public bool IsWaitLoading(Resource res)
    {
        return _waitingList.Contains(res);
    }

    public bool RemoveWaitingLoadingRes(Resource res)
    {
        return _waitingList.Remove(res);
    }

    private void LoadNext()
    {
        while (_loadingList.Count < MaxLoaderCount && _waitingList.Count > 0)
        {
            Resource loadingRes = _waitingList.First.Value;
            _waitingList.RemoveFirst();
            _loadingList.AddLast(loadingRes);
            if (!ResourceMgr.Instance.ResourcesLoadMode)
            {
                _wwwLoader.Load(loadingRes);
            }
            else
            {
                _inResourcesLoader.Load(loadingRes);
            }
        }
    }

    void OnDestroy()
    {
        _inResourcesLoader.OnResourceDone -= OnResourceDone;
        _wwwLoader.OnResourceDone -= OnResourceDone;
    }
}
