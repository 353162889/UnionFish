using UnityEngine;
using System.Collections;

public class CameraMove : MonoBehaviour
{
    public GameObject LookAtGo;
    public GameObject CameraGo;
    // Use this for initialization
    void Start()
    {
    }

    private Vector3 toP;
    private Vector3 toD;
    private float speed;
    public void SetGoTo(Vector3 V_p,Vector3 V_d)
    {
        if(toP == null || toD == null)
        {
            CameraGo.transform.parent.localPosition = V_p;
            CameraGo.transform.parent.localEulerAngles = V_d;
        }
        toP = V_p;
        toD = V_d;
        //LH.LogError(toP.ToString() + " " + toD.ToString());
        LookAtGo.transform.localPosition = V_p;
        LookAtGo.transform.localEulerAngles = V_d;
        LookAtGo.transform.localPosition = LookAtGo.transform.forward * 10;
        speed = Vector3.Distance(CameraGo.transform.parent.localPosition, toP) / 1.5f;
    }
    // Update is called once per frame
    void Update()
    {
        if (toP == null || toD == null) { return; }
        Vector3 p_1 = toP;
        Vector3 p_2 = CameraGo.transform.parent.localPosition;
        Vector3 p_3 = LookAtGo.transform.localPosition;
        Vector3 p_4 = CameraGo.transform.localPosition;
        float f_1 = Vector3.Distance(p_2, p_1); //¾àÀë
        if (f_1 >= 0.1)
        {
            CameraGo.transform.parent.localPosition = p_2 + Time.deltaTime * speed * (p_1 - p_2).normalized;
        }

        LookAtTarget(p_3 - p_4, CameraGo.transform, 0.5f * Time.deltaTime);
    }

    void LookAtTarget(Vector3 direction, Transform transform, float rotationSpeed)
    {
        if (direction == Vector3.zero) return;
        Quaternion targetRotation = Quaternion.LookRotation(direction, Vector3.up);
        transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, rotationSpeed);
    }
}
