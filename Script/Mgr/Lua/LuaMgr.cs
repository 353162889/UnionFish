using LuaInterface;
using System.Collections;
using UnityEngine;

public class LuaMgr : MonoBehaviour
{
    private static LuaMgr _instance;
    public static LuaMgr instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = Drive.drive.AddMissingComponent<LuaMgr>();
                //_instance.loader = new LuaLoader();
                _instance.loader = new LuaFileLoader();
            }
            return _instance;
        }
    }

    public static bool Verify()
    {
        return _instance != null && isInit;
    }

    public LuaState luaState = null;
    //private LuaLoader loader = null;
    private LuaFileLoader loader = null;
    private LuaLooper looper = null;
    private bool isClose = true;
    private static bool isInit = false;

    /// <summary>
    /// 启动lua虚拟机（外部接口）
    /// </summary>
    public void Init()
    {
        isClose = false;
        luaState = new LuaState();
        OpenLibs();
        LuaBinder.Bind(luaState);

        //添加搜索目录
        luaState.AddSearchPath(Application.dataPath + "/ToLua/Lua/protobuf");
        luaState.AddSearchPath(Application.dataPath + "/Lua/Protof");

        luaState.Start();

        looper = gameObject.AddComponent<LuaLooper>();
        looper.luaState = luaState;
        
        isInit = true;
    }

    public void StartGame()
    {
        if (isInit)
        {
            luaState.Require("Main");
            CallFunction("Main");
        }
    }

    /// <summary>
    /// 使用lua第三方包
    /// </summary>
    void OpenLibs()
    {
        luaState.OpenLibs(LuaDLL.luaopen_lpeg);
        luaState.OpenLibs(LuaDLL.luaopen_pb);
        OpenCJson();
    }

    //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
    private void OpenCJson()
    {
        luaState.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
        luaState.OpenLibs(LuaDLL.luaopen_cjson);
        luaState.LuaSetField(-2, "cjson");
        luaState.OpenLibs(LuaDLL.luaopen_cjson_safe);
        luaState.LuaSetField(-2, "cjson.safe");
    }

    public object[] DoFile(string filename)
    {
        if (!isClose)
        {
            return luaState.DoFile(filename);
        }
        return null;
    }
    public object[] CallFunction(string funcName, params object[] args)
    {
        if (!isClose)
        {
            LuaFunction func = luaState.GetFunction(funcName);
            if (func != null)
            {
                object[] result = func.Call(args);
                func.Dispose();
                func = null;
                return result;
            }
        }
        return null;
    }
    public LuaTable CreateLuaTable()
    {
        return (LuaTable)luaState.DoString("return {}")[0];
    }

    public LuaTable CreateLuaTable(IDictionary objs)
    {
        var table = CreateLuaTable();

        foreach (var key in objs.Keys)
        {
            table[key.ToString()] = objs[key];
        }
        return table;
    }

    public LuaTable ToLuaTable(IDictionary objs)
    {
        return CreateLuaTable(objs);
    }


    void OnDestroy()
    {
        Close();
    }
    public void Close()
    {
        luaState.Dispose();
        isClose = true;
    }
}
