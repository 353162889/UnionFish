-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_SC_Sign_pb')


S2CSIGNGETINFO = protobuf.Descriptor();
local S2CSIGNGETINFO_SIGN_FIELD = protobuf.FieldDescriptor();
local S2CSIGNGETINFO_NUM_FIELD = protobuf.FieldDescriptor();
S2CSIGNSIGN = protobuf.Descriptor();
local S2CSIGNSIGN_RET_FIELD = protobuf.FieldDescriptor();
local S2CSIGNSIGN_INDEX_FIELD = protobuf.FieldDescriptor();
SCENE_SIGN = protobuf.Descriptor();
local SCENE_SIGN_TYPE_FIELD = protobuf.FieldDescriptor();
local SCENE_SIGN_ID_FIELD = protobuf.FieldDescriptor();
local SCENE_SIGN_STATE_FIELD = protobuf.FieldDescriptor();
local SCENE_SIGN_LEFT_TIME_FIELD = protobuf.FieldDescriptor();
S2CSIGNGETSCENEINFO = protobuf.Descriptor();
local S2CSIGNGETSCENEINFO_INFO_FIELD = protobuf.FieldDescriptor();
local S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD = protobuf.FieldDescriptor();
S2CSIGNACCEPTPRIZEBYSCENE = protobuf.Descriptor();
local S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD = protobuf.FieldDescriptor();
S2CSIGNACCEPTPRIZEBYTIME = protobuf.Descriptor();
local S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD = protobuf.FieldDescriptor();
S2CSIGNACCEPTPRIZEBYALL = protobuf.Descriptor();
local S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD = protobuf.FieldDescriptor();

S2CSIGNGETINFO_SIGN_FIELD.name = "sign"
S2CSIGNGETINFO_SIGN_FIELD.full_name = ".net_protocol.S2CSignGetInfo.sign"
S2CSIGNGETINFO_SIGN_FIELD.number = 1
S2CSIGNGETINFO_SIGN_FIELD.index = 0
S2CSIGNGETINFO_SIGN_FIELD.label = 2
S2CSIGNGETINFO_SIGN_FIELD.has_default_value = false
S2CSIGNGETINFO_SIGN_FIELD.default_value = 0
S2CSIGNGETINFO_SIGN_FIELD.type = 13
S2CSIGNGETINFO_SIGN_FIELD.cpp_type = 3

S2CSIGNGETINFO_NUM_FIELD.name = "num"
S2CSIGNGETINFO_NUM_FIELD.full_name = ".net_protocol.S2CSignGetInfo.num"
S2CSIGNGETINFO_NUM_FIELD.number = 2
S2CSIGNGETINFO_NUM_FIELD.index = 1
S2CSIGNGETINFO_NUM_FIELD.label = 2
S2CSIGNGETINFO_NUM_FIELD.has_default_value = false
S2CSIGNGETINFO_NUM_FIELD.default_value = 0
S2CSIGNGETINFO_NUM_FIELD.type = 13
S2CSIGNGETINFO_NUM_FIELD.cpp_type = 3

S2CSIGNGETINFO.name = "S2CSignGetInfo"
S2CSIGNGETINFO.full_name = ".net_protocol.S2CSignGetInfo"
S2CSIGNGETINFO.nested_types = {}
S2CSIGNGETINFO.enum_types = {}
S2CSIGNGETINFO.fields = {S2CSIGNGETINFO_SIGN_FIELD, S2CSIGNGETINFO_NUM_FIELD}
S2CSIGNGETINFO.is_extendable = false
S2CSIGNGETINFO.extensions = {}
S2CSIGNSIGN_RET_FIELD.name = "ret"
S2CSIGNSIGN_RET_FIELD.full_name = ".net_protocol.S2CSignSign.ret"
S2CSIGNSIGN_RET_FIELD.number = 1
S2CSIGNSIGN_RET_FIELD.index = 0
S2CSIGNSIGN_RET_FIELD.label = 2
S2CSIGNSIGN_RET_FIELD.has_default_value = false
S2CSIGNSIGN_RET_FIELD.default_value = 0
S2CSIGNSIGN_RET_FIELD.type = 13
S2CSIGNSIGN_RET_FIELD.cpp_type = 3

S2CSIGNSIGN_INDEX_FIELD.name = "index"
S2CSIGNSIGN_INDEX_FIELD.full_name = ".net_protocol.S2CSignSign.index"
S2CSIGNSIGN_INDEX_FIELD.number = 2
S2CSIGNSIGN_INDEX_FIELD.index = 1
S2CSIGNSIGN_INDEX_FIELD.label = 2
S2CSIGNSIGN_INDEX_FIELD.has_default_value = false
S2CSIGNSIGN_INDEX_FIELD.default_value = 0
S2CSIGNSIGN_INDEX_FIELD.type = 13
S2CSIGNSIGN_INDEX_FIELD.cpp_type = 3

S2CSIGNSIGN.name = "S2CSignSign"
S2CSIGNSIGN.full_name = ".net_protocol.S2CSignSign"
S2CSIGNSIGN.nested_types = {}
S2CSIGNSIGN.enum_types = {}
S2CSIGNSIGN.fields = {S2CSIGNSIGN_RET_FIELD, S2CSIGNSIGN_INDEX_FIELD}
S2CSIGNSIGN.is_extendable = false
S2CSIGNSIGN.extensions = {}
SCENE_SIGN_TYPE_FIELD.name = "type"
SCENE_SIGN_TYPE_FIELD.full_name = ".net_protocol.scene_sign.type"
SCENE_SIGN_TYPE_FIELD.number = 1
SCENE_SIGN_TYPE_FIELD.index = 0
SCENE_SIGN_TYPE_FIELD.label = 2
SCENE_SIGN_TYPE_FIELD.has_default_value = false
SCENE_SIGN_TYPE_FIELD.default_value = 0
SCENE_SIGN_TYPE_FIELD.type = 13
SCENE_SIGN_TYPE_FIELD.cpp_type = 3

SCENE_SIGN_ID_FIELD.name = "id"
SCENE_SIGN_ID_FIELD.full_name = ".net_protocol.scene_sign.id"
SCENE_SIGN_ID_FIELD.number = 2
SCENE_SIGN_ID_FIELD.index = 1
SCENE_SIGN_ID_FIELD.label = 2
SCENE_SIGN_ID_FIELD.has_default_value = false
SCENE_SIGN_ID_FIELD.default_value = 0
SCENE_SIGN_ID_FIELD.type = 13
SCENE_SIGN_ID_FIELD.cpp_type = 3

SCENE_SIGN_STATE_FIELD.name = "state"
SCENE_SIGN_STATE_FIELD.full_name = ".net_protocol.scene_sign.state"
SCENE_SIGN_STATE_FIELD.number = 3
SCENE_SIGN_STATE_FIELD.index = 2
SCENE_SIGN_STATE_FIELD.label = 2
SCENE_SIGN_STATE_FIELD.has_default_value = false
SCENE_SIGN_STATE_FIELD.default_value = 0
SCENE_SIGN_STATE_FIELD.type = 13
SCENE_SIGN_STATE_FIELD.cpp_type = 3

SCENE_SIGN_LEFT_TIME_FIELD.name = "left_time"
SCENE_SIGN_LEFT_TIME_FIELD.full_name = ".net_protocol.scene_sign.left_time"
SCENE_SIGN_LEFT_TIME_FIELD.number = 4
SCENE_SIGN_LEFT_TIME_FIELD.index = 3
SCENE_SIGN_LEFT_TIME_FIELD.label = 2
SCENE_SIGN_LEFT_TIME_FIELD.has_default_value = false
SCENE_SIGN_LEFT_TIME_FIELD.default_value = 0
SCENE_SIGN_LEFT_TIME_FIELD.type = 13
SCENE_SIGN_LEFT_TIME_FIELD.cpp_type = 3

SCENE_SIGN.name = "scene_sign"
SCENE_SIGN.full_name = ".net_protocol.scene_sign"
SCENE_SIGN.nested_types = {}
SCENE_SIGN.enum_types = {}
SCENE_SIGN.fields = {SCENE_SIGN_TYPE_FIELD, SCENE_SIGN_ID_FIELD, SCENE_SIGN_STATE_FIELD, SCENE_SIGN_LEFT_TIME_FIELD}
SCENE_SIGN.is_extendable = false
SCENE_SIGN.extensions = {}
S2CSIGNGETSCENEINFO_INFO_FIELD.name = "info"
S2CSIGNGETSCENEINFO_INFO_FIELD.full_name = ".net_protocol.S2CSignGetSceneInfo.info"
S2CSIGNGETSCENEINFO_INFO_FIELD.number = 1
S2CSIGNGETSCENEINFO_INFO_FIELD.index = 0
S2CSIGNGETSCENEINFO_INFO_FIELD.label = 3
S2CSIGNGETSCENEINFO_INFO_FIELD.has_default_value = false
S2CSIGNGETSCENEINFO_INFO_FIELD.default_value = {}
S2CSIGNGETSCENEINFO_INFO_FIELD.message_type = SCENE_SIGN
S2CSIGNGETSCENEINFO_INFO_FIELD.type = 11
S2CSIGNGETSCENEINFO_INFO_FIELD.cpp_type = 10

S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.name = "enter_time"
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.full_name = ".net_protocol.S2CSignGetSceneInfo.enter_time"
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.number = 2
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.index = 1
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.label = 2
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.has_default_value = false
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.default_value = 0
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.type = 13
S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD.cpp_type = 3

S2CSIGNGETSCENEINFO.name = "S2CSignGetSceneInfo"
S2CSIGNGETSCENEINFO.full_name = ".net_protocol.S2CSignGetSceneInfo"
S2CSIGNGETSCENEINFO.nested_types = {}
S2CSIGNGETSCENEINFO.enum_types = {}
S2CSIGNGETSCENEINFO.fields = {S2CSIGNGETSCENEINFO_INFO_FIELD, S2CSIGNGETSCENEINFO_ENTER_TIME_FIELD}
S2CSIGNGETSCENEINFO.is_extendable = false
S2CSIGNGETSCENEINFO.extensions = {}
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.name = "info"
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.full_name = ".net_protocol.S2CSignAcceptPrizeByScene.info"
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.number = 1
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.index = 0
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.label = 2
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.has_default_value = false
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.default_value = nil
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.message_type = SCENE_SIGN
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.type = 11
S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD.cpp_type = 10

S2CSIGNACCEPTPRIZEBYSCENE.name = "S2CSignAcceptPrizeByScene"
S2CSIGNACCEPTPRIZEBYSCENE.full_name = ".net_protocol.S2CSignAcceptPrizeByScene"
S2CSIGNACCEPTPRIZEBYSCENE.nested_types = {}
S2CSIGNACCEPTPRIZEBYSCENE.enum_types = {}
S2CSIGNACCEPTPRIZEBYSCENE.fields = {S2CSIGNACCEPTPRIZEBYSCENE_INFO_FIELD}
S2CSIGNACCEPTPRIZEBYSCENE.is_extendable = false
S2CSIGNACCEPTPRIZEBYSCENE.extensions = {}
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.name = "info"
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.full_name = ".net_protocol.S2CSignAcceptPrizeByTime.info"
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.number = 1
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.index = 0
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.label = 2
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.has_default_value = false
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.default_value = nil
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.message_type = SCENE_SIGN
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.type = 11
S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD.cpp_type = 10

S2CSIGNACCEPTPRIZEBYTIME.name = "S2CSignAcceptPrizeByTime"
S2CSIGNACCEPTPRIZEBYTIME.full_name = ".net_protocol.S2CSignAcceptPrizeByTime"
S2CSIGNACCEPTPRIZEBYTIME.nested_types = {}
S2CSIGNACCEPTPRIZEBYTIME.enum_types = {}
S2CSIGNACCEPTPRIZEBYTIME.fields = {S2CSIGNACCEPTPRIZEBYTIME_INFO_FIELD}
S2CSIGNACCEPTPRIZEBYTIME.is_extendable = false
S2CSIGNACCEPTPRIZEBYTIME.extensions = {}
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.name = "info"
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.full_name = ".net_protocol.S2CSignAcceptPrizeByAll.info"
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.number = 1
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.index = 0
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.label = 3
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.has_default_value = false
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.default_value = {}
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.message_type = SCENE_SIGN
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.type = 11
S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD.cpp_type = 10

S2CSIGNACCEPTPRIZEBYALL.name = "S2CSignAcceptPrizeByAll"
S2CSIGNACCEPTPRIZEBYALL.full_name = ".net_protocol.S2CSignAcceptPrizeByAll"
S2CSIGNACCEPTPRIZEBYALL.nested_types = {}
S2CSIGNACCEPTPRIZEBYALL.enum_types = {}
S2CSIGNACCEPTPRIZEBYALL.fields = {S2CSIGNACCEPTPRIZEBYALL_INFO_FIELD}
S2CSIGNACCEPTPRIZEBYALL.is_extendable = false
S2CSIGNACCEPTPRIZEBYALL.extensions = {}

S2CSignAcceptPrizeByAll = protobuf.Message(S2CSIGNACCEPTPRIZEBYALL)
S2CSignAcceptPrizeByScene = protobuf.Message(S2CSIGNACCEPTPRIZEBYSCENE)
S2CSignAcceptPrizeByTime = protobuf.Message(S2CSIGNACCEPTPRIZEBYTIME)
S2CSignGetInfo = protobuf.Message(S2CSIGNGETINFO)
S2CSignGetSceneInfo = protobuf.Message(S2CSIGNGETSCENEINFO)
S2CSignSign = protobuf.Message(S2CSIGNSIGN)
scene_sign = protobuf.Message(SCENE_SIGN)

