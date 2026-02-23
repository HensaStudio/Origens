-----------------------------------------------------------------------------------------------------------------------------------------
-- NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Notify")
AddEventHandler("Notify",function(Title,Message,Color,Timer,Position,Mode,Route,Silenced)
	if Route and LocalPlayer["state"]["Route"] ~= Route then
		return false
	end

	Mode = Mode or Config.Mode
	Timer = Timer or Config.Timer
	Position = Position or Config.Position

	if Config.Themes[Color]["sound"] and not Silenced then
		TriggerEvent("sounds:playSound","notify-"..Color,Config.Themes[Color]["sound"],1.0,false)
	end

	SendNUIMessage({ Action = "Notify", Payload = { Title = Title, Message = Message, Timer = Timer, Theme = Config.Themes[Color], Position = Position, Progress = Mode } })
end)