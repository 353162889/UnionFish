/********************************************************************************
** Auth： 黎建斌
** Date： 2016-10-27 15:07
** Desc： 拓展方法+通用方法
** Ver ： V1.0.0
*********************************************************************************/

using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class Ext
{

    #region 通用字段
    public static System.Random MyR = new System.Random();
    #endregion
    public static Component AddComponentOnce(this GameObject obj,Type t)
    {
        Component comp =  obj.GetComponent(t);
        if(comp == null)
        {
            comp = obj.AddComponent(t);
        }
        return comp;
    }

    #region 拓展方法

    public static void AddChildToParent(this GameObject parent,GameObject child,bool stayWorldPos)
    {
        child.transform.SetParent(parent.transform, stayWorldPos);
        if(!stayWorldPos)
        {
            child.transform.localPosition = Vector3.zero;
            child.transform.localEulerAngles = Vector3.zero;
            child.transform.localScale = Vector3.one;
        }
    }
    //只对skinnedMeshRender有效
    public static void SetColor(this GameObject obj, Color color)
    {
        Renderer r = obj.GetComponentInChildren<SkinnedMeshRenderer>(false);
        if (r)
        {
            if (r.material)
                r.material.color = color;
            else
                Debug.LogError("物体下没有material");
        } 
        else
        {
            Debug.LogError("物体下没有Renderer");
        }
    }

    public static Color GetColor(this GameObject obj)
    {
        Renderer r = obj.GetComponentInChildren<SkinnedMeshRenderer>(false);
        if (r)
        {
            if (r.material)
                return r.material.color;
            else
                return Color.white;
        }
        else
        {
            return Color.white;
        }
    }

    public static bool HasColorInShader(this GameObject obj)
    {
        Renderer r = obj.GetComponentInChildren<SkinnedMeshRenderer>(false);
        if (r)
        {
            return r.material.HasProperty("_Color");
        }
        return false;
    }
    public static void SetColorInChildren(this GameObject obj, Color color)
    {
        Renderer[] rs = obj.GetComponentsInChildren<Renderer>(false);
        if (rs.Length > 0)
        {
            foreach (Renderer r in rs)
            {
                if (r.material)
                    r.material.color = color;
            }
        }
        else
        {
            Debug.LogError("物体下没有Renderer");
        }
    }
    public static void PlayAni(this GameObject obj, string aniName, string curAniName = null)
    {
        Animator animator = obj.GetComponent<Animator>();
        if (!animator)
        {
            Debug.LogError("物体没有Animator");
        }
        else
        {
            if (animator.GetCurrentAnimatorStateInfo(0).IsName(curAniName))
                return;
            if (!animator.enabled)
                animator.enabled = true;
            animator.CrossFade(aniName, 0, 0, 0);
        }
    }
    private static IEnumerator CheckAniEnd(Animator ani)
    {
        yield return new WaitForSeconds(0.1f);
        float length = ani.GetCurrentAnimatorStateInfo(0).length;
        yield return new WaitForSeconds(length - 0.2f);
    }

    //--------------------------------------------------------------Trans
    public static Transform[] GetChilds(this Transform trans)
    {
        Transform[] tmp = new Transform[trans.childCount];
        for (int i = 0; i < trans.childCount; i++)
        {
            tmp[i] = trans.GetChild(i);
        }
        return tmp;
    }

    public static GameObject[] GetChildsToGO(this Transform trans)
    {
        GameObject[] tmp = new GameObject[trans.childCount];
        for (int i = 0; i < trans.childCount; i++)
        {
            tmp[i] = trans.GetChild(i).gameObject;
        }
        return tmp;
    }

    public static string[] GetChildNames(this Transform trans)
    {
        string[] tmp = new string[trans.childCount];
        for (int i = 0; i < trans.childCount; i++)
        {
            tmp[i] = trans.GetChild(i).name;
        }
        return tmp;
    }

    public static Vector3[] GetVectorArrInChilds(this Transform trans)
    {
        Vector3[] tmp = new Vector3[trans.childCount];
        for (int i = 0; i < trans.childCount; i++)
        {
            tmp[i] = trans.GetChild(i).position;
        }
        return tmp;
    }

    public static List<Vector3> GetVectorListInChilds(this Transform trans)
    {
        List<Vector3> tmp = new List<Vector3>();
        for (int i = 0; i < trans.childCount; i++)
        {
            tmp.Add(trans.GetChild(i).position);
        }
        return tmp;
    }

    #endregion
    

    #region 通用方法
    public static Vector3[] GetVectors(params GameObject[] objs)
    {
        Vector3[] tmp = new Vector3[objs.Length];
        for (int i = 0; i < objs.Length; i++)
        {
            tmp[i] = objs[i].transform.position;
        }
        return tmp;
    }

    public static void DirExistsAndCreate(string directoryPath)
    {
        if (!Directory.Exists(directoryPath))
        {
            Directory.CreateDirectory(directoryPath);
        }
    }

    #endregion

    #region 通用结构

    #endregion


}
