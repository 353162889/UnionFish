using UnityEngine;
using System.Collections;

public class UIRenderQueue : MonoBehaviour
{

    public UIPanel mPanel;

    public int queue = 1;

    public Renderer rend;
    public Material mt;
    public void SetQueue(int _queue)
    {
        queue = _queue;
        Update();
    }
    void Start()
    {
        rend = gameObject.GetComponent<Renderer>();
        mPanel = NGUITools.FindInParents<UIPanel>(gameObject);
        Update();
    }

    void Update()
    {
        if (rend != null && rend.sharedMaterial != null)
        {
            if (mPanel != null)
            {
                rend.sharedMaterial.renderQueue = mPanel.startingRenderQueue + queue;
            }
        }
    }

    void OnDestory()
    {
        if (mt != null)
        {
            Destroy(mt);
        }
    }
}
