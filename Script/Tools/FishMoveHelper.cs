using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class FishMoveHelper : MonoBehaviour
{
    public Vector3 targetPos = Vector2.zero;
    public Quaternion targetRotate = Quaternion.identity;
    public float moveSpeed = 0;
    public float rotateSpeed = 0;
    public float offset = 1;

    void Update()
    {
        float angle = Quaternion.Angle(transform.localRotation, targetRotate);
        float supprotSpeed = angle / 360 * moveSpeed * offset;
        Vector3 supportOffset = transform.forward * supprotSpeed *Time.deltaTime;//全局坐标偏移
        Vector3 nextPos = Vector3.MoveTowards(transform.localPosition, targetPos, moveSpeed * Time.deltaTime);
        transform.localPosition = nextPos;
        transform.position += supportOffset;
        Quaternion quaternion = Quaternion.RotateTowards(transform.localRotation, targetRotate, rotateSpeed * Time.deltaTime);
        transform.localRotation = quaternion;
    }

}
