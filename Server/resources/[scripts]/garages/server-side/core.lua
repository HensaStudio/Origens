-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Active = {}
local Signal = {}
local Changed = {}
local Searched = {}
local Respawns = {}
local Propertys = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERCENTAGEARREST
-----------------------------------------------------------------------------------------------------------------------------------------
PercentageArrest = 0.1 -- Porcentagem a cobrar para liberar o veículo apreendido
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
local RColor, GColor, BColor = HexToRGB(Theme["main"])
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	-- Garages
	["1"] = { ["Name"] = "Garage", ["Save"] = true },
	["2"] = { ["Name"] = "Garage", ["Save"] = true },
	["3"] = { ["Name"] = "Garage", ["Save"] = true },
	["4"] = { ["Name"] = "Garage", ["Save"] = true },
	["5"] = { ["Name"] = "Garage", ["Save"] = true },
	["6"] = { ["Name"] = "Garage", ["Save"] = true },
	["7"] = { ["Name"] = "Garage", ["Save"] = true },
	["8"] = { ["Name"] = "Garage", ["Save"] = true },
	["9"] = { ["Name"] = "Garage", ["Save"] = true },
	["10"] = { ["Name"] = "Garage", ["Save"] = true },
	["11"] = { ["Name"] = "Garage", ["Save"] = true },
	["12"] = { ["Name"] = "Garage", ["Save"] = true },
	["13"] = { ["Name"] = "Garage", ["Save"] = true },
	["14"] = { ["Name"] = "Garage", ["Save"] = true },
	["15"] = { ["Name"] = "Garage", ["Save"] = true },
	["16"] = { ["Name"] = "Garage", ["Save"] = true },
	["17"] = { ["Name"] = "Garage", ["Save"] = true },
	["18"] = { ["Name"] = "Garage", ["Save"] = true },
	["19"] = { ["Name"] = "Garage", ["Save"] = true },
	["20"] = { ["Name"] = "Garage", ["Save"] = true },
	["21"] = { ["Name"] = "Garage", ["Save"] = true },
	["22"] = { ["Name"] = "Garage", ["Save"] = true },
	["23"] = { ["Name"] = "Garage", ["Save"] = true },
	["24"] = { ["Name"] = "Garage", ["Save"] = true },
	["25"] = { ["Name"] = "Garage", ["Save"] = true },
	["26"] = { ["Name"] = "Garage", ["Save"] = true },

	-- Paramedic
	["41"] = { ["Name"] = "Paramedic", ["Permission"] = "Paramedic" },
	["42"] = { ["Name"] = "Paramedic2", ["Permission"] = "Paramedic" },

	-- Police
	["51"] = { ["Name"] = "LSPDCars", ["Permission"] = "LSPD" },
	["52"] = { ["Name"] = "LSPDHelicopters", ["Permission"] = "LSPD" },
	["53"] = { ["Name"] = "PRPDCars", ["Permission"] = "PRPD" },

	-- Mechanic
	["60"] = { ["Name"] = "Mechanic", ["Permission"] = "Mechanic" },

	-- Works
	["141"] = { ["Name"] = "Lumberman" },
	["142"] = { ["Name"] = "Driver" },
	["143"] = { ["Name"] = "Garbageman" },
	["144"] = { ["Name"] = "Transporter" },
	["145"] = { ["Name"] = "Garbageman" },
	["146"] = { ["Name"] = "Trucker" },
	["147"] = { ["Name"] = "Taxi" },
	["148"] = { ["Name"] = "Grime" },
	["149"] = { ["Name"] = "Towed" },
	["150"] = { ["Name"] = "Milkman" },
	["151"] = { ["Name"] = "Bikes" },
	["152"] = { ["Name"] = "Fishing" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
	["LSPDCars"] = {
		{ Model = "police", Permission = nil, Level = 1 },
		{ Model = "police2", Permission = nil, Level = 1 },
		{ Model = "police3", Permission = nil, Level = 1 },
		{ Model = "police4", Permission = nil, Level = 1 },
		{ Model = "policet", Permission = nil, Level = 1 }
	},
	["LSPDHelicopters"] = {
		{ Model = "polmav", Permission = nil, Level = 1 }
	},
	["PRPDCars"] = {
		{ Model = "sheriff", Permission = nil, Level = 1 },
		{ Model = "sheriff2", Permission = nil, Level = 1 },
		{ Model = "fbi", Permission = nil, Level = 1 },
		{ Model = "fbi2", Permission = nil, Level = 1 }
	},
	["Paramedic"] = {
		{ Model = "ambulance", Permission = nil, Level = 1 },
		{ Model = "firetruk", Permission = nil, Level = 1 },
		{ Model = "lguard", Permission = nil, Level = 1 }
	},
	["Mechanic"] = {
		{ Model = "flatbed", Permission = nil, Level = 1 },
		{ Model = "towtruck", Permission = nil, Level = 1 }
	},
	["Driver"] = {
		{ Model = "bus", Permission = nil, Level = 1 }
	},
	["Transporter"] = {
		{ Model = "stockade", Permission = nil, Level = 1 }
	},
	["Lumberman"] = {
		{ Model = "ratloader", Permission = nil, Level = 1 }
	},
	["Garbageman"] = {
		{ Model = "trash", Permission = nil, Level = 1 }
	},
	["Trucker"] = {
		{ Model = "packer", Permission = nil, Level = 1 }
	},
	["Taxi"] = {
		{ Model = "taxi", Permission = nil, Level = 1 }
	},
	["Grime"] = {
		{ Model = "boxville2", Permission = nil, Level = 1 }
	},
	["Towed"] = {
		{ Model = "flatbed", Permission = nil, Level = 1 }
	},
	["Milkman"] = {
		{ Model = "youga2", Permission = nil, Level = 1 }
	},
	["Bikes"] = {
		{ Model = "bmx", Permission = nil, Level = 1 },
		{ Model = "cruiser", Permission = nil, Level = 1 },
		{ Model = "fixter", Permission = nil, Level = 1 },
		{ Model = "scorcher", Permission = nil, Level = 1 },
		{ Model = "tribike", Permission = nil, Level = 1 },
		{ Model = "tribike2", Permission = nil, Level = 1 },
		{ Model = "tribike3", Permission = nil, Level = 1 }
	},
	["Fishing"] = {
		{ Model = "dinghy2", Permission = nil, Level = 1 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTITYREMOVED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("entityRemoved",function(Entitys)
	if IsPedAPlayer(Entitys) or GetEntityType(Entitys) ~= 2 then
		return false
	end

	local Plate = GetVehicleNumberPlateText(Entitys)
	Plate = Changed[Plate] or Plate

	local Data = Spawn[Plate]
	if not Data then
		return false
	end

	local State = Entity(Entitys).state
	local Health = GetEntityHealth(Entitys)
	local Coords = GetEntityCoords(Entitys)
	local Heading = GetEntityHeading(Entitys)
	local Body = GetVehicleBodyHealth(Entitys)
	local Engine = GetVehicleEngineHealth(Entitys)

	local Windows = {}
	for Number = 0,5 do
		Windows[Number] = IsVehicleWindowIntact(Entitys,Number)
	end

	local VehicleCoords = vec4(Coords.x,Coords.y,Coords.z,Heading)
	Respawns[Plate] = VehicleCoords

	TriggerClientEvent("garages:Respawn",-1,"Add",Plate,VehicleCoords)

	vRP.Update("vehicles/updateVehiclesRespawns",{ Passport = Data[1], Vehicle = Data[2], Nitro = parseInt(State.Nitro) or 0, Engine = parseInt(Engine), Body = parseInt(Body), Health = parseInt(Health), Fuel = parseInt(State.Fuel) or 0, Windows = json.encode(Windows) })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ServerVehicle(Model,Coords,Plate,Nitro,Doors,Body,Fuel,Seatbelt,Drift,Admin)
	if not Model or not Coords then
		return false
	end

	local CurrentTimer = os.time() + 10
	local Vehicle = CreateVehicle(Model,Coords,true,false)

	while not DoesEntityExist(Vehicle) or NetworkGetNetworkIdFromEntity(Vehicle) == 0 do
		if os.time() >= CurrentTimer then
			return false
		end

		Wait(100)
	end

	Plate = Plate or vRP.GeneratePlate()
	SetVehicleNumberPlateText(Vehicle,Plate)
	SetVehicleBodyHealth(Vehicle,(Body or 1000) + 0.0)

	if Admin then
		SetVehicleCustomPrimaryColour(Vehicle,RColor,GColor,BColor)
		SetVehicleCustomSecondaryColour(Vehicle,RColor,GColor,BColor)
	end

	if Doors then
		local Decoded = json.decode(Doors)
		if type(Decoded) == "table" then
			for Number,Broken in pairs(Decoded) do
				if Broken then
					SetVehicleDoorBroken(Vehicle,parseInt(Number),true)
				end
			end
		end
	end

	local State = Entity(Vehicle).state
	State:set("Nitro",Nitro or 0,true)
	State:set("Fuel",Fuel or 100.0,true)
	State:set("Drift",Drift or false,true)
	State:set("Seatbelt",Seatbelt or false,true)

	return true,NetworkGetNetworkIdFromEntity(Vehicle),Vehicle,Plate
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:RESPAWNS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Respawns")
AddEventHandler("garages:Respawns",function(Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Spawn = Spawn[Plate]
	local Respawn = Respawns[Plate]
	if not (Respawn and Spawn and Spawn[1] == Passport) then
		return false
	end
	local VehicleData = vRP.SingleQuery("vehicles/plateVehicles",{ Plate = Plate })
	if not VehicleData then
		return false
	end

	local Key = "LsCustoms:"..VehicleData.id..":"..VehicleData.Vehicle
	local Mods = vRP.GetSrvData(Key,true)

	local Exist,Network,Vehicle = Creative.ServerVehicle(VehicleData.Vehicle,Respawn,Plate,VehicleData.Nitro,VehicleData.Doors,VehicleData.Body,VehicleData.Fuel,VehicleData.Seatbelt,VehicleData.Drift)

	if not Exist then
		return false
	end

	for Passport,OtherSource in pairs(vRPC.Players(source)) do
		async(function()
			vCLIENT.CreateVehicle(OtherSource,VehicleData.Vehicle,Network,VehicleData.Engine,VehicleData.Health,Mods,VehicleData.Windows,VehicleData.Tyres,VehicleData.Brakes,VehicleData.Dirt)
		end)
	end

	Entity(Vehicle).state:set("Lockpick",Plate,true)
	TaskWarpPedIntoVehicle(GetPlayerPed(source),Vehicle,-1)
	TriggerClientEvent("garages:Respawn",-1,"Remove",Plate)
	Spawn[Plate] = { Spawn[1],VehicleData.Vehicle,Vehicle }
	Respawns[Plate] = nil

	if VehicleData.Keys == 1 then
		vRP.GiveItem(Passport,"vehiclekey-"..Plate,1,true)
		vRP.Query("vehicles/updateVehiclesKeys",{ Passport = Passport, Vehicle = VehicleData.Vehicle, Keys = 0 })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:CHANGEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:ChangePlate",function(Plate,NewPlate)
	Changed[NewPlate] = Plate
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("SignalRemove",function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Garage = Garages[Number]
	if not Garage then
		return false
	end

	if exports.bank:CheckTaxs(Passport) or exports.bank:CheckFines(Passport) then
		return false
	end

	if Garage.Permission and not vRP.HasService(Passport,Garage.Permission) then
		return false
	end

	local Vehicles = {}
	local Selected = Garage.Name

	if Works[Selected] then
		local BestLevels = {}

		for _,Entry in pairs(Works[Selected]) do
			if type(Entry) == "table" and Entry.Permission then
				if vRP.HasPermission(Passport,Entry.Permission,Entry.Level or 1) then
					local CurrentLevel = Entry.Level or 1
					if not BestLevels[Entry.Permission] or CurrentLevel < BestLevels[Entry.Permission] then
						BestLevels[Entry.Permission] = CurrentLevel
					end
				end
			end
		end

		for _,Entry in pairs(Works[Selected]) do
			local Model = Entry
			local Allowed = true

			if type(Entry) == "table" then
				Model = Entry.Model
				if Entry.Permission then
					local UserBestLevel = BestLevels[Entry.Permission]
					if not UserBestLevel or (Entry.Level or 1) ~= UserBestLevel then
						Allowed = false
					end
				end
			end

			if Allowed and VehicleExist(Model) then
				local TaxTimer,RentalTimer = false,false
				local Consult = vRP.SelectVehicle(Passport,Model)

				if Consult then
					if Consult.Tax > os.time() then
						TaxTimer = CompleteTimers(Consult.Tax - os.time())
					end

					if Consult.Rental ~= 0 then
						if Consult.Rental > os.time() then
							RentalTimer = CompleteTimers(Consult.Rental - os.time())
						else
							RentalTimer = "Vencido"
						end
					end

					table.insert(Vehicles,{
						Model = Model,
						Name = VehicleName(Model),
						Tax = VehiclePrice(Model) * 0.15,
						Mode = VehicleMode(Model),
						Weight = Consult.Weight,
						Engine = Consult.Engine / 10,
						Body = Consult.Body / 10,
						Fuel = Consult.Fuel,
						TaxTime = TaxTimer,
						RentalTime = RentalTimer
					})
				else
					table.insert(Vehicles,{
						Model = Model,
						Name = VehicleName(Model),
						Tax = VehiclePrice(Model) * 0.15,
						Mode = VehicleMode(Model),
						Weight = VehicleWeight(Model),
						Engine = 100,
						Body = 100,
						Fuel = 100,
						TaxTime = "30 Dias e 29 Horas",
						RentalTime = false
					})
				end
			end
		end
	else
		if string.sub(Number,1,9) == "Propertys" then
			local Consult = vRP.Query("propertys/Exist",{ Name = Number })
			local Property = Consult[1]
			if not Property then
				return false
			end

			local OwnerProperty = vRP.InventoryFull(Passport,"propertys-"..Property.Serial) or Property.Passport == Passport
			if not OwnerProperty or os.time() > Property.Tax then
				return false
			end
		end

		local Consult = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })
		for _,v in pairs(Consult) do
			if VehicleExist(v.Vehicle) and not v.Work then
				if not Garage.Save or v.Save == Number then
					local TaxTimer,RentalTimer = false,false

					if v.Tax > os.time() then
						TaxTimer = CompleteTimers(v.Tax - os.time())
					end

					if v.Rental ~= 0 then
						if v.Rental > os.time() then
							RentalTimer = CompleteTimers(v.Rental - os.time())
						else
							RentalTimer = "Vencido"
						end
					end

					table.insert(Vehicles,{
						Model = v.Vehicle,
						Name = VehicleName(v.Vehicle),
						Tax = VehiclePrice(v.Vehicle) * 0.15,
						Mode = VehicleMode(v.Vehicle),
						Weight = v.Weight,
						Engine = v.Engine / 10,
						Body = v.Body / 10,
						Fuel = v.Fuel,
						TaxTime = TaxTimer,
						RentalTime = RentalTimer
					})
				end
			end
		end
	end

	if #Vehicles <= 0 then
		TriggerClientEvent("Notify",source,"Aviso","Você não possui veículos nesta garagem.","amarelo",5000)
		return false
	end

	return Vehicles
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Sell")
AddEventHandler("garages:Sell",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then
		return false
	end
	Name = string.lower(Name)

	local Mode = VehicleMode(Name)
	local Class = VehicleClass(Name)
	if Mode == "Work" or Mode == "Rental" or Class == "Races" then
		return false
	end

	Active[Passport] = true
	TriggerClientEvent("garages:Close",source)

	local Price = VehiclePrice(Name) * 0.5
	local VehicleName = VehicleName(Name)
	local FormattedPrice = Dotted(Price)

	if vRP.Request(source,"Garagem","Vender o veículo <b>"..VehicleName.."</b> por <b>"..Currency..""..FormattedPrice.."</b>?") then
		local Vehicle = vRP.SelectVehicle(Passport,Name)
		if Vehicle and not Vehicle.Block then
			vRP.GiveBank(Passport,Price)
			vRP.RemSrvData("LsCustoms:"..Vehicle.id..":"..Vehicle.Vehicle)
			vRP.RemSrvData("Trunkchest:"..Passport..":"..Name)
			vRP.Query("vehicles/removeVehicles",{ Passport = Passport, Vehicle = Name })
			TriggerClientEvent("Notify",source,VehicleName,"Veículo vendido com sucesso.","verde",5000)
		end
	end

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Transfer")
AddEventHandler("garages:Transfer",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end
	Name = string.lower(Name)

	local Vehicle = vRP.SelectVehicle(Passport,Name)
	if not Vehicle or Vehicle.Block then
		return false
	end

	TriggerClientEvent("garages:Close",source)

	local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
	if not Keyboard then
		return false
	end

	local OtherPassport = parseInt(Keyboard[1])
	if OtherPassport <= 0 or OtherPassport == Passport then
		TriggerClientEvent("Notify",source,"Negado","Passaporte inválido.","vermelho",5000)
		return false
	end

	local OtherName = vRP.FullName(OtherPassport) or "Desconhecido"
	if not vRP.Request(source,"Garagem","Transferir o veículo <b>"..VehicleName(Name).."</b> para <b>"..OtherName.."</b>?") then
		return false
	end

	if vRP.SelectVehicle(OtherPassport,Name) then
		TriggerClientEvent("Notify",source,"Atenção","<b>"..OtherName.."</b> já possui este modelo de veículo.","amarelo",5000)
		return false
	end

	vRP.Update("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = OtherPassport, Vehicle = Name })

	local TrunkData = vRP.GetSrvData("Trunkchest:"..Passport..":"..Name,true)
	vRP.SetSrvData("Trunkchest:"..OtherPassport..":"..Name,TrunkData,true)
	vRP.RemSrvData("Trunkchest:"..Passport..":"..Name)

	TriggerClientEvent("Notify",source,"Sucesso","Transferência concluída para <b>"..OtherName.."</b>.","verde",5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TAX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Tax")
AddEventHandler("garages:Tax",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end
	Name = string.lower(Name)

	local Vehicle = vRP.SelectVehicle(Passport,Name)
	if not Vehicle or Vehicle.Tax > os.time() then
		return false
	end

	TriggerClientEvent("garages:Close",source)

	local Price = VehiclePrice(Name) * 0.15
	local VehicleName = VehicleName(Name)
	local FormattedPrice = Dotted(Price)

	if not vRP.Request(source,"Garagem","Pagar o <b>IPVA</b> do veículo <b>"..VehicleName.."</b> por <b>"..Currency..""..FormattedPrice.."</b>?") then
		return false
	end

	if vRP.PaymentFull(Passport,Price) then
		vRP.Update("vehicles/updateVehiclesTax",{ Passport = Passport, Vehicle = Name })
		TriggerClientEvent("Notify",source,"Sucesso","Pagamento concluído.","verde",5000)
	else
		TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Spawn")
AddEventHandler("garages:Spawn",function(Name,Number)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] or not VehicleExist(Name) then
		return false
	end
	Name = string.lower(Name)

	Active[Passport] = true

	local Coin = "Diamantes"
	local Class = VehicleClass(Name)
	local Price = VehiclePrice(Name)
	local Gemstone = VehicleGemstone(Name)
	local Vehicle = vRP.SelectVehicle(Passport,Name)

	local function CancelProcess(Message)
		TriggerClientEvent("Notify",source,"Aviso",Message,"amarelo",5000)
		Active[Passport] = nil
		return false
	end

	if not Vehicle and Class ~= "Races" then
		if Gemstone > 0 then
			TriggerClientEvent("garages:Close",source)

			if Garages[Number] and Garages[Number].Platinum then
				Coin = "Platinas"
			end

			local Discount = 1.0
			if Coin == "Diamantes" then
				for Permission,Multiplier in pairs({ Diamante = 0.70, Platina = 0.85, Ouro = 0.95 }) do
					if vRP.HasService(Passport,Permission) then
						Discount = math.min(Discount,Multiplier)
					end
				end
			end

			local PaymentValue = (Coin == "Diamantes") and (Gemstone * Discount) or Gemstone
			if vRP.Request(source,"Garagem",("Pagar o aluguel do veículo <b>%s</b> por <b>%s</b> %s?"):format(VehicleName(Name),PaymentValue,Coin)) then
				if (Coin == "Diamantes" and not vRP.PaymentGems(Passport,PaymentValue)) or (Coin == "Platinas" and not vRP.TakeItem(Passport,"platinum",PaymentValue)) then
					return CancelProcess(Coin.." insuficiente.")
				end

				vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, Vehicle = Name, Plate = vRP.GeneratePlate(), Days = 30, Weight = VehicleWeight(Name), Work = 1 })
				exports.discord:Embed("Vehicles","**[PASSAPORTE]:** "..Passport.."\n**[RENOVOU]:** "..Name.."\n**[VALOR]:** "..Dotted(PaymentValue).." "..Coin)
				TriggerClientEvent("Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.","verde",5000)
				Vehicle = vRP.SelectVehicle(Passport,Name)
			else
				return CancelProcess("Processo cancelado.")
			end
		else
			if Price > 0 then
				TriggerClientEvent("garages:Close",source)

				if vRP.Request(source,"Garagem",("Comprar o veículo <b>%s</b> por <b>%s%s</b>?"):format(VehicleName(Name),Currency,Dotted(Price))) then
					if not vRP.PaymentFull(Passport,Price) then
						return CancelProcess("Dinheiro insuficiente.")
					end

					local GeneratePlate = vRP.GeneratePlate()
					vRP.Query("vehicles/addVehicles",{ Passport = Passport, Vehicle = Name, Plate = GeneratePlate, Weight = VehicleWeight(Name), Work = 1 })

					if Class ~= "Bicicletas" then
						vRP.GiveItem(Passport,"vehiclekey-"..GeneratePlate,1,true)
					end

					exports.discord:Embed("Vehicles","**[PASSAPORTE]:** "..Passport.."\n**[COMPROU]:** "..Name.."\n**[VALOR]:** "..Currency..Dotted(Price))
					exports.bank:AddTaxs(Passport,source,"Concessionária",Price,"Compra do veículo "..VehicleName(Name)..".",false)
					Vehicle = vRP.SelectVehicle(Passport,Name)
				else
					return CancelProcess("Processo cancelado.")
				end
			else
				vRP.Query("vehicles/addVehicles",{ Passport = Passport, Vehicle = Name, Plate = vRP.GeneratePlate(), Weight = VehicleWeight(Name), Work = 1 })
				Vehicle = vRP.SelectVehicle(Passport,Name)
			end
		end
	end

	if not Vehicle then
		Active[Passport] = nil
		return false
	end

	local SaveGarage = Vehicle.Save
	if Number ~= SaveGarage then
		if Garages[Number] and Garages[Number].Save then
			return CancelProcess("O veículo não está neste local. Ele se encontra na <b>Garagem "..SaveGarage.."</b>.")
		end
	end

	if Vehicle.Arrest then
		return CancelProcess("O veículo se encontra apreendido.")
	end

	local Plate = Vehicle.Plate

	if Spawn[Plate] then
		if not Signal[Plate] then
			if os.time() >= (Searched[Passport] or 0) then
				Searched[Passport] = os.time() + 60

				if not Respawns[Plate] then
					if DoesEntityExist(Spawn[Plate][3]) and not IsPedAPlayer(Spawn[Plate][3]) and GetEntityType(Spawn[Plate][3]) == 2 then
						vCLIENT.SearchBlip(source,GetEntityCoords(Spawn[Plate][3]))
						TriggerClientEvent("Notify",source,"Atenção","Rastreador ativado por <b>30</b> segundos. A localização pode ser imprecisa se estiver em movimento.","policia",10000)
					else
						Spawn[Plate] = nil
						TriggerClientEvent("Notify",source,"Sucesso","Seguradora resgatou seu veículo. Já está disponível para retirada.","policia",5000)
					end
				else
					vCLIENT.SearchBlip(source,Respawns[Plate].xyz)
					TriggerClientEvent("Notify",source,"Atenção","Rastreador ativado por <b>30</b> segundos. A localização pode ser imprecisa se estiver em movimento.","policia",10000)
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Rastreador pode ser ativado a cada <b>60</b> segundos.","policia",5000)
			end
		else
			TriggerClientEvent("Notify",source,"Aviso","Rastreador está desativado.","policia",5000)
		end
	else
		if Gemstone > 0 and Vehicle.Rental ~= 0 and Vehicle.Rental <= os.time() then
			TriggerClientEvent("garages:Close",source)

			if Class == "Races" or (Garages[Number] and Garages[Number].Platinum) then
				Coin = "Platinas"
			end

			local Discount = 1.0
			if Coin == "Diamantes" then
				for Permission,Multiplier in pairs({ Diamante = 0.70, Platina = 0.85, Ouro = 0.95 }) do
					if vRP.HasService(Passport,Permission) then
						Discount = math.min(Discount,Multiplier)
					end
				end
			end

			local PaymentValue = (Coin == "Diamantes") and (Gemstone * Discount) or Gemstone
			if vRP.Request(source,"Garagem",("Pagar aluguel do veículo <b>%s</b> por <b>%s %s</b>?"):format(VehicleName(Name),Dotted(PaymentValue),Coin)) then
				if (Coin == "Diamantes" and vRP.PaymentGems(Passport,PaymentValue)) or (Coin == "Platinas" and vRP.TakeItem(Passport,"platinum",PaymentValue)) then
					vRP.Update("vehicles/rentalVehiclesUpdate",{ Passport = Passport, Vehicle = Name, Days = 30 })
					TriggerClientEvent("Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.","verde",5000)
					exports.discord:Embed("Vehicles","**[PASSAPORTE]:** "..Passport.."\n**[RENOVOU]:** "..Model.."\n**[VALOR]:** "..Dotted(PaymentValue).." "..Coin)
				else
					return CancelProcess(Coin.." insuficiente.")
				end
			else
				return CancelProcess("Processo cancelado.")
			end
		end

		if Vehicle.Tax <= os.time() then
			TriggerClientEvent("garages:Close",source)

			if vRP.Request(source,"Garagem",("Pagar a taxa do veículo <b>%s</b> por <b>%s%s</b>?"):format(VehicleName(Name),Currency,Dotted(Price * 0.15))) then
				if not vRP.PaymentFull(Passport,Price * 0.15) then
					return CancelProcess("Dinheiro insuficiente.")
				end

				vRP.Update("vehicles/updateVehiclesTax",{ Passport = Passport, Vehicle = Name })
				TriggerClientEvent("Notify",source,"Sucesso","Pagamento concluído.","verde",5000)
			else
				return CancelProcess("Processo cancelado.")
			end
		end

		local Coords = vCLIENT.SpawnPosition(source,Number)
		if Coords then
			local Key = "LsCustoms:"..Vehicle.id..":"..Vehicle.Vehicle
			local Mods = vRP.GetSrvData(Key,true)
			local Exist,Network,Entitys = Creative.ServerVehicle(Name,Coords,Plate,Vehicle.Nitro,Vehicle.Doors,Vehicle.Body,Vehicle.Fuel,Vehicle.Seatbelt,Vehicle.Drift)
			if Exist then
				for Passport,OtherSource in pairs(vRPC.Players(source)) do
					async(function()
						vCLIENT.CreateVehicle(OtherSource,Name,Network,Vehicle.Engine,Vehicle.Health,Mods,Vehicle.Windows,Vehicle.Tyres,Vehicle.Brakes,Vehicle.Dirt)
					end)
				end

				Entity(Entitys).state:set("Lockpick",Passport,true)
				Spawn[Plate] = { Passport,Name,Entitys }

				if Vehicle.Keys == 1 then
					vRP.GiveItem(Passport,"vehiclekey-"..Plate,1,true)
					vRP.Query("vehicles/updateVehiclesKeys",{ Passport = Passport, Vehicle = Name, Keys = 0 })
				end
			end
		end
	end

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,Message)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin") or not Message[1] then
		return false
	end

	local Model = Message[1]
	local Ped = GetPlayerPed(source)
	local Coords = GetEntityCoords(Ped)
	local Heading = GetEntityHeading(Ped)
	local Plate = "VEH"..(10000 + Passport)

	local Exist,Network,Vehicle = Creative.ServerVehicle(Model,vec4(Coords.x,Coords.y,Coords.z,Heading),Plate,2000,nil,1000,50,true,false,true)
	if not Exist then
		return false
	end

	for Passport,OtherSource in pairs(vRPC.Players(source)) do
		async(function()
			vCLIENT.CreateVehicle(OtherSource,Model,Network,1000,1000,nil,false,false,{ 1.25,0.75,0.95 },0.0)
		end)
	end

	if not vRP.PassportHasVehicleKey(Passport,Plate) then
		vRP.GiveItem(Passport,"vehiclekey-"..Plate,1,true)
	end

	Entity(Vehicle).state:set("Lockpick",Plate,true)
	Spawn[Plate] = { Passport,Model,Vehicle }
	TaskWarpPedIntoVehicle(Ped,Vehicle,-1)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin") then
		return false
	end

	TriggerClientEvent("garages:Delete",source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:KEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Key")
AddEventHandler("garages:Key",function(EntityData)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not vRP.HasService(Passport,"Mechanic") then
		TriggerClientEvent("Notify",source,"Aviso","Você não possui permissões necessárias.","vermelho",5000)
		return false
	end

	local Plate = EntityData[1]
	local Network = EntityData[4]
	local Entitys = NetworkGetEntityFromNetworkId(Network)
	if not DoesEntityExist(Entitys) then
		return false
	end

	if vRP.Request(source,"Garagem","Você realmente deseja criar <b>1x "..ItemName("vehiclekey").."</b> no emplacamento <b>"..Plate.."</b>?") then
		vRP.GiveItem(Passport,"vehiclekey-"..Plate,1,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Entitys = NetworkGetEntityFromNetworkId(Network)
	if not DoesEntityExist(Entitys) then
		return false
	end

	if not Plate then
		return false
	end

	TriggerEvent("garages:LockVehicle",source,Network)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle",function(source,Network)
	local Vehicle = NetworkGetEntityFromNetworkId(Network)
	if not DoesEntityExist(Vehicle) then
		return false
	end

	local Coords = GetEntityCoords(Vehicle)

	local DoorStatus = tonumber(GetVehicleDoorLockStatus(Vehicle)) or 0

	if DoorStatus <= 1 then
		TriggerClientEvent("Notify",source,"Atenção","O veículo foi <b>Trancado</b>.","amarelo",5000,false,false,false,true)
		TriggerClientEvent("sounds:playSoundDistance",-1,"garages-locked","locked",0.7,false,Coords,5.0)
		SetVehicleDoorsLocked(Vehicle,2)
	else
		TriggerClientEvent("Notify",source,"Sucesso","O veículo foi <b>Destrancado</b>.","verde",5000,false,false,false,true)
		TriggerClientEvent("sounds:playSoundDistance",-1,"garages-unlocked","unlocked",0.7,false,Coords,5.0)
		SetVehicleDoorsLocked(Vehicle,1)
	end

	if not vRP.InsideVehicle(source) then
		vRPC.playAnim(source,true,{"anim@mp_player_intmenu@key_fob@","fob_click_fp"},false)
		Wait(350)
		vRPC.stopAnim(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Delete(Network,Doors,Tyres,Brakes,Plate,Save)
	local source = source
	local Networked = NetworkGetEntityFromNetworkId(Network)
	if not DoesEntityExist(Networked) or IsPedAPlayer(Networked) or GetEntityType(Networked) ~= 2 or GetVehicleNumberPlateText(Networked) ~= Plate then
		return false
	end

	if Spawn[Plate] then
		local Name = Spawn[Plate][2]
		local Passport = Spawn[Plate][1]
		local PlayerPassport = vRP.Passport(source)

		local KeyFound = false
		local Inventory = vRP.Inventory(PlayerPassport)
		for Slot,v in pairs(Inventory) do
			local Split = splitString(v.item,"-")
			if Split[1] == "vehiclekey" and Split[2] == Plate then
				KeyFound = true
				break
			end
		end

		if not KeyFound and VehicleClass(Name) ~= "Bicicletas" then
			TriggerClientEvent("Notify",source,"Aviso","Você não possui a chave do veículo <b>"..VehicleName(Name).."</b> por isso não pode guardar ele.","amarelo",5000)
			return false
		end

		if vRP.SelectVehicle(Passport,Name) then
			local Health = GetEntityHealth(Networked)
			local Dirt = GetVehicleDirtLevel(Networked)
			local Body = GetVehicleBodyHealth(Networked)
			local Engine = GetVehicleEngineHealth(Networked)

			local Windows = {}
			for Number = 0,5 do
				Windows[Number] = IsVehicleWindowIntact(Networked,Number)
			end

			local State = Entity(Networked).state
			local Nitro = State.Nitro or 0
			local Fuel = State.Fuel or 0

			local DoorsJson = json.encode(Doors)
			local WindowsJson = json.encode(Windows)
			local TyresJson = json.encode(Tyres)
			local BrakesJson = json.encode(Brakes)

			local HasKey = 0
			local Inventory = vRP.Inventory(PlayerPassport)
			for Slot,v in pairs(Inventory) do
				local Split = splitString(v.item,"-")
				if Split[1] == "vehiclekey" and Split[2] == Plate then
					if vRP.TakeItem(PlayerPassport,v.item,1,true,Slot) then
						HasKey = 1
						break
					end
				end
			end

			if VehicleMode(Name) ~= "Work" and Save and Garages[Save] and Garages[Save].Name == "Garage" then
				vRP.Update("vehicles/updateVehiclesSave",{ Engine = math.floor(Engine), Body = math.floor(Body), Health = math.floor(Health), Fuel = Fuel, Nitro = Nitro, Doors = DoorsJson, Windows = WindowsJson, Tyres = TyresJson, Brakes = BrakesJson, Dirt = math.floor(Dirt), Save = Save, Passport = Passport, Vehicle = Name, Keys = HasKey })
			else
				vRP.Update("vehicles/updateVehicles",{ Engine = math.floor(Engine), Body = math.floor(Body), Health = math.floor(Health), Fuel = Fuel, Nitro = Nitro, Doors = DoorsJson, Windows = WindowsJson, Tyres = TyresJson, Brakes = BrakesJson, Dirt = math.floor(Dirt), Passport = Passport, Vehicle = Name, Keys = HasKey })
			end
		end
	end

	TriggerEvent("garages:Delete",Network,Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Deleted")
AddEventHandler("garages:Deleted",function(Network,Plate)
	Creative.Delete(Network,{},{},{},Plate)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Delete")
AddEventHandler("garages:Delete",function(Network,Plate)
	if not Network or not Plate then
		return false
	end

	if Signal[Plate] then
		Signal[Plate] = nil
	end

	if Changed[Plate] then
		local Backup = Changed[Plate]
		if Spawn[Backup] then
			Spawn[Backup] = nil
		end

		Changed[Plate] = nil
	end

	if Spawn[Plate] then
		Spawn[Plate] = nil
	end

	local Entitys = NetworkGetEntityFromNetworkId(Network)
	if DoesEntityExist(Entitys) and not IsPedAPlayer(Entitys) and GetEntityType(Entitys) == 2 and GetVehicleNumberPlateText(Entitys) == Plate then
		DeleteEntity(Entitys)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Propertys")
AddEventHandler("garages:Propertys",function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or Active[Passport] then
		return false
	end

	local Consult = vRP.SingleQuery("propertys/Exist",{ Name = Name })
	if not Consult or Consult.Passport ~= Passport then
		return false
	end

	Active[Passport] = true

	TriggerClientEvent("dynamic:Close",source)
	TriggerClientEvent("Notify",source,"Aviso","Selecione o local da garagem.","amarelo",5000)

	local Hash = "prop_offroad_tyres02"
	local Sucess,GarageCoords = vRPC.ObjectControlling(source,Hash)
	if not Sucess then
		Active[Passport] = nil
		return false
	end

	local PropertyCoords = exports.propertys:Coords(Name)
	if #(vec3(GarageCoords[1],GarageCoords[2],GarageCoords[3]) - PropertyCoords) > 25 then
		TriggerClientEvent("Notify",source,"Aviso","A garagem precisa ser próximo da entrada.","amarelo",5000)
		Active[Passport] = nil
		return false
	end

	TriggerClientEvent("Notify",source,"Aviso","Selecione o local do veículo.","amarelo",5000)

	local VehicleHash = "sultanrs"
	local Sucess,VehicleCoords = vRPC.ObjectControlling(source,VehicleHash)
	if not Sucess then
		Active[Passport] = nil
		return false
	end

	if #(vec3(VehicleCoords[1],VehicleCoords[2],VehicleCoords[3]) - PropertyCoords) > 25 then
		TriggerClientEvent("Notify",source,"Aviso","A garagem precisa ser próximo da entrada.","amarelo",5000)
		Active[Passport] = nil
		return false
	end

	local NewGarage = {
		["1"] = { GarageCoords[1],GarageCoords[2],GarageCoords[3] + 1 },
		["2"] = { VehicleCoords[1],VehicleCoords[2],VehicleCoords[3] + 1,VehicleCoords[4] }
	}

	Garages[Name] = { Name = "Garage", Save = true }
	Propertys[Name] = { x = NewGarage["1"][1], y = NewGarage["1"][2], z = NewGarage["1"][3], ["1"] = NewGarage["2"] }

	vRP.Update("propertys/Garage",{ Name = Name, Garage = json.encode(NewGarage) })
	TriggerClientEvent("garages:Propertys",-1,Propertys)

	Active[Passport] = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.Query("propertys/Garages")
	for _,v in ipairs(Consult) do
		local Name = v.Name
		local GarageJson = v.Garage
		if not Propertys[Name] and GarageJson then
			local GarageTable = json.decode(GarageJson)
			if GarageTable and GarageTable["1"] and GarageTable["2"] then
				Garages[Name] = { Name = "Garage", Save = true }
				Propertys[Name] = { x = GarageTable["1"][1], y = GarageTable["1"][2], z = GarageTable["1"][3], ["1"] = GarageTable["2"] }
			end
		end
	end

	local Additional = 1296000
	local CurrentTimer = os.time()
	local Consult = vRP.Query("vehicles/All")
	for _,v in ipairs(Consult) do
		if (v.Tax + Additional) <= CurrentTimer then
			vRP.Query("entitydata/RemoveData",{ Name = "Mods:"..v.Passport..":"..v.Vehicle })
			vRP.Query("vehicles/removeVehicles",{ Passport = v.Passport, Vehicle = v.Vehicle })
			vRP.Query("entitydata/RemoveData",{ Name = "Trunkchest:"..v.Passport..":"..v.Vehicle })

			Wait(100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Impound()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return {}
	end

	local Vehicles = {}
	local Result = vRP.Query("vehicles/UserVehicles",{ Passport = Passport })

	for _,v in ipairs(Result) do
		local Arrest = v.Arrest

		if Arrest == 1 or Arrest == "1" or Arrest == true then
			Vehicles[#Vehicles + 1] = {
				Model = v.Vehicle,
				Name = VehicleName(v.Vehicle),
				Price = VehiclePrice(v.Vehicle) * PercentageArrest
			}
		end
	end

	return Vehicles
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:UNPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Unpound")
AddEventHandler("garages:Unpound", function(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local VehiclePrice = VehiclePrice(Name) * PercentageArrest
		TriggerClientEvent("dynamic:Close",source)

		TriggerClientEvent("animations:Emotes",source,"anotar")

		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true

		if vRP.Request(source,"Reboque","A liberação do veículo <b>"..VehicleName(Name).."</b> tem o custo de <b>"..Currency..""..Dotted(VehiclePrice).." "..ItemName("dollar").."</b>, deseja prosseguir com a liberação do mesmo?") then
			if vRP.PaymentFull(Passport,VehiclePrice) then
				vRP.Query("vehicles/PaymentArrest", { Passport = Passport, Vehicle = Name })
				TriggerClientEvent("Notify",source,"Sucesso","O veículo <b>"..VehicleName(Name).."</b> foi liberado.","verde",5000)
			end
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false

		vRPC.Destroy(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal",function(Plate)
	return Signal[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Spawn",function(Plate)
	return Spawn[Plate]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("garages:Propertys",source,Propertys,Respawns)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)
