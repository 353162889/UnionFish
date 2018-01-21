require 'Framework/Language/LuaLanguageCode'
LuaLanguagePack = Class()

function LuaLanguagePack:ctor(...)
	self.languageCode = tostring(select(1,...))
	self.map = {}
end
function LuaLanguagePack:AddString(key,value)
	self.map[key] = value
end

function LuaLanguagePack:RemoveString(key)
	self.map[key] = nil
end

function LuaLanguagePack:Init(map)
	self.map = map
end

function LuaLanguagePack:GetString(key)
	local value = self.map[key]
	if(value ~= nil) then
		return true,value
	end
	return false,key
end

function LuaLanguagePack:ToString()
	if(self.map	~= nil) then
		local str = ""
		for k,v in pairs(self.map) do
			str = str + string.format("%s=%s\n",k,v)
		end
		Log(str)
	end
end

