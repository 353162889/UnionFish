using LuaInterface;
using System.Collections;
using System.Text;
using UnityEngine;
using System;
using UnityEngine.SceneManagement;
using System.Collections.Generic;
using Launch;

public class Drive : MonoBehaviour
{
    private static string MainEntryFile = "asset_bundle_entry.xml";
    private static string LuaAssetBundleFile = "luacode/luacode.assetbundle";
    private static string ResourceLuaFiles = "LuaCode/LuaCodes.bytes";
    public static GameObject drive;
    public static bool IsStartGame = false;
    private Resource _luaBundleRes;
    private MultiResourceLoader _luaResourceResLoader;
    private bool _isRunning;
    private CommandSequence sequence;
   
    void Start()
    {
        _isRunning = true;
        Application.runInBackground = true;
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        drive = GameObject.Find("UIRoot/Drive");
        if(Debug.isDebugBuild)
        {
            drive.AddComponent<ConsoleLogger>();
        }
        DontDestroyOnLoad(drive.transform.parent.gameObject);
        sequence = new CommandSequence();
        Cmd_Init init = new Cmd_Init();
        Cmd_LoadPkgVersion loadPkgVersion = new Cmd_LoadPkgVersion();
        Cmd_LoadLocalVersion loadLocalVersion = new Cmd_LoadLocalVersion();

        //热更流程
        CommandSequence hotUpdateSequence = new CommandSequence();
        Cmd_LoadRemoteVersion loadRemoteVersion = new Cmd_LoadRemoteVersion();
        Cmd_DownloadHotUpdateFiles downloadHotUpdateFiles = new Cmd_DownloadHotUpdateFiles();
        hotUpdateSequence.AddCmd(loadRemoteVersion);
        hotUpdateSequence.AddCmd(downloadHotUpdateFiles);

        //非热更流程
        CommandSequence notHotUpdateSequence = new CommandSequence();

        //热更检测流程
        CommandSelector hotUpdateSelect = new CommandSelector();
        Cmd_HotUpdateCheck hotUpdateCheck = new Cmd_HotUpdateCheck();//检测成功走热更流程，不成功走非热更流程
        hotUpdateSelect.AddConditionWork(hotUpdateCheck, hotUpdateSequence, notHotUpdateSequence);

        Cmd_InitAssetBundleMgr initABMgr = new Cmd_InitAssetBundleMgr();
        Cmd_InitLuaFiles initLuaFile = new Cmd_InitLuaFiles();
        Cmd_EnterGame enterGame = new Cmd_EnterGame();
        sequence.AddCmd(init);
        sequence.AddCmd(loadPkgVersion);
        sequence.AddCmd(loadLocalVersion);
        sequence.AddCmd(hotUpdateSelect);
        sequence.AddCmd(initABMgr);
        sequence.AddCmd(initLuaFile);
        sequence.AddCmd(enterGame);

        sequence.OnCmdDone += OnCmdDone;
        sequence.OnStart();

    }

    private void OnCmdDone(CommandBase cmd)
    {
        if(cmd.Status == CommandStatus.Succeed)
        {
            LH.Log("启动成功");
            sequence = null;
        }
        else
        {
            LH.LogError("启动流程错误，退出游戏");
            //Application.Quit();
        }
    }

    public void OnDestroy()
    {
        _isRunning = false;
    }


    public void OnApplicationPause(bool pause)
    {
        if (!_isRunning)
            return;
        if(IsStartGame)
        {
            LuaMgr.instance.CallFunction("LinkCtrl.OnApplicationPause",pause);
        }
        LH.Log("OnApplicationPause:"+pause);
    }

    //private void EnterGame() 
    //{
    //    if(ResourceMgr.Instance.ResourcesLoadMode)
    //    {
    //        LoadLuaFile();
    //    }
    //    else
    //    {
    //        ResourceMgr.Instance.GetResource(MainEntryFile, OnLoadEntryFile,null,ResourceType.Text);
    //    }
    //  //  StartCoroutine(InitGame());
    //}

    //private void OnLoadEntryFile(Resource res)
    //{
    //    string str = res.GetText();
    //    AssetBundleMgr.Instance.Init(str);
    //    //加载依赖文件
    //    ResourceMgr.Instance.GetResource(AssetBundleMgr.Instance.MainAssetBundlePath, OnLoadDependFile, OnLoadDependFile);
    //}

    //private void OnLoadDependFile(Resource res)
    //{
    //    if(res.isSucc)
    //    {
    //        AssetBundleManifest manifest = (AssetBundleManifest)res.GetAsset(null);
    //        AssetBundleMgr.Instance.AddAssetBundleManifest(manifest);
    //        LoadLuaFile();
    //    }
    //    else
    //    {
    //        LH.LogError("加载依赖文件失败!path="+ AssetBundleMgr.Instance.MainAssetBundlePath);
    //    }
    //}

    //private void LoadLuaFile()
    //{
    //    if (ResourceMgr.Instance.ResourcesLoadMode)
    //    {
    //        //Editor下直接运行游戏
    //        if(Application.isEditor)
    //        { 
    //            RealStartGame();
    //        }
    //        //resource包的时候，预加载所有的lua文件
    //        else
    //        {
    //            ResourceMgr.Instance.GetResource(ResourceLuaFiles, OnLoadResourceLuaFiles,null,ResourceType.Text);
    //        }
    //    }
    //    else
    //    {
    //        //预加载
    //        ResourceMgr.Instance.GetResource(LuaAssetBundleFile, OnLoadAssetBundle);
    //    }
    //}

    //private void OnLoadResourceLuaFiles(Resource res)
    //{
    //    string text = res.GetText();
    //    string[] files = text.Split(',');
    //    if(files == null)
    //    {
    //        RealStartGame();
    //        return;
    //    }
    //    _luaResourceResLoader = new MultiResourceLoader();
    //    List<string> names = new List<string>();
    //    for (int i = 0; i < files.Length; i++)
    //    {
    //        names.Add(files[i]);
    //    }
    //    _luaResourceResLoader.LoadList(names,OnLoadLuaFinish,null,ResourceType.Bytes);
    //}
    //private void OnLoadLuaFinish(MultiResourceLoader loader)
    //{
    //    RealStartGame();
    //}

    //private void OnLoadAssetBundle(Resource res)
    //{
    //    _luaBundleRes = res;
    //    _luaBundleRes.Retain();
    //    RealStartGame();
    //}

    //private void RealStartGame()
    //{
    //    //提前载入必要lua文件
    //    LuaMgr.instance.Init();

    //    //初始化网络
    //    Client.Instance.Init();

    //    //启动lua代码
    //    LuaMgr.instance.StartGame();
    //}

    public readonly static int refWidth = 1280;
    public readonly static int refHeight = 720;
    public static float zoom { private set; get; }
    public void UISelfAdaption()
    {
        Debugger.Log("开始适配");
        //设置自适应
        GameObject uiRoot = GameObject.Find("UIRoot");
        UIRoot root = uiRoot.GetComponent<UIRoot>();
        int screenWidth = Screen.width;
        int screenHeight = Screen.height;
        Debugger.Log(string.Format("当前机器分辨率为：{0}X{1}", screenWidth, screenHeight));
        if (screenWidth * refHeight / screenHeight < refWidth)
        {
            Debugger.Log("需要重新计算高度");
            int val = refWidth * screenHeight / screenWidth;
            Debugger.Log(string.Format("设置高度为：{0}", val));
            //重新计算高度
            root.manualHeight = val;
            root.minimumHeight = val;
            root.maximumHeight = val;
        }
        else
        {
            Debugger.Log("不需要适配");
        }
        zoom = screenHeight / (float)refHeight;
    }

    void OnApplicationQuit()
    {
        if(GameConfig.IsHotUpdateMode)
        { 
		    VersionMgr.Instance.SaveLocalVersionData();
		    LaunchDownloadMgr.Instance.StopService();
        }
        SDKMgr.Dispose();
        Client.Instance.Disconnect();
        if(sequence != null)
        {
            sequence.OnDestroy();
        }
    }

    void Update()
    {
        if(Application.platform == RuntimePlatform.Android || Application.platform == RuntimePlatform.IPhonePlayer)
        {

            if (HttpMgr.Instance.IsVisiable)
            {
                if (Input.GetKeyDown(KeyCode.Home) || Input.GetKeyDown(KeyCode.Escape))
                {
                    HttpMgr.Instance.SetVisibility(false);
                }
            }
            else
            {
                if (Input.GetKeyDown(KeyCode.Escape))
                {
                    if (SDKMgr.IsInit)
                    {
                        SDKMgr.Exit();
                    }
                    else
                    {
                        if (IsStartGame)
                        {
                            LuaMgr.instance.CallFunction("LinkCtrl.OnExitGame");
                        }
                    }
                }
            }
            
        }
    }

    //private void OnGUI()
    //{
    //    if(GUI.Button(new Rect(0,0,100,50),"停止下载"))
    //    {
    //        LaunchDownloadMgr.Instance.StopService();
    //    }
    //    if (GUI.Button(new Rect(100, 0, 100, 50), "开始下载"))
    //    {
    //        LaunchDownloadMgr.Instance.StartService();
    //    }
    //}
}