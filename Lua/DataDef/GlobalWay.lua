function PlaySound(id,source)
    local cfg = Res.audio[id]
    local path = "Sound/"..cfg.name
    local channel = cfg.channel
    local loop = cfg.loop == 1
    local layer = cfg.layer
    AudioMgr.PlaySoundByPath(path,channel,loop,layer)
end

function PlaySoundById(id)
    PlaySound(id,nil)
end

function StopAllSound()
    AudioMgr.StopAll()
end

function EverMoveP(go,p)
    LH.SetTweenPosition(go:GetComponent("TweenPosition"),0,1.1,go.transform.localPosition,p)
end
function EverMoveD(go,d)
    LH.SetTweenRotation(go:GetComponent("TweenRotation"),0,1.1,go.transform.localEulerAngles,d)
end

function CheckCode(code)
    if code == 0 then
        return true
    else
        local str = Res.code_def[code].explain
        HelpCtrl.Msg(str)
        return false
    end
end

function GetParentPanel(go)
    local panel = go:GetComponent("UIPanel")
    if(panel == nil) then
        if(go.transform.parent ~= nil) then
            return GetParentPanel(go.transform.parent.gameObject)
        end
        return nil
    else
        return panel
    end
end

function GetParentPanelRenderQueue(go)
    local panel = GetParentPanel(go)
    if(panel ~= nil)then
        return panel.startingRenderQueue
    end
    return 0
end

function LB(label,key,...)
    local str = L(key,...)
    LFix(label,str)
end

function LFix(label,str)
    if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
        label.alignment = NGUIText.Alignment.Right
        if(label.MaxCharacters > 0) then
            str = LH.FixUighur(str,label.MaxCharacters)
        end
    end
    label.text = str
end

function L(key,...)
    local succ,str = LuaLanguage.GetString(key)
    if(not succ) then
        --将找不到的key值写入到文件中
        if(LH.IsDebugMode()) then
            LogError("#ff0000","找不到language表中的key值:",key)
            LH.LogLanguage(key)
        end
    end
    --替换动态文本
    str = ReplaceStrParam(str,...)
    --替换颜色
    str = ReplaceStrColor(str)
    -- return "000000"
    --如果是特殊文字，需要特殊转换
    str = SpecialLanguageHandle(str)
    return str
end

function SpecialLanguageHandle(str)
    -- if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
    --     str = ReverseStr(str,'|')
    -- end
    return str
end

function ReverseStr(str,char)
    local list = string.split(str,char)
    if(#list == 0) then return str end
    local temp = ""
    for i= #list,1,-1 do
        if(i == 1) then
            temp = temp .. list[i]
        else
            temp = temp .. list[i] .. '\n'
        end
    end
    return temp
end

function ReplaceStrParam(str,...)
    local count = select('#',...)
    for i=1,count do
        local temp = string.format("{%d}",i)
        _, index = string.find(str,temp)
        if(index ~= nil and index > 0) then
            local param = select(i,...)
            str = string.gsub(str,temp,param)
        end
    end
    return str
end

function ReplaceStrColor(str)
    -- if(LuaLanguage.languagePack.languageCode == LuaLanguageCode.uiG) then
    --     str = string.gsub(str,"(%[%x+%])","")
    --     str = string.gsub(str,"(%[C_%d+%])","")
    --     str = string.gsub(str,"[%[%-%]]","")
    --     return str
    -- end
    --将所有的[C_id]替换成[颜色值]
    local result = string.gsub(str,"(%[C_%d+%])",function (s)
        --获取到[C_id]将C_id替换成颜色值
        local id = string.sub(s,string.find(s,"%d+"))
        local color = Res.color[tonumber(id)]
        if(color == nil) then
            return s
        end
        return color.c
     end)
    return result
end

function GetNumberDesc(number)
    if(number >= 10000) then
        local result = number / 10000.0
        local remain = number % 10000
        if(result < 10 and remain >= 1000) then
            result = string.format("%.1f",result)
            return result..L("万")
        else
             return math.floor(result)..L("万")
        end
       
    end
    return tostring(number)    
end

local soundValue = 1
function GetAudioSoundValue()
    return soundValue
end

function SetAudioSoundValue(value)
    soundValue = value
end
