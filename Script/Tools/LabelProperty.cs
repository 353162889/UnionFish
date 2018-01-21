using Launch;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[Serializable]
public class LabelLanagueProperty
{
    [SerializeField]
    public string languageCode;
    [SerializeField]
    public int fontSize = 0;
    [SerializeField]
    public int spacingX = 0;
    [SerializeField]
    public int spacingY= 0;
    [SerializeField]
    public int maxWidth = -1;
    [SerializeField]
    public int maxChars = -1;
}

[Serializable]
public class LabelProperty : MonoBehaviour
{
    public List<LabelLanagueProperty> values;
    private UILabel _label;
    private void Awake()
    {
        _label = GetComponent<UILabel>();
    }

    private void Start()
    {
        if (_label == null) return;
        if (string.IsNullOrEmpty(Language.CurLanguage)) return;
        if(values != null && values.Count > 0)
        {
            for (int i = 0; i < values.Count; i++)
            {
                if(values[i].languageCode == Language.CurLanguage)
                {
                    ChangeProperty(values[i]);
                    break;
                }
            }
        }
    }

    private void ChangeProperty(LabelLanagueProperty property)
    {
        if(property.fontSize > 0)
        { 
            _label.fontSize = property.fontSize;
        }
        if(property.spacingX >= 0)
        {
            _label.spacingX = property.spacingX;
        }
        if(property.spacingY >= 0)
        {
            _label.spacingY = property.spacingY;
        }
        if(property.maxWidth >= 0)
        {
            _label.overflowWidth = property.maxWidth;
        }
        if(property.maxWidth >= 0)
        {
            _label.MaxCharacters = property.maxChars;
        }
    }
}
