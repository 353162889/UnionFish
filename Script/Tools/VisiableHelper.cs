using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class VisiableHelper : MonoBehaviour
{
    public bool isVisiable;

    private void OnBecameVisible()
    {
        isVisiable = true;
    }

    private void OnBecameInvisible()
    {
        isVisiable = false;
    }
}
