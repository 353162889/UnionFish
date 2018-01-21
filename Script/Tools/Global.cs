using UnityEngine;
using System.Collections.Generic;

public class Global
{
    /// <summary>
    /// 是否是Lua AssetBundle脚本加载模式
    /// </summary>
    public static bool LuaAssetBundleMode = true;

    /// <summary>
    /// 是否是Resource AssetBundle脚本加载模式
    /// </summary>
    public static bool ResAssetBundleMode = false;

    public static bool LuaByteMode = false;                      //Lua字节码模式-默认关闭 

    /// <summary>
    /// Lua脚本存放的临时目录
    /// </summary>
    public const string LuaTempDir = "ToLua/temp/";

    //游戏Lua脚本文件
    public static string cusLuaDir = Application.dataPath + "/Lua/";
    //ToLua自带Lua目录
    public static string toluaLuaDir = Application.dataPath + "/ToLua/Lua/";

    /// <summary>
    /// 打包资源目录
    /// </summary>
    public static List<string> searchPath = new List<string>() {

        "ToLua/temp",
       // "Resources/View",
       // "Resources/Island/Pre",
       // "Resources/Scene/Pre",
    };

    /// <summary>
    /// 打包资源后缀
    /// </summary>
    public static List<string> packExt = new List<string> { ".png", ".jpg", ".prefab", ".unity", ".mat",
       ".fbx",  ".ttf", ".lua", ".bytes", ".shader",".mp3" ,".asset",".exr" ,".tga",".txt",".controller"};
}
