using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshRenderer))]
public class MultiMaterialOrder : MonoBehaviour
{

    // Use this for initialization
    void Awake()
    {
        var maters = GetComponent<MeshRenderer>().materials;
        for (var i = 0; i < maters.Length; i++)
        {
            maters[i].renderQueue = maters.Length - i;
        }
    }
}
