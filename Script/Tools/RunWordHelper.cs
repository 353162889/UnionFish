using UnityEngine;
using System.Collections;

public class RunWordHelper : MonoBehaviour
{
    public GameObject Box;
    public GameObject BG;
    public GameObject Label;
    public GameObject LabelBox;
    public float Speed = 200;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        gameObject.transform.localPosition -= new Vector3(Speed * Time.deltaTime, 0, 0);
        float _x = gameObject.transform.localPosition.x;
        float _w_1 = BG.GetComponent<UISprite>().width / 2;
        float _w_2 = Label.GetComponent<UILabel>().width;
        if (_x + _w_1 + _w_2 < 0)
        {
            gameObject.transform.parent = BG.transform;
            Label.GetComponent<UILabel>().text = "";
            if (LabelBox.transform.childCount == 0)
            {
                Box.SetActive(false);
            }
            gameObject.SetActive(false);
        }
    }
}
