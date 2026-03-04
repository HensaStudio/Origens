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
Tunnel.bindInterface("police",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
local Locations = {}
local FoundItems = {}
local CooldownCure = {}
local CooldownFood = {}
local CooldownDrink = {}
local CooldownCandy = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REWARDS
-----------------------------------------------------------------------------------------------------------------------------------------
local Rewards = {
	{ Item = "key", Chance = 10 },
	{ Item = "WEAPON_SWITCHBLADE", Chance = 15 },
	{ Item = "WEAPON_BOTTLE", Chance = 20 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:ITENS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Itens")
AddEventHandler("prison:Itens",function(OtherSource)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport or not OtherSource or not vRP.HasService(Passport,"Police") or vRP.GetHealth(source) <= 100 then
		return false
	end

	local OtherPassport = vRP.Passport(OtherSource)
	if not OtherPassport then
		return false
	end

	TriggerClientEvent("Notify",source,"Sucesso","Objetos apreendidos.","verde",5000)
	exports.inventory:CleanWeapons(OtherPassport)
	vRP.ArrestItens(OtherPassport)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:PLATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Plate")
AddEventHandler("prison:Plate",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)

	if not Passport or not vRP.HasService(Passport,"Police") then
		return
	end

	TriggerClientEvent("dynamic:Close",source)

	local Plate = Entitys and Entitys[1]

	if not Plate then
		local Keyboard = vKEYBOARD.Primary(source,"Placa")
		Plate = Keyboard and Keyboard[1]
	end

	if not Plate or Plate == "" then
		TriggerClientEvent("Notify",source,"Emplacamento","Você precisa informar uma placa.","vermelho",5000)
		return
	end

	Plate = string.upper(Plate)
	Plate = string.gsub(Plate,"%W","")

	local OtherPassport = vRP.PassportPlate(Plate)
	if not OtherPassport then
		TriggerClientEvent("Notify",source,"Emplacamento","Placa não encontrada no sistema.","policia",5000)
		return
	end

	local Identity = vRP.Identity(OtherPassport)
	if not Identity then
		TriggerClientEvent("Notify",source,"Emplacamento","Identidade vinculada não encontrada.","policia",5000)
		return
	end

	local Message = string.format("<b>Passaporte:</b> %s<br><b>Telefone:</b> %s<br><b>Nome:</b> %s %s",Identity.id,vRP.Phone(OtherPassport),Identity.Name,Identity.Lastname)
	TriggerClientEvent("Notify",source,"Emplacamento",Message,"policia",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Service")
AddEventHandler("prison:Service",function(Number)
	local source = source
	local Passport = vRP.Passport(source)
	local Identity = vRP.Identity(Passport)
	if Passport and Identity and Identity["Prison"] > 0 then
		if not Locations[Passport] then
			Locations[Passport] = {}
		end

		if Locations[Passport][Number] then
			if os.time() >= Locations[Passport][Number] then
				Reduction(source,Passport,Number)
			else
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Locations[Passport][Number] - os.time())..".","amarelo",5000)
			end
		else
			Reduction(source,Passport,Number)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYFINDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function TryFindItem(Passport)
	if not FoundItems[Passport] then
		FoundItems[Passport] = {}
	end

	local Random = math.random(100)
	local Accumulated = 0
	for _,Reward in pairs(Rewards) do
		Accumulated =  Accumulated + Reward.Chance

		if Random <= Accumulated then
			if not FoundItems[Passport][Reward.Item] then
				vRP.GenerateItem(Passport,Reward.Item,1,true)

				FoundItems[Passport][Reward.Item] = true
			end

			break
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REDUCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function Reduction(source,Passport,Number)
	if not Active[Passport] then
		Player(source)["state"]["Cancel"] = true
		Player(source)["state"]["Buttons"] = true

		vRPC.playAnim(source,false,{"amb@prop_human_bum_bin@base","base"},true)

		if not vRP.Task(source,3,1500) then
			vRPC.Destroy(source)

			Player(source)["state"]["Cancel"] = false
			Player(source)["state"]["Buttons"] = false

			vRP.UpgradeStress(Passport,1)

			return false
		end

		Active[Passport] = os.time() + 30
		Locations[Passport][Number] = os.time() + 300
		TriggerClientEvent("Progress",source,"Vasculhando",30000)

		repeat
			if Active[Passport] and os.time() >= parseInt(Active[Passport]) then
				vRPC.Destroy(source)
				Active[Passport] = nil

				vRP.UpdatePrison(Passport,1)
				vRP.UpgradeStress(Passport,1)

				if math.random(100) >= 50 then
					vRP.DowngradeThirst(Passport,3)
				else
					vRP.DowngradeHunger(Passport,3)
				end

				TryFindItem(Passport)

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
			end

			Wait(100)
		until not Active[Passport]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:VEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Vehicle")
AddEventHandler("prison:Vehicle",function(Entity)
	local source = source
	local Plate = Entity[1]
	local Passport = vRP.Passport(source)
	if Passport and vRP.Request(source,"Garagem","Apreender o veículo?") and vRP.PassportPlate(Plate) then
		local Vehicle = vRP.Query("vehicles/plateVehicles",{ Plate = Plate })
		if Vehicle[1] then
			if not Vehicle[1]["Arrest"] then
				vRP.Query("vehicles/Arrest",{ Plate = Plate })

				local OwnerPassport = vRP.PassportPlate(Plate)
				if OwnerPassport then
					local OwnerSource = vRP.Source(OwnerPassport)
					if OwnerSource then
						TriggerClientEvent("Notify", OwnerSource, "Departamento Policial",
							("Seu veículo de placa <b>%s</b> foi apreendido e enviado para a <b>Garagem Reboque</b>."):format(Plate),
							"policia", 10000)
					end
				end

				TriggerClientEvent("Notify",source,"Departamento Policial","Veículo apreendido e enviado para a <b>Garagem Reboque</b>.","policia",5000)
			else
				TriggerClientEvent("Notify",source,"Departamento Policial","Veículo já se encontra apreendido.","policia",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:ESCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Escape")
AddEventHandler("prison:Escape",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return
	end

	if not vRP.ConsultItem(Passport,"key",1) then
		TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("key").."</b>.","amarelo",5000)
		return
	end

	if not vRP.Request(source,"Penitenciária de Bolingbroke","Você realmente deseja fugir? Ao fazer isso, você ficará procurado em toda a cidade.") then
		return
	end

	if not vRP.LetterGame(source) then
		TriggerClientEvent("Notify",source,"Atenção","Você falhou em fugir.","amarelo",5000)
		return
	end

	vRP.TakeItem(Passport,"key",1,true)

	local Members,Count = exports.party:Room(Passport,source,2)

	if Count > 0 then
		for _,Member in pairs(Members) do
			local OtherSource = Member.Source
			local OtherPassport = Member.Passport

			TriggerClientEvent("prison:ScreenFadeEscape",OtherSource)

			exports.vrp:CallPolice({
				Source = OtherSource,
				Passport = OtherPassport,
				Permission = "Police",
				Title = "Fuga da Penitenciária",
				Name = vRP.FullName(OtherPassport),
				Wanted = 60,
				Code = 98,
				Color = 2
			})
		end
	else
		TriggerClientEvent("prison:ScreenFadeEscape",source)

		exports.vrp:CallPolice({
			Source = source,
			Passport = Passport,
			Permission = "Police",
			Title = "Fuga da Penitenciária",
			Name = vRP.FullName(Passport),
			Wanted = 60,
			Code = 98,
			Color = 2
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:CURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Cure")
AddEventHandler("prison:Cure",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not Player(source).state.Prison then
		TriggerClientEvent("Notify",source,"Penitenciária de Bolingbroke","Somente prisioneiros podem utilizar este benefício.","policia",5000)
		return false
	end

	if CooldownCure[Passport] and os.time() < CooldownCure[Passport] then
		local Remaining = CooldownCure[Passport] - os.time()
		TriggerClientEvent("Notify",source,"Saúde","Se cure novamente em <b>"..CompleteTimers(Remaining).."</b>.","sangue",5000)
		return false
	end

	if not vRP.Request(source,"Penitenciária de Bolingbroke","Você só pode se curar <b>uma vez</b> a cada <b>5 minutos</b>.") then
		return false
	end

	if not Active[Passport] then
		Active[Passport] = os.time() + 30

		Player(source)["state"]["Cancel"] = true
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Commands"] = true

		TriggerClientEvent("Progress",source,"Comendo",30000)
		vRPC.playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

		CreateThread(function()
			while Active[Passport] and os.time() < Active[Passport] do
				Wait(100)
			end

			if Active[Passport] then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				vRP.Revive(source,200)

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Commands"] = false

				CooldownCure[Passport] = os.time() + 300

				TriggerClientEvent("Notify",source,"Saúde","Você se curou.","sangue",5000)
			end
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:CANDY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Candy")
AddEventHandler("prison:Candy",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not Player(source).state.Prison then
		TriggerClientEvent("Notify",source,"Penitenciária de Bolingbroke","Somente prisioneiros podem utilizar este benefício.","policia",5000)
		return false
	end

	if CooldownCandy[Passport] and os.time() < CooldownCandy[Passport] then
		local Remaining = CooldownCandy[Passport] - os.time()
		TriggerClientEvent("Notify",source,"Estresse","Se acalme novamente em <b>"..CompleteTimers(Remaining).."</b>.","estresse",5000)
		return false
	end

	if not vRP.Request(source,"Penitenciária de Bolingbroke","Você só pode se acalmar <b>uma vez</b> a cada <b>5 minutos</b> e diminui o estresse em apenas <b>20%</b> a cada uso.") then
		return false
	end

	if not Active[Passport] then
		Active[Passport] = os.time() + 30

		Player(source)["state"]["Cancel"] = true
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Commands"] = true

		TriggerClientEvent("Progress",source,"Comendo",30000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_choc_ego",49,60309)

		CreateThread(function()
			while Active[Passport] and os.time() < Active[Passport] do
				Wait(100)
			end

			if Active[Passport] then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				vRP.DowngradeStress(Passport,20)

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Commands"] = false

				TriggerClientEvent("Notify",source,"Estresse","Você se acalmou.","estresse",5000)

				CooldownCandy[Passport] = os.time() + 300
			end
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:DRINK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Drink")
AddEventHandler("prison:Drink",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not Player(source).state.Prison then
		TriggerClientEvent("Notify",source,"Penitenciária de Bolingbroke","Somente prisioneiros podem utilizar este benefício.","policia",5000)
		return false
	end
	
	if CooldownDrink[Passport] and os.time() < CooldownDrink[Passport] then
		local Remaining = CooldownDrink[Passport] - os.time()
		TriggerClientEvent("Notify",source,"Hidratação","Se hidrate novamente em <b>"..CompleteTimers(Remaining).."</b>.","sede",5000)
		return false
	end

	if not vRP.Request(source,"Penitenciária de Bolingbroke","Você só pode se hidratar <b>uma vez</b> a cada <b>5 minutos</b> e recupera apenas <b>20%</b> a cada uso.") then
		return false
	end

	if not Active[Passport] then
		Active[Passport] = os.time() + 30

		Player(source)["state"]["Cancel"] = true
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Commands"] = true

		TriggerClientEvent("Progress",source,"Bebendo",30000)
		vRPC.CreateObjects(source,"amb@world_human_drinking@coffee@male@idle_a","idle_c","prop_plastic_cup_02",49,28422)

		CreateThread(function()
			while Active[Passport] and os.time() < Active[Passport] do
				Wait(100)
			end

			if Active[Passport] then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				vRP.UpgradeThirst(Passport,20)

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Commands"] = false

				TriggerClientEvent("Notify",source,"Hidratação","Você se hidratou.","sede",5000)

				CooldownDrink[Passport] = os.time() + 300

				if math.random(100) >= 50 then
					TriggerEvent("health:Infect","intoxication",source)
				end
			end
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISON:FOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("prison:Food")
AddEventHandler("prison:Food",function()
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if not Player(source).state.Prison then
		TriggerClientEvent("Notify",source,"Penitenciária de Bolingbroke","Somente prisioneiros podem utilizar este benefício.","policia",5000)
		return false
	end

	if CooldownFood[Passport] and os.time() < CooldownFood[Passport] then
		local Remaining = CooldownFood[Passport] - os.time()
		TriggerClientEvent("Notify",source,"Alimentação","Se alimente novamente em <b>"..CompleteTimers(Remaining).."</b>.","fome",5000)
		return false
	end

	if not vRP.Request(source,"Penitenciária de Bolingbroke","Você só pode se alimentar <b>uma vez</b> a cada <b>5 minutos</b> e recupera apenas <b>20%</b> a cada uso.") then
		return false
	end

	if not Active[Passport] then
		Active[Passport] = os.time() + 30

		Player(source)["state"]["Cancel"] = true
		Player(source)["state"]["Buttons"] = true
		Player(source)["state"]["Commands"] = true

		TriggerClientEvent("Progress",source,"Comendo",30000)
		vRPC.CreateObjects(source,"mp_player_inteat@burger","mp_player_int_eat_burger","prop_cs_burger_01",49,60309)

		CreateThread(function()
			while Active[Passport] and os.time() < Active[Passport] do
				Wait(100)
			end

			if Active[Passport] then
				Active[Passport] = nil
				vRPC.Destroy(source,"one")
				vRP.UpgradeHunger(Passport,20)

				Player(source)["state"]["Cancel"] = false
				Player(source)["state"]["Buttons"] = false
				Player(source)["state"]["Commands"] = false

				CooldownFood[Passport] = os.time() + 300

				TriggerClientEvent("Notify",source,"Alimentação","Você se alimentou.","fome",5000)

				if math.random(100) >= 50 then
					TriggerEvent("health:Infect","intoxication",source)
				end
			end
		end)
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