-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_CS_Scene_pb')


C2SSCENEMOVEGUN = protobuf.Descriptor();
local C2SSCENEMOVEGUN_POINT_FIELD = protobuf.FieldDescriptor();
local C2SSCENEMOVEGUN_ANGLE_FIELD = protobuf.FieldDescriptor();
C2SSCENECHANGEGUN = protobuf.Descriptor();
local C2SSCENECHANGEGUN_WEAPON_FIELD = protobuf.FieldDescriptor();
C2SSCENESENDBULLET = protobuf.Descriptor();
local C2SSCENESENDBULLET_BULLET_TYPE_FIELD = protobuf.FieldDescriptor();
local C2SSCENESENDBULLET_POINT_X_FIELD = protobuf.FieldDescriptor();
local C2SSCENESENDBULLET_POINT_Y_FIELD = protobuf.FieldDescriptor();
local C2SSCENESENDBULLET_ANGLE_FIELD = protobuf.FieldDescriptor();
C2SSCENEGETBACKBULLET = protobuf.Descriptor();
local C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD = protobuf.FieldDescriptor();
C2SSCENEATTACKFISH = protobuf.Descriptor();
local C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD = protobuf.FieldDescriptor();
local C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD = protobuf.FieldDescriptor();
C2SSCENEGUNUNLOCK = protobuf.Descriptor();
local C2SSCENEGUNUNLOCK_LV_ID_FIELD = protobuf.FieldDescriptor();
C2SSCENESETGUNLEVEL = protobuf.Descriptor();
local C2SSCENESETGUNLEVEL_LV_FIELD = protobuf.FieldDescriptor();
C2SSCENETREASURE = protobuf.Descriptor();
local C2SSCENETREASURE_TYPE_FIELD = protobuf.FieldDescriptor();
C2SSCENEOUTBREAK = protobuf.Descriptor();
C2SSCENEATTACKMULTIFISH = protobuf.Descriptor();
local C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD = protobuf.FieldDescriptor();
local C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD = protobuf.FieldDescriptor();
C2SSCENEFUNCTIONFISH = protobuf.Descriptor();
local C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD = protobuf.FieldDescriptor();
local C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD = protobuf.FieldDescriptor();
local C2SSCENEFUNCTIONFISH_PARAMS_FIELD = protobuf.FieldDescriptor();
C2SSCENEAIATTACKFISH = protobuf.Descriptor();
local C2SSCENEAIATTACKFISH_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD = protobuf.FieldDescriptor();
C2SSCENEAIGETBACKBULLET = protobuf.Descriptor();
local C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD = protobuf.FieldDescriptor();
C2SSCENEAIFUNCTIONFISH = protobuf.Descriptor();
local C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD = protobuf.FieldDescriptor();
local C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD = protobuf.FieldDescriptor();

C2SSCENEMOVEGUN_POINT_FIELD.name = "point"
C2SSCENEMOVEGUN_POINT_FIELD.full_name = ".net_protocol.C2SSceneMoveGun.point"
C2SSCENEMOVEGUN_POINT_FIELD.number = 1
C2SSCENEMOVEGUN_POINT_FIELD.index = 0
C2SSCENEMOVEGUN_POINT_FIELD.label = 2
C2SSCENEMOVEGUN_POINT_FIELD.has_default_value = false
C2SSCENEMOVEGUN_POINT_FIELD.default_value = 0.0
C2SSCENEMOVEGUN_POINT_FIELD.type = 2
C2SSCENEMOVEGUN_POINT_FIELD.cpp_type = 6

C2SSCENEMOVEGUN_ANGLE_FIELD.name = "angle"
C2SSCENEMOVEGUN_ANGLE_FIELD.full_name = ".net_protocol.C2SSceneMoveGun.angle"
C2SSCENEMOVEGUN_ANGLE_FIELD.number = 2
C2SSCENEMOVEGUN_ANGLE_FIELD.index = 1
C2SSCENEMOVEGUN_ANGLE_FIELD.label = 2
C2SSCENEMOVEGUN_ANGLE_FIELD.has_default_value = false
C2SSCENEMOVEGUN_ANGLE_FIELD.default_value = 0.0
C2SSCENEMOVEGUN_ANGLE_FIELD.type = 2
C2SSCENEMOVEGUN_ANGLE_FIELD.cpp_type = 6

C2SSCENEMOVEGUN.name = "C2SSceneMoveGun"
C2SSCENEMOVEGUN.full_name = ".net_protocol.C2SSceneMoveGun"
C2SSCENEMOVEGUN.nested_types = {}
C2SSCENEMOVEGUN.enum_types = {}
C2SSCENEMOVEGUN.fields = {C2SSCENEMOVEGUN_POINT_FIELD, C2SSCENEMOVEGUN_ANGLE_FIELD}
C2SSCENEMOVEGUN.is_extendable = false
C2SSCENEMOVEGUN.extensions = {}
C2SSCENECHANGEGUN_WEAPON_FIELD.name = "weapon"
C2SSCENECHANGEGUN_WEAPON_FIELD.full_name = ".net_protocol.C2SSceneChangeGun.weapon"
C2SSCENECHANGEGUN_WEAPON_FIELD.number = 1
C2SSCENECHANGEGUN_WEAPON_FIELD.index = 0
C2SSCENECHANGEGUN_WEAPON_FIELD.label = 2
C2SSCENECHANGEGUN_WEAPON_FIELD.has_default_value = false
C2SSCENECHANGEGUN_WEAPON_FIELD.default_value = 0
C2SSCENECHANGEGUN_WEAPON_FIELD.type = 13
C2SSCENECHANGEGUN_WEAPON_FIELD.cpp_type = 3

C2SSCENECHANGEGUN.name = "C2SSceneChangeGun"
C2SSCENECHANGEGUN.full_name = ".net_protocol.C2SSceneChangeGun"
C2SSCENECHANGEGUN.nested_types = {}
C2SSCENECHANGEGUN.enum_types = {}
C2SSCENECHANGEGUN.fields = {C2SSCENECHANGEGUN_WEAPON_FIELD}
C2SSCENECHANGEGUN.is_extendable = false
C2SSCENECHANGEGUN.extensions = {}
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.name = "bullet_type"
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.full_name = ".net_protocol.C2SSceneSendBullet.bullet_type"
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.number = 1
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.index = 0
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.label = 2
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.has_default_value = false
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.default_value = 0
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.type = 13
C2SSCENESENDBULLET_BULLET_TYPE_FIELD.cpp_type = 3

C2SSCENESENDBULLET_POINT_X_FIELD.name = "point_x"
C2SSCENESENDBULLET_POINT_X_FIELD.full_name = ".net_protocol.C2SSceneSendBullet.point_x"
C2SSCENESENDBULLET_POINT_X_FIELD.number = 2
C2SSCENESENDBULLET_POINT_X_FIELD.index = 1
C2SSCENESENDBULLET_POINT_X_FIELD.label = 2
C2SSCENESENDBULLET_POINT_X_FIELD.has_default_value = false
C2SSCENESENDBULLET_POINT_X_FIELD.default_value = 0.0
C2SSCENESENDBULLET_POINT_X_FIELD.type = 2
C2SSCENESENDBULLET_POINT_X_FIELD.cpp_type = 6

C2SSCENESENDBULLET_POINT_Y_FIELD.name = "point_y"
C2SSCENESENDBULLET_POINT_Y_FIELD.full_name = ".net_protocol.C2SSceneSendBullet.point_y"
C2SSCENESENDBULLET_POINT_Y_FIELD.number = 3
C2SSCENESENDBULLET_POINT_Y_FIELD.index = 2
C2SSCENESENDBULLET_POINT_Y_FIELD.label = 2
C2SSCENESENDBULLET_POINT_Y_FIELD.has_default_value = false
C2SSCENESENDBULLET_POINT_Y_FIELD.default_value = 0.0
C2SSCENESENDBULLET_POINT_Y_FIELD.type = 2
C2SSCENESENDBULLET_POINT_Y_FIELD.cpp_type = 6

C2SSCENESENDBULLET_ANGLE_FIELD.name = "angle"
C2SSCENESENDBULLET_ANGLE_FIELD.full_name = ".net_protocol.C2SSceneSendBullet.angle"
C2SSCENESENDBULLET_ANGLE_FIELD.number = 4
C2SSCENESENDBULLET_ANGLE_FIELD.index = 3
C2SSCENESENDBULLET_ANGLE_FIELD.label = 2
C2SSCENESENDBULLET_ANGLE_FIELD.has_default_value = false
C2SSCENESENDBULLET_ANGLE_FIELD.default_value = 0.0
C2SSCENESENDBULLET_ANGLE_FIELD.type = 2
C2SSCENESENDBULLET_ANGLE_FIELD.cpp_type = 6

C2SSCENESENDBULLET.name = "C2SSceneSendBullet"
C2SSCENESENDBULLET.full_name = ".net_protocol.C2SSceneSendBullet"
C2SSCENESENDBULLET.nested_types = {}
C2SSCENESENDBULLET.enum_types = {}
C2SSCENESENDBULLET.fields = {C2SSCENESENDBULLET_BULLET_TYPE_FIELD, C2SSCENESENDBULLET_POINT_X_FIELD, C2SSCENESENDBULLET_POINT_Y_FIELD, C2SSCENESENDBULLET_ANGLE_FIELD}
C2SSCENESENDBULLET.is_extendable = false
C2SSCENESENDBULLET.extensions = {}
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.name = "bullet_only_key"
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.full_name = ".net_protocol.C2SSceneGetBackBullet.bullet_only_key"
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.number = 1
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.index = 0
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.label = 2
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.has_default_value = false
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.default_value = 0
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.type = 13
C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD.cpp_type = 3

C2SSCENEGETBACKBULLET.name = "C2SSceneGetBackBullet"
C2SSCENEGETBACKBULLET.full_name = ".net_protocol.C2SSceneGetBackBullet"
C2SSCENEGETBACKBULLET.nested_types = {}
C2SSCENEGETBACKBULLET.enum_types = {}
C2SSCENEGETBACKBULLET.fields = {C2SSCENEGETBACKBULLET_BULLET_ONLY_KEY_FIELD}
C2SSCENEGETBACKBULLET.is_extendable = false
C2SSCENEGETBACKBULLET.extensions = {}
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.name = "bullet_only_key"
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.full_name = ".net_protocol.C2SSceneAttackFish.bullet_only_key"
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.number = 1
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.index = 0
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.label = 2
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.has_default_value = false
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.default_value = 0
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.type = 13
C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD.cpp_type = 3

C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.name = "fish_obj_id"
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.full_name = ".net_protocol.C2SSceneAttackFish.fish_obj_id"
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.number = 2
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.index = 1
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.label = 2
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.has_default_value = false
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.default_value = 0
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.type = 13
C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD.cpp_type = 3

C2SSCENEATTACKFISH.name = "C2SSceneAttackFish"
C2SSCENEATTACKFISH.full_name = ".net_protocol.C2SSceneAttackFish"
C2SSCENEATTACKFISH.nested_types = {}
C2SSCENEATTACKFISH.enum_types = {}
C2SSCENEATTACKFISH.fields = {C2SSCENEATTACKFISH_BULLET_ONLY_KEY_FIELD, C2SSCENEATTACKFISH_FISH_OBJ_ID_FIELD}
C2SSCENEATTACKFISH.is_extendable = false
C2SSCENEATTACKFISH.extensions = {}
C2SSCENEGUNUNLOCK_LV_ID_FIELD.name = "lv_id"
C2SSCENEGUNUNLOCK_LV_ID_FIELD.full_name = ".net_protocol.C2SSceneGunUnlock.lv_id"
C2SSCENEGUNUNLOCK_LV_ID_FIELD.number = 1
C2SSCENEGUNUNLOCK_LV_ID_FIELD.index = 0
C2SSCENEGUNUNLOCK_LV_ID_FIELD.label = 2
C2SSCENEGUNUNLOCK_LV_ID_FIELD.has_default_value = false
C2SSCENEGUNUNLOCK_LV_ID_FIELD.default_value = 0
C2SSCENEGUNUNLOCK_LV_ID_FIELD.type = 13
C2SSCENEGUNUNLOCK_LV_ID_FIELD.cpp_type = 3

C2SSCENEGUNUNLOCK.name = "C2SSceneGunUnlock"
C2SSCENEGUNUNLOCK.full_name = ".net_protocol.C2SSceneGunUnlock"
C2SSCENEGUNUNLOCK.nested_types = {}
C2SSCENEGUNUNLOCK.enum_types = {}
C2SSCENEGUNUNLOCK.fields = {C2SSCENEGUNUNLOCK_LV_ID_FIELD}
C2SSCENEGUNUNLOCK.is_extendable = false
C2SSCENEGUNUNLOCK.extensions = {}
C2SSCENESETGUNLEVEL_LV_FIELD.name = "lv"
C2SSCENESETGUNLEVEL_LV_FIELD.full_name = ".net_protocol.C2SSceneSetGunLevel.lv"
C2SSCENESETGUNLEVEL_LV_FIELD.number = 1
C2SSCENESETGUNLEVEL_LV_FIELD.index = 0
C2SSCENESETGUNLEVEL_LV_FIELD.label = 2
C2SSCENESETGUNLEVEL_LV_FIELD.has_default_value = false
C2SSCENESETGUNLEVEL_LV_FIELD.default_value = 0
C2SSCENESETGUNLEVEL_LV_FIELD.type = 13
C2SSCENESETGUNLEVEL_LV_FIELD.cpp_type = 3

C2SSCENESETGUNLEVEL.name = "C2SSceneSetGunLevel"
C2SSCENESETGUNLEVEL.full_name = ".net_protocol.C2SSceneSetGunLevel"
C2SSCENESETGUNLEVEL.nested_types = {}
C2SSCENESETGUNLEVEL.enum_types = {}
C2SSCENESETGUNLEVEL.fields = {C2SSCENESETGUNLEVEL_LV_FIELD}
C2SSCENESETGUNLEVEL.is_extendable = false
C2SSCENESETGUNLEVEL.extensions = {}
C2SSCENETREASURE_TYPE_FIELD.name = "type"
C2SSCENETREASURE_TYPE_FIELD.full_name = ".net_protocol.C2SSceneTreasure.type"
C2SSCENETREASURE_TYPE_FIELD.number = 1
C2SSCENETREASURE_TYPE_FIELD.index = 0
C2SSCENETREASURE_TYPE_FIELD.label = 2
C2SSCENETREASURE_TYPE_FIELD.has_default_value = false
C2SSCENETREASURE_TYPE_FIELD.default_value = 0
C2SSCENETREASURE_TYPE_FIELD.type = 13
C2SSCENETREASURE_TYPE_FIELD.cpp_type = 3

C2SSCENETREASURE.name = "C2SSceneTreasure"
C2SSCENETREASURE.full_name = ".net_protocol.C2SSceneTreasure"
C2SSCENETREASURE.nested_types = {}
C2SSCENETREASURE.enum_types = {}
C2SSCENETREASURE.fields = {C2SSCENETREASURE_TYPE_FIELD}
C2SSCENETREASURE.is_extendable = false
C2SSCENETREASURE.extensions = {}
C2SSCENEOUTBREAK.name = "C2SSceneOutBreak"
C2SSCENEOUTBREAK.full_name = ".net_protocol.C2SSceneOutBreak"
C2SSCENEOUTBREAK.nested_types = {}
C2SSCENEOUTBREAK.enum_types = {}
C2SSCENEOUTBREAK.fields = {}
C2SSCENEOUTBREAK.is_extendable = false
C2SSCENEOUTBREAK.extensions = {}
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.name = "status_id"
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.full_name = ".net_protocol.C2SSceneAttackMultiFish.status_id"
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.number = 1
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.index = 0
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.label = 2
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.has_default_value = false
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.default_value = 0
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.type = 13
C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD.cpp_type = 3

C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.name = "fish_obj_id_list"
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.full_name = ".net_protocol.C2SSceneAttackMultiFish.fish_obj_id_list"
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.number = 2
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.index = 1
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.label = 3
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.has_default_value = false
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.default_value = {}
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.type = 13
C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD.cpp_type = 3

C2SSCENEATTACKMULTIFISH.name = "C2SSceneAttackMultiFish"
C2SSCENEATTACKMULTIFISH.full_name = ".net_protocol.C2SSceneAttackMultiFish"
C2SSCENEATTACKMULTIFISH.nested_types = {}
C2SSCENEATTACKMULTIFISH.enum_types = {}
C2SSCENEATTACKMULTIFISH.fields = {C2SSCENEATTACKMULTIFISH_STATUS_ID_FIELD, C2SSCENEATTACKMULTIFISH_FISH_OBJ_ID_LIST_FIELD}
C2SSCENEATTACKMULTIFISH.is_extendable = false
C2SSCENEATTACKMULTIFISH.extensions = {}
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.name = "func_type"
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.full_name = ".net_protocol.C2SSceneFunctionFish.func_type"
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.number = 1
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.index = 0
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.label = 2
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.has_default_value = false
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.default_value = 0
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.type = 13
C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD.cpp_type = 3

C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.name = "fish_obj_id_list"
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.full_name = ".net_protocol.C2SSceneFunctionFish.fish_obj_id_list"
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.number = 2
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.index = 1
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.label = 3
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.has_default_value = false
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.default_value = {}
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.type = 13
C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.cpp_type = 3

C2SSCENEFUNCTIONFISH_PARAMS_FIELD.name = "params"
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.full_name = ".net_protocol.C2SSceneFunctionFish.params"
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.number = 3
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.index = 2
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.label = 2
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.has_default_value = false
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.default_value = ""
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.type = 9
C2SSCENEFUNCTIONFISH_PARAMS_FIELD.cpp_type = 9

C2SSCENEFUNCTIONFISH.name = "C2SSceneFunctionFish"
C2SSCENEFUNCTIONFISH.full_name = ".net_protocol.C2SSceneFunctionFish"
C2SSCENEFUNCTIONFISH.nested_types = {}
C2SSCENEFUNCTIONFISH.enum_types = {}
C2SSCENEFUNCTIONFISH.fields = {C2SSCENEFUNCTIONFISH_FUNC_TYPE_FIELD, C2SSCENEFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD, C2SSCENEFUNCTIONFISH_PARAMS_FIELD}
C2SSCENEFUNCTIONFISH.is_extendable = false
C2SSCENEFUNCTIONFISH.extensions = {}
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.name = "role_id"
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.full_name = ".net_protocol.C2SSceneAIAttackFish.role_id"
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.number = 1
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.index = 0
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.label = 2
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.has_default_value = false
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.default_value = 0
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.type = 13
C2SSCENEAIATTACKFISH_ROLE_ID_FIELD.cpp_type = 3

C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.name = "bullet_only_key"
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.full_name = ".net_protocol.C2SSceneAIAttackFish.bullet_only_key"
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.number = 2
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.index = 1
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.label = 2
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.has_default_value = false
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.default_value = 0
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.type = 13
C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD.cpp_type = 3

C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.name = "fish_obj_id"
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.full_name = ".net_protocol.C2SSceneAIAttackFish.fish_obj_id"
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.number = 3
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.index = 2
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.label = 2
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.has_default_value = false
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.default_value = 0
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.type = 13
C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD.cpp_type = 3

C2SSCENEAIATTACKFISH.name = "C2SSceneAIAttackFish"
C2SSCENEAIATTACKFISH.full_name = ".net_protocol.C2SSceneAIAttackFish"
C2SSCENEAIATTACKFISH.nested_types = {}
C2SSCENEAIATTACKFISH.enum_types = {}
C2SSCENEAIATTACKFISH.fields = {C2SSCENEAIATTACKFISH_ROLE_ID_FIELD, C2SSCENEAIATTACKFISH_BULLET_ONLY_KEY_FIELD, C2SSCENEAIATTACKFISH_FISH_OBJ_ID_FIELD}
C2SSCENEAIATTACKFISH.is_extendable = false
C2SSCENEAIATTACKFISH.extensions = {}
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.name = "role_id"
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.full_name = ".net_protocol.C2SSceneAIGetBackBullet.role_id"
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.number = 1
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.index = 0
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.label = 2
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.has_default_value = false
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.default_value = 0
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.type = 13
C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD.cpp_type = 3

C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.name = "bullet_only_key"
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.full_name = ".net_protocol.C2SSceneAIGetBackBullet.bullet_only_key"
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.number = 2
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.index = 1
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.label = 2
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.has_default_value = false
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.default_value = 0
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.type = 13
C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD.cpp_type = 3

C2SSCENEAIGETBACKBULLET.name = "C2SSceneAIGetBackBullet"
C2SSCENEAIGETBACKBULLET.full_name = ".net_protocol.C2SSceneAIGetBackBullet"
C2SSCENEAIGETBACKBULLET.nested_types = {}
C2SSCENEAIGETBACKBULLET.enum_types = {}
C2SSCENEAIGETBACKBULLET.fields = {C2SSCENEAIGETBACKBULLET_ROLE_ID_FIELD, C2SSCENEAIGETBACKBULLET_BULLET_ONLY_KEY_FIELD}
C2SSCENEAIGETBACKBULLET.is_extendable = false
C2SSCENEAIGETBACKBULLET.extensions = {}
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.name = "role_id"
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.full_name = ".net_protocol.C2SSceneAIFunctionFish.role_id"
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.number = 1
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.index = 0
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.label = 2
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.has_default_value = false
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.default_value = 0
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.type = 13
C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD.cpp_type = 3

C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.name = "func_type"
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.full_name = ".net_protocol.C2SSceneAIFunctionFish.func_type"
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.number = 2
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.index = 1
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.label = 2
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.has_default_value = false
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.default_value = 0
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.type = 13
C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD.cpp_type = 3

C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.name = "fish_obj_id_list"
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.full_name = ".net_protocol.C2SSceneAIFunctionFish.fish_obj_id_list"
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.number = 3
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.index = 2
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.label = 3
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.has_default_value = false
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.default_value = {}
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.type = 13
C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD.cpp_type = 3

C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.name = "params"
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.full_name = ".net_protocol.C2SSceneAIFunctionFish.params"
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.number = 4
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.index = 3
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.label = 2
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.has_default_value = false
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.default_value = ""
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.type = 9
C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD.cpp_type = 9

C2SSCENEAIFUNCTIONFISH.name = "C2SSceneAIFunctionFish"
C2SSCENEAIFUNCTIONFISH.full_name = ".net_protocol.C2SSceneAIFunctionFish"
C2SSCENEAIFUNCTIONFISH.nested_types = {}
C2SSCENEAIFUNCTIONFISH.enum_types = {}
C2SSCENEAIFUNCTIONFISH.fields = {C2SSCENEAIFUNCTIONFISH_ROLE_ID_FIELD, C2SSCENEAIFUNCTIONFISH_FUNC_TYPE_FIELD, C2SSCENEAIFUNCTIONFISH_FISH_OBJ_ID_LIST_FIELD, C2SSCENEAIFUNCTIONFISH_PARAMS_FIELD}
C2SSCENEAIFUNCTIONFISH.is_extendable = false
C2SSCENEAIFUNCTIONFISH.extensions = {}

C2SSceneAIAttackFish = protobuf.Message(C2SSCENEAIATTACKFISH)
C2SSceneAIFunctionFish = protobuf.Message(C2SSCENEAIFUNCTIONFISH)
C2SSceneAIGetBackBullet = protobuf.Message(C2SSCENEAIGETBACKBULLET)
C2SSceneAttackFish = protobuf.Message(C2SSCENEATTACKFISH)
C2SSceneAttackMultiFish = protobuf.Message(C2SSCENEATTACKMULTIFISH)
C2SSceneChangeGun = protobuf.Message(C2SSCENECHANGEGUN)
C2SSceneFunctionFish = protobuf.Message(C2SSCENEFUNCTIONFISH)
C2SSceneGetBackBullet = protobuf.Message(C2SSCENEGETBACKBULLET)
C2SSceneGunUnlock = protobuf.Message(C2SSCENEGUNUNLOCK)
C2SSceneMoveGun = protobuf.Message(C2SSCENEMOVEGUN)
C2SSceneOutBreak = protobuf.Message(C2SSCENEOUTBREAK)
C2SSceneSendBullet = protobuf.Message(C2SSCENESENDBULLET)
C2SSceneSetGunLevel = protobuf.Message(C2SSCENESETGUNLEVEL)
C2SSceneTreasure = protobuf.Message(C2SSCENETREASURE)

