-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_SC_Attr_pb')


S2CATTRSETHEADIDRET = protobuf.Descriptor();
local S2CATTRSETHEADIDRET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETHEADIDRET_ID_FIELD = protobuf.FieldDescriptor();
S2CATTRSETNAMERET = protobuf.Descriptor();
local S2CATTRSETNAMERET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETNAMERET_NAME_FIELD = protobuf.FieldDescriptor();
S2CATTRSETGENDERRET = protobuf.Descriptor();
local S2CATTRSETGENDERRET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETGENDERRET_TYPE_FIELD = protobuf.FieldDescriptor();
S2CATTRSETBATTERYIDRET = protobuf.Descriptor();
local S2CATTRSETBATTERYIDRET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETBATTERYIDRET_ID_FIELD = protobuf.FieldDescriptor();
S2CATTRSETBATTERYLEVELRET = protobuf.Descriptor();
local S2CATTRSETBATTERYLEVELRET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETBATTERYLEVELRET_ID_FIELD = protobuf.FieldDescriptor();
S2CATTRSETBATTERYRATERET = protobuf.Descriptor();
local S2CATTRSETBATTERYRATERET_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRSETBATTERYRATERET_LV_FIELD = protobuf.FieldDescriptor();
S2CATTRGETROLEINFORET = protobuf.Descriptor();
local S2CATTRGETROLEINFORET_USER_NAME_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_EXP_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_NAME_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_GOLD_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_DIAMOND_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_HEAD_ID_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_BATTERY_ID_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETROLEINFORET_GENDER_FIELD = protobuf.FieldDescriptor();
SYN_ITEM = protobuf.Descriptor();
local SYN_ITEM_KEY_FIELD = protobuf.FieldDescriptor();
local SYN_ITEM_VAL_FIELD = protobuf.FieldDescriptor();
S2CATTRSYNCROLE = protobuf.Descriptor();
local S2CATTRSYNCROLE_ITEM_FIELD = protobuf.FieldDescriptor();
S2CATTRGETDAILYASS = protobuf.Descriptor();
local S2CATTRGETDAILYASS_RET_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETDAILYASS_GOLD_FIELD = protobuf.FieldDescriptor();
local S2CATTRGETDAILYASS_DAILY_ASS_FIELD = protobuf.FieldDescriptor();
BATTERY = protobuf.Descriptor();
local BATTERY_ID_FIELD = protobuf.FieldDescriptor();
local BATTERY_END_TIME_FIELD = protobuf.FieldDescriptor();
S2CATTRUNLOCKBATTERY = protobuf.Descriptor();
local S2CATTRUNLOCKBATTERY_LIST_FIELD = protobuf.FieldDescriptor();
S2CATTRENTERROOM2 = protobuf.Descriptor();

S2CATTRSETHEADIDRET_RET_FIELD.name = "ret"
S2CATTRSETHEADIDRET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetHeadIdRet.ret"
S2CATTRSETHEADIDRET_RET_FIELD.number = 1
S2CATTRSETHEADIDRET_RET_FIELD.index = 0
S2CATTRSETHEADIDRET_RET_FIELD.label = 2
S2CATTRSETHEADIDRET_RET_FIELD.has_default_value = false
S2CATTRSETHEADIDRET_RET_FIELD.default_value = 0
S2CATTRSETHEADIDRET_RET_FIELD.type = 13
S2CATTRSETHEADIDRET_RET_FIELD.cpp_type = 3

S2CATTRSETHEADIDRET_ID_FIELD.name = "id"
S2CATTRSETHEADIDRET_ID_FIELD.full_name = ".net_protocol.S2CAttrSetHeadIdRet.id"
S2CATTRSETHEADIDRET_ID_FIELD.number = 2
S2CATTRSETHEADIDRET_ID_FIELD.index = 1
S2CATTRSETHEADIDRET_ID_FIELD.label = 1
S2CATTRSETHEADIDRET_ID_FIELD.has_default_value = false
S2CATTRSETHEADIDRET_ID_FIELD.default_value = 0
S2CATTRSETHEADIDRET_ID_FIELD.type = 13
S2CATTRSETHEADIDRET_ID_FIELD.cpp_type = 3

S2CATTRSETHEADIDRET.name = "S2CAttrSetHeadIdRet"
S2CATTRSETHEADIDRET.full_name = ".net_protocol.S2CAttrSetHeadIdRet"
S2CATTRSETHEADIDRET.nested_types = {}
S2CATTRSETHEADIDRET.enum_types = {}
S2CATTRSETHEADIDRET.fields = {S2CATTRSETHEADIDRET_RET_FIELD, S2CATTRSETHEADIDRET_ID_FIELD}
S2CATTRSETHEADIDRET.is_extendable = false
S2CATTRSETHEADIDRET.extensions = {}
S2CATTRSETNAMERET_RET_FIELD.name = "ret"
S2CATTRSETNAMERET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetNameRet.ret"
S2CATTRSETNAMERET_RET_FIELD.number = 1
S2CATTRSETNAMERET_RET_FIELD.index = 0
S2CATTRSETNAMERET_RET_FIELD.label = 2
S2CATTRSETNAMERET_RET_FIELD.has_default_value = false
S2CATTRSETNAMERET_RET_FIELD.default_value = 0
S2CATTRSETNAMERET_RET_FIELD.type = 13
S2CATTRSETNAMERET_RET_FIELD.cpp_type = 3

S2CATTRSETNAMERET_NAME_FIELD.name = "name"
S2CATTRSETNAMERET_NAME_FIELD.full_name = ".net_protocol.S2CAttrSetNameRet.name"
S2CATTRSETNAMERET_NAME_FIELD.number = 2
S2CATTRSETNAMERET_NAME_FIELD.index = 1
S2CATTRSETNAMERET_NAME_FIELD.label = 1
S2CATTRSETNAMERET_NAME_FIELD.has_default_value = false
S2CATTRSETNAMERET_NAME_FIELD.default_value = ""
S2CATTRSETNAMERET_NAME_FIELD.type = 9
S2CATTRSETNAMERET_NAME_FIELD.cpp_type = 9

S2CATTRSETNAMERET.name = "S2CAttrSetNameRet"
S2CATTRSETNAMERET.full_name = ".net_protocol.S2CAttrSetNameRet"
S2CATTRSETNAMERET.nested_types = {}
S2CATTRSETNAMERET.enum_types = {}
S2CATTRSETNAMERET.fields = {S2CATTRSETNAMERET_RET_FIELD, S2CATTRSETNAMERET_NAME_FIELD}
S2CATTRSETNAMERET.is_extendable = false
S2CATTRSETNAMERET.extensions = {}
S2CATTRSETGENDERRET_RET_FIELD.name = "ret"
S2CATTRSETGENDERRET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetGenderRet.ret"
S2CATTRSETGENDERRET_RET_FIELD.number = 1
S2CATTRSETGENDERRET_RET_FIELD.index = 0
S2CATTRSETGENDERRET_RET_FIELD.label = 2
S2CATTRSETGENDERRET_RET_FIELD.has_default_value = false
S2CATTRSETGENDERRET_RET_FIELD.default_value = 0
S2CATTRSETGENDERRET_RET_FIELD.type = 13
S2CATTRSETGENDERRET_RET_FIELD.cpp_type = 3

S2CATTRSETGENDERRET_TYPE_FIELD.name = "type"
S2CATTRSETGENDERRET_TYPE_FIELD.full_name = ".net_protocol.S2CAttrSetGenderRet.type"
S2CATTRSETGENDERRET_TYPE_FIELD.number = 2
S2CATTRSETGENDERRET_TYPE_FIELD.index = 1
S2CATTRSETGENDERRET_TYPE_FIELD.label = 1
S2CATTRSETGENDERRET_TYPE_FIELD.has_default_value = false
S2CATTRSETGENDERRET_TYPE_FIELD.default_value = 0
S2CATTRSETGENDERRET_TYPE_FIELD.type = 13
S2CATTRSETGENDERRET_TYPE_FIELD.cpp_type = 3

S2CATTRSETGENDERRET.name = "S2CAttrSetGenderRet"
S2CATTRSETGENDERRET.full_name = ".net_protocol.S2CAttrSetGenderRet"
S2CATTRSETGENDERRET.nested_types = {}
S2CATTRSETGENDERRET.enum_types = {}
S2CATTRSETGENDERRET.fields = {S2CATTRSETGENDERRET_RET_FIELD, S2CATTRSETGENDERRET_TYPE_FIELD}
S2CATTRSETGENDERRET.is_extendable = false
S2CATTRSETGENDERRET.extensions = {}
S2CATTRSETBATTERYIDRET_RET_FIELD.name = "ret"
S2CATTRSETBATTERYIDRET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryIdRet.ret"
S2CATTRSETBATTERYIDRET_RET_FIELD.number = 1
S2CATTRSETBATTERYIDRET_RET_FIELD.index = 0
S2CATTRSETBATTERYIDRET_RET_FIELD.label = 2
S2CATTRSETBATTERYIDRET_RET_FIELD.has_default_value = false
S2CATTRSETBATTERYIDRET_RET_FIELD.default_value = 0
S2CATTRSETBATTERYIDRET_RET_FIELD.type = 13
S2CATTRSETBATTERYIDRET_RET_FIELD.cpp_type = 3

S2CATTRSETBATTERYIDRET_ID_FIELD.name = "id"
S2CATTRSETBATTERYIDRET_ID_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryIdRet.id"
S2CATTRSETBATTERYIDRET_ID_FIELD.number = 2
S2CATTRSETBATTERYIDRET_ID_FIELD.index = 1
S2CATTRSETBATTERYIDRET_ID_FIELD.label = 1
S2CATTRSETBATTERYIDRET_ID_FIELD.has_default_value = false
S2CATTRSETBATTERYIDRET_ID_FIELD.default_value = 0
S2CATTRSETBATTERYIDRET_ID_FIELD.type = 13
S2CATTRSETBATTERYIDRET_ID_FIELD.cpp_type = 3

S2CATTRSETBATTERYIDRET.name = "S2CAttrSetBatteryIdRet"
S2CATTRSETBATTERYIDRET.full_name = ".net_protocol.S2CAttrSetBatteryIdRet"
S2CATTRSETBATTERYIDRET.nested_types = {}
S2CATTRSETBATTERYIDRET.enum_types = {}
S2CATTRSETBATTERYIDRET.fields = {S2CATTRSETBATTERYIDRET_RET_FIELD, S2CATTRSETBATTERYIDRET_ID_FIELD}
S2CATTRSETBATTERYIDRET.is_extendable = false
S2CATTRSETBATTERYIDRET.extensions = {}
S2CATTRSETBATTERYLEVELRET_RET_FIELD.name = "ret"
S2CATTRSETBATTERYLEVELRET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryLevelRet.ret"
S2CATTRSETBATTERYLEVELRET_RET_FIELD.number = 1
S2CATTRSETBATTERYLEVELRET_RET_FIELD.index = 0
S2CATTRSETBATTERYLEVELRET_RET_FIELD.label = 2
S2CATTRSETBATTERYLEVELRET_RET_FIELD.has_default_value = false
S2CATTRSETBATTERYLEVELRET_RET_FIELD.default_value = 0
S2CATTRSETBATTERYLEVELRET_RET_FIELD.type = 13
S2CATTRSETBATTERYLEVELRET_RET_FIELD.cpp_type = 3

S2CATTRSETBATTERYLEVELRET_ID_FIELD.name = "id"
S2CATTRSETBATTERYLEVELRET_ID_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryLevelRet.id"
S2CATTRSETBATTERYLEVELRET_ID_FIELD.number = 2
S2CATTRSETBATTERYLEVELRET_ID_FIELD.index = 1
S2CATTRSETBATTERYLEVELRET_ID_FIELD.label = 1
S2CATTRSETBATTERYLEVELRET_ID_FIELD.has_default_value = false
S2CATTRSETBATTERYLEVELRET_ID_FIELD.default_value = 0
S2CATTRSETBATTERYLEVELRET_ID_FIELD.type = 13
S2CATTRSETBATTERYLEVELRET_ID_FIELD.cpp_type = 3

S2CATTRSETBATTERYLEVELRET.name = "S2CAttrSetBatteryLevelRet"
S2CATTRSETBATTERYLEVELRET.full_name = ".net_protocol.S2CAttrSetBatteryLevelRet"
S2CATTRSETBATTERYLEVELRET.nested_types = {}
S2CATTRSETBATTERYLEVELRET.enum_types = {}
S2CATTRSETBATTERYLEVELRET.fields = {S2CATTRSETBATTERYLEVELRET_RET_FIELD, S2CATTRSETBATTERYLEVELRET_ID_FIELD}
S2CATTRSETBATTERYLEVELRET.is_extendable = false
S2CATTRSETBATTERYLEVELRET.extensions = {}
S2CATTRSETBATTERYRATERET_RET_FIELD.name = "ret"
S2CATTRSETBATTERYRATERET_RET_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryRateRet.ret"
S2CATTRSETBATTERYRATERET_RET_FIELD.number = 1
S2CATTRSETBATTERYRATERET_RET_FIELD.index = 0
S2CATTRSETBATTERYRATERET_RET_FIELD.label = 2
S2CATTRSETBATTERYRATERET_RET_FIELD.has_default_value = false
S2CATTRSETBATTERYRATERET_RET_FIELD.default_value = 0
S2CATTRSETBATTERYRATERET_RET_FIELD.type = 13
S2CATTRSETBATTERYRATERET_RET_FIELD.cpp_type = 3

S2CATTRSETBATTERYRATERET_LV_FIELD.name = "lv"
S2CATTRSETBATTERYRATERET_LV_FIELD.full_name = ".net_protocol.S2CAttrSetBatteryRateRet.lv"
S2CATTRSETBATTERYRATERET_LV_FIELD.number = 2
S2CATTRSETBATTERYRATERET_LV_FIELD.index = 1
S2CATTRSETBATTERYRATERET_LV_FIELD.label = 1
S2CATTRSETBATTERYRATERET_LV_FIELD.has_default_value = false
S2CATTRSETBATTERYRATERET_LV_FIELD.default_value = 0
S2CATTRSETBATTERYRATERET_LV_FIELD.type = 13
S2CATTRSETBATTERYRATERET_LV_FIELD.cpp_type = 3

S2CATTRSETBATTERYRATERET.name = "S2CAttrSetBatteryRateRet"
S2CATTRSETBATTERYRATERET.full_name = ".net_protocol.S2CAttrSetBatteryRateRet"
S2CATTRSETBATTERYRATERET.nested_types = {}
S2CATTRSETBATTERYRATERET.enum_types = {}
S2CATTRSETBATTERYRATERET.fields = {S2CATTRSETBATTERYRATERET_RET_FIELD, S2CATTRSETBATTERYRATERET_LV_FIELD}
S2CATTRSETBATTERYRATERET.is_extendable = false
S2CATTRSETBATTERYRATERET.extensions = {}
S2CATTRGETROLEINFORET_USER_NAME_FIELD.name = "user_name"
S2CATTRGETROLEINFORET_USER_NAME_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.user_name"
S2CATTRGETROLEINFORET_USER_NAME_FIELD.number = 1
S2CATTRGETROLEINFORET_USER_NAME_FIELD.index = 0
S2CATTRGETROLEINFORET_USER_NAME_FIELD.label = 2
S2CATTRGETROLEINFORET_USER_NAME_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_USER_NAME_FIELD.default_value = ""
S2CATTRGETROLEINFORET_USER_NAME_FIELD.type = 9
S2CATTRGETROLEINFORET_USER_NAME_FIELD.cpp_type = 9

S2CATTRGETROLEINFORET_LEVEL_FIELD.name = "level"
S2CATTRGETROLEINFORET_LEVEL_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.level"
S2CATTRGETROLEINFORET_LEVEL_FIELD.number = 2
S2CATTRGETROLEINFORET_LEVEL_FIELD.index = 1
S2CATTRGETROLEINFORET_LEVEL_FIELD.label = 2
S2CATTRGETROLEINFORET_LEVEL_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_LEVEL_FIELD.default_value = 0
S2CATTRGETROLEINFORET_LEVEL_FIELD.type = 13
S2CATTRGETROLEINFORET_LEVEL_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_EXP_FIELD.name = "exp"
S2CATTRGETROLEINFORET_EXP_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.exp"
S2CATTRGETROLEINFORET_EXP_FIELD.number = 3
S2CATTRGETROLEINFORET_EXP_FIELD.index = 2
S2CATTRGETROLEINFORET_EXP_FIELD.label = 2
S2CATTRGETROLEINFORET_EXP_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_EXP_FIELD.default_value = 0
S2CATTRGETROLEINFORET_EXP_FIELD.type = 13
S2CATTRGETROLEINFORET_EXP_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.name = "vip_level"
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.vip_level"
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.number = 4
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.index = 3
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.label = 2
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.default_value = 0
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.type = 13
S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_NAME_FIELD.name = "name"
S2CATTRGETROLEINFORET_NAME_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.name"
S2CATTRGETROLEINFORET_NAME_FIELD.number = 5
S2CATTRGETROLEINFORET_NAME_FIELD.index = 4
S2CATTRGETROLEINFORET_NAME_FIELD.label = 2
S2CATTRGETROLEINFORET_NAME_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_NAME_FIELD.default_value = ""
S2CATTRGETROLEINFORET_NAME_FIELD.type = 9
S2CATTRGETROLEINFORET_NAME_FIELD.cpp_type = 9

S2CATTRGETROLEINFORET_GOLD_FIELD.name = "gold"
S2CATTRGETROLEINFORET_GOLD_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.gold"
S2CATTRGETROLEINFORET_GOLD_FIELD.number = 6
S2CATTRGETROLEINFORET_GOLD_FIELD.index = 5
S2CATTRGETROLEINFORET_GOLD_FIELD.label = 2
S2CATTRGETROLEINFORET_GOLD_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_GOLD_FIELD.default_value = 0
S2CATTRGETROLEINFORET_GOLD_FIELD.type = 13
S2CATTRGETROLEINFORET_GOLD_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_DIAMOND_FIELD.name = "diamond"
S2CATTRGETROLEINFORET_DIAMOND_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.diamond"
S2CATTRGETROLEINFORET_DIAMOND_FIELD.number = 7
S2CATTRGETROLEINFORET_DIAMOND_FIELD.index = 6
S2CATTRGETROLEINFORET_DIAMOND_FIELD.label = 2
S2CATTRGETROLEINFORET_DIAMOND_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_DIAMOND_FIELD.default_value = 0
S2CATTRGETROLEINFORET_DIAMOND_FIELD.type = 13
S2CATTRGETROLEINFORET_DIAMOND_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_HEAD_ID_FIELD.name = "head_id"
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.head_id"
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.number = 8
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.index = 7
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.label = 2
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.default_value = 0
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.type = 13
S2CATTRGETROLEINFORET_HEAD_ID_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.name = "battery_id"
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.battery_id"
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.number = 9
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.index = 8
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.label = 2
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.default_value = 0
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.type = 13
S2CATTRGETROLEINFORET_BATTERY_ID_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.name = "battery_level"
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.battery_level"
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.number = 10
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.index = 9
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.label = 2
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.default_value = 0
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.type = 13
S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.name = "battery_rate"
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.battery_rate"
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.number = 11
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.index = 10
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.label = 2
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.default_value = 0
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.type = 13
S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.name = "consortia_id"
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.consortia_id"
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.number = 12
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.index = 11
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.label = 2
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.default_value = 0
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.type = 13
S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.name = "consortia_name"
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.consortia_name"
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.number = 13
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.index = 12
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.label = 2
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.default_value = ""
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.type = 9
S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD.cpp_type = 9

S2CATTRGETROLEINFORET_GENDER_FIELD.name = "gender"
S2CATTRGETROLEINFORET_GENDER_FIELD.full_name = ".net_protocol.S2CAttrGetRoleInfoRet.gender"
S2CATTRGETROLEINFORET_GENDER_FIELD.number = 14
S2CATTRGETROLEINFORET_GENDER_FIELD.index = 13
S2CATTRGETROLEINFORET_GENDER_FIELD.label = 2
S2CATTRGETROLEINFORET_GENDER_FIELD.has_default_value = false
S2CATTRGETROLEINFORET_GENDER_FIELD.default_value = 0
S2CATTRGETROLEINFORET_GENDER_FIELD.type = 13
S2CATTRGETROLEINFORET_GENDER_FIELD.cpp_type = 3

S2CATTRGETROLEINFORET.name = "S2CAttrGetRoleInfoRet"
S2CATTRGETROLEINFORET.full_name = ".net_protocol.S2CAttrGetRoleInfoRet"
S2CATTRGETROLEINFORET.nested_types = {}
S2CATTRGETROLEINFORET.enum_types = {}
S2CATTRGETROLEINFORET.fields = {S2CATTRGETROLEINFORET_USER_NAME_FIELD, S2CATTRGETROLEINFORET_LEVEL_FIELD, S2CATTRGETROLEINFORET_EXP_FIELD, S2CATTRGETROLEINFORET_VIP_LEVEL_FIELD, S2CATTRGETROLEINFORET_NAME_FIELD, S2CATTRGETROLEINFORET_GOLD_FIELD, S2CATTRGETROLEINFORET_DIAMOND_FIELD, S2CATTRGETROLEINFORET_HEAD_ID_FIELD, S2CATTRGETROLEINFORET_BATTERY_ID_FIELD, S2CATTRGETROLEINFORET_BATTERY_LEVEL_FIELD, S2CATTRGETROLEINFORET_BATTERY_RATE_FIELD, S2CATTRGETROLEINFORET_CONSORTIA_ID_FIELD, S2CATTRGETROLEINFORET_CONSORTIA_NAME_FIELD, S2CATTRGETROLEINFORET_GENDER_FIELD}
S2CATTRGETROLEINFORET.is_extendable = false
S2CATTRGETROLEINFORET.extensions = {}
SYN_ITEM_KEY_FIELD.name = "key"
SYN_ITEM_KEY_FIELD.full_name = ".net_protocol.syn_item.key"
SYN_ITEM_KEY_FIELD.number = 1
SYN_ITEM_KEY_FIELD.index = 0
SYN_ITEM_KEY_FIELD.label = 2
SYN_ITEM_KEY_FIELD.has_default_value = false
SYN_ITEM_KEY_FIELD.default_value = 0
SYN_ITEM_KEY_FIELD.type = 13
SYN_ITEM_KEY_FIELD.cpp_type = 3

SYN_ITEM_VAL_FIELD.name = "val"
SYN_ITEM_VAL_FIELD.full_name = ".net_protocol.syn_item.val"
SYN_ITEM_VAL_FIELD.number = 2
SYN_ITEM_VAL_FIELD.index = 1
SYN_ITEM_VAL_FIELD.label = 2
SYN_ITEM_VAL_FIELD.has_default_value = false
SYN_ITEM_VAL_FIELD.default_value = 0
SYN_ITEM_VAL_FIELD.type = 13
SYN_ITEM_VAL_FIELD.cpp_type = 3

SYN_ITEM.name = "syn_item"
SYN_ITEM.full_name = ".net_protocol.syn_item"
SYN_ITEM.nested_types = {}
SYN_ITEM.enum_types = {}
SYN_ITEM.fields = {SYN_ITEM_KEY_FIELD, SYN_ITEM_VAL_FIELD}
SYN_ITEM.is_extendable = false
SYN_ITEM.extensions = {}
S2CATTRSYNCROLE_ITEM_FIELD.name = "item"
S2CATTRSYNCROLE_ITEM_FIELD.full_name = ".net_protocol.S2CAttrSyncRole.item"
S2CATTRSYNCROLE_ITEM_FIELD.number = 1
S2CATTRSYNCROLE_ITEM_FIELD.index = 0
S2CATTRSYNCROLE_ITEM_FIELD.label = 3
S2CATTRSYNCROLE_ITEM_FIELD.has_default_value = false
S2CATTRSYNCROLE_ITEM_FIELD.default_value = {}
S2CATTRSYNCROLE_ITEM_FIELD.message_type = SYN_ITEM
S2CATTRSYNCROLE_ITEM_FIELD.type = 11
S2CATTRSYNCROLE_ITEM_FIELD.cpp_type = 10

S2CATTRSYNCROLE.name = "S2CAttrSyncRole"
S2CATTRSYNCROLE.full_name = ".net_protocol.S2CAttrSyncRole"
S2CATTRSYNCROLE.nested_types = {}
S2CATTRSYNCROLE.enum_types = {}
S2CATTRSYNCROLE.fields = {S2CATTRSYNCROLE_ITEM_FIELD}
S2CATTRSYNCROLE.is_extendable = false
S2CATTRSYNCROLE.extensions = {}
S2CATTRGETDAILYASS_RET_FIELD.name = "ret"
S2CATTRGETDAILYASS_RET_FIELD.full_name = ".net_protocol.S2CAttrGetDailyAss.ret"
S2CATTRGETDAILYASS_RET_FIELD.number = 1
S2CATTRGETDAILYASS_RET_FIELD.index = 0
S2CATTRGETDAILYASS_RET_FIELD.label = 2
S2CATTRGETDAILYASS_RET_FIELD.has_default_value = false
S2CATTRGETDAILYASS_RET_FIELD.default_value = 0
S2CATTRGETDAILYASS_RET_FIELD.type = 13
S2CATTRGETDAILYASS_RET_FIELD.cpp_type = 3

S2CATTRGETDAILYASS_GOLD_FIELD.name = "gold"
S2CATTRGETDAILYASS_GOLD_FIELD.full_name = ".net_protocol.S2CAttrGetDailyAss.gold"
S2CATTRGETDAILYASS_GOLD_FIELD.number = 2
S2CATTRGETDAILYASS_GOLD_FIELD.index = 1
S2CATTRGETDAILYASS_GOLD_FIELD.label = 1
S2CATTRGETDAILYASS_GOLD_FIELD.has_default_value = false
S2CATTRGETDAILYASS_GOLD_FIELD.default_value = 0
S2CATTRGETDAILYASS_GOLD_FIELD.type = 13
S2CATTRGETDAILYASS_GOLD_FIELD.cpp_type = 3

S2CATTRGETDAILYASS_DAILY_ASS_FIELD.name = "daily_ass"
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.full_name = ".net_protocol.S2CAttrGetDailyAss.daily_ass"
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.number = 3
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.index = 2
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.label = 1
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.has_default_value = false
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.default_value = 0
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.type = 13
S2CATTRGETDAILYASS_DAILY_ASS_FIELD.cpp_type = 3

S2CATTRGETDAILYASS.name = "S2CAttrGetDailyAss"
S2CATTRGETDAILYASS.full_name = ".net_protocol.S2CAttrGetDailyAss"
S2CATTRGETDAILYASS.nested_types = {}
S2CATTRGETDAILYASS.enum_types = {}
S2CATTRGETDAILYASS.fields = {S2CATTRGETDAILYASS_RET_FIELD, S2CATTRGETDAILYASS_GOLD_FIELD, S2CATTRGETDAILYASS_DAILY_ASS_FIELD}
S2CATTRGETDAILYASS.is_extendable = false
S2CATTRGETDAILYASS.extensions = {}
BATTERY_ID_FIELD.name = "id"
BATTERY_ID_FIELD.full_name = ".net_protocol.battery.id"
BATTERY_ID_FIELD.number = 1
BATTERY_ID_FIELD.index = 0
BATTERY_ID_FIELD.label = 2
BATTERY_ID_FIELD.has_default_value = false
BATTERY_ID_FIELD.default_value = 0
BATTERY_ID_FIELD.type = 13
BATTERY_ID_FIELD.cpp_type = 3

BATTERY_END_TIME_FIELD.name = "end_time"
BATTERY_END_TIME_FIELD.full_name = ".net_protocol.battery.end_time"
BATTERY_END_TIME_FIELD.number = 2
BATTERY_END_TIME_FIELD.index = 1
BATTERY_END_TIME_FIELD.label = 2
BATTERY_END_TIME_FIELD.has_default_value = false
BATTERY_END_TIME_FIELD.default_value = 0
BATTERY_END_TIME_FIELD.type = 13
BATTERY_END_TIME_FIELD.cpp_type = 3

BATTERY.name = "battery"
BATTERY.full_name = ".net_protocol.battery"
BATTERY.nested_types = {}
BATTERY.enum_types = {}
BATTERY.fields = {BATTERY_ID_FIELD, BATTERY_END_TIME_FIELD}
BATTERY.is_extendable = false
BATTERY.extensions = {}
S2CATTRUNLOCKBATTERY_LIST_FIELD.name = "list"
S2CATTRUNLOCKBATTERY_LIST_FIELD.full_name = ".net_protocol.S2CAttrUnlockBattery.list"
S2CATTRUNLOCKBATTERY_LIST_FIELD.number = 1
S2CATTRUNLOCKBATTERY_LIST_FIELD.index = 0
S2CATTRUNLOCKBATTERY_LIST_FIELD.label = 3
S2CATTRUNLOCKBATTERY_LIST_FIELD.has_default_value = false
S2CATTRUNLOCKBATTERY_LIST_FIELD.default_value = {}
S2CATTRUNLOCKBATTERY_LIST_FIELD.message_type = BATTERY
S2CATTRUNLOCKBATTERY_LIST_FIELD.type = 11
S2CATTRUNLOCKBATTERY_LIST_FIELD.cpp_type = 10

S2CATTRUNLOCKBATTERY.name = "S2CAttrUnlockBattery"
S2CATTRUNLOCKBATTERY.full_name = ".net_protocol.S2CAttrUnlockBattery"
S2CATTRUNLOCKBATTERY.nested_types = {}
S2CATTRUNLOCKBATTERY.enum_types = {}
S2CATTRUNLOCKBATTERY.fields = {S2CATTRUNLOCKBATTERY_LIST_FIELD}
S2CATTRUNLOCKBATTERY.is_extendable = false
S2CATTRUNLOCKBATTERY.extensions = {}
S2CATTRENTERROOM2.name = "S2CAttrEnterRoom2"
S2CATTRENTERROOM2.full_name = ".net_protocol.S2CAttrEnterRoom2"
S2CATTRENTERROOM2.nested_types = {}
S2CATTRENTERROOM2.enum_types = {}
S2CATTRENTERROOM2.fields = {}
S2CATTRENTERROOM2.is_extendable = false
S2CATTRENTERROOM2.extensions = {}

S2CAttrEnterRoom2 = protobuf.Message(S2CATTRENTERROOM2)
S2CAttrGetDailyAss = protobuf.Message(S2CATTRGETDAILYASS)
S2CAttrGetRoleInfoRet = protobuf.Message(S2CATTRGETROLEINFORET)
S2CAttrSetBatteryIdRet = protobuf.Message(S2CATTRSETBATTERYIDRET)
S2CAttrSetBatteryLevelRet = protobuf.Message(S2CATTRSETBATTERYLEVELRET)
S2CAttrSetBatteryRateRet = protobuf.Message(S2CATTRSETBATTERYRATERET)
S2CAttrSetGenderRet = protobuf.Message(S2CATTRSETGENDERRET)
S2CAttrSetHeadIdRet = protobuf.Message(S2CATTRSETHEADIDRET)
S2CAttrSetNameRet = protobuf.Message(S2CATTRSETNAMERET)
S2CAttrSyncRole = protobuf.Message(S2CATTRSYNCROLE)
S2CAttrUnlockBattery = protobuf.Message(S2CATTRUNLOCKBATTERY)
battery = protobuf.Message(BATTERY)
syn_item = protobuf.Message(SYN_ITEM)
