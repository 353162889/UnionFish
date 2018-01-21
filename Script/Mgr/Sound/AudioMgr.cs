using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class AudioMgr
{
    public static bool enableSound = true;
    public const float defaultVol = 1.0f;
    public const int AUDIO_CHANNEL_MUSIC = 0;   //m
    public const int AUDIO_CHANNEL_FX = 1;      //e
    public const int UI_CHANNEL_FX = 2;         //u

    private static GameObject _audioListenerObj;
    private static GameObject _audioChannelObj;

    private static Dictionary<int, List<AudioChannelSource>> _mapSoundFX = new Dictionary<int, List<AudioChannelSource>>();
    private static Dictionary<int, List<AudioChannelSource>> _mapSoundUI = new Dictionary<int, List<AudioChannelSource>>();
    private static AudioChannelSource _music;

    private static int DefaultMaxCount = 5;
    private static Dictionary<int, int> _mapMaxCount = new Dictionary<int, int>();

    public static GameObject AudioListenerObj
    {
        get
        {
            if (_audioListenerObj == null)
            {
                _audioListenerObj = new GameObject("AudioListen");
                _audioListenerObj.AddComponent<AudioListener>();
                GameObject.DontDestroyOnLoad(_audioListenerObj);
            }
            return _audioListenerObj;
        }
    }
    public static GameObject AudioChannelObj
    {
        get
        {
            if (_audioChannelObj == null)
            {
                _audioChannelObj = new GameObject("AudioChannels");
                _audioChannelObj.transform.position = Vector3.zero;
                GameObject.DontDestroyOnLoad(_audioChannelObj);
            }
            return _audioChannelObj;
        }
    }


    public static void AddKeyCount(int layer,int count)
    {
        if(_mapMaxCount.ContainsKey(layer))
        {
            _mapMaxCount[layer] = count;
        }
        else
        {
            _mapMaxCount.Add(layer, count);
        }
    }

    public static void setMusicVol(float value)
    {
        Debug.Log("setMusicVol");
        if (_music != null)
        {
            _music.setVolume(value);
        }
    }

    public static void PlaySoundByPath(string path,int channelType, bool isLoop,int layer)
    {
        if (!enableSound)
        {
            return;
        }

        AudioChannelSource ch = getChannel(channelType, layer);

        if (ch == null)
        {
            Debug.Log("No more sound channel!");
            return;
        }
        ch.play(path, isLoop);
    }

    public static void StopAll()
    {
        if (_music != null)
        {
            _music.stop();
        }
        foreach (var item in _mapSoundFX)
        {
            for (int i = 0; i < item.Value.Count; i++)
            {
                item.Value[i].stop();
            }
        }
        foreach (var item in _mapSoundUI)
        {
            for (int i = 0; i < item.Value.Count; i++)
            {
                item.Value[i].stop();
            }
        }
    }

    private static AudioChannelSource getChannel(int channelType,int layer)
    {
        AudioChannelSource channel = null;
        string chName = string.Empty;
        if (channelType == AUDIO_CHANNEL_MUSIC)
        {
            chName = "music";
            if (_music == null)
            {
                _music = new AudioChannelSource(chName, channelType);
            }
            channel = _music;
        }
        else if (channelType == AUDIO_CHANNEL_FX)
        {
            chName = "sound_fx";

            List<AudioChannelSource> list;
            _mapSoundFX.TryGetValue(layer, out list);
            if(list == null)
            {
                list = new List<AudioChannelSource>();
                _mapSoundFX.Add(layer, list);
            }
            for (int i = 0; i < list.Count; i++)
            {
                if(list[i].isAvailable)
                {
                    channel = list[i];
                    break;
                }
            }
            if(channel == null)
            {
                int count = DefaultMaxCount;
                if (_mapMaxCount.ContainsKey(layer))
                {
                    count = _mapMaxCount[layer];
                }
                if (list.Count < count)
                {
                    channel = new AudioChannelSource(chName, channelType);
                    list.Add(channel);
                }
                else
                {
                    channel = list[0];
                }
            }

            if (channel != null)
            {
                channel.setVolume(defaultVol);
                channel.setPos(Vector3.zero);
            }
        }
        else if (channelType == UI_CHANNEL_FX)
        {
            chName = "sound_ui";
            List<AudioChannelSource> list;
            _mapSoundUI.TryGetValue(layer, out list);
            if (list == null)
            {
                list = new List<AudioChannelSource>();
                _mapSoundUI.Add(layer, list);
            }
            for (int i = 0; i < list.Count; i++)
            {
                if (list[i].isAvailable)
                {
                    channel = list[i];
                    break;
                }
            }
            if (channel == null)
            {
                int count = DefaultMaxCount;
                if(_mapMaxCount.ContainsKey(layer))
                {
                    count = _mapMaxCount[layer];
                }
                if (list.Count < count)
                {
                    channel = new AudioChannelSource(chName, channelType);
                    list.Add(channel);
                }
                else
                {
                    channel = list[0];
                }
            }

            if (channel != null)
            {
                channel.setVolume(defaultVol);
                channel.setPos(Vector3.zero);
            }
        }
        return channel;
    }
}

public class AudioChannelSource
{
    private AudioSource _audioSource;
    private bool _isLoading;
    private bool _isPlay;

    public AudioChannelSource(string name, int type)
    {
        _audioSource = new GameObject(name).AddComponent<AudioSource>();
        if (type == SoundMgr.AUDIO_CHANNEL_MUSIC)
        {
            _audioSource.transform.parent = SoundMgr.AudioListenerObj.transform;
            _audioSource.transform.localPosition = Vector3.zero;
            _audioSource.volume = 1;
        }
        else if (type == SoundMgr.AUDIO_CHANNEL_FX)
        {
            _audioSource.transform.parent = SoundMgr.AudioChannelObj.transform;
            _audioSource.transform.localPosition = Vector3.zero;
            _audioSource.spatialBlend = 1;
            _audioSource.rolloffMode = AudioRolloffMode.Linear;
            _audioSource.maxDistance = 15f;
            _audioSource.minDistance = 1f;
        }
        else if (type == SoundMgr.UI_CHANNEL_FX)
        {
            _audioSource.transform.parent = SoundMgr.AudioListenerObj.transform;
            _audioSource.transform.localPosition = Vector3.zero;
        }
        _isPlay = false;
    }

    public void play(string clipName, bool isLoop)
    {
        _isLoading = true;
        _isPlay = true;
        ResourceMgr.Instance.GetResource(clipName, (Resource res) => {
            _isLoading = false;
            if(_isPlay)
            { 
                AudioClip ac = (AudioClip)res.GetAsset(clipName);
                playClip(clipName, isLoop, ac);
            }
        }, null);
    }

    private void playClip(string clipName, bool isLoop, AudioClip clip)
    {
        if (_audioSource == null)
        {
            Debug.Log("Can't find sound channel!");
        }
        else
        {
            _audioSource.clip = clip;
            _audioSource.loop = isLoop;
            _audioSource.playOnAwake = false;
            _audioSource.Play();
        }
    }

    public void stop()
    {
        _isPlay = false;
        if (_audioSource != null)
        {
            _audioSource.Stop();
            _audioSource.clip = null;
        }
    }


    public void setVolume(float value)
    {
        _audioSource.volume = value;
    }

    public void setPos(Vector3 pos)
    {
        _audioSource.transform.localPosition = pos;
    }

    public bool isAvailable
    {
        get
        {
            return !_isLoading && !_audioSource.isPlaying;
        }
    }

}
