-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("prison",Creative)
vSERVER = Tunnel.getInterface("prison")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Cooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:PRISIONER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("prison:Prisioner")
AddEventHandler("prison:Prisioner",function(Status)
	LocalPlayer.state.Prison = Status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()

		if LocalPlayer.state.Prison and not LocalPlayer.state.Cancel then
			local Coords = GetEntityCoords(Ped)

			for Index, v in pairs(Locations) do
				local Distance = #(Coords - v.xyz)

				if Distance <= 6.5 then
					TimeDistance = 1

					if Distance <= 1.0 then
						SetDrawOrigin(v.x, v.y, v.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()

						if IsControlJustPressed(1,38) then
							TriggerServerEvent("prison:Service", Index)
						end
					else
						SetDrawOrigin(v.x, v.y, v.z)
						DrawSprite("Textures","E",0.0,0.0,0.01,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTPRISONALARM
-----------------------------------------------------------------------------------------------------------------------------------------
local function StartPrisonAlarm()
	if not PrepareAlarm("PRISON_ALARMS") then
		PrepareAlarm("PRISON_ALARMS")
	end

	while not PrepareAlarm("PRISON_ALARMS") do
		Wait(100)
	end

	StartAlarm("PRISON_ALARMS", true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPPRISONALARM
-----------------------------------------------------------------------------------------------------------------------------------------
local function StopPrisonAlarm()
	StopAlarm("PRISON_ALARMS", true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:SCREENFADEESCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("prison:ScreenFadeEscape", function()
	StartPrisonAlarm()

    DoScreenFadeOut(1000)

    Wait(3000)

	local Ped = PlayerPedId()
	SetEntityCoordsNoOffset(Ped,PrisonOutside.x,PrisonOutside.y,PrisonOutside.z,false,false,false)

    DoScreenFadeIn(1000)

	SetTimeout(30000, function()
		StopPrisonAlarm()
	end)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	exports.target:AddBoxZone(
		"EscapePrison",
		Init["xyz"],
		0.75, 0.75,
		{
			name = "EscapePrison",
			heading = Init["w"],
			minZ = Init["z"] - 1.0,
			maxZ = Init["z"] + 1.0
		},
		{
			Distance = 1.75,
			options = {
				{
					event = "prison:Escape",
					label = "Conversar",
					tunnel = "server"
				}
			}
		}
	)

	exports.target:AddBoxZone(
		"EssentialsPrison",
		Essentials["xyz"],
		0.75, 0.75,
		{
			name = "EssentialsPrison",
			heading = Essentials["w"],
			minZ = Essentials["z"] - 1.0,
			maxZ = Essentials["z"] + 1.0
		},
		{
			Distance = 1.80,
			options = {
				{
					event = "prison:Candy",
					label = "Se Acalmar",
					tunnel = "server"
				},{
					event = "prison:Drink",
					label = "Se Hidratar",
					tunnel = "server"
				},{
					event = "prison:Food",
					label = "Se Alimentar",
					tunnel = "server"
				}
			}
		}
	)

	exports.target:AddBoxZone(
		"LifeInPrison",
		Cure["xyz"],
		0.75, 0.75,
		{
			name = "LifeInPrison",
			heading = Cure["w"],
			minZ = Cure["z"] - 1.0,
			maxZ = Cure["z"] + 1.0
		},
		{
			Distance = 1.80,
			options = {
				{
					event = "prison:Cure",
					label = "Se Curar",
					tunnel = "server"
				}
			}
		}
	)
end)