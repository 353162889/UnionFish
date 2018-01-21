using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using LuaInterface;

public class BulletHelper : MonoBehaviour
{
    protected static int RayIndex = 0;
    private int Mask = LayerMask.GetMask("Fish","CameraFish","Scene");
    private int SceneLayer = LayerMask.NameToLayer("Scene");
    public GameObject RayGo;
    private Transform[] _arrayRayGo;
    private Ray _ray;

    public bool IsSelf;                 //是否是玩家自己
    public int RoleObjId;               //玩家对象id
    public int BulletObjId;             //子弹id
    public double BirthTimestamp;        //出生时间戳
    public int DefineId;                //子弹定义ID
    public int Type;                    //子弹类别
    public int Index;                   //子弹在子弹个数中的索引
    public int ReboundNum;              //子弹反弹次数
    public float LifeTime;              //子弹的生命时长
    public float PenetrateNum;          //子弹的穿透次数
    public float PenetrateSpace;        //子弹的穿透间隔
    public int GunFace;                 //记录炮台朝向
    public float Speed;                 //子弹的速度
    public float AccSpeed;              //子弹的加速度
    public float AccTime;               //子弹的加速时长
    public float WidthSpeed;            //子弹的宽度变化
    public float WidthTime;             //子弹的宽度变化时长
    public float HeightSpeed;           //子弹的高度变化
    public float HeightTime;            //子弹的高度变化时长
    public float AddX;                  //子弹的附加X
    public float AddXTime;              //附加X时长
    public float AddY;                  //附加Y
    public float AddYTime;              //附加Y时长
    public float AddTurn;               //附加转向
    public float AddTurnTime;           //附加转向时长
    public float AddSpeed;              //附加速度
    public float AddSpeedTime;          //附加速度时长
    public float LifeOver;              //生命结束后续
    public float HitOver;               //命中后续

    public float MinUpdateTime;         //最小更新间隔

    public float MaxRayDistance;        //射线最大距离

    private List<int> _listHitFish = new List<int>();           //已受击鱼列表
    private List<float> _listHitSpace = new List<float>();      //已受击鱼的时间间隔
    private Vector3 _tempPosition;
    private Vector3 _tempAngle;
    private Vector3 _tempScale;

    private double _targetTimestamp;     //当前目标时间戳
    private double _curTimestamp;        //当前运行的时间戳
    private double _startTimestamp;      //开始运行的时间戳
    private float _spaceTime;           //运行间隔时间
    private float _curSpaceTime;        //已运行的时间间隔

    private bool _isDestroy = false;
    private int _curRayCount = 0;
    private bool _evenRay = false;

    public void Reset()
    {
        _listHitFish.Clear();
        _listHitSpace.Clear();
        _curRayCount = 0;
        _arrayRayGo = null;
    }

    void Update()
    {
        if(_curSpaceTime < _spaceTime)
        {
            float deltaTime = Time.deltaTime;
            if(_curTimestamp < _targetTimestamp)
            {
                bool updateDestroy = false;
                float moveTime = (float)(_targetTimestamp - _startTimestamp) * (deltaTime / _spaceTime);
                InitTemp();
                //做位移操作
                float curMoveTime = 0f;
                float curMoveDeltaTime = moveTime;
                if (curMoveDeltaTime > deltaTime)
                {
                    curMoveDeltaTime = deltaTime;
                }
                //暂时不允许出现误差，这里会导致每次走多一点（就是前后端延时很大的时候，这里会多走一点，导致会有卡顿）
                while (curMoveTime < moveTime)
                {
                    float nextMoveTime = curMoveTime + curMoveDeltaTime;
                    //最后一次使用的更新间隔可能略大，保证刚好在MoveTime时间内完成更新
                    if (nextMoveTime >= moveTime)
                    {
                        curMoveDeltaTime = moveTime - curMoveTime;
                    }
                    updateDestroy = UpdateTime(curMoveDeltaTime);
                    if(updateDestroy) break;
                    curMoveTime += curMoveDeltaTime;
                }
                if(!updateDestroy)
                {
                    SetTemp();
                }

                //更新射线(只检测自己的子弹)
                if (!_isDestroy && !updateDestroy)
                {
                    //关闭单帧检测
                    //bool even = Time.frameCount % 2 == 0;
                    //if ((_evenRay && even) || (!_evenRay && !even))
                    //{ 
                        UpdateRay();
                    //}
                }
                _curTimestamp += curMoveTime;
            }
            _curSpaceTime += deltaTime;
        }
    }

    private void InitTemp()
    {
        _tempPosition = gameObject.transform.localPosition;
        _tempAngle = gameObject.transform.localEulerAngles;
        _tempScale = gameObject.transform.localScale;
    }

    private void SetTemp()
    {
        if (_isDestroy) return;
        gameObject.transform.localPosition = _tempPosition;
        gameObject.transform.localEulerAngles = _tempAngle;
        gameObject.transform.localScale = _tempScale;
    }

    void Destroy()
    {
        _isDestroy = true;
        _curRayCount = 0;
        _arrayRayGo = null;
    }

    public void Init()
    {
        _targetTimestamp = 0;
        _startTimestamp = 0;
        _curTimestamp = BirthTimestamp;
        _spaceTime = 0;
        _curSpaceTime = 0;
        _curRayCount = 0;
        BulletHelper.RayIndex++;
        if (BulletHelper.RayIndex > 1000000) BulletHelper.RayIndex = 0;
        _evenRay = BulletHelper.RayIndex % 2 == 0;
    }

    /// <summary>
    /// 设置目标时间戳
    /// </summary>
    /// <param name="targetTimestamp">需要运行</param>
    /// <param name="spaceTime">从currentTimeStamp到targetTimestamp需要运行的时间</param>
    public void SetTargetTimestamp(double targetTimestamp,float spaceTime)
    {
        _startTimestamp = _curTimestamp;
        _targetTimestamp = targetTimestamp;
        _spaceTime = spaceTime;
        _curSpaceTime = 0;
        //Debug.Log("spaceTimestamp:"+(targetTimestamp - _startTimestamp)+",target:"+targetTimestamp + ",start:"+_startTimestamp);
        if(_spaceTime == 0)
        {
            //如果时间大于生命周期，直接调用生命结束接口
            if(_targetTimestamp - BirthTimestamp > LifeTime)
            {
                LuaMgr.instance.CallFunction("BulletMgr.OnLifeTimeOver", BulletObjId);
                return;
            }
            InitTemp();
            while(_curTimestamp < _targetTimestamp)
            {
                if (UpdateTime(MinUpdateTime)) break;
                _curTimestamp += MinUpdateTime;
            }
            SetTemp();
        }
    }

    private bool UpdateTime(float dt)
    {
        LifeTime -= dt;
        if (LifeTime <= 0)
        {
            //生命结束接口
            LuaMgr.instance.CallFunction("BulletMgr.OnLifeTimeOver", BulletObjId);
            Reset();
            return true;
        }
        if (AccSpeed != 0 && AccTime > 0)
        {
            AccTime -= dt;
            Speed += (AccSpeed * dt);
        }
        if (WidthSpeed != 0 && WidthTime > 0)
        {
            WidthTime -= dt;
            _tempScale += new Vector3(WidthSpeed * dt, 0, 0);
        }
        if (HeightSpeed != 0 && HeightTime > 0)
        {
            HeightTime -= dt;
            _tempScale += new Vector3(0, HeightSpeed * dt, 0);
        }
        if (AddTurn != 0 && AddTurnTime > 0)
        {
            AddTurnTime -= dt;
            _tempAngle += new Vector3(0, 0, AddTurn * dt);
        }
        float f = _tempAngle.z / 360 * 2 * Mathf.PI;
        float s = Speed * dt;
        if (AddSpeed != 0 && AddSpeedTime > 0)
        {
            AddSpeedTime -= dt;
            s = (Speed + AddSpeed) * dt;
        }
        _tempPosition -= new Vector3(s * Mathf.Sin(f), (-1) * s * Mathf.Cos(f), 0);

        #region bullet Rebound
        float f_z = (_tempAngle.z + 1440) % 360;
        bool b_1 = _tempPosition.x < (-1) * Drive.refWidth / 2;
        bool b_2 = _tempPosition.x > (1) * Drive.refWidth / 2;
        bool b_3 = _tempPosition.y < (-1) * Drive.refHeight / 2;
        bool b_4 = _tempPosition.y > (1) * Drive.refHeight / 2;
        if (ReboundNum > 0)
        {
            if (b_1 && (f_z > 0 && f_z < 180))
            {
                SetEulerAngles(new Vector3(0, 0, 360 - f_z));
            }
            else if (b_2 && (f_z > 180 && f_z < 360))
            {
                SetEulerAngles(new Vector3(0, 0, 360 - f_z));
            }

            if (b_3 && (f_z > 90 && f_z < 270))
            {
                if (f_z < 180)
                {
                    SetEulerAngles(new Vector3(0, 0, 180 - f_z));
                }
                else if (f_z > 180)
                {
                    SetEulerAngles(new Vector3(0, 0, 540 - f_z));
                }
            }
            else if (b_4 && !(f_z > 90 && f_z < 270))
            {
                if (f_z < 180)
                {
                    SetEulerAngles(new Vector3(0, 0, 180 - f_z));
                }
                else if (f_z > 180)
                {
                    SetEulerAngles(new Vector3(0, 0, 540 - f_z));
                }
            }
        }
        else
        {
            if (b_1 || b_2 || b_3 || b_4)
            {
                //子弹反弹结束接口
                LuaMgr.instance.CallFunction("BulletMgr.OnReboundOver", BulletObjId);
                Reset();
                return true;
            }
        }
        #endregion

        for (int i = _listHitFish.Count - 1; i >= 0; i--)
        {
            _listHitSpace[i] -= dt;
            if (_listHitSpace[i] <= 0)
            {
                _listHitSpace.RemoveAt(i);
                _listHitFish.RemoveAt(i);
            }
        }

        return false;
    }

    private void SetEulerAngles(Vector3 v3)
    {
        _tempAngle = v3;
        ReboundNum -= 1;
    }

    private void UpdateRay()
    {
        if (RayGo == null) return;
        if(_arrayRayGo == null)
        {
            int count = RayGo.transform.FindChild("RayBox").childCount;
            _arrayRayGo = new Transform[count];
            for (int i = 0; i < count; i++)
            {
                _arrayRayGo[i] = RayGo.transform.FindChild("RayBox").GetChild(i);
            }
        }
        int RayCount = _arrayRayGo.Length;

        RaycastHit[] hits;
        if(_curRayCount < _arrayRayGo.Length)
        { 
       // for (int i = 0; i < RayCount; i++)
       // {
            Vector3 v = LH.GetMainUICamera().WorldToScreenPoint(_arrayRayGo[_curRayCount].position);
            _ray = Camera.main.ScreenPointToRay(v);
            RaycastHit hit;
            if(Physics.Raycast(_ray, out hit, MaxRayDistance, Mask))
            {
                if(hit.collider.gameObject.layer == SceneLayer)
                {
                    return;
                }
                GameObject go = hit.collider.gameObject;
                MonoData monoData = GetFishMonoData(go);
                if (monoData == null)
                {
                    //LH.LogError("Fish can not find MonoData!go.name=" + go.name);
                    return;
                }
                LuaTable lt = monoData.data as LuaTable;
                int fishObjId = Convert.ToInt32(lt["fish_obj_id"]);
                if (!_listHitFish.Contains(fishObjId))
                {
                    PenetrateNum--;
                    _listHitFish.Add(fishObjId);
                    _listHitSpace.Add(PenetrateSpace);
                    //命中回调
                    LuaMgr.instance.CallFunction("BulletMgr.OnHitFish", BulletObjId, fishObjId);
                    if (PenetrateNum <= 0)
                    {
                        Reset();
                        return;
                    }
                }
            }
            //hits = Physics.RaycastAll(_ray, MaxRayDistance, Mask);
            //if(hits != null && hits.Length > 0)
            //{ 
            //    for (int j = 0; j < hits.Length; j++)
            //    {
            //        GameObject go = hits[j].collider.gameObject;
            //        MonoData monoData = GetFishMonoData(go);
            //        if(monoData == null)
            //        {
            //            LH.LogError("Fish can not find MonoData!go.name="+go.name);
            //            return;
            //        }
            //        LuaTable lt = monoData.data as LuaTable;
            //        int fishObjId = Convert.ToInt32(lt["fish_obj_id"]);
            //        if (!_listHitFish.Contains(fishObjId))
            //        {
            //            PenetrateNum--;
            //            _listHitFish.Add(fishObjId);
            //            _listHitSpace.Add(PenetrateSpace);
            //            //命中回调
            //            LuaMgr.instance.CallFunction("BulletMgr.OnHitFish", BulletObjId, fishObjId);
            //            if (PenetrateNum <= 0)
            //            {
            //                Reset();
            //                return;
            //            }
            //        }
            //    }
            //}
            // }
        }
        if (_curRayCount < RayCount - 1)
        {
            _curRayCount++;
        }
        else
        {
            _curRayCount = 0;
        }
    }

    private MonoData GetFishMonoData(GameObject go)
    {
        MonoData data = go.GetComponent<MonoData>();
        if(data == null && go.transform.parent != null)
        {
            return GetFishMonoData(go.transform.parent.gameObject);
        }
        return data;
    }
}