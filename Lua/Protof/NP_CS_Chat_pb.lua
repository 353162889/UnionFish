-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_CS_Chat_pb')


C2SCHANNELCHAT = protobuf.Descriptor();
local C2SCHANNELCHAT_CHANNEL_ID_FIELD = protobuf.FieldDescriptor();
local C2SCHANNELCHAT_MSG_CONTENT_FIELD = protobuf.FieldDescriptor();
local C2SCHANNELCHAT_VOICE_FIELD = protobuf.FieldDescriptor();
C2SSINGLECHAT = protobuf.Descriptor();
local C2SSINGLECHAT_TO_UID_FIELD = protobuf.FieldDescriptor();
local C2SSINGLECHAT_MSG_CONTENT_FIELD = protobuf.FieldDescriptor();
local C2SSINGLECHAT_VOICE_FIELD = protobuf.FieldDescriptor();
C2SCHATGETVOICE = protobuf.Descriptor();
local C2SCHATGETVOICE_VOICE_ID_FIELD = protobuf.FieldDescriptor();

C2SCHANNELCHAT_CHANNEL_ID_FIELD.name = "channel_id"
C2SCHANNELCHAT_CHANNEL_ID_FIELD.full_name = ".net_protocol.C2SChannelChat.channel_id"
C2SCHANNELCHAT_CHANNEL_ID_FIELD.number = 1
C2SCHANNELCHAT_CHANNEL_ID_FIELD.index = 0
C2SCHANNELCHAT_CHANNEL_ID_FIELD.label = 2
C2SCHANNELCHAT_CHANNEL_ID_FIELD.has_default_value = false
C2SCHANNELCHAT_CHANNEL_ID_FIELD.default_value = 0
C2SCHANNELCHAT_CHANNEL_ID_FIELD.type = 13
C2SCHANNELCHAT_CHANNEL_ID_FIELD.cpp_type = 3

C2SCHANNELCHAT_MSG_CONTENT_FIELD.name = "msg_content"
C2SCHANNELCHAT_MSG_CONTENT_FIELD.full_name = ".net_protocol.C2SChannelChat.msg_content"
C2SCHANNELCHAT_MSG_CONTENT_FIELD.number = 2
C2SCHANNELCHAT_MSG_CONTENT_FIELD.index = 1
C2SCHANNELCHAT_MSG_CONTENT_FIELD.label = 2
C2SCHANNELCHAT_MSG_CONTENT_FIELD.has_default_value = false
C2SCHANNELCHAT_MSG_CONTENT_FIELD.default_value = ""
C2SCHANNELCHAT_MSG_CONTENT_FIELD.type = 9
C2SCHANNELCHAT_MSG_CONTENT_FIELD.cpp_type = 9

C2SCHANNELCHAT_VOICE_FIELD.name = "voice"
C2SCHANNELCHAT_VOICE_FIELD.full_name = ".net_protocol.C2SChannelChat.voice"
C2SCHANNELCHAT_VOICE_FIELD.number = 3
C2SCHANNELCHAT_VOICE_FIELD.index = 2
C2SCHANNELCHAT_VOICE_FIELD.label = 1
C2SCHANNELCHAT_VOICE_FIELD.has_default_value = false
C2SCHANNELCHAT_VOICE_FIELD.default_value = ""
C2SCHANNELCHAT_VOICE_FIELD.type = 12
C2SCHANNELCHAT_VOICE_FIELD.cpp_type = 9

C2SCHANNELCHAT.name = "C2SChannelChat"
C2SCHANNELCHAT.full_name = ".net_protocol.C2SChannelChat"
C2SCHANNELCHAT.nested_types = {}
C2SCHANNELCHAT.enum_types = {}
C2SCHANNELCHAT.fields = {C2SCHANNELCHAT_CHANNEL_ID_FIELD, C2SCHANNELCHAT_MSG_CONTENT_FIELD, C2SCHANNELCHAT_VOICE_FIELD}
C2SCHANNELCHAT.is_extendable = false
C2SCHANNELCHAT.extensions = {}
C2SSINGLECHAT_TO_UID_FIELD.name = "to_uid"
C2SSINGLECHAT_TO_UID_FIELD.full_name = ".net_protocol.C2SSingleChat.to_uid"
C2SSINGLECHAT_TO_UID_FIELD.number = 1
C2SSINGLECHAT_TO_UID_FIELD.index = 0
C2SSINGLECHAT_TO_UID_FIELD.label = 2
C2SSINGLECHAT_TO_UID_FIELD.has_default_value = false
C2SSINGLECHAT_TO_UID_FIELD.default_value = 0
C2SSINGLECHAT_TO_UID_FIELD.type = 13
C2SSINGLECHAT_TO_UID_FIELD.cpp_type = 3

C2SSINGLECHAT_MSG_CONTENT_FIELD.name = "msg_content"
C2SSINGLECHAT_MSG_CONTENT_FIELD.full_name = ".net_protocol.C2SSingleChat.msg_content"
C2SSINGLECHAT_MSG_CONTENT_FIELD.number = 2
C2SSINGLECHAT_MSG_CONTENT_FIELD.index = 1
C2SSINGLECHAT_MSG_CONTENT_FIELD.label = 2
C2SSINGLECHAT_MSG_CONTENT_FIELD.has_default_value = false
C2SSINGLECHAT_MSG_CONTENT_FIELD.default_value = ""
C2SSINGLECHAT_MSG_CONTENT_FIELD.type = 9
C2SSINGLECHAT_MSG_CONTENT_FIELD.cpp_type = 9

C2SSINGLECHAT_VOICE_FIELD.name = "voice"
C2SSINGLECHAT_VOICE_FIELD.full_name = ".net_protocol.C2SSingleChat.voice"
C2SSINGLECHAT_VOICE_FIELD.number = 3
C2SSINGLECHAT_VOICE_FIELD.index = 2
C2SSINGLECHAT_VOICE_FIELD.label = 1
C2SSINGLECHAT_VOICE_FIELD.has_default_value = false
C2SSINGLECHAT_VOICE_FIELD.default_value = ""
C2SSINGLECHAT_VOICE_FIELD.type = 12
C2SSINGLECHAT_VOICE_FIELD.cpp_type = 9

C2SSINGLECHAT.name = "C2SSingleChat"
C2SSINGLECHAT.full_name = ".net_protocol.C2SSingleChat"
C2SSINGLECHAT.nested_types = {}
C2SSINGLECHAT.enum_types = {}
C2SSINGLECHAT.fields = {C2SSINGLECHAT_TO_UID_FIELD, C2SSINGLECHAT_MSG_CONTENT_FIELD, C2SSINGLECHAT_VOICE_FIELD}
C2SSINGLECHAT.is_extendable = false
C2SSINGLECHAT.extensions = {}
C2SCHATGETVOICE_VOICE_ID_FIELD.name = "voice_id"
C2SCHATGETVOICE_VOICE_ID_FIELD.full_name = ".net_protocol.C2SChatGetVoice.voice_id"
C2SCHATGETVOICE_VOICE_ID_FIELD.number = 1
C2SCHATGETVOICE_VOICE_ID_FIELD.index = 0
C2SCHATGETVOICE_VOICE_ID_FIELD.label = 2
C2SCHATGETVOICE_VOICE_ID_FIELD.has_default_value = false
C2SCHATGETVOICE_VOICE_ID_FIELD.default_value = 0
C2SCHATGETVOICE_VOICE_ID_FIELD.type = 13
C2SCHATGETVOICE_VOICE_ID_FIELD.cpp_type = 3

C2SCHATGETVOICE.name = "C2SChatGetVoice"
C2SCHATGETVOICE.full_name = ".net_protocol.C2SChatGetVoice"
C2SCHATGETVOICE.nested_types = {}
C2SCHATGETVOICE.enum_types = {}
C2SCHATGETVOICE.fields = {C2SCHATGETVOICE_VOICE_ID_FIELD}
C2SCHATGETVOICE.is_extendable = false
C2SCHATGETVOICE.extensions = {}

C2SChannelChat = protobuf.Message(C2SCHANNELCHAT)
C2SChatGetVoice = protobuf.Message(C2SCHATGETVOICE)
C2SSingleChat = protobuf.Message(C2SSINGLECHAT)

