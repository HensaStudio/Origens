-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("towed")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Destiny = 1
local Vehicle = nil
local Locale = false
local Service = false
local ModelSelected = ""
local TimeDistance = 1000
local VehiclePlate = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVERYCOORD
-----------------------------------------------------------------------------------------------------------------------------------------
local DeliveryCoord = vec3(-208.94,-1168.93,23.03)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
local RColor,GColor,BColor = HexToRGB(Theme["main"])
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(Init) do
		exports.target:AddBoxZone("Towed:"..Name,v["xyz"],0.75,0.75,{
			name = "Towed:"..Name,
			heading = v["w"],
			minZ = v["z"] - 1.0,
			maxZ = v["z"] + 1.0
		},{
			shop = Name,
			Distance = 1.75,
			options = {
				{
					event = "towed:Init",
					label = "Iniciar Expediente",
					tunnel = "client"
				},{
					event = "garages:Impound",
					label = "Veículos Apreendidos",
					tunnel = "client"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWED:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("towed:Init",function(Data)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end

	if Service then
		TriggerEvent("Notify","Central de Empregos","Você acaba finalizar sua jornada de trabalho.","default",5000)
		exports.target:LabelText("Towed:"..Data,"Iniciar Expediente")
		Service = false
		Locale = false
		Vehicle = nil
		VehiclePlate = false
	else
		Locale = Data
		TriggerEvent("Notify","Central de Empregos","Você iniciou sua jornada de trabalho.","default",5000)
		exports.target:LabelText("Towed:"..Data,"Finalizar Expediente")
		ModelSelected = Models[math.random(#Models)]
		Destiny = math.random(#Locations[Locale])
		VehiclePlate = false
		MarkedVehicle()
		Service = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWED:INATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("towed:Inative")
AddEventHandler("towed:Inative",function(Plate)
	if VehiclePlate and VehiclePlate == Plate then
		ModelSelected = Models[math.random(#Models)]
		Destiny = math.random(#Locations[Locale])
		VehiclePlate = false
		TimeDistance = 1000
		MarkedVehicle()
		Vehicle = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		TimeDistance = 1000

		if Service and Locale then
			local Ped = PlayerPedId()
			local Coords = GetEntityCoords(Ped)

			if not Vehicle then
				if #(Coords - Locations[Locale][Destiny]["xyz"]) <= 100.0 then
					local Networked,Plate = vSERVER.Vehicle(ModelSelected,Locale,Destiny)

					if Networked then
						local EntityNet = LoadNetwork(Networked)
						while not DoesEntityExist(EntityNet) do
							Wait(100)
						end

						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
							Blip = nil
						end

						Vehicle = EntityNet
						VehiclePlate = Plate

						SetVehicleHasBeenOwnedByPlayer(Vehicle,true)
						SetVehicleNeedsToBeHotwired(Vehicle,false)
						DecorSetInt(Vehicle,"Player_Vehicle",-1)
						SetVehicleOnGroundProperly(Vehicle)
						SetVehRadioStation(Vehicle,"OFF")
					end
				end

			elseif DoesEntityExist(Vehicle) then
				local State = Entity(Vehicle).state
				TimeDistance = 5

				if State and not State.Tow then
					local VehCoords = GetEntityCoords(Vehicle)
					DrawMarker(22,VehCoords.x, VehCoords.y, VehCoords.z + 2.5,0.0,0.0,0.0,0.0,180.0,0.0,2.5,2.5,1.5,RColor,GColor,BColor,175,false,false,0,true)
				end

				if State and State.Tow then
					DrawMarker(22,DeliveryCoord.x, DeliveryCoord.y, DeliveryCoord.z + 1.5,0.0,0.0,0.0,0.0,180.0,0.0,3.0,3.0,1.5,RColor,GColor,BColor,175,false,false,0,true)
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARKEDVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function MarkedVehicle()
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
	end

	Blip = AddBlipForCoord(Locations[Locale][Destiny].x,Locations[Locale][Destiny].y,Locations[Locale][Destiny].z)

	SetBlipSprite(Blip,1)
	SetBlipDisplay(Blip,4)
	SetBlipAsShortRange(Blip,true)
	SetBlipColour(Blip,77)
	SetBlipScale(Blip,0.75)
	SetBlipRoute(Blip,true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Veículo Quebrado")
	EndTextCommandSetBlipName(Blip)
end