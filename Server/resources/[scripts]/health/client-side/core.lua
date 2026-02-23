-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("health")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Illness = nil
local HasIllness = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:APPLY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("health:Apply")
AddEventHandler("health:Apply", function(Illness)
	HasIllness = true

	local IllnessTimer = GetGameTimer() + 600000 -- 10 minutos

	CreateThread(function()
		while HasIllness do
			Wait(1000)

			if not Illness or not LocalPlayer["state"]["Illness"] or not LocalPlayer["state"]["Active"] then
				HasIllness = false
				break
			end

			if IllnessTimer <= GetGameTimer() then
				local Ped = PlayerPedId()

				if Illness == "flu" then
					PlayCough()

				elseif Illness == "intoxication" then
					PlayVomit()

				elseif Illness == "fever" then
					if math.random(100) <= 20 then
						ApplyDamageToPed(Ped,2,false)
						TriggerEvent("Notify","Saúde","Sofrendo com <b>Febre</b>.","sangue",5000)
						AnimpostfxPlay("DrugsDrivingOut",5000,true)
					end

				elseif Illness == "infection" then
					ApplyDamageToPed(Ped,5,false)
					TriggerEvent("Notify","Saúde","Sofrendo com <b>Infecção</b>.","sangue",5000)
					ShakeGameplayCam("SMALL_EXPLOSION_SHAKE",0.1)
				end

				SetPedMovementClipset(Ped,"move_m@injured",0.5)

				IllnessTimer = GetGameTimer() + 600000
			end
		end
	end)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("health:Remove")
AddEventHandler("health:Remove", function()
	Illness = nil
	HasIllness = false
	ClearPedTasks(PlayerPedId())
	LocalPlayer["state"]:set("Walk",false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYCOUGH
-----------------------------------------------------------------------------------------------------------------------------------------
function PlayCough()
	ApplyDamageToPed(PlayerPedId(),2,false)
	TriggerEvent("Notify","Saúde","Sofrendo com <b>Tosse</b>.","sangue",5000)

	RequestAnimDict("timetable@gardener@smoking_joint")
	while not HasAnimDictLoaded("timetable@gardener@smoking_joint") do
		Wait(10)
	end

	TaskPlayAnim(PlayerPedId(),"timetable@gardener@smoking_joint","idle_cough",2.0,2.0,-1,48,0,0,0,0)

	Wait(2000)

	ClearPedTasks(PlayerPedId())

	TriggerServerEvent("health:Contagion")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYVOMIT
-----------------------------------------------------------------------------------------------------------------------------------------
function PlayVomit()
	local Ped = PlayerPedId()

	ApplyDamageToPed(Ped,2,false)
	TriggerEvent("Notify","Saúde","Sofrendo com <b>Intoxicação</b>.","sangue",5000)

	ClearPedTasks(Ped)

	if LoadAnim("missfam5_blackout") then
		local Duration = GetAnimDuration("missfam5_blackout","vomit") * 1000

		TaskPlayAnim(Ped,"missfam5_blackout","vomit",3.0,-3.0,-1,49,0,false,false,false)

		TriggerServerEvent("vomit:SyncParticles",PedToNet(Ped),Duration)

		Wait(Duration + 500)
		ClearPedTasks(Ped)

		TriggerServerEvent("health:Contagion")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOMIT:PLAYPARTICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vomit:PlayParticles")
AddEventHandler("vomit:PlayParticles", function(NetPed,Duration)
	local Ped = NetToPed(NetPed)
	if not DoesEntityExist(Ped) then return end

	if LoadPtfxAsset("scr_family5") then
		UseParticleFxAssetNextCall("scr_family5")

		local Bone = GetPedBoneIndex(Ped,47495)
		local Puke = StartParticleFxLoopedOnEntityBone("scr_trev_puke",Ped,0.0,0.0,0.0,0.0,0.0,0.0,Bone,1.0,false,false,false)

		SetTimeout(Duration, function()
			StopParticleFxLooped(Puke,0)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISPEDWITHOUTSHIRT
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsPedWithoutShirt(Ped)
	local Torso = GetPedDrawableVariation(Ped,11) -- componente torso
	-- Ajusta conforme teu pack de roupas (0 normalmente é "sem nada")
	return Torso == 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISPEDBAREFOOT
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsPedBarefoot(Ped)
	local Feet = GetPedDrawableVariation(Ped,6) -- componente sapatos
	-- 0 geralmente é descalço, mas pode variar com packs de roupas
	return Feet == 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKILLNESS
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckIllness()
	local Ped = PlayerPedId()
	local Vehicle = GetVehiclePedIsIn(Ped,false)

	if GlobalState["Weather"] == "CLEARING" or GlobalState["Weather"] == "RAIN" or GlobalState["Weather"] == "THUNDER" then
		if not LocalPlayer["state"]["Umbrella"] and not Illness then
			if Vehicle == 0 then
				local Chance = 0

				if IsPedSwimming(Ped) or IsPedSwimmingUnderWater(Ped) then
					Chance = Chance + 20
				end

				if IsPedWithoutShirt(Ped) then
					Chance = Chance + 20
				end

				if IsPedBarefoot(Ped) then
					Chance = Chance + 20
				end

				if Chance > 0 and math.random(100) <= Chance then
					local IllType = (math.random(2) == 1) and "flu" or "fever"
					vSERVER.InRain(IllType)
				end
			end
		end
	end

	SetTimeout(300000,CheckIllness)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKILLNESSTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(CheckIllness)