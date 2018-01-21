using UnityEngine;
using System.Collections;

namespace Launch
{ 
    public class LaunchHotUpdateView : SingletonMonoBehaviour<LaunchHotUpdateView> {
        private GameObject _go;
        private UISprite _sprite;
        private UIProgress _progress;
        private UILabel _label;
        private UILabel _desc;
	    public void Init(GameObject go)
        {
            _go = go;
            _sprite = go.transform.FindChild("BG/Line/Run").GetComponent<UISprite>();
            _progress = _sprite.gameObject.AddComponent<UIProgress>();
            _progress.Init();
            _progress.SetProgressMode(UIProgress.ProgressMode.Horizontal);
            _label = go.transform.FindChild("BG/Line/Label").GetComponent<UILabel>();
            _desc = go.transform.FindChild("BG/Line/LabelDesc").GetComponent<UILabel>();
        }

        public void UpdateProgress(float percent)
        {
            percent = Mathf.Max(0, percent);
            percent = Mathf.Min(1, percent);
            //_sprite.fillAmount = percent;
            _progress.UpdateProgress(percent);
            _label.text = Mathf.Ceil(100 * percent) + "%";
        }

        public float GetProgress()
        {
            return _progress.GetPercent();
        }

        public void UpdateDesc(string desc)
        {
            _desc.text = desc;
        }

        public void Show()
        {
            _go.SetActive(true);
        }

        public void Close(bool destroy)
        {
            _go.SetActive(false);
            if(destroy && _go != null)
            {
                GameObject.Destroy(_go);
                _go = null;
            }
        }
    }
}