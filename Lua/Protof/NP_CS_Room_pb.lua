-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_CS_Room_pb')


C2SROOMENTERROOM = protobuf.Descriptor();
local C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD = protobuf.FieldDescriptor();
local C2SROOMENTERROOM_ROOM_TYPE_FIELD = protobuf.FieldDescriptor();
C2SROOMSTARTREFRESH = protobuf.Descriptor();
C2SROOMEXITROOM = protobuf.Descriptor();

C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.name = "room_type_id"
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.full_name = ".net_protocol.C2SRoomEnterRoom.room_type_id"
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.number = 1
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.index = 0
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.label = 2
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.has_default_value = false
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.default_value = 0
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.type = 13
C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD.cpp_type = 3

C2SROOMENTERROOM_ROOM_TYPE_FIELD.name = "room_type"
C2SROOMENTERROOM_ROOM_TYPE_FIELD.full_name = ".net_protocol.C2SRoomEnterRoom.room_type"
C2SROOMENTERROOM_ROOM_TYPE_FIELD.number = 2
C2SROOMENTERROOM_ROOM_TYPE_FIELD.index = 1
C2SROOMENTERROOM_ROOM_TYPE_FIELD.label = 2
C2SROOMENTERROOM_ROOM_TYPE_FIELD.has_default_value = false
C2SROOMENTERROOM_ROOM_TYPE_FIELD.default_value = 0
C2SROOMENTERROOM_ROOM_TYPE_FIELD.type = 13
C2SROOMENTERROOM_ROOM_TYPE_FIELD.cpp_type = 3

C2SROOMENTERROOM.name = "C2SRoomEnterRoom"
C2SROOMENTERROOM.full_name = ".net_protocol.C2SRoomEnterRoom"
C2SROOMENTERROOM.nested_types = {}
C2SROOMENTERROOM.enum_types = {}
C2SROOMENTERROOM.fields = {C2SROOMENTERROOM_ROOM_TYPE_ID_FIELD, C2SROOMENTERROOM_ROOM_TYPE_FIELD}
C2SROOMENTERROOM.is_extendable = false
C2SROOMENTERROOM.extensions = {}
C2SROOMSTARTREFRESH.name = "C2SRoomStartRefresh"
C2SROOMSTARTREFRESH.full_name = ".net_protocol.C2SRoomStartRefresh"
C2SROOMSTARTREFRESH.nested_types = {}
C2SROOMSTARTREFRESH.enum_types = {}
C2SROOMSTARTREFRESH.fields = {}
C2SROOMSTARTREFRESH.is_extendable = false
C2SROOMSTARTREFRESH.extensions = {}
C2SROOMEXITROOM.name = "C2SRoomExitRoom"
C2SROOMEXITROOM.full_name = ".net_protocol.C2SRoomExitRoom"
C2SROOMEXITROOM.nested_types = {}
C2SROOMEXITROOM.enum_types = {}
C2SROOMEXITROOM.fields = {}
C2SROOMEXITROOM.is_extendable = false
C2SROOMEXITROOM.extensions = {}

C2SRoomEnterRoom = protobuf.Message(C2SROOMENTERROOM)
C2SRoomExitRoom = protobuf.Message(C2SROOMEXITROOM)
C2SRoomStartRefresh = protobuf.Message(C2SROOMSTARTREFRESH)
