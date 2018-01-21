using UnityEngine;
using System.Collections.Generic;
using System.IO;
using System;

namespace Launch
{
	public class Language 
	{
        private static string LanguageBasePath = "Launch/Config/";
        private static string LanguageName = "Language";
        private static LanguagePack curLanguagePack = new LanguagePack();
		public static string CurLanguage { get;set;}

        public static void Init(string languageCode)
        {
            if (languageCode == LanguageCode.zhCN) return;
            string path = LanguageBasePath + languageCode + "/" + LanguageName;
            TextAsset txt = Resources.Load<TextAsset>(path);
            if(txt != null)
            {
                CurLanguage = languageCode;
                SetLanguagePack(txt);
            }
            else
            {
                LH.LogError("can not find language file:"+path);
            }
        }

		public static void SetLanguagePack(TextAsset content)
		{
			using(StringReader f = new StringReader(content.text))
			{
				string line;
				while((line = f.ReadLine()) != null)
				{
					string[] arr = line.Split(new string[] { "=" }, System.StringSplitOptions.None);
					if(arr.Length == 2)
					{
						//curLanguagePack.AddString(arr[0].Trim(),arr[1].Trim());
						curLanguagePack.AddString(arr[0],arr[1]);
					}
				}	
			}
		}

		public static string GetString(string key)
		{
			key = key.Replace(@"\n","\n");
            string str;
            if (CurLanguage == LanguageCode.zhCN)
            {
                str = key;
            }
            else
            { 
			    str =  curLanguagePack.GetString(key);
            }
            return str;
		}

        public static string GetString(string key, params object[] list)
        {
            string str = GetString(key);
            return string.Format(str, list);
        }

        public static void Dump()
		{
			Debug.Log("Current Language Code:"+CurLanguage+",Content:");
			curLanguagePack.Dump();
		}
	}
}
