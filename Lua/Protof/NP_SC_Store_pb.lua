-- Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('NP_SC_Store_pb')


S2CSTOREBUY = protobuf.Descriptor();
local S2CSTOREBUY_MONEY_CODE_FIELD = protobuf.FieldDescriptor();
local S2CSTOREBUY_ID_FIELD = protobuf.FieldDescriptor();

S2CSTOREBUY_MONEY_CODE_FIELD.name = "money_code"
S2CSTOREBUY_MONEY_CODE_FIELD.full_name = ".net_protocol.S2CStoreBuy.money_code"
S2CSTOREBUY_MONEY_CODE_FIELD.number = 1
S2CSTOREBUY_MONEY_CODE_FIELD.index = 0
S2CSTOREBUY_MONEY_CODE_FIELD.label = 2
S2CSTOREBUY_MONEY_CODE_FIELD.has_default_value = false
S2CSTOREBUY_MONEY_CODE_FIELD.default_value = 0
S2CSTOREBUY_MONEY_CODE_FIELD.type = 5
S2CSTOREBUY_MONEY_CODE_FIELD.cpp_type = 1

S2CSTOREBUY_ID_FIELD.name = "id"
S2CSTOREBUY_ID_FIELD.full_name = ".net_protocol.S2CStoreBuy.id"
S2CSTOREBUY_ID_FIELD.number = 2
S2CSTOREBUY_ID_FIELD.index = 1
S2CSTOREBUY_ID_FIELD.label = 2
S2CSTOREBUY_ID_FIELD.has_default_value = false
S2CSTOREBUY_ID_FIELD.default_value = 0
S2CSTOREBUY_ID_FIELD.type = 13
S2CSTOREBUY_ID_FIELD.cpp_type = 3

S2CSTOREBUY.name = "S2CStoreBuy"
S2CSTOREBUY.full_name = ".net_protocol.S2CStoreBuy"
S2CSTOREBUY.nested_types = {}
S2CSTOREBUY.enum_types = {}
S2CSTOREBUY.fields = {S2CSTOREBUY_MONEY_CODE_FIELD, S2CSTOREBUY_ID_FIELD}
S2CSTOREBUY.is_extendable = false
S2CSTOREBUY.extensions = {}

S2CStoreBuy = protobuf.Message(S2CSTOREBUY)

