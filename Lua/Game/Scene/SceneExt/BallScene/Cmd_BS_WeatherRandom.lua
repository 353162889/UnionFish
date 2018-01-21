Cmd_BS_WeatherRandom = Class(CommandBase)

function Cmd_BS_WeatherRandom:Execute(context)
	Cmd_BS_WeatherRandom.superclass.Execute(self,context)

	--随机当前天气
	local scene = Res.scene[BallScene.sceneId]
	local sceneTime = scene.time
	local sceneWeather = scene.weather
	if(#sceneTime > 0 and #sceneWeather > 0) then
		local timeRandom = LH.Random(1,#sceneTime + 1)
		local weatherRandom = LH.Random(1,#sceneWeather + 1)
		local weatherId = tonumber(tostring(timeRandom)..tostring(weatherRandom))
		BallScene.weather = Res.weather[weatherId];
	else
		BallScene.weather = nil
	end

	self:OnExecuteDone(CmdExecuteState.Success)
end
