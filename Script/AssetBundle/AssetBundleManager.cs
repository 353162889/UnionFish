using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using LuaInterface;

public class LoadedAssetBundle
{
    public AssetBundle m_AssetBundle;
    public int m_ReferencedCount;

    public LoadedAssetBundle(AssetBundle assetBundle)
    {
        m_AssetBundle = assetBundle;
        m_ReferencedCount = 1;
    }
}

public class AssetBundleManager
{
    //static string m_BaseDownloadingURL = "";
    static AssetBundleManifest m_AssetBundleManifest = null;
    static string[] m_ActiveVariants = { };
    static Dictionary<string, string> m_DownloadingErrors = new Dictionary<string, string>();
    static Dictionary<string, LoadedAssetBundle> m_LoadedAssetBundles = new Dictionary<string, LoadedAssetBundle>();
    static Dictionary<string, string[]> m_Dependencies = new Dictionary<string, string[]>();
    static Dictionary<string, WWW> m_DownloadingWWWs = new Dictionary<string, WWW>();
    static List<AssetBundleLoadOperation> m_InProgressOperations = new List<AssetBundleLoadOperation>();

    // AssetBundleManifest object which can be used to load the dependecies and check suitable assetBundle variants.
    public static AssetBundleManifest AssetBundleManifestObject
    {
        set { m_AssetBundleManifest = value; }
    }

    //public static string BaseDownloadingURL
    //{
    //    get { return m_BaseDownloadingURL; }
    //    set { m_BaseDownloadingURL = value; }
    //}

    public static AssetBundleLoadManifestOperation Initialize()
    {
        //m_BaseDownloadingURL = Util.GetAssetBundlePath();
        string manifestAssetBundleName = CommonUtils.platformName;
        LoadAssetBundle(manifestAssetBundleName, true);
        var operation = new AssetBundleLoadManifestOperation(manifestAssetBundleName, "AssetBundleManifest", typeof(AssetBundleManifest));
        m_InProgressOperations.Add(operation);
        return operation;
    }

    // Load AssetBundle and its dependencies.
    protected static void LoadAssetBundle(string assetBundleName, bool isLoadingAssetBundleManifest = false)
    {
        if (!isLoadingAssetBundleManifest)
        {
            if (m_AssetBundleManifest == null)
            {
                Debugger.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
                return;
            }
        }

        // Check if the assetBundle has already been processed.
        bool isAlreadyProcessed = LoadAssetBundleInternal(assetBundleName, isLoadingAssetBundleManifest);

        // Load dependencies.
        if (!isAlreadyProcessed && !isLoadingAssetBundleManifest)
            LoadDependencies(assetBundleName);
    }

    // Where we actuall call WWW to download the assetBundle.
    protected static bool LoadAssetBundleInternal(string assetBundleName, bool isLoadingAssetBundleManifest)
    {
        // Already loaded.
        LoadedAssetBundle bundle = null;
        m_LoadedAssetBundles.TryGetValue(assetBundleName, out bundle);
        if (bundle != null)
        {
            bundle.m_ReferencedCount++;
            return true;
        }

        // @TODO: Do we need to consider the referenced count of WWWs?
        // In the demo, we never have duplicate WWWs as we wait LoadAssetAsync()/LoadLevelAsync() to be finished before calling another LoadAssetAsync()/LoadLevelAsync().
        // But in the real case, users can call LoadAssetAsync()/LoadLevelAsync() several times then wait them to be finished which might have duplicate WWWs.
        if (m_DownloadingWWWs.ContainsKey(assetBundleName))
            return true;

        WWW download = null;
        string url = CommonUtils.GetAssetUrl(assetBundleName);

        // For manifest assetbundle, always download it as we don't have hash for it.
        if (isLoadingAssetBundleManifest)
            download = new WWW(url);
        else
            download = WWW.LoadFromCacheOrDownload(url, m_AssetBundleManifest.GetAssetBundleHash(assetBundleName), 0);

        m_DownloadingWWWs.Add(assetBundleName, download);

        return false;
    }

    // Where we get all the dependencies and load them all.
    protected static void LoadDependencies(string assetBundleName)
    {
        if (m_AssetBundleManifest == null)
        {
            Debugger.LogError("Please initialize AssetBundleManifest by calling AssetBundleManager.Initialize()");
            return;
        }

        // Get dependecies from the AssetBundleManifest object..
        string[] dependencies = m_AssetBundleManifest.GetAllDependencies(assetBundleName);
        if (dependencies.Length == 0)
            return;

        for (int i = 0; i < dependencies.Length; i++)
            dependencies[i] = RemapVariantName(dependencies[i]);

        // Record and load all dependencies.
        m_Dependencies.Add(assetBundleName, dependencies);
        for (int i = 0; i < dependencies.Length; i++)
            LoadAssetBundleInternal(dependencies[i], false);
    }

    // Remaps the asset bundle name to the best fitting asset bundle variant.
    static protected string RemapVariantName(string assetBundleName)
    {
        string[] bundlesWithVariant = m_AssetBundleManifest.GetAllAssetBundlesWithVariant();

        string[] split = assetBundleName.Split('.');

        int bestFit = int.MaxValue;
        int bestFitIndex = -1;
        // Loop all the assetBundles with variant to find the best fit variant assetBundle.
        for (int i = 0; i < bundlesWithVariant.Length; i++)
        {
            string[] curSplit = bundlesWithVariant[i].Split('.');
            if (curSplit[0] != split[0])
                continue;

            int found = System.Array.IndexOf(m_ActiveVariants, curSplit[1]);

            // If there is no active variant found. We still want to use the first 
            if (found == -1)
                found = int.MaxValue - 1;

            if (found < bestFit)
            {
                bestFit = found;
                bestFitIndex = i;
            }
        }

        if (bestFit == int.MaxValue - 1)
        {
            Debugger.LogWarning("Ambigious asset bundle variant chosen because there was no matching active variant: " + bundlesWithVariant[bestFitIndex]);
        }

        if (bestFitIndex != -1)
        {
            return bundlesWithVariant[bestFitIndex];
        }
        else
        {
            return assetBundleName;
        }
    }


    // Get loaded AssetBundle, only return vaild object when all the dependencies are downloaded successfully.
    public static LoadedAssetBundle GetLoadedAssetBundle(string assetBundleName, out string error)
    {
        if (m_DownloadingErrors.TryGetValue(assetBundleName, out error))
            return null;

        LoadedAssetBundle bundle = null;
        m_LoadedAssetBundles.TryGetValue(assetBundleName, out bundle);
        if (bundle == null)
            return null;

        // No dependencies are recorded, only the bundle itself is required.
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
            return bundle;

        // Make sure all dependencies are loaded
        foreach (var dependency in dependencies)
        {
            if (m_DownloadingErrors.TryGetValue(assetBundleName, out error))
                return bundle;

            LoadedAssetBundle dependentBundle;
            m_LoadedAssetBundles.TryGetValue(dependency, out dependentBundle);
            if (dependentBundle == null)
                return null;
        }

        return bundle;
    }

    // Unload assetbundle and its dependencies.
    public static void UnloadAssetBundle(string assetBundleName)
    {

        //UnloadAssetBundleInternal(assetBundleName);
        //UnloadDependencies(assetBundleName);
    }

    protected static void UnloadDependencies(string assetBundleName)
    {
        string[] dependencies = null;
        if (!m_Dependencies.TryGetValue(assetBundleName, out dependencies))
            return;

        // Loop dependencies.
        foreach (var dependency in dependencies)
        {
            UnloadAssetBundleInternal(dependency);
        }

        m_Dependencies.Remove(assetBundleName);
    }

    protected static void UnloadAssetBundleInternal(string assetBundleName)
    {
        string error;
        LoadedAssetBundle bundle = GetLoadedAssetBundle(assetBundleName, out error);
        if (bundle == null)
            return;

        if (--bundle.m_ReferencedCount == 0)
        {
            bundle.m_AssetBundle.Unload(false);
            m_LoadedAssetBundles.Remove(assetBundleName);
        }
    }

    public static void Update()
    {
        // Collect all the finished WWWs.
        var keysToRemove = new List<string>();
        foreach (var keyValue in m_DownloadingWWWs)
        {
            WWW download = keyValue.Value;

            // If downloading fails.
            if (download.error != null)
            {
                m_DownloadingErrors.Add(keyValue.Key, string.Format("Failed downloading bundle {0} from {1}: {2}", keyValue.Key, download.url, download.error));
                keysToRemove.Add(keyValue.Key);
                continue;
            }

            // If downloading succeeds.
            if (download.isDone)
            {
                AssetBundle bundle = download.assetBundle;
                if (bundle == null)
                {
                    m_DownloadingErrors.Add(keyValue.Key, string.Format("{0} is not a valid asset bundle.", keyValue.Key));
                    keysToRemove.Add(keyValue.Key);
                    continue;
                }

                //Debug.Log("Downloading " + keyValue.Key + " is done at frame " + Time.frameCount);
                m_LoadedAssetBundles.Add(keyValue.Key, new LoadedAssetBundle(download.assetBundle));
                keysToRemove.Add(keyValue.Key);
            }
        }

        // Remove the finished WWWs.
        foreach (var key in keysToRemove)
        {
            WWW download = m_DownloadingWWWs[key];
            m_DownloadingWWWs.Remove(key);
            download.Dispose();
        }

        // Update all in progress operations
        for (int i = 0; i < m_InProgressOperations.Count;)
        {
            if (!m_InProgressOperations[i].Update())
            {
                m_InProgressOperations.RemoveAt(i);
            }
            else
                i++;
        }
    }

    // Load asset from the given assetBundle.
    public static AssetBundleLoadAssetOperation LoadAssetAsync(string assetBundleName, string assetName, System.Type type)
    {
        //Debugger.Log("Loading " + assetName + " from " + assetBundleName + " bundle");

        AssetBundleLoadAssetOperation operation = null;

        assetBundleName = RemapVariantName(assetBundleName);
        LoadAssetBundle(assetBundleName);
        operation = new AssetBundleLoadAssetOperationFull(assetBundleName, assetName, type);

        m_InProgressOperations.Add(operation);

        return operation;
    }

    // Load level from the given assetBundle.
    public static AssetBundleLoadOperation LoadLevelAsync(string assetBundleName, string levelName, bool isAdditive, Action<float> onUpdateProgress)
    {
        //Debugger.Log("Loading " + levelName + " from " + assetBundleName + " bundle");

        AssetBundleLoadOperation operation = null;

        assetBundleName = RemapVariantName(assetBundleName);
        LoadAssetBundle(assetBundleName);
        operation = new AssetBundleLoadLevelOperation(assetBundleName, levelName, isAdditive,onUpdateProgress);

        m_InProgressOperations.Add(operation);

        return operation;
    }

    // Load AssetBundle Async
    public static AssetBundleLoadAssetBundleOperation LoadAssetBundleAsync(string assetBundleName)
    {
        //Debugger.Log("Loading AssetBundle:" + assetBundleName);
        AssetBundleLoadAssetBundleOperation operation = null;

        assetBundleName = RemapVariantName(assetBundleName);
        LoadAssetBundle(assetBundleName);
        operation = new AssetBundleLoadAssetBundleOperation(assetBundleName);
        m_InProgressOperations.Add(operation);
        return operation;
    }
}

