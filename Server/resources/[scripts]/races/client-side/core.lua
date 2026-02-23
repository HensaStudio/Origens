-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("races",Creative)
vSERVER = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Object = {}
local SmokeEffects = {}
local Position = 0
local Markers = {}
local Mode = false
local Checkpoint = 1
local InitSeconds = 0
local Selected = false
local Progressing = false
local ExplodeTimers = false
local Seconds = GetGameTimer()
local ExplodeCooldown = GetGameTimer()
local PositionCooldown = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
local RColor, GColor, BColor = HexToRGB(Theme["main"])
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
LocalPlayer.state:set("Races",false,false)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRACES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	LoadModel(PropTyre)
	LoadModel(PropFlags)
	SetGhostedEntityAlpha(254)

	while true do
		local TimeDistance = 999
		if not LocalPlayer.state.TestDrive then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)
			local Vehicle = GetVehiclePedIsUsing(Ped)

			if LocalPlayer.state.Races and Mode and Selected then
				TimeDistance = 1

				local RaceActive = Races[Mode]
				local GlobalCheck = RaceActive and (not RaceActive.Global or GlobalState["Races:"..Mode..":"..Selected])

				if RaceActive and GlobalCheck then
					Seconds = GetGameTimer() - InitSeconds

					local CheckpointData = Routes[Selected].Coords[Checkpoint]
					local Distance = #(Coords - CheckpointData.Center)
					if Distance <= (CheckpointData.Distance + 1.0) then
						if Checkpoint >= #Routes[Selected].Coords then
							FinishRace(Vehicle)
						else
							NextCheckpoint()
						end
					end
				else
					if #(Coords - Routes[Selected].Init) > 100 then
						CancelRace(Vehicle)
					elseif IsControlJustPressed(1,38) then
						vSERVER.GlobalState(Mode,Selected)
					end
				end
			elseif IsEligibleToStart(Ped,Vehicle) then
				local InitCoords = Routes[Selected].Init
				local Distance = #(Coords - InitCoords.xyz)

				if Distance <= 25 then
					DrawMarker(23,InitCoords.x,InitCoords.y,InitCoords.z - 0.35,0,0,0,0,0,0,10.0,10.0,10.0,RColor,GColor,BColor,175,false,false,0,false)
					TimeDistance = 1

					if Distance <= 5 and IsControlJustPressed(1,38) and vSERVER.Runners(Mode,Selected) then
						if StartRace(Vehicle) then
							InitCircuit()
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISHRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function FinishRace(Vehicle)
	PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",true)
	vSERVER.Finish(Mode,Selected,Seconds,Position)
	SendNUIMessage({ Action = "Close" })
	CleanObjects()
	CleanSmokeEffects()
	CleanMarker()

	Checkpoint = 1
	InitSeconds = 0
	Progressing = false
	ExplodeTimers = false

	SetLocalPlayerAsGhost(false)
	SetNetworkVehicleAsGhost(Vehicle,false)
	LocalPlayer.state:set("Races",false,false)

	SendNUIMessage({
		Action = "Results",
		Payload = vSERVER.Ranking(Mode,Selected,ResultFinish)
	})

	Selected,Mode = false,false

	SetTimeout(SecondsResult,function()
		SendNUIMessage({ Action = "Close" })
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEXTCHECKPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
function NextCheckpoint()
	if DoesBlipExist(Markers[Checkpoint]) then
		RemoveBlip(Markers[Checkpoint])
		Markers[Checkpoint] = nil
	end

	Checkpoint = Checkpoint + 1
	PlaySoundFrontend(-1,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET",true)
	SetBlipRoute(Markers[Checkpoint],true)
	CreatedTyres()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function CancelRace(Vehicle)
	if Vehicle then
		SetNetworkVehicleAsGhost(Vehicle,false)
	end

	SetLocalPlayerAsGhost(false)
	StopCircuit()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISELIGIBLETOSTART
-----------------------------------------------------------------------------------------------------------------------------------------
function IsEligibleToStart(Ped,Vehicle)
	return IsPedInAnyVehicle(Ped) and not IsPedInAnyHeli(Ped) and not IsPedInAnyBoat(Ped) and not IsPedInAnyPlane(Ped) and GetPedInVehicleSeat(Vehicle,-1) == Ped and Mode and Selected and Routes[Selected]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTRACE
-----------------------------------------------------------------------------------------------------------------------------------------
function StartRace(Vehicle)
	if not vSERVER.Start(Mode,Selected) then
		return false
	end

	if Races[Mode] and Races[Mode].Explode then
		ExplodeTimers = Routes[Selected].Time
		ExplodeCooldown = GetGameTimer() + 1000
	end

	if Races[Mode] and Races[Mode].Global then
		SendNUIMessage({ Action = "Message", Payload = { "E","Pressione","para iniciar a corrida" } })
	else
		Progressing = true
		InitSeconds = GetGameTimer()
	end

	SetNetworkVehicleAsGhost(Vehicle,true)
	SetLocalPlayerAsGhost(true)

	Checkpoint = 1
	LocalPlayer.state:set("Races",true,false)
	CreatedTyres()

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITCIRCUIT
-----------------------------------------------------------------------------------------------------------------------------------------
function InitCircuit()
	local Consult = Routes[Selected].Coords
	for Index,v in ipairs(Consult) do
		local Blip = AddBlipForCoord(v.Center)
		local Calculated = #Markers < (#Consult - 1)

		SetBlipSprite(Blip,Calculated and 1 or 38)
		SetBlipColour(Blip,Calculated and ColourMarker or 4)
		SetBlipScale(Blip,Calculated and 0.85 or 0.75)
		SetBlipAsShortRange(Blip,true)

		if Calculated then
			ShowNumberOnBlip(Blip,Index)
		end

		Markers[Index] = Blip
	end

	CreateThread(function()
		while true do
			if LocalPlayer.state.Races and Mode and Races[Mode] and Selected and Routes[Selected] then
				local Ped = PlayerPedId()
				local CurrentTime = GetGameTimer()
				local Coords = GetEntityCoords(Ped)
				local Vehicle = GetVehiclePedIsUsing(Ped)
				local CheckpointData = Routes[Selected].Coords[Checkpoint]
				local Distance = #(Coords - CheckpointData.Center)

				if CurrentTime >= PositionCooldown then
					PositionCooldown = CurrentTime + 1000
					vSERVER.UpdatePosition(Mode,Selected,Checkpoint,Distance)
				end

				if Races[Mode] and Races[Mode].Explode then
					if Progressing and ExplodeTimers and CurrentTime >= ExplodeCooldown then
						ExplodeTimers = ExplodeTimers - 1
						ExplodeCooldown = CurrentTime + 1000
					end
				end

				if not Vehicle or not IsPedInAnyVehicle(Ped) or GetPedInVehicleSeat(Vehicle,-1) ~= Ped or (ExplodeTimers and ExplodeTimers <= 0) then
					CancelRace(Vehicle)
				end
			else
				break
			end

			Wait(500)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEDTYRES
-----------------------------------------------------------------------------------------------------------------------------------------
function CreatedTyres()
	CleanObjects()
	CleanSmokeEffects()

	local Prop = Checkpoint >= #Routes[Selected].Coords and PropFlags or PropTyre
	local Coords = Routes[Selected].Coords[Checkpoint]

	Object.Left = CreateObjectNoOffset(Prop,Coords.Left.x,Coords.Left.y,Coords.Left.z,false,false,false)
	Object.Right = CreateObjectNoOffset(Prop,Coords.Right.x,Coords.Right.y,Coords.Right.z,false,false,false)

	for _,v in pairs(Object) do
		SetEntityLodDist(v,0xFFFF)
		PlaceObjectOnGroundProperly(v)
		SetEntityCollision(v,false,false)
	end

	CreateSmokeEffect(Coords.Center)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANMARKER
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanMarker()
	for _,v in pairs(Markers) do
		if DoesBlipExist(v) then
			RemoveBlip(v)
		end
	end

	Markers = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanObjects()
	for _,v in pairs(Object) do
		if DoesEntityExist(v) then
			DeleteEntity(v)
		end
	end

	Object = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATESMOKEEFFECT
-----------------------------------------------------------------------------------------------------------------------------------------
function CreateSmokeEffect(coords)
	RequestNamedPtfxAsset("core")

	CreateThread(function()
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(100)
		end

		local groundZ = coords.z

		UseParticleFxAssetNextCall("core")
		local smokeEffect = StartParticleFxLoopedAtCoord("exp_grd_flare", coords.x, coords.y, groundZ - 0.5, 0.0, 0.0, 0.0, 2.0, false, false, false, false)

		SmokeEffects[#SmokeEffects + 1] = smokeEffect
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANSMOKEEFFECTS
-----------------------------------------------------------------------------------------------------------------------------------------
function CleanSmokeEffects()
	for _,effect in pairs(SmokeEffects) do
		if DoesParticleFxLoopedExist(effect) then
			StopParticleFxLooped(effect, false)
		end
	end

	SmokeEffects = {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPCIRCUIT
-----------------------------------------------------------------------------------------------------------------------------------------
function StopCircuit()
	LocalPlayer.state:set("Races",false,false)
	SendNUIMessage({ Action = "Close" })
	vSERVER.Cancel()

	CleanObjects()

	CleanSmokeEffects()
	CleanMarker()

	if ExplodeTimers and Progressing then
		SetTimeout(SecondsExplode,function()
			local Ped = PlayerPedId()
			local Vehicle = GetLastDrivenVehicle()

			if DoesEntityExist(Vehicle) then
				NetworkExplodeVehicle(Vehicle,true,false,true)
			else
				ApplyDamageToPed(Ped,200,false)
			end
		end)
	end

	Object = {}
	SmokeEffects = {}
	Markers = {}
	Position = 0
	Mode = false
	Checkpoint = 1
	InitSeconds = 0
	Selected = false
	Progressing = false
	ExplodeTimers = false
	Seconds = GetGameTimer()
	ExplodeCooldown = GetGameTimer()
	PositionCooldown = GetGameTimer()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdatePosition(Positioner,Runners)
	Position = Positioner

	local CurrentSeconds = 0
	if Progressing and InitSeconds > 0 then
		CurrentSeconds = GetGameTimer() - InitSeconds
	end

	SendNUIMessage({ Action = "Racing", Payload = { Position,#Runners,Runners,CurrentSeconds,ExplodeTimers,"1/1",Checkpoint.."/"..Routes[Selected].Checkpoints } })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:START
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Start")
AddEventHandler("races:Start",function(Modez,Selectedz)
	if Mode and Mode == Modez and Selected and Selected == Selectedz then
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			CancelRace()
			return true
		end

		local Vehicle = GetVehiclePedIsUsing(Ped)
		local StartPosition = Routes[Selected].Positions[Position]

		if not StartPosition then
			CancelRace()
			return true
		end

		SendNUIMessage({ Action = "StartCountdown", Payload = SecondsInit })
		SendNUIMessage({ Action = "Message", Payload = false })
		SetEntityCoords(Vehicle,StartPosition.xyz)
		SetEntityHeading(Vehicle,StartPosition.w)
		FreezeEntityPosition(Vehicle,true)

		SetTimeout((SecondsInit + 1) * 1000,function()
			Progressing = true
			Seconds = GetGameTimer()
			InitSeconds = GetGameTimer()
			FreezeEntityPosition(Vehicle,false)
			SendNUIMessage({ Action = "StopCountdown" })
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Open")
AddEventHandler("races:Open",function()
	if not LocalPlayer.state.Races then
		local Avatar,Experience = vSERVER.Information()

		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", Payload = { Races,{ Name = LocalPlayer.state.Name, Passport = LocalPlayer.state.Passport, Avatar = "Avatar" },Experience,RankingTablet } })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Run",function(Data,Callback)
	Mode = Data.Mode
	Selected = Data.Route

	if Selected and Routes[Selected] and Routes[Selected].Init then
		SetNewWaypoint(Routes[Selected].Init.x + 0.0001,Routes[Selected].Init.y + 0.0001)
	end

	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	TriggerEvent("hud:Active",true)

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Ranking",function(Data,Callback)
	Callback(vSERVER.Ranking(Data.Mode,Data.Route,RankingTablet))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKINGGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RankingGlobal",function(Data,Callback)
	Callback(vSERVER.RankingGlobal())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Vehicles",function(Data,Callback)
	Callback(vSERVER.VehicleShop())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RentalVehicle",function(Data,Callback)
	Callback(vSERVER.RentalVehicle(Data.Model))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES:NOTIFY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("races:Notify")
AddEventHandler("races:Notify",function(Title,Message,Type)
	SendNUIMessage({ Action = "Notify", Payload = { Title,Message,Type } })
end)