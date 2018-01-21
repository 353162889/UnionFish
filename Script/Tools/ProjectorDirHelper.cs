using UnityEngine;
using System.Collections;

public class ProjectorDirHelper : MonoBehaviour {

    private Projector _projector;
	// Use this for initialization
	void Start () {
        _projector = GetComponent<Projector>();
        _projector.material.SetVector("_ProjectorDir", transform.forward);
    }
	
	// Update is called once per frame
	void Update () {
        _projector.material.SetVector("_ProjectorDir",transform.forward);
        //每帧发射射线，检测距离

	}
}
