using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class LaunchPreload : Singleton<LaunchPreload>
    {
        private static string LuaAssetBundleFile = "luacode/luacode.assetbundle";
        private static string ResourceLuaFiles = "LuaCode/LuaCodes.bytes";
        private Resource _luaBundleRes;
        private MultiResourceLoader _luaResourceResLoader;
        private Action<bool> _luaAction;
        private Action<float> _onProgress;
        private int _totalLuaFiles;
        private int _curLuaFiles;

        public void PreloadLua(Action<bool> callback,Action<float> onProgress = null)
        {
            if (ResourceMgr.Instance.ResourcesLoadMode)
            {
                //Editor下直接运行游戏
                if (Application.isEditor)
                {
                    callback.Invoke(true);
                }
                //resource包的时候，预加载所有的lua文件
                else
                {
                    _luaAction = callback;
                    _onProgress = onProgress;
                    ResourceMgr.Instance.GetResource(ResourceLuaFiles, OnLoadResourceLuaFiles, OnLoadResourceLuaFiles, ResourceType.Text);
                }
            }
            else
            {
                //预加载
                _luaAction = callback;
                _onProgress = onProgress;
                ResourceMgr.Instance.GetResource(LuaAssetBundleFile, OnLoadAssetBundle, OnLoadAssetBundle);
            }
        }

        private void OnLoadResourceLuaFiles(Resource res)
        {
            string text = res.GetText();
            string[] files = text.Split(',');
            if (files == null)
            {
                OnPreloadLuaFinish(false);
                return;
            }
            _luaResourceResLoader = new MultiResourceLoader();
            List<string> names = new List<string>();
            for (int i = 0; i < files.Length; i++)
            {
                names.Add(files[i]);
            }
            _totalLuaFiles = names.Count;
            _curLuaFiles = 0;
            _luaResourceResLoader.LoadList(names, OnLoadLuaFinish, OnProgress, ResourceType.Bytes);
        }
        private void OnLoadLuaFinish(MultiResourceLoader loader)
        {
            OnPreloadLuaFinish(true);
        }

        private void OnProgress(Resource res)
        {
            _curLuaFiles++;
            _curLuaFiles = Mathf.Min(_curLuaFiles,_totalLuaFiles);
            OnPreloadProgress(_curLuaFiles / (float)_totalLuaFiles);
        }

        private void OnLoadAssetBundle(Resource res)
        {
            OnPreloadProgress(1f);
            _luaBundleRes = res;
            _luaBundleRes.Retain();
            OnPreloadLuaFinish(true);
        }

        private void OnPreloadLuaFinish(bool succ)
        {
            if(_luaAction != null)
            {
                Action<bool> temp = _luaAction;
                _luaAction = null;
                temp.Invoke(succ);
            }
            _onProgress = null;
        }

        private void OnPreloadProgress(float progress)
        {
            if (_onProgress != null)
            {
                _onProgress.Invoke(progress);
            }
        }

        public void DisposeLuaRes()
        {
            if(_luaBundleRes != null)
            {
                _luaBundleRes.Release();
                _luaBundleRes = null;
            }
            if(_luaResourceResLoader != null)
            {
                _luaResourceResLoader.Clear();
                _luaResourceResLoader = null;
            }
        }
    }
}
