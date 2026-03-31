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
Tunnel.bindInterface("shops",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
	local source = source
	local Passport = vRP.Passport(source)

	if Passport and List[Name] and not exports.bank:CheckTaxes(Passport) and not exports.bank:CheckFines(Passport) then
		if Name == "HuntingBuy" and not vRP.DatatableInformation(Passport,"Firearms") then
			TriggerClientEvent("Notify",source,"Aviso","Você precisa possuir <b>Porte de Armas</b>.","vermelho",5000)
			return false
		end

		if Name == "Laundromat" and not vRP.ConsultItem(Passport,"laundromataccess",1) then
			TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("laundromataccess").."</b>.","amarelo",5000)
			return false
		end

		if not List[Name]["Permission"] or (List[Name]["Permission"] and vRP.HasService(Passport,List[Name]["Permission"])) then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Name and List[Name] then
		local Primary = {}
		local Inv = vRP.Inventory(Passport)
		for Slot,v in pairs(Inv) do
			if v.amount <= 0 or not ItemExist(v.item) then
				vRP.CleanSlot(Passport,Slot)
			else
				v.key = v.item

				local Split = splitString(v.item)
				local Item = Split[1]

				if not v.desc then
					if Item == "vehiclekey" and Split[2] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM vehicles WHERE Plate = ? LIMIT 1",{ Split[2] })
						if Consult and VehicleExist(Consult.Vehicle) then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common><br>Modelo: <common>"..VehicleName(Consult.Vehicle).."</common><br>Placa: <common>"..Split[2].."</common>"
						else
							v.desc = "Proprietário: <epic>Prefeitura</epic><br>Placa: <common>"..Split[2].."</common>"
						end
					elseif Item == "propertys" and Split[2] then
						local Consult = exports.oxmysql:single_async("SELECT * FROM propertys WHERE Serial = ? LIMIT 1",{ Split[2] })
						if Consult then
							v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common>"
						end
					elseif Item == "prescription" and Split[3] then
						v.desc = "Proprietário: <common>"..vRP.FullName(Split[4]).."</common><br>Medicamento: <rare>"..ItemName(Split[3]).."</rare>"
					elseif ItemNamed(Item) and Split[2] and vRP.Identity(Split[2]) then
						if Item == "identity" then
							v.desc = "Passaporte: <rare>"..Dotted(Split[2]).."</rare><br>Nome: <rare>"..vRP.FullName(Split[2]).."</rare>"
						else
							v.desc = "Proprietário: <common>"..vRP.FullName(Split[2]).."</common>"
						end
					end
				end

				if Split[2] then
					local Loaded = ItemLoads(v.item)
					if Loaded then
						v.charges = parseInt(Split[2] * (100 / Loaded))
					end

					if ItemDurability(v.item) then
						v.durability = parseInt(os.time() - Split[2])
						v.days = ItemDurability(v.item)
					end
				end

				Primary[Slot] = v
			end
		end

		return Primary,vRP.GetWeight(Passport)
	end
end
---------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Amount,Target,Name)
	local source = source
	local Target = tostring(Target)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and Item and Target and List[Name] and List[Name]["Type"] and List[Name]["List"] and List[Name]["List"][Item] then
		if Amount <= 0 then
			return false
		end

		if Amount > 1 and (ItemUnique(Item) or ItemLoads(Item)) then
			Amount = 1
		end

		local Inventory = vRP.Inventory(Passport)

		if vRP.MaxItens(Passport,Item,Amount) then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Quantidade máxima atingida para este item.","amarelo")
			return false
		end

		if not vRP.CheckWeight(Passport,Item,Amount) then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Espaço insuficiente na mochila.","amarelo")
			return false
		end

		if Inventory[Target] and Inventory[Target]["item"] ~= Item then
			TriggerClientEvent("inventory:Notify",source,"Aviso","Slot já está ocupado por outro item.","amarelo")
			return false
		end

		if List[Name]["Type"] == "Cash" then
			if ItemMedical(Item) then
				local Prescription = vRP.HasPrescription(Passport,Item) or vRP.HasService(Passport,"Paramedic")
				if not Prescription then
					TriggerClientEvent("inventory:Notify",source,"Aviso","Você precisa de uma receita para comprar este medicamento.","amarelo")
					return false
				end
			end

			if vRP.PaymentFull(Passport,List[Name]["List"][Item] * Amount) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)

				if ItemMedical(Item) then
					local Prescription = vRP.HasPrescription(Passport,Item)
					if Prescription then
						vRP.TakeItem(Passport,Prescription.Item,1,true,Prescription.Slot)
					end
				end

				if Item == "WEAPON_PETROLCAN" then
					vRP.GenerateItem(Passport,"WEAPON_PETROLCAN_AMMO",4500)
				end
			else
				TriggerClientEvent("inventory:Notify",source,"Aviso","Dinheiro insuficiente.","amarelo")
				return false
			end
		elseif List[Name]["Type"] == "Illegal" then

			local Price = List[Name]["List"][Item] * Amount

			if vRP.TakeItem(Passport,"dirtydollar",Price,true) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)
			else
				TriggerClientEvent("inventory:Notify",source,"Aviso","Dinheiro Sujo insuficiente.","amarelo")
				return false
			end
		elseif List[Name]["Type"] == "Consume" and List[Name]["Item"] then
			local Required = List[Name]["List"][Item] * Amount

			if vRP.TakeItem(Passport,List[Name]["Item"],Required) then
				vRP.GenerateItem(Passport,Item,Amount,false,Target)
			else
				TriggerClientEvent("inventory:Notify",source,"Atenção","<b>"..ItemName(List[Name]["Item"]).."</b> insuficiente.","vermelho")
				return false
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end
---------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Amount,Slot,Name)
	local source = source
	local Split = SplitOne(Item)
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)
	if Passport and List[Name] and List[Name]["List"] and List[Name]["Type"] and List[Name]["List"][Split] and not vRP.CheckDamaged(Item) then
		if List[Name]["Type"] == "Cash" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,"dollar",List[Name]["List"][Split] * Amount,false)
			end
		elseif List[Name]["Type"] == "Consume" then
			if vRP.TakeItem(Passport,Item,Amount,false,Slot) then
				vRP.GenerateItem(Passport,List[Name]["Item"],List[Name]["List"][Split] * Amount,false)
			end
		end
	end

	TriggerClientEvent("inventory:Update",source)
end