--先加载基础类
require 'Framework/Command/Impl/CommandSequence'
require 'Framework/Command/Impl/CommandDynamicSequence'
require 'Framework/Command/Impl/CommandSelector'

--再加载子类的引用
require 'GameStarter/Cmd/Cmd_Init'
require 'GameStarter/Cmd/Cmd_Preload'
require 'GameStarter/Cmd/Cmd_Login'
require 'GameStarter/Cmd/Cmd_EnterGame'
require 'GameStarter/Cmd/Cmd_BackToLoginHandler'
require 'GameStarter/Cmd/Cmd_CheckGuide'
require 'GameStarter/Cmd/Cmd_GuideEnterGame'

GameStarter = {}

local _currentSequence
function GameStarter.RunInStart()
	if(_currentSequence ~= nil) then
		LogError("RunInStart need call without game start!")
	end
	_currentSequence = CommandSequence.new()
	local init = Cmd_Init.new()
	local preload = Cmd_Preload.new()
	local login = Cmd_Login.new()
	local checkGuide = Cmd_CheckGuide.new()
	local enterGame = Cmd_EnterGame.new()
	local guideEnterGame = Cmd_GuideEnterGame.new()
	local cmdEnterGame = CommandSelector.new()
	cmdEnterGame:AddCondition(checkGuide,guideEnterGame,enterGame)

	_currentSequence:AddSubCommand(init)
	_currentSequence:AddSubCommand(preload)
	_currentSequence:AddSubCommand(login)
	_currentSequence:AddSubCommand(cmdEnterGame)
	--_currentSequence:AddSubCommand(enterGame)
	_currentSequence:AddDoneFunc(GameStarter.OnEnterDone)
	_currentSequence:Execute()
end

function GameStarter.OnEnterDone()
	Log("EnterGame")
end

function GameStarter.BackToLogin()
	if(_currentSequence ~= nil) then
		_currentSequence:OnDestroy()
		_currentSequence = nil
	end
	_currentSequence = CommandSequence.new()
	local backToLoginHandler = Cmd_BackToLoginHandler.new()
	local login = Cmd_Login.new()
	local checkGuide = Cmd_CheckGuide.new()
	local enterGame = Cmd_EnterGame.new()
	local guideEnterGame = Cmd_GuideEnterGame.new()
	local cmdEnterGame = CommandSelector.new()
	cmdEnterGame:AddCondition(checkGuide,guideEnterGame,enterGame)
	_currentSequence:AddSubCommand(backToLoginHandler)
	_currentSequence:AddSubCommand(login)
	_currentSequence:AddSubCommand(cmdEnterGame)
	_currentSequence:AddDoneFunc(GameStarter.OnEnterDone)
	_currentSequence:Execute()
end