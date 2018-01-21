using UnityEngine;
using System.Collections.Generic;
using System.Xml;
using System.Text;
using System.IO;
using System;

public class FileVersionData
{
    public uint crc { get; set; }
    public int size { get; set; }
}

public class StorageVersionData
{
    public int PkgVersionCode { get; set; }
    public long HotVersionCode { get; set; }
    public string ShowVersion { get; set; }

	private Dictionary<string,FileVersionData> _fileVersions;

	public Dictionary<string,FileVersionData> fileVersions
	{
		get { return _fileVersions;}
	}

	public StorageVersionData()
	{
        Reset();
	}

	public void SetFileVersion(string file,FileVersionData versionData)
	{
		if (_fileVersions.ContainsKey (file))
		{
			_fileVersions[file] = versionData;
		}
		else
		{
			_fileVersions.Add (file, versionData);
		}

	}

	public FileVersionData GetFileVersion(string file)
	{
		FileVersionData version;
		_fileVersions.TryGetValue(file,out version);
		return version;
	}

	public void ParseVersionData(string versionXml)
	{
        XmlDocument xmlDoc = new XmlDocument();
        xmlDoc.LoadXml(versionXml);
        ShowVersion = xmlDoc.DocumentElement.GetAttribute("showVersion");
        string pkgVersionCodeStr = xmlDoc.DocumentElement.GetAttribute("pkgVersion");
        string hotVersionCodeStr = xmlDoc.DocumentElement.GetAttribute("hotVersion");

        if (string.IsNullOrEmpty(pkgVersionCodeStr))
        {
            LH.LogError("pkgVersionCode is null!");
        }
        else
        {
            PkgVersionCode = int.Parse(pkgVersionCodeStr);
        }

        if(string.IsNullOrEmpty(hotVersionCodeStr))
        {
            LH.LogError("hotVersionCode is null!");
        }
        else
        {
            HotVersionCode = long.Parse(hotVersionCodeStr);
        }

		if(xmlDoc.DocumentElement.ChildNodes == null || xmlDoc.DocumentElement.ChildNodes.Count == 0)
			return;

        foreach (XmlNode node in xmlDoc.DocumentElement.ChildNodes)
        {
            XmlElement element = (XmlElement)node;
            string file = element.GetAttribute("path");
            uint crc = uint.Parse(element.GetAttribute("crc"));
            int size = int.Parse(element.GetAttribute("size"));
            FileVersionData data = new FileVersionData();
            data.crc = crc;
            data.size = size;
            _fileVersions.Add(file, data);
        }
	}

	public void WriteToFile(string fileName)
	{
        XmlDocument document = new XmlDocument();
        XmlElement root = document.CreateElement("root");
        root.SetAttribute("showVersion", this.ShowVersion.ToString());
        root.SetAttribute("pkgVersion", this.PkgVersionCode.ToString());
        root.SetAttribute("hotVersion", this.HotVersionCode.ToString());
        document.AppendChild(root);

        XmlElement file = null;
        foreach (var item in _fileVersions)
        {
            file = document.CreateElement("file");
            file.SetAttribute("path", item.Key);
            file.SetAttribute("crc", item.Value.crc.ToString());
            file.SetAttribute("size", item.Value.size.ToString());
            root.AppendChild(file);
        }
        document.ToString();

        XmlWriterSettings setting = new XmlWriterSettings();
        setting.Indent = true;
        setting.OmitXmlDeclaration = true;
        setting.Encoding = Encoding.ASCII;

        string dir = Path.GetDirectoryName(fileName);
        if (!Directory.Exists(dir))
        {
            Directory.CreateDirectory(dir);
        }

        XmlWriter write = XmlWriter.Create(fileName, setting);
        document.Save(write);
        write.Flush();
        write.Close();
        
    }

	public void Reset()
	{
        this.ShowVersion = null;
        this.PkgVersionCode = 0;
        this.HotVersionCode = 0;
		_fileVersions = new Dictionary<string, FileVersionData>();
	}


	public void Clear()
	{
		_fileVersions.Clear();
		_fileVersions = null;
	}
}
