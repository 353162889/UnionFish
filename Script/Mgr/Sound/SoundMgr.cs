using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;

public class SoundMgr
{
    public static List<string> soundCall = new List<string>();
    public static int counter;
    private static GameObject _audioListenerObj;
    private static GameObject _audioChannelObj;

    public static bool localRes = true;
    public static bool enableSound = true;
    static int _totalCount;
    static int _totalUICount;
    public const float defaultVol = 1.0f;
    public const int AUDIO_CHANNEL_MUSIC = 0;   //m
    public const int AUDIO_CHANNEL_FX = 1;      //e
    public const int UI_CHANNEL_FX = 2;         //u
    public static int MAX_CHANNEL_COUNT = 16;
    public static int MAX_UI_COUNT = 5;
    private static List<AudioChannel> _soundFxList = new List<AudioChannel>();
    private static List<AudioChannel> _soundUIList = new List<AudioChannel>();
    private static AudioChannel _music;

    public static Transform followTarget;

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

    public static void update()
    {
        clearSoundCall();
        if (followTarget != null)
        {
            AudioListenerObj.transform.position = followTarget.position;
        }
    }

    private static void clearSoundCall()
    {
        counter++;
        if (counter > 10)
        {
            counter = 0;
            soundCall.Clear();
        }
    }

    public static void setMusicVol(float value)
    {
        if (_music != null)
        {
            _music.setVolume(value);
        }
    } 

    public static void PlaySoundById(int id, int channel = UI_CHANNEL_FX, GameObject source = null)
    {
        //TplSound data = CTplSound.GetTpl(id);
        //doPlaySound(data.sound_name, data.loop == 1, channel, source, "sound_effect/");
        object[] data = LuaMgr.instance.CallFunction("GetSoundData", id);
        LuaDictTable ldt = (data[0] as LuaTable).ToDictTable();
        doPlaySound((string)ldt["name"], (int)(double)ldt["loop"] == 1, channel, source, "");
    }

    public static void StopAll()
    {
        if(_music != null)
        {
            _music.stop();
        }
        for (int i = 0; i < _soundFxList.Count; i++)
        {
            _soundFxList[i].stop();
        }
        for (int i = 0; i < _soundUIList.Count; i++)
        {
            _soundUIList[i].stop();

        }
    }


    public static vp_Timer.Handle SoundHandle = new vp_Timer.Handle();

    public static void doPlaySound(string clipName, bool isLoop, int channelType = AUDIO_CHANNEL_MUSIC, GameObject audioSourceObj = null, string path = "")
    {
        if (!enableSound)
        {
            return;
        }

        if (channelType == AUDIO_CHANNEL_FX)
        {
            if (soundCall.Contains(clipName))
            {
                //return;
            }
            else
            {
                soundCall.Add(clipName);
            }
        }


        AudioChannel ch = getChannel(channelType, audioSourceObj);

        if (ch == null)
        {
            Debug.Log("No more sound channel!");
            return;
        }

        ch.play(path + clipName, isLoop);
    }

   
    private static AudioChannel getChannel(int channelType, GameObject audioSourceObj)
    {
        AudioChannel channel = null;
        string chName = string.Empty;
        if (channelType == AUDIO_CHANNEL_MUSIC)
        {
            chName = "music";
            if (_music == null)
            {
                _music = new AudioChannel(chName, channelType);
            }
            channel = _music;
        }
        else if (channelType == AUDIO_CHANNEL_FX)
        {
            chName = "sound_fx";
            //查找存在的声道
            int count = _soundFxList.Count;
            for (int i = count - 1; i >= 0; i--)
            {
                AudioChannel ch = _soundFxList[i];
                if (ch.isAvailable)
                {
                    channel = ch;
                    break;
                }
            }

            if (channel == null)
            {
                if (_totalCount < MAX_CHANNEL_COUNT)
                {
                    _totalCount++;
                    channel = new AudioChannel(chName + _totalCount, channelType);
                    _soundFxList.Add(channel);
                }
                else
                {
                    channel = _soundFxList[0];
                }
            }

            if (channel != null)
            {
                //channel.setVolume(GameSetting.sound_fx_vol);
                channel.setVolume(defaultVol);
                if (audioSourceObj == null)
                {
                    channel.setPos(Vector3.zero);
                }
                else
                {
                    channel.setPos(audioSourceObj.transform.position);
                }

            }
        }
        else if (channelType == UI_CHANNEL_FX)
        {
            chName = "sound_ui";
            //查找存在的声道
            int count = _soundUIList.Count;
            for (int i = count - 1; i >= 0; i--)
            {
                AudioChannel ch = _soundUIList[i];
                if (ch.isAvailable)
                {
                    channel = ch;
                    break;
                }
            }
            if (channel == null)
            {
                if (_totalUICount < MAX_UI_COUNT)
                {
                    _totalUICount++;
                    channel = new AudioChannel(chName + _totalUICount, channelType);
                    _soundUIList.Add(channel);
                }
                else
                {
                    channel = _soundUIList[0];
                }
            }
            if (channel != null)
            {
                //channel.setVolume(GameSetting.sound_fx_vol);
                channel.setVolume(defaultVol);
            }
        }
        return channel;
    }
}


public class AudioChannel
{
    private AudioSource _audioSource;
    private bool _isLoading;

    //创建AudioSource
    public AudioChannel(string name, int type)
    {
        _audioSource = new GameObject(name).AddComponent<AudioSource>();
        if (type == SoundMgr.AUDIO_CHANNEL_MUSIC)
        {
            _audioSource.transform.parent = SoundMgr.AudioListenerObj.transform;
            _audioSource.transform.localPosition = Vector3.zero;
            //_audioSource.volume = GameSetting.sound_music_vol;
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
            //_audioSource.volume = GameSetting.sound_fx_vol;
            //_audioSource.volume = defaultVol;
        }
    }

    public void play(string clipName, bool isLoop)
    {
        _isLoading = true;

        ResourceMgr.Instance.GetResource("Sound/" + clipName, (Resource res) => {
            _isLoading = false;
            AudioClip ac = (AudioClip)res.GetAsset(null);
            playClip(clipName, isLoop, ac);
        }, null);
        //if (SoundMgr.localRes)
        //{
        //    _isLoading = false;
        //    AudioClip ac = Resources.Load<AudioClip>("Sound/" + clipName); //Resources
        //    if (ac != null)
        //    {
        //        playClip(clipName, isLoop, ac);
        //    }
        //}
        //else
        //{
        //    ResourceManager.instance.LoadAsset<AudioClip>(ResourceManager.SOUND_URL + clipName, (o, p) =>
        //    {
        //        _isLoading = false;
        //        playClip(clipName, isLoop, o);
        //    });
        //}
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
        if(_audioSource != null)
        {
            _audioSource.Stop();
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