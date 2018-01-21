using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class UIDragDropItemHelper : UIDragDropItem
{
    private LuaFunction _dragStart;
    private LuaTable _dragStartLT;
    private LuaFunction _dragRelease;
    private LuaTable _dragReleaseLT;
    private LuaFunction _dragEnd;
    private LuaTable _dragEndLT;

    public void SetStartFunc(LuaFunction lf,LuaTable lt)
    {
        this._dragStart = lf;
        this._dragStartLT = lt;
    }

    public void SetReleaseFunc(LuaFunction lf, LuaTable lt)
    {
        this._dragRelease = lf;
        this._dragReleaseLT = lt;
    }

    public void SetEndFunc(LuaFunction lf, LuaTable lt)
    {
        this._dragEnd = lf;
        this._dragEndLT = lt;
    }

    public void CloneTo(UIDragDropItemHelper helper)
    {
        helper.SetStartFunc(_dragStart, _dragStartLT);
        helper.SetReleaseFunc(_dragRelease, _dragReleaseLT);
        helper.SetEndFunc(_dragEnd, _dragEndLT);
    }

    protected override void OnClone(GameObject original)
    {
        UIDragDropItemHelper helper = original.GetComponent<UIDragDropItemHelper>();
        helper.CloneTo(this);
        this.name = original.name;
    }

    protected override void OnDragDropStart()
    {
        if(this._dragStart != null)
        {
            this._dragStart.Call(this._dragStartLT,gameObject);
        }
        base.OnDragDropStart();
    }

    protected override void OnDragDropRelease(GameObject surface)
    {
        if (this._dragRelease != null)
        {
            this._dragRelease.Call(this._dragReleaseLT,gameObject,surface);
        }
        base.OnDragDropRelease(surface);
    }

    protected override void OnDragEnd()
    {
        if (this._dragEnd != null)
        {
            this._dragEnd.Call(this._dragEndLT,gameObject);
        }
        base.OnDragEnd();
    }

    private void OnDestroy()
    {
        if(_dragStart != null)
        {
            _dragStart = null;
        }
        if(_dragStartLT != null)
        {
            _dragStartLT = null;
        }

        if (_dragRelease != null)
        {
            _dragRelease = null;
        }
        if (_dragReleaseLT != null)
        {
            _dragReleaseLT = null;
        }

        if (_dragEnd != null)
        {
            _dragEnd = null;
        }
        if (_dragEndLT != null)
        {
            _dragEndLT = null;
        }

    }
}
