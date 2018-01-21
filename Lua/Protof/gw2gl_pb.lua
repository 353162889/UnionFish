-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('gw2gl_pb')


GW2GLROLELOGOUT = protobuf.Descriptor();
local GW2GLROLELOGOUT_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLROLELOGOUT_TYPE_FIELD = protobuf.FieldDescriptor();
GW2GLTRANSFERSCENE = protobuf.Descriptor();
local GW2GLTRANSFERSCENE_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLTRANSFERSCENE_SCENE_X_FIELD = protobuf.FieldDescriptor();
local GW2GLTRANSFERSCENE_SCENE_Y_FIELD = protobuf.FieldDescriptor();
GW2GLREQDESTORYSCENE = protobuf.Descriptor();
local GW2GLREQDESTORYSCENE_SCENE_ID_FIELD = protobuf.FieldDescriptor();
GW2GLSYNROLEDATAINFO = protobuf.Descriptor();
local GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_HP_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_MP_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_HP_POOL_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_MP_POOL_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_PK_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD = protobuf.FieldDescriptor();
local GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD = protobuf.FieldDescriptor();
GW2GLROLEOUTPUTCURRENCY = protobuf.Descriptor();
local GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD = protobuf.FieldDescriptor();
local GW2GLROLEOUTPUTCURRENCY_CNT_FIELD = protobuf.FieldDescriptor();
local GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD = protobuf.FieldDescriptor();
GW2GLKICKALLLEAVESCENE = protobuf.Descriptor();
local GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD = protobuf.FieldDescriptor();
GW2GLATTACKFISH = protobuf.Descriptor();
local GW2GLATTACKFISH_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_FISH_OBJ_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_FISH_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_GUN_LEVEL_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_ATK_NUM_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_IS_DIE_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_NO_POOL_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKFISH_FISH_RATE_FIELD = protobuf.FieldDescriptor();
GW2GLADDGOLDFISH = protobuf.Descriptor();
local GW2GLADDGOLDFISH_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLADDGOLDFISH_GOLD_NUM_FIELD = protobuf.FieldDescriptor();
local GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD = protobuf.FieldDescriptor();
GW2GLCHANGEGUN = protobuf.Descriptor();
local GW2GLCHANGEGUN_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLCHANGEGUN_ID_FIELD = protobuf.FieldDescriptor();
GW2GLSETGUNLEVEL = protobuf.Descriptor();
local GW2GLSETGUNLEVEL_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSETGUNLEVEL_LV_FIELD = protobuf.FieldDescriptor();
GW2GLADDGOLDPOOL = protobuf.Descriptor();
local GW2GLADDGOLDPOOL_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLADDGOLDPOOL_ADD_GOLD_FIELD = protobuf.FieldDescriptor();
GW2GLATTACKBOSS = protobuf.Descriptor();
local GW2GLATTACKBOSS_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_FISH_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_ATK_TYPE_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_GOLD_POOL_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_GUN_LEVEL_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_P1_FIELD = protobuf.FieldDescriptor();
local GW2GLATTACKBOSS_P2_FIELD = protobuf.FieldDescriptor();
GW2GLADDITEMS = protobuf.Descriptor();
local GW2GLADDITEMS_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLADDITEMS_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLADDITEMS_NUM_FIELD = protobuf.FieldDescriptor();
GW2GLSTARTBOXGAME = protobuf.Descriptor();
local GW2GLSTARTBOXGAME_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSTARTBOXGAME_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSTARTBOXGAME_RATE_FIELD = protobuf.FieldDescriptor();
GW2GLSTARTLOTTERY = protobuf.Descriptor();
local GW2GLSTARTLOTTERY_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local GW2GLSTARTLOTTERY_ID_FIELD = protobuf.FieldDescriptor();

GW2GLROLELOGOUT_ROLE_ID_FIELD.name = "role_id"
GW2GLROLELOGOUT_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLRoleLogout.role_id"
GW2GLROLELOGOUT_ROLE_ID_FIELD.number = 1
GW2GLROLELOGOUT_ROLE_ID_FIELD.index = 0
GW2GLROLELOGOUT_ROLE_ID_FIELD.label = 2
GW2GLROLELOGOUT_ROLE_ID_FIELD.has_default_value = false
GW2GLROLELOGOUT_ROLE_ID_FIELD.default_value = 0
GW2GLROLELOGOUT_ROLE_ID_FIELD.type = 13
GW2GLROLELOGOUT_ROLE_ID_FIELD.cpp_type = 3

GW2GLROLELOGOUT_TYPE_FIELD.name = "type"
GW2GLROLELOGOUT_TYPE_FIELD.full_name = ".net_protocol.GW2GLRoleLogout.type"
GW2GLROLELOGOUT_TYPE_FIELD.number = 2
GW2GLROLELOGOUT_TYPE_FIELD.index = 1
GW2GLROLELOGOUT_TYPE_FIELD.label = 2
GW2GLROLELOGOUT_TYPE_FIELD.has_default_value = false
GW2GLROLELOGOUT_TYPE_FIELD.default_value = 0
GW2GLROLELOGOUT_TYPE_FIELD.type = 13
GW2GLROLELOGOUT_TYPE_FIELD.cpp_type = 3

GW2GLROLELOGOUT.name = "GW2GLRoleLogout"
GW2GLROLELOGOUT.full_name = ".net_protocol.GW2GLRoleLogout"
GW2GLROLELOGOUT.nested_types = {}
GW2GLROLELOGOUT.enum_types = {}
GW2GLROLELOGOUT.fields = {GW2GLROLELOGOUT_ROLE_ID_FIELD, GW2GLROLELOGOUT_TYPE_FIELD}
GW2GLROLELOGOUT.is_extendable = false
GW2GLROLELOGOUT.extensions = {}
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.name = "role_id"
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLTransferScene.role_id"
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.number = 1
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.index = 0
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.label = 2
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.has_default_value = false
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.default_value = 0
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.type = 13
GW2GLTRANSFERSCENE_ROLE_ID_FIELD.cpp_type = 3

GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.name = "scene_type_id"
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.full_name = ".net_protocol.GW2GLTransferScene.scene_type_id"
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.number = 2
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.index = 1
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.label = 2
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.has_default_value = false
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.default_value = 0
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.type = 13
GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD.cpp_type = 3

GW2GLTRANSFERSCENE_SCENE_X_FIELD.name = "scene_x"
GW2GLTRANSFERSCENE_SCENE_X_FIELD.full_name = ".net_protocol.GW2GLTransferScene.scene_x"
GW2GLTRANSFERSCENE_SCENE_X_FIELD.number = 3
GW2GLTRANSFERSCENE_SCENE_X_FIELD.index = 2
GW2GLTRANSFERSCENE_SCENE_X_FIELD.label = 2
GW2GLTRANSFERSCENE_SCENE_X_FIELD.has_default_value = false
GW2GLTRANSFERSCENE_SCENE_X_FIELD.default_value = 0
GW2GLTRANSFERSCENE_SCENE_X_FIELD.type = 13
GW2GLTRANSFERSCENE_SCENE_X_FIELD.cpp_type = 3

GW2GLTRANSFERSCENE_SCENE_Y_FIELD.name = "scene_y"
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.full_name = ".net_protocol.GW2GLTransferScene.scene_y"
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.number = 4
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.index = 3
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.label = 2
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.has_default_value = false
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.default_value = 0
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.type = 13
GW2GLTRANSFERSCENE_SCENE_Y_FIELD.cpp_type = 3

GW2GLTRANSFERSCENE.name = "GW2GLTransferScene"
GW2GLTRANSFERSCENE.full_name = ".net_protocol.GW2GLTransferScene"
GW2GLTRANSFERSCENE.nested_types = {}
GW2GLTRANSFERSCENE.enum_types = {}
GW2GLTRANSFERSCENE.fields = {GW2GLTRANSFERSCENE_ROLE_ID_FIELD, GW2GLTRANSFERSCENE_SCENE_TYPE_ID_FIELD, GW2GLTRANSFERSCENE_SCENE_X_FIELD, GW2GLTRANSFERSCENE_SCENE_Y_FIELD}
GW2GLTRANSFERSCENE.is_extendable = false
GW2GLTRANSFERSCENE.extensions = {}
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.name = "scene_id"
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.full_name = ".net_protocol.GW2GLReqDestoryScene.scene_id"
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.number = 1
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.index = 0
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.label = 2
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.has_default_value = false
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.default_value = 0
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.type = 13
GW2GLREQDESTORYSCENE_SCENE_ID_FIELD.cpp_type = 3

GW2GLREQDESTORYSCENE.name = "GW2GLReqDestoryScene"
GW2GLREQDESTORYSCENE.full_name = ".net_protocol.GW2GLReqDestoryScene"
GW2GLREQDESTORYSCENE.nested_types = {}
GW2GLREQDESTORYSCENE.enum_types = {}
GW2GLREQDESTORYSCENE.fields = {GW2GLREQDESTORYSCENE_SCENE_ID_FIELD}
GW2GLREQDESTORYSCENE.is_extendable = false
GW2GLREQDESTORYSCENE.extensions = {}
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.name = "role_id"
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.role_id"
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.number = 1
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.index = 0
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.label = 2
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.type = 13
GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.name = "last_scene_id"
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.last_scene_id"
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.number = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.index = 1
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.label = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.type = 13
GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.name = "last_scene_x"
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.last_scene_x"
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.number = 3
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.index = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.label = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.default_value = 0.0
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.type = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD.cpp_type = 6

GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.name = "last_scene_y"
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.last_scene_y"
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.number = 4
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.index = 3
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.label = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.default_value = 0.0
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.type = 2
GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD.cpp_type = 6

GW2GLSYNROLEDATAINFO_HP_FIELD.name = "hp"
GW2GLSYNROLEDATAINFO_HP_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.hp"
GW2GLSYNROLEDATAINFO_HP_FIELD.number = 5
GW2GLSYNROLEDATAINFO_HP_FIELD.index = 4
GW2GLSYNROLEDATAINFO_HP_FIELD.label = 2
GW2GLSYNROLEDATAINFO_HP_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_HP_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_HP_FIELD.type = 13
GW2GLSYNROLEDATAINFO_HP_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_MP_FIELD.name = "mp"
GW2GLSYNROLEDATAINFO_MP_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.mp"
GW2GLSYNROLEDATAINFO_MP_FIELD.number = 6
GW2GLSYNROLEDATAINFO_MP_FIELD.index = 5
GW2GLSYNROLEDATAINFO_MP_FIELD.label = 2
GW2GLSYNROLEDATAINFO_MP_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_MP_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_MP_FIELD.type = 13
GW2GLSYNROLEDATAINFO_MP_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.name = "hp_pool"
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.hp_pool"
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.number = 7
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.index = 6
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.label = 2
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.type = 13
GW2GLSYNROLEDATAINFO_HP_POOL_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.name = "mp_pool"
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.mp_pool"
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.number = 8
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.index = 7
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.label = 2
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.type = 13
GW2GLSYNROLEDATAINFO_MP_POOL_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_PK_FIELD.name = "pk"
GW2GLSYNROLEDATAINFO_PK_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.pk"
GW2GLSYNROLEDATAINFO_PK_FIELD.number = 9
GW2GLSYNROLEDATAINFO_PK_FIELD.index = 8
GW2GLSYNROLEDATAINFO_PK_FIELD.label = 2
GW2GLSYNROLEDATAINFO_PK_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_PK_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_PK_FIELD.type = 13
GW2GLSYNROLEDATAINFO_PK_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.name = "inner_value"
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.inner_value"
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.number = 10
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.index = 9
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.label = 2
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.type = 13
GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.name = "ride_state"
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.full_name = ".net_protocol.GW2GLSynRoleDataInfo.ride_state"
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.number = 11
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.index = 10
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.label = 2
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.has_default_value = false
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.default_value = 0
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.type = 13
GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD.cpp_type = 3

GW2GLSYNROLEDATAINFO.name = "GW2GLSynRoleDataInfo"
GW2GLSYNROLEDATAINFO.full_name = ".net_protocol.GW2GLSynRoleDataInfo"
GW2GLSYNROLEDATAINFO.nested_types = {}
GW2GLSYNROLEDATAINFO.enum_types = {}
GW2GLSYNROLEDATAINFO.fields = {GW2GLSYNROLEDATAINFO_ROLE_ID_FIELD, GW2GLSYNROLEDATAINFO_LAST_SCENE_ID_FIELD, GW2GLSYNROLEDATAINFO_LAST_SCENE_X_FIELD, GW2GLSYNROLEDATAINFO_LAST_SCENE_Y_FIELD, GW2GLSYNROLEDATAINFO_HP_FIELD, GW2GLSYNROLEDATAINFO_MP_FIELD, GW2GLSYNROLEDATAINFO_HP_POOL_FIELD, GW2GLSYNROLEDATAINFO_MP_POOL_FIELD, GW2GLSYNROLEDATAINFO_PK_FIELD, GW2GLSYNROLEDATAINFO_INNER_VALUE_FIELD, GW2GLSYNROLEDATAINFO_RIDE_STATE_FIELD}
GW2GLSYNROLEDATAINFO.is_extendable = false
GW2GLSYNROLEDATAINFO.extensions = {}
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.name = "role_id"
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLRoleOutputCurrency.role_id"
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.number = 1
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.index = 0
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.label = 2
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.has_default_value = false
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.default_value = 0
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.type = 13
GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD.cpp_type = 3

GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.name = "type"
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.full_name = ".net_protocol.GW2GLRoleOutputCurrency.type"
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.number = 2
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.index = 1
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.label = 2
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.has_default_value = false
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.default_value = 0
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.type = 5
GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD.cpp_type = 1

GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.name = "cnt"
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.full_name = ".net_protocol.GW2GLRoleOutputCurrency.cnt"
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.number = 3
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.index = 2
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.label = 2
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.has_default_value = false
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.default_value = 0
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.type = 5
GW2GLROLEOUTPUTCURRENCY_CNT_FIELD.cpp_type = 1

GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.name = "gun_level"
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.full_name = ".net_protocol.GW2GLRoleOutputCurrency.gun_level"
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.number = 4
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.index = 3
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.label = 2
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.has_default_value = false
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.default_value = 0
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.type = 5
GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD.cpp_type = 1

GW2GLROLEOUTPUTCURRENCY.name = "GW2GLRoleOutputCurrency"
GW2GLROLEOUTPUTCURRENCY.full_name = ".net_protocol.GW2GLRoleOutputCurrency"
GW2GLROLEOUTPUTCURRENCY.nested_types = {}
GW2GLROLEOUTPUTCURRENCY.enum_types = {}
GW2GLROLEOUTPUTCURRENCY.fields = {GW2GLROLEOUTPUTCURRENCY_ROLE_ID_FIELD, GW2GLROLEOUTPUTCURRENCY_TYPE_FIELD, GW2GLROLEOUTPUTCURRENCY_CNT_FIELD, GW2GLROLEOUTPUTCURRENCY_GUN_LEVEL_FIELD}
GW2GLROLEOUTPUTCURRENCY.is_extendable = false
GW2GLROLEOUTPUTCURRENCY.extensions = {}
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.name = "role_ids"
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.full_name = ".net_protocol.GW2GLKickAllLeaveScene.role_ids"
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.number = 1
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.index = 0
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.label = 3
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.has_default_value = false
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.default_value = {}
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.type = 13
GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD.cpp_type = 3

GW2GLKICKALLLEAVESCENE.name = "GW2GLKickAllLeaveScene"
GW2GLKICKALLLEAVESCENE.full_name = ".net_protocol.GW2GLKickAllLeaveScene"
GW2GLKICKALLLEAVESCENE.nested_types = {}
GW2GLKICKALLLEAVESCENE.enum_types = {}
GW2GLKICKALLLEAVESCENE.fields = {GW2GLKICKALLLEAVESCENE_ROLE_IDS_FIELD}
GW2GLKICKALLLEAVESCENE.is_extendable = false
GW2GLKICKALLLEAVESCENE.extensions = {}
GW2GLATTACKFISH_ROLE_ID_FIELD.name = "role_id"
GW2GLATTACKFISH_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLAttackFish.role_id"
GW2GLATTACKFISH_ROLE_ID_FIELD.number = 1
GW2GLATTACKFISH_ROLE_ID_FIELD.index = 0
GW2GLATTACKFISH_ROLE_ID_FIELD.label = 2
GW2GLATTACKFISH_ROLE_ID_FIELD.has_default_value = false
GW2GLATTACKFISH_ROLE_ID_FIELD.default_value = 0
GW2GLATTACKFISH_ROLE_ID_FIELD.type = 13
GW2GLATTACKFISH_ROLE_ID_FIELD.cpp_type = 3

GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.name = "bullet_only_key"
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.full_name = ".net_protocol.GW2GLAttackFish.bullet_only_key"
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.number = 2
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.index = 1
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.label = 2
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.has_default_value = false
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.default_value = 0
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.type = 13
GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD.cpp_type = 3

GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.name = "fish_obj_id"
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.full_name = ".net_protocol.GW2GLAttackFish.fish_obj_id"
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.number = 3
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.index = 2
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.label = 2
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.has_default_value = false
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.default_value = 0
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.type = 13
GW2GLATTACKFISH_FISH_OBJ_ID_FIELD.cpp_type = 3

GW2GLATTACKFISH_FISH_ID_FIELD.name = "fish_id"
GW2GLATTACKFISH_FISH_ID_FIELD.full_name = ".net_protocol.GW2GLAttackFish.fish_id"
GW2GLATTACKFISH_FISH_ID_FIELD.number = 4
GW2GLATTACKFISH_FISH_ID_FIELD.index = 3
GW2GLATTACKFISH_FISH_ID_FIELD.label = 2
GW2GLATTACKFISH_FISH_ID_FIELD.has_default_value = false
GW2GLATTACKFISH_FISH_ID_FIELD.default_value = 0
GW2GLATTACKFISH_FISH_ID_FIELD.type = 13
GW2GLATTACKFISH_FISH_ID_FIELD.cpp_type = 3

GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.name = "fish_gold_pool"
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.full_name = ".net_protocol.GW2GLAttackFish.fish_gold_pool"
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.number = 5
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.index = 4
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.label = 2
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.has_default_value = false
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.default_value = 0
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.type = 13
GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD.cpp_type = 3

GW2GLATTACKFISH_GUN_LEVEL_FIELD.name = "gun_level"
GW2GLATTACKFISH_GUN_LEVEL_FIELD.full_name = ".net_protocol.GW2GLAttackFish.gun_level"
GW2GLATTACKFISH_GUN_LEVEL_FIELD.number = 6
GW2GLATTACKFISH_GUN_LEVEL_FIELD.index = 5
GW2GLATTACKFISH_GUN_LEVEL_FIELD.label = 2
GW2GLATTACKFISH_GUN_LEVEL_FIELD.has_default_value = false
GW2GLATTACKFISH_GUN_LEVEL_FIELD.default_value = 0
GW2GLATTACKFISH_GUN_LEVEL_FIELD.type = 13
GW2GLATTACKFISH_GUN_LEVEL_FIELD.cpp_type = 3

GW2GLATTACKFISH_ATK_NUM_FIELD.name = "atk_num"
GW2GLATTACKFISH_ATK_NUM_FIELD.full_name = ".net_protocol.GW2GLAttackFish.atk_num"
GW2GLATTACKFISH_ATK_NUM_FIELD.number = 7
GW2GLATTACKFISH_ATK_NUM_FIELD.index = 6
GW2GLATTACKFISH_ATK_NUM_FIELD.label = 2
GW2GLATTACKFISH_ATK_NUM_FIELD.has_default_value = false
GW2GLATTACKFISH_ATK_NUM_FIELD.default_value = 0
GW2GLATTACKFISH_ATK_NUM_FIELD.type = 13
GW2GLATTACKFISH_ATK_NUM_FIELD.cpp_type = 3

GW2GLATTACKFISH_IS_DIE_FIELD.name = "is_die"
GW2GLATTACKFISH_IS_DIE_FIELD.full_name = ".net_protocol.GW2GLAttackFish.is_die"
GW2GLATTACKFISH_IS_DIE_FIELD.number = 8
GW2GLATTACKFISH_IS_DIE_FIELD.index = 7
GW2GLATTACKFISH_IS_DIE_FIELD.label = 2
GW2GLATTACKFISH_IS_DIE_FIELD.has_default_value = false
GW2GLATTACKFISH_IS_DIE_FIELD.default_value = 0
GW2GLATTACKFISH_IS_DIE_FIELD.type = 13
GW2GLATTACKFISH_IS_DIE_FIELD.cpp_type = 3

GW2GLATTACKFISH_NO_POOL_FIELD.name = "no_pool"
GW2GLATTACKFISH_NO_POOL_FIELD.full_name = ".net_protocol.GW2GLAttackFish.no_pool"
GW2GLATTACKFISH_NO_POOL_FIELD.number = 9
GW2GLATTACKFISH_NO_POOL_FIELD.index = 8
GW2GLATTACKFISH_NO_POOL_FIELD.label = 2
GW2GLATTACKFISH_NO_POOL_FIELD.has_default_value = false
GW2GLATTACKFISH_NO_POOL_FIELD.default_value = 0
GW2GLATTACKFISH_NO_POOL_FIELD.type = 13
GW2GLATTACKFISH_NO_POOL_FIELD.cpp_type = 3

GW2GLATTACKFISH_FISH_RATE_FIELD.name = "fish_rate"
GW2GLATTACKFISH_FISH_RATE_FIELD.full_name = ".net_protocol.GW2GLAttackFish.fish_rate"
GW2GLATTACKFISH_FISH_RATE_FIELD.number = 10
GW2GLATTACKFISH_FISH_RATE_FIELD.index = 9
GW2GLATTACKFISH_FISH_RATE_FIELD.label = 2
GW2GLATTACKFISH_FISH_RATE_FIELD.has_default_value = false
GW2GLATTACKFISH_FISH_RATE_FIELD.default_value = 0
GW2GLATTACKFISH_FISH_RATE_FIELD.type = 13
GW2GLATTACKFISH_FISH_RATE_FIELD.cpp_type = 3

GW2GLATTACKFISH.name = "GW2GLAttackFish"
GW2GLATTACKFISH.full_name = ".net_protocol.GW2GLAttackFish"
GW2GLATTACKFISH.nested_types = {}
GW2GLATTACKFISH.enum_types = {}
GW2GLATTACKFISH.fields = {GW2GLATTACKFISH_ROLE_ID_FIELD, GW2GLATTACKFISH_BULLET_ONLY_KEY_FIELD, GW2GLATTACKFISH_FISH_OBJ_ID_FIELD, GW2GLATTACKFISH_FISH_ID_FIELD, GW2GLATTACKFISH_FISH_GOLD_POOL_FIELD, GW2GLATTACKFISH_GUN_LEVEL_FIELD, GW2GLATTACKFISH_ATK_NUM_FIELD, GW2GLATTACKFISH_IS_DIE_FIELD, GW2GLATTACKFISH_NO_POOL_FIELD, GW2GLATTACKFISH_FISH_RATE_FIELD}
GW2GLATTACKFISH.is_extendable = false
GW2GLATTACKFISH.extensions = {}
GW2GLADDGOLDFISH_ROLE_ID_FIELD.name = "role_id"
GW2GLADDGOLDFISH_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLAddGoldFish.role_id"
GW2GLADDGOLDFISH_ROLE_ID_FIELD.number = 1
GW2GLADDGOLDFISH_ROLE_ID_FIELD.index = 0
GW2GLADDGOLDFISH_ROLE_ID_FIELD.label = 2
GW2GLADDGOLDFISH_ROLE_ID_FIELD.has_default_value = false
GW2GLADDGOLDFISH_ROLE_ID_FIELD.default_value = 0
GW2GLADDGOLDFISH_ROLE_ID_FIELD.type = 13
GW2GLADDGOLDFISH_ROLE_ID_FIELD.cpp_type = 3

GW2GLADDGOLDFISH_GOLD_NUM_FIELD.name = "gold_num"
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.full_name = ".net_protocol.GW2GLAddGoldFish.gold_num"
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.number = 2
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.index = 1
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.label = 2
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.has_default_value = false
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.default_value = 0
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.type = 5
GW2GLADDGOLDFISH_GOLD_NUM_FIELD.cpp_type = 1

GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.name = "fish_obj_id"
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.full_name = ".net_protocol.GW2GLAddGoldFish.fish_obj_id"
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.number = 3
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.index = 2
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.label = 2
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.has_default_value = false
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.default_value = 0
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.type = 5
GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD.cpp_type = 1

GW2GLADDGOLDFISH.name = "GW2GLAddGoldFish"
GW2GLADDGOLDFISH.full_name = ".net_protocol.GW2GLAddGoldFish"
GW2GLADDGOLDFISH.nested_types = {}
GW2GLADDGOLDFISH.enum_types = {}
GW2GLADDGOLDFISH.fields = {GW2GLADDGOLDFISH_ROLE_ID_FIELD, GW2GLADDGOLDFISH_GOLD_NUM_FIELD, GW2GLADDGOLDFISH_FISH_OBJ_ID_FIELD}
GW2GLADDGOLDFISH.is_extendable = false
GW2GLADDGOLDFISH.extensions = {}
GW2GLCHANGEGUN_ROLE_ID_FIELD.name = "role_id"
GW2GLCHANGEGUN_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLChangeGun.role_id"
GW2GLCHANGEGUN_ROLE_ID_FIELD.number = 1
GW2GLCHANGEGUN_ROLE_ID_FIELD.index = 0
GW2GLCHANGEGUN_ROLE_ID_FIELD.label = 2
GW2GLCHANGEGUN_ROLE_ID_FIELD.has_default_value = false
GW2GLCHANGEGUN_ROLE_ID_FIELD.default_value = 0
GW2GLCHANGEGUN_ROLE_ID_FIELD.type = 13
GW2GLCHANGEGUN_ROLE_ID_FIELD.cpp_type = 3

GW2GLCHANGEGUN_ID_FIELD.name = "id"
GW2GLCHANGEGUN_ID_FIELD.full_name = ".net_protocol.GW2GLChangeGun.id"
GW2GLCHANGEGUN_ID_FIELD.number = 2
GW2GLCHANGEGUN_ID_FIELD.index = 1
GW2GLCHANGEGUN_ID_FIELD.label = 2
GW2GLCHANGEGUN_ID_FIELD.has_default_value = false
GW2GLCHANGEGUN_ID_FIELD.default_value = 0
GW2GLCHANGEGUN_ID_FIELD.type = 5
GW2GLCHANGEGUN_ID_FIELD.cpp_type = 1

GW2GLCHANGEGUN.name = "GW2GLChangeGun"
GW2GLCHANGEGUN.full_name = ".net_protocol.GW2GLChangeGun"
GW2GLCHANGEGUN.nested_types = {}
GW2GLCHANGEGUN.enum_types = {}
GW2GLCHANGEGUN.fields = {GW2GLCHANGEGUN_ROLE_ID_FIELD, GW2GLCHANGEGUN_ID_FIELD}
GW2GLCHANGEGUN.is_extendable = false
GW2GLCHANGEGUN.extensions = {}
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.name = "role_id"
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLSetGunLevel.role_id"
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.number = 1
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.index = 0
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.label = 2
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.has_default_value = false
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.default_value = 0
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.type = 13
GW2GLSETGUNLEVEL_ROLE_ID_FIELD.cpp_type = 3

GW2GLSETGUNLEVEL_LV_FIELD.name = "lv"
GW2GLSETGUNLEVEL_LV_FIELD.full_name = ".net_protocol.GW2GLSetGunLevel.lv"
GW2GLSETGUNLEVEL_LV_FIELD.number = 2
GW2GLSETGUNLEVEL_LV_FIELD.index = 1
GW2GLSETGUNLEVEL_LV_FIELD.label = 2
GW2GLSETGUNLEVEL_LV_FIELD.has_default_value = false
GW2GLSETGUNLEVEL_LV_FIELD.default_value = 0
GW2GLSETGUNLEVEL_LV_FIELD.type = 5
GW2GLSETGUNLEVEL_LV_FIELD.cpp_type = 1

GW2GLSETGUNLEVEL.name = "GW2GLSetGunLevel"
GW2GLSETGUNLEVEL.full_name = ".net_protocol.GW2GLSetGunLevel"
GW2GLSETGUNLEVEL.nested_types = {}
GW2GLSETGUNLEVEL.enum_types = {}
GW2GLSETGUNLEVEL.fields = {GW2GLSETGUNLEVEL_ROLE_ID_FIELD, GW2GLSETGUNLEVEL_LV_FIELD}
GW2GLSETGUNLEVEL.is_extendable = false
GW2GLSETGUNLEVEL.extensions = {}
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.name = "role_id"
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLAddGoldPool.role_id"
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.number = 1
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.index = 0
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.label = 2
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.has_default_value = false
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.default_value = 0
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.type = 13
GW2GLADDGOLDPOOL_ROLE_ID_FIELD.cpp_type = 3

GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.name = "add_gold"
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.full_name = ".net_protocol.GW2GLAddGoldPool.add_gold"
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.number = 2
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.index = 1
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.label = 2
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.has_default_value = false
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.default_value = 0
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.type = 13
GW2GLADDGOLDPOOL_ADD_GOLD_FIELD.cpp_type = 3

GW2GLADDGOLDPOOL.name = "GW2GLAddGoldPool"
GW2GLADDGOLDPOOL.full_name = ".net_protocol.GW2GLAddGoldPool"
GW2GLADDGOLDPOOL.nested_types = {}
GW2GLADDGOLDPOOL.enum_types = {}
GW2GLADDGOLDPOOL.fields = {GW2GLADDGOLDPOOL_ROLE_ID_FIELD, GW2GLADDGOLDPOOL_ADD_GOLD_FIELD}
GW2GLADDGOLDPOOL.is_extendable = false
GW2GLADDGOLDPOOL.extensions = {}
GW2GLATTACKBOSS_ROLE_ID_FIELD.name = "role_id"
GW2GLATTACKBOSS_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.role_id"
GW2GLATTACKBOSS_ROLE_ID_FIELD.number = 1
GW2GLATTACKBOSS_ROLE_ID_FIELD.index = 0
GW2GLATTACKBOSS_ROLE_ID_FIELD.label = 2
GW2GLATTACKBOSS_ROLE_ID_FIELD.has_default_value = false
GW2GLATTACKBOSS_ROLE_ID_FIELD.default_value = 0
GW2GLATTACKBOSS_ROLE_ID_FIELD.type = 13
GW2GLATTACKBOSS_ROLE_ID_FIELD.cpp_type = 3

GW2GLATTACKBOSS_FISH_ID_FIELD.name = "fish_id"
GW2GLATTACKBOSS_FISH_ID_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.fish_id"
GW2GLATTACKBOSS_FISH_ID_FIELD.number = 2
GW2GLATTACKBOSS_FISH_ID_FIELD.index = 1
GW2GLATTACKBOSS_FISH_ID_FIELD.label = 2
GW2GLATTACKBOSS_FISH_ID_FIELD.has_default_value = false
GW2GLATTACKBOSS_FISH_ID_FIELD.default_value = 0
GW2GLATTACKBOSS_FISH_ID_FIELD.type = 13
GW2GLATTACKBOSS_FISH_ID_FIELD.cpp_type = 3

GW2GLATTACKBOSS_ATK_TYPE_FIELD.name = "atk_type"
GW2GLATTACKBOSS_ATK_TYPE_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.atk_type"
GW2GLATTACKBOSS_ATK_TYPE_FIELD.number = 3
GW2GLATTACKBOSS_ATK_TYPE_FIELD.index = 2
GW2GLATTACKBOSS_ATK_TYPE_FIELD.label = 2
GW2GLATTACKBOSS_ATK_TYPE_FIELD.has_default_value = false
GW2GLATTACKBOSS_ATK_TYPE_FIELD.default_value = 0
GW2GLATTACKBOSS_ATK_TYPE_FIELD.type = 13
GW2GLATTACKBOSS_ATK_TYPE_FIELD.cpp_type = 3

GW2GLATTACKBOSS_GOLD_POOL_FIELD.name = "gold_pool"
GW2GLATTACKBOSS_GOLD_POOL_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.gold_pool"
GW2GLATTACKBOSS_GOLD_POOL_FIELD.number = 4
GW2GLATTACKBOSS_GOLD_POOL_FIELD.index = 3
GW2GLATTACKBOSS_GOLD_POOL_FIELD.label = 2
GW2GLATTACKBOSS_GOLD_POOL_FIELD.has_default_value = false
GW2GLATTACKBOSS_GOLD_POOL_FIELD.default_value = 0
GW2GLATTACKBOSS_GOLD_POOL_FIELD.type = 13
GW2GLATTACKBOSS_GOLD_POOL_FIELD.cpp_type = 3

GW2GLATTACKBOSS_GUN_LEVEL_FIELD.name = "gun_level"
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.gun_level"
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.number = 5
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.index = 4
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.label = 2
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.has_default_value = false
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.default_value = 0
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.type = 13
GW2GLATTACKBOSS_GUN_LEVEL_FIELD.cpp_type = 3

GW2GLATTACKBOSS_P1_FIELD.name = "p1"
GW2GLATTACKBOSS_P1_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.p1"
GW2GLATTACKBOSS_P1_FIELD.number = 6
GW2GLATTACKBOSS_P1_FIELD.index = 5
GW2GLATTACKBOSS_P1_FIELD.label = 2
GW2GLATTACKBOSS_P1_FIELD.has_default_value = false
GW2GLATTACKBOSS_P1_FIELD.default_value = 0
GW2GLATTACKBOSS_P1_FIELD.type = 13
GW2GLATTACKBOSS_P1_FIELD.cpp_type = 3

GW2GLATTACKBOSS_P2_FIELD.name = "p2"
GW2GLATTACKBOSS_P2_FIELD.full_name = ".net_protocol.GW2GLAttackBoss.p2"
GW2GLATTACKBOSS_P2_FIELD.number = 7
GW2GLATTACKBOSS_P2_FIELD.index = 6
GW2GLATTACKBOSS_P2_FIELD.label = 2
GW2GLATTACKBOSS_P2_FIELD.has_default_value = false
GW2GLATTACKBOSS_P2_FIELD.default_value = 0
GW2GLATTACKBOSS_P2_FIELD.type = 13
GW2GLATTACKBOSS_P2_FIELD.cpp_type = 3

GW2GLATTACKBOSS.name = "GW2GLAttackBoss"
GW2GLATTACKBOSS.full_name = ".net_protocol.GW2GLAttackBoss"
GW2GLATTACKBOSS.nested_types = {}
GW2GLATTACKBOSS.enum_types = {}
GW2GLATTACKBOSS.fields = {GW2GLATTACKBOSS_ROLE_ID_FIELD, GW2GLATTACKBOSS_FISH_ID_FIELD, GW2GLATTACKBOSS_ATK_TYPE_FIELD, GW2GLATTACKBOSS_GOLD_POOL_FIELD, GW2GLATTACKBOSS_GUN_LEVEL_FIELD, GW2GLATTACKBOSS_P1_FIELD, GW2GLATTACKBOSS_P2_FIELD}
GW2GLATTACKBOSS.is_extendable = false
GW2GLATTACKBOSS.extensions = {}
GW2GLADDITEMS_ROLE_ID_FIELD.name = "role_id"
GW2GLADDITEMS_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLAddItems.role_id"
GW2GLADDITEMS_ROLE_ID_FIELD.number = 1
GW2GLADDITEMS_ROLE_ID_FIELD.index = 0
GW2GLADDITEMS_ROLE_ID_FIELD.label = 2
GW2GLADDITEMS_ROLE_ID_FIELD.has_default_value = false
GW2GLADDITEMS_ROLE_ID_FIELD.default_value = 0
GW2GLADDITEMS_ROLE_ID_FIELD.type = 13
GW2GLADDITEMS_ROLE_ID_FIELD.cpp_type = 3

GW2GLADDITEMS_ID_FIELD.name = "id"
GW2GLADDITEMS_ID_FIELD.full_name = ".net_protocol.GW2GLAddItems.id"
GW2GLADDITEMS_ID_FIELD.number = 2
GW2GLADDITEMS_ID_FIELD.index = 1
GW2GLADDITEMS_ID_FIELD.label = 2
GW2GLADDITEMS_ID_FIELD.has_default_value = false
GW2GLADDITEMS_ID_FIELD.default_value = 0
GW2GLADDITEMS_ID_FIELD.type = 13
GW2GLADDITEMS_ID_FIELD.cpp_type = 3

GW2GLADDITEMS_NUM_FIELD.name = "num"
GW2GLADDITEMS_NUM_FIELD.full_name = ".net_protocol.GW2GLAddItems.num"
GW2GLADDITEMS_NUM_FIELD.number = 3
GW2GLADDITEMS_NUM_FIELD.index = 2
GW2GLADDITEMS_NUM_FIELD.label = 2
GW2GLADDITEMS_NUM_FIELD.has_default_value = false
GW2GLADDITEMS_NUM_FIELD.default_value = 0
GW2GLADDITEMS_NUM_FIELD.type = 13
GW2GLADDITEMS_NUM_FIELD.cpp_type = 3

GW2GLADDITEMS.name = "GW2GLAddItems"
GW2GLADDITEMS.full_name = ".net_protocol.GW2GLAddItems"
GW2GLADDITEMS.nested_types = {}
GW2GLADDITEMS.enum_types = {}
GW2GLADDITEMS.fields = {GW2GLADDITEMS_ROLE_ID_FIELD, GW2GLADDITEMS_ID_FIELD, GW2GLADDITEMS_NUM_FIELD}
GW2GLADDITEMS.is_extendable = false
GW2GLADDITEMS.extensions = {}
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.name = "role_id"
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLStartBoxGame.role_id"
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.number = 1
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.index = 0
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.label = 2
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.has_default_value = false
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.default_value = 0
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.type = 13
GW2GLSTARTBOXGAME_ROLE_ID_FIELD.cpp_type = 3

GW2GLSTARTBOXGAME_ID_FIELD.name = "id"
GW2GLSTARTBOXGAME_ID_FIELD.full_name = ".net_protocol.GW2GLStartBoxGame.id"
GW2GLSTARTBOXGAME_ID_FIELD.number = 2
GW2GLSTARTBOXGAME_ID_FIELD.index = 1
GW2GLSTARTBOXGAME_ID_FIELD.label = 2
GW2GLSTARTBOXGAME_ID_FIELD.has_default_value = false
GW2GLSTARTBOXGAME_ID_FIELD.default_value = 0
GW2GLSTARTBOXGAME_ID_FIELD.type = 13
GW2GLSTARTBOXGAME_ID_FIELD.cpp_type = 3

GW2GLSTARTBOXGAME_RATE_FIELD.name = "rate"
GW2GLSTARTBOXGAME_RATE_FIELD.full_name = ".net_protocol.GW2GLStartBoxGame.rate"
GW2GLSTARTBOXGAME_RATE_FIELD.number = 3
GW2GLSTARTBOXGAME_RATE_FIELD.index = 2
GW2GLSTARTBOXGAME_RATE_FIELD.label = 2
GW2GLSTARTBOXGAME_RATE_FIELD.has_default_value = false
GW2GLSTARTBOXGAME_RATE_FIELD.default_value = 0
GW2GLSTARTBOXGAME_RATE_FIELD.type = 13
GW2GLSTARTBOXGAME_RATE_FIELD.cpp_type = 3

GW2GLSTARTBOXGAME.name = "GW2GLStartBoxGame"
GW2GLSTARTBOXGAME.full_name = ".net_protocol.GW2GLStartBoxGame"
GW2GLSTARTBOXGAME.nested_types = {}
GW2GLSTARTBOXGAME.enum_types = {}
GW2GLSTARTBOXGAME.fields = {GW2GLSTARTBOXGAME_ROLE_ID_FIELD, GW2GLSTARTBOXGAME_ID_FIELD, GW2GLSTARTBOXGAME_RATE_FIELD}
GW2GLSTARTBOXGAME.is_extendable = false
GW2GLSTARTBOXGAME.extensions = {}
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.name = "role_id"
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.full_name = ".net_protocol.GW2GLStartLottery.role_id"
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.number = 1
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.index = 0
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.label = 2
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.has_default_value = false
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.default_value = 0
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.type = 13
GW2GLSTARTLOTTERY_ROLE_ID_FIELD.cpp_type = 3

GW2GLSTARTLOTTERY_ID_FIELD.name = "id"
GW2GLSTARTLOTTERY_ID_FIELD.full_name = ".net_protocol.GW2GLStartLottery.id"
GW2GLSTARTLOTTERY_ID_FIELD.number = 2
GW2GLSTARTLOTTERY_ID_FIELD.index = 1
GW2GLSTARTLOTTERY_ID_FIELD.label = 2
GW2GLSTARTLOTTERY_ID_FIELD.has_default_value = false
GW2GLSTARTLOTTERY_ID_FIELD.default_value = 0
GW2GLSTARTLOTTERY_ID_FIELD.type = 13
GW2GLSTARTLOTTERY_ID_FIELD.cpp_type = 3

GW2GLSTARTLOTTERY.name = "GW2GLStartLottery"
GW2GLSTARTLOTTERY.full_name = ".net_protocol.GW2GLStartLottery"
GW2GLSTARTLOTTERY.nested_types = {}
GW2GLSTARTLOTTERY.enum_types = {}
GW2GLSTARTLOTTERY.fields = {GW2GLSTARTLOTTERY_ROLE_ID_FIELD, GW2GLSTARTLOTTERY_ID_FIELD}
GW2GLSTARTLOTTERY.is_extendable = false
GW2GLSTARTLOTTERY.extensions = {}

GW2GLAddGoldFish = protobuf.Message(GW2GLADDGOLDFISH)
GW2GLAddGoldPool = protobuf.Message(GW2GLADDGOLDPOOL)
GW2GLAddItems = protobuf.Message(GW2GLADDITEMS)
GW2GLAttackBoss = protobuf.Message(GW2GLATTACKBOSS)
GW2GLAttackFish = protobuf.Message(GW2GLATTACKFISH)
GW2GLChangeGun = protobuf.Message(GW2GLCHANGEGUN)
GW2GLKickAllLeaveScene = protobuf.Message(GW2GLKICKALLLEAVESCENE)
GW2GLReqDestoryScene = protobuf.Message(GW2GLREQDESTORYSCENE)
GW2GLRoleLogout = protobuf.Message(GW2GLROLELOGOUT)
GW2GLRoleOutputCurrency = protobuf.Message(GW2GLROLEOUTPUTCURRENCY)
GW2GLSetGunLevel = protobuf.Message(GW2GLSETGUNLEVEL)
GW2GLStartBoxGame = protobuf.Message(GW2GLSTARTBOXGAME)
GW2GLStartLottery = protobuf.Message(GW2GLSTARTLOTTERY)
GW2GLSynRoleDataInfo = protobuf.Message(GW2GLSYNROLEDATAINFO)
GW2GLTransferScene = protobuf.Message(GW2GLTRANSFERSCENE)
