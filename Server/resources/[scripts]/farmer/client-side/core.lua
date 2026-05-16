-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("farmer",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Poly = {}
local Blips = {}
local Display = {}
local Waypoints = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTTARGETPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function InputTargetPosition(Number,v)
	exports.target:AddBoxZone("Farmer:"..Number,v["Coords"]["xyz"],v["Width"],v["Width"],{
		name = "Farmer:"..Number,
		heading = v["Coords"]["w"] or 0.0,
		minZ = v["Coords"]["z"] - (v["Lower"] or 0.0),
		maxZ = v["Coords"]["z"] + (v["Upper"] or 0.0)
	},{
		shop = Number,
		Distance = v["Distance"] or 1.5,
		options = {
			{
				event = v["Event"],
				label = v["Label"],
				tunnel = "server"
			}
		}
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Service,_ in pairs(FastFarmer) do
		for Number,v in pairs(FastFarmer[Service]["Coords"]) do
			exports.target:AddCircleZone(Service..":"..Number,v,FastFarmer[Service]["Width"],{
				name = Service..":"..Number,
				heading = 0.0,
				useZ = true
			},{
				Distance = FastFarmer[Service]["Distance"],
				options = FastFarmer[Service]["Options"]
			})
		end

		if FastFarmer[Service]["PolyZone"] and not Poly[Service] then
			Poly[Service] = PolyZone:Create(FastFarmer[Service]["PolyZone"],{ name = Service })
		end
	end

	while true do
		local Ped = PlayerPedId()
		local TimerDistance = 5000
		local Coords = GetEntityCoords(Ped)

		for Number,v in pairs(Objects) do
			if #(Coords - v["Coords"]["xyz"]) <= (v["Show"] or 100.0) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
				if not Display[Number] and LoadModel(v["Model"]) then
					Display[Number] = CreateObjectNoOffset(v["Model"],v["Coords"]["x"],v["Coords"]["y"],v["Coords"]["z"] - (v["Height"] or 0.0),false,false,false)

					SetEntityHeading(Display[Number],v["Coords"]["w"])
					FreezeEntityPosition(Display[Number],true)

					if v["Model"] == "prop_rub_binbag_06" then
						PlaceObjectOnGroundProperly(Display[Number])
						v["Coords"] = GetEntityCoords(Display[Number])
					end

					InputTargetPosition(Number,v)
					TimerDistance = 1000
				end
			else
				if Display[Number] then
					if DoesEntityExist(Display[Number]) then
						DeleteEntity(Display[Number])
					end

					exports.target:RemCircleZone("Farmer:"..Number)
					Display[Number] = nil
				end
			end

			if #Blips > 0 and v["Model"] == "prop_rub_binbag_06" and not Blips[Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
				Blips[Number] = AddBlipForRadius(v["Coords"]["xyz"],5.0)
				SetBlipAlpha(Blips[Number],150)
				SetBlipColour(Blips[Number],4)
			end
		end

		Wait(TimerDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Blips")
AddEventHandler("farmer:Blips",function()
	if #Blips > 0 then
		for _,v in pairs(Blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		Blips = {}

		TriggerEvent("Notify","Lixeiro","Marcações desativadas.","default",10000)
	else
		for Number,v in pairs(Objects) do
			if not Blips[Number] and v["Model"] == "prop_rub_binbag_06" and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
				Blips[Number] = AddBlipForRadius(v["Coords"]["xyz"],5.0)
				SetBlipAlpha(Blips[Number],150)
				SetBlipColour(Blips[Number],4)
			end
		end

		TriggerEvent("Notify","Lixeiro","Marcações ativadas.","default",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:WEEDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Weeds")
AddEventHandler("farmer:Weeds",function()
	if LocalPlayer["state"]["Basket"] then
		if next(Waypoints) then
			for _,id in pairs(Waypoints) do
				exports["waypoints"]:RemoveWaypoint(id)
			end

			Waypoints = {}

			TriggerEvent("Notify","Brotos de Maconha","Marcação desativada.","default",5000)
		else
			local Coords = vec3(1551.30,1560.24,106.90)

			Waypoints[1] = exports["waypoints"]:AddWaypoint(Coords,{ label = "Brotos de Maconha", color = Theme["main"], autoRemove = true })

			TriggerEvent("Notify","Brotos de Maconha","Marcação ativada.","default",5000)
		end
	else
		TriggerEvent("Notify","Brotos de Maconha","Você precisa estar com <b>1x "..ItemName("basket").."</b> em mãos.","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:TREES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Trees")
AddEventHandler("farmer:Trees",function()
	if next(Waypoints) then
		for _,id in pairs(Waypoints) do
			exports["waypoints"]:RemoveWaypoint(id)
		end

		Waypoints = {}

		TriggerEvent("Notify","Árvores","Marcação desativada.","default",5000)
	else
		local Coords = vec3(2110.77,5078.5,44.3)

		Waypoints[1] = exports["waypoints"]:AddWaypoint(Coords,{ label = "Árvores", color = Theme["main"], autoRemove = true })

		TriggerEvent("Notify","Árvores","Marcação ativada.","default",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler(nil,"global",function(Name,Key,Value)
	if Key:sub(1,7) == "Farmer:" then
		local Number = tonumber(Key:sub(8))
		if Number then
			if Display[Number] then
				if DoesEntityExist(Display[Number]) then
					DeleteEntity(Display[Number])
				end

				exports.target:RemCircleZone("Farmer:"..Number)
				Display[Number] = nil
			end

			if Blips[Number] then
				if DoesBlipExist(Blips[Number]) then
					RemoveBlip(Blips[Number])
				end

				Blips[Number] = nil
			end

			if Waypoints[Number] then
				exports["waypoints"]:RemoveWaypoint(Waypoints[Number])
				Waypoints[Number] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLYZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.PolyZone(Service)
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)

	return Poly[Service] and Poly[Service]:isPointInside(Coords)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:SPAWNACTIVIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:SpawnActivist")
AddEventHandler("farmer:SpawnActivist",function()
	local Ped = PlayerPedId()
	local Coords = GetEntityCoords(Ped)
	local Model = "cs_hunter"

	local Angle = math.random() * 2 * math.pi
	local Radius = math.random(25,30)
	local x = Coords.x + Radius * math.cos(Angle)
	local y = Coords.y + Radius * math.sin(Angle)
	local _,z = GetGroundZFor_3dCoord(x,y,Coords.z + 10.0,0)

	local Networked = vRPS.CreateModels(Model,x,y,z,28)
	if Networked then
		local Hunter = LoadNetwork(Networked)
		if Hunter then
			TriggerEvent("Notify","Atenção","Um caçador ativista apareceu.","amarelo",5000)

			SetEntityMaxHealth(Hunter,500)
			SetEntityHealth(Hunter,500)
			SetEntityInvincible(Hunter,false)
			SetPedRelationshipGroupHash(Hunter,GetHashKey("HATES_PLAYER"))
			SetPedFleeAttributes(Hunter,0,false)
			SetPedCombatAttributes(Hunter,0,true)
			SetPedCombatAttributes(Hunter,46,true)
			SetPedCombatAttributes(Hunter,5,true)
			SetPedCombatAttributes(Hunter,16,true)
			SetPedCombatRange(Hunter,2)
			SetPedCombatMovement(Hunter,3)
			SetPedCombatAbility(Hunter,2)
			SetBlockingOfNonTemporaryEvents(Hunter,false)
			GiveWeaponToPed(Hunter,GetHashKey("WEAPON_MACHETE"),500,true,true)
			TaskCombatPed(Hunter,Ped,0,16)
			SetPedKeepTask(Hunter,true)

			CreateThread(function()
				local Timeout = GetGameTimer() + 45000
				while DoesEntityExist(Hunter) and GetGameTimer() < Timeout do
					if not IsPedInCombat(Hunter,Ped) then
						TaskCombatPed(Hunter,Ped,0,16)
					end

					Wait(3000)
				end
			end)
		end
	end
end)