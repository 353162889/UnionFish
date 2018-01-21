using UnityEngine;
using System.Collections;
using System.IO;
using LuaInterface;
using System.Collections.Generic;

/// <summary>
/// 集成自LuaFileUtils，重写里面的ReadFile，
/// </summary>
public class LuaLoader : LuaFileUtils
{
#if UNITY_EDITOR
    bool isReload = false;
    List<string> loadedList = new List<string>();
#endif

    // Use this for initialization
    public LuaLoader()
    {
        instance = this;
        beZip = Global.LuaAssetBundleMode;
    }

    /// <summary>
    /// 增加Lua代码AssetBundle
    /// </summary>
    /// <param name="bundleName"></param>
    /// <param name="ab"></param>
    public void AddBundle(string bundleName, AssetBundle ab)
    {
        if (ab != null)
            base.AddSearchBundle(bundleName, ab);
    }

    /// <summary>
    /// 当LuaVM加载Lua文件的时候，这里就会被调用，
    /// 用户可以自定义加载行为，只要返回byte[]即可。
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    public override byte[] ReadFile(string fileName)
    {
        Debugger.Log("Load file:" + fileName);

        if (string.IsNullOrEmpty(fileName))
        {
            Debug.LogError("[ERROR] Lua file name error, Is null or empty !");
            return null;
        }

        if (Application.isEditor || !beZip)
        {
            byte[] str = null;
            //string path = GetFullPathFileName(fileName);
            string path = FindFile(fileName);

            if (File.Exists(path))
            {
                str = File.ReadAllBytes(path);
                string s = System.Text.Encoding.UTF8.GetString(str);
#if UNITY_EDITOR
                if (!loadedList.Contains(fileName))
                    loadedList.Add(fileName);
#endif
            }

            return str;
        }
        else
        {
            return ReadZipFile(fileName);
        }
    }

    /// <summary>
    /// 查找 Lua 文件
    /// </summary>
    /// <param name="fileName"></param>
    /// <returns></returns>
    public override string FindFile(string fileName)
    {
        if (fileName == string.Empty)
        {
            return string.Empty;
        }

        if (Path.IsPathRooted(fileName))
        {
            if (!fileName.EndsWith(".lua"))
            {
                fileName += ".lua";
            }

            return fileName;
        }

        if (fileName.EndsWith(".lua"))
        {
            fileName = fileName.Substring(0, fileName.Length - 4);
        }

        string fullPath = null;

        for (int i = 0; i < searchPaths.Count; i++)
        {
            fullPath = searchPaths[i].Replace("?", fileName);

            if (File.Exists(fullPath))
            {
                return fullPath;
            }
        }

        return null;
    }

    byte[] ReadZipFile(string fileName)
    {
        byte[] buffer = null;
        AssetBundle zipFile = null;

        if (!Path.HasExtension(fileName))
        {
            fileName += ".lua";
        }

        string abDir = Global.LuaTempDir + fileName;
        string abName = CommonUtils.ParseAssetBundleName(abDir);
        string assetName = CommonUtils.ParseAssetName(abDir) + ".bytes";
        zipMap.TryGetValue(abName, out zipFile);

        if (zipFile == null)
        {
            string abPath = CommonUtils.GetAssetPath(abName);
            Debugger.Log("请求加载luaAB：" + abPath);
            if (File.Exists(abPath))
            {
                zipFile = AssetBundle.LoadFromFile(abPath);
                if (zipFile != null)
                {
                    AddSearchBundle(abName, zipFile);
                }
            }
            Debugger.Log(abPath);
        }

        if (zipFile != null)
        {
            Debugger.Log("luaAB加载成功：" + abName);
            TextAsset luaCode = zipFile.LoadAsset(assetName) as TextAsset;
            if (luaCode != null)
            {
                string s = luaCode.text;
                buffer = luaCode.bytes;
                Resources.UnloadAsset(luaCode);
            }
        }
        return buffer;
    }
#if UNITY_EDITOR
    /// <summary>
    /// 重新加载Lua
    /// </summary>
    public void ReloadLua()
    {
        if (isReload)
            return;
        isReload = true;
        if (LuaMgr.Verify())
        {
            List<string> list = new List<string>(loadedList.ToArray());
            foreach (var file in list)
            {
                //if (file.Equals("tolua.lua"))
                //    continue;
                LuaMgr.instance.DoFile(file);
                //Debugger.Log("重新加载Lua文件：" + file);
            }
        }
        isReload = false;
        Debugger.Log("重新加载Lua文件结束");
    }
#endif
}

