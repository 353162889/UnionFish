using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class PicMoveHelper : MonoBehaviour
{

    private UISprite us;
    private bool isInit = false;
    private int SpriteCount = 0;
    private int PlayCount = 1;
    private float Space = 0;
    private string TypeString = "";
    private bool isPlaying = false;
    private bool AutoPlay = false;
    private LuaFunction OnceDoLF = null;
    private LuaTable OnceDoLT = null;
    public float MaxSpace = 0.05f;
    // Use this for initialization
    void Start()
    {
        if (!isInit)
        {
            Init();
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (SpriteCount > 0)
        {
            if (isPlaying)
            {
                if (Space < MaxSpace)
                {
                    Space += Time.deltaTime;
                }
                else
                {
                    Space -= MaxSpace;
                    if (PlayCount < SpriteCount)
                    {
                        PlayCount++;
                        us.spriteName = TypeString + "_" + PlayCount;
                    }
                    else
                    {
                        PlayCount = 1;
                        Space = 0;
                        us.spriteName = TypeString + "_" + PlayCount;
                        isPlaying = AutoPlay;
                        if(OnceDoLF != null)
                        {
                            OnceDoLF.Call(OnceDoLT);
                        }
                    }
                }
            }
        }
    }

    public void SetAutoPlay(bool b)
    {
        if (!isInit)
        {
            Init();
        }
        AutoPlay = b;
        if (AutoPlay)
        {
            PlaySprite();
        }
    }
    public void SetOncePlay(LuaFunction lf,LuaTable lt)
    {
        OnceDoLF = lf;
        OnceDoLT = lt;
        SetAutoPlay(true);
    }

    public void PlaySprite()
    {
        PlayCount = 1;
        Space = 0;
        us.spriteName = TypeString + "_" + PlayCount;
        isPlaying = true;
    }

    public void Init()
    {
        isInit = true;
        us = gameObject.GetComponent<UISprite>();
        TypeString = us.spriteName.Split('_')[0];
        if (SpriteCount == 0)
        {
            for (int i = 0; i < us.atlas.spriteList.Count; i++)
            {
                if (us.atlas.spriteList[i].name.Split('_')[0] == TypeString)
                {
                    SpriteCount++;
                }
            }
        }
    }
}
