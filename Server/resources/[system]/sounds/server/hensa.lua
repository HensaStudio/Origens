RegisterNetEvent("sounds:playSoundDistanceServer")
AddEventHandler("sounds:playSoundDistanceServer",function(Name,Sound,Volume,Loop,Coords,Distance)
	TriggerClientEvent("sounds:playSoundDistance",-1,Name,Sound,Volume,Loop,Coords,Distance)
end)