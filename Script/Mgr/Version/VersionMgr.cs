using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Launch;
using System.IO;
using UnityEngine;

public class VersionMgr : Singleton<VersionMgr>
{
    public static readonly string Url_VersionCode = "version/versioncode";
    public static readonly string Url_VersionCodeExt = ".txt";
    public static readonly string Url_VersionData = "version/versionmanifest";
    public static readonly string Url_VersionDataExt = ".xml";

    public static readonly string Url_ResourceVersionFile = "Launch/versioncode";

    private StorageVersionData _pkgVerData;
    public StorageVersionData pkgVerData
    {
        get { return _pkgVerData; }
    }

    private StorageVersionData _localVerData;
    public StorageVersionData localVerData
    {
        get { return _localVerData; }
    }

    private StorageVersionData _remoteVerData;
    public StorageVersionData remoteVerData
    {
        get { return _remoteVerData; }
    }

    private Action<bool, string> _remoteLoadHandler;

    public VersionMgr()
    {
    }

    public void Init()
    {
        _pkgVerData = null;
        _localVerData = null;
        _remoteVerData = null;
        _remoteLoadHandler = null;
    }

    public int GenerateVersionCode()
    {
        DateTime date = DateTime.Now;
        string str = date.ToString("yyMMddHHmm");
        str = str.Substring(0, str.Length - 1);
        int versionCode = int.Parse(str);
        return versionCode;
    }

    public bool HasLocalFile()
    {
        string localUrl = GetLocalVersionFilePath();
        return File.Exists(localUrl);
    }

    public string GetLocalVersionFilePath()
    {
        return ResourceFileUtil.ResourceLoadPath + Url_VersionData + Url_VersionDataExt;
    }

    public bool LoadPkgVerData()
    {
        try
        {
            string files = null;
            if(Application.isEditor)
            {
                //如果是editor下，读取versioncode.txt文件（Resource加载模式下不加载版本号）
                string file = ResourceFileUtil.StreamingAssetsPath + Url_VersionCode + Url_VersionCodeExt;
                files = File.ReadAllText(file);
            }
            else
            { 
                //版本文件放在包内，所以，直接用Resources.load读取
                TextAsset txt = Resources.Load<TextAsset>(Url_ResourceVersionFile);
                files = txt.text;
            }
            if (string.IsNullOrEmpty(files))
            {
                LH.LogError("pkg version data is null!");
                return false;
            }
            if (_pkgVerData == null)
                _pkgVerData = new StorageVersionData();
            string[] arr = files.Split(',');
            _pkgVerData.PkgVersionCode = int.Parse(arr[0]);
            _pkgVerData.HotVersionCode = long.Parse(arr[1]);
            return true;
        }
        catch(Exception e)
        {
            LH.LogError("load pkg version data error!msg=" + e.Message + ",StackTrace=" + e.StackTrace);
            return false;
        }
       
    }

    public bool LoadLocalVerData()
    {
        string localUrl = GetLocalVersionFilePath();
        _localVerData = new StorageVersionData();
        bool hasError = false;
        if (File.Exists(localUrl))
        {
            string xml = File.ReadAllText(localUrl);
            bool isEmpty = string.IsNullOrEmpty(xml);
            if (!isEmpty)
            {
                try
                {
                    _localVerData.ParseVersionData(xml);
                }
                catch (Exception e)
                {
                    LH.LogError("parse local version data error!msg="+e.Message+ ",StackTrace=" + e.StackTrace);
                    hasError = true;
                }
            }
            else
            {
                LH.LogError("parse local version data is null!");
                hasError = true;
            }
            hasError = false;
        }
        else
        {
            LH.Log("not exist local version file,path="+localUrl);
            hasError = true;
        }
        //当有错误发生时，删除本地版本文件，下次打开，重新解压数据
        if(hasError)
        {
            //删除本地版本文件
            ResourceFileUtil.Instance.RemoveFile(localUrl);
        }
        return !hasError;
    }

    public void LoadRemoteVersionCode(Action<bool, string> handler)
    {
        _remoteLoadHandler = handler;
        string remoteUrl = Url_VersionCode + Url_VersionCodeExt + "?" + UnityEngine.Random.Range(0, 99999999);
        string url = ResourceFileUtil.Instance.GetRemotePath(GameConfig.ServerUrl, remoteUrl);
        LaunchWWWLoader.Instance.WWWRequest(url,10f, null, OnLoadRemoteVersion);
    }

    private void OnLoadRemoteVersion(string error,WWW www)
    {
        if (string.IsNullOrEmpty(error))
        {
            if (_remoteVerData == null)
                _remoteVerData = new StorageVersionData();
            string codeInfo = www.text;
            string[] arr = codeInfo.Split(',');
            _remoteVerData.PkgVersionCode = int.Parse(arr[0]);
            _remoteVerData.HotVersionCode = long.Parse(arr[1]);
            LH.Log("RemoteVersion:[versionPkgCode]" + _remoteVerData.PkgVersionCode + ",[versionCode]" + _remoteVerData.HotVersionCode);
            if (_remoteLoadHandler != null)
            {
                Action<bool, string> temp = _remoteLoadHandler;
                _remoteLoadHandler = null;
                temp(true, www.text);
            }
        }
        else
        {
            if (_remoteLoadHandler != null)
            {
                Action<bool, string> temp = _remoteLoadHandler;
                _remoteLoadHandler = null;
                temp(false, error);
            }
        }
    }


    public void LoadRemoteVersionData(Action<bool, string> handler)
    {
        _remoteLoadHandler = handler;
        string remoteUrl = Url_VersionData + Url_VersionDataExt + "?" + UnityEngine.Random.Range(0, 99999999);
        string url = ResourceFileUtil.Instance.GetRemotePath(GameConfig.ServerUrl, remoteUrl);
        LaunchWWWLoader.Instance.WWWRequest(url,10f, null, OnRemoteVersionDataLoaded);
    }

    private void OnRemoteVersionDataLoaded(string error,WWW www)
    {
        Debug.Log("OnRemoteVersionDataLoaded: " + www.text);
        if (string.IsNullOrEmpty(error))
        {
            if (_remoteVerData == null)
                _remoteVerData = new StorageVersionData();
            try
            { 
                _remoteVerData.ParseVersionData(www.text);
                if(_remoteLoadHandler != null)
                { 
                    Action<bool, string> temp = _remoteLoadHandler;
                    _remoteLoadHandler = null;
                    temp(true, www.text);
                }
            }
            catch(Exception e)
            {
                if (_remoteLoadHandler != null)
                {
                    Action<bool, string> temp = _remoteLoadHandler;
                    _remoteLoadHandler = null;
                    temp(false, "parse remote version data error!msg=" + e.Message + ",StackTrace=" + e.StackTrace);
                }
            }
        }
        else
        {
            if (_remoteLoadHandler != null)
            {
                Action<bool, string> temp = _remoteLoadHandler;
                _remoteLoadHandler = null;
                temp(false, error);
            }
        }
    }

    public bool IsClientNew()
    {
        return _localVerData == null || _remoteVerData == null || _localVerData.HotVersionCode >= _remoteVerData.HotVersionCode;
    }

    public bool IsPackageNew()
    {
        return _localVerData == null || _remoteVerData == null || _localVerData.PkgVersionCode >= _remoteVerData.PkgVersionCode;
    }

    public List<string> FindUpdateList()
    {
        List<string> updateList = new List<string>();
        if (_remoteVerData == null)
            return updateList;
        Dictionary<string, FileVersionData> remoteFileVersions = _remoteVerData.fileVersions;
        FileVersionData localVer;
        FileVersionData remoteVer;
        foreach (var pair in remoteFileVersions)
        {
            remoteVer = pair.Value;
            localVer = _localVerData.GetFileVersion(pair.Key);
            if (localVer == null)
            {
                updateList.Add(pair.Key);
            }
            else
            {
                if (remoteVer.crc != localVer.crc)
                {
                    updateList.Add(pair.Key);
                }
            }
        }
        return updateList;
    }

    public List<string> FindDeleteList()
    {
        List<string> deleteList = new List<string>();
        if (_remoteVerData == null)
            return deleteList;
        Dictionary<string, FileVersionData> localFileVersions = _localVerData.fileVersions;
        FileVersionData remoteVer;
        foreach (var item in localFileVersions)
        {
            remoteVer = _remoteVerData.GetFileVersion(item.Key);
            if (remoteVer == null)
            {
                deleteList.Add(item.Key);
            }
        }
        return deleteList;
    }

    public void UpdateLocalToNew()
    {
        _localVerData.PkgVersionCode = _remoteVerData.PkgVersionCode;
        _localVerData.HotVersionCode = _remoteVerData.HotVersionCode;
    }

    public void UpdateFileToNew(string file)
    {
        FileVersionData versionData = _remoteVerData.GetFileVersion(file);
        if (versionData != null)
        {
            _localVerData.SetFileVersion(file, versionData);
        }
    }

    public void SaveLocalVersionData()
    {
        if (_localVerData != null && _remoteVerData != null)
        {
            string file = GetLocalVersionFilePath();
            string tempFile = file + ".temp";
            Debug.Log("save tempFile:" + tempFile);
            try
            {
                _localVerData.WriteToFile(tempFile);
            }
            catch (Exception ex)
            {
                Debug.Log("write version error:" + ex.Message + " " + ex.StackTrace);
                //保存时出现异常，删除异常文件
                if (File.Exists(tempFile))
                {
                    File.Delete(tempFile);
                }
            }
            finally
            {
                //如果有临时文件
                if (File.Exists(tempFile))
                {
                    Debug.Log("Exist temp file:" + tempFile);
                    FileInfo fileInfo = new FileInfo(tempFile);
                    //临时文件有内容，用临时文件替换原来的版本文件
                    if (fileInfo.Length > 0)
                    {
                        Debug.Log("Delete file:" + file);
                        if (File.Exists(file))
                        {
                            File.Delete(file);
                        }
                        string dir = Path.GetDirectoryName(file);
                        if (!Directory.Exists(dir))
                        {
                            Directory.CreateDirectory(dir);
                        }
                        Debug.Log("Move tempFile:" + tempFile + " to file:" + file);
                        File.Move(tempFile, file);
                    }
                    else
                    {
                        Debug.Log("Delete temp file!");
                        File.Delete(tempFile);
                    }
                }
            }
        }
    }

    public void OnUpdateDone()
    {
        _remoteLoadHandler = null;
        _remoteVerData.Clear();
        _remoteVerData = null;
    }

    public void DeleteAllLocal()
    {
        ResourceFileUtil.Instance.RemoveDir(ResourceFileUtil.ResourceLoadPath);
    }

    public void DeleteUnuseLocal()
    {
        try
        { 
            List<string> deleteList = FindDeleteList();
            for (int i = 0; i < deleteList.Count; i++)
            {
                string url = ResourceFileUtil.ResourceLoadPath + deleteList[i];
                File.Delete(url);
                Debug.Log("<color='#ff0000'>[删除文件: " + url + "</color>");
            }
        }
        catch(Exception e)
        {
            LH.LogError("delete unuse local res error!msg="+e.Message+ ",StackTrace=" + e.StackTrace);
        }
    }

}
