using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class TimeMgr : MonoBehaviour
{
    private static TimeMgr _instance;

    public static TimeMgr Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = Drive.drive.AddComponent<TimeMgr>();
            }
            return _instance;
        }
    }

    private float _scaleTimer;
    private bool _scaleLocker;
    private float _delay;
    private float _scaleValue;

    //时间戳
    private long timeStamp;
    private float timeStampTemp;

    public delegate void CallBack(params object[] data);
    private List<Timer> _timerList = new List<Timer>();

    public static void initMgr()
    {
        if (_instance == null)
        {
            _instance = Drive.drive.AddComponent<TimeMgr>();
        }
        //Client.Instance.beginHeartBeat();
    }


    void Update()
    {
        float deltaTime = Time.unscaledDeltaTime;

        timeStampTemp += deltaTime;
        timeStamp +=(int) timeStampTemp;
        timeStampTemp -= (int)timeStampTemp;

        Client.Instance.Update();
        //ActorInterpreter.update(deltaTime);

        //SoundFxManager.update();

        //TailProxy.updateProxy(deltaTime);

        for (int i = _timerList.Count - 1; i >= 0; i--)
        {
            Timer timer = _timerList[i];
            timer.Update(deltaTime);
        }
    }

    void LateUpdate()
    {
        float deltaTime = Time.unscaledDeltaTime;

        if (_delay > 0)
        {
            _delay -= deltaTime;
            if (_delay <= 0)
            {
                Time.timeScale = _scaleValue;
                _delay = 0;
            }
        }

        if (_scaleTimer > 0 && _delay <= 0)
        {
            _scaleTimer -= deltaTime;
            if (_scaleTimer <= 0)
            {
                Time.timeScale = 1;
                _scaleTimer = 0;
                _scaleLocker = false;
            }
        }
    }

    /// <summary>
    /// 设置服务端时间戳
    /// </summary>
    /// <param name="time"></param>
    public void SetTimeStamp(uint time)
    {
        timeStamp = time;
    }

    /// <summary>
    /// 获取服务器时间
    /// </summary>
    /// <returns></returns>
    public DateTime GetServerTime()
    {
        DateTime dtStart = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1));
        return dtStart.AddSeconds(timeStamp);
    }

    /// <summary>
    /// 比较时间戳
    /// </summary>
    /// <param name="time"></param>
    /// <returns>是否达到时间</returns>
    public bool CompareTime(uint time)
    {
        return time >= timeStamp;
    }

    public void setFrameRate(int rate)
    {
        Application.targetFrameRate = rate;
    }


    public void setTimeScale(float value, float time = 0, float delay = 0, bool isLock = false)
    {
        if (!_scaleLocker || isLock)
        {
            if (delay == 0)
            {
                Time.timeScale = value;
            }
            _scaleTimer = time;
            _scaleValue = value;
            _delay = delay;
            _scaleLocker = isLock;
        }
    }

    private IEnumerator delayCoroutine(float time, CallBack callback, params object[] datas)
    {
        yield return new WaitForSeconds(time);
        if (callback != null)
        {
            callback(datas);
        }
    }



    public void addTimer(Timer timer)
    {
        if (!_timerList.Contains(timer))
        {
            _timerList.Add(timer);
        }
    }

    public void removeTimer(Timer timer)
    {
        _timerList.Remove(timer);
    }


    public static Timer addTimerFunc(float delay, float interval, int repeatCount, CallBack func, CallBack complete, params object[] datas)
    {
        if (_instance == null)
        {
            return null;
        }
        Timer timer = new Timer(delay, interval, repeatCount, datas);
        if (func != null)
        {
            timer.OnTimer += func;
        }
        if (complete != null)
        {
            timer.OnTimerComplete += complete;
        }
        timer.Start();
        return timer;
    }

    public static void delayCall(float time, CallBack callback, object[] datas)
    {
        Instance.StartCoroutine(_instance.delayCoroutine(time, callback, datas));
    }

    public static Coroutine startCoroutine(IEnumerator routine)
    {
        return Instance.StartCoroutine(routine);
    }
    public static void stopCoroutine(Coroutine routine)
    {
        Instance.StopCoroutine(routine);
    }
}

public class Timer
{
    private float _timeElapsed = 0;
    private float _currentElapsed = 0;
    private float _delay;
    private float _interval;
    private int _repeatCount;
    private int _currentCount;

    private object[] _datas;

    public event TimeMgr.CallBack OnTimer;
    public event TimeMgr.CallBack OnTimerComplete;

    public Timer(float delay, float interval, int repeatCount, params object[] datas)
    {
        _datas = datas;
        _delay = delay;
        _interval = interval;
        _repeatCount = repeatCount;
        _currentElapsed = interval;
    }

    public void Start()
    {
        TimeMgr.Instance.addTimer(this);
    }

    public void Stop()
    {
        TimeMgr.Instance.removeTimer(this);
    }

    public void Reset()
    {
        Stop();
        _timeElapsed = 0;
        _currentCount = 0;
    }

    public void Update(float deltaTime)
    {
        _timeElapsed += deltaTime;
        if (_timeElapsed >= _delay)
        {
            _currentElapsed += deltaTime;
            while (_currentElapsed >= _interval)
            {
                _currentCount++;
                _currentElapsed -= _interval;
                if (OnTimer != null)
                {
                    OnTimer(_datas);
                }
                if (_repeatCount > 0 && _currentCount >= _repeatCount)
                {
                    Stop();
                    if (OnTimerComplete != null)
                    {
                        OnTimerComplete(_datas);
                    }
                    break;
                }
            }
        }
    }
}
