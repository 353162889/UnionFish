using LuaInterface;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class EffectHelper : MonoBehaviour
{
    public float Life = 0;
    public LuaFunction LF = null;
    public LuaTable LT = null;
    private void Update()
    {
        if (Life != -1)
        {
            Life -= Time.deltaTime;
            if (Life < 0)
            {
                Life = -1;
                gameObject.SetActive(false);
                if (LF != null)
                {
                    LF.Call(LT);
                }
            }
        }
    }
}
