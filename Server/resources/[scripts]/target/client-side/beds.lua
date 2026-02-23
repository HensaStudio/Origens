-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local InBed = false
local OutBed = false
local Treatment = false
local AnimName = "idle_a"
local AnimDict = "amb@world_human_sunbathe@female@back@idle_a"
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Beds = {
	-- Pillbox
	{ Coords = vec4(307.72,-581.74,43.2,340.16), Invert = 180.0 },
	{ Coords = vec4(311.06,-582.96,43.2,340.16), Invert = 180.0 },
	{ Coords = vec4(314.46,-584.2,43.2,340.16), Invert = 180.0 },
	{ Coords = vec4(317.68,-585.37,43.2,340.16), Invert = 180.0 },
	{ Coords = vec4(322.62,-587.16,43.2,340.16), Invert = 180.0 },
	{ Coords = vec4(324.26,-582.8,43.2,158.75), Invert = 180.0 },
	{ Coords = vec4(319.42,-581.05,43.2,158.75), Invert = 180.0 },
	{ Coords = vec4(313.93,-579.04,43.2,158.75), Invert = 180.0 },
	{ Coords = vec4(309.35,-577.38,43.2,158.75), Invert = 180.0 },
	{ Coords = vec4(363.8,-589.12,43.21,68.04), Invert = 180.0 },
	{ Coords = vec4(364.96,-585.94,43.21,68.04), Invert = 180.0 },
	{ Coords = vec4(366.52,-581.67,43.21,68.04), Invert = 180.0 },
	{ Coords = vec4(354.44,-600.19,43.21,68.04), Invert = 180.0 },
	{ Coords = vec4(359.53,-586.23,43.2,68.04), Invert = 180.0 },
	{ Coords = vec4(361.36,-581.3,43.2,68.04), Invert = 180.0 },

	-- Clandestine
	{ Coords = vec4(-471.87,6287.56,13.63,53.86), Invert = 180.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Beds) do
		AddBoxZone("Beds:"..Number,v.Coords.xyz,2.0,1.0,{
			name = "Beds:"..Number,
			heading = v.Coords.w,
			minZ = v.Coords.z - 0.25,
			maxZ = v.Coords.z + 0.50
		},{
			shop = Number,
			Distance = 1.50,
			options = {
				{
					event = "target:PutBed",
					label = "Deitar",
					tunnel = "client"
				},{
					event = "target:Treatment",
					label = "Tratamento",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:PUTBED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:PutBed",function(Number)
	if LocalPlayer.state.Bed or InBed then
		return false
	end

	local Ped = PlayerPedId()
	InBed = Beds[Number].Coords
	OutBed = GetEntityCoords(Ped)

	LocalPlayer.state:set("Bed",true,false)
	SetEntityCoords(Ped,InBed.x,InBed.y,InBed.z - 0.5)
	SetEntityHeading(Ped,InBed.w - Beds[Number].Invert)
	vRP.playAnim(false,{AnimDict,AnimName},true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:UPBED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:UpBed",function()
	if not LocalPlayer.state.Bed or not InBed then
		return false
	end

	SetEntityCoords(PlayerPedId(),OutBed.x,OutBed.y,OutBed.z - 0.5)
	LocalPlayer.state:set("Bed",false,false)
	OutBed = false
	InBed = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("target:Treatment",function(Number,Ignore)
	if LocalPlayer.state.Bed or InBed or not Beds[Number] then
		return false
	end

	if not Ignore and not vSERVER.CheckIn() then
		return false
	end

	local Ped = PlayerPedId()
	if GetEntityHealth(Ped) <= 100 then
		exports.survival:Revive(101)
	end

	TriggerEvent("target:PutBed",Number)

	LocalPlayer.state:set("Commands",true,true)
	LocalPlayer.state:set("Buttons",true,true)
	LocalPlayer.state:set("Cancel",true,true)
	NetworkSetFriendlyFireOption(false)
	Treatment = GetGameTimer() + 1000
	TriggerEvent("paramedic:Reset")
	SetEntityInvincible(Ped,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:StartTreatment")
AddEventHandler("target:StartTreatment",function()
	if Treatment then
		return false
	end

	LocalPlayer.state:set("Commands",true,true)
	LocalPlayer.state:set("Buttons",true,true)
	LocalPlayer.state:set("Cancel",true,true)
	SetEntityInvincible(PlayerPedId(),true)
	Treatment = GetGameTimer() + 1000
	TriggerEvent("paramedic:Reset")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if Treatment and GetGameTimer() >= Treatment then
			local Ped = PlayerPedId()
			local Health = GetEntityHealth(Ped)

			Treatment = GetGameTimer() + 1000

			if Health < 200 then
				SetEntityHealth(Ped,Health + 1)

				if LocalPlayer.state.Bed and InBed and not IsEntityPlayingAnim(Ped,AnimDict,AnimName,3) then
					SetEntityCoords(Ped,InBed.x,InBed.y,InBed.z - 0.5)
					vRP.playAnim(false,{AnimDict,AnimName},true)
				end
			else
				Treatment = false
				SetEntityInvincible(Ped,false)
				NetworkSetFriendlyFireOption(true)
				LocalPlayer.state:set("Cancel",false,true)
				LocalPlayer.state:set("Buttons",false,true)
				LocalPlayer.state:set("Commands",false,true)
				TriggerEvent("Notify","Centro Médico","Tratamento concluido.","sangue",5000)

				if LocalPlayer.state.Bed and InBed and IsEntityPlayingAnim(Ped,AnimDict,AnimName,3) then
					TriggerEvent("target:UpBed")
				end
			end
		end

		Wait(1000)
	end
end)