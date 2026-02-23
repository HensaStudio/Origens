-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local InsideHospital = false
local HasWarned = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOSPITALZONE
-----------------------------------------------------------------------------------------------------------------------------------------
local HospitalZone = PolyZone:Create({
	vec2(301.2979,-581.3405),
	vec2(297.2734,-592.2442),
	vec2(324.2558,-602.0985),
	vec2(327.8471,-592.2938),
	vec2(327.3276,-590.7792)
}, { name = "Hospital" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- HOSPITALZONE:ONPLAYERINOUT
-----------------------------------------------------------------------------------------------------------------------------------------
HospitalZone:onPlayerInOut(function(isInside)
	InsideHospital = isInside

	if InsideHospital and not LocalPlayer["state"]["Safezone"] then
		if not HasWarned then
			TriggerEvent("inventory:Buttons", { { "!", "Não Corra ou Pule no Hospital" } })
			HasWarned = true
		end
	else
		if HasWarned then
			TriggerEvent("inventory:CloseButtons")
			HasWarned = false
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERIFYTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if InsideHospital and not LocalPlayer["state"]["Safezone"] then
			local Ped = PlayerPedId()

			if IsPedRunning(Ped) then
				SetPedToRagdoll(Ped,2000,2000,0,false,false,false)

				Wait(2000)
			elseif IsPedJumping(Ped) then
				SetPedToRagdoll(Ped,2000,2000,0,false,false,false)

				Wait(2000)
			else
				Wait(200)
			end
		else
			Wait(1000)
		end
	end
end)