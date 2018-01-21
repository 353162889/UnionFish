-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_ServerClient_pb')


S2CREGISTERRESULT = protobuf.Descriptor();
local S2CREGISTERRESULT_INIT_USER_NAME_FIELD = protobuf.FieldDescriptor();
local S2CREGISTERRESULT_USER_PWD_FIELD = protobuf.FieldDescriptor();
local S2CREGISTERRESULT_IP_FIELD = protobuf.FieldDescriptor();
local S2CREGISTERRESULT_PORT_FIELD = protobuf.FieldDescriptor();
S2CLOGINRESULT = protobuf.Descriptor();
local S2CLOGINRESULT_RESULT = protobuf.EnumDescriptor();
local S2CLOGINRESULT_RESULT_SUC_ENUM = protobuf.EnumValueDescriptor();
local S2CLOGINRESULT_RESULT_FAIL_UNFOUND_GATWAY_ENUM = protobuf.EnumValueDescriptor();
local S2CLOGINRESULT_RESULT_FROBID_ENUM = protobuf.EnumValueDescriptor();
local S2CLOGINRESULT_RESULT_DEVICE_FROBID_ENUM = protobuf.EnumValueDescriptor();
local S2CLOGINRESULT_REULST_FIELD = protobuf.FieldDescriptor();
local S2CLOGINRESULT_INIT_USER_NAME_FIELD = protobuf.FieldDescriptor();
local S2CLOGINRESULT_USER_PWD_FIELD = protobuf.FieldDescriptor();
local S2CLOGINRESULT_IP_FIELD = protobuf.FieldDescriptor();
local S2CLOGINRESULT_PORT_FIELD = protobuf.FieldDescriptor();
local S2CLOGINRESULT_GAMEID_FIELD = protobuf.FieldDescriptor();
S2CKICKROLE = protobuf.Descriptor();
local S2CKICKROLE_KICKREASON = protobuf.EnumDescriptor();
local S2CKICKROLE_KICKREASON_LOGIN_ON_OTHER_PLACE_ENUM = protobuf.EnumValueDescriptor();
local S2CKICKROLE_REASON_FIELD = protobuf.FieldDescriptor();
BATTERY_INFO = protobuf.Descriptor();
local BATTERY_INFO_ID_FIELD = protobuf.FieldDescriptor();
local BATTERY_INFO_END_TIME_FIELD = protobuf.FieldDescriptor();
S2CENTERGAME = protobuf.Descriptor();
local S2CENTERGAME_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_EXP_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_VIP_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_NAME_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_GOLD_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_DIAMOND_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_HEAD_ID_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_CANNON_MULTIPLE_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_BATTERY_ID_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_BATTERY_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_BATTERY_IDS_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_SKILL_IDS_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_CONSORTIA_ID_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_CONSORTIA_NAME_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_GENDER_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_BATTERY_RATE_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_IS_NAME_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_IS_GENDER_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_DAILY_ASS_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_SP_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_USER_NAME_FIELD = protobuf.FieldDescriptor();
local S2CENTERGAME_BATTERY_LIST_FIELD = protobuf.FieldDescriptor();
S2CHEARTBEAT = protobuf.Descriptor();
local S2CHEARTBEAT_TIME_FIELD = protobuf.FieldDescriptor();
CS2CROLEINFOUPDATE = protobuf.Descriptor();
local CS2CROLEINFOUPDATE_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local CS2CROLEINFOUPDATE_TYPE_FIELD = protobuf.FieldDescriptor();
local CS2CROLEINFOUPDATE_RET_FIELD = protobuf.FieldDescriptor();
PARAMLIST = protobuf.Descriptor();
local PARAMLIST_ID_FIELD = protobuf.FieldDescriptor();
local PARAMLIST_PARAM_FIELD = protobuf.FieldDescriptor();
S2CCODENOTICE = protobuf.Descriptor();
local S2CCODENOTICE_CODETYPE = protobuf.EnumDescriptor();
local S2CCODENOTICE_CODETYPE_ERROR_CODE_ENUM = protobuf.EnumValueDescriptor();
local S2CCODENOTICE_CODETYPE_NOTICE_CODE_ENUM = protobuf.EnumValueDescriptor();
local S2CCODENOTICE_CODE_ID_FIELD = protobuf.FieldDescriptor();
local S2CCODENOTICE_CODE_TYPE_FIELD = protobuf.FieldDescriptor();
local S2CCODENOTICE_LIST_FIELD = protobuf.FieldDescriptor();
CS2CUSERLOGINACK = protobuf.Descriptor();
local CS2CUSERLOGINACK_ACK_FIELD = protobuf.FieldDescriptor();

S2CREGISTERRESULT_INIT_USER_NAME_FIELD.name = "init_user_name"
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.full_name = ".net_protocol.S2CRegisterResult.init_user_name"
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.number = 1
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.index = 0
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.label = 2
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.has_default_value = false
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.default_value = ""
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.type = 9
S2CREGISTERRESULT_INIT_USER_NAME_FIELD.cpp_type = 9

S2CREGISTERRESULT_USER_PWD_FIELD.name = "user_pwd"
S2CREGISTERRESULT_USER_PWD_FIELD.full_name = ".net_protocol.S2CRegisterResult.user_pwd"
S2CREGISTERRESULT_USER_PWD_FIELD.number = 2
S2CREGISTERRESULT_USER_PWD_FIELD.index = 1
S2CREGISTERRESULT_USER_PWD_FIELD.label = 2
S2CREGISTERRESULT_USER_PWD_FIELD.has_default_value = false
S2CREGISTERRESULT_USER_PWD_FIELD.default_value = ""
S2CREGISTERRESULT_USER_PWD_FIELD.type = 9
S2CREGISTERRESULT_USER_PWD_FIELD.cpp_type = 9

S2CREGISTERRESULT_IP_FIELD.name = "ip"
S2CREGISTERRESULT_IP_FIELD.full_name = ".net_protocol.S2CRegisterResult.ip"
S2CREGISTERRESULT_IP_FIELD.number = 3
S2CREGISTERRESULT_IP_FIELD.index = 2
S2CREGISTERRESULT_IP_FIELD.label = 2
S2CREGISTERRESULT_IP_FIELD.has_default_value = false
S2CREGISTERRESULT_IP_FIELD.default_value = 0
S2CREGISTERRESULT_IP_FIELD.type = 13
S2CREGISTERRESULT_IP_FIELD.cpp_type = 3

S2CREGISTERRESULT_PORT_FIELD.name = "port"
S2CREGISTERRESULT_PORT_FIELD.full_name = ".net_protocol.S2CRegisterResult.port"
S2CREGISTERRESULT_PORT_FIELD.number = 4
S2CREGISTERRESULT_PORT_FIELD.index = 3
S2CREGISTERRESULT_PORT_FIELD.label = 2
S2CREGISTERRESULT_PORT_FIELD.has_default_value = false
S2CREGISTERRESULT_PORT_FIELD.default_value = 0
S2CREGISTERRESULT_PORT_FIELD.type = 13
S2CREGISTERRESULT_PORT_FIELD.cpp_type = 3

S2CREGISTERRESULT.name = "S2CRegisterResult"
S2CREGISTERRESULT.full_name = ".net_protocol.S2CRegisterResult"
S2CREGISTERRESULT.nested_types = {}
S2CREGISTERRESULT.enum_types = {}
S2CREGISTERRESULT.fields = {S2CREGISTERRESULT_INIT_USER_NAME_FIELD, S2CREGISTERRESULT_USER_PWD_FIELD, S2CREGISTERRESULT_IP_FIELD, S2CREGISTERRESULT_PORT_FIELD}
S2CREGISTERRESULT.is_extendable = false
S2CREGISTERRESULT.extensions = {}
S2CLOGINRESULT_RESULT_SUC_ENUM.name = "SUC"
S2CLOGINRESULT_RESULT_SUC_ENUM.index = 0
S2CLOGINRESULT_RESULT_SUC_ENUM.number = 0
S2CLOGINRESULT_RESULT_FAIL_UNFOUND_GATWAY_ENUM.name = "FAIL_UNFOUND_GATWAY"
S2CLOGINRESULT_RESULT_FAIL_UNFOUND_GATWAY_ENUM.index = 1
S2CLOGINRESULT_RESULT_FAIL_UNFOUND_GATWAY_ENUM.number = 1
S2CLOGINRESULT_RESULT_FROBID_ENUM.name = "FROBID"
S2CLOGINRESULT_RESULT_FROBID_ENUM.index = 2
S2CLOGINRESULT_RESULT_FROBID_ENUM.number = 2
S2CLOGINRESULT_RESULT_DEVICE_FROBID_ENUM.name = "DEVICE_FROBID"
S2CLOGINRESULT_RESULT_DEVICE_FROBID_ENUM.index = 3
S2CLOGINRESULT_RESULT_DEVICE_FROBID_ENUM.number = 3
S2CLOGINRESULT_RESULT.name = "Result"
S2CLOGINRESULT_RESULT.full_name = ".net_protocol.S2CLoginResult.Result"
S2CLOGINRESULT_RESULT.values = {S2CLOGINRESULT_RESULT_SUC_ENUM,S2CLOGINRESULT_RESULT_FAIL_UNFOUND_GATWAY_ENUM,S2CLOGINRESULT_RESULT_FROBID_ENUM,S2CLOGINRESULT_RESULT_DEVICE_FROBID_ENUM}
S2CLOGINRESULT_REULST_FIELD.name = "reulst"
S2CLOGINRESULT_REULST_FIELD.full_name = ".net_protocol.S2CLoginResult.reulst"
S2CLOGINRESULT_REULST_FIELD.number = 1
S2CLOGINRESULT_REULST_FIELD.index = 0
S2CLOGINRESULT_REULST_FIELD.label = 2
S2CLOGINRESULT_REULST_FIELD.has_default_value = true
S2CLOGINRESULT_REULST_FIELD.default_value = SUC
S2CLOGINRESULT_REULST_FIELD.enum_type = S2CLOGINRESULT.RESULT
S2CLOGINRESULT_REULST_FIELD.type = 14
S2CLOGINRESULT_REULST_FIELD.cpp_type = 8

S2CLOGINRESULT_INIT_USER_NAME_FIELD.name = "init_user_name"
S2CLOGINRESULT_INIT_USER_NAME_FIELD.full_name = ".net_protocol.S2CLoginResult.init_user_name"
S2CLOGINRESULT_INIT_USER_NAME_FIELD.number = 2
S2CLOGINRESULT_INIT_USER_NAME_FIELD.index = 1
S2CLOGINRESULT_INIT_USER_NAME_FIELD.label = 2
S2CLOGINRESULT_INIT_USER_NAME_FIELD.has_default_value = false
S2CLOGINRESULT_INIT_USER_NAME_FIELD.default_value = ""
S2CLOGINRESULT_INIT_USER_NAME_FIELD.type = 9
S2CLOGINRESULT_INIT_USER_NAME_FIELD.cpp_type = 9

S2CLOGINRESULT_USER_PWD_FIELD.name = "user_pwd"
S2CLOGINRESULT_USER_PWD_FIELD.full_name = ".net_protocol.S2CLoginResult.user_pwd"
S2CLOGINRESULT_USER_PWD_FIELD.number = 3
S2CLOGINRESULT_USER_PWD_FIELD.index = 2
S2CLOGINRESULT_USER_PWD_FIELD.label = 2
S2CLOGINRESULT_USER_PWD_FIELD.has_default_value = false
S2CLOGINRESULT_USER_PWD_FIELD.default_value = ""
S2CLOGINRESULT_USER_PWD_FIELD.type = 9
S2CLOGINRESULT_USER_PWD_FIELD.cpp_type = 9

S2CLOGINRESULT_IP_FIELD.name = "ip"
S2CLOGINRESULT_IP_FIELD.full_name = ".net_protocol.S2CLoginResult.ip"
S2CLOGINRESULT_IP_FIELD.number = 4
S2CLOGINRESULT_IP_FIELD.index = 3
S2CLOGINRESULT_IP_FIELD.label = 2
S2CLOGINRESULT_IP_FIELD.has_default_value = false
S2CLOGINRESULT_IP_FIELD.default_value = 0
S2CLOGINRESULT_IP_FIELD.type = 13
S2CLOGINRESULT_IP_FIELD.cpp_type = 3

S2CLOGINRESULT_PORT_FIELD.name = "port"
S2CLOGINRESULT_PORT_FIELD.full_name = ".net_protocol.S2CLoginResult.port"
S2CLOGINRESULT_PORT_FIELD.number = 5
S2CLOGINRESULT_PORT_FIELD.index = 4
S2CLOGINRESULT_PORT_FIELD.label = 2
S2CLOGINRESULT_PORT_FIELD.has_default_value = false
S2CLOGINRESULT_PORT_FIELD.default_value = 0
S2CLOGINRESULT_PORT_FIELD.type = 13
S2CLOGINRESULT_PORT_FIELD.cpp_type = 3

S2CLOGINRESULT_GAMEID_FIELD.name = "gameid"
S2CLOGINRESULT_GAMEID_FIELD.full_name = ".net_protocol.S2CLoginResult.gameid"
S2CLOGINRESULT_GAMEID_FIELD.number = 6
S2CLOGINRESULT_GAMEID_FIELD.index = 5
S2CLOGINRESULT_GAMEID_FIELD.label = 2
S2CLOGINRESULT_GAMEID_FIELD.has_default_value = false
S2CLOGINRESULT_GAMEID_FIELD.default_value = 0
S2CLOGINRESULT_GAMEID_FIELD.type = 13
S2CLOGINRESULT_GAMEID_FIELD.cpp_type = 3

S2CLOGINRESULT.name = "S2CLoginResult"
S2CLOGINRESULT.full_name = ".net_protocol.S2CLoginResult"
S2CLOGINRESULT.nested_types = {}
S2CLOGINRESULT.enum_types = {S2CLOGINRESULT_RESULT}
S2CLOGINRESULT.fields = {S2CLOGINRESULT_REULST_FIELD, S2CLOGINRESULT_INIT_USER_NAME_FIELD, S2CLOGINRESULT_USER_PWD_FIELD, S2CLOGINRESULT_IP_FIELD, S2CLOGINRESULT_PORT_FIELD, S2CLOGINRESULT_GAMEID_FIELD}
S2CLOGINRESULT.is_extendable = false
S2CLOGINRESULT.extensions = {}
S2CKICKROLE_KICKREASON_LOGIN_ON_OTHER_PLACE_ENUM.name = "LOGIN_ON_OTHER_PLACE"
S2CKICKROLE_KICKREASON_LOGIN_ON_OTHER_PLACE_ENUM.index = 0
S2CKICKROLE_KICKREASON_LOGIN_ON_OTHER_PLACE_ENUM.number = 0
S2CKICKROLE_KICKREASON.name = "KickReason"
S2CKICKROLE_KICKREASON.full_name = ".net_protocol.S2CKickRole.KickReason"
S2CKICKROLE_KICKREASON.values = {S2CKICKROLE_KICKREASON_LOGIN_ON_OTHER_PLACE_ENUM}
S2CKICKROLE_REASON_FIELD.name = "reason"
S2CKICKROLE_REASON_FIELD.full_name = ".net_protocol.S2CKickRole.reason"
S2CKICKROLE_REASON_FIELD.number = 1
S2CKICKROLE_REASON_FIELD.index = 0
S2CKICKROLE_REASON_FIELD.label = 2
S2CKICKROLE_REASON_FIELD.has_default_value = true
S2CKICKROLE_REASON_FIELD.default_value = LOGIN_ON_OTHER_PLACE
S2CKICKROLE_REASON_FIELD.enum_type = S2CKICKROLE.KICKREASON
S2CKICKROLE_REASON_FIELD.type = 14
S2CKICKROLE_REASON_FIELD.cpp_type = 8

S2CKICKROLE.name = "S2CKickRole"
S2CKICKROLE.full_name = ".net_protocol.S2CKickRole"
S2CKICKROLE.nested_types = {}
S2CKICKROLE.enum_types = {S2CKICKROLE_KICKREASON}
S2CKICKROLE.fields = {S2CKICKROLE_REASON_FIELD}
S2CKICKROLE.is_extendable = false
S2CKICKROLE.extensions = {}
BATTERY_INFO_ID_FIELD.name = "id"
BATTERY_INFO_ID_FIELD.full_name = ".net_protocol.battery_info.id"
BATTERY_INFO_ID_FIELD.number = 1
BATTERY_INFO_ID_FIELD.index = 0
BATTERY_INFO_ID_FIELD.label = 2
BATTERY_INFO_ID_FIELD.has_default_value = false
BATTERY_INFO_ID_FIELD.default_value = 0
BATTERY_INFO_ID_FIELD.type = 13
BATTERY_INFO_ID_FIELD.cpp_type = 3

BATTERY_INFO_END_TIME_FIELD.name = "end_time"
BATTERY_INFO_END_TIME_FIELD.full_name = ".net_protocol.battery_info.end_time"
BATTERY_INFO_END_TIME_FIELD.number = 2
BATTERY_INFO_END_TIME_FIELD.index = 1
BATTERY_INFO_END_TIME_FIELD.label = 2
BATTERY_INFO_END_TIME_FIELD.has_default_value = false
BATTERY_INFO_END_TIME_FIELD.default_value = 0
BATTERY_INFO_END_TIME_FIELD.type = 13
BATTERY_INFO_END_TIME_FIELD.cpp_type = 3

BATTERY_INFO.name = "battery_info"
BATTERY_INFO.full_name = ".net_protocol.battery_info"
BATTERY_INFO.nested_types = {}
BATTERY_INFO.enum_types = {}
BATTERY_INFO.fields = {BATTERY_INFO_ID_FIELD, BATTERY_INFO_END_TIME_FIELD}
BATTERY_INFO.is_extendable = false
BATTERY_INFO.extensions = {}
S2CENTERGAME_ROLE_ID_FIELD.name = "role_id"
S2CENTERGAME_ROLE_ID_FIELD.full_name = ".net_protocol.S2CEnterGame.role_id"
S2CENTERGAME_ROLE_ID_FIELD.number = 1
S2CENTERGAME_ROLE_ID_FIELD.index = 0
S2CENTERGAME_ROLE_ID_FIELD.label = 2
S2CENTERGAME_ROLE_ID_FIELD.has_default_value = false
S2CENTERGAME_ROLE_ID_FIELD.default_value = 0
S2CENTERGAME_ROLE_ID_FIELD.type = 13
S2CENTERGAME_ROLE_ID_FIELD.cpp_type = 3

S2CENTERGAME_LEVEL_FIELD.name = "level"
S2CENTERGAME_LEVEL_FIELD.full_name = ".net_protocol.S2CEnterGame.level"
S2CENTERGAME_LEVEL_FIELD.number = 2
S2CENTERGAME_LEVEL_FIELD.index = 1
S2CENTERGAME_LEVEL_FIELD.label = 2
S2CENTERGAME_LEVEL_FIELD.has_default_value = false
S2CENTERGAME_LEVEL_FIELD.default_value = 0
S2CENTERGAME_LEVEL_FIELD.type = 13
S2CENTERGAME_LEVEL_FIELD.cpp_type = 3

S2CENTERGAME_EXP_FIELD.name = "exp"
S2CENTERGAME_EXP_FIELD.full_name = ".net_protocol.S2CEnterGame.exp"
S2CENTERGAME_EXP_FIELD.number = 3
S2CENTERGAME_EXP_FIELD.index = 2
S2CENTERGAME_EXP_FIELD.label = 2
S2CENTERGAME_EXP_FIELD.has_default_value = false
S2CENTERGAME_EXP_FIELD.default_value = 0
S2CENTERGAME_EXP_FIELD.type = 13
S2CENTERGAME_EXP_FIELD.cpp_type = 3

S2CENTERGAME_VIP_LEVEL_FIELD.name = "vip_level"
S2CENTERGAME_VIP_LEVEL_FIELD.full_name = ".net_protocol.S2CEnterGame.vip_level"
S2CENTERGAME_VIP_LEVEL_FIELD.number = 4
S2CENTERGAME_VIP_LEVEL_FIELD.index = 3
S2CENTERGAME_VIP_LEVEL_FIELD.label = 2
S2CENTERGAME_VIP_LEVEL_FIELD.has_default_value = false
S2CENTERGAME_VIP_LEVEL_FIELD.default_value = 0
S2CENTERGAME_VIP_LEVEL_FIELD.type = 13
S2CENTERGAME_VIP_LEVEL_FIELD.cpp_type = 3

S2CENTERGAME_NAME_FIELD.name = "name"
S2CENTERGAME_NAME_FIELD.full_name = ".net_protocol.S2CEnterGame.name"
S2CENTERGAME_NAME_FIELD.number = 5
S2CENTERGAME_NAME_FIELD.index = 4
S2CENTERGAME_NAME_FIELD.label = 2
S2CENTERGAME_NAME_FIELD.has_default_value = false
S2CENTERGAME_NAME_FIELD.default_value = ""
S2CENTERGAME_NAME_FIELD.type = 9
S2CENTERGAME_NAME_FIELD.cpp_type = 9

S2CENTERGAME_GOLD_FIELD.name = "gold"
S2CENTERGAME_GOLD_FIELD.full_name = ".net_protocol.S2CEnterGame.gold"
S2CENTERGAME_GOLD_FIELD.number = 6
S2CENTERGAME_GOLD_FIELD.index = 5
S2CENTERGAME_GOLD_FIELD.label = 2
S2CENTERGAME_GOLD_FIELD.has_default_value = false
S2CENTERGAME_GOLD_FIELD.default_value = 0
S2CENTERGAME_GOLD_FIELD.type = 13
S2CENTERGAME_GOLD_FIELD.cpp_type = 3

S2CENTERGAME_DIAMOND_FIELD.name = "diamond"
S2CENTERGAME_DIAMOND_FIELD.full_name = ".net_protocol.S2CEnterGame.diamond"
S2CENTERGAME_DIAMOND_FIELD.number = 7
S2CENTERGAME_DIAMOND_FIELD.index = 6
S2CENTERGAME_DIAMOND_FIELD.label = 2
S2CENTERGAME_DIAMOND_FIELD.has_default_value = false
S2CENTERGAME_DIAMOND_FIELD.default_value = 0
S2CENTERGAME_DIAMOND_FIELD.type = 13
S2CENTERGAME_DIAMOND_FIELD.cpp_type = 3

S2CENTERGAME_HEAD_ID_FIELD.name = "head_id"
S2CENTERGAME_HEAD_ID_FIELD.full_name = ".net_protocol.S2CEnterGame.head_id"
S2CENTERGAME_HEAD_ID_FIELD.number = 8
S2CENTERGAME_HEAD_ID_FIELD.index = 7
S2CENTERGAME_HEAD_ID_FIELD.label = 2
S2CENTERGAME_HEAD_ID_FIELD.has_default_value = false
S2CENTERGAME_HEAD_ID_FIELD.default_value = 0
S2CENTERGAME_HEAD_ID_FIELD.type = 13
S2CENTERGAME_HEAD_ID_FIELD.cpp_type = 3

S2CENTERGAME_CANNON_MULTIPLE_FIELD.name = "cannon_multiple"
S2CENTERGAME_CANNON_MULTIPLE_FIELD.full_name = ".net_protocol.S2CEnterGame.cannon_multiple"
S2CENTERGAME_CANNON_MULTIPLE_FIELD.number = 9
S2CENTERGAME_CANNON_MULTIPLE_FIELD.index = 8
S2CENTERGAME_CANNON_MULTIPLE_FIELD.label = 2
S2CENTERGAME_CANNON_MULTIPLE_FIELD.has_default_value = false
S2CENTERGAME_CANNON_MULTIPLE_FIELD.default_value = 0
S2CENTERGAME_CANNON_MULTIPLE_FIELD.type = 13
S2CENTERGAME_CANNON_MULTIPLE_FIELD.cpp_type = 3

S2CENTERGAME_BATTERY_ID_FIELD.name = "battery_id"
S2CENTERGAME_BATTERY_ID_FIELD.full_name = ".net_protocol.S2CEnterGame.battery_id"
S2CENTERGAME_BATTERY_ID_FIELD.number = 10
S2CENTERGAME_BATTERY_ID_FIELD.index = 9
S2CENTERGAME_BATTERY_ID_FIELD.label = 2
S2CENTERGAME_BATTERY_ID_FIELD.has_default_value = false
S2CENTERGAME_BATTERY_ID_FIELD.default_value = 0
S2CENTERGAME_BATTERY_ID_FIELD.type = 13
S2CENTERGAME_BATTERY_ID_FIELD.cpp_type = 3

S2CENTERGAME_BATTERY_LEVEL_FIELD.name = "battery_level"
S2CENTERGAME_BATTERY_LEVEL_FIELD.full_name = ".net_protocol.S2CEnterGame.battery_level"
S2CENTERGAME_BATTERY_LEVEL_FIELD.number = 11
S2CENTERGAME_BATTERY_LEVEL_FIELD.index = 10
S2CENTERGAME_BATTERY_LEVEL_FIELD.label = 2
S2CENTERGAME_BATTERY_LEVEL_FIELD.has_default_value = false
S2CENTERGAME_BATTERY_LEVEL_FIELD.default_value = 0
S2CENTERGAME_BATTERY_LEVEL_FIELD.type = 13
S2CENTERGAME_BATTERY_LEVEL_FIELD.cpp_type = 3

S2CENTERGAME_BATTERY_IDS_FIELD.name = "battery_ids"
S2CENTERGAME_BATTERY_IDS_FIELD.full_name = ".net_protocol.S2CEnterGame.battery_ids"
S2CENTERGAME_BATTERY_IDS_FIELD.number = 12
S2CENTERGAME_BATTERY_IDS_FIELD.index = 11
S2CENTERGAME_BATTERY_IDS_FIELD.label = 3
S2CENTERGAME_BATTERY_IDS_FIELD.has_default_value = false
S2CENTERGAME_BATTERY_IDS_FIELD.default_value = {}
S2CENTERGAME_BATTERY_IDS_FIELD.type = 13
S2CENTERGAME_BATTERY_IDS_FIELD.cpp_type = 3

S2CENTERGAME_SKILL_IDS_FIELD.name = "skill_ids"
S2CENTERGAME_SKILL_IDS_FIELD.full_name = ".net_protocol.S2CEnterGame.skill_ids"
S2CENTERGAME_SKILL_IDS_FIELD.number = 13
S2CENTERGAME_SKILL_IDS_FIELD.index = 12
S2CENTERGAME_SKILL_IDS_FIELD.label = 3
S2CENTERGAME_SKILL_IDS_FIELD.has_default_value = false
S2CENTERGAME_SKILL_IDS_FIELD.default_value = {}
S2CENTERGAME_SKILL_IDS_FIELD.type = 13
S2CENTERGAME_SKILL_IDS_FIELD.cpp_type = 3

S2CENTERGAME_CONSORTIA_ID_FIELD.name = "consortia_id"
S2CENTERGAME_CONSORTIA_ID_FIELD.full_name = ".net_protocol.S2CEnterGame.consortia_id"
S2CENTERGAME_CONSORTIA_ID_FIELD.number = 14
S2CENTERGAME_CONSORTIA_ID_FIELD.index = 13
S2CENTERGAME_CONSORTIA_ID_FIELD.label = 2
S2CENTERGAME_CONSORTIA_ID_FIELD.has_default_value = false
S2CENTERGAME_CONSORTIA_ID_FIELD.default_value = 0
S2CENTERGAME_CONSORTIA_ID_FIELD.type = 13
S2CENTERGAME_CONSORTIA_ID_FIELD.cpp_type = 3

S2CENTERGAME_CONSORTIA_NAME_FIELD.name = "consortia_name"
S2CENTERGAME_CONSORTIA_NAME_FIELD.full_name = ".net_protocol.S2CEnterGame.consortia_name"
S2CENTERGAME_CONSORTIA_NAME_FIELD.number = 15
S2CENTERGAME_CONSORTIA_NAME_FIELD.index = 14
S2CENTERGAME_CONSORTIA_NAME_FIELD.label = 2
S2CENTERGAME_CONSORTIA_NAME_FIELD.has_default_value = false
S2CENTERGAME_CONSORTIA_NAME_FIELD.default_value = ""
S2CENTERGAME_CONSORTIA_NAME_FIELD.type = 9
S2CENTERGAME_CONSORTIA_NAME_FIELD.cpp_type = 9

S2CENTERGAME_GENDER_FIELD.name = "gender"
S2CENTERGAME_GENDER_FIELD.full_name = ".net_protocol.S2CEnterGame.gender"
S2CENTERGAME_GENDER_FIELD.number = 16
S2CENTERGAME_GENDER_FIELD.index = 15
S2CENTERGAME_GENDER_FIELD.label = 2
S2CENTERGAME_GENDER_FIELD.has_default_value = false
S2CENTERGAME_GENDER_FIELD.default_value = 0
S2CENTERGAME_GENDER_FIELD.type = 13
S2CENTERGAME_GENDER_FIELD.cpp_type = 3

S2CENTERGAME_BATTERY_RATE_FIELD.name = "battery_rate"
S2CENTERGAME_BATTERY_RATE_FIELD.full_name = ".net_protocol.S2CEnterGame.battery_rate"
S2CENTERGAME_BATTERY_RATE_FIELD.number = 17
S2CENTERGAME_BATTERY_RATE_FIELD.index = 16
S2CENTERGAME_BATTERY_RATE_FIELD.label = 2
S2CENTERGAME_BATTERY_RATE_FIELD.has_default_value = false
S2CENTERGAME_BATTERY_RATE_FIELD.default_value = 0
S2CENTERGAME_BATTERY_RATE_FIELD.type = 13
S2CENTERGAME_BATTERY_RATE_FIELD.cpp_type = 3

S2CENTERGAME_IS_NAME_FIELD.name = "is_name"
S2CENTERGAME_IS_NAME_FIELD.full_name = ".net_protocol.S2CEnterGame.is_name"
S2CENTERGAME_IS_NAME_FIELD.number = 18
S2CENTERGAME_IS_NAME_FIELD.index = 17
S2CENTERGAME_IS_NAME_FIELD.label = 2
S2CENTERGAME_IS_NAME_FIELD.has_default_value = false
S2CENTERGAME_IS_NAME_FIELD.default_value = 0
S2CENTERGAME_IS_NAME_FIELD.type = 13
S2CENTERGAME_IS_NAME_FIELD.cpp_type = 3

S2CENTERGAME_IS_GENDER_FIELD.name = "is_gender"
S2CENTERGAME_IS_GENDER_FIELD.full_name = ".net_protocol.S2CEnterGame.is_gender"
S2CENTERGAME_IS_GENDER_FIELD.number = 19
S2CENTERGAME_IS_GENDER_FIELD.index = 18
S2CENTERGAME_IS_GENDER_FIELD.label = 2
S2CENTERGAME_IS_GENDER_FIELD.has_default_value = false
S2CENTERGAME_IS_GENDER_FIELD.default_value = 0
S2CENTERGAME_IS_GENDER_FIELD.type = 13
S2CENTERGAME_IS_GENDER_FIELD.cpp_type = 3

S2CENTERGAME_DAILY_ASS_FIELD.name = "daily_Ass"
S2CENTERGAME_DAILY_ASS_FIELD.full_name = ".net_protocol.S2CEnterGame.daily_Ass"
S2CENTERGAME_DAILY_ASS_FIELD.number = 20
S2CENTERGAME_DAILY_ASS_FIELD.index = 19
S2CENTERGAME_DAILY_ASS_FIELD.label = 2
S2CENTERGAME_DAILY_ASS_FIELD.has_default_value = false
S2CENTERGAME_DAILY_ASS_FIELD.default_value = 0
S2CENTERGAME_DAILY_ASS_FIELD.type = 13
S2CENTERGAME_DAILY_ASS_FIELD.cpp_type = 3

S2CENTERGAME_SP_FIELD.name = "sp"
S2CENTERGAME_SP_FIELD.full_name = ".net_protocol.S2CEnterGame.sp"
S2CENTERGAME_SP_FIELD.number = 21
S2CENTERGAME_SP_FIELD.index = 20
S2CENTERGAME_SP_FIELD.label = 2
S2CENTERGAME_SP_FIELD.has_default_value = false
S2CENTERGAME_SP_FIELD.default_value = 0
S2CENTERGAME_SP_FIELD.type = 13
S2CENTERGAME_SP_FIELD.cpp_type = 3

S2CENTERGAME_USER_NAME_FIELD.name = "user_name"
S2CENTERGAME_USER_NAME_FIELD.full_name = ".net_protocol.S2CEnterGame.user_name"
S2CENTERGAME_USER_NAME_FIELD.number = 22
S2CENTERGAME_USER_NAME_FIELD.index = 21
S2CENTERGAME_USER_NAME_FIELD.label = 2
S2CENTERGAME_USER_NAME_FIELD.has_default_value = false
S2CENTERGAME_USER_NAME_FIELD.default_value = ""
S2CENTERGAME_USER_NAME_FIELD.type = 9
S2CENTERGAME_USER_NAME_FIELD.cpp_type = 9

S2CENTERGAME_BATTERY_LIST_FIELD.name = "battery_list"
S2CENTERGAME_BATTERY_LIST_FIELD.full_name = ".net_protocol.S2CEnterGame.battery_list"
S2CENTERGAME_BATTERY_LIST_FIELD.number = 23
S2CENTERGAME_BATTERY_LIST_FIELD.index = 22
S2CENTERGAME_BATTERY_LIST_FIELD.label = 3
S2CENTERGAME_BATTERY_LIST_FIELD.has_default_value = false
S2CENTERGAME_BATTERY_LIST_FIELD.default_value = {}
S2CENTERGAME_BATTERY_LIST_FIELD.message_type = BATTERY_INFO
S2CENTERGAME_BATTERY_LIST_FIELD.type = 11
S2CENTERGAME_BATTERY_LIST_FIELD.cpp_type = 10

S2CENTERGAME.name = "S2CEnterGame"
S2CENTERGAME.full_name = ".net_protocol.S2CEnterGame"
S2CENTERGAME.nested_types = {}
S2CENTERGAME.enum_types = {}
S2CENTERGAME.fields = {S2CENTERGAME_ROLE_ID_FIELD, S2CENTERGAME_LEVEL_FIELD, S2CENTERGAME_EXP_FIELD, S2CENTERGAME_VIP_LEVEL_FIELD, S2CENTERGAME_NAME_FIELD, S2CENTERGAME_GOLD_FIELD, S2CENTERGAME_DIAMOND_FIELD, S2CENTERGAME_HEAD_ID_FIELD, S2CENTERGAME_CANNON_MULTIPLE_FIELD, S2CENTERGAME_BATTERY_ID_FIELD, S2CENTERGAME_BATTERY_LEVEL_FIELD, S2CENTERGAME_BATTERY_IDS_FIELD, S2CENTERGAME_SKILL_IDS_FIELD, S2CENTERGAME_CONSORTIA_ID_FIELD, S2CENTERGAME_CONSORTIA_NAME_FIELD, S2CENTERGAME_GENDER_FIELD, S2CENTERGAME_BATTERY_RATE_FIELD, S2CENTERGAME_IS_NAME_FIELD, S2CENTERGAME_IS_GENDER_FIELD, S2CENTERGAME_DAILY_ASS_FIELD, S2CENTERGAME_SP_FIELD, S2CENTERGAME_USER_NAME_FIELD, S2CENTERGAME_BATTERY_LIST_FIELD}
S2CENTERGAME.is_extendable = false
S2CENTERGAME.extensions = {}
S2CHEARTBEAT_TIME_FIELD.name = "time"
S2CHEARTBEAT_TIME_FIELD.full_name = ".net_protocol.S2CHeartBeat.time"
S2CHEARTBEAT_TIME_FIELD.number = 1
S2CHEARTBEAT_TIME_FIELD.index = 0
S2CHEARTBEAT_TIME_FIELD.label = 2
S2CHEARTBEAT_TIME_FIELD.has_default_value = false
S2CHEARTBEAT_TIME_FIELD.default_value = 0
S2CHEARTBEAT_TIME_FIELD.type = 13
S2CHEARTBEAT_TIME_FIELD.cpp_type = 3

S2CHEARTBEAT.name = "S2CHeartBeat"
S2CHEARTBEAT.full_name = ".net_protocol.S2CHeartBeat"
S2CHEARTBEAT.nested_types = {}
S2CHEARTBEAT.enum_types = {}
S2CHEARTBEAT.fields = {S2CHEARTBEAT_TIME_FIELD}
S2CHEARTBEAT.is_extendable = false
S2CHEARTBEAT.extensions = {}
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.name = "role_id"
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.full_name = ".net_protocol.CS2CRoleInfoUpdate.role_id"
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.number = 1
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.index = 0
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.label = 2
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.has_default_value = false
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.default_value = 0
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.type = 13
CS2CROLEINFOUPDATE_ROLE_ID_FIELD.cpp_type = 3

CS2CROLEINFOUPDATE_TYPE_FIELD.name = "type"
CS2CROLEINFOUPDATE_TYPE_FIELD.full_name = ".net_protocol.CS2CRoleInfoUpdate.type"
CS2CROLEINFOUPDATE_TYPE_FIELD.number = 2
CS2CROLEINFOUPDATE_TYPE_FIELD.index = 1
CS2CROLEINFOUPDATE_TYPE_FIELD.label = 2
CS2CROLEINFOUPDATE_TYPE_FIELD.has_default_value = false
CS2CROLEINFOUPDATE_TYPE_FIELD.default_value = 0
CS2CROLEINFOUPDATE_TYPE_FIELD.type = 13
CS2CROLEINFOUPDATE_TYPE_FIELD.cpp_type = 3

CS2CROLEINFOUPDATE_RET_FIELD.name = "ret"
CS2CROLEINFOUPDATE_RET_FIELD.full_name = ".net_protocol.CS2CRoleInfoUpdate.ret"
CS2CROLEINFOUPDATE_RET_FIELD.number = 3
CS2CROLEINFOUPDATE_RET_FIELD.index = 2
CS2CROLEINFOUPDATE_RET_FIELD.label = 2
CS2CROLEINFOUPDATE_RET_FIELD.has_default_value = false
CS2CROLEINFOUPDATE_RET_FIELD.default_value = 0
CS2CROLEINFOUPDATE_RET_FIELD.type = 13
CS2CROLEINFOUPDATE_RET_FIELD.cpp_type = 3

CS2CROLEINFOUPDATE.name = "CS2CRoleInfoUpdate"
CS2CROLEINFOUPDATE.full_name = ".net_protocol.CS2CRoleInfoUpdate"
CS2CROLEINFOUPDATE.nested_types = {}
CS2CROLEINFOUPDATE.enum_types = {}
CS2CROLEINFOUPDATE.fields = {CS2CROLEINFOUPDATE_ROLE_ID_FIELD, CS2CROLEINFOUPDATE_TYPE_FIELD, CS2CROLEINFOUPDATE_RET_FIELD}
CS2CROLEINFOUPDATE.is_extendable = false
CS2CROLEINFOUPDATE.extensions = {}
PARAMLIST_ID_FIELD.name = "id"
PARAMLIST_ID_FIELD.full_name = ".net_protocol.ParamList.id"
PARAMLIST_ID_FIELD.number = 1
PARAMLIST_ID_FIELD.index = 0
PARAMLIST_ID_FIELD.label = 2
PARAMLIST_ID_FIELD.has_default_value = false
PARAMLIST_ID_FIELD.default_value = 0
PARAMLIST_ID_FIELD.type = 13
PARAMLIST_ID_FIELD.cpp_type = 3

PARAMLIST_PARAM_FIELD.name = "param"
PARAMLIST_PARAM_FIELD.full_name = ".net_protocol.ParamList.param"
PARAMLIST_PARAM_FIELD.number = 2
PARAMLIST_PARAM_FIELD.index = 1
PARAMLIST_PARAM_FIELD.label = 2
PARAMLIST_PARAM_FIELD.has_default_value = false
PARAMLIST_PARAM_FIELD.default_value = ""
PARAMLIST_PARAM_FIELD.type = 9
PARAMLIST_PARAM_FIELD.cpp_type = 9

PARAMLIST.name = "ParamList"
PARAMLIST.full_name = ".net_protocol.ParamList"
PARAMLIST.nested_types = {}
PARAMLIST.enum_types = {}
PARAMLIST.fields = {PARAMLIST_ID_FIELD, PARAMLIST_PARAM_FIELD}
PARAMLIST.is_extendable = false
PARAMLIST.extensions = {}
S2CCODENOTICE_CODETYPE_ERROR_CODE_ENUM.name = "ERROR_CODE"
S2CCODENOTICE_CODETYPE_ERROR_CODE_ENUM.index = 0
S2CCODENOTICE_CODETYPE_ERROR_CODE_ENUM.number = 0
S2CCODENOTICE_CODETYPE_NOTICE_CODE_ENUM.name = "NOTICE_CODE"
S2CCODENOTICE_CODETYPE_NOTICE_CODE_ENUM.index = 1
S2CCODENOTICE_CODETYPE_NOTICE_CODE_ENUM.number = 1
S2CCODENOTICE_CODETYPE.name = "CodeType"
S2CCODENOTICE_CODETYPE.full_name = ".net_protocol.S2CCodeNotice.CodeType"
S2CCODENOTICE_CODETYPE.values = {S2CCODENOTICE_CODETYPE_ERROR_CODE_ENUM,S2CCODENOTICE_CODETYPE_NOTICE_CODE_ENUM}
S2CCODENOTICE_CODE_ID_FIELD.name = "code_id"
S2CCODENOTICE_CODE_ID_FIELD.full_name = ".net_protocol.S2CCodeNotice.code_id"
S2CCODENOTICE_CODE_ID_FIELD.number = 1
S2CCODENOTICE_CODE_ID_FIELD.index = 0
S2CCODENOTICE_CODE_ID_FIELD.label = 2
S2CCODENOTICE_CODE_ID_FIELD.has_default_value = false
S2CCODENOTICE_CODE_ID_FIELD.default_value = 0
S2CCODENOTICE_CODE_ID_FIELD.type = 13
S2CCODENOTICE_CODE_ID_FIELD.cpp_type = 3

S2CCODENOTICE_CODE_TYPE_FIELD.name = "code_type"
S2CCODENOTICE_CODE_TYPE_FIELD.full_name = ".net_protocol.S2CCodeNotice.code_type"
S2CCODENOTICE_CODE_TYPE_FIELD.number = 2
S2CCODENOTICE_CODE_TYPE_FIELD.index = 1
S2CCODENOTICE_CODE_TYPE_FIELD.label = 2
S2CCODENOTICE_CODE_TYPE_FIELD.has_default_value = false
S2CCODENOTICE_CODE_TYPE_FIELD.default_value = nil
S2CCODENOTICE_CODE_TYPE_FIELD.enum_type = S2CCODENOTICE.CODETYPE
S2CCODENOTICE_CODE_TYPE_FIELD.type = 14
S2CCODENOTICE_CODE_TYPE_FIELD.cpp_type = 8

S2CCODENOTICE_LIST_FIELD.name = "list"
S2CCODENOTICE_LIST_FIELD.full_name = ".net_protocol.S2CCodeNotice.list"
S2CCODENOTICE_LIST_FIELD.number = 3
S2CCODENOTICE_LIST_FIELD.index = 2
S2CCODENOTICE_LIST_FIELD.label = 3
S2CCODENOTICE_LIST_FIELD.has_default_value = false
S2CCODENOTICE_LIST_FIELD.default_value = {}
S2CCODENOTICE_LIST_FIELD.message_type = PARAMLIST
S2CCODENOTICE_LIST_FIELD.type = 11
S2CCODENOTICE_LIST_FIELD.cpp_type = 10

S2CCODENOTICE.name = "S2CCodeNotice"
S2CCODENOTICE.full_name = ".net_protocol.S2CCodeNotice"
S2CCODENOTICE.nested_types = {}
S2CCODENOTICE.enum_types = {S2CCODENOTICE_CODETYPE}
S2CCODENOTICE.fields = {S2CCODENOTICE_CODE_ID_FIELD, S2CCODENOTICE_CODE_TYPE_FIELD, S2CCODENOTICE_LIST_FIELD}
S2CCODENOTICE.is_extendable = false
S2CCODENOTICE.extensions = {}
CS2CUSERLOGINACK_ACK_FIELD.name = "ack"
CS2CUSERLOGINACK_ACK_FIELD.full_name = ".net_protocol.CS2CUserLoginAck.ack"
CS2CUSERLOGINACK_ACK_FIELD.number = 1
CS2CUSERLOGINACK_ACK_FIELD.index = 0
CS2CUSERLOGINACK_ACK_FIELD.label = 2
CS2CUSERLOGINACK_ACK_FIELD.has_default_value = false
CS2CUSERLOGINACK_ACK_FIELD.default_value = 0
CS2CUSERLOGINACK_ACK_FIELD.type = 13
CS2CUSERLOGINACK_ACK_FIELD.cpp_type = 3

CS2CUSERLOGINACK.name = "CS2CUserLoginAck"
CS2CUSERLOGINACK.full_name = ".net_protocol.CS2CUserLoginAck"
CS2CUSERLOGINACK.nested_types = {}
CS2CUSERLOGINACK.enum_types = {}
CS2CUSERLOGINACK.fields = {CS2CUSERLOGINACK_ACK_FIELD}
CS2CUSERLOGINACK.is_extendable = false
CS2CUSERLOGINACK.extensions = {}

CS2CRoleInfoUpdate = protobuf.Message(CS2CROLEINFOUPDATE)
CS2CUserLoginAck = protobuf.Message(CS2CUSERLOGINACK)
ParamList = protobuf.Message(PARAMLIST)
S2CCodeNotice = protobuf.Message(S2CCODENOTICE)
S2CEnterGame = protobuf.Message(S2CENTERGAME)
S2CHeartBeat = protobuf.Message(S2CHEARTBEAT)
S2CKickRole = protobuf.Message(S2CKICKROLE)
S2CLoginResult = protobuf.Message(S2CLOGINRESULT)
S2CRegisterResult = protobuf.Message(S2CREGISTERRESULT)
battery_info = protobuf.Message(BATTERY_INFO)
