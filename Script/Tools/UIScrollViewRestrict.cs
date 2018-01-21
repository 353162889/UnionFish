using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class UIScrollViewRestrict : MonoBehaviour
{
    private UIScrollView scroll;
    public Vector3 startPos;

    private void Awake()
    {
        scroll = gameObject.GetComponent<UIScrollView>();
        if (scroll != null)
        {
            startPos = scroll.transform.localPosition;
            scroll.onDragFinished += DragFinished;
            ResetToBegin();
        }
    }

    private void DragFinished()
    {
        if (scroll != null)
        {
            SpringPanel.Begin(scroll.gameObject, startPos, 8);
        }
    }

    public void ResetToBegin()
    {
        if(scroll != null)
        { 
            scroll.transform.localPosition = startPos;
        }
    }

}
