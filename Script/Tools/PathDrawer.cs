/********************************************************************************
** Auth： 黎建斌
** Date： 2016-10-25 11:25
** Desc： 路径描绘
** Ver ： V1.0.0
*********************************************************************************/

#if UNITY_EDITOR

using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

namespace GameEditor
{
    [ExecuteInEditMode]
    public class PathDrawer : MonoBehaviour
    {

        #region 字段
        public bool isVisible = true;
        public Color drawColor = Color.red;
        public Transform[] pathObjs;
        public Vector3[] paths;

        #endregion


        #region 生命周期

        void Awake()
        {
            paths = new Vector3[transform.childCount];
        }


        void Update()
        {
            //paths = new List<Vector3>(pathObjs.Length);
            paths = new Vector3[transform.childCount];
            pathObjs = new Transform[transform.childCount];
            for (int i = 0; i < transform.childCount; i++)
            {
                if (!transform.GetChild(i).gameObject.activeInHierarchy) continue;
                pathObjs[i] = transform.GetChild(i);
            }
            for (int i = 0; i < transform.childCount; i++)
            {
                if (!transform.GetChild(i).gameObject.activeInHierarchy) continue;
                paths[i] = transform.GetChild(i).position;
            }
        }


        void OnDrawGizmos()
        {
            if (!isVisible || !gameObject.activeInHierarchy || paths.Length < 2) return;
            PathHelper.DrawPath(paths, drawColor);
        }
        #endregion

    }

}

#endif
