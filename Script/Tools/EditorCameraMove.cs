using UnityEngine;
using System.Collections;

public class EditorCameraMove : MonoBehaviour
{
    public SceneHelper sceneHelper;
    public GameObject LookAtGo;
    public GameObject CameraGo;
    public int index = 0;
    // Use this for initialization
    void Start()
    {
        if (sceneHelper.MovePointList != null && sceneHelper.MovePointList.Count > 1)
        {
            index = 0;
            //MovePointList[index].go.transform.localScale = Vector3.one * 2;
            CameraGo.transform.parent.localPosition = sceneHelper.MovePointList[index].go.transform.localPosition;
            Vector3 v = sceneHelper.MovePointList[index].go.transform.forward * 10;
            LookAtGo.transform.localPosition = v;
            Vector3 p_3 = LookAtGo.transform.localPosition;
            Vector3 p_4 = CameraGo.transform.localPosition;
            LookAtTarget(p_3 - p_4, CameraGo.transform, 1000);
        }
        else
        {
            index = -1;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (index == -1) { return; }
        Vector3 p_1 = sceneHelper.MovePointList[index].go.transform.localPosition;
        Vector3 p_2 = CameraGo.transform.parent.localPosition;
        Vector3 p_3 = LookAtGo.transform.localPosition;
        Vector3 p_4 = CameraGo.transform.localPosition;
        float f_1 = Vector3.Distance(p_2, p_1); //¾àÀë
        if (f_1 < 0.1)
        {
            index++;
            if (index >= sceneHelper.MovePointList.Count)
            {
                index = 0;
            }
            Vector3 v = sceneHelper.MovePointList[index].go.transform.forward * 10;
            LookAtGo.transform.localPosition = v;
        }
        CameraGo.transform.parent.localPosition = p_2 + RealTime.deltaTime * sceneHelper.MovePointList[index].speed * (p_1 - p_2).normalized;


        LookAtTarget(p_3 - p_4, CameraGo.transform, sceneHelper.MovePointList[index].rotate * Time.deltaTime);
    }

    void LookAtTarget(Vector3 direction, Transform transform, float rotationSpeed)
    {
        if (direction == Vector3.zero) return;
        Quaternion targetRotation = Quaternion.LookRotation(direction, Vector3.up);
        transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, rotationSpeed);
    }
}
