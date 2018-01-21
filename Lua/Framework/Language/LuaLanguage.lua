require 'Framework/Language/LuaLanguageEvent'
require 'Framework/Language/LuaLanguagePack'
LuaLanguage = CustomEvent()

local this = LuaLanguage
this.languagePack = nil

function this.SetLanguagePack(languagePack)
	if(this.languagePack == nil or languagePack.languageCode ~= this.languagePack.languageCode) then
		local preLanguage = this.languagePack
		this.languagePack = languagePack
		this.SendEvent(LuaLanguageEvent.LanguageUpdate,{preLanguage,this.languagePack})
	end
end

function this.GetString(key)
	return this.languagePack:GetString(key)
end