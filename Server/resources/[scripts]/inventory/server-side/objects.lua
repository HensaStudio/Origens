-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Delay = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEFAULT
-----------------------------------------------------------------------------------------------------------------------------------------
local Default = {
	-- ROBBERY AMMUNATION
	{ ["Coords"] = { 256.35,-47.51,69.7,249.76 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 846.13,-1036.62,27.95,178.74 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -335.18,6083.29,31.21,45.57 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -665.98,-932.24,21.58,358.38 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -1301.93,-391.36,36.45,255.85 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -1122.59,2698.25,18.31,42.82 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 2571.67,291.28,108.49,180.02 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 2571.66,291.29,108.49,181.06 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 19.57,-1103.0,29.55,339.07 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 813.92,-2160.34,29.37,179.33 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 1688.78,3759.13,34.46,47.5 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },

	-- ROBBERY DEPARTMENT
	{ ["Coords"] = { 28.18,-1338.55,29.24,359.45 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 2548.61,384.87,108.36,87.98 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 1159.12,-316.72,68.95,100.36 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -710.58,-906.72,18.96,90.17 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -45.73,-1749.8,29.17,50.77 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 378.3,334.01,103.31,346.27 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -3250.66,1004.43,12.57,85.32 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 1735.06,6421.41,34.78,333.6 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 546.53,2662.18,41.89,186.7 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 1958.93,3749.46,32.09,30.17 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 2672.21,3286.9,54.98,61.68 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 1706.27,4922.6,41.81,324.6 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -1828.06,796.31,137.93,132.2 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { -3048.43,585.41,7.66,106.96 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },

	-- PROPERTYS
	{ ["Coords"] = { 21.28,-34.47,-24.25,231.47 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 98.89,-107.51,-24.45,224.95 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 91.47,74.95,-24.26,269.15 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 165.72,-152.01,-18.05,214.77 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 121.21,-116.41,-31.46,186.32 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 188.09,-202.5,-24.25,89.74 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },
	{ ["Coords"] = { 51.0,-43.67,-24.28,52.65 }, ["Object"] = "p_v_43_safe_s", ["Ground"] = true },

	-- SLOTMACHINE
	{ ["Coords"] = { 984.25,64.95,122.12,149.36 }, ["Object"] = "vw_prop_casino_slot_04a", ["Ground"] = true },

	-- ADMIN
	{ ["Coords"] = { 268.53,2861.36,42.65,31.46 }, ["Object"] = "prop_byard_machine03", ["Mode"] = "Recycle", Weight = 1.0 },
	{ ["Coords"] = { -179.99,6263.39,30.51,41.2 }, ["Object"] = "prop_byard_machine03", ["Mode"] = "Recycle", Weight = 1.0 },
	{ ["Coords"] = { 966.66,-1912.34,30.15,0.51 }, ["Object"] = "prop_byard_machine03", ["Mode"] = "Recycle", Weight = 1.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINITOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for _,v in pairs(Default) do
		repeat
			Selected = GenerateString("DDLLDDLL")
		until Selected and not Objects[Selected]

		Objects[Selected] = v
	end

	local Consult = vRP.Query("entitydata/GetData",{ Name = "SaveObjects" })
	SaveObjects = Consult and Consult[1] and json.decode(Consult[1].Information) or {}

	for Index,v in pairs(SaveObjects) do
		if v.Item and ItemDurability(v.Item) and vRP.CheckDamaged(v.Item) then
			SaveObjects[Index] = nil
		else
			Objects[Index] = v
		end
	end

	while true do
		local CurrentTimer = os.time()
		for Permission,v in pairs(Delay) do
			local Number = v.Number

			if v.Timer <= CurrentTimer and Objects[Number] then
				TriggerClientEvent("objects:Remover",-1,Number)

				SaveObjects[Number] = nil
				Delay[Permission] = nil
				Objects[Number] = nil
			end
		end

		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("objects",function(source,Message)
	local Passport = vRP.Passport(source)
	if not Passport or not Message[1] or not vRP.HasGroup(Passport,"Admin") then
		return false
	end

	local Hash = Message[1]
	local Success,Coords = vRPC.ObjectControlling(source,Hash)

	if Success and Coords then
		local Selected
		repeat
			Selected = GenerateString("DDLLDDLL")
		until Selected and not Objects[Selected]

		local Data = {
			Coords = Coords,
			Object = Hash,
			Mode = "Store",
			Ground = true,
			Bucket = GetPlayerRoutingBucket(source)
		}

		Objects[Selected] = Data
		TriggerClientEvent("objects:Adicionar",-1,Selected,Data)

		vRP.Archive("coordenadas.txt",json.encode(Data))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:STOREOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:StoreObjects")
AddEventHandler("inventory:StoreObjects",function(Number)
	local source = source
	local Object = Objects[Number]
	local Passport = vRP.Passport(source)

	if not Passport or not Object or Active[Passport] then
		return false
	end

	Active[Passport] = true

	local Coords = Object.Coords
	local CurrentTimer = os.time()
	local Permission = Object.Permission or false
	local IsAdmin = vRP.HasService(Passport,"Admin")

	if Object.Timer and Object.Timer >= CurrentTimer then
		TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Object.Timer - CurrentTimer)..".","amarelo",5000)
		Active[Passport] = nil
		return false
	end

	if Object.Mode ~= "Sprays" then
		local Item = Object.Item
		if Item and Item ~= "spikestrips" then
			if not IsAdmin and Object.Passport and Object.Passport ~= Passport then
				Active[Passport] = nil
				return false
			end

			if not vRP.MaxItens(Passport,Item) and vRP.CheckWeight(Passport,Item) then
				vRP.GiveItem(Passport,Item,1,true)
			else
				TriggerClientEvent("Notify",source,"Mochila Sobrecarregada","Sua recompensa caiu no chão.","amarelo",5000)
				exports.inventory:Drops(Passport,source,Item,1,true)
			end
		end

		TriggerClientEvent("objects:Remover",-1,Number)
		SaveObjects[Number] = nil
		Objects[Number] = nil
	else
		if not Delay[Permission] then
			Delay[Permission] = { Timer = CurrentTimer + 600, Number = Number }

			for _,OtherSource in pairs(vRP.NumPermission(Permission)) do
				async(function()
					vRPC.PlaySound(OtherSource,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
					TriggerClientEvent("NotifyPush",OtherSource,{ code = "Aviso", title = "Violação de Spray", x = Coords[1], y = Coords[2], z = Coords[3], color = 44 })
				end)
			end

			TriggerClientEvent("Notify",source,"Atenção","O grupo responsável foi avisado que o spray foi violado. Nos próximos <b>10 minutos</b> se ninguém proteger o mesmo será removido.","amarelo",10000)
		elseif vRP.HasService(Passport,Permission) then
			Delay[Permission] = nil
			TriggerClientEvent("Notify",source,"Atenção","Remoção cancelada.","amarelo",5000)
		end
	end

	Active[Passport] = nil
end)