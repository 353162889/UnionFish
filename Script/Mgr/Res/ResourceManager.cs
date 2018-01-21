using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using LuaInterface;
using System;
using Object = UnityEngine.Object;

public class ResourceManager : MonoBehaviour
{
    #region 角色资源路径
    public const string CHARACTER_MODEL_URL = "external_res/characters/model/";
    public const string CHARACTER_TEXTURE_URL = "external_res/characters/texture/";
    public const string CHARACTER_CTRL_URL = "external_res/characters/ctrl/";
    #endregion
    #region 场景资源路径
    public const string SCENE_PREFAB_URL = "external_res/scene/prefabs/";
    public const string SCENE_MODEL_URL = "external_res/scene/models/";
    public const string SCENE_TEXTURE_URL = "external_res/scene/textures/";
    public const string SCENE_LIGHTMAP_URL = "external_res/scene/lightmaps/";
    public const string SCENE_LOOT_URL = "external_res/characters/model/items/";
    public const string SCENE_DOOR_URL = "external_res/effects/prefabs/scenes_eff/";
    public const string SCENE_BUFF_URL = "external_res/effects/prefabs/";
    #endregion
    #region 特效资源路径
    public const string EFFECT_URL = "external_res/effects/prefabs/";
    public const string EFFECT_TEX_URL = "external_res/effects/commonTex/";
    #endregion
    #region 音效资源路径
    public const string SOUND_URL = "external_res/sounds/";
    public const string SOUND_MUSIC_URL = "external_res/sounds/music";
    #endregion
    #region 配置资源路径
    public const string SKILL_CFG_URL = "external_res/config/skill/";
    public const string CFG_URL = "external_res/config/batch/";
    #endregion
    #region TPL资源路径
    public const string TPL_DATA_URL = "external_res/tpl_data/";
    #endregion


    public delegate void OnCompleteBytes(byte[] www, object info);
    public delegate void OnQueueComplete(Object[] res, object info);
    private static ResourceManager _instance;

    public static ResourceManager instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = Drive.drive.AddComponent<ResourceManager>();
            }
            return _instance;
        }
    }

    public delegate void OnLoadAssetFinishCallBack<T>(T o, object parms);

    public delegate void OnLoadLevelFinishCallBack();

    public AssetBundleLoadManifestOperation Initialize()
    {
        return AssetBundleManager.Initialize();
    }

    void Update()
    {
        AssetBundleManager.Update();
    }

    #region Lua调用接口
    public void LuaLoadPrefab(string assetPath, LuaFunction callback)
    {
        StartCoroutine(DoLoadAssetForLua<GameObject>(assetPath, callback));
    }

    public void LuaLoadTexture(string assetPath, LuaFunction callback)
    {
        StartCoroutine(DoLoadAssetForLua<Texture>(assetPath, callback));
    }

    IEnumerator DoLoadAssetForLua<T>(string assetPath, LuaFunction callback) where T : UnityEngine.Object
    {
        AssetBundleLoadAssetOperation operation = LoadAsset<T>(assetPath);
        if (operation == null)
        {
            yield break;
        }
        yield return StartCoroutine(operation);
        if (callback != null)
            callback.Call(operation.GetAsset<T>());
        UnLoadAsset(assetPath);
    }
    #endregion

    #region C#调用接口

    public static void loadBinRes(string url, OnCompleteBytes callback, object parms)
    {
        string Url = CommonUtils.GetAssetUrl(url);
        instance.StartCoroutine(instance.LoadData(Url, callback, parms));
    }

    public static void loadBinResAbsolutely(string url, OnCompleteBytes callback, object parms)
    {
        instance.StartCoroutine(instance.LoadData(url, callback, parms));
    }

    public static void downloadBinRes(string url, OnCompleteBytes callback, object parms)
    {
        instance.StartCoroutine(instance.LoadData(url, callback, parms));
    }

    IEnumerator LoadData(string url, OnCompleteBytes callback, object info)
    {
        WWW www = new WWW(url);
        yield return www;
        if (callback != null)
        {
            callback(www.bytes, info);
        }
    }

    public AssetBundleLoadAssetOperation LoadAsset<T>(string assetPath)
    {
        string assetbundleName = CommonUtils.ParseAssetBundleName(assetPath);
        string assetName = CommonUtils.ParseAssetName(assetPath);
        return AssetBundleManager.LoadAssetAsync(assetbundleName, assetName, typeof(T));
    }


    public void LoadAsset<T>(string assetPath, OnLoadAssetFinishCallBack<T> callback, object parms = null) where T : UnityEngine.Object
    {
        StartCoroutine(DoLoadAsset<T>(assetPath, callback, parms));
    }

    IEnumerator DoLoadAsset<T>(string assetPath, OnLoadAssetFinishCallBack<T> callback, object parms = null) where T : UnityEngine.Object
    {
        AssetBundleLoadAssetOperation operation = LoadAsset<T>(assetPath);
        if (operation == null)
        {
            yield break;
        }
        yield return StartCoroutine(operation);

        if (callback != null)
            callback.Invoke(operation.GetAsset<T>(), parms);
        UnLoadAsset(assetPath);
    }

    public void LoadAssetQueue(string[] assetPaths, OnQueueComplete callback, object parms = null)
    {
        StartCoroutine(DoLoadAssetQueue(assetPaths, callback, parms));
    }

    IEnumerator DoLoadAssetQueue(string[] assetPaths, OnQueueComplete callback, object parms)
    {
        Object[] assets = null;
        if (assetPaths != null)
        {
            assets = new Object[assetPaths.Length];
            for (int i = 0; i < assetPaths.Length; i++)
            {
                AssetBundleLoadAssetOperation operation = LoadAsset<Object>(assetPaths[i]);
                if (operation == null)
                {
                    yield break;
                }
                yield return operation;
                assets[i] = operation.GetAsset<Object>();
                UnLoadAsset(assetPaths[i]);
            }
        }
        if (callback != null)
            callback(assets, parms);
    }

    public void LoadLevel(string levelPath, bool isAdditive, OnLoadLevelFinishCallBack callback)
    {
        string assetbundleName = CommonUtils.ParseLevelBundleName(levelPath);
        string levelName = CommonUtils.ParseAssetName(levelPath);
        StartCoroutine(DoLoadLevel(assetbundleName, levelName, isAdditive, callback));
    }

    IEnumerator DoLoadLevel(string assetbundleName, string levelName, bool isAdditive, OnLoadLevelFinishCallBack callback)
    {
        AssetBundleLoadOperation operation = AssetBundleManager.LoadLevelAsync(assetbundleName, levelName, isAdditive, null);
        if (operation == null)
        {
            yield break;
        }
        yield return StartCoroutine(operation);

        if (callback != null)
        {
            callback.Invoke();
        }

        AssetBundleManager.UnloadAssetBundle(assetbundleName);
    }

    public AssetBundleLoadOperation LoadLevel(string levelPath, bool isAdditive, Action<float> onUpdateProgress = null)
    {
        string assetbundleName = CommonUtils.ParseLevelBundleName(levelPath);
        string levelName = CommonUtils.ParseAssetName(levelPath);
        return AssetBundleManager.LoadLevelAsync(assetbundleName, levelName, isAdditive, onUpdateProgress);
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="assetbundleName"></param>
    /// <returns></returns>
    public AssetBundleLoadAssetBundleOperation LoadAssetBundle(string assetbundleName)
    {
        return AssetBundleManager.LoadAssetBundleAsync(assetbundleName);
    }

    public void UnLoadAsset(string assetPath)
    {
        //AssetBundleManager.UnloadAssetBundle(CommonUtils.ParseAssetBundleName(assetPath));
    }

    #endregion
}
