-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dynamic")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Dynamic = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton",function(Title,Description,Trigger,Param,ParentId,Server,Back)
	SendNUIMessage({ Action = "AddButton", Payload = { Title = Title, Description = Description, Trigger = Trigger, Param = Param, ParentId = ParentId, Server = Server, Back = Back } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddMenu",function(Title,Description,Id,ParentId)
	SendNUIMessage({ Action = "AddMenu", Payload = { Title = Title, Description = Description, Id = Id, ParentId = ParentId } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:AddButton")
AddEventHandler("dynamic:AddButton",function(Title,Description,Trigger,Param,ParentId,Server,Back)
	SendNUIMessage({ Action = "AddButton", Payload = { Title = Title, Description = Description, Trigger = Trigger, Param = Param, ParentId = ParentId, Server = Server, Back = Back } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:ADDMENU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:AddMenu")
AddEventHandler("dynamic:AddMenu",function(Title,Description,Id,ParentId)
	SendNUIMessage({ Action = "AddMenu", Payload = { Title = Title, Description = Description, Id = Id, ParentId = ParentId } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Open",function()
	SendNUIMessage({ Action = "Open" })
	TriggerEvent("hud:Active",false)
	SetNuiFocus(true,true)
	Dynamic = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Clicked",function(Data,Callback)
	if Data["Trigger"] and Data["Trigger"] ~= "" then
		if Data["Server"] then
			TriggerServerEvent(Data["Trigger"],Data["Param"])
		else
			TriggerEvent(Data["Trigger"],Data["Param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	TriggerEvent("hud:Active",true)
	SetNuiFocus(false,false)
	Dynamic = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:Close")
AddEventHandler("dynamic:Close",function()
	if Dynamic then
		SendNUIMessage({ Action = "Close" })
		TriggerEvent("hud:Active",true)
		SetNuiFocus(false,false)
		Dynamic = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("PlayerFunctions",function()
	local Ped = PlayerPedId()
	if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not Dynamic and not IsPauseMenuActive() and GetEntityHealth(Ped) > 100 then
		exports.dynamic:AddMenu("Andar","Mude o seu estilo de andar.","walks")
		exports.dynamic:AddButton("Normal","Voltar ao padrão.","player:ResetWalk","","walks",true)
		exports.dynamic:AddButton("Rápido","Passos acelerados.","player:SetWalk","move_m@quick","walks",true)
		exports.dynamic:AddButton("Corrida Leve","Caminhada em ritmo de trote.","player:SetWalk","move_m@jog@","walks",true)
		exports.dynamic:AddButton("Sexy","Ande de forma sensual.","player:SetWalk","move_f@sexy@a","walks",true)
		exports.dynamic:AddButton("Elegante","Estilo refinado e chique.","player:SetWalk","move_f@posh@","walks",true)
		exports.dynamic:AddButton("Confiante (F)","Postura confiante feminina.","player:SetWalk","move_f@arrogant@a","walks",true)
		exports.dynamic:AddButton("Assustada","Demonstra medo ao andar.","player:SetWalk","move_f@scared","walks",true)
		exports.dynamic:AddButton("Apavorada","Corrida em pânico.","player:SetWalk","move_f@flee@a","walks",true)
		exports.dynamic:AddButton("Femme Fatale","Estilo dominante.","player:SetWalk","move_f@femme@","walks",true)
		exports.dynamic:AddButton("Saltos","Caminhada de salto alto.","player:SetWalk","move_f@heels@c","walks",true)
		exports.dynamic:AddButton("Atitude Feminina","Postura forte.","player:SetWalk","move_f@tough_guy@","walks",true)
		exports.dynamic:AddButton("Apresentável","Caminhada charmosa.","player:SetWalk","move_f@sassy","walks",true)
		exports.dynamic:AddButton("Apressada","Andando com pressa.","player:SetWalk","move_f@hurry@a","walks",true)
		exports.dynamic:AddButton("Valente","Postura corajosa.","player:SetWalk","move_m@brave","walks",true)
		exports.dynamic:AddButton("Confiante","Caminhada firme.","player:SetWalk","move_m@confident","walks",true)
		exports.dynamic:AddButton("Rico","Estilo de magnata.","player:SetWalk","move_m@money","walks",true)
		exports.dynamic:AddButton("Arrogante","Estilo exibido.","player:SetWalk","move_m@swagger","walks",true)
		exports.dynamic:AddButton("Durão","Postura intimidadora.","player:SetWalk","move_m@tough_guy@","walks",true)
		exports.dynamic:AddButton("Suspeito","Caminhada disfarçada.","player:SetWalk","move_m@shadyped@a","walks",true)
		exports.dynamic:AddButton("Policial","Caminhada policial.","player:SetWalk","move_m@intimidation@cop@unarmed","walks",true)
		exports.dynamic:AddButton("Executivo A","Estilo corporativo.","player:SetWalk","move_m@business@a","walks",true)
		exports.dynamic:AddButton("Executivo B","Estilo corporativo.","player:SetWalk","move_m@business@b","walks",true)
		exports.dynamic:AddButton("Executivo C","Estilo corporativo.","player:SetWalk","move_m@business@c","walks",true)
		exports.dynamic:AddButton("Bandido","Caminhada de gangster.","player:SetWalk","move_m@gangster@generic","walks",true)
		exports.dynamic:AddButton("Gangster NG","Estilo de rua.","player:SetWalk","move_m@gangster@ng","walks",true)
		exports.dynamic:AddButton("Gangster E","Postura criminosa.","player:SetWalk","move_m@gangster@var_e","walks",true)
		exports.dynamic:AddButton("Gangster F","Postura criminosa.","player:SetWalk","move_m@gangster@var_f","walks",true)
		exports.dynamic:AddButton("Gangster I","Postura criminosa.","player:SetWalk","move_m@gangster@var_i","walks",true)
		exports.dynamic:AddButton("Bêbado","Totalmente bêbado.","player:SetWalk","move_m@drunk@verydrunk","walks",true)
		exports.dynamic:AddButton("Alcoolizado","Levemente bêbado.","player:SetWalk","move_m@drunk@slightlydrunk","walks",true)
		exports.dynamic:AddButton("Embriagado","Bêbado moderado.","player:SetWalk","move_m@drunk@a","walks",true)
		exports.dynamic:AddButton("Chapado","Sob efeito de drogas.","player:SetWalk","move_m@buzzed","walks",true)
		exports.dynamic:AddButton("Casual A","Estilo comum.","player:SetWalk","move_m@casual@a","walks",true)
		exports.dynamic:AddButton("Casual B","Estilo comum.","player:SetWalk","move_m@casual@b","walks",true)
		exports.dynamic:AddButton("Casual C","Estilo comum.","player:SetWalk","move_m@casual@c","walks",true)
		exports.dynamic:AddButton("Casual D","Estilo comum.","player:SetWalk","move_m@casual@d","walks",true)
		exports.dynamic:AddButton("Casual E","Estilo comum.","player:SetWalk","move_m@casual@e","walks",true)
		exports.dynamic:AddButton("Casual F","Estilo comum.","player:SetWalk","move_m@casual@f","walks",true)
		exports.dynamic:AddButton("Hipster","Estilo moderno.","player:SetWalk","move_m@hipster@a","walks",true)
		exports.dynamic:AddButton("Trabalhador","Andar simples.","player:SetWalk","move_m@hobo@a","walks",true)
		exports.dynamic:AddButton("Triste","Andar abatido.","player:SetWalk","move_m@sad@a","walks",true)
		exports.dynamic:AddButton("Zé do Lixo","Postura cansada.","player:SetWalk","move_p_m_zero","walks",true)
		exports.dynamic:AddButton("Zelador","Postura simples.","player:SetWalk","move_p_m_zero_janitor","walks",true)
		exports.dynamic:AddButton("Lento","Movimentos lentos.","player:SetWalk","move_p_m_zero_slow","walks",true)
		exports.dynamic:AddButton("Operário","Postura pesada.","player:SetWalk","move_p_m_two","walks",true)
		exports.dynamic:AddButton("Alien","Movimentos estranhos.","player:SetWalk","move_m@alien","walks",true)
		exports.dynamic:AddButton("Jimmy","Caminhada arrastada.","player:SetWalk","move_characters@jimmy@slow@","walks",true)
		exports.dynamic:AddButton("Em Chamas (F)","Personagem queimando.","player:SetWalk","move_characters@franklin@fire","walks",true)
		exports.dynamic:AddButton("Em Chamas (M)","Personagem queimando.","player:SetWalk","move_characters@michael@fire","walks",true)
		exports.dynamic:AddButton("Pegando Fogo","Movimento em chamas.","player:SetWalk","move_m@fire","walks",true)
		exports.dynamic:AddButton("Corredora","Passos femininos rápidos.","player:SetWalk","female_fast_runner","walks",true)
		exports.dynamic:AddButton("Groove","Andar estilizado.","player:SetWalk","anim@move_m@grooving@","walks",true)
		exports.dynamic:AddButton("Ballistic","Movimento agressivo.","player:SetWalk","anim_group_move_ballistic","walks",true)
		exports.dynamic:AddButton("Lemar","Caminhada de rua.","player:SetWalk","anim_group_move_lemar_alley","walks",true)

		exports.dynamic:AddMenu("Armário","Abrir lista com todas as vestimentas.","wardrobe")
		exports.dynamic:AddButton("Guardar","Salvar vestimentas do corpo.","dynamic:Clothes","Save","wardrobe",true)

		if not LocalPlayer["state"]["Prison"] then
			local Clothes = vSERVER.Clothes()
			if parseInt(#Clothes) > 0 then
				for Index,v in pairs(Clothes) do
					exports.dynamic:AddMenu(v,"Informações da vestimenta.",Index,"wardrobe")
					exports.dynamic:AddButton("Aplicar","Vestir-se com as vestimentas.","dynamic:Clothes","Apply-"..v,Index,true)
					exports.dynamic:AddButton("Remover","Deletar a vestimenta do armário.","dynamic:Clothes","Delete-"..v,Index,true,true)
				end
			end

			exports.dynamic:AddMenu("Roupas","Colocar/Retirar roupas.","clothes")
			exports.dynamic:AddButton("Chapéu","Colocar/Retirar o chapéu.","player:Outfit","Hat","clothes",true)
			exports.dynamic:AddButton("Máscara","Colocar/Retirar a máscara.","player:Outfit","Mask","clothes",true)
			exports.dynamic:AddButton("Óculos","Colocar/Retirar o óculos.","player:Outfit","Glasses","clothes",true)
			exports.dynamic:AddButton("Camisa","Colocar/Retirar a camisa.","player:Outfit","Shirt","clothes",true)
			exports.dynamic:AddButton("Jaqueta","Colocar/Retirar a jaqueta.","player:Outfit","Torso","clothes",true)
			exports.dynamic:AddButton("Luvas","Colocar/Retirar as luvas.","player:Outfit","Arms","clothes",true)
			exports.dynamic:AddButton("Colete","Colocar/Retirar o colete.","player:Outfit","Vest","clothes",true)
			exports.dynamic:AddButton("Calça","Colocar/Retirar a calça.","player:Outfit","Pants","clothes",true)
			exports.dynamic:AddButton("Sapatos","Colocar/Retirar o sapato.","player:Outfit","Shoes","clothes",true)
			exports.dynamic:AddButton("Acessórios","Colocar/Retirar os acessórios.","player:Outfit","Accessory","clothes",true)
			exports.dynamic:AddButton("Enviar","Vestir roupas no próximo.","skinshop:Send","","clothes",true)
		end

		if vRP.ClosestVehicle(7) then
			if not IsPedInAnyVehicle(Ped) then
				local Vehicle = GetLastDrivenVehicle()
				if Vehicle and IsThisModelABoat(GetEntityModel(Vehicle)) then
					exports.dynamic:AddButton("Ancorar","Prender/Desprender a embarcação.","player:Anchor",Vehicle,false,false)
				end

				if vRP.ClosestPed(3) then
					exports.dynamic:AddMenu("Jogador","Pessoa mais próxima de você.","closestpeds")
					exports.dynamic:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","closestpeds",true)
					exports.dynamic:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","closestpeds",true)
				end
			else
				exports.dynamic:AddMenu("Veículo","Funções do veículo.","vehicle")
				exports.dynamic:AddButton("Sentar no Motorista","Sentar no banco do motorista.","player:seatPlayer","0","vehicle",false)
				exports.dynamic:AddButton("Sentar no Passageiro","Sentar no banco do passageiro.","player:seatPlayer","1","vehicle",false)
				exports.dynamic:AddButton("Sentar em Outros","Sentar no banco do passageiro.","player:seatPlayer","2","vehicle",false)
				exports.dynamic:AddButton("Mexer nos Vidros","Levantar/Abaixar os vidros.","player:Windows","","vehicle",false)
			end

			exports.dynamic:AddMenu("Portas","Portas do veículo.","doors")
			exports.dynamic:AddButton("Porta do Motorista","Abrir porta do motorista.","player:Doors","1","doors",true)
			exports.dynamic:AddButton("Porta do Passageiro","Abrir porta do passageiro.","player:Doors","2","doors",true)
			exports.dynamic:AddButton("Porta Traseira Esquerda","Abrir porta traseira esquerda.","player:Doors","3","doors",true)
			exports.dynamic:AddButton("Porta Traseira Direita","Abrir porta traseira direita.","player:Doors","4","doors",true)
			exports.dynamic:AddButton("Porta-Malas","Abrir porta-malas.","player:Doors","5","doors",true)
			exports.dynamic:AddButton("Capô","Abrir capô.","player:Doors","6","doors",true)
		end

		local Painels = 0
		for Permission,v in pairs(Groups) do
			if not v.Block and LocalPlayer.state[Permission] then
				if Painels == 0 then
					exports.dynamic:AddMenu("Computador","Abrir o software dos grupos.","painel")
				end

				local Events = { LSPD = "mdt:Open", PRPD = "mdt:Open", Paramedic = "ems:Open" }
				local Event = Events[Permission] or "painel:Open"

				exports.dynamic:AddButton(v.Name or Permission,"Painel de Controle do usuário.",Event,Permission,"painel",true)

				Painels = Painels + 1
			end
		end

		exports.dynamic:AddMenu("Outros","Todas as funções do personagem.","others")
		exports.dynamic:AddButton("Desbugar","Recarregar o personagem.","player:Debug","","others",true)
		exports.dynamic:AddButton("Ferimentos","Verificar ferimentos no corpo.","paramedic:Injuries","","others",false)

		if not LocalPlayer["state"]["Prison"] then
			exports.dynamic:AddButton("Lixeiro","Marcar/Desmarcar sacos no mapa.","farmer:Blips","","others",false)
			exports.dynamic:AddButton("Propriedades","Marcar/Desmarcar propriedades no mapa.","propertys:Blips","","others",false)
			exports.dynamic:AddButton("Minhas Residências","Marcar/Desmarcar suas residências no mapa.","propertys:MyBlips","","others",false)
		end

		TriggerEvent("animals:Dynamic")

		exports.dynamic:Open()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("EmergencyFunctions",function()
	if not IsPauseMenuActive() and not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not Dynamic then
		local Ped = PlayerPedId()
		local Health = GetEntityHealth(Ped)

		if CheckPolice() then
			if GetResourceState("perimeter") == "started" then
				TriggerEvent("perimeter:Dynamic")
			end

			exports.dynamic:AddButton("Placa","Verificar emplacamento.","prison:Plate","",false,true)

			exports.dynamic:AddMenu("Emergência","Avisos emergenciais.","tencode")
			exports.dynamic:AddButton("10-13","Oficial desmaiado/ferido.","dynamic:Tencode","13","tencode",true)
			exports.dynamic:AddButton("10-20","Localização.","dynamic:Tencode","20","tencode",true)
			exports.dynamic:AddButton("10-38","Abordagem de trânsito.","dynamic:Tencode","38","tencode",true)
			exports.dynamic:AddButton("10-78","Apoio com prioridade.","dynamic:Tencode","78","tencode",true)

			if Health > 100 and not IsPedInAnyVehicle(Ped) then
				exports.dynamic:AddMenu("Jogador","Pessoa mais próxima de você.","player")
				exports.dynamic:AddButton("Carregar","Carregar a pessoa mais próxima.","inventory:Carry","","player",true)
				exports.dynamic:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","player",true)
				exports.dynamic:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","player",true)
				exports.dynamic:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:Remove","Hat","player",true)
				exports.dynamic:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:Remove","Mask","player",true)
				exports.dynamic:AddButton("Remover Óculos","Remover da pessoa mais próxima.","skinshop:Remove","Glasses","player",true)

				exports.dynamic:AddMenu("Fardamentos","Todos os fardamentos policiais.","prePolice")
				exports.dynamic:AddButton("Principal","Fardamento de oficial.","player:Preset","1","prePolice",true)
			end

			exports.dynamic:Open()
		elseif LocalPlayer["state"]["Paramedic"] and Health > 100 and not IsPedInAnyVehicle(Ped) then
			exports.dynamic:AddMenu("Jogador","Pessoa mais próxima de você.","player")
			exports.dynamic:AddButton("Carregar","Carregar a pessoa mais próxima.","inventory:Carry","","player",true)
			exports.dynamic:AddButton("Colocar no Veículo","Colocar no veículo mais próximo.","player:cvFunctions","cv","player",true)
			exports.dynamic:AddButton("Remover do Veículo","Remover do veículo mais próximo.","player:cvFunctions","rv","player",true)
			exports.dynamic:AddButton("Remover Chapéu","Remover da pessoa mais próxima.","skinshop:Remove","Hat","player",true)
			exports.dynamic:AddButton("Remover Máscara","Remover da pessoa mais próxima.","skinshop:Remove","Mask","player",true)
			exports.dynamic:AddButton("Remover Óculos","Remover da pessoa mais próxima.","skinshop:Remove","Glasses","player",true)

			exports.dynamic:AddMenu("Fardamentos","Todos os fardamentos médicos.","preMedic")
			exports.dynamic:AddButton("Principal","Fardamento de oficial.","player:Preset","2","preMedic",true)

			exports.dynamic:Open()
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("PlayerFunctions","Abrir menu principal.","keyboard","F9")
RegisterKeyMapping("EmergencyFunctions","Abrir menu de emergencial.","keyboard","F10")