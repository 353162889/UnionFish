EffectMgr = {}
local this = EffectMgr

this.EffectParent = nil
--id 特效ID，p父节点，q渲染深度，lf播放完毕回调，lt回调参数
function this.GetEffectById(id,p,q,lf,lt)
    local tr = p.transform:FindChild("EverEffect_" .. id)
    local g = nil
    local data = Res.effect[id]
    if tr == nil then
        g = GameObject.New("EverEffect_" .. id)
        g:AddComponent(typeof(TimeHelper))
        g.transform.parent = p.transform
        g.transform.localPosition = Vector3.zero
        g.transform.localScale = Vector3.one
        if data ~= nil then
            local _g = LH.Load(data.path)
            _g.transform.parent = g.transform
            _g.transform.localPosition = Vector3.zero
            _g.transform.localScale = Vector3.one
            _g.transform.localEulerAngles = Vector3.zero
            this.AddUIRenderQueue(_g,q)
        else
            LogError("Res.Effect中没有id为"..id.."的资源")
            return nil
        end
    else
        g = tr.gameObject
    end
    
    local eh = LH.AddMissingEffectHelper(g)
    eh.Life = data.cd
    eh.LF = lf
    eh.LT = lt
    g:SetActive(false)
    g:SetActive(true)
    -- local soundData = string.Split(data.sound,",")
    --soundData[1] 音效效果类型
    -- if (soundData[2] ~= "0")then
    --     SoundFxManager.PlaySoundById(tonumber(soundData[2]),1,nil)
    -- end
    return g
end

function this.AddUIRenderQueue(g,q)
    local renderer = g:GetComponent("Renderer")
    if renderer ~= nil and renderer.sharedMaterial ~= nil then
        local uirq = g:AddComponent(typeof(UIRenderQueue))
        uirq:SetQueue(q)
        local mt = LH.CopyMaterial(renderer.sharedMaterial)
        renderer.sharedMaterial = mt
        uirq.mt = mt
    end
    local count = g.transform.childCount
    for i=1,count do 
        this.AddUIRenderQueue(g.transform:GetChild(i-1).gameObject,q)
    end
end