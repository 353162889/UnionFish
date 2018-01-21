using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Launch
{
    public class LanguageRecorder
    {
        private FileStream _file;
        private string _logFilePath;
        private BinaryWriter _fileWriter;

        public string LogFilePath
        {
            get
            {
                if (_logFilePath == null)
                {
                    if (Application.platform == RuntimePlatform.WindowsEditor || Application.platform == RuntimePlatform.WindowsPlayer
                        || Application.platform == RuntimePlatform.OSXPlayer || Application.platform == RuntimePlatform.OSXEditor)
                    {
                        _logFilePath = Application.dataPath + "/../language.log";
                    }
                    else
                    {
                        _logFilePath = Application.persistentDataPath + "/language.log";
                    }
                }
                return _logFilePath;
            }
        }

        public LanguageRecorder()
        {
            _file = new FileStream(LogFilePath,FileMode.Create);
            _fileWriter = new BinaryWriter(this._file);
        }

        ~LanguageRecorder()
        {
            if ((Application.platform == RuntimePlatform.WindowsPlayer) || (Application.platform == RuntimePlatform.WindowsEditor) ||
               (Application.platform == RuntimePlatform.OSXPlayer) || (Application.platform == RuntimePlatform.OSXEditor))
            {
                if (this._fileWriter != null)
                {
                    this._fileWriter.Close();
                    this._fileWriter = null;
                }
                if (this._file != null)
                {
                    this._file.Close();
                    this._file = null;
                }
            }
        }

        public void Log(object msg)
        {
            string str = (msg == null) ? "null" : msg.ToString();
            string[] formatStrs = new string[] { "[INFO：", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"), "]", str, "\r\n" };
            this._fileWriter.Write(string.Concat(formatStrs).ToCharArray());
            this._fileWriter.Flush();
        }
    }
}
