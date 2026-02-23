-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("propertys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blips = {}
local MyBlips = {}
local HotelBlip = nil
local Inside = false
local Opened = false
local Policed = false
local Stealing = false
local Interior = false
local RobbedItems = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Pid = PlayerId()
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			if not Inside then
				for Name,v in pairs(Propertys) do
					local Distance = #(Coords - v.Coords)
					
					if Distance <= 3.0 then
						TimeDistance = 1
						SetDrawOrigin(v.Coords.x,v.Coords.y,v.Coords.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end

					if Distance <= 0.75 then
						if IsControlJustPressed(1,38) then
							local Consult = vSERVER.Propertys(Name)

							if Consult then
								if Consult == "Nothing" then
									if not Propertys[Name].Galpao then
										exports.dynamic:AddButton("Invadir","Forçar a fechadura.","propertys:Robbery",Name,false,true)
									end

									for Line,v in pairs(Informations) do
										if (Propertys[Name].Galpao and Line == "Galpao") or (not Propertys[Name].Galpao and Line ~= "Galpao") then
											exports.dynamic:AddMenu(Line,"Informações sobre o interior.",Line)

											if v.Vault then
												exports.dynamic:AddButton("Baú","Total de <yellow>"..v.Vault.."Kg</yellow> no compartimento.","","",Line,false)
											end

											if v.Fridge then
												exports.dynamic:AddButton("Geladeira","Total de <yellow>"..v.Fridge.."Kg</yellow> no compartimento.","","",Line,false)
											end

											exports.dynamic:AddButton("Credenciais","Máximo <yellow>1</yellow> proprietário e <yellow>3</yellow> adicionais.","","",Line,false)
											exports.dynamic:AddButton("Comprar com Dinheiro","Custo de <yellow>"..Currency..Dotted(v.Price).."</yellow>.","propertys:Buy",Name.."-"..Line.."-Dollar",Line,true)
											exports.dynamic:AddButton("Comprar com Diamantes","Custo de <yellow>"..Dotted(v.Gemstone).."</yellow>.","propertys:Buy",Name.."-"..Line.."-Gemstone",Line,true)
										end
									end

									exports.dynamic:Open()
								else
									if Consult ~= "Hotel" then
										Interior = Consult.Interior

										exports.dynamic:AddButton("Entrar","Adentrar a propriedade.","propertys:Enter",Name,false,false)
										exports.dynamic:AddButton("Cartões","Comprar um novo cartão de acesso.","propertys:Item",Name,false,true)
										exports.dynamic:AddButton("Fechadura","Trancar/Destrancar a propriedade.","propertys:Lock",Name,false,true)
										exports.dynamic:AddButton("Credenciais","Reconfigurar os cartões de acesso.","propertys:Credentials",Name,false,true)

										if Interior ~= "Galpao" and Interior ~= "Amber" then
											exports.dynamic:AddMenu("Interior","Trocar interior da propriedade.<br><yellow>O peso do baú permanece o mesmo.</yellow>","interior")

											local Valuation = Informations[Interior].Gemstone
											for Line,v in pairs(Informations) do
												local InteriorValuation = Informations[Line].Gemstone
												if Line ~= "Galpao" and InteriorValuation > Valuation then
													exports.dynamic:AddButton(Line,"Custo de <yellow>"..Dotted(InteriorValuation - Valuation).." diamantes</yellow>.","propertys:Interior",Name.."-"..Line,"interior",true)
												end
											end
										end

										exports.dynamic:AddButton("Garagem","Adicionar/Reajustar a garagem.","garages:Propertys",Name,false,true)
										exports.dynamic:AddButton("Vender","Se desfazer da propriedade.","propertys:Sell",Name,false,true)
										exports.dynamic:AddButton("Transferência","Mudar proprietário.","propertys:Transfer",Name,false,true)
										exports.dynamic:AddButton("Hipoteca",Consult.Tax,"","",false,false)

										exports.dynamic:Open()
									else
										Interior = "Hotel"
										TriggerEvent("propertys:Enter",Name,false)
									end
								end
							else
								if Name == "Hotel" then
									TriggerEvent("Notify","Hotel","Você não possui acesso ao hotel pois já possui propriedade(s).","amarelo",10000)
								elseif not Propertys[Name].Galpao then
									exports.dynamic:AddButton("Invadir","Forçar a fechadura.","propertys:Robbery",Name,false,true)
									exports.dynamic:Open()
								end
							end
						end
					end
				end
			elseif Inside and Interior and Propertys[Inside] and Internal[Interior] then
				SetPlayerBlipPositionThisFrame(Propertys[Inside].Coords.x,Propertys[Inside].Coords.y)

				if Internal[Interior] and Internal[Interior].Exit and Coords.z < (Internal[Interior].Exit.z - 25.0) then
					SetEntityCoords(Ped,Internal[Interior].Exit,false,false,false,false)
				end

				if Internal[Interior] and Internal[Interior].Furniture and Policed and Policed <= GetGameTimer() and (GetPedMovementClipset(Ped) ~= -1155413492 or IsPedSprinting(Ped) or MumbleIsPlayerTalking(Pid)) then
					vSERVER.Police(Propertys[Inside].Coords,Coords)
					Policed = GetGameTimer() + 15000
				end

				if Internal[Interior] and Internal[Interior].Exit then
					if #(Coords - Internal[Interior].Exit) <= 3.0 then
						SetDrawOrigin(Internal[Interior].Exit.x,Internal[Interior].Exit.y,Internal[Interior].Exit.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end

					if #(Coords - Internal[Interior].Exit) <= 1.0 and IsControlJustPressed(1,38) then
						SetEntityCoords(Ped,Propertys[Inside].Coords,false,false,false,false)
						vSERVER.Toggle(Inside,"Exit")
						Interior = false
						Stealing = false
						Policed = false
						Inside = false
						RobbedItems = {}
					end
				end

				if Interior and Internal[Interior] and Internal[Interior].Vault and not Stealing then
					if #(Coords - Internal[Interior].Vault) <= 3.0 then
						SetDrawOrigin(Internal[Interior].Vault.x,Internal[Interior].Vault.y,Internal[Interior].Vault.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end

					if #(Coords - Internal[Interior].Vault) <= 1.0 and IsControlJustPressed(1,38) and vSERVER.Permission(Inside) then
						Opened = "Vault"
						vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
						TriggerEvent("inventory:Open",{
							Type = "Chest",
							Resource = "propertys",
							Right = "Cofre"
						})
					end
				end

				if Interior and Internal[Interior] and Internal[Interior].Fridge and not Stealing then
					if #(Coords - Internal[Interior].Fridge) <= 3.0 then
						SetDrawOrigin(Internal[Interior].Fridge.x,Internal[Interior].Fridge.y,Internal[Interior].Fridge.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end

					if #(Coords - Internal[Interior].Fridge) <= 1.0 and IsControlJustPressed(1,38) and vSERVER.Permission(Inside) then
						Opened = "Fridge"
						vRP.playAnim(false,{"amb@prop_human_bum_bin@base","base"},true)
						TriggerEvent("inventory:Open",{
							Type = "Chest",
							Resource = "propertys",
							Right = "Geladeira"
						})
					end
				end

				if Interior and Internal[Interior] and Internal[Interior].Clothes and not Stealing then
					if #(Coords - Internal[Interior].Clothes) <= 3.0 then
						SetDrawOrigin(Internal[Interior].Clothes.x,Internal[Interior].Clothes.y,Internal[Interior].Clothes.z)
						DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
						ClearDrawOrigin()
					end

					if #(Coords - Internal[Interior].Clothes) <= 1.0 and IsControlJustPressed(1,38) then
						exports.dynamic:AddMenu("Armário","Abrir lista com todas as vestimentas.","wardrobe")
						exports.dynamic:AddButton("Shopping","Abrir a loja de vestimentas.","skinshop:Open","",false,false)
						exports.dynamic:AddButton("Guardar","Salvar vestimentas do corpo.","propertys:Clothes","Save","wardrobe",true)

						local Clothes = vSERVER.Clothes()
						if #Clothes > 0 then
							for Index,v in pairs(Clothes) do
								exports.dynamic:AddMenu(v,"Informações da vestimenta.",Index,"wardrobe")
								exports.dynamic:AddButton("Aplicar","Vestir-se com as vestimentas.","propertys:Clothes","Apply-"..v,Index,true)
								exports.dynamic:AddButton("Remover","Deletar a vestimenta do armário.","propertys:Clothes","Delete-"..v,Index,true,true)
							end
						end

					exports.dynamic:Open()
				end
			end

			if Stealing and Internal[Interior] and Internal[Interior].Furniture and Inside then
				for Number,v in pairs(Internal[Interior].Furniture) do
					local Key = Inside..":"..Number
					if not RobbedItems[Key] then
						if #(Coords - v) <= 3.0 then
							SetDrawOrigin(v.x,v.y,v.z)
							DrawSprite("Textures","EPress",0.0,0.0,0.053,0.01 * GetAspectRatio(false),0.0,255,255,255,255)
							ClearDrawOrigin()
						end

						if #(Coords - v) <= 1.0 and IsControlJustPressed(1,38) then
							if Inside then
								TriggerServerEvent("propertys:RobberyItem",tostring(Number),Inside)
							end
						end
					end
				end
			end

			TimeDistance = 1
		end
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:ENTER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Enter")
AddEventHandler("propertys:Enter",function(Name,Theft)
	if Theft then
		Stealing = true
		Interior = Theft
		Policed = GetGameTimer() + 15000
		RobbedItems = {}
		TriggerEvent("player:Residual","Resquício de Línter")
	end

	Inside = Name
	local Ped = PlayerPedId()
	TriggerEvent("dynamic:Close")
	vSERVER.Toggle(Inside,"Enter")
	SetEntityCoords(Ped,Internal[Interior].Exit,false,false,false,false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Mount",function(Data,Callback)
	local Primary,Secondary,PrimaryWeight,SecondaryWeight = vSERVER.Mount(Inside,Opened)
	if Primary then
		Callback({ Primary = Primary, Secondary = Secondary, PrimaryMaxWeight = PrimaryWeight, SecondaryMaxWeight = SecondaryWeight, SecondarySlots = math.max(CountTable(Secondary),100) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	if Opened then
		Opened = false
		vRP.Destroy()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:REMCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:RemCircleZone")
AddEventHandler("propertys:RemCircleZone",function(Index)
	if Inside and Index then
		RobbedItems[Inside..":"..Index] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Take",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Take(Data.slot,Data.amount,Data.target,Inside,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Store",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Store(Data.item,Data.slot,Data.amount,Data.target,Inside,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	if MumbleIsConnected() then
		vSERVER.Update(Data.slot,Data.target,Data.amount,Inside,Opened)
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEHOTELBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdateHotelBlip(HasAccess)
	if HasAccess then
		if not HotelBlip and Propertys["Hotel"] then
			HotelBlip = AddBlipForCoord(Propertys["Hotel"].Coords.x, Propertys["Hotel"].Coords.y, Propertys["Hotel"].Coords.z)
			SetBlipSprite(HotelBlip, 475)
			SetBlipDisplay(HotelBlip, 4)
			SetBlipAsShortRange(HotelBlip, true)
			SetBlipColour(HotelBlip, 26)
			SetBlipScale(HotelBlip, 0.6)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentSubstringPlayerName("Hotel")
			EndTextCommandSetBlipName(HotelBlip)
		end
	else
		if HotelBlip and DoesBlipExist(HotelBlip) then
			RemoveBlip(HotelBlip)
			HotelBlip = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:HOTELACCESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:HotelAccess")
AddEventHandler("propertys:HotelAccess",function(HasAccess)
	UpdateHotelBlip(HasAccess)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:Blips")
AddEventHandler("propertys:Blips",function()
	if next(Blips) ~= nil then
		for _,v in pairs(Blips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		TriggerEvent("Notify","Propriedades","Marcações desativadas.","default",10000)
		Blips = {}
	else
		local Markers = vSERVER.Markers()
		for Name,v in pairs(Propertys) do
			if Name ~= "Hotel" then
				Blips[Name] = AddBlipForCoord(v.Coords)

				if v.Galpao then
					SetBlipSprite(Blips[Name],473)
				else
					SetBlipSprite(Blips[Name],374)
				end

				SetBlipScale(Blips[Name],0.5)
				SetBlipAsShortRange(Blips[Name],true)
				SetBlipColour(Blips[Name],Markers[Name] and 35 or 43)
			end
		end

		TriggerEvent("Notify","Propriedades","Marcações ativadas.","default",10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:MYBLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("propertys:MyBlips")
AddEventHandler("propertys:MyBlips",function()
	if next(MyBlips) ~= nil then
		for _,v in pairs(MyBlips) do
			if DoesBlipExist(v) then
				RemoveBlip(v)
			end
		end

		TriggerEvent("Notify","Propriedades","Suas residências desativadas.","default",10000)
		MyBlips = {}
	else
		local MyPropertys = vSERVER.MyPropertys()

		if MyPropertys and next(MyPropertys) ~= nil then
			for Name,v in pairs(Propertys) do
				if Name ~= "Hotel" and MyPropertys[Name] then
					MyBlips[Name] = AddBlipForCoord(v.Coords)

					if v.Galpao then
						SetBlipSprite(MyBlips[Name], 473)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Meu Galpão")
						EndTextCommandSetBlipName(MyBlips[Name])
					else
						SetBlipSprite(MyBlips[Name], 374)
						BeginTextCommandSetBlipName("STRING")
						AddTextComponentString("Minha Residência")
						EndTextCommandSetBlipName(MyBlips[Name])
					end

					SetBlipScale(MyBlips[Name], 0.6)
					SetBlipAsShortRange(MyBlips[Name], false)
					SetBlipColour(MyBlips[Name], 2)
					SetBlipDisplay(MyBlips[Name], 4)
				end
			end

			TriggerEvent("Notify","Propriedades","Suas residências ativadas.","default",10000)
		else
			TriggerEvent("Notify","Propriedades","Você não possui propriedades.","amarelo",10000)
		end
	end
end)