-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("doors")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Doors = {}
local Display = {}
local Cooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS:CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:Connect")
AddEventHandler("doors:Connect",function(Table)
	Doors = Table

	for Number,v in pairs(Doors) do
		if not IsDoorRegisteredWithSystem(Number) then
			AddDoorToSystem(Number,v.Hash,v.Coords,false,false,true)
		end

		DoorSystemSetOpenRatio(Number,0.0,false,true)
		DoorSystemSetAutomaticRate(Number,5.0,false,true)
		DoorSystemSetDoorState(Number,v.Lock and 1 or 0,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS:SYNC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("doors:Sync")
AddEventHandler("doors:Sync",function(Number,Status,Other)
	if Number and Doors[Number] then
		Doors[Number].Lock = Status

		if Other and Doors[Other] then
			TriggerEvent("doors:Sync",Other,Status)
		end

		if not IsDoorRegisteredWithSystem(Number) then
			AddDoorToSystem(Number,Doors[Number].Hash,Doors[Number].Coords,false,false,true)
		end

		DoorSystemSetOpenRatio(Number,0.0,false,true)
		DoorSystemSetAutomaticRate(Number,5.0,false,true)
		DoorSystemSetDoorState(Number,Status and 1 or 0,true)

		local Locate = Doors[Number].Coords
		exports.sounds:PlayUrlPos("door-key-"..Number,"nui://sounds/html/sounds/door-key.mp3",0.8,vec3(Locate.x,Locate.y,Locate.z),false)
		exports.sounds:Distance("door-key-"..Number,5.0)

		if Display[Number] then
			SendNUIMessage({ Action = "Show", Payload = { "E","Pressione",Status and "para destrancar" or "para trancar" } })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		for Number,v in pairs(Doors) do
			if not v.Disabled then
				if #(Coords - v.Coords) <= v.Distance then
					TimeDistance = 1

					if not Display[Number] then
						SendNUIMessage({ Action = "Show", Payload = { "E","Pressione",v.Lock and "para destrancar" or "para trancar" } })
						Display[Number] = true
					end

					if IsControlJustPressed(1,38) and Cooldown <= GetGameTimer() then
						Cooldown = GetGameTimer() + 5000
						vSERVER.Permission(Number)
					end
				elseif Display[Number] then
					SendNUIMessage({ Action = "Hide" })
					Display[Number] = nil
				end
			end
		end

		Wait(TimeDistance)
	end
end)