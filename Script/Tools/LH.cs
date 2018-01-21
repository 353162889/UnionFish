using ArabicSupport;
using Launch;
using LuaInterface;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityStandardAssets.ImageEffects;

public class LH
{   
    public static System.Random R = new System.Random();

    #region 日志打印基础
    public static bool isDebug = true;
    public static LogRecorder logRecorder = new LogRecorder();
    public static LanguageRecorder languageRecorder = new LanguageRecorder();
    public static void Log(string s)
    {
        if (GameConfig.IsDebugInfo) { Debug.Log(s); logRecorder.Log(s); }
        
    }

    public static void Log(string msg, string color)
    {
        if (GameConfig.IsDebugInfo)
        {
            StringBuilder sb = new StringBuilder();
            if (string.IsNullOrEmpty(color))
            {
                sb.Append(msg.ToString());
            }
            else
            {
                sb.Append("<color=" + color + ">");
                sb.Append(msg.ToString());
                sb.Append("</color>");
            }

            Debug.Log(sb.ToString());
            logRecorder.Log(msg);
        }
    }

    public static void LogError(string s)
    {
        if (GameConfig.IsDebugError) { Debug.LogError(s);logRecorder.LogError(s); }
    }

    public static void LogWarn(string s)
    {
        if (GameConfig.IsDebugWarn) { Debug.LogWarning(s); logRecorder.LogWarn(s); }
    }

    public static void LogLanguage(string msg)
    {
        if (GameConfig.IsDebugInfo)
        {
            languageRecorder.Log(msg);
        }
    }

    #endregion

    #region 数据统计
    public static void SetStatisticUserId(string userId, string userName)
    {
        StatisticsMgr.Instance.SetUserId(userId, userName);
    }

    #endregion

    #region 面板深度控制

    public static GameObject Load(string path)
    {
        UnityEngine.Object obj = Resources.Load(path);
        if (obj == null)
        {
            LogError(path + "路径下的预设不存在");
            return null;
        }
        return UnityEngine.Object.Instantiate(obj) as GameObject;
    }

    public static void SetDataViewLayer(GameObject go, int index, int Lv)
    {
        List<UIPanel> list = go.GetComponentsInChildren<UIPanel>(true).ToList();
        list.Sort(CompareDepth);
        for (int i = 0; i < list.Count; i++)
        {
            list[i].depth = (Lv * 10000) + (index + 1) * 100 + (i + 1);
            list[i].renderQueue = UIPanel.RenderQueue.StartAt;
            list[i].startingRenderQueue = 3000 + (Lv * 1000) + (index + 1) * 100 + (i + 1) * 25;
           // list[i].startingRenderQueue = 3000 + 20*((Lv * 100) + (index + 1) * 50 + (i + 1));
        }
    }

    private static int CompareDepth(UIPanel a, UIPanel b)
    {
        return a.depth.CompareTo(b.depth);
    }

    public static void DestoryGameObject(GameObject gameObject)
    {
        UnityEngine.Object.Destroy(gameObject);
        Resources.UnloadUnusedAssets();
    }

    #endregion

    #region 按钮事件辅助
    private static Dictionary<string, LuaFunction> clickEvents = new Dictionary<string, LuaFunction>();

    public static void AddClickEvent(GameObject go, LuaFunction lf)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnClick";
        if (clickEvents.ContainsKey(key))
        {
            clickEvents[key] = lf;
        }
        else
        {
            clickEvents.Add(key, lf);
        }
        UIEventListener.Get(go).onClick = OnClickEvent;
    }
    private static void OnClickEvent(GameObject go)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnClick";
        if (clickEvents.ContainsKey(key))
        {
            if (clickEvents[key] != null)
            {
                clickEvents[key].Call(go);
            }
        }
    }

    public static void AddPressEvent(GameObject go, LuaFunction lf)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnPress";
        if (clickEvents.ContainsKey(key))
        {
            clickEvents[key] = lf;
        }
        else
        {
            clickEvents.Add(key, lf);
        }
        UIEventListener.Get(go).onPress = OnPressEvent;
    }
    private static void OnPressEvent(GameObject go, bool state)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnPress";
        if (clickEvents.ContainsKey(key))
        {
            if (clickEvents[key] != null)
            {
                clickEvents[key].Call(go, state);
            }
        }
    }

    public static void AddDragEvent(GameObject go, LuaFunction lf)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnDrag";
        if (clickEvents.ContainsKey(key))
        {
            clickEvents[key] = lf;
        }
        else
        {
            clickEvents.Add(key, lf);
        }
        UIEventListener.Get(go).onDrag = OnDragEvent;
    }
    private static void OnDragEvent(GameObject go, Vector2 delta)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnDrag";
        if (clickEvents.ContainsKey(key))
        {
            if (clickEvents[key] != null)
            {
                clickEvents[key].Call(go, delta);
            }
        }
    }

    public static void AddDragEndEvent(GameObject go, LuaFunction lf)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnDragEnd";
        if (clickEvents.ContainsKey(key))
        {
            clickEvents[key] = lf;
        }
        else
        {
            clickEvents.Add(key, lf);
        }
        UIEventListener.Get(go).onDragEnd = OnDragEndEvent;
    }
    private static void OnDragEndEvent(GameObject go)
    {
        int id = go.GetInstanceID();
        string key = id.ToString() + "_OnDragEnd";
        if (clickEvents.ContainsKey(key))
        {
            if (clickEvents[key] != null)
            {
                clickEvents[key].Call(go);
            }
        }
    }
    #endregion

    #region Tween

    public static void SetTweenPosition(TweenPosition tp, float _delay, float _duration, Vector3 f, Vector3 t)
    {
        if (tp == null)
        {
            LogError("SetTweenPosition中tp为空");
            return;
        }
        tp.delay = _delay;
        tp.duration = _duration;
        tp.from = f;
        tp.to = t;
        tp.ResetToBeginning();
        tp.PlayForward();
    }

    public static void SetTweenRotation(TweenRotation tr, float _delay, float _duration, Vector3 f, Vector3 t)
    {
        if (tr == null)
        {
            LogError("SetTweenRotation中tr为空");
            return;
        }
        tr.delay = _delay;
        tr.duration = _duration;
        tr.from = f;
        tr.to = t;
        tr.ResetToBeginning();
        tr.PlayForward();
    }
    public static void SetTweenScale(TweenScale ts, float _delay, float _duration, Vector3 f, Vector3 t)
    {
        if (ts == null)
        {
            LogError("SetTweenScale中ts为空");
            return;
        }
        ts.delay = _delay;
        ts.duration = _duration;
        ts.from = f;
        ts.to = t;
        ts.ResetToBeginning();
        ts.PlayForward();
    }
    public static void SetTweenAlpha(TweenAlpha ta, float _delay, float _duration, float f, float t)
    {
        if (ta == null)
        {
            LogError("SetTweenAlpha中ta为空");
            return;
        }
        ta.delay = _delay;
        ta.duration = _duration;
        ta.from = f;
        ta.to = t;
        ta.ResetToBeginning();
        ta.PlayForward();
    }

    public static void SetTweenPosition(TweenPosition tp, Vector3 from, Vector3 to, float duration, LuaFunction lf)
    {
        tp.from = from;
        tp.to = to;
        tp.duration = duration;
        tp.onFinished.Clear();
        tp.AddOnFinished(() =>
        {
            if (lf != null)
            {
                lf.Call(tp.gameObject);
            }
        });
        tp.ResetToBeginning();
        tp.PlayForward();
    }

    public static void SetTweenPositionInDelay(TweenPosition tp,Vector3 from,Vector3 to,float delay,float duration,LuaFunction lf)
    {
        tp.from = from;
        tp.to = to;
        tp.delay = delay;
        tp.duration = duration;
        tp.onFinished.Clear();
        tp.AddOnFinished(() =>
        {
            if (lf != null)
            {
                lf.Call(tp.gameObject);
            }
        });
        tp.ResetToBeginning();
        tp.PlayForward();
    }

    public static void SetTweenRotation(TweenRotation tr, Vector3 from, Vector3 to, float duration, LuaFunction lf)
    {
        tr.from = from;
        tr.to = to;
        tr.duration = duration;
        tr.onFinished.Clear();
        tr.AddOnFinished(() =>
        {
            if (lf != null)
            {
                lf.Call(tr.gameObject);
            }
        });
        tr.ResetToBeginning();
        tr.PlayForward();
    }

    public static void SetTweenScale(TweenScale ts, Vector3 from, Vector3 to,float delay, float duration, LuaFunction lf)
    {
        ts.from = from;
        ts.to = to;
        ts.delay = delay;
        ts.duration = duration;
        ts.onFinished.Clear();
        ts.AddOnFinished(() =>
        {
            if (lf != null)
            {
                lf.Call(ts.gameObject);
            }
        });
        ts.ResetToBeginning();
        ts.PlayForward();
    }

    #endregion



    public static GameObject GetGoBy (GameObject g, GameObject p)
    {
        GameObject temp = UnityEngine.Object.Instantiate(g);
        temp.transform.parent = p.transform;
        temp.transform.localPosition = Vector3.zero;
        temp.transform.localScale = Vector3.one;
        temp.transform.localEulerAngles = Vector3.zero;
        return temp;
    }

    public static vp_Timer.Handle UseVP(float daly, int times, float f, LuaFunction lf, LuaTable lt)
    {
        vp_Timer.Handle th = new vp_Timer.Handle();
        vp_Timer.In(daly, () => { if (lf != null) {
                lf.BeginPCall();
                lf.Push(lt);
                lf.PCall();
                lf.EndPCall();
                //lf.Call(lt);//这个会产生额外内存分配
            } }, times, f, th);
        return th;
    }

    public static int ScreenWidth()
    {
        GameObject uiRoot = GameObject.Find("UIRoot");
        UIRoot root = uiRoot.GetComponent<UIRoot>();
        return root.manualWidth;
    }
    public static int ScreenHeight()
    {
        GameObject uiRoot = GameObject.Find("UIRoot");
        UIRoot root = uiRoot.GetComponent<UIRoot>();
        return root.activeHeight;
    }
    public static GameObject GetRay(GameObject CameraGo)
    {
        Vector3 v3 = Input.mousePosition;// - new Vector3(Screen.width / 2, Screen.height / 2, 0);
        Ray _ray = CameraGo.GetComponent<Camera>().ScreenPointToRay(v3);
        RaycastHit hitInfo;
        if (Physics.Raycast(_ray, out hitInfo))
        {
            GameObject go = hitInfo.collider.gameObject;
            return go;
        }
        return null;
    }

    public static int Random(int min,int max)
    {
        return UnityEngine.Random.Range(min, max);
    }

    public static void Play(GameObject go, string name)
    {
        Animator a = go.GetComponent<Animator>();
        a.Play(name);
    }

    public static void SetCamera(Camera c, string s)
    {
        List<string> list = s.Split('_').ToList();
        if (list.Count == 1)
        {
            c.cullingMask = 1 << LayerMask.NameToLayer(list[0]);
        }
        else if (list.Count == 2)
        {
            c.cullingMask = 1 << LayerMask.NameToLayer(list[0]) | 1 << LayerMask.NameToLayer(list[1]);
        }
        else if (list.Count == 3)
        {
            c.cullingMask = 1 << LayerMask.NameToLayer(list[0]) | 1 << LayerMask.NameToLayer(list[1]) | 1 << LayerMask.NameToLayer(list[2]);
        }
    }

    public static void EnableCollider(GameObject go,bool enable)
    {
        Collider[] colliders = go.GetComponentsInChildren<Collider>();
        if(colliders != null)
        { 
            for (int i = 0; i < colliders.Length; i++)
            {
                colliders[i].enabled = enable;
            }
        }
    }


    public static Material CopyMaterial(Material mt)
    {
        return new Material(mt);
    }
    public static EffectHelper AddMissingEffectHelper(GameObject g)
    {
        return g.AddMissingComponent<EffectHelper>();
    }
    public static Camera GetMainUICamera()
    {
        return Drive.drive.transform.parent.FindChild("Camera").GetComponent<Camera>();
    }
    public static Camera GetMainCamera()
    {
        return Camera.main;
    }

    public static Vector3 WorldPosToUIPos(Vector3 pos)
    {
        Vector3 screenPos = GetMainCamera().WorldToScreenPoint(pos);
        screenPos.z = 0;
        return GetMainUICamera().ScreenToWorldPoint(screenPos);
    }

    public static void SetLayer(GameObject go,int layer)
    {
        go.layer = layer;
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            SetLayer(go.transform.GetChild(i).gameObject,layer);
        }
    }

    public static int FishCount = 0;
    public static void SetFishCount(int count)
    {
        FishCount = count;
    }

    public static int VisiableFishCount = 0;
    public static void SetVisiableFishCount(int count)
    {
        VisiableFishCount = count;
    }

    public static GameObject GetChildRender(GameObject go)
    {
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            Renderer render = child.GetComponent<Renderer>();
            if (render != null) return child;
        }
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            GameObject result = GetChildRender(child);
            if (result != null) return result;
        }
        return null;
    }

    public static void SetQueue(GameObject go,int queue)
    {
        Renderer renderer = go.GetComponent<Renderer>();
        if(renderer != null)
        { 
            renderer.material.renderQueue = queue;
        }
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            SetQueue(child, queue);
        }
    }

    public static void SetSortingLayer(GameObject go, string name)
    {
        Renderer renderer = go.GetComponent<Renderer>();
        if (renderer != null)
        {
            renderer.sortingLayerName = name;
        }
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            SetSortingLayer(child, name);
        }
    }

    public static void SetSortingOrder(GameObject go,int orderOffset)
    {
        UIDepth depth = go.GetComponent<UIDepth>();
        if(depth != null)
        {
            depth.order = orderOffset + depth.order;
            depth.UpdateOrder();
        }
        if(depth == null || depth.isChildUseOrder)
        {
            Renderer renderer = go.GetComponent<Renderer>();
            if (renderer != null)
            {
                renderer.sortingOrder = orderOffset + renderer.sortingOrder;
            }
            int count = go.transform.childCount;
            for (int i = 0; i < count; i++)
            {
                GameObject child = go.transform.GetChild(i).gameObject;
                SetSortingOrder(child, orderOffset);
            }
        }
    }

    public static void EnableBloomEffect(GameObject go,bool enable)
    {
        Bloom bloom = go.GetComponent<Bloom>();
        if (bloom != null)
        {
            bloom.enabled = enable;
        }
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            EnableBloomEffect(child, enable);
        }
    }

    public static bool RestrictWithinView(UIScrollView scrollView, Transform relativeTo,Transform child, bool instant,Vector3 posOffset)
    {
        Bounds childBounds = NGUIMath.CalculateRelativeWidgetBounds(relativeTo, child, false);
        Vector3 min = childBounds.min;
        Vector3 max = childBounds.max;
        Vector4 cr = scrollView.panel.finalClipRegion;

        float offsetX = cr.z * 0.5f;
        float offsetY = cr.w * 0.5f;

        Vector2 minRect = new Vector2(min.x, min.y);
        Vector2 maxRect = new Vector2(max.x, max.y);
        Vector2 minArea = new Vector2(cr.x - offsetX, cr.y - offsetY);
        Vector2 maxArea = new Vector2(cr.x + offsetX, cr.y + offsetY);

        if (scrollView.panel.clipping == UIDrawCall.Clipping.SoftClip)
        {
            minArea.x += scrollView.panel.clipSoftness.x;
            minArea.y += scrollView.panel.clipSoftness.y;
            maxArea.x -= scrollView.panel.clipSoftness.x;
            maxArea.y -= scrollView.panel.clipSoftness.y;
        }
        Vector3 constraint = NGUIMath.ConstrainRect(minRect, maxRect, minArea, maxArea);
        if (constraint.magnitude > 1f)
        {
            if (!instant && scrollView.dragEffect == UIScrollView.DragEffect.MomentumAndSpring)
            {
                // Spring back into place
                Vector3 pos = scrollView.transform.localPosition + constraint;
                pos.x = Mathf.Round(pos.x);
                pos.y = Mathf.Round(pos.y);
                SpringPanel sp = SpringPanel.Begin(scrollView.panel.gameObject, pos, 13f);
                sp.onFinished += () => {
                    scrollView.RestrictWithinBounds(instant);
                };
            }
            else
            {
                // Jump back into place
                scrollView.MoveRelative(constraint);
                scrollView.currentMomentum = Vector3.zero;
                scrollView.Scroll(0);
                scrollView.RestrictWithinBounds(instant);
            }
            return true;
        }
        return false;

    }

    public static string GetTimeFormat(int second)
    {
        TimeSpan ts = new TimeSpan(0, 0, second);
        int hours = ts.Hours;
        if(ts.Days > 0)
        {
            hours = ts.Days * 24 + hours;
        }
        return hours.ToString().PadLeft(2,'0') + ":" + ts.Minutes.ToString().PadLeft(2, '0') + ":" + ts.Seconds.ToString().PadLeft(2, '0');
    }

    public static float GetRadiusIn360(float angle)
    {
        float a = angle % 360;
        if (a < 0) a += 360;
        return a;
    }

    public static long GetDateTimeTicks()
    {
        return ServerTime.Now.Ticks;
    }

    public static long GetDayOffsetTimeTicks(int day)
    {
        return ServerTime.Now.AddDays(day).Ticks;
    }

    public static string GetDateTimeTicksToString()
    {
        return ServerTime.Now.Ticks.ToString();
    }

    public static GameObject GetChildByName(GameObject go,string name)
    {
        if (go.name == name) return go;
        int count = go.transform.childCount;
        for (int i = 0; i < count; i++)
        {
            GameObject child = go.transform.GetChild(i).gameObject;
            GameObject result = GetChildByName(child,name);
            if (result != null) return result;
        }
        return null;
    }

    public static void ShowConsoleLog(bool isShow)
    {
        var log = Drive.drive.GetComponent<ConsoleLogger>();
        if(log != null)
        {
            log.show = isShow;
        }
    }

    public static bool IsDebugMode()
    {
        return Debug.isDebugBuild;
    }

    public static string FixedArabic(string str)
    {
        return ArabicFixer.Fix(str);
    }

    public static string WrapText(string input)
    {
        string result;
        NGUIText.WrapText(input, out result);
        string[] s = result.Split('\n');
        return result;
    }

    public static string FixUighur(string line, int maxCharacters)
    {
        line = Reverse(line);
        var regex = new Regex(".{0," + maxCharacters + "}(\\s+|$)", RegexOptions.Multiline);
        line = regex.Replace(line, "$0\n");

        if (line.EndsWith("\n\n"))
            line = line.Substring(0, line.Length - 2);

        // Apply the RTL fix for each line
        var lines = line.Split('\n');
        for (int i = 0, imax = lines.Length; i < imax; ++i)
        {
            lines[i] = Reverse(lines[i]);
        }

        line = string.Join("\n", lines);

        return line;
    }

    public static string Reverse(string text)
    {
        char[] charArray = text.ToCharArray();
        Array.Reverse(charArray);
        return new string(charArray);
    }
}
