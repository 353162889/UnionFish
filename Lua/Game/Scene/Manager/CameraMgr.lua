require 'Game/Scene/Component/StateComponent'
CameraMgr = {}

local this = CameraMgr
 this.Camera = nil
 this.stateComponent = nil
 this.shakeHelper = nil
 this.cameraMove = nil
 this.tableName = "CameraMgr"

 function this.OnEnterScene(camera)
 	this.Camera = camera
 	this.stateComponent = StateComponent:New(this)
 	this.shakeHelper = this.Camera.gameObject:AddComponent(typeof(ShakeCameraHelper))
 	this.cameraMove = this.Camera.gameObject:GetComponent("CameraMove")
 	local editorCameraMove = this.cameraMove.LookAtGo:GetComponent("EditorCameraMove")
 	if(editorCameraMove ~= nil) then
 		if(editorCameraMove.enabled) then
 			LogError("EditorCameraMove 必须禁用掉")
 			editorCameraMove.enabled = false 
 		end
 	end
 end

 function this.OnExitScene()
 	this.Camera = nil
 	if(this.stateComponent ~= nil) then
		this.stateComponent:Clear()
		this.stateComponent = nil
	end
	this.shakeHelper = nil
	this.cameraMove = nil
 end

 function this.Init(cameraPos,listState)
 	this.Camera.transform.parent.localPosition = Vector3.New(cameraPos.p_x,cameraPos.p_y,cameraPos.p_z)
	this.Camera.gameObject.transform.localEulerAngles = Vector3.New(cameraPos.d_x,cameraPos.d_y,cameraPos.d_z)
	if(listState ~= nil) then
		this.OnInitStates(listState)
	end
 end

 function this.SyncPos(listPos)
 	for k,v in pairs(listPos) do
		if(v.obj_id == PlayCtrl.mode.CameraID) then
			this.cameraMove:SetGoTo(Vector3.New(v.obj_pos.p_x,v.obj_pos.p_y,v.obj_pos.p_z),Vector3.New(v.obj_pos.d_x,v.obj_pos.d_y,v.obj_pos.d_z))
		end
	end
 end

 function this.OnUpdateState(refStateInfo)
 	if(this.stateComponent ~= nil) then
		this.UpdateStates(refStateInfo.info_list)
	end
end

function this.OnInitStates(listState)
	for i,v in ipairs(listState) do
		this.stateComponent:InitState(v.id,v)
	end
end

function this.UpdateStates(listState)
	for i,v in ipairs(listState) do
		this.stateComponent:UpdateState(v.id,v)
	end
end

function this.OnDeleteState(delStateInfo)
	if(this.stateComponent ~= nil) then
		this.DeleteStates(delStateInfo.id_list)
	end
end

function this.DeleteStates(listState)
	for i,v in ipairs(listState) do
		this.stateComponent:RemoveState(v)
	end
end

function this.ShakeDefault()
	if(this.shakeHelper ~= nil) then
		this.shakeHelper:SetShakeParam(0.5,20,0.0,0.01,0)
		this.shakeHelper:SetShakeCamera()
	end
end

function this.Shake(shakeTime,fps,frameTime,shakeDelta,delay)
	if(this.shakeHelper ~= nil) then
		this.shakeHelper:SetShakeParam(shakeTime,fps,frameTime,shakeDelta,delay)
		this.shakeHelper:SetShakeCamera()
	end
end
