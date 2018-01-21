using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class SceneHelper : MonoBehaviour
{
    public Camera camera;
    [SerializeField]
    public List<MovePointHelper> MovePointList;

}

[System.Serializable]
public class MovePointHelper
{
    public GameObject go;
    public float speed;
    public float rotate;
    public string levelIdList;

	public static float GetMoveTime(MovePointHelper pos1, MovePointHelper pos2)
	{
		float ret = 0;
		if (pos1 != null && pos2 != null && pos1.go!=null && pos2.go!=null)
		{
			Vector3 p1 = pos1.go.transform.localPosition;
			Vector3 p2 = pos2.go.transform.localPosition;
			ret = (p2 - p1).magnitude / pos1.speed;

		}else
		{
			Debug.LogError("错误,存在空对象,请检查");
		}
		return ret;
	}

	public static float GetRotateTime(MovePointHelper pos1, MovePointHelper pos2)
	{
		float ret = 0;
		if (pos1 != null )
		{
			ret = 6f / pos1.rotate;
            float t2 = GetMoveTime(pos1, pos2);
            ret = (t2 > ret ? ret : t2);
        }
		else
		{
			Debug.LogError("错误,存在空对象,请检查");
		}
		return ret;
	}
}
