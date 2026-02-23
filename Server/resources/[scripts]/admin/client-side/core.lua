-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("admin",Creative)
vSERVER = Tunnel.getInterface("admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local debugMode = false
local inFreeze = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportWay()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		Ped = GetVehiclePedIsUsing(Ped)
	end

	local Waypoint = GetFirstBlipInfoId(8)
	if not DoesBlipExist(Waypoint) then
		return false
	end

	local Coords = GetBlipCoords(Waypoint)
	for Height = 1,1000 do
		SetEntityCoordsNoOffset(Ped,Coords.x,Coords.y,Height + 0.0,true,false,false)

		RequestCollisionAtCoord(Coords.x,Coords.y,Coords.z)
		while not HasCollisionLoadedAroundEntity(Ped) do
			Wait(1)
		end

		local Found,GroundZ = GetGroundZFor_3dCoord(Coords.x,Coords.y,Height + 0.0)
		if Found then
			SetEntityCoordsNoOffset(Ped,Coords.x,Coords.y,GroundZ + 1.0,true,false,false)
			break
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORTWAY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.teleportLimbo()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local _,Node = GetNthClosestVehicleNode(Coords["x"],Coords["y"],Coords["z"],1,0,0,0)

	SetEntityCoords(Ped,Node["x"],Node["y"],Node["z"] + 1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:Tuning",function()
	local Ped = PlayerPedId()
	if not IsPedInAnyVehicle(Ped) then
		return false
	end

	local Vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleModKit(Vehicle,0)
	ToggleVehicleMod(Vehicle,18,true)

	for _,Mod in ipairs({ 11,12,13,15 }) do
		SetVehicleMod(Vehicle,Mod,GetNumVehicleMods(Vehicle,Mod) - 1,false)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTONCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(1,38) then
-- 			vSERVER.buttonTxt()
-- 		end
-- 		Wait(1)
-- 	end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Markers = {}
local DefaultLeft = 2.0
local ConfigRace = false
local DefaultRight = -2.0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIGRACE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("configrace",function(source,Message)
	if LocalPlayer["state"]["Admin"] then
		for _,v in pairs(Markers) do
			if DoesBlipExist(v["Blip"]) then
				RemoveBlip(v["Blip"])
			end
		end

		local NameRace = "nulled"
		if not ConfigRace and Message[1] then
			NameRace = Message[1]
		end

		Markers = {}
		DefaultLeft = 2.0
		DefaultRight = -2.0
		ConfigRace = not ConfigRace

		while ConfigRace do
			Wait(1)

			local Ped = PlayerPedId()
			local Vehicle = GetVehiclePedIsUsing(Ped)
			local Left = GetOffsetFromEntityInWorldCoords(Vehicle,DefaultLeft,5.0,0.0)
			local Right = GetOffsetFromEntityInWorldCoords(Vehicle,DefaultRight,5.0,0.0)
			local Center = GetOffsetFromEntityInWorldCoords(Vehicle,0.0,5.0,0.0)

			if IsDisabledControlPressed(1,10) then
				DefaultLeft = DefaultLeft + 0.1
				DefaultRight = DefaultRight - 0.1
			end

			if IsDisabledControlPressed(1,11) then
				DefaultLeft = DefaultLeft - 0.1
				DefaultRight = DefaultRight + 0.1
			end

			if DefaultLeft < 2.0 then
				DefaultLeft = 2.0
			end

			if DefaultRight > -2.0 then
				DefaultRight = -2.0
			end

			if IsControlJustPressed(1,38) then
				local Number = #Markers + 1
				vSERVER.RaceConfig(Left,Center,Right,DefaultLeft * 0.80,NameRace)
				Markers[Number] = { ["Left"] = Left, ["Right"] = Right, ["Blip"] = nil }

				Markers[Number]["Blip"] = AddBlipForCoord(Center["x"],Center["y"],Center["z"])
				SetBlipSprite(Markers[Number]["Blip"],1)
				SetBlipColour(Markers[Number]["Blip"],2)
				SetBlipScale(Markers[Number]["Blip"],0.85)
				ShowNumberOnBlip(Markers[Number]["Blip"],Number)
				SetBlipAsShortRange(Markers[Number]["Blip"],true)
			end

			DrawMarker(1,Left["x"],Left["y"],Left["z"] - 100,0.0,0.0,0.0,0.0,0.0,0.0,1.75,1.75,200.0,88,101,242,175,0,0,0,0)
			DrawMarker(1,Right["x"],Right["y"],Right["z"] - 100,0.0,0.0,0.0,0.0,0.0,0.0,1.75,1.75,200.0,88,101,242,175,0,0,0,0)
			DrawMarker(1,Center["x"],Center["y"],Center["z"] -100,0.0,0.0,0.0,0.0,0.0,0.0,0.75,0.75,200.0,255,255,255,25,0,0,0,0)

			for _,v in pairs(Markers) do
				DrawMarker(1,v["Left"]["x"],v["Left"]["y"],v["Left"]["z"] - 100,0.0,0.0,0.0,0.0,0.0,0.0,1.75,1.75,200.0,0,255,0,100,0,0,0,0)
				DrawMarker(1,v["Right"]["x"],v["Right"]["y"],v["Right"]["z"] - 100,0.0,0.0,0.0,0.0,0.0,0.0,1.75,1.75,200.0,0,255,0,100,0,0,0,0)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:INITSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:initSpectate")
AddEventHandler("admin:initSpectate",function(source)
	if not NetworkIsInSpectatorMode() then
		local Pid = GetPlayerFromServerId(source)
		local Ped = GetPlayerPed(Pid)

		LocalPlayer["state"]:set("Spectate",true,false)
		NetworkSetInSpectatorMode(true,Ped)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:RESETSPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("admin:resetSpectate",function()
	if not NetworkIsInSpectatorMode() then
		return false
	end

	NetworkSetInSpectatorMode(false)
	LocalPlayer.state:set("Spectate",false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Quake",nil,function(Name,Key,Value)
	ShakeGameplayCam("SKY_DIVING_SHAKE",1.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Limparea(Coords)
	local Radius = 100.0
	local x,y,z = Coords.x,Coords.y,Coords.z

	ClearAreaOfPeds(x,y,z,Radius,0)
	ClearAreaOfCops(x,y,z,Radius,0)
	ClearAreaOfObjects(x,y,z,Radius,0)
	ClearAreaOfProjectiles(x,y,z,Radius,0)
	ClearArea(x,y,z,Radius,true,false,false,false)
	ClearAreaOfVehicles(x,y,z,Radius,false,false,false,false,false)
	ClearAreaLeaveVehicleHealth(x,y,z,Radius,false,false,false,false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOGGLEDEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("ToggleDebug")
AddEventHandler("ToggleDebug",function()
	debugMode = not debugMode

    if debugMode then
		TriggerEvent("Notify","Atenção","Debug ON.","amarelo",5000)
        debugon()
    else
		TriggerEvent("Notify","Atenção","Debug OFF.","amarelo",5000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetVehicle()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstVehicle()
	local success
	local rped = nil
	local distanceFrom
	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
			else
				DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Veh: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
			end
		end

		success, ped = FindNextVehicle(handle)
	until not success

	EndFindVehicle(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETOBJECT
-----------------------------------------------------------------------------------------------------------------------------------------
function GetObject()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstObject()
	local success
	local rped = nil
	local distanceFrom
	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if distance < 10.0 then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. " IN CONTACT" )
			else
				DrawText3Ds(pos["x"],pos["y"],pos["z"]+1, "Obj: " .. ped .. " Model: " .. GetEntityModel(ped) .. "" )
			end
		end

		success, ped = FindNextObject(handle)
	until not success

	EndFindObject(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETNPC
-----------------------------------------------------------------------------------------------------------------------------------------
function getNPC()
	local playerped = GetPlayerPed(-1)
	local playerCoords = GetEntityCoords(playerped)
	local handle, ped = FindFirstPed()
	local success
	local rped = nil
	local distanceFrom

	repeat
		local pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(playerCoords, pos, true)
		if canPedBeUsed(ped) and distance < 30.0 and (distanceFrom == nil or distance < distanceFrom) then
			distanceFrom = distance
			rped = ped

			if IsEntityTouchingEntity(GetPlayerPed(-1), ped) then
				DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) .. " IN CONTACT" )
			else
				DrawText3Ds(pos["x"],pos["y"],pos["z"], "Ped: " .. ped .. " Model: " .. GetEntityModel(ped) .. " Relationship HASH: " .. GetPedRelationshipGroupHash(ped) )
			end

			FreezeEntityPosition(ped, inFreeze)
		end

		success, ped = FindNextPed(handle)
	until not success

	EndFindPed(handle)

	return rped
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANPEDBEUSED
-----------------------------------------------------------------------------------------------------------------------------------------
function canPedBeUsed(ped)
	if ped == nil then
		return false
	end

	if ped == GetPlayerPed(-1) then
		return false
	end

	if not DoesEntityExist(ped) then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUGON
-----------------------------------------------------------------------------------------------------------------------------------------
function debugon()
	CreateThread( function()
		while true do
			Wait(1)

			if debugMode then
				local pos = GetEntityCoords(GetPlayerPed(-1))

				local forPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 1.0, 0.0)
				local backPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -1.0, 0.0)
				local LPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 1.0, 0.0, 0.0)
				local RPos = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -1.0, 0.0, 0.0) 

				local forPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 2.0, 0.0)
				local backPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, -2.0, 0.0)
				local LPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 2.0, 0.0, 0.0)
				local RPos2 = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -2.0, 0.0, 0.0)    

				local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
				local currentStreetHash, intersectStreetHash = GetStreetNameAtCoord(x, y, z, currentStreetHash, intersectStreetHash)
				currentStreetName = GetStreetNameFromHashKey(currentStreetHash)

				drawTxtS(0.8, 0.50, 0.4,0.4,0.30, "Heading: " .. GetEntityHeading(GetPlayerPed(-1)), 55, 155, 55, 255)
				drawTxtS(0.8, 0.52, 0.4,0.4,0.30, "Coords: " .. pos, 55, 155, 55, 255)
				drawTxtS(0.8, 0.54, 0.4,0.4,0.30, "Attached Ent: " .. GetEntityAttachedTo(GetPlayerPed(-1)), 55, 155, 55, 255)
				drawTxtS(0.8, 0.56, 0.4,0.4,0.30, "Health: " .. GetEntityHealth(GetPlayerPed(-1)), 55, 155, 55, 255)
				drawTxtS(0.8, 0.58, 0.4,0.4,0.30, "H a G: " .. GetEntityHeightAboveGround(GetPlayerPed(-1)), 55, 155, 55, 255)
				drawTxtS(0.8, 0.60, 0.4,0.4,0.30, "Model: " .. GetEntityModel(GetPlayerPed(-1)), 55, 155, 55, 255)
				drawTxtS(0.8, 0.62, 0.4,0.4,0.30, "Speed: " .. GetEntitySpeed(GetPlayerPed(-1)) * VehicleSpeed, 55, 155, 55, 255)
				drawTxtS(0.8, 0.64, 0.4,0.4,0.30, "Frame Time: " .. GetFrameTime(), 55, 155, 55, 255)
				drawTxtS(0.8, 0.66, 0.4,0.4,0.30, "Street: " .. currentStreetName, 55, 155, 55, 255)

				DrawLine(pos,forPos, 255,0,0,115)
				DrawLine(pos,backPos, 255,0,0,115)

				DrawLine(pos,LPos, 255,255,0,115)
				DrawLine(pos,RPos, 255,255,0,115)

				DrawLine(forPos,forPos2, 255,0,255,115)
				DrawLine(backPos,backPos2, 255,0,255,115)

				DrawLine(LPos,LPos2, 255,255,255,115)
				DrawLine(RPos,RPos2, 255,255,255,115)

				local nearped = getNPC()

				local veh = GetVehicle()

				local nearobj = GetObject()

				if IsControlJustReleased(0, 38) then
					if inFreeze then
						inFreeze = false
						TriggerEvent("Notify","Atenção","Freeze OFF.","amarelo",5000)
					else
						inFreeze = true
						TriggerEvent("Notify","Atenção","Freeze ON.","amarelo",5000)
					end
				end
			else
				Wait(5000)
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTXTS
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxtS(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(0)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3DS
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end