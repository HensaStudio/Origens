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
Tunnel.bindInterface("pdm",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local VehiclekeyPrice = ItemEconomy("vehiclekey")
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Open()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports.bank:CheckTaxs(Passport) and not exports.bank:CheckFines(Passport) then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Buy(Model)
	local Return = false
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] and Model and VehicleExist(Model) then
		Active[Passport] = true

		if vRP.SelectVehicle(Passport,Model) then
			TriggerClientEvent("Notify",source,"Aviso","Já possui um <b>"..VehicleName(Model).."</b>.","amarelo",5000)
		else
			local VehicleStock = VehicleStock(Model)
			if VehicleStock and vRP.Scalar("vehicles/Count",{ Vehicle = Model }) >= VehicleStock then
				TriggerClientEvent("Notify",source,"Aviso","Estoque insuficiente.","amarelo",5000)
			else
				if VehicleMode(Model) == "Rental" then
					local Discount = 1.0
					local VehicleGemstone = VehicleGemstone(Model)
					for Permission,Multiplier in pairs({ Ouro = 0.70, Prata = 0.80, Bronze = 0.90 }) do
						if vRP.HasService(Passport,Permission) then
							Discount = math.min(Discount,Multiplier)
						end
					end

					local PaymentValue = VehicleGemstone * Discount
					if PaymentValue > 0 and vRP.PaymentGems(Passport,PaymentValue) then
						local GeneratePlate = vRP.GeneratePlate()

						vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, Vehicle = Model, Plate = GeneratePlate, Days = 30, Weight = VehicleWeight(Model), Work = 0, Save = 154 })
						vRP.GiveItem(Passport,"vehiclekey-"..GeneratePlate,1,true)
						exports.discord:Embed("Pdm","**[PASSAPORTE]:** "..Passport.."\n**[COMPROU]:** "..Model.."\n**[VALOR]:** "..Dotted(PaymentValue).." Diamantes.")
						TriggerClientEvent("Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Model).."</b> concluído.<br>O veículo foi para a <b>Garagem Concessionária</b>.","verde",10000)
						Return = true
					else
						TriggerClientEvent("Notify",source,"Aviso","Diamante insuficiente.","amarelo",5000)
					end
				elseif VehicleClass(Model) ~= "Races" then
					local VehiclePrice = VehiclePrice(Model)
					if VehiclePrice and vRP.PaymentFull(Passport,VehiclePrice) then
						local GeneratePlate = vRP.GeneratePlate()

						vRP.Query("vehicles/addVehicles",{ Passport = Passport, Vehicle = Model, Plate = GeneratePlate, Weight = VehicleWeight(Model), Work = 0, Save = 154 })

						if VehicleClass(Model) ~= "Bicicletas" then
							vRP.GiveItem(Passport,"vehiclekey-"..GeneratePlate,1,true)
						end

						exports.discord:Embed("Pdm","**[PASSAPORTE]:** "..Passport.."\n**[COMPROU]:** "..Model.."\n**[VALOR]:** "..Currency..Dotted(VehiclePrice))
						exports.bank:AddTaxs(Passport,source,"Concessionária",VehiclePrice,"Compra do veículo "..VehicleName(Model)..".",false)
						TriggerClientEvent("Notify",source,"Sucesso","Compra concluída.<br>O veículo foi para a <b>Garagem Concessionária</b>.","verde",10000)
						Return = true
					else
						TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
					end
				end
			end
		end

		Active[Passport] = nil
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Check()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerEvent("DebugWeapons",Passport)
		TriggerEvent("animals:Delete",Passport,source)
		exports.vrp:Bucket(source,"Enter",100000 + Passport)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Discount()
	local Normal = 1.0
	local Platinas = 1.0
	local Importados = 1.0

	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		for Permission,Multiplier in pairs({ Ouro = 0.70, Prata = 0.80, Bronze = 0.90 }) do
			if vRP.HasService(Passport,Permission) then
				Importados = math.min(Importados,Multiplier)
			end
		end
	end

	return { Default = Normal, Importados = Importados, Platinas = Platinas }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Remove()
	local source = source

	exports.vrp:Bucket(source,"Exit")
	TriggerEvent("vRP:ReloadWeapons",source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = vRP.Query("vehicles/UserVehicles", { Passport = Passport })

		for Number, v in ipairs(Vehicle) do
			Vehicles[#Vehicles + 1] = {
				["Plate"] = Vehicle[Number]["Plate"],
				["Model"] = Vehicle[Number]["Vehicle"],
				["Name"] = VehicleName(Vehicle[Number]["Vehicle"]) or "Veículo sem nome"
			}
		end

		return Vehicles
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PDM:MAKEVEHICLEKEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("pdm:MakeVehiclekey")
AddEventHandler("pdm:MakeVehiclekey", function(Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:Close",source)

		if vRP.Request(Passport,"Concessionária","A <b>"..ItemName("vehiclekey").."</b> tem o custo de <b>"..Currency..""..Dotted(VehiclekeyPrice).."</b> dólares, deseja prosseguir com a criação da mesma?") then
			if vRP.PaymentFull(Passport,VehiclekeyPrice) then
				vRP.GiveItem(Passport,"vehiclekey-"..Plate,1,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)