using UnityEngine;
using System.Collections;

public class BallHelper : MonoBehaviour
{
    public GameObject _Camera;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (_Camera != null)
        {
            _Camera.transform.localEulerAngles = new Vector3((-1) * gameObject.transform.localPosition.y / 10, 0, (1) * gameObject.transform.localPosition.x / 20);
        }
    }
}
