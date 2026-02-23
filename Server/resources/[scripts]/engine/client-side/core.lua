-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("engine")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Price = 0
local Lasted = 0
local Display = false
local VehicleBrakes = {}
local VehicleFuel = false
local ExplosionChance = math.random(1,100)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELWARNINGS
-----------------------------------------------------------------------------------------------------------------------------------------
local FuelWarnings = {
	[30] = false,
	[20] = false,
	[10] = false
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELPRICES
-----------------------------------------------------------------------------------------------------------------------------------------
local FuelPrices = {
	["247"]   = 3.0,
	["LTD"]   = 4.0,
	["Oil"]   = 2.0,
	["Xero"]  = 1.0,
	["Globe"] = 5.0
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ELECTRICVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
local ElectricVehicles = {
	["neon"] = true,
	["raiden"] = true,
	["cyclone"] = true,
	["voltic"] = true,
	["tezeract"] = true,
	["imorgon"] = true,
	["khamelion"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
local Consume = {
	[1.0] = 0.675,
	[0.9] = 0.625,
	[0.8] = 0.575,
	[0.7] = 0.525,
	[0.6] = 0.475,
	[0.5] = 0.425,
	[0.4] = 0.375,
	[0.3] = 0.325,
	[0.2] = 0.275,
	[0.1] = 0.125,
	[0.0] = 0.025
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FLOOR
-----------------------------------------------------------------------------------------------------------------------------------------
function floor(Number)
	return math.floor(Number * 10 + 0.5) * 0.1
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BRAKESTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			if GetVehiclePedIsTryingToEnter(Ped) > 0 then
				local Vehicle = GetVehiclePedIsUsing(Ped)
				if NetworkGetEntityIsNetworked(Vehicle) then
					local Network = NetworkGetNetworkIdFromEntity(Vehicle)
					if GetVehicleClass(Vehicle) ~= 14 and GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16 and GetVehicleClass(Vehicle) ~= 21 then
						VehicleBrakes[Network] = vSERVER.VehicleBrakes(Network)

						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
					end
				end
			end
		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GAMEEVENTTRIGGERED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("gameEventTriggered",function(Event,Message)
	if Event == "CEventNetworkPlayerEnteredVehicle" and Message[1] == PlayerId() then
		local Ped = PlayerPedId()
		local Vehicle = Message[2]
		if not Entity(Vehicle).state.Fuel then
			Entity(Vehicle).state:set("Fuel",100.0,true)
		end

		SetPedConfigFlag(Ped,35,false)
		SetVehicleFuelLevel(Vehicle,Entity(Vehicle).state.Fuel + 0.0)

		if not IsPedInAnyHeli(Ped) then
			TriggerEvent("inventory:CleanWeapons")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISELECTRIC
-----------------------------------------------------------------------------------------------------------------------------------------
function IsElectric(Vehicle)
	local Model = GetEntityModel(Vehicle)
	return ElectricVehicles[GetDisplayNameFromVehicleModel(Model):lower()] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:FUELADMIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:FuelAdmin")
AddEventHandler("engine:FuelAdmin",function()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local Vehicle = GetVehiclePedIsUsing(Ped)
		Entity(Vehicle).state:set("Fuel",100.0,true)
		TriggerServerEvent("engine:SyncFuel",VehToNet(Vehicle),100.0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCONSUME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			local Class = GetVehicleClass(Vehicle)
			if Class ~= 13 and Class ~= 14 then
				local CurrentFuel = GetVehicleFuelLevel(Vehicle)
				if CurrentFuel >= 1 then
					if (GetEntitySpeed(Vehicle) * VehicleSpeed) >= 1 then
						local RPM = floor(GetVehicleCurrentRpm(Vehicle))
						local Consumption = (Consume[RPM] or 1.0) * 0.1
						local NewFuel = CurrentFuel - Consumption

						SetVehicleFuelLevel(Vehicle,NewFuel)

						if GetPedInVehicleSeat(Vehicle,-1) == Ped then
							Entity(Vehicle).state:set("Fuel",NewFuel,true)
						end

						for level,_ in pairs(FuelWarnings) do
							if NewFuel <= level and not FuelWarnings[level] then
								local Message = "O <b>Combustível</b> está abaixo de <b>"..level.."%</b>."
								if IsElectric(Vehicle) then
									Message = "A <b>Bateria</b> está abaixo de <b>"..level.."%</b>."
								end

								TriggerEvent("Notify","Atenção",Message,"amarelo",10000)

								PlaySoundFrontend(-1,"5_Second_Timer","DLC_HEISTS_GENERAL_FRONTEND_SOUNDS",true)

								FuelWarnings[level] = true
							end
						end

						if NewFuel > 30 then
							for level,_ in pairs(FuelWarnings) do
								FuelWarnings[level] = false
							end
						end
					end
				else
					SetVehicleEngineOn(Vehicle,false,true,true)

					TimeDistance = 1
				end
			end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSUMEBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			local Vehicle = GetVehiclePedIsUsing(Ped)
			if GetVehicleClass(Vehicle) ~= 14 and GetVehicleClass(Vehicle) ~= 15 and GetVehicleClass(Vehicle) ~= 16 and GetVehicleClass(Vehicle) ~= 21 then
				local Speed = GetEntitySpeed(Vehicle) * VehicleSpeed
				if Speed >= 1 and NetworkGetEntityIsNetworked(Vehicle) then
					local Network = NetworkGetNetworkIdFromEntity(Vehicle)

					if VehicleBrakes[Network] == nil then
						VehicleBrakes[Network] = vSERVER.VehicleBrakes(Network)

						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
						SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
					end

					if GetPedInVehicleSeat(Vehicle,-1) == Ped then
						if IsPedOnAnyBike(Ped) then
							local BrakeStatus = GetVehicleWheelBrakePressure(Vehicle,0)

							if BrakeStatus ~= 0.0 then
								BrakeUpdate(Vehicle,Network)
							end
						else
							local BrakeStatus = GetVehicleWheelBrakePressure(Vehicle,0)
							local OtherBrakeStatus = GetVehicleWheelBrakePressure(Vehicle,2)

							if BrakeStatus ~= 0.0 or OtherBrakeStatus ~= 0.0 then
								BrakeUpdate(Vehicle,Network)
							end
						end
					end
				end
			end
		end

		Wait(500)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SUPPLY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("engine:Supply", function(Entitys,Brand)
	if VehicleFuel then return false end

	local Ped = PlayerPedId()
	local Vehicle = Entitys[3]
	local EngineHealth = GetVehicleEngineHealth(Vehicle)

	if not DoesEntityExist(Vehicle) or not IsVehicleDriveable(Vehicle, false) then
		TriggerEvent("Notify", "Aviso", "Veículo inválido.", "vermelho", 5000)
		return false
	end

	if IsElectric(Vehicle) then
		TriggerEvent("Notify", "Aviso", "Veículos <b>elétricos</b> não podem abastecer em postos convencionais.", "vermelho", 5000)
		return false
	end

	local Gallons = Entitys[6]
	local VehicleState = Entity(Vehicle).state

	if not VehicleState.Fuel then
		VehicleState:set("Fuel", 100.0, true)
	end

	local Lasted = VehicleState.Fuel
	if Lasted > 99.98 then
		TriggerEvent("Notify", "Atenção", "O tanque já está cheio.", "amarelo", 5000)
		return false
	end

	if vSERVER.CanUse(EngineHealth) then
		local Coords = GetEntityCoords(Vehicle)

		if not Display and not Gallons then
			SendNUIMessage({ Action = "Open" })
			TriggerEvent("hud:Active", false)
			Display = true
		end

		if not VehicleFuel then
			TaskTurnPedToFaceEntity(Ped, Vehicle, 5000)
			VehicleFuel = Lasted
		end

		CreateThread(function()
			while VehicleFuel do
				if EngineHealth <= 900 then
					if not IsEntityOnFire(Vehicle) then
						SetVehiclePetrolTankHealth(Vehicle,100.0)
						StartScriptFire(Coords,25,true)
					end
				end

				Wait(1000)
			end
		end)

		while VehicleFuel do
			for _, v in ipairs({18,22,23,24,29,30,31,140,141,142,143,257,263}) do
				DisableControlAction(0, v, true)
			end

			if not Gallons then
				local UnitPrice = FuelPrices[Brand] or 1.0
				Price += UnitPrice * 0.02
				VehicleFuel += 0.02

				local DisplayPrice = tonumber(string.format("%.2f", Price))
				SendNUIMessage({ Action = "Tank", Payload = { math.floor(VehicleFuel), DisplayPrice, UnitPrice } })
			else
				local Ammo = GetAmmoInPedWeapon(Ped, 883325847)
				if Ammo > 2 then
					SetPedAmmo(Ped, 883325847, math.floor(Ammo - 2))
					VehicleFuel += 0.02
				end
			end

			SetDrawOrigin(Coords.x,Coords.y,Coords.z)
			DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
			ClearDrawOrigin()

			if not IsEntityPlayingAnim(Ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) and LoadAnim("timetable@gardener@filling_can") then
				TaskPlayAnim(Ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 8.0, 8.0, -1, 50, 1, 0, 0, 0)
			end

			if (VehicleFuel >= 100.0 or GetEntityHealth(Ped) <= 100 or (Gallons and GetAmmoInPedWeapon(Ped, 883325847) <= 2) or IsControlJustPressed(1, 38)) then
				if not Gallons and not vSERVER.RechargeFuel(Price, VehicleFuel + 0.0, "Fuel") then
					VehicleState:set("Fuel", Lasted + 0.0, true)
					TriggerServerEvent("engine:SyncFuel", VehToNet(Vehicle), Lasted + 0.0)

					TriggerEvent("Notify", "Aviso", "Dinheiro insuficiente.", "amarelo", 5000)

					if ExplosionChance <= 10 then
						AddExplosion(GetEntityCoords(Vehicle), 0, 1.0, true, false, 0.0)
					end
				else
					VehicleState:set("Fuel", VehicleFuel + 0.0, true)
					TriggerServerEvent("engine:SyncFuel", VehToNet(Vehicle), VehicleFuel + 0.0)

					if Display then
						SendNUIMessage({ Action = "Close" })
						TriggerEvent("hud:Active", true)
					end
				end

				VehicleFuel = false
				Display = false
				vRP.Destroy()
				Lasted = 0
				Price = 0
			end

			Wait(1)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:RECHARGE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("engine:Recharge",function(Entitys)
	if VehicleFuel then
		return false
	end

	local Ped = PlayerPedId()
	local Vehicle = Entitys[3]

	if not IsElectric(Vehicle) then
		TriggerEvent("Notify","Aviso","Apenas veículos <b>elétricos</b> podem usar o carregador.","vermelho",5000)
		return
	end

	local VehicleState = Entity(Vehicle).state

	if not VehicleState.Fuel then
		VehicleState:set("Fuel",100.0,true)
	end

	Lasted = VehicleState.Fuel
	if Lasted > 99.980 then
		TriggerEvent("Notify","Atenção","A bateria já está carregada.","amarelo",5000)
		return false
	end

	local Coords = GetEntityCoords(Vehicle)

	if not Display and not Gallons then
		SendNUIMessage({ Action = "Open" })
		TriggerEvent("hud:Active",false)
		Display = true
	end

	if not VehicleFuel then
		TaskTurnPedToFaceEntity(Ped,Vehicle,5000)
		VehicleFuel = Lasted
	end

	while VehicleFuel do
		for _,v in ipairs({ 18,22,23,24,29,30,31,140,141,142,143,257,263 }) do
			DisableControlAction(0,v,true)
		end

		Price += 0.2
		VehicleFuel += 0.05
		SendNUIMessage({ Action = "Tank", Payload = { floor(VehicleFuel),Price,0.8 } })

		SetDrawOrigin(Coords.x,Coords.y,Coords.z)
		DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
		ClearDrawOrigin()

		if not IsEntityPlayingAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",3) and LoadAnim("timetable@gardener@filling_can") then
			TaskPlayAnim(Ped,"timetable@gardener@filling_can","gar_ig_5_filling_can",8.0,8.0,-1,50,1,0,0,0)
		end

		if (VehicleFuel >= 100.0 or GetEntityHealth(Ped) <= 100 or IsControlJustPressed(1,38)) then
			if not vSERVER.RechargeFuel(Price,VehicleFuel + 0.0,"Battery") then
				VehicleState:set("Fuel", Lasted + 0.0, true)
				TriggerServerEvent("engine:SyncFuel", VehToNet(Vehicle), Lasted + 0.0)

				TriggerEvent("Notify","Aviso","Dinheiro insuficiente.","amarelo",5000)

				if ExplosionChance <= 20 then
					AddExplosion(GetEntityCoords(Vehicle),0,1.0,true,false,0.0)
				end
			else
				VehicleState:set("Fuel",VehicleFuel + 0.0,true)
				TriggerServerEvent("engine:SyncFuel", VehToNet(Vehicle), VehicleFuel + 0.0)

				if Display then
					SendNUIMessage({ Action = "Close" })
					TriggerEvent("hud:Active",true)
				end
			end

			VehicleFuel = false
			Display = false
			vRP.Destroy()
			Lasted = 0
			Price = 0
		end

		Wait(1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BRAKEUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function BrakeUpdate(Vehicle,Network)
	local BrakeForceFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce")
	local BrakeFrontFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront")
	local BrakeHandFloat = GetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce")

	local ForceFloat = BrakeForceFloat - (0.90 * 0.0015)
	local FrontFloat = BrakeFrontFloat - (0.55 * 0.0030)
	local HandFloat = BrakeHandFloat - (0.75 * 0.0030)

	if ForceFloat <= 0.0900 then ForceFloat = 0.0900 end
	if FrontFloat <= 0.0550 then FrontFloat = 0.0550 end
	if HandFloat <= 0.0750 then HandFloat = 0.0750 end

	local PlayersAround = {}
	for _,Player in ipairs(GetActivePlayers()) do
		PlayersAround[#PlayersAround + 1] = GetPlayerServerId(Player)
	end

	TriggerServerEvent("engine:TryBrakes",Network,{ ForceFloat,FrontFloat,HandFloat },PlayersAround)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:SYNCBRAKES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("engine:SyncBrakes")
AddEventHandler("engine:SyncBrakes",function(Network,Result)
	VehicleBrakes[Network] = Result

	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeForce",VehicleBrakes[Network][1])
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fBrakeBiasFront",VehicleBrakes[Network][2])
			SetVehicleHandlingFloat(Vehicle,"CHandlingData","fHandBrakeForce",VehicleBrakes[Network][3])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENGINE:VEHRIFY
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("engine:Vehrify",function(Entitys)
	local Vehicle = Entitys[3]

	local VehicleBrakes = vSERVER.VehicleBrakes(NetworkGetNetworkIdFromEntity(Vehicle))
	exports.dynamic:AddMenu("Freios","Verificar os freios do veículo.","brakes")
	local BrakeForce = Dotted((VehicleBrakes[1] * 10000) / 90)
	exports.dynamic:AddButton("Integral",("O <rare>Freio Integral</rare> se encontra em <rare>%d%%</rare>."):format(BrakeForce),"","","brakes",false)
	local BrakeFront = Dotted((VehicleBrakes[2] * 10000) / 55)
	exports.dynamic:AddButton("Dianteiro",("O <rare>Freio Dianteiro</rare> se encontra em <rare>%d%%</rare>."):format(BrakeFront),"","","brakes",false)
	local BrakeHands = Dotted((VehicleBrakes[3] * 10000) / 75)
	exports.dynamic:AddButton("Traseiro",("O <rare>Freio Traseiro</rare> se encontra em <rare>%d%%</rare>."):format(BrakeHands),"","","brakes",false)

	local Title = "Gasolina"
	local Message = "O combustível está com <rare>%d%%</rare> da capacidade."
	if IsElectric(Vehicle) then
		Title = "Bateria"
		Message = "A bateria está com <rare>%d%%</rare> da capacidade."
	end

	local Fuel = Dotted(Entity(Vehicle).state.Fuel)
	exports.dynamic:AddButton(Title,(Message):format(Fuel),"","",false,false)

	local Mods = {
		{ Number = 11, Name = "Motor" },
		{ Number = 12, Name = "Freios" },
		{ Number = 13, Name = "Transmissão" },
		{ Number = 15, Name = "Suspensão" },
		{ Number = 16, Name = "Blindagem" }
	}

	for _,v in ipairs(Mods) do
		local CurrentMod = GetVehicleMod(Vehicle,v.Number)
		if CurrentMod ~= -1 then
			local Total = GetNumVehicleMods(Vehicle,v.Number)
			exports.dynamic:AddButton(v.Name,("Modificação atual instalada: <rare>%d</rare> / %d"):format(CurrentMod + 1,Total),"","",false,false)
		end
	end

	local Force = Dotted(GetVehicleEngineHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Potência",("Potência do motor se encontra em <rare>%d%%</rare>."):format(Force),"","",false,false)

	local Body = Dotted(GetVehicleBodyHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Lataria",("Qualidade da lataria se encontra em <rare>%d%%</rare>."):format(Body),"","",false,false)

	local Health = Dotted(GetEntityHealth(Vehicle) / 10)
	exports.dynamic:AddButton("Chassi",("Rigidez do chassi se encontra em <rare>%d%%</rare>."):format(Health),"","",false,false)

	if Entity(Vehicle).state.Lockpick then
		exports.dynamic:AddButton("Numeração","O veículo possui a numeração <epic>Adulterada</epic>.","","",false,false)
	else
		exports.dynamic:AddButton("Numeração","O veículo possui a numeração <common>Original</common>.","","",false,false)
	end

	exports.dynamic:Open()
end)