using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class LaunchHotTipView : SingletonMonoBehaviour<LaunchHotTipView>
    {
        private GameObject _go;
        private UILabel _labelTitle;
        private UILabel _labelContent;
        private UILabel _labelTip;
        private GameObject _btnClose;
        private GameObject _btnCancel;
        private UILabel _labelCancel;
        private GameObject _btnConfirm;
        private UILabel _labelConfirm;
        private GameObject _btnCenter;
        private UILabel _labelCenter;
        private Action _cancelCallback;
        private Action _confirmCallback;
        private Action _closeCallback;
        private TweenScale _ts;

        public void Init(GameObject go)
        {
            _go = go;
            Transform ts = _go.transform;
            _labelTitle = ts.FindChild("LabelTitle").GetComponent<UILabel>();
            _labelContent = ts.FindChild("LabelContent").GetComponent<UILabel>();
            _labelTip = ts.FindChild("LabelTip").GetComponent<UILabel>();
            _btnClose = ts.FindChild("BtnClose").gameObject;
            UIEventListener.Get(_btnClose).onClick += OnClickClose;
            _btnCancel = ts.FindChild("BtnCancel").gameObject;
            _labelCancel = ts.FindChild("BtnCancel/Label").GetComponent<UILabel>();
            UIEventListener.Get(_btnCancel).onClick += OnClickCancel;
            _btnConfirm = ts.FindChild("BtnConfirm").gameObject;
            _labelConfirm = ts.FindChild("BtnConfirm/Label").GetComponent<UILabel>();
            UIEventListener.Get(_btnConfirm).onClick += OnClickConfirm;
            _btnCenter = ts.FindChild("BtnCenterConfirm").gameObject;
            _labelCenter = ts.FindChild("BtnCenterConfirm/Label").GetComponent<UILabel>();
            UIEventListener.Get(_btnCenter).onClick += OnClickConfirm;
            _ts = NGUITools.AddMissingComponent<TweenScale>(_go);
            _ts.animationCurve.keys = null;
            _ts.animationCurve.AddKey(0, 0.5f);
            _ts.animationCurve.AddKey(0.5f, 0f);
            _ts.animationCurve.AddKey(1, 1f);
            Close(false);
        }

        private void OnClickConfirm(GameObject go)
        {
            Action temp = this._confirmCallback;
            Close(false);
            if(temp != null)
            {
                temp();
            }
        }

        private void OnClickCancel(GameObject go)
        {
            Action temp = this._cancelCallback;
            Close(false);
            if (temp != null)
            {
                temp();
            }
        }

        private void OnClickClose(GameObject go)
        {
            Action temp = this._closeCallback;
            Close(false);
            if (temp != null)
            {
                temp();
            }
        }

        public void Open(string title,string content,string tips = null,string labelConfirm = null,string labelCancel = null, Action confirmCallback = null, Action cancelCallback = null,Action closeCallback = null)
        {
            this._cancelCallback = cancelCallback;
            this._confirmCallback = confirmCallback;
            this._closeCallback = closeCallback;
            this._labelTitle.text = title;
            this._labelContent.text = content;
            this._labelTip.text = tips;
            string configmTxt = Language.GetString("确 定");
            if(string.IsNullOrEmpty(labelConfirm))
            {
                configmTxt = labelConfirm;
            }
            this._labelConfirm.text = configmTxt;
            string cancelTxt = Language.GetString("取 消");
            if(string .IsNullOrEmpty(labelCancel))
            {
                cancelTxt = labelCancel;
            }
            this._labelCancel.text = cancelTxt;
            this._btnCenter.SetActive(false);
            this._btnClose.SetActive(true);
            this._btnCancel.SetActive(true);
            this._btnConfirm.SetActive(true);
            _go.SetActive(true);
            PlayTween();
        }

        public void OpenCenter(string title,string content,string tips = null, string labelConfirm = null, Action confirmCallback = null, Action closeCallback = null)
        {
            this._confirmCallback = confirmCallback;
            this._closeCallback = closeCallback;
            this._labelTitle.text = title;
            this._labelContent.text = content;
            this._labelTip.text = tips;
            string configmTxt = Language.GetString("确 定");
            if (string.IsNullOrEmpty(labelConfirm))
            {
                configmTxt = labelConfirm;
            }
            this._labelCenter.text = configmTxt;
            this._btnCenter.SetActive(true);
            this._btnClose.SetActive(true);
            this._btnCancel.SetActive(false);
            this._btnConfirm.SetActive(false);
            _go.SetActive(true);
            PlayTween();
        }

        private void PlayTween()
        {
            _ts.delay = 0;
            _ts.duration = 0.2f;
            _ts.from = new Vector3(0.8f,0.8f,0.8f);
            _ts.to = Vector3.one;
            _ts.ResetToBeginning();
            _ts.PlayForward();
        }

        public void Close(bool destroy)
        {
            _go.SetActive(false);
            _cancelCallback = null;
            _confirmCallback = null;
            _closeCallback = null;
            if (destroy && _go != null)
            {
                GameObject.Destroy(_go);
                _go = null;
            }
        }
    }
}
