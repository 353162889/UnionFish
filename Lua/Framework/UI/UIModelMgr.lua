UIModelMgr = { }
local this = UIModelMgr

local isInit = false
local index = 0
local tranRoot

function UIModelMgr.Init()
    index = 0
    tranRoot = GameObject.New("UIModelMgr").transform
    tranRoot.position = Vector3.New(1000, 1000, 1000)
    GameObject.DontDestroyOnLoad(tranRoot.gameObject)
    isInit = true
end

function UIModelMgr.CreateModel(uiTexture, isCanDrag, cameraScale, isOrthographic)

    if not isInit then
        this.Init()
    end

    local ModelEntry = this.CreateEntry()
    ModelEntry.uiTexture = uiTexture

    ModelEntry.root = GameObject.New(tostring(ModelEntry.id)).transform
    ModelEntry.root.parent = tranRoot
    ModelEntry.root.localPosition = Vector3.New(2000, ModelEntry.id * 1000, 0)

    -- 设置相机
    local cameraGo = GameObject.New("Camera")
    ModelEntry.camera = cameraGo:AddComponent(typeof(UnityEngine.Camera))
    ModelEntry.camera.transform.parent = ModelEntry.root
    ModelEntry.camera.transform.localPosition = Vector3.New(0, 0, 5)
    ModelEntry.camera.transform.eulerAngles = Vector3.New(0, 180, 0)

    if isOrthographic ~= nil then
        ModelEntry.camera.orthographic = isOrthographic
    else
        ModelEntry.camera.orthographic = true
    end
    ModelEntry.camera.farClipPlane = 100
    ModelEntry.camera.depth = -10
    if ModelEntry.camera.orthographic then
        ModelEntry.camera.orthographicSize = cameraScale or 1.5
    else
        ModelEntry.camera.fieldOfView = cameraScale or 60
    end
    -- ModelEntry.camera.cullingMask = 257
    ModelEntry.camera.backgroundColor = Color.New(0, 0, 0, 0)
    ModelEntry.camera.clearFlags=UnityEngine.CameraClearFlags.SolidColor
    LH.SetCamera(ModelEntry.camera,"Gun_Fish")
    -- 设置renderTexture
    ModelEntry.renderTexture = UnityEngine.RenderTexture.New(uiTexture.width, uiTexture.height, 24)
    ModelEntry.renderTexture.antiAliasing = 2;
    ModelEntry.camera.targetTexture = ModelEntry.renderTexture


    local OnTextureDrag = function(g,vec)
        if ModelEntry ~= nil and ModelEntry.go ~= nil then
            ModelEntry.go.transform.eulerAngles = ModelEntry.go.transform.eulerAngles:Add(Vector3.New(0, - vec.x, 0))
        end
    end

    local SetTexture = function(t)
        t.mainTexture = ModelEntry.renderTexture
        -- 设置旋转
        local box = t:GetComponent("BoxCollider")
        if isCanDrag then
            LH.AddDragEvent(t.gameObject, OnTextureDrag)
            if box == nil then
                box = t.gameObject:AddComponent(typeof(UnityEngine.BoxCollider))
                t.autoResizeBoxCollider = true
                box.size = Vector3.New(t.width, t.height, 0)
            end
        else
            -- if box ~= nil then
            --     box.enabled = false
            -- end
        end
    end

    SetTexture(ModelEntry.uiTexture)

    local AddTexture = function(t)
        SetTexture(t)
    end

    local ShowModel = function(modelPath,vecPos,vecRot,vecSca,defaultAnim)
        if ModelEntry.go ~= nil then
            GameObject.Destroy(ModelEntry.go)
            ModelEntry.animator = nil
            ModelEntry.ResObj = nil
            ModelEntry.speedHelper = nil
            ModelEntry.go = nil
        end
        ModelEntry.go = UnityEngine.GameObject("go")
        ModelEntry.go.transform.parent = ModelEntry.root
        ModelEntry.go.transform.localPosition = vecPos
        ModelEntry.go.transform.localEulerAngles = vecRot
        ModelEntry.go.transform.localScale = vecSca
       
        if(ModelEntry.OnResLoaded ~= nil) then
            ResourceMgr.RemoveListenerInLua( ModelEntry.ModelPath,ModelEntry.OnResLoaded)
            ModelEntry.OnResLoaded = nil
            ModelEntry.ModelPath = nil
        end
        ModelEntry.isModelInit = false
        
        ModelEntry.ResPos = Vector3.zero
        ModelEntry.ResRot = Vector3.zero
        ModelEntry.ResScale = Vector3.one

        ModelEntry.DefaultAnim = defaultAnim
        ModelEntry.DefaultSpeed = nil
        ModelEntry.ModelPath = modelPath
        ModelEntry.OnResLoaded = function (res)
            local obj = Resource.GetGameObject(res,ModelEntry.ModelPath)
            ModelEntry.ResObj = obj
            obj.transform.parent = ModelEntry.go.transform
            obj.transform.localPosition = ModelEntry.ResPos
            obj.transform.localEulerAngles = ModelEntry.ResRot
            obj.transform.localScale = ModelEntry.ResScale

            ModelEntry.root.gameObject:SetActive(true)
            ModelEntry.OnResLoaded = nil
            --播放默认动画
            ModelEntry.animator = obj:GetComponent("Animator")
             ModelEntry.speedHelper = ModelEntry.animator.gameObject:AddComponent(typeof(AnimSpeedHelper))
            if(ModelEntry.DefaultAnim ~= nil) then
                ModelEntry.animator:Play(ModelEntry.DefaultAnim)
                if(ModelEntry.DefaultSpeed ~= nil) then
                    ModelEntry.speedHelper:SetAnimSpeed(ModelEntry.DefaultAnim,ModelEntry.DefaultSpeed)
                end
            end
        end
        ResourceMgr.GetResourceInLua(modelPath,ModelEntry.OnResLoaded)
        ModelEntry.isModelInit = true
    end
    local HideModel = function()
        if ModelEntry ~= nil and ModelEntry.root ~= nil then
            ModelEntry.root.gameObject:SetActive(false)
        end

    end
    local ResetModel = function()
        if(ModelEntry.OnResLoaded ~= nil) then
            ResourceMgr.RemoveListenerInLua(ModelEntry.ModelPath,ModelEntry.OnResLoaded)
            ModelEntry.OnResLoaded = nil
        end
        ModelEntry.speedHelper = nil
        ModelEntry.animator = nil
        ModelEntry.ResObj = nil
        if(ModelEntry.go ~= nil) then
             GameObject.Destroy(ModelEntry.go)
             ModelEntry.go = nil
        end
         if ModelEntry ~= nil and ModelEntry.root ~= nil then
            ModelEntry.root.gameObject:SetActive(false)
        end
    end

    local DestroyModel = function()
        if ModelEntry ~= nil then
            if(ModelEntry.OnResLoaded ~= nil) then
                ResourceMgr.RemoveListenerInLua( ModelEntry.ModelPath,ModelEntry.OnResLoaded)
                ModelEntry.OnResLoaded = nil
            end
            ModelEntry.speedHelper = nil
            ModelEntry.animator = nil
            ModelEntry.ResObj = nil
            if(ModelEntry.go ~= nil) then
                 GameObject.Destroy(ModelEntry.go)
                 ModelEntry.go = nil
            end
            GameObject.Destroy(ModelEntry.root.gameObject)
            ModelEntry.renderTexture:Release()
            ModelEntry.renderTexture = nil
            ModelEntry.uiTexture.mainTexture = nil
        end
    end

    local Play = function(anim,speed)
        local spd = speed
        if(spd == nil)then
            spd = 1
        end
        ModelEntry.DefaultAnim = anim
        ModelEntry.DefaultSpeed = spd

        if(ModelEntry.animator ~= nil and ModelEntry.DefaultAnim ~= nil) then
            ModelEntry.animator:Play(tostring(ModelEntry.DefaultAnim))
            ModelEntry.speedHelper:SetAnimSpeed(ModelEntry.DefaultAnim,ModelEntry.DefaultSpeed)
        end
    end
    local GetAnimator = function()
        return ModelEntry.animator
    end
    local PlayEffect = function(path, pos)
        
    end
    local GetGo = function ()
        return ModelEntry.go
    end

    local AutoRotate = function (xSpeed,ySpeed,zSpeed)
        if(ModelEntry.go == nil) then return end
        local autoRotateHelper = ModelEntry.go:GetComponent("AutoRotateHelper")
        if(autoRotateHelper == nil) then
            autoRotateHelper = ModelEntry.go:AddComponent(typeof(AutoRotateHelper))
        end
        autoRotateHelper:SetRotateSpeed(xSpeed,ySpeed,zSpeed)
    end

    local SetResInfo = function (vecPos,vecRot,vecSca)
        ModelEntry.ResPos = vecPos
        ModelEntry.ResRot = vecRot
        ModelEntry.ResScale = vecSca
        if(ModelEntry.ResObj ~= nil) then
            ModelEntry.ResObj.transform.localPosition = ModelEntry.ResPos
            ModelEntry.ResObj.transform.localEulerAngles = ModelEntry.ResRot
            ModelEntry.ResObj.transform.localScale = ModelEntry.ResScale
        end
    end

    return {
        -- 显示模型
        ShowModel = ShowModel,
        -- 隐藏模型
        HideModel = HideModel,
        ResetModel = ResetModel,
        -- 销毁模型
        DestroyModel = DestroyModel,
        -- 增加贴图
        AddTexture = AddTexture,
        -- 播放动作
        Play = Play,
        GetAnimator=GetAnimator,
        -- 播放特效
        PlayEffect=PlayEffect,
        GetGo = GetGo,
        AutoRotate = AutoRotate,
        --设置加载的资源位置
        SetResInfo = SetResInfo
    }
end

function UIModelMgr.CreateEntry()
    local ModelEntry = { }
    ModelEntry.id = index
    index = index + 1
    return ModelEntry
end