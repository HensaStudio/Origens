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
Tunnel.bindInterface("throwing",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Cooldown = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.First()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then

		if Cooldown[Passport] and os.time() <= Cooldown[Passport] then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Cooldown[Passport] - os.time())..".","amarelo",5000)
			return false
		end

		if vRP.Request(source,"Jornal","Você gostaria de começar seu trabalho e receber o material necessário para isso?") then
			if not vRP.MaxItens(Passport,ReceiveItem,ReceiveItemAmount) then
				if vRP.CheckWeight(Passport,ReceiveItem,ReceiveItemAmount) then
					vRP.GenerateItem(Passport,ReceiveItem,ReceiveItemAmount,true)

					Cooldown[Passport] = os.time() + 1800

					TriggerClientEvent("Notify",source,"Sucesso","Você recebeu o material necessário para iniciar seu trabalho.","verde",5000)
					return true
				else
					TriggerClientEvent("Notify",source,"Aviso","Mochila Sobrecarregada.","amarelo",5000)
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Limite atingido.","amarelo",5000)
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Model = vRPC.VehicleName(source)
		if not Model or not VehicleList[Model] then
			exports.discord:Embed("Hackers","**[PASSAPORTE]:** "..Passport.."\n**[FUNÇÃO]:** Payment do Throwing",source)
		end

		local GainExperience = 2
		local Amount = math.random(100,150)
		local Experience,Level = vRP.GetExperience(Passport,"Throwing")
		local Valuation = Amount + Amount * (0.05 * Level)

		if exports.inventory:Buffs("Dexterity",Passport) then
			Valuation = Valuation + (Valuation * 0.1)
		end

		for Permission,Multiplier in pairs({ Ouro = 0.1, Prata = 0.075, Bronze = 0.05 }) do
			if vRP.HasService(Passport,Permission) then
				Valuation = Valuation + (Valuation * Multiplier)
				GainExperience = GainExperience + 3
			end
		end

		vRP.PutExperience(Passport,"Throwing",GainExperience)
		vRP.GenerateItem(Passport,"dollar",Valuation,true)
		vRP.BattlepassPoints(Passport,GainExperience)
		vRP.UpgradeStress(Passport,2)

		Active[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Active[Passport] then
		Active[Passport] = nil
	end
end)