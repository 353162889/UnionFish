using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class UIDepth : MonoBehaviour
{
    [SortingLayerAttribute]
    public string sortingLayer = "Default";
    public int order;
    public bool isChildUseOrder = true;
    void Start()
    {
        UpdateOrder();
    }

    public void UpdateOrder()
    {
        if (isChildUseOrder)
        {
            Renderer[] renders = GetComponentsInChildren<Renderer>();
            foreach (Renderer render in renders)
            {
                render.sortingLayerName = sortingLayer;
                render.sortingOrder = order;
            }
        }
        else
        {
            Renderer render = GetComponent<Renderer>();
            if (render != null)
            {
                render.sortingLayerName = sortingLayer;
                render.sortingOrder = order;
            }
        }
    }
}
