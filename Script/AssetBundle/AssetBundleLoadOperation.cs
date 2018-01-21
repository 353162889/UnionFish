using UnityEngine;
using System.Collections;
using System;
using UnityEngine.SceneManagement;
using LuaInterface;

public abstract class AssetBundleLoadOperation : IEnumerator
{
    public object Current { get { return null; } }

    public bool MoveNext() { return !IsDone(); }

    public void Reset() { }

    abstract public bool Update();

    abstract public bool IsDone();
}

public abstract class AssetBundleLoadAssetOperation : AssetBundleLoadOperation
{
    public abstract T GetAsset<T>() where T : UnityEngine.Object;
}

public class AssetBundleLoadAssetOperationFull : AssetBundleLoadAssetOperation
{
    protected string m_AssetBundleName;
    protected string m_AssetName;
    protected string m_DownloadingError;
    protected System.Type m_Type;
    protected AssetBundleRequest m_Request = null;

    public AssetBundleLoadAssetOperationFull(string bundleName, string assetName, System.Type type)
    {
        m_AssetBundleName = bundleName;
        m_AssetName = assetName;
        m_Type = type;
    }

    public override T GetAsset<T>()
    {
        if (m_Request != null && m_Request.isDone)
            return m_Request.asset as T;
        else
            return null;
    }

    public override bool Update()
    {
        if (m_Request != null)
            return false;

        LoadedAssetBundle bundle = AssetBundleManager.GetLoadedAssetBundle(m_AssetBundleName, out m_DownloadingError);
        if (bundle != null)
        {
            if(string.IsNullOrEmpty(m_AssetName))
            {
                Debugger.LogError("加载资源名为空：AssetBundleName:" + m_AssetBundleName + " AssetName:" + m_AssetName + " Type:" + m_Type.Name);
            }
            ///@TODO: When asset bundle download fails this throws an exception...
            m_Request = bundle.m_AssetBundle.LoadAssetAsync(m_AssetName, m_Type);
            return false;
        }
        else
        {
            return true;
        }
    }

    public override bool IsDone()
    {
        if (m_Request == null && m_DownloadingError != null)
        {
            Debugger.LogError(m_DownloadingError);
            return true;
        }

        return m_Request != null && m_Request.isDone;
    }
}

public class AssetBundleLoadLevelOperation : AssetBundleLoadOperation
{
    protected string m_AssetBundleName;
    protected string m_LevelName;
    protected bool m_IsAdditive;
    protected string m_DownloadingError;
    protected AsyncOperation m_Requset;
    protected Action<float> m_OnUpdateProgress;

    public AssetBundleLoadLevelOperation(string assetbundleName, string levelName, bool isAdditive, Action<float> onUpdateProgress)
    {
        m_AssetBundleName = assetbundleName;
        m_LevelName = levelName;
        m_IsAdditive = isAdditive;
        m_OnUpdateProgress = onUpdateProgress;
    }

    public override bool Update()
    {
        if (m_Requset != null)
            return false;

        LoadedAssetBundle bundle = AssetBundleManager.GetLoadedAssetBundle(m_AssetBundleName, out m_DownloadingError);
        if (bundle != null)
        {
            if (m_IsAdditive)
                m_Requset = SceneManager.LoadSceneAsync(m_LevelName, LoadSceneMode.Additive);
            else
                m_Requset = SceneManager.LoadSceneAsync(m_LevelName, LoadSceneMode.Single);
            return false;
        }
        else
            return true;
    }

    public override bool IsDone()
    {
        if (m_Requset == null && m_DownloadingError != null)
        {
            Debugger.LogError(m_DownloadingError);
            return true;
        }
        if (m_Requset != null)
        {
            if (m_OnUpdateProgress != null)
                m_OnUpdateProgress(m_Requset.progress);
        }
        return m_Requset != null && m_Requset.isDone;
    }
}

public class AssetBundleLoadManifestOperation : AssetBundleLoadAssetOperationFull
{
    public AssetBundleLoadManifestOperation(string bundleName, string assetName, System.Type type) : base(bundleName, assetName, type) { }

    public override bool Update()
    {
        base.Update();

        if (m_Request != null && m_Request.isDone)
        {
            AssetBundleManager.AssetBundleManifestObject = GetAsset<AssetBundleManifest>();
            return false;
        }
        else
            return true;
    }
}

public class AssetBundleLoadAssetBundleOperation : AssetBundleLoadOperation
{
    protected string m_AssetBundleName;
    protected string m_DownloadingError;
    public AssetBundle m_Bundle = null;

    public AssetBundleLoadAssetBundleOperation(string bundleName)
    {
        m_AssetBundleName = bundleName;
    }

    public override bool IsDone()
    {
        if (m_Bundle == null && m_DownloadingError != null)
        {
            Debugger.LogError(m_DownloadingError);
            return true;
        }

        return m_Bundle != null;
    }

    public override bool Update()
    {
        if (m_Bundle != null)
            return false;

        LoadedAssetBundle bundle = AssetBundleManager.GetLoadedAssetBundle(m_AssetBundleName, out m_DownloadingError);
        if (bundle != null)
        {
            ///@TODO: When asset bundle download fails this throws an exception...
            m_Bundle = bundle.m_AssetBundle;
            return false;
        }
        else
        {
            return true;
        }
    }
}