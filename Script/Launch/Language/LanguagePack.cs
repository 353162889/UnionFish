using UnityEngine;
using System.Collections.Generic;

namespace Launch
{
	public class LanguagePack
	{
		protected Dictionary<string,string> _strings = new Dictionary<string, string>();

		public void AddString(string key,string value)
		{
			if(!_strings.ContainsKey(key))
			{
				_strings.Add(key,value);
			}
			else
			{
				//CLogger.LogWarn("LanguagePack.AddString().Duplicated value for key:"+key);
			}
		}

		public void RemoveString(string key)
		{
			if(_strings.ContainsKey(key))
			{
				_strings.Remove(key);
			}
		}

		public string GetString(string key)
		{
			if(_strings.ContainsKey(key))
			{
				return _strings[key];
			}
            else
            {
                LH.LogError("language can not find key:" + key);
            }
            return key;
		}

		public void Dump()
		{
			foreach(var pair in _strings)
			{
				Debug.Log(pair.Key+"="+pair.Value);
			}
		}
	}
}
