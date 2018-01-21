using UnityEngine;
using System.Collections;

public class GoMoveHelper : MonoBehaviour
{
    public GameObject ToGo;
    public GameObject Item;
    public float delayTime = 0;
    public float duration = 0;
    public Vector3 offset;
    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (ToGo != null)
        {
            transform.localPosition = ToGo.transform.localPosition + offset;
            if (delayTime > 0)
            {
                delayTime -= RealTime.deltaTime;
            }
            else if (delayTime < 0)
            {
                delayTime = 0;
                TweenPosition tp = Item.GetComponent<TweenPosition>();
                if (tp != null)
                {
                    tp.from = Item.transform.localPosition;
                    tp.to = Vector3.zero;
                    tp.delay = 0;
                    tp.duration = duration;
                    tp.ResetToBeginning();
                    tp.PlayForward();
                }
                TweenScale ts = Item.GetComponent<TweenScale>();
                if (ts != null)
                {
                    ts.from = Item.transform.localScale;
                    ts.to = Vector3.one*0.25f;
                    ts.delay = 0;
                    ts.duration = duration;
                    ts.ResetToBeginning();
                    ts.PlayForward();
                    //ts.onFinished.Clear();
                    //ts.AddOnFinished(() =>
                    //{
                    //    Item.transform.localScale = Vector3.zero;
                    //    ts.onFinished.Clear();
                    //});
                }
            }
        }
        else
        {
            gameObject.SetActive(false);
        }
    }
    public void SetEnd()
    {
        delayTime = -1;
    }
    public void SetGoTo(GameObject _ToGo, Vector3 _offset, float _duration, float _delayTime)
    {
        ToGo = _ToGo;
        duration = _duration;
        delayTime = _delayTime;
        offset = _offset;
        gameObject.SetActive(true);
    }
}
