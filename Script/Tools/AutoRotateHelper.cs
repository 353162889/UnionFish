using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class AutoRotateHelper : MonoBehaviour
{
    private Vector3 rotateSpeed = new Vector3(0, 0, 0);
    public void SetRotateSpeed(float x,float y,float z)
    {
        rotateSpeed.x = x;
        rotateSpeed.y = y;
        rotateSpeed.z = z;
    }

    private void Update()
    {
        transform.Rotate(rotateSpeed.x * Time.deltaTime, rotateSpeed.y * Time.deltaTime, rotateSpeed.z * Time.deltaTime);
    }
}
