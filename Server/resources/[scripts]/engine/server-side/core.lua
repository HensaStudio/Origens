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
Tunnel.bindInterface("engine",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local VehicleBrakes = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RechargeFuel(Price,Amount,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if not (Passport and Price and Amount and Mode) then
		return false
	end

	local IsService = vRP.HasService(Passport,"LSPD") or vRP.HasService(Passport,"PRPD") or vRP.HasService(Passport,"Paramedic") or vRP.HasService(Passport,"Mechanic")

	local ModeText = Mode == "Fuel" and "Tanque" or "Bateria"

	if IsService then
		TriggerClientEvent("Notify",source, "Sucesso",("%s <b>%s%%</b> %s e você foi isento de cobranças."):format(ModeText,Dotted(Amount),Mode == "Fuel" and "abastecido" or "carregada"),"verde",5000)
		return true
	elseif vRP.PaymentFull(Passport,Price) then
		TriggerClientEvent("Notify",source,"Sucesso",("%s <b>%s%%</b> %s."):format(ModeText,Dotted(Amount),Mode == "Fuel" and "abastecido" or "carregada"),"verde",5000)
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VehicleBrakes(Vehicle)
	if VehicleBrakes[Vehicle] == nil then
		VehicleBrakes[Vehicle] = { 0.90,0.55,0.75 }
	end

	return VehicleBrakes[Vehicle]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:TRYBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:TryBrakes")
AddEventHandler("engine:TryBrakes",function(Vehicle,BrakesStatus,PlayersAround)
	VehicleBrakes[Vehicle] = BrakesStatus

	if PlayersAround then
		for _,v in ipairs(PlayersAround) do
			async(function()
				TriggerClientEvent("engine:SyncBrakes",v,Vehicle,BrakesStatus)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:APPLYBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:ApplyBrakes")
AddEventHandler("engine:ApplyBrakes",function(Item,Vehicle,Brakes,PlayersAround)
	if VehicleBrakes[Vehicle] then
		if Item == "graphite01" then
			VehicleBrakes[Vehicle][1] = VehicleBrakes[Vehicle][1] + (Brakes * 0.0090) + 0.0
		elseif Item == "graphite02" then
			VehicleBrakes[Vehicle][2] = VehicleBrakes[Vehicle][2] + (Brakes * 0.0055) + 0.0
		elseif Item == "graphite03" then
			VehicleBrakes[Vehicle][3] = VehicleBrakes[Vehicle][3] + (Brakes * 0.0075) + 0.0
		end

		if VehicleBrakes[Vehicle][1] >= 0.90 then
			VehicleBrakes[Vehicle][1] = 0.90
		end

		if VehicleBrakes[Vehicle][2] >= 0.55 then
			VehicleBrakes[Vehicle][2] = 0.55
		end

		if VehicleBrakes[Vehicle][3] >= 0.75 then
			VehicleBrakes[Vehicle][3] = 0.75
		end

		if PlayersAround and type(PlayersAround) == "table" and #PlayersAround > 0 then
			for _,v in ipairs(PlayersAround) do
				async(function()
					TriggerClientEvent("engine:SyncBrakes",v,Vehicle,VehicleBrakes[Vehicle])
					TriggerClientEvent("Notify",v,"Sucesso","O freio do veículo foi atualizado.","verde",5000)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SYNCFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("engine:SyncFuel")
AddEventHandler("engine:SyncFuel",function(Network,Fuel)
	local Vehicle = NetworkGetEntityFromNetworkId(Network)
	if DoesEntityExist(Vehicle) then
		Entity(Vehicle).state:set("Fuel",Fuel,true)
	end
end)