-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_SC_Mail_pb')


RAWARD = protobuf.Descriptor();
local RAWARD_ID_FIELD = protobuf.FieldDescriptor();
local RAWARD_NUM_FIELD = protobuf.FieldDescriptor();
MAIL = protobuf.Descriptor();
local MAIL_ID_FIELD = protobuf.FieldDescriptor();
local MAIL_TITLE_FIELD = protobuf.FieldDescriptor();
local MAIL_SENDER_FIELD = protobuf.FieldDescriptor();
local MAIL_TXT_FIELD = protobuf.FieldDescriptor();
local MAIL_RAWARD_LIST_FIELD = protobuf.FieldDescriptor();
local MAIL_START_TIME_FIELD = protobuf.FieldDescriptor();
local MAIL_END_TIME_FIELD = protobuf.FieldDescriptor();
local MAIL_MAIL_TYPE_FIELD = protobuf.FieldDescriptor();
S2CMAILGETINFO = protobuf.Descriptor();
local S2CMAILGETINFO_MAIL_LIST_FIELD = protobuf.FieldDescriptor();
S2CMAILGET = protobuf.Descriptor();
local S2CMAILGET_RAWARD_LIST_FIELD = protobuf.FieldDescriptor();
S2CMAILGETALL = protobuf.Descriptor();
local S2CMAILGETALL_RAWARD_LIST_FIELD = protobuf.FieldDescriptor();
S2CMAILUPDATE = protobuf.Descriptor();
local S2CMAILUPDATE_MAIL_LIST_FIELD = protobuf.FieldDescriptor();

RAWARD_ID_FIELD.name = "id"
RAWARD_ID_FIELD.full_name = ".net_protocol.Raward.id"
RAWARD_ID_FIELD.number = 1
RAWARD_ID_FIELD.index = 0
RAWARD_ID_FIELD.label = 2
RAWARD_ID_FIELD.has_default_value = false
RAWARD_ID_FIELD.default_value = 0
RAWARD_ID_FIELD.type = 13
RAWARD_ID_FIELD.cpp_type = 3

RAWARD_NUM_FIELD.name = "num"
RAWARD_NUM_FIELD.full_name = ".net_protocol.Raward.num"
RAWARD_NUM_FIELD.number = 2
RAWARD_NUM_FIELD.index = 1
RAWARD_NUM_FIELD.label = 2
RAWARD_NUM_FIELD.has_default_value = false
RAWARD_NUM_FIELD.default_value = 0
RAWARD_NUM_FIELD.type = 13
RAWARD_NUM_FIELD.cpp_type = 3

RAWARD.name = "Raward"
RAWARD.full_name = ".net_protocol.Raward"
RAWARD.nested_types = {}
RAWARD.enum_types = {}
RAWARD.fields = {RAWARD_ID_FIELD, RAWARD_NUM_FIELD}
RAWARD.is_extendable = false
RAWARD.extensions = {}
MAIL_ID_FIELD.name = "id"
MAIL_ID_FIELD.full_name = ".net_protocol.Mail.id"
MAIL_ID_FIELD.number = 1
MAIL_ID_FIELD.index = 0
MAIL_ID_FIELD.label = 2
MAIL_ID_FIELD.has_default_value = false
MAIL_ID_FIELD.default_value = 0
MAIL_ID_FIELD.type = 13
MAIL_ID_FIELD.cpp_type = 3

MAIL_TITLE_FIELD.name = "title"
MAIL_TITLE_FIELD.full_name = ".net_protocol.Mail.title"
MAIL_TITLE_FIELD.number = 2
MAIL_TITLE_FIELD.index = 1
MAIL_TITLE_FIELD.label = 2
MAIL_TITLE_FIELD.has_default_value = false
MAIL_TITLE_FIELD.default_value = ""
MAIL_TITLE_FIELD.type = 9
MAIL_TITLE_FIELD.cpp_type = 9

MAIL_SENDER_FIELD.name = "sender"
MAIL_SENDER_FIELD.full_name = ".net_protocol.Mail.sender"
MAIL_SENDER_FIELD.number = 3
MAIL_SENDER_FIELD.index = 2
MAIL_SENDER_FIELD.label = 2
MAIL_SENDER_FIELD.has_default_value = false
MAIL_SENDER_FIELD.default_value = ""
MAIL_SENDER_FIELD.type = 9
MAIL_SENDER_FIELD.cpp_type = 9

MAIL_TXT_FIELD.name = "txt"
MAIL_TXT_FIELD.full_name = ".net_protocol.Mail.txt"
MAIL_TXT_FIELD.number = 4
MAIL_TXT_FIELD.index = 3
MAIL_TXT_FIELD.label = 2
MAIL_TXT_FIELD.has_default_value = false
MAIL_TXT_FIELD.default_value = ""
MAIL_TXT_FIELD.type = 9
MAIL_TXT_FIELD.cpp_type = 9

MAIL_RAWARD_LIST_FIELD.name = "raward_list"
MAIL_RAWARD_LIST_FIELD.full_name = ".net_protocol.Mail.raward_list"
MAIL_RAWARD_LIST_FIELD.number = 5
MAIL_RAWARD_LIST_FIELD.index = 4
MAIL_RAWARD_LIST_FIELD.label = 3
MAIL_RAWARD_LIST_FIELD.has_default_value = false
MAIL_RAWARD_LIST_FIELD.default_value = {}
MAIL_RAWARD_LIST_FIELD.message_type = RAWARD
MAIL_RAWARD_LIST_FIELD.type = 11
MAIL_RAWARD_LIST_FIELD.cpp_type = 10

MAIL_START_TIME_FIELD.name = "start_time"
MAIL_START_TIME_FIELD.full_name = ".net_protocol.Mail.start_time"
MAIL_START_TIME_FIELD.number = 6
MAIL_START_TIME_FIELD.index = 5
MAIL_START_TIME_FIELD.label = 2
MAIL_START_TIME_FIELD.has_default_value = false
MAIL_START_TIME_FIELD.default_value = 0
MAIL_START_TIME_FIELD.type = 4
MAIL_START_TIME_FIELD.cpp_type = 4

MAIL_END_TIME_FIELD.name = "end_time"
MAIL_END_TIME_FIELD.full_name = ".net_protocol.Mail.end_time"
MAIL_END_TIME_FIELD.number = 7
MAIL_END_TIME_FIELD.index = 6
MAIL_END_TIME_FIELD.label = 2
MAIL_END_TIME_FIELD.has_default_value = false
MAIL_END_TIME_FIELD.default_value = 0
MAIL_END_TIME_FIELD.type = 4
MAIL_END_TIME_FIELD.cpp_type = 4

MAIL_MAIL_TYPE_FIELD.name = "mail_type"
MAIL_MAIL_TYPE_FIELD.full_name = ".net_protocol.Mail.mail_type"
MAIL_MAIL_TYPE_FIELD.number = 8
MAIL_MAIL_TYPE_FIELD.index = 7
MAIL_MAIL_TYPE_FIELD.label = 2
MAIL_MAIL_TYPE_FIELD.has_default_value = false
MAIL_MAIL_TYPE_FIELD.default_value = 0
MAIL_MAIL_TYPE_FIELD.type = 13
MAIL_MAIL_TYPE_FIELD.cpp_type = 3

MAIL.name = "Mail"
MAIL.full_name = ".net_protocol.Mail"
MAIL.nested_types = {}
MAIL.enum_types = {}
MAIL.fields = {MAIL_ID_FIELD, MAIL_TITLE_FIELD, MAIL_SENDER_FIELD, MAIL_TXT_FIELD, MAIL_RAWARD_LIST_FIELD, MAIL_START_TIME_FIELD, MAIL_END_TIME_FIELD, MAIL_MAIL_TYPE_FIELD}
MAIL.is_extendable = false
MAIL.extensions = {}
S2CMAILGETINFO_MAIL_LIST_FIELD.name = "mail_list"
S2CMAILGETINFO_MAIL_LIST_FIELD.full_name = ".net_protocol.S2CMailGetInfo.mail_list"
S2CMAILGETINFO_MAIL_LIST_FIELD.number = 1
S2CMAILGETINFO_MAIL_LIST_FIELD.index = 0
S2CMAILGETINFO_MAIL_LIST_FIELD.label = 3
S2CMAILGETINFO_MAIL_LIST_FIELD.has_default_value = false
S2CMAILGETINFO_MAIL_LIST_FIELD.default_value = {}
S2CMAILGETINFO_MAIL_LIST_FIELD.message_type = MAIL
S2CMAILGETINFO_MAIL_LIST_FIELD.type = 11
S2CMAILGETINFO_MAIL_LIST_FIELD.cpp_type = 10

S2CMAILGETINFO.name = "S2CMailGetInfo"
S2CMAILGETINFO.full_name = ".net_protocol.S2CMailGetInfo"
S2CMAILGETINFO.nested_types = {}
S2CMAILGETINFO.enum_types = {}
S2CMAILGETINFO.fields = {S2CMAILGETINFO_MAIL_LIST_FIELD}
S2CMAILGETINFO.is_extendable = false
S2CMAILGETINFO.extensions = {}
S2CMAILGET_RAWARD_LIST_FIELD.name = "raward_list"
S2CMAILGET_RAWARD_LIST_FIELD.full_name = ".net_protocol.S2CMailGet.raward_list"
S2CMAILGET_RAWARD_LIST_FIELD.number = 1
S2CMAILGET_RAWARD_LIST_FIELD.index = 0
S2CMAILGET_RAWARD_LIST_FIELD.label = 3
S2CMAILGET_RAWARD_LIST_FIELD.has_default_value = false
S2CMAILGET_RAWARD_LIST_FIELD.default_value = {}
S2CMAILGET_RAWARD_LIST_FIELD.message_type = RAWARD
S2CMAILGET_RAWARD_LIST_FIELD.type = 11
S2CMAILGET_RAWARD_LIST_FIELD.cpp_type = 10

S2CMAILGET.name = "S2CMailGet"
S2CMAILGET.full_name = ".net_protocol.S2CMailGet"
S2CMAILGET.nested_types = {}
S2CMAILGET.enum_types = {}
S2CMAILGET.fields = {S2CMAILGET_RAWARD_LIST_FIELD}
S2CMAILGET.is_extendable = false
S2CMAILGET.extensions = {}
S2CMAILGETALL_RAWARD_LIST_FIELD.name = "raward_list"
S2CMAILGETALL_RAWARD_LIST_FIELD.full_name = ".net_protocol.S2CMailGetAll.raward_list"
S2CMAILGETALL_RAWARD_LIST_FIELD.number = 1
S2CMAILGETALL_RAWARD_LIST_FIELD.index = 0
S2CMAILGETALL_RAWARD_LIST_FIELD.label = 3
S2CMAILGETALL_RAWARD_LIST_FIELD.has_default_value = false
S2CMAILGETALL_RAWARD_LIST_FIELD.default_value = {}
S2CMAILGETALL_RAWARD_LIST_FIELD.message_type = RAWARD
S2CMAILGETALL_RAWARD_LIST_FIELD.type = 11
S2CMAILGETALL_RAWARD_LIST_FIELD.cpp_type = 10

S2CMAILGETALL.name = "S2CMailGetAll"
S2CMAILGETALL.full_name = ".net_protocol.S2CMailGetAll"
S2CMAILGETALL.nested_types = {}
S2CMAILGETALL.enum_types = {}
S2CMAILGETALL.fields = {S2CMAILGETALL_RAWARD_LIST_FIELD}
S2CMAILGETALL.is_extendable = false
S2CMAILGETALL.extensions = {}
S2CMAILUPDATE_MAIL_LIST_FIELD.name = "mail_list"
S2CMAILUPDATE_MAIL_LIST_FIELD.full_name = ".net_protocol.S2CMailUpdate.mail_list"
S2CMAILUPDATE_MAIL_LIST_FIELD.number = 1
S2CMAILUPDATE_MAIL_LIST_FIELD.index = 0
S2CMAILUPDATE_MAIL_LIST_FIELD.label = 3
S2CMAILUPDATE_MAIL_LIST_FIELD.has_default_value = false
S2CMAILUPDATE_MAIL_LIST_FIELD.default_value = {}
S2CMAILUPDATE_MAIL_LIST_FIELD.message_type = MAIL
S2CMAILUPDATE_MAIL_LIST_FIELD.type = 11
S2CMAILUPDATE_MAIL_LIST_FIELD.cpp_type = 10

S2CMAILUPDATE.name = "S2CMailUpdate"
S2CMAILUPDATE.full_name = ".net_protocol.S2CMailUpdate"
S2CMAILUPDATE.nested_types = {}
S2CMAILUPDATE.enum_types = {}
S2CMAILUPDATE.fields = {S2CMAILUPDATE_MAIL_LIST_FIELD}
S2CMAILUPDATE.is_extendable = false
S2CMAILUPDATE.extensions = {}

Mail = protobuf.Message(MAIL)
Raward = protobuf.Message(RAWARD)
S2CMailGet = protobuf.Message(S2CMAILGET)
S2CMailGetAll = protobuf.Message(S2CMAILGETALL)
S2CMailGetInfo = protobuf.Message(S2CMAILGETINFO)
S2CMailUpdate = protobuf.Message(S2CMAILUPDATE)

