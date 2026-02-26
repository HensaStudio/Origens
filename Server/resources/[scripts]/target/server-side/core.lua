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
Tunnel.bindInterface("target",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Workout = {}
local Announces = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
for Number,_ in pairs(Academy) do
	GlobalState["Academy-"..Number] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Academy(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and not GlobalState["Academy-"..Number] and not Workout[Passport] then
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Cancel"] = true
		GlobalState["Academy-"..Number] = true
		Workout[Passport] = Number

		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACADEMYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.AcademyWeight(Number)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and GlobalState["Academy-"..Number] and Workout[Passport] == Number then
		local MaxWeight = 75
		for Permission,Multiplier in pairs({ Ouro = 60, Prata = 40, Bronze = 20 }) do
			if vRP.HasService(Passport,Permission) then
				MaxWeight = MaxWeight + Multiplier
			end
		end

		if vRP.GetWeight(Passport,true) < MaxWeight then
			vRP.UpgradeWeight(Passport,1,"+")
			TriggerClientEvent("Notify",source,"Academia","Sinto minha força alcançando novos patamares, não há limites quando se trata de determinação e dedicação.","verde",5000)
		end

		Player(source)["state"]["Buttons"] = false
		Player(source)["state"]["Cancel"] = false
		GlobalState["Academy-"..Number] = false
		Workout[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKIN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckIn()
	local Return = false
	local source = source
	local Alimentation = false
	local Valuation,Repose = 1000,1200
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.AmountService("Paramedic") > 0 then
			TriggerClientEvent("Notify",source,"Atenção","Há paramédicos em serviço no momento. Procure um deles para receber atendimento.","amarelo",10000)
			Return = false
		end

		local MedicPlan = vRP.DatatableInformation(Passport,"MedicPlan")
		if MedicPlan and MedicPlan > os.time() then
			Valuation,Repose = 500,600
		end

		if vRP.Request(source,"Centro Médico","Deseja adicionar o serviço de alimentação pagando <b>"..Currency.."500</b>?") then
			Valuation = Valuation + 500
			Alimentation = true
		end

		if vRP.GetHealth(source) <= 100 then
			Valuation = Valuation + 500
			Repose = Repose + 600
		end

		if vRP.PaymentFull(Passport,Valuation) then
			if Alimentation then
				vRP.UpgradeThirst(Passport,25)
				vRP.UpgradeHunger(Passport,25)
			end

			TriggerEvent("Repose",source,Passport,Repose)
			Return = true
		else
			TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
		end
	end

	return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:REPOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Repose")
AddEventHandler("target:Repose",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	local OtherPassport = vRP.Passport(OtherSource)
	local Keyboard = vKEYBOARD.Primary(source,"Minutos.")
	if Passport and OtherPassport and Keyboard and parseInt(Keyboard[1]) > 0 then
		TriggerClientEvent("Notify",source,"Centro Médico","Adicionou "..Keyboard[1].." minutos de repouso.","sangue",5000)
		TriggerEvent("Repose",OtherSource,OtherPassport,parseInt(Keyboard[1]) * 60)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Service")
AddEventHandler("target:Service",function(Permission)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or not vRP.HasGroup(Passport,Permission) then
		return false
	end

	if Permission == "Police" then
		for _,v in pairs({ "LSPD","PRPD" }) do
			if vRP.HasPermission(Passport,v) then
				Permission = v
				break
			end
		end

		if Permission == "Police" then
			return false
		end
	end

	vRP.ServiceToggle(source,Passport,Permission)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ANNOUNCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("target:Announces")
AddEventHandler("target:Announces", function(Service)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Identity = vRP.Identity(Passport)
		local Account = Identity and vRP.Account(Identity.License)

		if not Announces[Service] then
			Announces[Service] = os.time()
		end

		if os.time() < Announces[Service] then
			local Cooldown = parseInt(Announces[Service] - os.time())
			return TriggerClientEvent("Notify",source,"Atenção","Aguarde <b>"..CompleteTimers(Cooldown).."</b> segundos.","amarelo",5000)
		end

		local Config = {
			LSPD = { Color = "policia", Permission = "LSPD" },
			PRPD = { Color = "policia", Permission = "PRPD" },
			Paramedic = { Color = "sangue", Permission = "Paramedic" },
			Mechanic = { Color = "default", Permission = "Mechanic" }
		}

		local function SendAnnouncement(Title,Color)
			local Keyboard = vKEYBOARD.AreaOptions(source,"Anúncio:",{ "15s","30s","60s","180s","360s" })
			if Keyboard and Keyboard[1] and Keyboard[2] then
				local Message = Keyboard[1]
				local Duration = Keyboard[2]
				local Times = {
					["15s"] = 15000,
					["30s"] = 30000,
					["60s"] = 60000,
					["180s"] = 180000,
					["360s"] = 360000
				}

				local Time = Times[Duration] or 15000
				TriggerClientEvent("Notify",-1,Title,Message,Color,Time)
				Announces[Service] = os.time() + 600

				if Account and Account.Discord then
					exports.discord:Content("Announces",Account.Discord.." #"..Passport.." "..Keyboard[1].." "..Keyboard[2].." "..Color)
				end
			end
		end

		local Data = Config[Service]
		if Data then
			if vRP.HasService(Passport,Data.Permission) then
				SendAnnouncement(Groups[Service].Name,Data.Color)
			else
				TriggerClientEvent("Notify",source,"Aviso","Você não pode enviar um anúncio.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Workout[Passport] then
		GlobalState["Academy-"..Workout[Passport]] = false
		Workout[Passport] = nil
	end
end)