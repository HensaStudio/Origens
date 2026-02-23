-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("pdm")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lasted = ""
local Camera = nil
local Selected = 1
local Preview = nil
local Vehicles = VehicleList()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
local RColor, GColor, BColor = HexToRGB(Theme["main"])
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
	{
		List = {},
		PdmCoords = vec3(-32.33,-1112.48,26.75),
		KeysCoords = vec3(-31.79,-1105.10,26.73),
		Cam = vec4(-49.14,-1099.56,26.92,294.81),
		Spawn = vec4(-44.42,-1097.44,26.23,28.35),
		DriveIn = vec4(-54.56,-1075.18,26.45,68.04),
		DriveOut = vec4(-32.04,-1111.02,26.42,172.92),
		Classes = {
			--Compactos = true,
			--Esportivos = true
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Config) do
		exports.target:AddCircleZone("PDM:"..Index,v.PdmCoords,0.1,{
			name = "PDM:"..Index,
			heading = 0.0,
			useZ = true
		},{
			shop = Index,
			Distance = 1.55,
			options = {
				{ event = "pdm:Open", label = "Comprar Veículo", tunnel = "client" }
			}
		})

		exports.target:AddCircleZone("PDM-KEYS:"..Index,v.KeysCoords,0.1,{
			name = "PDM-KEYS:"..Index,
			heading = 0.0,
			useZ = true
		},{
			shop = Index,
			Distance = 1.55,
			options = {
				{ event = "pdm:MakeVehiclekey", label = "Chave Reserva", tunnel = "client" }
			}
		})

		if v.Classes and next(v.Classes) then
			for Model,Vehicle in pairs(Vehicles) do
				if Vehicle.Class and v.Classes[Vehicle.Class] then
					v.List[Model] = Vehicle
				end
			end
		else
			v.List = Vehicles
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PDM:MAKEVEHICLEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("pdm:MakeVehiclekey")
AddEventHandler("pdm:MakeVehiclekey", function()
	local Vehicles = vSERVER.Vehicles()
	if parseInt(#Vehicles) > 0 then
		for k,v in pairs(Vehicles) do
			exports.dynamic:AddMenu(v["Name"],"Clique para mais informações.",v["Model"])
			exports.dynamic:AddButton("Informações","Placa do veículo: <rare>"..v["Plate"].."</rare>.","","",v["Model"],false)
			exports.dynamic:AddButton(ItemName("vehiclekey"),"Clique para fazer uma <b>"..ItemName("vehiclekey").."</b>.","pdm:MakeVehiclekey",v["Plate"],v["Model"],true)
		end

		exports.dynamic:Open()
	else
		TriggerEvent("Notify","Atenção","Você não possui veículos.","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Close()
	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	Lasted = ""
	vRP.Destroy()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	TriggerEvent("hud:Active",true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAMERAACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function CameraActive()
	if DoesCamExist(Camera) then
		RenderScriptCams(false,false,0,false,false)
		DestroyCam(Camera,false)
		Camera = nil
	end

	Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA",true)
	SetCamRot(Camera,0.0,0.0,Config[Selected].Cam.w)
	SetCamCoord(Camera,Config[Selected].Cam.xyz)
	RenderScriptCams(true,false,0,false,false)
	SetCamActive(Camera,true)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PDM:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("pdm:Open",function(Number)
	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	if not LocalPlayer.state.Buttons and not LocalPlayer.state.Commands and not exports.hud:Wanted() then
		CameraActive()
		Selected = Number
		SetNuiFocus(true,true)
		SetCursorLocation(0.5,0.5)
		TriggerEvent("hud:Active",false)
		SendNUIMessage({ Action = "Open", Payload = { Vehicles = Config[Selected].List, Discounts = vSERVER.Discount(), Tax = 0.25, TaxTime = "MENSAL" } })

		vRP.CreateObjects("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_a","prop_cs_tablet",49,28422,-0.05,0.0,0.0,0.0,0.0, 0.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	Close()

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Model = Data.Vehicle
	if LoadModel(Model) and Lasted ~= Model then
		if DoesEntityExist(Preview) then
			DeleteEntity(Preview)
			Preview = nil
		end

		Preview = CreateVehicle(Model,Config[Selected].Spawn,false,false)
		SetVehicleCustomSecondaryColour(Preview,RColor,GColor,BColor)
		SetVehicleCustomPrimaryColour(Preview,RColor,GColor,BColor)
		SetVehicleNumberPlateText(Preview,"PDMSPORT")
		SetEntityCollision(Preview,false,false)
		FreezeEntityPosition(Preview,true)
		SetEntityInvincible(Preview,true)
		SetVehicleDirtLevel(Preview,0.0)
		Lasted = Model
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Buy",function(Data,Callback)
	local Sucess = vSERVER.Buy(Data.Vehicle,Data.Rental)

	if Sucess then
		SendNUIMessage({ Action = "Close" })
		Close()
	end

	Callback(Sucess)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Rotate",function(Data,Callback)
	if DoesEntityExist(Preview) then
		local Offset = Data.Direction == "Left" and -5 or 5
		SetEntityHeading(Preview,GetEntityHeading(Preview) + Offset)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Drive", function(Data, Callback)
	if not vSERVER.Check() or not LoadModel(Data.Vehicle) then
		return Callback("Ok")
	end

	SendNUIMessage({ Action = "Close" })
	Close()

	if DoesEntityExist(Preview) then
		DeleteEntity(Preview)
		Preview = nil
	end

	Preview = CreateVehicle(Data.Vehicle,Config[Selected].DriveIn,false,false)

	SetVehicleModKit(Preview,0)
	SetVehicleDirtLevel(Preview,0.0)
	ToggleVehicleMod(Preview,18,true)
	SetEntityInvincible(Preview,true)
	SetPedIntoVehicle(PlayerPedId(),Preview,-1)
	SetVehicleNumberPlateText(Preview,"PDMSPORT")
	SetVehicleCustomPrimaryColour(Preview,88,101,242)
	SetVehicleCustomSecondaryColour(Preview,88,101,242)

	for _,Type in ipairs({ 11,12,13,15 }) do
		SetVehicleMod(Preview,Type,GetNumVehicleMods(Preview,Type) - 1,false)
	end

	LocalPlayer.state:set("Commands",true,true)

	CreateThread(function()
		while true do
			local Ped = PlayerPedId()
			if not IsPedInAnyVehicle(Ped) then
				vSERVER.Remove()
				LocalPlayer.state:set("Commands",false,true)

				SetEntityHeading(Ped,Config[Selected].DriveOut.w)
				SetEntityCoords(Ped,Config[Selected].DriveOut.xyz)

				if DoesEntityExist(Preview) then
					DeleteEntity(Preview)
					Preview = nil

					break
				end
			end

			Wait(1)
		end
	end)

	Callback("Ok")
end)