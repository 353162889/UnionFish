using System;
using UnityEngine;
using UnityEngine.UI;

namespace Launch
{
    public class UIProgress : MonoBehaviour
    {
        public event Action<float> OnProgressChange;
        protected UISprite _image;
        protected float _percent;
        protected float _totalValue;
        [SerializeField]
        private ProgressMode _progressMode = ProgressMode.Horizontal;

        private bool hasInit;
        protected virtual void Awake()
        {
            if (hasInit)
                return;
            hasInit = true;

            _image = gameObject.GetComponent<UISprite>();
            _percent = -1;
            SetProgressMode(_progressMode);
        }

        public virtual void Init()
        {
            Awake();
        }

        public void SetProgressMode(UIProgress.ProgressMode mode)
        {
            _progressMode = mode;
            if (_progressMode == ProgressMode.Horizontal)
            {
                _totalValue = _image.width;
            }
            else
            {
                _totalValue = _image.height;
            }
        }

        public void UpdateProgress(float percent)
        {
            if (_image == null) return;
            if (percent < 0) percent = 0f;
            else if (percent > 1) percent = 1f;

            if (_percent != percent)
            {
                _percent = percent;
                _image.gameObject.SetActive(_percent != 0);
                float changeValue = GetPercent() * _totalValue;
                
                if (_progressMode == ProgressMode.Horizontal)
                {
                    _image.width = (int)changeValue;
                }
                else
                {
                    _image.height = (int)changeValue;
                }
                ChangeProcess(_percent);
            }
        }

        public virtual float GetPercent()
        {
            return _percent;
        }

        protected void ChangeProcess(float value)
        {
            if (OnProgressChange != null)
            {
                OnProgressChange(value);
            }
        }

        protected bool IsFullProgress()
        {
            return _percent == 1f;
        }

        public enum ProgressMode
        {
            Horizontal,
            Vertical
        }
    }
}

