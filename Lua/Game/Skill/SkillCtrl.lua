require "Protof/NP_CS_Skill_pb"
require "Protof/NP_SC_Skill_pb"
require "Game/Skill/SkillEvent"
SkillCtrl = CustomEvent()

local this = SkillCtrl
this.mode = {}
this.mode.SkillList = {}
this.mode.UnLockSkillList = {}
this.mode.Forbid = false

function this.ResetData()
    this.mode = {}
    this.mode.SkillList = {}
    this.mode.UnLockSkillList = {}
    this.mode.Forbid = false
end

function this.ForbidSkill()
    this.mode.Forbid = true
end

function this.ResumeSkill()
    this.mode.Forbid = false
end

function this.IsSkillForbid(skillID)
    return this.mode.Forbid
end

function this.C2SSkillGetInfo()
	local sendData = NP_CS_Skill_pb.C2SSkillGetInfo()
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15250, msg)
end

function this.S2CSkillGetInfo(data)
	this.mode.SkillList = {}
	this.mode.UnLockSkillList = {}
	local msg = NP_SC_Skill_pb.S2CSkillGetInfo()
    msg:ParseFromString(data)
    LogColor("#ff0000","S2CSkillGetInfo")
    for i,v in ipairs(msg.skill_list) do
    	table.insert(this.mode.SkillList,v)
    end
    for i,v in ipairs(msg.un_skill_list) do
    	table.insert(this.mode.UnLockSkillList,v)
    end
end

function this.C2SSkillUnlockSkill(skillID)
	local sendData = NP_CS_Skill_pb.C2SSkillUnlockSkill()
	sendData.skill_id = skillID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15251, msg)
end

function this.S2CSkillUnlockSkill(data)
	local msg = NP_SC_Skill_pb.S2CSkillUnlockSkill()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
    	local list = this.mode.UnLockSkillList
    	local exist = false
    	for i,v in pairs(list) do
    		if(v ~= nil and v == msg.skill_id) then
    			exist = true
    			break
    		end
    	end
    	if(not exist) then
    		table.insert(this.mode.UnLockSkillList,msg.skill_id)
    		this.SendEvent(SkillEvent.OnUnlockSkill,msg.skill_id)
    	end
    else

    end
    LogColor("#ff0000","S2CSkillUnlockSkill",msg.ret,msg.skill_id)
end

function this.C2SSkillSetSkill(index,skillID)
	local sendData = NP_CS_Skill_pb.C2SSkillSetSkill()
	sendData.id = index
	sendData.skill_id = skillID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15252, msg)
end

function this.S2CSkillSetSkill(data)
	local msg = NP_SC_Skill_pb.S2CSkillSetSkill()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
    	this.mode.SkillList[msg.id] = msg.skill_id
    	this.SendEvent(SkillEvent.OnSetSkill,msg.id,msg.skill_id)
    else
    end
     LogColor("#ff0000","S2CSkillSetSkill",msg.ret,msg.id,msg.skill_id)
end

--使用技能能量版
function this.C2SSkillUseSkill(skillID)
	local sendData = NP_CS_Skill_pb.C2SSkillUseSkill()
	sendData.skill_id = skillID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15253, msg)
end

function this.S2CSkillUseSkill(data)
	local msg = NP_SC_Skill_pb.S2CSkillUseSkill()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
         this.PlaySkillSound(msg.skill_id)
         --使用技能
    	this.SendEvent(SkillEvent.OnUseSkill,msg.skill_id)
    	
    else
    end
     LogColor("#ff0000","S2CSkillUseSkill",msg.ret,msg.skill_id)
end

--使用技能钻石版
function this.C2SSkillUseSkillGold(skillID)
	local sendData = NP_CS_Skill_pb.C2SSkillUseSkillGold()
	sendData.skill_id = skillID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15254, msg)
end

function this.S2CSkillUseSkillGold(data)
	local msg = NP_SC_Skill_pb.S2CSkillUseSkillGold()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
         this.PlaySkillSound(msg.skill_id)
    	--使用技能
    	this.SendEvent(SkillEvent.OnUseSkillGold,msg.skill_id)
    else
    end
     LogColor("#ff0000","S2CSkillUseSkillGold",msg.ret,msg.skill_id)
end

--使用技能场景版
function this.C2SSkillUseSceneSkill(skillID)
    LogColor("#ff0000","C2SSkillUseSceneSkill",skillID)
	local sendData = NP_CS_Skill_pb.C2SSkillUseSceneSkill()
	sendData.skill_id = skillID
    local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15255, msg)
end

function this.S2CSkillUseSceneSkill(data)
	local msg = NP_SC_Skill_pb.S2CSkillUseSceneSkill()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
        this.PlaySkillSound(msg.skill_id)
    	--使用技能
    	this.SendEvent(SkillEvent.OnUseSceneSkill,msg.skill_id)
    else
    end
     LogColor("#ff0000","S2CSkillUseSceneSkill",msg.ret,msg.skill_id)
end

function this.C2SSkillSwapSkill(index1,index2)
	local sendData = NP_CS_Skill_pb.C2SSkillSwapSkill()
	sendData.index1 = index1
	sendData.index2 = index2
	 local msg = sendData:SerializeToString()
    LuaMsgHelper.sendBinMsgData(15256, msg)
end

function this.S2CSkillSwapSkill(data)
	local msg = NP_SC_Skill_pb.S2CSkillSwapSkill()
    msg:ParseFromString(data)
    if(msg.ret == GlobalDefine.RetSucc) then
    	local index1 = msg.index1
    	local index2 = msg.index2
    	local temp = this.mode.SkillList[index1]
    	this.mode.SkillList[index1] = this.mode.SkillList[index2]
    	this.mode.SkillList[index2] = temp
    	this.SendEvent(SkillEvent.OnSwapSkill,index1,index2)
    else
    end
     LogColor("#ff0000","S2CSkillSwapSkill",msg.ret)
end

function this.PlaySkillSound(skillID)
    if(Res.skill[skillID] == nil)then return end
    local cfg = Res.skill[skillID]
    if(cfg.sound > 0) then
        PlaySound(cfg.sound,nil)
    end
end