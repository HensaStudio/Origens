-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("health",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local HasIllness = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ILLNESSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local IllnessList = {
	["flu"] = { Name = "Gripe", Cure = "complaint", Contagion = { Chance = 40, Radius = 5.0 } },
	["intoxication"] = { Name = "Intoxicação", Cure = "intoxication", Contagion = { Chance = 70, Radius = 2.0 } },
	["fever"] = { Name = "Febre", Cure = "antipyretic", Contagion = { Chance = 30, Radius = 2.5 } },
	["infection"] = { Name = "Infecção", Cure = "antiinfection", Contagion = { Chance = 50, Radius = 3.0 } }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:INFECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("health:Infect")
AddEventHandler("health:Infect", function(Illness,source)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	if vRP.DatatableInformation(Passport,"MedicPlan") then
		TriggerClientEvent("Notify",source,"Aviso","Você esteve em risco de ficar doente, mas graças ao seu <b>Plano Médico</b>, conseguiu se manter saudável.","vermelho",10000)
		return
	end

	local Query = vRP.Query("health/Get",{ Passport = Passport })
	if not Query[1] then
		if not HasIllness[Passport] then
			HasIllness[Passport] = Illness

			vRP.Query("health/Set",{ Passport = Passport, Illness = Illness })

			Player(source).state.Illness = Illness
			TriggerClientEvent("health:Apply",source,Illness)
			TriggerClientEvent("Notify",source,"Saúde","Você está com <b>"..IllnessList[Illness].Name.."</b>.","sangue",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:CURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("health:Cure")
AddEventHandler("health:Cure", function(Item,source)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	local Illness = HasIllness[Passport]
	if Illness and IllnessList[Illness].Cure == Item then
		HasIllness[Passport] = nil

		vRP.Query("health/Remove",{ Passport = Passport })

		Player(source).state.Illness = false
		TriggerClientEvent("health:Remove",source)
		TriggerClientEvent("Notify",source,"Saúde","Você foi curado da <b>"..IllnessList[Illness].Name.."</b>.","sangue",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:ADMINCURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("health:AdminCure")
AddEventHandler("health:AdminCure", function(Result,source)
	local Passport = vRP.Passport(Result)
	if not Passport then return end

	local Illness = HasIllness[Passport]
	if Illness then
		HasIllness[Passport] = nil

		vRP.Query("health/Remove",{ Passport = Passport })

		Player(Result).state.Illness = false
		TriggerClientEvent("health:Remove",Result)
		TriggerClientEvent("Notify",Result,"Saúde","Você foi curado da <b>"..IllnessList[Illness].Name.."</b>.","sangue",5000)
	else
		TriggerClientEvent("Notify",source,"Saúde","Nenhuma doença encontrada.","sangue",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HEALTH:CONTAGION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("health:Contagion")
AddEventHandler("health:Contagion", function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then return end

	local Illness = HasIllness[Passport]
	if not Illness then return end

	local Result = IllnessList[Illness]
	if not Result or not Result.Contagion then return end

	local ClosestPed = vRPC.ClosestPed(source)
	if ClosestPed then
		local OtherPassport = vRP.Passport(ClosestPed)
		if OtherPassport and not HasIllness[OtherPassport] then
			if math.random(100) <= Result.Contagion.Chance then
				HasIllness[OtherPassport] = Illness

				vRP.Query("health/Set",{ Passport = OtherPassport, Illness = Illness })

				Player(ClosestPed).state.Illness = Illness
				TriggerClientEvent("health:Apply",ClosestPed,Illness)
				TriggerClientEvent("Notify",ClosestPed,"Saúde","Você foi infectado com <b>"..Result.Name.."</b>.","sangue",5000)

				TriggerClientEvent("Notify",source,"Saúde","Você transmitiu sua doença a alguém.","sangue",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VOMIT:SYNCPARTICLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vomit:SyncParticles")
AddEventHandler("vomit:SyncParticles", function(NetPed,Duration)
	TriggerClientEvent("vomit:PlayParticles",-1,NetPed,Duration)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INRAIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.InRain(Illness)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if not HasIllness[Passport] then
			TriggerEvent("health:Infect",Illness,source)
			TriggerClientEvent("Notify",source,"Saúde","Você ficou tempo demais na chuva e por isso ficou <b>Doente</b>.","sangue",10000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Query = vRP.Query("health/Get",{ Passport = Passport })
	if Query and Query[1] and Query[1].Illness then
		local Illness = Query[1].Illness
		HasIllness[Passport] = Illness

		Player(source).state.Illness = Illness
		TriggerClientEvent("health:Apply",source,Illness)
		TriggerClientEvent("Notify",source,"Saúde","Você está doente com: <b>"..IllnessList[Illness].Name.."</b>.","sangue",10000)
	end
end)