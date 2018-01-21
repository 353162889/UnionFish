using UnityEngine;
using System.Collections;

public class FPS : MonoBehaviour
{
    private UILabel lbl;
    float updateInterval = 0.5f;
    private float accum = 0.0f;
    private float frames = 0;
    private float timeleft;
    // Use this for initialization
    void Start()
    {
        lbl = gameObject.GetComponent<UILabel>();
        timeleft = updateInterval;
    }

    // Update is called once per frame
    void Update()
    {
        timeleft -= Time.deltaTime;
        accum += Time.timeScale / Time.deltaTime;
        ++frames;

        if (timeleft <= 0.0)
        {
            lbl.text = "FPS:" + (accum / frames).ToString("f2") +" 鱼总数量:" + LH.FishCount+",显示鱼数量:"+LH.VisiableFishCount;
            timeleft = updateInterval;
            accum = 0.0f;
            frames = 0;
        }
    }
}
