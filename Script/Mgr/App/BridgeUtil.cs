using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

public class BridgeUtil
{
    public static string dictionaryToString(Dictionary<string, string> maps)
    {
        StringBuilder param = new StringBuilder();
        if (null != maps)
        {
            foreach (KeyValuePair<string, string> kv in maps)
            {
                if (param.Length == 0)
                {
                    param.AppendFormat("{0}={1}", kv.Key, kv.Value);
                }
                else
                {
                    param.AppendFormat("&{0}={1}", kv.Key, kv.Value);
                }
            }
        }
        return param.ToString();
    }

    public static Dictionary<string, string> stringToDictionary(string message)
    {
        Dictionary<string, string> param = new Dictionary<string, string>();
        if (null != message)
        {
            if (message.Contains("&info="))
            {
                Regex regex = new Regex(@"code=(.*)&msg=([\s\S]*)&info=([\s\S]*)");
                string[] tokens = regex.Split(message);
                string code = tokens[1];
                string msg = tokens[2];
                string info = tokens[3];
                param.Add("code", code);
                param.Add("msg", msg);
                param.Add("info", info);
            }
            else
            {
                Regex regex = new Regex(@"code=(.*)&msg=([\s\S]*)");
                string[] tokens = regex.Split(message);
                string code = tokens[1];
                string msg = tokens[2];
                param.Add("code", code);
                param.Add("msg", msg);
            }
        }

        return param;
    }
}
