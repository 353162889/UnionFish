using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using UnityEngine;

namespace Launch
{
    //包内的游戏配置
    public class GameConfig
    {
        private static string GameSetting = "Launch/Config/GameConfig";
        public static bool IsResourceLoadMode { get; set; }
        public static bool IsHotUpdateMode { get; set; }
        public static bool IsDebugInfo { get; set; }
        public static bool IsDebugWarn { get; set; }
        public static bool IsDebugError { get; set; }
        public static string ServerUrl { get; set; }
        public static string PkgUpdateUrl { get; set; }
        public static string ShowVersion { get; set; }
        public static int PkgVersion { get; set; }
        public static string GameServer { get; set; }
        public static int GamePort { get; set; }
        public static bool IsUsedSDK  { get;set; }
        public static string LanguageCode { get; set; }
        public static string StatisticServerUrl { get; set; }
        public static bool StatisticServerOpen { get; set; }
        public static string PayForSelfUrl { get; set; }

        public static void Load()
        {
            TextAsset txt = Resources.Load<TextAsset>(GameSetting);
            string files = txt.text;
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(files);
            foreach (XmlNode node in xmlDoc.DocumentElement.ChildNodes)
            {
                XmlElement element = (XmlElement)node; 
                if (node.Name == "Resource")
                {
                    IsResourceLoadMode = element.GetAttribute("isResourcesLoadMode") == "true";
                }
                else if(node.Name == "HotUpdate")
                {
                    IsHotUpdateMode = element.GetAttribute("isHotUpdate") == "true";
                }
                else if (node.Name == "Debug")
                {
                    IsDebugInfo = element.GetAttribute("isDebugInfo") == "true";
                    IsDebugWarn = element.GetAttribute("isDebugWarn") == "true";
                    IsDebugError = element.GetAttribute("isDebugError") == "true";
                }
                else if (node.Name == "Server")
                {
                    ServerUrl = element.GetAttribute("url");
                    PkgUpdateUrl = element.GetAttribute("pkgUpdateUrl");
                }
                else if (node.Name == "Version")
                {
                    ShowVersion = element.GetAttribute("showVersion");
                    PkgVersion = int.Parse(element.GetAttribute("pkgVersion"));
                }
                else if(node.Name == "GameServer")
                {
                    GameServer = element.GetAttribute("server");
                    GamePort = int.Parse(element.GetAttribute("port"));
                }
                else if(node.Name == "SDK")
                {
                    IsUsedSDK = element.GetAttribute("isUsed") == "true";
                }
                else if(node.Name == "Language")
                {
                    LanguageCode = element.GetAttribute("code");
                }
                else if(node.Name == "StatisticServer")
                {
                    StatisticServerUrl = element.GetAttribute("url");
                    StatisticServerOpen = element.GetAttribute("isOpen") == "true";
                }
                else if(node.Name == "Pay")
                {
                    PayForSelfUrl = element.GetAttribute("payForSelfUrl");
                }
            }
        }

        public static void Save()
        {
            TextAsset txt = Resources.Load<TextAsset>(GameSetting);
            string files = txt.text;
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(files);
            foreach (XmlNode node in xmlDoc.DocumentElement.ChildNodes)
            {
                XmlElement element = (XmlElement)node;
                if (node.Name == "Resource")
                {
                    element.SetAttribute("isResourcesLoadMode", IsResourceLoadMode.ToString().ToLower());
                }
                else if (node.Name == "HotUpdate")
                {
                    element.SetAttribute("isHotUpdate", IsHotUpdateMode.ToString().ToLower());
                }
                else if (node.Name == "Debug")
                {
                    element.SetAttribute("isDebugInfo", IsDebugInfo.ToString().ToLower());
                    element.SetAttribute("isDebugWarn", IsDebugWarn.ToString().ToLower());
                    element.SetAttribute("isDebugError", IsDebugError.ToString().ToLower());
                }
                else if (node.Name == "Server")
                {
                    element.SetAttribute("url", ServerUrl);
                    element.SetAttribute("pkgUpdateUrl", PkgUpdateUrl);
                }
                else if (node.Name == "Version")
                {
                    element.SetAttribute("showVersion", ShowVersion);
                    element.SetAttribute("pkgVersion", PkgVersion.ToString());
                }
                else if(node.Name == "GameServer")
                {
                    element.SetAttribute("server", GameServer);
                    element.SetAttribute("port", GamePort.ToString());
                }
                else if (node.Name == "SDK")
                {
                    element.SetAttribute("isUsed",IsUsedSDK.ToString().ToLower());
                }
                else if(node.Name == "Language")
                {
                    element.SetAttribute("code",LanguageCode);
                }
                else if(node.Name == "StatisticServer")
                {
                    element.SetAttribute("url", StatisticServerUrl);
                    element.SetAttribute("isOpen", StatisticServerOpen.ToString().ToLower());
                }
                else if(node.Name == "Pay")
                {
                    element.SetAttribute("payForSelfUrl",PayForSelfUrl);
                }
            }
            XmlWriterSettings setting = new XmlWriterSettings();
            setting.Indent = true;
            setting.OmitXmlDeclaration = true;
            setting.Encoding = Encoding.ASCII;

            string path = Application.dataPath + "/Resources/" + GameSetting + ".xml";
            string dir = Path.GetDirectoryName(path);
            if (!Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }
            XmlWriter write = XmlWriter.Create(path, setting);
            xmlDoc.Save(write);
            write.Close();
        }
    }
}
