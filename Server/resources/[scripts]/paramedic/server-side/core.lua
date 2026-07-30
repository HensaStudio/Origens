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
vCLIENT = Tunnel.getInterface("paramedic")
vSURVIVAL = Tunnel.getInterface("survival")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blood = {}
local Active = {}
local Extract = {}
local Cooldown = {}
local AttentionCooldown = {}
local MedicamentCooldown = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:SURVIVALCALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:SurvivalCall")
AddEventHandler("paramedic:SurvivalCall",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.AmountService("Paramedic") > 0 then
			TriggerClientEvent("Notify",source,"Saúde","Você sofreu um acidente e um chamado automático foi enviado aos paramédicos disponíveis no momento.","sangue",30000,"top-center",false,false,false)

			exports.vrp:CallPolice({
				Source = source,
				Passport = Passport,
				Permission = "Paramedic",
				Title = "Possível acidente",
				Code = 99,
			})
		else
			TriggerClientEvent("Notify",source,"Aviso","Atualmente não existem paramédicos em serviço.","vermelho",5000,"top-center",false,false,false)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:NEEDATTENTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:NeedAttention")
AddEventHandler("paramedic:NeedAttention",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.AmountService("Paramedic") > 0 then
			if AttentionCooldown[Passport] and os.time() <= AttentionCooldown[Passport] then
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(AttentionCooldown[Passport] - os.time())..".","amarelo",5000)
				return false
			end

			exports.vrp:CallPolice({
				Source = source,
				Passport = Passport,
				Permission = "Paramedic",
				Title = "Recepção do Hospital",
				Code = 99,
			})

			AttentionCooldown[Passport] = os.time() + 300
		else
			TriggerClientEvent("Notify",source,"Atenção","Atualmente não existem paramédicos em serviço.","amarelo",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:PRESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Prescription")
AddEventHandler("paramedic:Prescription",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 and vRP.GetHealth(Entitys) > 100 then
		local OtherPassport = vRP.Passport(Entitys)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if Cooldown[OtherPassport] and os.time() <= Cooldown[OtherPassport] then
				TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Cooldown[OtherPassport] - os.time())..".","amarelo",5000)
				return false
			end
			
			local List = { "medkit","ritmoneury","sinkalmy","analgesic","antipyretic","intoxication","complaint","antiinfection" }

			local DisplayList = {}
			for _,item in ipairs(List) do
				table.insert(DisplayList, ItemName(item))
			end

			local Keyboard = vKEYBOARD.Instagram(source,DisplayList)
			if Keyboard then
				local SelectedName = Keyboard[1]
				local SelectedId

				for i,name in ipairs(DisplayList) do
					if name == SelectedName then
						SelectedId = List[i]
						break
					end
				end

				if SelectedId then
					if not Active[Passport] then
						Active[Passport] = os.time() + 3

						vRPC.CreateObjects(source,"mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)

						CreateThread(function()
							while Active[Passport] and os.time() < Active[Passport] do
								Wait(100)
							end

							if Active[Passport] then
								vRPC.Destroy(source)
								Active[Passport] = nil
								
								vRP.GiveItem(OtherPassport,"prescription-"..os.time().."-"..SelectedId.."-"..OtherPassport,1,true)
								Cooldown[OtherPassport] = os.time() + 1800

								TriggerClientEvent("Notify",source,"Sucesso","Você receitou <b>1x "..SelectedName.."</b> para <b>"..vRP.FullName(OtherPassport).."</b>.","verde",5000)
							end
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:TAKEMEDICAMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:TakeMedicament")
AddEventHandler("paramedic:TakeMedicament",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if not vRP.DatatableInformation(Passport,"MedicPlan") then
			TriggerClientEvent("Notify",source,"Aviso","Você não tem um <b>Plano Médico</b> e não pode acessar esse benefício.","vermelho",10000)
			return false
		end

		if MedicamentCooldown[Passport] and os.time() <= MedicamentCooldown[Passport] then
			TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(MedicamentCooldown[Passport] - os.time())..".","amarelo",5000)
			return false
		end

		if vRP.Request(source,"Centro Médico","Você pode escolher apenas <b>1 Medicamento</b> a cada <b>10 Minutos</b>, deseja continuar?") then
			local List = { "medkit","ritmoneury","sinkalmy","analgesic","antipyretic","intoxication","complaint","antiinfection" }

			local DisplayList = {}
			for _,item in ipairs(List) do
				table.insert(DisplayList, ItemName(item))
			end

			local Keyboard = vKEYBOARD.Instagram(source,DisplayList)
			if Keyboard then
				local SelectedName = Keyboard[1]
				local SelectedId

				for i,name in ipairs(DisplayList) do
					if name == SelectedName then
						SelectedId = List[i]
						break
					end
				end

				if SelectedId then
					vRP.GiveItem(Passport,"prescription-"..os.time().."-"..SelectedId.."-"..Passport,1,true)
					MedicamentCooldown[Passport] = os.time() + 600

					TriggerClientEvent("Notify",source,"Sucesso","Você pegou <b>1x</b> receita de <b>"..SelectedName.."</b>.","verde",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:ADRENALINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Adrenaline")
AddEventHandler("paramedic:Adrenaline",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local Adrenaline = vRP.ConsultItem(Passport,"adrenaline")
		local AdrenalinePlus = vRP.ConsultItem(Passport,"adrenalineplus")

		if not Adrenaline and not AdrenalinePlus then
			TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName("adrenaline").."</b>.","amarelo",5000)
		else
			if AdrenalinePlus and vRP.TakeItem(Passport,"adrenalineplus") then
				vSURVIVAL.UpdateCrawl(Entitys,115)
			elseif Adrenaline and vRP.TakeItem(Passport,"adrenaline") then
				if vSURVIVAL.CheckCrawl(Entitys) then
					vSURVIVAL.UpdateCrawl(Entitys,115)
				else
					TriggerClientEvent("Notify",source,"Adrenalina","Os batimentos cardiados não podem ser acelerados no momento.","amarelo",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:TREATMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Treatment")
AddEventHandler("paramedic:Treatment",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 and vRP.GetHealth(Entitys) > 100 then
		local OtherPassport = vRP.Passport(Entitys)
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			if vRP.TakeItem(Passport,"syringe0"..Identity["Blood"]) then
				if not Blood[OtherPassport] then
					Blood[OtherPassport] = os.time() + 1800
				end

				TriggerClientEvent("target:StartTreatment",Entitys)
				TriggerClientEvent("Notify",source,"Centro Médico","Tratamento começou.","sangue",5000)
			else
				TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName("syringe0"..Identity["Blood"]).."</b>.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:REVIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Revive")
AddEventHandler("paramedic:Revive",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(Entitys) <= 100 then
		if vRP.HasService(Passport,"Paramedic") then
			Player(source)["state"]["Cancel"] = true
			local OtherPassport = vRP.Passport(Entitys)
			TriggerClientEvent("Progress",source,"Reanimando",10000)
			vRPC.playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

			SetTimeout(10000,function()
				vRPC.Destroy(source)
				vRP.Revive(Entitys,101)
				vRP.UpgradeThirst(OtherPassport,10)
				vRP.UpgradeHunger(OtherPassport,10)
				Player(source)["state"]["Cancel"] = false
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:BANDAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Bandage")
AddEventHandler("paramedic:Bandage",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 and vRP.GetHealth(Entitys) > 100 then
		if vRP.HasService(Passport,"Paramedic") then
			if vCLIENT.Bleeding(Entitys) > 0 then
				if vRP.TakeItem(Passport,"gauze") then
					local Bandage = vCLIENT.Bandage(Entitys)
					TriggerClientEvent("Progress",source,"Passando",5000)
					vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)

					SetTimeout(3000,function()
						TriggerClientEvent("Notify",source,"Sucesso","Passou ataduras no(a) <b>"..Bandage.."</b>.","verde",5000)
						TriggerClientEvent("sounds:playSound",source,"paramedic-bandage","bandage",0.5,false)
						vRPC.Destroy(source)
					end)
				else
					TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>1x "..ItemName("gauze").."</b>.","amarelo",5000)
				end
			else
				TriggerClientEvent("Notify",source,"Atenção","Nenhum ferimento encontrado.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PARAMEDIC:DIAGNOSTIC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:Diagnostic")
AddEventHandler("paramedic:Diagnostic",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) > 100 then
		if vRP.HasService(Passport,"Paramedic") then
			local Result = ""
			local OtherPassport = vRP.Passport(Entity)
			local Identity = vRP.Identity(OtherPassport)
			if Identity then
				local Diagnostic,Bleeding = vCLIENT.Diagnostic(Entity)

				if Bleeding <= 1 then
					Result = "<b>Sangramento:</b> Baixo<br>"
				elseif Bleeding == 2 then
					Result = "<b>Sangramento:</b> Médio<br>"
				elseif Bleeding >= 3 then
					Result = "<b>Sangramento:</b> Alto<br>"
				end

				Result = Result.."<b>Tipo Sangüíneo:</b> "..Sanguine(Identity["Blood"])

				local Illness = Player(Entity).state.Illness
				if Illness and IllnessList[Illness] then
					Result = Result.."<br><br><b>Doença:</b> "..IllnessList[Illness].Name.."<br>"
					Result = Result.."<b>Cura Recomendada:</b> "..ItemName(IllnessList[Illness].Cure).."<br>"
				else
					Result = Result.."<br><br><b>Doença:</b> Nenhuma<br>"
				end

				local Number = 0
				local Damaged = false
				for Index,_ in pairs(Diagnostic) do
					if not Damaged then
						Result = Result.."<br><b>Danos Superficiais:</b><br>"
						Damaged = true
					end

					Number = Number + 1
					Result = Result.."<b>"..Number.."</b>: "..Bone(Index).."<br>"
				end

				TriggerClientEvent("Notify",source,"Ferimentos",Result,"amarelo",10000)
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
			["pants"] = { item = 56, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 16, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 57, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 16, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["2"] = {
		["mp_m_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 84, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 122, texture = 0 },
			["shoes"] = { item = 47, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 186, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 110, texture = 3 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mp_f_freemode_01"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 86, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["backpack"] = { item = 0, texture = 0 },
			["decals"] = { item = 90, texture = 0 },
			["mask"] = { item = 122, texture = 0 },
			["shoes"] = { item = 48, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 188, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 127, texture = 3 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETBURN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:presetBurn")
AddEventHandler("paramedic:presetBurn",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Emergency") then
		local Model = vRP.ModelPlayer(Entity)
		if Model == "mp_m_freemode_01" or "mp_f_freemode_01" then
			TriggerClientEvent("skinshop:Apply",Entity,Preset["1"][Model])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETPLASTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:presetPlaster")
AddEventHandler("paramedic:presetPlaster",function(Entity)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasService(Passport,"Emergency") then
		local Model = vRP.ModelPlayer(Entity)
		if Model == "mp_m_freemode_01" or "mp_f_freemode_01" then
			TriggerClientEvent("skinshop:Apply",Entity,Preset["2"][Model])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:EXTRACTBLOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:extractBlood")
AddEventHandler("paramedic:extractBlood",function(Entitys)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		local OtherPassport = vRP.Passport(Entitys)
		if OtherPassport and not Extract[OtherPassport] then
			Extract[OtherPassport] = true

			if vRP.GetHealth(Entitys) >= 170 then
				local Identity = vRP.Identity(OtherPassport)
				if Identity and vRP.Request(Entitys,"Centro Médico","Deseja iniciar a doação sangue?") then
					if not Blood[OtherPassport] then
						Blood[OtherPassport] = os.time()
					end

					if os.time() >= Blood[OtherPassport] then
						vRPC.DowngradeHealth(Entitys,50)
						Blood[OtherPassport] = os.time() + 10800
						vRP.GenerateItem(Passport,"syringe0"..Identity["Blood"],5,true)

						if Extract[OtherPassport] then
							Extract[OtherPassport] = nil
						end
					else
						TriggerClientEvent("Notify",source,"Atenção","No momento não é possível efetuar a extração, o mesmo ainda está se recuperando ou se acidentou recentemente.","amarelo",10000)
					end
				end
			else
				TriggerClientEvent("Notify",source,"Aviso","Sistema imunológico do paciente muito fraco.","amarelo",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:BLOODDEATH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("paramedic:bloodDeath")
AddEventHandler("paramedic:bloodDeath",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		Blood[Passport] = os.time() + 10800
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Active[Passport] then
		Active[Passport] = nil
	end

	if Extract[Passport] then
		Extract[Passport] = nil
	end
end)