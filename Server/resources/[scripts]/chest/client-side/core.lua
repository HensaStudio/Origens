-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("chest")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Block = false
local Opened = false
local Animation = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Chests = {
	{ Name = "LSPD", Coords = vec3(485.05,-999.46,30.48), Mode = "1" },
	{ Name = "PRPD", Coords = vec3(385.47,800.39,189.80), Mode = "1" },
	{ Name = "Paramedic", Coords = vec3(306.64,-602.17,43.26), Mode = "2" },
	{ Name = "Mechanic", Coords = vec3(951.95,-963.41,39.05), Mode = "3" },
	{ Name = "BurgerShot", Coords = vec3(-1184.08,-900.96,14.02), Mode = "3" },
	{ Name = "BurgerShotTray-1", Coords = vec3(-1188.46,-894.29,13.95), Mode = "4" },
	{ Name = "BurgerShotTray-2", Coords = vec3(-1189.54,-894.99,13.95), Mode = "4" },
	{ Name = "BurgerShotTray-3", Coords = vec3(-1191.13,-896.08,13.95), Mode = "4" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Labels = {
	["1"] = {
		{
			event = "chest:Open",
			label = "Compartimento Geral",
			tunnel = "client",
			service = "Normal"
		},{
			event = "chest:Open",
			label = "Compartimento Pessoal",
			tunnel = "client",
			service = "Personal"
		},{
			event = "chest:Armour",
			label = "Colete Balístico",
			tunnel = "server"
		}
	},
	["2"] = {
		{
			event = "chest:MedicShop",
			label = "Loja Portátil",
			tunnel = "server"
		},{
			event = "chest:Open",
			label = "Compartimento Geral",
			tunnel = "client",
			service = "Normal"
		},{
			event = "chest:Open",
			label = "Compartimento Pessoal",
			tunnel = "client",
			service = "Personal"
		}
	},
	["3"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "client",
			service = "Normal"
		}
	},
	["4"] = {
		{
			event = "chest:Open",
			label = "Abrir",
			tunnel = "client",
			service = "Tray"
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Name,v in pairs(Chests) do
		exports.target:AddCircleZone("Chest:"..Name,v.Coords,0.25,{
			name = "Chest:"..Name,
			heading = 0.0,
			useZ = true
		},{
			Distance = 1.25,
			shop = v.Name,
			options = Labels[v.Mode]
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chest:Open")
AddEventHandler("chest:Open",function(Name,Mode,Item,Blocked,Force)
	if vSERVER.Permissions(Name,Mode,Item) and GetEntityHealth(PlayerPedId()) > 100 then
		if Blocked or SplitBoolean(Name,"Helicrash",":") then
			Block = true
		end

		Opened = Name

		if Mode ~= "Item" then
			Animation = true
			vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
		end

		TriggerEvent("inventory:Open",{
			Type = "Chest",
			Resource = "chest",
			Force = Force,
			Right = "Baú"
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Item",function(Name)
	local FullName = splitString(Name)
	if vSERVER.Permissions(FullName[1]..":"..FullName[3],"Item") and GetEntityHealth(PlayerPedId()) > 100 then
		Opened = true
		TriggerEvent("inventory:Open",{ Type = "Chest", Resource = "chest", Right = "Baú" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST:RECYCLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("chest:Recycle",function()
	if vSERVER.Permissions("Recycle","Tray") and GetEntityHealth(PlayerPedId()) > 100 then
		Opened = true
		TriggerEvent("inventory:Open",{ Type = "Chest", Resource = "chest", Right = "Baú" })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function(Force)
	if (not Force and Opened) or (Force and Opened and Opened == Force) then
		if Animation then
			Animation = false
			vRP.Destroy()
		end

		Opened = false
		Block = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:Closed",function(Name)
	if Opened and Opened == Name then
		if Animation then
			Animation = false
			vRP.Destroy()
		end

		Block = false
		Opened = false
		TriggerEvent("inventory:Close")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	Callback(vSERVER.Take(Data.item,Data.slot,Data.amount,Data.target))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	Callback(vSERVER.Store(Data.item,Data.slot,Data.amount,Data.target,Block))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	Callback(vSERVER.Update(Data.slot,Data.target,Data.amount))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,Secondary,PrimaryWeight,SecondaryWeight,Slots = vSERVER.Mount()
	if Primary then
		Callback({ Primary = Primary, Secondary = Secondary, PrimaryMaxWeight = PrimaryWeight, SecondaryMaxWeight = SecondaryWeight, SecondarySlots = math.max(CountTable(Secondary),Slots) })
	end
end)