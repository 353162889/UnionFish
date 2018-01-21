using UnityEngine;
using System.Collections;
using System.Security.Cryptography;
using System.IO;
using System.Text;
using System;
using System.Collections.Generic;
using LuaInterface;
#if UNITY_EDITOR
using UnityEditor;
#endif


public class CommonUtils
{

    #region Log
    public static void Log(string str)
    {
        Debugger.Log("LUA▲▲▲" + str);
    }

    public static void LogWarning(string str)
    {
        Debugger.LogWarning("LUA▲▲▲" + str);
    }

    public static void LogError(string str)
    {
        Debugger.LogError("LUA▲▲▲" + str);
    }
    #endregion

    #region 路径目录

    public static string platformName
#if UNITY_EDITOR
    {
        get
        {
            if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.Android)
                return "Android";
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.iOS)
                return "IOS";
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.StandaloneWindows
                || EditorUserBuildSettings.activeBuildTarget == BuildTarget.StandaloneWindows64)
                return "Windows";
            else if (EditorUserBuildSettings.activeBuildTarget == BuildTarget.WebGL)
                return "WebGL";
            else
                return "";
        }
    }
#elif UNITY_ANDROID
         ="Android";
#elif UNITY_IPHONE
        = "IOS";
#elif UNITY_STANDALONE_WIN
        = "Windows";
#elif UNITY_WEBPLAYER
        = "WebGL";
#else
        = String.Empty;
#endif


    public static string persistentDataPath = Application.persistentDataPath + "/" + platformName + "/";

    public static string persistentDataUrl =
#if UNITY_EDITOR
        "file:///" + persistentDataPath;
#elif UNITY_ANDROID
        "file://" + persistentDataPath;
#elif UNITY_IPHONE
        "file://" + persistentDataPath;
#elif UNITY_STANDALONE_WIN
        "file:///" + persistentDataPath;
#else
        String.Empty;
#endif

    public static string streamingDataPath =
#if UNITY_EDITOR
        Application.dataPath + "/StreamingAssets/" + platformName + "/";
#elif UNITY_ANDROID
        "jar:file://" + Application.dataPath + "!/assets/"+ platformName + "/";
#elif UNITY_IPHONE
        Application.dataPath + "/Raw/"+platformName + "/";
#elif UNITY_STANDALONE_WIN
        Application.dataPath + "/StreamingAssets/" + platformName + "/";
#else
        String.Empty;
#endif

    public static string streamingDataUrl =
#if UNITY_EDITOR
       "file://" + streamingDataPath;
#elif UNITY_ANDROID
        streamingDataPath;
#elif UNITY_IPHONE
        "file://" + streamingDataPath;
#elif UNITY_STANDALONE_WIN
        "file://" + streamingDataPath;
#else
        String.Empty;
#endif


#if !UNITY_EDITOR
    private static Dictionary<string, bool> _filePathCache = new Dictionary<string, bool>();
#endif


    public static string GetAssetUrl(string assetName)
    {
#if UNITY_EDITOR
        return streamingDataUrl + assetName;
#else
        string path = persistentDataPath + assetName;
        bool exist = false;
        if (_filePathCache.TryGetValue(path, out exist))
        {
            if (exist)
            {
                path = persistentDataUrl + assetName;
            }
            else
            {
                path = streamingDataUrl + assetName;
            }
        }
        else
        {
            if (File.Exists(path))
            {
                _filePathCache[path] = true;
                path = persistentDataUrl + assetName;
            }
            else
            {
                _filePathCache[path] = false;
                path = streamingDataUrl + assetName;
            }
        }
        return path;
#endif
    }

    public static string GetAssetPath(string assetName)
    {
#if UNITY_EDITOR
        return streamingDataPath + assetName;
#else
        string path = persistentDataPath + assetName;
        bool exist = false;
        if (_filePathCache.TryGetValue(path, out exist))
        {
            if (exist)
            {
                path = persistentDataPath + assetName;
            }
            else
            {
                path = streamingDataPath + assetName;
            }
        }
        else
        {
            if (File.Exists(path))
            {
                _filePathCache[path] = true;
                path = persistentDataPath + assetName;
            }
            else
            {
                _filePathCache[path] = false;
                path = streamingDataPath + assetName;
            }
        }
        return path;
#endif
    }


    #endregion

    #region MD5
    /// <summary>
    /// 计算字符串的MD5值
    /// </summary>
    public static string md5(string source)
    {
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
        byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
        md5.Clear();

        string destString = "";
        for (int i = 0; i < md5Data.Length; i++)
        {
            destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
        }
        destString = destString.PadLeft(32, '0');
        return destString;
    }

    /// <summary>
    /// 计算文件的MD5值
    /// </summary>
    public static string md5file(string file)
    {
        try
        {
            FileStream fs = new FileStream(file, FileMode.Open);
            System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] retVal = md5.ComputeHash(fs);
            fs.Close();

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < retVal.Length; i++)
            {
                sb.Append(retVal[i].ToString("x2"));
            }
            return sb.ToString();
        }
        catch (Exception ex)
        {
            throw new Exception("md5file() fail, error:" + ex.Message);
        }
    }
    #endregion

    #region AssetBundle
    /// <summary>
    /// 解析AB资源包名称
    /// </summary>
    /// <param name="assetPath"></param>
    /// <returns></returns>
    public static string ParseAssetBundleName(string assetPath)
    {
        int p = assetPath.LastIndexOf('/');
        if (p == -1)
        {
            Debugger.LogError("AssetPath Error:" + assetPath);
            return "";
        }
        string bundleName = assetPath.Remove(p);
        return bundleName.Replace('/', '!').ToLower();
    }
    /// <summary>
    /// 解析AB关卡包名
    /// </summary>
    /// <param name="assetPath"></param>
    /// <returns></returns>
    public static string ParseLevelBundleName(string assetPath)
    {
        return assetPath.Replace('/', '!').ToLower() + "!scene";
    }

    /// <summary>
    /// 解析AB包资源名
    /// </summary>
    /// <param name="assetPath"></param>
    /// <returns></returns>
    public static string ParseAssetName(string assetPath)
    {
        int p = assetPath.LastIndexOf('/');
        if (p == -1)
        {
            Debugger.LogError("AssetPath Error:" + assetPath);
            return "";
        }
        return assetPath.Substring(p + 1);
    }
    #endregion
}
