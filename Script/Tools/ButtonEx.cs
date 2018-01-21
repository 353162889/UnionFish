//----------------------------------------------
//            NGUI: Next-Gen UI kit
// Copyright © 2011-2016 Tasharen Entertainment
//----------------------------------------------

using System;
using UnityEngine;
using System.Linq;
using System.Collections.Generic;

/// <summary>
/// Simple example script of how a button can be colored when the mouse hovers over it or it gets pressed.
/// </summary>

[ExecuteInEditMode]
[AddComponentMenu("NGUI/Interaction/_ButtonEx")]
public class ButtonEx : MonoBehaviour
{
    static public ButtonEx current;
    public enum State
    {
        Normal,
        Hover,
        Pressed,
        Disabled,
    }
    public GameObject tweenTarget;

    public bool CanUse = true;
    public bool isUseColorState = true;
    public bool isUseSizeState = true;
    public int SizeStateType = 1;
    public int SoundId = 1;
    public float ButtonCD = 0;
    private float _ButtonCD = 0;
    private UISprite _gameObjectUISP = null;
    public void SetButtonCD()
    {
        if (ButtonCD != 0)
        {
            _ButtonCD = ButtonCD;
            SetBtnExEnble(gameObject, false);
            UISprite uis = gameObject.GetComponent<UISprite>();
            if (_gameObjectUISP == null && uis != null)
            {
                GameObject _g = new GameObject();
                _g.transform.parent = gameObject.transform;
                _g.transform.localPosition = Vector3.zero;
                _g.transform.localScale = Vector3.one;
                _gameObjectUISP = _g.AddMissingComponent<UISprite>();
                _gameObjectUISP.atlas = uis.atlas;
                _gameObjectUISP.spriteName = uis.spriteName;
                //_gameObjectUISP.spriteName = "";
                _gameObjectUISP.width = uis.width;
                _gameObjectUISP.height = uis.height;
                _gameObjectUISP.type = UIBasicSprite.Type.Filled;
                _gameObjectUISP.fillDirection = UIBasicSprite.FillDirection.Radial360;
                _gameObjectUISP.invert = true;
                _gameObjectUISP.depth = uis.depth + 1;
            }
            _gameObjectUISP.gameObject.SetActive(true);
        }
    }
    public static void SetBtnExEnble(GameObject g, bool b)
    {
        UISprite usp = g.GetComponent<UISprite>();
        BoxCollider bc = g.GetComponent<BoxCollider>();
        ButtonEx be = g.GetComponent<ButtonEx>();
        if (usp != null && bc != null && be != null)
        {
            if (b)
            {
                usp.color = Color.white;
                bc.enabled = true;
                be.ResetWhiteColor(true);
            }
            else
            {
                usp.color = Color.black;
                bc.enabled = false;
                be.ResetWhiteColor(false);
            }
        }
    }
    private void Update()
    {
        if (_ButtonCD > 0)
        {
            _ButtonCD -= Time.deltaTime;
            if (_gameObjectUISP != null && ButtonCD != 0)
            {
                _gameObjectUISP.fillAmount = 1 - (_ButtonCD / ButtonCD);
            }
            if (_ButtonCD <= 0)
            {
                _ButtonCD = 0;
                SetBtnExEnble(gameObject, true);
                _gameObjectUISP.gameObject.SetActive(false);
            }
        }
    }
    protected Color hover = new Color(225f / 255f, 200f / 255f, 150f / 255f, 1f);

    protected Color pressed = new Color(183f / 255f, 163f / 255f, 123f / 255f, 1f);

    protected Color disabledColor = Color.black;

    private float duration = 0.2f;

    [System.NonSerialized]
    protected Color mStartingColor;
    [System.NonSerialized]
    protected Color mDefaultColor;
    [System.NonSerialized]
    protected bool mInitDone = false;
    [System.NonSerialized]
    protected UIWidget mWidget;
    [System.NonSerialized]
    protected State mState = State.Normal;

    protected State state { get { return mState; } set { SetState(value, false); } }

    protected Color defaultColor
    {
        get
        {
#if UNITY_EDITOR
            if (!Application.isPlaying) return Color.white;
#endif
            if (!mInitDone) OnInit();
            return mDefaultColor;
        }
        set
        {
#if UNITY_EDITOR
            if (!Application.isPlaying) return;
#endif
            if (!mInitDone) OnInit();
            mDefaultColor = value;

            State st = mState;
            mState = State.Disabled;
            SetState(st, false);
        }
    }

    protected virtual bool isEnabled { get { return enabled; } set { enabled = value; } }


    public void ResetDefaultColor() { defaultColor = mStartingColor; }
    public void ResetWhiteColor(bool b) { CanUse = b; defaultColor = b ? Color.white : Color.black; mStartingColor = b ? Color.white : Color.black; }

    public void CacheDefaultColor() { if (!mInitDone) OnInit(); }

    void Start()
    {
        if (!mInitDone) OnInit();
        if (!isEnabled) SetState(State.Disabled, true);
    }

    protected virtual void OnInit()
    {
        mInitDone = true;
        if (tweenTarget == null && !Application.isPlaying) tweenTarget = gameObject;
        if (tweenTarget != null) mWidget = tweenTarget.GetComponent<UIWidget>();

        if (mWidget != null)
        {
            mDefaultColor = mWidget.color;
            mStartingColor = mDefaultColor;
        }
        else if (tweenTarget != null)
        {
#if UNITY_4_3 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7
    			Renderer ren = tweenTarget.renderer;
#else
            Renderer ren = tweenTarget.GetComponent<Renderer>();
#endif
            if (ren != null)
            {
                mDefaultColor = Application.isPlaying ? ren.material.color : ren.sharedMaterial.color;
                mStartingColor = mDefaultColor;
            }
            else
            {
#if UNITY_4_3 || UNITY_4_5 || UNITY_4_6 || UNITY_4_7
    				Light lt = tweenTarget.light;
#else
                Light lt = tweenTarget.GetComponent<Light>();
#endif
                if (lt != null)
                {
                    mDefaultColor = lt.color;
                    mStartingColor = mDefaultColor;
                }
                else
                {
                    tweenTarget = null;
                    mInitDone = false;
                }
            }
        }
        isUseColorState = false;//默认不使用颜色
    }

    protected virtual void OnEnable()
    {
#if UNITY_EDITOR
        if (!Application.isPlaying)
        {
            mInitDone = false;
            return;
        }
#endif
        if (mInitDone) OnHover(UICamera.IsHighlighted(gameObject));

        if (UICamera.currentTouch != null)
        {
            if (UICamera.currentTouch.pressed == gameObject) OnPress(true);
            else if (UICamera.currentTouch.current == gameObject) OnHover(true);
        }
    }

    protected virtual void OnDisable()
    {
#if UNITY_EDITOR
        if (!Application.isPlaying) return;
#endif
        if (mInitDone && mState != State.Normal)
        {
            SetState(State.Normal, true);

            if (tweenTarget != null)
            {
                TweenColor tc = tweenTarget.GetComponent<TweenColor>();

                if (tc != null)
                {
                    tc.value = mDefaultColor;
                    tc.enabled = false;
                }
            }
        }
    }

    protected virtual void OnHover(bool isOver)
    {
        if (isEnabled)
        {
            if (!mInitDone) OnInit();
            if (tweenTarget != null) SetState(isOver ? State.Hover : State.Normal, false);
        }
    }

    protected virtual void OnPress(bool isPressed)
    {
        if (isEnabled && UICamera.currentTouch != null)
        {
            if (!mInitDone) OnInit();

            if (tweenTarget != null)
            {
                if (isPressed)
                {
                    SetState(State.Pressed, false);
                }
                else if (UICamera.currentTouch.current == gameObject)
                {
                    if (UICamera.currentScheme == UICamera.ControlScheme.Controller)
                    {
                        SetState(State.Hover, false);
                    }
                    else if (UICamera.currentScheme == UICamera.ControlScheme.Mouse && UICamera.hoveredObject == gameObject)
                    {
                        SetState(State.Hover, false);
                    }
                    else
                    {
                        SetState(State.Normal, false);
                    }
                    if (SoundId != 0)
                    {
                        LuaMgr.instance.CallFunction("PlaySoundById", SoundId);
                    }
                }
                else
                {
                    SetState(State.Normal, false);
                }
            }
        }
    }

    protected virtual void OnDragOver()
    {
        if (isEnabled)
        {
            if (!mInitDone) OnInit();
            if (tweenTarget != null) SetState(State.Pressed, false);
        }
    }

    protected virtual void OnDragOut()
    {
        if (isEnabled)
        {
            if (!mInitDone) OnInit();
            if (tweenTarget != null) SetState(State.Normal, false);
        }
    }

    public virtual void SetState(State state, bool instant)
    {
        if (!mInitDone)
        {
            mInitDone = true;
            OnInit();
        }

        if (mState != state)
        {
            mState = state;
            UpdateColor(instant);
            UpdateSize(instant);
        }
    }

    private void UpdateSize(bool instant)
    {
        if (!isUseSizeState) { return; }
        TweenScale ts;

        if (tweenTarget != null)
        {
            Vector3 v_3 = new Vector3(1f, 1f, 1f);
            switch (SizeStateType)
            {
                case 1: v_3 = new Vector3(1.05f, 1.05f, 1.05f); break;
                case 2: v_3 = new Vector3(1f, 1f, 1f); break;
                case 3: v_3 = new Vector3(0.95f, 0.95f, 0.95f); break;
                default: v_3 = new Vector3(1f, 1f, 1f); break;
            }
            switch (mState)
            {
                //case State.Hover: return;
                case State.Pressed: ts = TweenScale.Begin(tweenTarget, duration, v_3); break;
                //case State.Disabled: return;
                default: ts = TweenScale.Begin(tweenTarget, duration, new Vector3(1f, 1f, 1f)); break;
            }

            if (instant && ts != null)
            {
                ts.value = ts.to;
                ts.enabled = false;
            }
        }
    }

    public void UpdateColor(bool instant)
    {
        if (!isUseColorState) { return; }
        TweenColor tc;

        if (tweenTarget != null)
        {
            switch (mState)
            {
                case State.Hover: tc = TweenColor.Begin(tweenTarget, duration, hover); break;
                case State.Pressed: tc = TweenColor.Begin(tweenTarget, duration, pressed); break;
                case State.Disabled: tc = TweenColor.Begin(tweenTarget, duration, disabledColor); break;
                default: tc = TweenColor.Begin(tweenTarget, duration, mDefaultColor); break;
            }

            if (instant && tc != null)
            {
                tc.value = tc.to;
                tc.enabled = false;
            }
        }
    }
}
