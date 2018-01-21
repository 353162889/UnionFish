using System;
using UnityEngine;

public class BaseResLoader : MonoBehaviour
{
	public event Action<Resource> OnResourceDone;

	public virtual void Load(Resource res)
	{
	}

	protected void OnDone(Resource res)
	{
		if (OnResourceDone != null)
		{
			OnResourceDone.Invoke (res);
		}
	}

    protected virtual string GetInResPath(Resource res)
    {
        return "";
    }
}

