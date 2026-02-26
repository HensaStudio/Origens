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
Tunnel.bindInterface("chest",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Open = {}
local Cooldown = {}
local CooldownArmour = {}
local CooldownMedicShop = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local ChestItens = {
	["personalp"] = {
		Slots = 100,
		Weight = 100,
		Block = true
	},
	["personalm"] = {
		Slots = 100,
		Weight = 250,
		Block = true
	},
	["personalg"] = {
		Slots = 100,
		Weight = 500,
		Block = true
	},
	["chestgroupp"] = {
		Slots = 100,
		Weight = 1000,
		Block = true
	},
	["chestgroupm"] = {
		Slots = 100,
		Weight = 2500,
		Block = true
	},
	["chestgroupg"] = {
		Slots = 100,
		Weight = 5000,
		Block = true
	},
	["suitcase"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["dollar"] = true,
			["dirtydollar"] = true,
			["wetdollar"] = true,
			["promissory"] = true
		}
	},
	["ammobox"] = {
		Slots = 25,
		Weight = 12,
		Close = true,
		Itens = {
			["WEAPON_PISTOL_AMMO"] = true,
			["WEAPON_SMG_AMMO"] = true,
			["WEAPON_RIFLE_AMMO"] = true,
			["WEAPON_SHOTGUN_AMMO"] = true,
			["WEAPON_MUSKET_AMMO"] = true
		}
	},
	["weaponbox"] = {
		Slots = 50,
		Weight = 100,
		Close = true,
		Itens = {
			["WEAPON_STUNGUN"] = true,
			["WEAPON_PISTOL"] = true,
			["WEAPON_PISTOL_MK2"] = true,
			["WEAPON_COMPACTRIFLE"] = true,
			["WEAPON_APPISTOL"] = true,
			["WEAPON_HEAVYPISTOL"] = true,
			["WEAPON_MACHINEPISTOL"] = true,
			["WEAPON_MICROSMG"] = true,
			["WEAPON_RPG"] = true,
			["WEAPON_MINISMG"] = true,
			["WEAPON_SNSPISTOL"] = true,
			["WEAPON_SNSPISTOL_MK2"] = true,
			["WEAPON_VINTAGEPISTOL"] = true,
			["WEAPON_PISTOL50"] = true,
			["WEAPON_COMBATPISTOL"] = true,
			["WEAPON_CARBINERIFLE"] = true,
			["WEAPON_CARBINERIFLE_MK2"] = true,
			["WEAPON_ADVANCEDRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE"] = true,
			["WEAPON_BULLPUPRIFLE_MK2"] = true,
			["WEAPON_SPECIALCARBINE"] = true,
			["WEAPON_SPECIALCARBINE_MK2"] = true,
			["WEAPON_PUMPSHOTGUN"] = true,
			["WEAPON_PUMPSHOTGUN_MK2"] = true,
			["WEAPON_MUSKET"] = true,
			["WEAPON_SAWNOFFSHOTGUN"] = true,
			["WEAPON_SMG"] = true,
			["WEAPON_SMG_MK2"] = true,
			["WEAPON_TACTICALRIFLE"] = true,
			["WEAPON_HEAVYRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE"] = true,
			["WEAPON_ASSAULTRIFLE_MK2"] = true,
			["WEAPON_ASSAULTSMG"] = true,
			["WEAPON_GUSENBERG"] = true
		}
	},
	["medicbag"] = {
		Slots = 25,
		Weight = 10,
		Close = true,
		Itens = {
			["bandage"] = true,
			["gauze"] = true,
			["gdtkit"] = true,
			["medkit"] = true,
			["sinkalmy"] = true,
			["analgesic"] = true,
			["ritmoneury"] = true,
			["adrenaline"] = true
		}
	},
	["treasurebox"] = {
		Slots = 25,
		Weight = 50,
		Close = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permissions(Name,Mode,Item)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport then
		return false
	end

	if Mode == "Personal" then
		local ServiceName = SplitOne(Name)
		if vRP.HasService(Passport,ServiceName) then
			Open[Passport] = {
				Name = "Personal:"..Passport,
				Weight = 50,
				Save = true,
				Slots = 25
			}

			return true
		else
			TriggerClientEvent("Notify",source,"Atenção","Você não possui permissão para acessar este compartimento pessoal.","amarelo",10000)
			return false
		end
	elseif Mode == "Tray" then
		local isRecycle = (Name == "Recycle")

		Open[Passport] = {
			Slots = 25,
			Name = Name,
			Save = true,
			Recycle = isRecycle,
			Weight = isRecycle and 100 or 25
		}

		return true
	elseif Mode == "Custom" or Mode == "Trash" then
		if SplitBoolean(Name,"Helicrash",":") and Cooldown[Name] and Cooldown[Name] > os.time() then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde até que esfrie o compartimento.","amarelo",10000)
			vRPC.DowngradeHealth(source,10)

			return false
		end

		Open[Passport] = {
			Name = (Mode == "Trash" and "Trash:"..Name or Name),
			Weight = 50,
			Slots = 25,
			Mode = "Custom"
		}

		return true
	elseif Mode == "Item" then
		local Split = splitString(Name,":")
		if vRP.ConsultItem(Passport,Split[1].."-"..Split[2]) then
			local UniqueName = SplitOne(Name,":")
			if ChestItens[UniqueName] then
				Open[Passport] = {
					Name = Name,
					Save = true,
					Unique = UniqueName,
					Slots = ChestItens[UniqueName].Slots,
					Weight = ChestItens[UniqueName].Weight,
					Item = Item
				}

				return true
			else
				TriggerClientEvent("Notify",source,"Atenção","Você não possui permissão para acessar este baú.","amarelo",10000)
				return false
			end
		else
			TriggerClientEvent("Notify",source,"Atenção","Você não possui o item necessário para acessar este baú.","amarelo",10000)
			return false
		end
	else
		local Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		if not Consult then
			vRP.Query("chests/AddChests",{ Name = Name })
			Consult = vRP.SingleQuery("chests/GetChests",{ Name = Name })
		end

		if Consult then
			if vRP.HasService(Passport,Consult.Permission) then
				local IsPremium = vRP.Permissions(Consult.Permission, "Premium") > os.time()

				Open[Passport] = {
					Weight = IsPremium and Consult.Weight * 2 or Consult.Weight,
					Chest = Name,
					Slots = Consult.Slots,
					Name = "Chest:"..Name,
					Logs = Consult.Logs,
					Permission = Consult.Permission,
					Save = true
				}

				return true
			else
				TriggerClientEvent("Notify",source,"Atenção","Você não possui permissão para acessar este baú.","amarelo",10000)
				return false
			end
		else
			TriggerClientEvent("Notify",source,"Atenção","Erro ao acessar o baú. Tente novamente.","amarelo",10000)
			return false
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Mount()
	local source = source
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport]) then
		return false
	end

	local function ProcessItem(Slot,v,Prefix,Key,Save)
		if v.amount <= 0 or not ItemExist(v.item) then
			if Prefix == "Inventory" then
				vRP.CleanSlot(Passport,Slot)
			elseif Prefix == "Chest" then
				vRP.CleanSlotChest(Key,Slot,Save)
			end

			return false
		end

		v.key = v.item

		local Split = splitString(v.item)
		local Item = Split[1]

		if Prefix == "Inventory" and ChestItens[Item] and ChestItens[Item].Close then
			v.block = true
		end

		if not v.desc then
			if Item == "vehiclekey" and Split[2] then
				local Consult = exports.oxmysql:single_async("SELECT * FROM vehicles WHERE Plate = ? LIMIT 1",{ Split[3] })
				if Consult and VehicleExist(Consult.Vehicle) then
					v.desc = "Proprietário: <common>"..vRP.FullName(Consult.Passport).."</common><br>Modelo: <common>"..VehicleName(Consult.Vehicle).."</common><br>Placa: <common>"..Split[3].."</common>"
				else
					v.desc = "Proprietário: <epic>Prefeitura</epic><br>Placa: <common>"..Split[3].."</common>"
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

		return v
	end

	local Primary = {}
	local Inventory = vRP.Inventory(Passport)
	for Slot,v in pairs(Inventory) do
		local Processed = ProcessItem(Slot,v,"Inventory")
		if Processed then
			Primary[Slot] = Processed
		end
	end

	local Secondary = {}
	if Open[Passport] and Open[Passport].Name then
		local ChestData = Open[Passport].Name
		local Chest = vRP.GetSrvData(ChestData,Open[Passport].Save)
		for Slot,v in pairs(Chest) do
			local Processed = ProcessItem(Slot,v,"Chest",ChestData,Open[Passport].Save)
			if Processed then
				Secondary[Slot] = Processed
			end
		end
	end

	return Primary,Secondary,vRP.GetWeight(Passport),Open[Passport].Weight,Open[Passport].Slots
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Inactived)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not (Passport and Open[Passport] and not Inactived) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	if Open[Passport].Recycle then
		local Recycled = ItemRecycle(Item)
		if Recycled and vRP.TakeItem(Passport,Item,Amount) then
			for Index,Number in pairs(Recycled) do
				vRP.GenerateItem(Passport,Index,Number * Amount)
			end

			TriggerClientEvent("inventory:Update",source)
		else
			TriggerClientEvent("inventory:Notify",source,"Atenção",ItemName(Item).." não pode ser reciclado.","amarelo")
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if Item == "diagram" and Open[Passport].Chest and vRP.TakeItem(Passport,Item,Amount) then
		vRP.Update("chests/UpdateWeight",{ Name = Open[Passport].Chest, Multiplier = Amount })
		TriggerClientEvent("inventory:Notify",source,"Sucesso","Armazenamento melhorado.","verde")
		Open[Passport].Weight = Open[Passport].Weight + (10 * Amount)
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local CleanedItem = SplitOne(Item)
	local Unique = Open[Passport].Unique
	if (ChestItens[CleanedItem] and ChestItens[CleanedItem].Block) or (Unique and ChestItens[Unique] and ChestItens[Unique].Itens and not ChestItens[Unique].Itens[CleanedItem]) then
		if Unique and CleanedItem == Unique then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory", Right = "Proximidade" },true)
		else
			TriggerClientEvent("inventory:Update",source)
		end

		return false
	end

	if vRP.StoreChest(Passport,Open[Passport].Name,Amount,Open[Passport].Weight,Slot,Target,Open[Passport].Save,ChestItens[Unique]) then
		TriggerClientEvent("inventory:Update",source)

		return false
	elseif Open[Passport].Logs then
		exports.discord:Embed(Open[Passport].Chest, "**[PASSAPORTE]:** " .. Passport .. "\n**[GUARDOU]:** " .. Amount .. "x " .. ItemName(Item) .. "\n**[DATA & HORA]:** " .. os.date("%d/%m/%Y") .. " às " .. os.date("%H:%M"))
    end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.TakeChest(Passport,Name,Amount,Slot,Target,Saved) then
		TriggerClientEvent("inventory:Update",source)

		return false
	end

	local Data = vRP.GetSrvData(Name,Saved)    
	if (Open[Passport].Mode or Open[Passport].Item) and json.encode(Data) == "[]" then
		if Open[Passport].Item and vRP.TakeItem(Passport,Open[Passport].Item) then
			TriggerClientEvent("inventory:Open",source,{ Type = "Inventory", Resource = "inventory", Right = "Baú" },true)
		end

		if SplitBoolean(Name,"Helicrash",":") then
			GlobalState.Helibox = (GlobalState.Helibox or 1) - 1

			if GlobalState.Helibox <= 0 then
				GlobalState.Helicrash = false
			end
		end
	end

	if Open[Passport].Logs then
		exports.discord:Embed(Open[Passport].Chest, "**[PASSAPORTE]:** " .. Passport .. "\n**[RETIROU]:** " .. Amount .. "x " .. ItemName(Item) .. "\n**[DATA & HORA]:** " .. os.date("%d/%m/%Y") .. " às " .. os.date("%H:%M"))
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount,true)
	local Passport = vRP.Passport(source)

	if not Passport or not Open[Passport] then
		return false
	end

	local Name = Open[Passport].Name
	local Saved = Open[Passport].Save
	if vRP.UpdateChest(Passport,Name,Slot,Target,Amount,Saved) then
		TriggerClientEvent("inventory:Update",source)
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Cooldown",function(Name)
	Cooldown[Name] = os.time() + 600
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ARMOUR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:Armour")
AddEventHandler("chest:Armour",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Police") then
		if CooldownArmour[Passport] and os.time() <= CooldownArmour[Passport] then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(CooldownArmour[Passport] - os.time())..".","amarelo",5000)
			return false
		end

		if vRP.Request(source,"Delegacia","Você só pode pegar <b>1x Colete</b> a cada <b>30 Minutos</b>, deseja continuar?") then
			vRP.Armour(source,100)

			CooldownArmour[Passport] = os.time() + 1800
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:MEDICSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chest:MedicShop")
AddEventHandler("chest:MedicShop",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Paramedic") then
		if CooldownMedicShop[Passport] and os.time() <= CooldownMedicShop[Passport] then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(CooldownMedicShop[Passport] - os.time())..".","amarelo",5000)
			return false
		end

		if vRP.Request(source,"Hospital","Você só pode pegar <b>1x "..ItemName("medicshop").."</b> a cada <b>30 Minutos</b>, deseja continuar?") then
			vRP.GiveItem(Passport,"medicshop-"..os.time().."-"..Passport,1,true)
			CooldownMedicShop[Passport] = os.time() + 1800
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Open[Passport] then
		Open[Passport] = nil
	end
end)