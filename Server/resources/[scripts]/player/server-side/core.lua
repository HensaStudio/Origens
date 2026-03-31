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
vCLIENT = Tunnel.getInterface("player")
vSKINSHOP = Tunnel.getInterface("skinshop")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CallCooldown = {}
local CooldownTime = 300
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICES
-----------------------------------------------------------------------------------------------------------------------------------------
local Services = {
	["Prefeitura"] = {
		perm = "Admin",
		color = 2,
		price = 50
	},
	["Delegacia"] = {
		perm = "Police",
		color = 29,
		price = 100
	},
	["Hospital"] = {
		perm = "Paramedic",
		color = 1,
		price = 80
	},
	["Mecânica"] = {
		perm = "Mechanic",
		color = 44,
		price = 100
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Call")
AddEventHandler("player:Call", function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	if CallCooldown[Passport] and os.time() < CallCooldown[Passport] then
		local TimeLeft = CallCooldown[Passport] - os.time()
		TriggerClientEvent("Notify",source,"Atenção","Aguarde <b>"..CompleteTimers(TimeLeft).."</b> para realizar outro chamado.","amarelo",5000)
		return
	end

	if not vRP.Request(source,"Telefone","Recomendamos que aguarde por até <b>5 minutos</b> no local onde o chamado foi realizado. Deseja prosseguir?") then return end

	local Options = {}
	for name in pairs(Services) do
		Options[#Options + 1] = name
	end

	local Keyboard = vKEYBOARD.Call(source, Options)
	if not Keyboard or not Keyboard[1] then return end

	local ServiceData = Services[Keyboard[1]]
	if not ServiceData then return end

	if vRP.AmountService(ServiceData.perm) <= 0 then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return
	end

	local Members = vRP.NumPermission(ServiceData.perm)
	local Coords = vRP.GetEntityCoords(source)

	for _, player in pairs(Members) do
		vRPC.PlaySound(player, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")

		TriggerClientEvent("NotifyPush", player, {
			code = 20,
			title = "Chamado de Telefone Público",
			name = vRP.FullName(Passport),
			x = Coords.x,
			y = Coords.y,
			z = Coords.z,
			color = ServiceData.color
		})
	end

	exports.bank:AddTaxes(Passport,source,"Telefone",ServiceData.price,"Chamado para "..Keyboard[1]..".")

	CallCooldown[Passport] = os.time() + CooldownTime
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:INFECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Infect")
AddEventHandler("player:Infect",function(Illness)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if math.random(100) >= 50 then
			TriggerEvent("health:Infect",Illness,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SURVIVAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Survival")
AddEventHandler("player:Survival",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.ClearInventory(Passport)
		vRP.UpgradeThirst(Passport,100)
		vRP.UpgradeHunger(Passport,100)
		vRP.DowngradeStress(Passport,100)
		TriggerEvent("inventory:CarryDetach",source,Passport)
		exports.discord:Embed("Airport","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[COORDS]:** "..vRP.GetEntityCoords(source))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Demand")
AddEventHandler("player:Demand",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	if Passport and OtherPassport and not exports.bank:CheckTaxes(OtherPassport) and not exports.bank:CheckFines(OtherPassport) then
		local Keyboard = vKEYBOARD.Primary(source,"Valor")
		if Keyboard and vRP.Passport(OtherSource) then
			local Price = parseInt(Keyboard[1],true)
			if vRP.Request(OtherSource,"Cobrança","Aceitar a cobrança de <b>"..Currency..""..Dotted(Price).."</b> feita por <b>"..Passport.."</b>.") then
				if vRP.PaymentBank(OtherPassport,Price,true) then
					vRP.GiveBank(Passport,Price,true)
				end
			else
				TriggerClientEvent("Notify",source,"Cobrança","Pedido recusado.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
local Debug = {}
RegisterServerEvent("player:Debug")
AddEventHandler("player:Debug",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Debug[Passport] or os.time() > Debug[Passport] then
		TriggerClientEvent("target:Debug",source)
		TriggerEvent("DebugObjects",Passport)
		Debug[Passport] = os.time() + 300
		vRPC.ReloadCharacter(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Stress")
AddEventHandler("player:Stress",function(Number)
	local source = source
	local Number = parseInt(Number)
	local Passport = vRP.Passport(source)
	if Passport then
		vRP.DowngradeStress(Passport,Number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if Message[2] and Message[2] == "friend" then
			local ClosestPed = vRPC.ClosestPed(source)
			if ClosestPed and vRP.GetHealth(ClosestPed) > 100 and not Player(ClosestPed)["state"]["Handcuff"] then
				if vRP.Request(ClosestPed,"Animação","Pedido de <b>"..vRP.FullName(Passport).."</b> da animação <b>"..Message[1].."</b>?") then
					TriggerClientEvent("animations:Emotes",ClosestPed,Message[1])
					TriggerClientEvent("animations:Emotes",source,Message[1])
				end
			end
		else
			TriggerClientEvent("animations:Emotes",source,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e2",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and (vRP.HasService(Passport,"Admin") or vRP.HasService(Passport,"Paramedic")) then
		local ClosestPed = vRPC.ClosestPed(source)
		if ClosestPed then
			TriggerClientEvent("animations:Emotes",ClosestPed,Message[1])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- E3
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("e3",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) then
		local Players = vRPC.ClosestPeds(source,50)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("animations:Emotes",v,Message[1])
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Doors")
AddEventHandler("player:Doors",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Vehicle,Network = vRPC.VehicleList(source)
		if Vehicle then
			local Players = vRPC.Players(source)
			for Passport,PlayerSource in pairs(Players) do
				async(function()
					TriggerClientEvent("player:syncDoors",PlayerSource,Network,Number)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(Mode)
	local Distance = 1
	if Mode == "rv" then
		Distance = 10
	end

	local source = source
	local Passport = vRP.Passport(source)
	local OtherSource = vRPC.ClosestPed(source,Distance)
	if Passport and OtherSource then
		if vRP.HasService(Passport,"Emergency") or vRP.ConsultItem(Passport,"rope",1) then
			local Vehicle,Network = vRPC.VehicleList(source)
			if Vehicle then
				local Networked = NetworkGetEntityFromNetworkId(Network)
				if DoesEntityExist(Networked) and GetVehicleDoorLockStatus(Networked) <= 1 then
					if Mode == "rv" then
						vCLIENT.RemoveVehicle(OtherSource)
					elseif Mode == "cv" then
						vCLIENT.PlaceVehicle(OtherSource,Network)
						TriggerEvent("inventory:CarryDetach",source,Passport)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local Preset = {
	["1"] = {
        ["mp_m_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 195, texture = 0 },
            ["vest"] = { item = 65, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 197, texture = 12 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 15, texture = 0 },
            ["torso"] = { item = 548, texture = 0 },
            ["accessory"] = { item = 183, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 22, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        },
        ["mp_f_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 209, texture = 0 },
            ["vest"] = { item = 63, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 209, texture = 12 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 254, texture = 0 },
            ["torso"] = { item = 584, texture = 0 },
            ["accessory"] = { item = 148, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 21, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        }
	},
	["2"] = {
        ["mp_m_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 31, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 58, texture = 1 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 154, texture = 0 },
            ["torso"] = { item = 250, texture = 0 },
            ["accessory"] = { item = 171, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 85, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        },
        ["mp_f_freemode_01"] = {
            ["hat"] = { item = -1, texture = 0 },
            ["pants"] = { item = 30, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["backpack"] = { item = 0, texture = 0 },
            ["decals"] = { item = 66, texture = 1 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 25, texture = 0 },
            ["tshirt"] = { item = 190, texture = 0 },
            ["torso"] = { item = 258, texture = 0 },
            ["accessory"] = { item = 96, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 109, texture = 0 },
            ["glass"] = { item = 0, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
        }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Preset")
AddEventHandler("player:Preset",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Emergency") and Preset[Number] then
		local Model = vRP.ModelPlayer(source)

		if Preset[Number][Model] then
			TriggerClientEvent("skinshop:Apply",source,Preset[Number][Model],true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrunk")
AddEventHandler("player:checkTrunk",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source)
	if ClosestPed then
		TriggerClientEvent("player:checkTrunk",ClosestPed)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKTRASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:checkTrash")
AddEventHandler("player:checkTrash",function()
	local source = source
	local ClosestPed = vRPC.ClosestPed(source)
	if ClosestPed then
		TriggerClientEvent("player:checkTrash",ClosestPed)
	else
		TriggerClientEvent("Notify",source,"Aviso","Não tem nada na lixeira.","vermelho",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CHECKSHOES
-----------------------------------------------------------------------------------------------------------------------------------------
local UniqueShoes = {}
RegisterServerEvent("player:checkShoes")
AddEventHandler("player:checkShoes",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not UniqueShoes[Entity] then
			UniqueShoes[Entity] = os.time()
		end

		if os.time() >= UniqueShoes[Entity] and vSKINSHOP.checkShoes(Entity) then
			vRP.GenerateItem(Passport,"WEAPON_SHOES",2,true)
			UniqueShoes[Entity] = os.time() + 300
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:OUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Outfit")
AddEventHandler("player:Outfit",function(Mode)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not exports.hud:Repose(Passport) and not exports.hud:Wanted(Passport) then
		TriggerClientEvent("skinshop:set"..Mode,source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:DEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:Death")
AddEventHandler("player:Death",function(OtherSource,Weapon)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not OtherSource then
		return false
	end

	local OtherPassport = vRP.Passport(OtherSource)
	if not OtherPassport then
		return false
	end

	local Entity = vRP.DoesEntityExist(source)
	local OtherEntity = vRP.DoesEntityExist(OtherSource)
	if not Entity or not OtherEntity then
		return false
	end

	local Coords = vRP.GetEntityCoords(source)
	local OtherCoords = vRP.GetEntityCoords(OtherSource)

	exports.oxmysql:insert_async("INSERT INTO deaths_creative (Attacker,Victim,Weapon,Timestamp) VALUES (?,?,?,?)",{ OtherPassport,Passport,Weapon,os.time() })
	exports.discord:Embed("Deaths","**[ASSASSINO]:** "..OtherPassport.."\n**[LOCALIZAÇÃO]:** "..OtherCoords.."\n\n**[VÍTIMA]:** "..Passport.."\n**[LOCALIZAÇÃO]:** "..Coords)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:SETWALK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:SetWalk")
AddEventHandler("player:SetWalk",function(Walk)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	if type(Walk) ~= "string" then return end

	vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Walk", Information = json.encode(Walk) })
	TriggerClientEvent("Notify",source,"Sucesso","Você mudou o seu estilo de movimentos.","verde",5000)

	TriggerClientEvent("vRP:Walk",source,Walk)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:RESETWALK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:ResetWalk")
AddEventHandler("player:ResetWalk",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Walk", Information = json.encode(nil) })
	TriggerClientEvent("Notify",source,"Sucesso","Você resetou o seu estilo de movimentos.","verde",5000)

	TriggerClientEvent("vRP:Walk",source,nil)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("player:DuiTable",source,DuiTextures)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Debug[Passport] then
		Debug[Passport] = nil
	end
end)