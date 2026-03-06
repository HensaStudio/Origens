-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Payments = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALCULATEVALUATION
-----------------------------------------------------------------------------------------------------------------------------------------
local function CalculateValuation(Passport, BaseValuation, Type)
	local Valuation = BaseValuation
	local Multipliers = {
		["Mining"] = { Party = 0.5, Luck = 0.5, VIP = { Ouro = 0.5, Prata = 0.35, Bronze = 0.2 } },
		["Lumber"] = { Party = 0.25, Luck = 0.25, VIP = { Ouro = 0.25, Prata = 0.2, Bronze = 0.15 } },
		["Weed"] = { Party = 0.25, Luck = 0.25, VIP = { Ouro = 0.25, Prata = 0.20, Bronze = 0.15 } },
		["Simple"] = { Luck = 1 }
	}

	local Config = Multipliers[Type]
	if not Config then return Valuation end

	if Config.Party and exports.party:DoesExist(Passport, 2) then
		Valuation = Valuation + (Valuation * Config.Party)
	end

	if Config.Luck and exports.inventory:Buffs("Luck", Passport) then
		if Type == "Simple" then
			Valuation = Valuation + Config.Luck
		else
			Valuation = Valuation + (Valuation * Config.Luck)
		end
	end

	if Config.VIP then
		for Permission, Multiplier in pairs(Config.VIP) do
			if vRP.HasService(Passport, Permission) then
				Valuation = Valuation + (Valuation * Multiplier)
			end
		end
	end

	return math.floor(Valuation)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDISTANCE
-----------------------------------------------------------------------------------------------------------------------------------------
local function CheckDistance(source, Number, MaxDistance)
	if not Objects[Number] then return false end
	local Ped = GetPlayerPed(source)
	local Coords = GetEntityCoords(Ped)
	local Distance = #(Coords - Objects[Number]["Coords"]["xyz"])
	return Distance <= (MaxDistance or 10.0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number = 1,#Objects do
	GlobalState["Farmer:"..Number] = 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MINERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Minerman")
AddEventHandler("farmer:Minerman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Farmer",source)

			Payments[Passport] = (Payments[Passport] or 0) + 1
			if Payments[Passport] >= 3 then
				vRP.SetBanned(Passport,-1,"Permanente","Hacker")
			end

			Active[Passport] = nil
			return
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			local Item = "pickaxe"
			local Pickaxe = vRP.ConsultItem(Passport,Item)
			local PickaxePlus = vRP.ConsultItem(Passport,Item.."plus")

			if not Pickaxe and not PickaxePlus then
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName(Item).."</b>.","amarelo",5000)
			else
				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true
				vRPC.CreateObjects(source,"melee@large_wpn@streamed_core","ground_attack_on_spot","prop_tool_pickaxe",1,18905,0.10,-0.1,0.0,-92.0,260.0,5.0)

				if vRP.Task(source,Pickaxe and 10 or 5,10000) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 60

					local Result = {
						{ ["Item"] = "tin_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "lead_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "copper_pure", ["Chance"] = 100, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "iron_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "gold_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "diamond_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
						{ ["Item"] = "ruby_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 }
					}

					if PickaxePlus then
						Result = {
							{ ["Item"] = "tin_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "lead_pure", ["Chance"] = 125, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "copper_pure", ["Chance"] = 100, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "iron_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "gold_pure", ["Chance"] = 75, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "diamond_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "ruby_pure", ["Chance"] = 25, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "sapphire_pure", ["Chance"] = 15, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "emerald_pure", ["Chance"] = 10, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "chalcopyrite", ["Chance"] = 1, ["Min"] = 1, ["Max"] = 1 },
							{ ["Item"] = "bauxite", ["Chance"] = 1, ["Min"] = 1, ["Max"] = 1 }
						}
					end

					local Consult = RandPercentage(Result)
					local Amount = CalculateValuation(Passport, 1, "Mining")

					if vRP.CheckWeight(Passport,Consult["Item"],Amount) and not vRP.MaxItens(Passport,Consult["Item"],Amount) then
						vRP.GenerateItem(Passport,Consult["Item"],Amount,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
						exports.inventory:Drops(Passport,source,Consult["Item"],Amount)
					end

					vRP.BattlepassPoints(Passport,2)
					vRP.UpgradeStress(Passport,1)

					if math.random(100) <= 50 then
						TriggerClientEvent("farmer:SpawnCow",source)
					end
				end

				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				vRPC.Destroy(source)
			end
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUMBERMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Lumberman")
AddEventHandler("farmer:Lumberman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Farmer",source)

			Payments[Passport] = (Payments[Passport] or 0) + 1
			if Payments[Passport] >= 3 then
				vRP.SetBanned(Passport,-1,"Permanente","Hacker")
			end

			Active[Passport] = nil
			return
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			local Item = "axe"
			local Axe = vRP.ConsultItem(Passport,Item)
			local AxePlus = vRP.ConsultItem(Passport,Item.."plus")

			if not Axe and not AxePlus then
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName(Item).."</b>.","amarelo",5000)
			else
				if math.random(100) <= 50 then
					TriggerClientEvent("farmer:SpawnCow",source)
				end

				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true
				vRPC.CreateObjects(source,"lumberjackaxe@idle","idle","prop_tool_fireaxe",1,57005,0.1,0.0,0.0,-90.0,0.0,0.0)

				if vRP.Task(source,Axe and 10 or 5,10000) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					local Valuation = CalculateValuation(Passport, 3, "Lumber")

					if vRP.CheckWeight(Passport,"woodlog",Valuation) and not vRP.MaxItens(Passport,"woodlog",Valuation) then
						vRP.GenerateItem(Passport,"woodlog",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
						exports.inventory:Drops(Passport,source,"woodlog",Valuation)
					end

					vRP.BattlepassPoints(Passport,2)
					vRP.UpgradeStress(Passport,1)
				end

				TriggerClientEvent("inventory:Provisory",source,false)
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				vRPC.Destroy(source)
			end
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSPORTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Transporter")
AddEventHandler("farmer:Transporter",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Farmer",source)

			Payments[Passport] = (Payments[Passport] or 0) + 1
			if Payments[Passport] >= 3 then
				vRP.SetBanned(Passport,-1,"Permanente","Hacker")
			end

			Active[Passport] = nil
			return
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1000)
			vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)

			SetTimeout(1000,function()
				if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 18

					local Valuation = CalculateValuation(Passport, 1, "Simple")

					if vRP.CheckWeight(Passport,"pouch",Valuation) and not vRP.MaxItens(Passport,"pouch",Valuation) then
						vRP.GenerateItem(Passport,"pouch",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
						exports.inventory:Drops(Passport,source,"pouch",Valuation)
					end

					vRP.UpgradeStress(Passport,1)
				end

				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				Active[Passport] = nil
			end)
		else
			Active[Passport] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SANDMAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Sandman")
AddEventHandler("farmer:Sandman",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Farmer",source)

			Payments[Passport] = (Payments[Passport] or 0) + 1
			if Payments[Passport] >= 3 then
				vRP.SetBanned(Passport,-1,"Permanente","Hacker")
			end

			Active[Passport] = nil
			return
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1000)
			vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)

			SetTimeout(1000,function()
				if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					local Valuation = CalculateValuation(Passport, 1, "Simple")

					if vRP.CheckWeight(Passport,"sand",Valuation) and not vRP.MaxItens(Passport,"sand",Valuation) then
						vRP.GenerateItem(Passport,"sand",Valuation,true)
					else
						TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
						exports.inventory:Drops(Passport,source,"sand",Valuation)
					end

					vRP.BattlepassPoints(Passport,5)
					vRP.UpgradeStress(Passport,1)
				end

				vRPC.Destroy(source)
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Cancel"] = false
				Active[Passport] = nil
			end)
		else
			Active[Passport] = nil
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRASHER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Trasher")
AddEventHandler("farmer:Trasher",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Farmer",source)

			Payments[Passport] = (Payments[Passport] or 0) + 1
			if Payments[Passport] >= 3 then
				vRP.SetBanned(Passport,-1,"Permanente","Hacker")
			end

			Active[Passport] = nil
			return
		end

		if not vRPC.LastVehicle(source,"trash") then
			TriggerClientEvent("Notify",source,"Atenção","Necessário a utilização do veículo <b>Trash</b>.","amarelo",5000)
			Active[Passport] = nil

			return false
		end

		if GlobalState["Farmer:"..Number] and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
			Player(source)["state"]["Cancel"] = true
			Player(source)["state"]["Buttons"] = true
			TriggerClientEvent("Progress",source,"Coletando",1000)
			vRPC.playAnim(source,false,{"pickup_object","pickup_low"},true)

			Wait(1000)

			if GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
				GlobalState["Farmer:"..Number] = GlobalState["Work"] + 180

				if not vRP.MaxItens(Passport,"binbag") and vRP.CheckWeight(Passport,"binbag") then
					vRP.GenerateItem(Passport,"binbag",1,true)
				else
					TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
					exports.inventory:Drops(Passport,source,"binbag",1)
				end

				vRP.PutExperience(Passport,"Garbageman",1)
				vRP.BattlepassPoints(Passport,1)
				vRP.UpgradeStress(Passport,1)

				if math.random(100) >= 50 then
					TriggerEvent("health:Infect","intoxication",source)
				end
			end

			Player(source)["state"]["Buttons"] = false
			Player(source)["state"]["Cancel"] = false
			vRPC.Destroy(source)
		end

		Active[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEATHERBONUS
-----------------------------------------------------------------------------------------------------------------------------------------
local WeatherBonus = { EXTRASUNNY = 0.85, CLEAR = 0.90, CLEARING = 0.95, CLOUDS = 1.00, OVERCAST = 1.05, FOGGY = 1.10, RAIN = 1.25, THUNDER = 1.40 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETRANDOMPURITY
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetRandomPurity()
	local Weather = GlobalState["Weather"]
	local WeatherMultiplier = WeatherBonus[Weather] or 1.0

	local Hour = GlobalState["Hours"] or 12
	if Hour >= 6 and Hour <= 10 then
		WeatherMultiplier = WeatherMultiplier * 0.90
	elseif Hour >= 18 or Hour <= 5 then
		WeatherMultiplier = WeatherMultiplier * 1.10
	end

	local Random = math.random(100) * WeatherMultiplier
	local Accumulated = 0

	for _,v in ipairs(Puritys) do
		Accumulated = Accumulated + v.Chance
		if Random <= Accumulated then
			return v.Percent
		end
	end

	return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:WEED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("farmer:Weed")
AddEventHandler("farmer:Weed",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not Active[Passport] then
			if Player(source)["state"]["Basket"] and vRP.ConsultItem(Passport,"basket",1) then 
				Active[Passport] = true

				if not Number or type(Number) ~= "number" or not CheckDistance(source, Number) then
					exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** farmer:Weed",source)

					Payments[Passport] = (Payments[Passport] or 0) + 1
					if Payments[Passport] >= 3 then
						vRP.SetBanned(Passport,-1,"Permanente","Hacker")
					end

					Active[Passport] = nil
					return
				end

				if not GlobalState["Farmer:"..Number] then
					Active[Passport] = nil
					return
				end

				if GlobalState["Work"] < GlobalState["Farmer:"..Number] then
					Active[Passport] = nil
					return
				end

				Player(source)["state"]["Cancel"] = true
				Player(source)["state"]["Buttons"] = true
				TriggerClientEvent("inventory:Provisory",source,true)

				vRPC.playAnim(source,false,{"amb@world_human_gardener_plant@male@base","base"},true)

				if vRP.Task(source,5,2000) and GlobalState["Work"] >= GlobalState["Farmer:"..Number] then
					TriggerClientEvent("Progress",source,"Coletando",60000)

					SetTimeout(60000,function()
						local Valuation = CalculateValuation(Passport, 3, "Weed")

						local Purity = GetRandomPurity()
						local CloneItem = "weedclone_"..Purity

						TriggerClientEvent("Notify",source,"Sucesso","Você colheu um broto com <b>"..Purity.."%</b> de pureza.","verde",5000)

						exports.inventory:Drops(Passport,source,CloneItem,1)

						vRP.BattlepassPoints(Passport,2)
						vRP.UpgradeStress(Passport,1)

						GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

						TriggerClientEvent("inventory:Provisory",source,false)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
						vRPC.Destroy(source)

						Active[Passport] = nil
					end)
				else
					TriggerClientEvent("Notify",source,"Aviso","Você não conseguiu coletar da forma correta e acabou destruindo a plantação.","vermelho",5000)

					GlobalState["Farmer:"..Number] = GlobalState["Work"] + 30

					TriggerClientEvent("inventory:Provisory",source,false)
					Player(source)["state"]["Buttons"] = false
					Player(source)["state"]["Cancel"] = false
					vRPC.Destroy(source)

					Active[Passport] = nil
				end
			else
				TriggerClientEvent("Notify",source,"Atenção","Você precisa estar com <b>1x "..ItemName("basket").."</b> em mãos.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if Payments[Passport] then
		Payments[Passport] = nil
	end
end)