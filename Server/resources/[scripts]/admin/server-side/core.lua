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
Tunnel.bindInterface("admin",Creative)
vCLIENT = Tunnel.getInterface("admin")
vHUD = Tunnel.getInterface("hud")
vKEYBOARD = Tunnel.getInterface("keyboard")
vSKINWEAPON = Tunnel.getInterface("skinweapon")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Spectate = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Quake"] = false
GlobalState["Blackout"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("passport",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		local Keyboard = vKEYBOARD.Secondary(source,"Atual","Novo")
		if Keyboard then
			local NewPassport = parseInt(Keyboard[2])
			local OtherPassport = parseInt(Keyboard[1])
			if NewPassport > 0 and OtherPassport > 0 then
				if vRP.Source(OtherPassport) then
					return TriggerClientEvent("Notify",source,"Atenção","O passaporte "..OtherPassport.." precisa estar desconectado.","amarelo",5000)
				end

				if not vRP.Identity(OtherPassport) then
					return TriggerClientEvent("Notify",source,"Atenção","O passaporte "..OtherPassport.." não existe.","amarelo",5000)
				end

				if vRP.Identity(NewPassport) then
					return TriggerClientEvent("Notify",source,"Atenção","O passaporte "..NewPassport.." já existe.","amarelo",5000)
				end

				local Vehicles = exports.oxmysql:query_async("SELECT * FROM vehicles WHERE Passport = ?",{ OtherPassport })
				if Vehicles and #Vehicles > 0 then
					for _,v in pairs(Vehicles) do
						local Trunkchest = vRP.GetSrvData("Trunkchest:"..OtherPassport..":"..v.Vehicle,true)
						vRP.SetSrvData("Trunkchest:"..NewPassport..":"..v.Vehicle,Trunkchest,true)
						vRP.RemSrvData("Trunkchest:"..OtherPassport..":"..v.Vehicle)
					end

					exports.oxmysql:update_async("UPDATE vehicles SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local NewEntitydata = "Personal:"..NewPassport
				local ActualEntitydata = "Personal:"..OtherPassport
				local Entitydata = exports.oxmysql:query_async("SELECT * FROM entitydata WHERE Name = ?",{ ActualEntitydata })
				if Entitydata and #Entitydata > 0 then
					exports.oxmysql:update_async("UPDATE entitydata SET Name = ? WHERE Name = ?",{ NewEntitydata,ActualEntitydata })
				end

				local Character = exports.oxmysql:query_async("SELECT * FROM characters WHERE id = ?",{ OtherPassport })
				if Character and #Character > 0 then
					exports.oxmysql:update_async("UPDATE characters SET id = ? WHERE id = ?",{ NewPassport,OtherPassport })
				end

				local Transactions = exports.oxmysql:query_async("SELECT * FROM transactions WHERE Passport = ?",{ OtherPassport })
				if Transactions and #Transactions > 0 then
					exports.oxmysql:update_async("UPDATE transactions SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Taxs = exports.oxmysql:query_async("SELECT * FROM taxs WHERE Passport = ?",{ OtherPassport })
				if Taxs and #Taxs > 0 then
					exports.oxmysql:update_async("UPDATE taxs SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Races = exports.oxmysql:query_async("SELECT * FROM races WHERE Passport = ?",{ OtherPassport })
				if Races and #Races > 0 then
					exports.oxmysql:update_async("UPDATE races SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Propertys = exports.oxmysql:query_async("SELECT * FROM propertys WHERE Passport = ?",{ OtherPassport })
				if Propertys and #Propertys > 0 then
					exports.oxmysql:update_async("UPDATE propertys SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Playerdata = exports.oxmysql:query_async("SELECT * FROM playerdata WHERE Passport = ?",{ OtherPassport })
				if Playerdata and #Playerdata > 0 then
					exports.oxmysql:update_async("UPDATE playerdata SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Painel_Transactions = exports.oxmysql:query_async("SELECT * FROM painel_creative_transactions WHERE Passport = ?",{ OtherPassport })
				if Painel_Transactions and #Painel_Transactions > 0 then
					exports.oxmysql:update_async("UPDATE painel_creative_transactions SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Painel_Transactions_Transfer = exports.oxmysql:query_async("SELECT * FROM painel_creative_transactions WHERE Transfer = ?",{ OtherPassport })
				if Painel_Transactions_Transfer and #Painel_Transactions_Transfer > 0 then
					exports.oxmysql:update_async("UPDATE painel_creative_transactions SET Transfer = ? WHERE Transfer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Arrest = exports.oxmysql:query_async("SELECT * FROM mdt_creative_arrest WHERE Passport = ?",{ OtherPassport })
				if MDT_Arrest and #MDT_Arrest > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_arrest SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Arrest_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_arrest WHERE Officer = ?",{ OtherPassport })
				if MDT_Arrest_Officer and #MDT_Arrest_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_arrest SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Fines = exports.oxmysql:query_async("SELECT * FROM mdt_creative_fines WHERE Passport = ?",{ OtherPassport })
				if MDT_Fines and #MDT_Fines > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_fines SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Fines_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_fines WHERE Officer = ?",{ OtherPassport })
				if MDT_Fines_Officer and #MDT_Fines_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_fines SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Medals_Officers = exports.oxmysql:query_async("SELECT * FROM mdt_creative_medals")
				if MDT_Medals_Officers and #MDT_Medals_Officers > 0 then
					for _,v in pairs(MDT_Medals_Officers) do
						local Updated = false
						local Officers = json.decode(v.Officers) or {}
						local CleanedOfficers = {}
						
						-- Garante que Officers seja um array limpo (sem chaves booleanas)
						if type(Officers) == "table" then
							for _,Number in ipairs(Officers) do
								if type(Number) == "number" then
									if Number == OtherPassport then
										CleanedOfficers[#CleanedOfficers + 1] = NewPassport
										Updated = true
									else
										CleanedOfficers[#CleanedOfficers + 1] = Number
									end
								end
							end
						end

						if Updated then
							exports.oxmysql:update_async("UPDATE mdt_creative_medals SET Officers = ? WHERE id = ?",{ json.encode(CleanedOfficers),v.id })
						end
					end
				end

				local MDT_Reports = exports.oxmysql:query_async("SELECT * FROM mdt_creative_reports WHERE Passport = ?",{ OtherPassport })
				if MDT_Reports and #MDT_Reports > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_reports SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Reports_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_reports WHERE Officer = ?",{ OtherPassport })
				if MDT_Reports_Officer and #MDT_Reports_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_reports SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Units_Officers = exports.oxmysql:query_async("SELECT * FROM mdt_creative_units")
				if MDT_Units_Officers and #MDT_Units_Officers > 0 then
					for _,v in pairs(MDT_Units_Officers) do
						local Updated = false
						local Officers = json.decode(v.Officers) or {}
						local CleanedOfficers = {}
						
						-- Garante que Officers seja um array limpo (sem chaves booleanas)
						if type(Officers) == "table" then
							for _,Number in ipairs(Officers) do
								if type(Number) == "number" then
									if Number == OtherPassport then
										CleanedOfficers[#CleanedOfficers + 1] = NewPassport
										Updated = true
									else
										CleanedOfficers[#CleanedOfficers + 1] = Number
									end
								end
							end
						end

						if Updated then
							exports.oxmysql:update_async("UPDATE mdt_creative_units SET Officers = ? WHERE id = ?",{ json.encode(CleanedOfficers),v.id })
						end
					end
				end

				local MDT_Vehicles = exports.oxmysql:query_async("SELECT * FROM mdt_creative_vehicles WHERE Passport = ?",{ OtherPassport })
				if MDT_Vehicles and #MDT_Vehicles > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_vehicles SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Vehicles_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_vehicles WHERE Officer = ?",{ OtherPassport })
				if MDT_Vehicles_Officer and #MDT_Vehicles_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_vehicles SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Wanted = exports.oxmysql:query_async("SELECT * FROM mdt_creative_wanted WHERE Passport = ?",{ OtherPassport })
				if MDT_Wanted and #MDT_Wanted > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_wanted SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Wanted_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_wanted WHERE Officer = ?",{ OtherPassport })
				if MDT_Wanted_Officer and #MDT_Wanted_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_wanted SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Warning = exports.oxmysql:query_async("SELECT * FROM mdt_creative_warning WHERE Passport = ?",{ OtherPassport })
				if MDT_Warning and #MDT_Warning > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_warning SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local MDT_Warning_Officer = exports.oxmysql:query_async("SELECT * FROM mdt_creative_warning WHERE Officer = ?",{ OtherPassport })
				if MDT_Warning_Officer and #MDT_Warning_Officer > 0 then
					exports.oxmysql:update_async("UPDATE mdt_creative_warning SET Officer = ? WHERE Officer = ?",{ NewPassport,OtherPassport })
				end

				local Invoices = exports.oxmysql:query_async("SELECT * FROM invoices WHERE Passport = ?",{ OtherPassport })
				if Invoices and #Invoices > 0 then
					exports.oxmysql:update_async("UPDATE invoices SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Invoices_Received = exports.oxmysql:query_async("SELECT * FROM invoices WHERE Received = ?",{ OtherPassport })
				if Invoices_Received and #Invoices_Received > 0 then
					exports.oxmysql:update_async("UPDATE invoices SET Received = ? WHERE Received = ?",{ NewPassport,OtherPassport })
				end

				local Investments = exports.oxmysql:query_async("SELECT * FROM investments WHERE Passport = ?",{ OtherPassport })
				if Investments and #Investments > 0 then
					exports.oxmysql:update_async("UPDATE investments SET Passport = ? WHERE Passport = ?",{ NewPassport,OtherPassport })
				end

				local Phone = exports.oxmysql:query_async("SELECT * FROM phone_phones WHERE owner_id = ?",{ OtherPassport })
				if Phone and #Phone > 0 then
					exports.oxmysql:update_async("UPDATE phone_phones SET owner_id = ?, id = ? WHERE owner_id = ?",{ NewPassport,NewPassport,OtherPassport })
				end

				local Permissions = vRP.UserGroups(OtherPassport)
				for Permission,Level in pairs(Permissions) do
					vRP.RemovePermission(OtherPassport,Permission)
					vRP.SetPermission(NewPassport,Permission,Level)
				end

				exports.crons:Swap(OtherPassport,NewPassport)

				local Playing = vRP.GetSrvData("Playing:"..OtherPassport,true)
				vRP.SetSrvData("Playing:"..NewPassport,Playing,true)
				vRP.RemSrvData("Playing:"..OtherPassport)

				TriggerClientEvent("Notify",source,"Sucesso","Atualização de passaporte concluída.","verde",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("players",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Number = 0
		local Message = ""
		local Players = vRP.Players()
		local Amounts = CountTable(Players)
		for OtherPassport in pairs(Players) do
			Number = Number + 1
			Message = Message..OtherPassport..(Number < Amounts and ", " or "")
		end

		TriggerClientEvent("chat:ClientMessage",source,"JOGADORES CONECTADOS",Message,"OOC")
		TriggerClientEvent("Notify",source,"Listagem","<b>Jogadores Conectados:</b> "..GetNumPlayerIndices(),"verde",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clone",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and Message[1] and parseInt(Message[1]) > 0 then
		local OtherPassport = parseInt(Message[1])
		local Identity = vRP.Identity(OtherPassport)
		if Identity then
			vRPC.Skin(source,Identity["Skin"])
			TriggerClientEvent("skinshop:Apply",source,vRP.UserData(OtherPassport,"Clothings"),true)
			TriggerClientEvent("barbershop:Apply",source,vRP.UserData(OtherPassport,"Barbershop"))
			TriggerClientEvent("tattooshop:Apply",source,vRP.UserData(OtherPassport,"Tattooshop"))

			TriggerClientEvent("Notify",source,"Clonagem","Alterações conclúidas.","verde",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("print",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and parseInt(Message[1]) > 0 then
		local OtherPassport = parseInt(Message[1])
		local OtherSource = vRP.Source(OtherPassport)
		local Webhook = exports.discord:Webhook("Print")
		if OtherPassport and OtherSource and Webhook ~= "" then
			TriggerClientEvent("megazord:Screenshot",OtherSource,Webhook)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WIPEBATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wipebattlepass",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		local CurrentTimer = os.time()

		vRP.Query("entitydata/SetData",{ Name = "Battlepass", Information = CurrentTimer })
		exports.oxmysql:query_async("DELETE FROM playerdata WHERE Name = ?",{ "Battlepass" })

		TriggerClientEvent("Notify",source,"Sucesso","Passe de batalha resetado.","verde",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WIPEONLINE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wipeonline",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		vRP.WipePlaying()
		exports.oxmysql:query_async("DELETE FROM entitydata WHERE Name LIKE 'Playing:%'")
		TriggerClientEvent("Notify",source,"Sucesso","Tempo online resetado.","verde",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WIPEDAILY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wipedaily",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		exports.oxmysql:update_async("UPDATE characters SET Daily = ?",{ "09-01-1990-0" })
		TriggerClientEvent("Notify",source,"Sucesso","Daily resetado.","verde",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skinshop",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("skinshop:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("barbershop",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("barbershop:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINWEAPON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skinweapon",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("skinweapon:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LSCUSTOMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lscustoms",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("lscustoms:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TATTOOSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tattooshop",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("tattooshop:Open",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POSTIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("postit",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("chat:postit_new",source,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("usource",function(source,Message)
	local Passport = vRP.Passport(source)
	local OtherSource = parseInt(Message[1])
	if Passport and OtherSource and OtherSource > 0 and vRP.Passport(OtherSource) and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("Notify",source,"Informações","<b>Passaporte:</b> "..vRP.Passport(OtherSource),"default",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cam",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Freecam") then
		TriggerClientEvent("freecam:Active",source,Message)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("id",function(source,Message)
	local OtherPassport = Message[1]
	local Passport = vRP.Passport(source)
	if Passport and OtherPassport and vRP.Identity(OtherPassport) and vRP.HasGroup(Passport,"Admin") then
		local CountGroups = 0
		local Radio = "Desligado"
		local Message = "<br><br>"
		local Groups = vRP.UserGroups(OtherPassport)
		local OtherSource = vRP.Source(OtherPassport)
		for Permission,Level in pairs(Groups) do
			CountGroups = CountGroups + 1
			Message = Message.."[ <warning>"..Permission.."</warning> ] "..vRP.NameHierarchy(Permission,Level).." ( "..Level.." )<br>"
		end

		if OtherSource then
			Radio = vHUD.Radio(OtherSource)
		end

		TriggerClientEvent("Notify",source,"Informações","<b>Passaporte:</b> "..OtherPassport.."<br><b>Nome:</b> "..vRP.FullName(OtherPassport).."<br><b>Banco:</b> "..Currency..Dotted(vRP.GetBank(OtherPassport)).."<br><b>Radio:</b> "..(Radio ~= ("Desligado" or 0) and Radio.."Mhz" or "Desligado").."<br><b>Telefone:</b> "..vRP.Phone(OtherPassport).."<br><b>Grupos Participantes:</b> "..CountGroups..(CountGroups >= 1 and Message or ""),(OtherSource and "verde" or "vermelho"),10000)
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------
-- WIPEPERMISSIONS
------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wipepermissions",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasPermission(Passport,"Admin") then
		local Permissions = {}
		for Permission in pairs(Groups) do
			Permissions[#Permissions + 1] = Permission
		end

		table.sort(Permissions,function(a,b) return a < b end)

		local Keyboard = vKEYBOARD.Instagram(source,Permissions)
		if Keyboard then
			local Permission = Keyboard[1]
			local Consult = exports.oxmysql:query_async("SELECT * FROM chests WHERE Permission LIKE ?",{ Permission.."%" })
			for _,v in pairs(Consult) do
				if SplitOne(v.Permission) == Permission then
					if vRP.GetSrvData("Chest:"..v.Name,true) then
						vRP.RemSrvData("Chest:"..v.Name)
					end

					exports.oxmysql:query_async("DELETE FROM chests WHERE id = ?",{ v.id })
				end
			end

			if vRP.GetSrvData("Permissions:"..Permission,true) then
				vRP.RemSrvData("Permissions:"..Permission)
			end

			exports.oxmysql:query_async("DELETE FROM permissions WHERE Permission = ?",{ Permission })
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------
-- CLEARPERMISSION
------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearpermission",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasPermission(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
		if Keyboard then
			local OtherPassport = parseInt(Keyboard[1])
			if vRP.Identity(OtherPassport) then
				local Permissions = vRP.UserGroups(OtherPassport)
				for Permission,Level in pairs(Permissions) do
					vRP.RemovePermission(OtherPassport,Permission)
				end

				TriggerClientEvent("Notify",source,"Sucesso","Limpeza concluída.","verde",5000)
			end
		end
	end
end)
------------------------------------------------------------------------------------------------------------------------------------------
-- STATUS
------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("status",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasPermission(Passport,"Admin") then
		local Permissions = {}
		for Permission in pairs(Groups) do
			table.insert(Permissions,Permission)
		end

		table.sort(Permissions,function(a,b) return a < b end)

		local Keyboard = vKEYBOARD.Instagram(source,Permissions)
		if Keyboard then
			local Online = ""
			local Offline = ""
			local Permission = Keyboard[1]
			local Consult,Amount = vRP.DataGroups(Permission)
			local Table,Connects = vRP.NumPermission(Permission)

			local Message = "<warning>Jogadores Conectados:</warning> "..Connects.."<br><warning>Jogadores Participantes:</warning> "..Amount..(Amount >= 1 and "<br><br>" or "")

			for OtherPassport in pairs(Consult) do
				if Table[OtherPassport] then
					Online = Online.."<online>•</online> "..vRP.FullName(OtherPassport).." ( "..OtherPassport.." )<br>"
				else
					Offline = Offline.."<offline>•</offline> "..vRP.FullName(OtherPassport).." ( "..OtherPassport.." )<br>"
				end
			end

			TriggerClientEvent("Notify",source,Permission,Message..Online..Offline,"default",15000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skin",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[2] and vRPC.ModelExist(source,Message[2]) and vRP.HasGroup(Passport,"Admin") then
		local Skin = Message[2]
		local OtherPassport = Message[1]
		local OtherSource = vRP.Source(OtherPassport)
		if OtherSource then
			vRPC.Skin(OtherSource,Skin)
			vRP.SkinCharacter(OtherPassport,Skin)
			exports.discord:Embed("Skin","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport.."\n**[MODEL]:** "..Skin)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARINV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("clearinv",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and parseInt(Message[1]) > 0 and vRP.HasGroup(Passport,"Admin",2) then
		vRP.ClearInventory(Message[1],true)
		TriggerClientEvent("Notify",source,"Sucesso","Limpeza concluída.","verde",5000)
		exports.discord:Embed("ClearInv","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..Message[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dima",function(source,Message)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin",1) then
		return false
	end

	local Keyboard = vKEYBOARD.Secondary(source,"Passaporte","Quantidade")
	if not Keyboard then
		return false
	end

	local Amount = Keyboard[2]
	local OtherPassport = Keyboard[1]
	if not vRP.Identity(OtherPassport) then
		TriggerClientEvent("Notify",source,"Aviso","Passaporte inválido.","vermelho",5000)
		return false
	end

	vRP.UpgradeGemstone(OtherPassport,Amount,true)
	TriggerClientEvent("Notify",source,"Sucesso","Diamantes entregues.","verde",5000)
	exports.discord:Embed("Dima",("**[ADMIN]:** %s\n**[PASSAPORTE]:** %s\n**[QUANTIDADE]:** %sx"):format(Passport,OtherPassport,Amount))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("money",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin",1) then
		return false
	end

	local Keyboard = vKEYBOARD.Secondary(source,"Passaporte","Quantidade")
	if not Keyboard then
		return false
	end

	local Amount = Keyboard[2]
	local OtherPassport = Keyboard[1]
	if not vRP.Identity(OtherPassport) then
		TriggerClientEvent("Notify",source,"Aviso","Passaporte inválido.","vermelho",5000)
		return false
	end

	vRP.GiveBank(OtherPassport,Amount,true)
	TriggerClientEvent("Notify",source,"Sucesso","Dinheiros entregues.","verde",5000)
	exports.discord:Embed("Money",("**[ADMIN]:** %s\n**[PASSAPORTE]:** %s\n**[QUANTIDADE]:** %sx"):format(Passport,OtherPassport,Amount))
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cleanprison",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin",1) then
		return false
	end

	local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
	if not Keyboard then
		return false
	end

	local OtherPassport = Keyboard[1]
	if not vRP.Identity(OtherPassport) then
		TriggerClientEvent("Notify",source,"Aviso","Passaporte inválido.","vermelho",5000)
		return false
	end

	vRP.CleanPrison(OtherPassport)
	exports.discord:Embed("CleanPrison",("**[ADMIN]:** %s\n**[PASSAPORTE]:** %s"):format(Passport,OtherPassport))
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blips",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		vRPC.BlipAdmin(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("god",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		if Message[1] then
			local OtherPassport = parseInt(Message[1])
			local OtherSource = vRP.Source(OtherPassport)
			if OtherSource then
				vRP.Revive(OtherSource,200)
				vRP.UpgradeThirst(OtherPassport,10)
				vRP.UpgradeHunger(OtherPassport,10)
				vRP.DowngradeStress(OtherPassport,100)
				TriggerClientEvent("paramedic:Reset",OtherSource)

				exports.discord:Embed("God","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport)
			end
		else
			vRP.Revive(source,200)
			vRP.Armour(source,100)
			vRP.UpgradeThirst(Passport,100)
			vRP.UpgradeHunger(Passport,100)
			vRP.DowngradeStress(Passport,100)
			TriggerClientEvent("paramedic:Reset",source)

			exports.discord:Embed("God","**[ADMIN]:** "..Passport)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("item",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) then
		if not Message[1] then
			local Keyboard = vKEYBOARD.Item(source,"Passaporte","Item","Quantidade",{ "Jogador","Todos","Area" },"Distância")
			if Keyboard then
				if ItemExist(Keyboard[2]) then
					local Item = Keyboard[2]
					local Action = Keyboard[4]
					local OtherPassport = Keyboard[1]
					local Amount = parseInt(Keyboard[3],true)
					local Distance = parseInt(Keyboard[5],true)

					if Action == "Jogador" then
						if vRP.Source(OtherPassport) then
							vRP.GenerateItem(OtherPassport,Item,Amount,true)
							TriggerClientEvent("Notify",source,"Sucesso","Entregue ao destinatário.","verde",5000)
						else
							local Selected = GenerateString("DDLLDDLL")
							local Consult = vRP.GetSrvData("Offline:"..OtherPassport,true)

							repeat
								Selected = GenerateString("DDLLDDLL")
							until Selected and not Consult[Selected]

							TriggerClientEvent("Notify",source,"Sucesso","Adicionado a lista de entregas.","verde",5000)
							Consult[Selected] = { ["Item"] = Item, ["Amount"] = Amount }
							vRP.SetSrvData("Offline:"..OtherPassport,Consult,true)
						end
					elseif Action == "Todos" then
						local List = vRP.Players()
						for OtherPlayer in pairs(List) do
							async(function()
								vRP.GenerateItem(OtherPlayer,Item,Amount,true)
							end)
						end
					elseif Action == "Area" then
						local PlayerList = GetPlayers()
						local Coords = vRP.GetEntityCoords(source)

						for _,OtherSource in ipairs(PlayerList) do
							async(function()
								local OtherSource = parseInt(OtherSource)
								local OtherPassport = vRP.Passport(OtherSource)
								local OtherCoords = vRP.GetEntityCoords(OtherSource)

								if OtherCoords and OtherPassport and #(Coords - OtherCoords) <= Distance then
									vRP.GenerateItem(OtherPassport,Item,Amount,true)
								end
							end)
						end
					end

					exports.discord:Embed("Item","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport.."\n**[ITEM]:** "..Item.."\n**[QUANTIDADE]:** "..Amount.."x")
				else
					TriggerClientEvent("Notify",source,"Aviso","O item <b>"..Keyboard[2].."</b> não existe.","vermelho",5000)
				end
			end
		elseif Message[1] and Message[2] then
			if ItemExist(Message[1]) then
				vRP.GenerateItem(Passport,Message[1],Message[2],true)
				exports.discord:Embed("Item","**[ADMIN]:** "..Passport.."\n**[ITEM]:** "..Message[1].."\n**[QUANTIDADE]:** "..Message[2].."x")
			else
				TriggerClientEvent("Notify",source,"Aviso","O item <b>"..Message[1].."</b> não existe.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATAITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dataitem",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) then
		if Message[1] and Message[2] and Message[3] then
			if ItemExist(Message[1]) then
				vRP.GenerateItem(Passport,Message[1].."-"..Message[2],Message[3],true)
				exports.discord:Embed("Item","**[ADMIN]:** "..Passport.."\n**[ITEM]:** "..Message[1].."-"..Message[2]"\n**[QUANTIDADE]:** "..Message[3].."x")
			else
				TriggerClientEvent("Notify",source,"Aviso","O item <b>"..Message[1].."</b> não existe.","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("skins",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) then
		local Keyboard = vKEYBOARD.Skins(source,"Passaporte","Número","Weapon","Component",{ "Jogador","Todos" })
		if Keyboard then
			if Keyboard[5] == "Jogador" then
				local OtherPassport = parseInt(Keyboard[1])
				if vRP.Identity(OtherPassport) then
					TriggerEvent("inventory:SkinPlayer",OtherPassport,Keyboard[2],Keyboard[3],Keyboard[4])
				end
			elseif Keyboard[5] == "Todos" then
				local List = vRP.Players()
				for OtherPassport in pairs(List) do
					async(function()
						TriggerEvent("inventory:SkinPlayer",OtherPassport,Keyboard[2],Keyboard[3],Keyboard[4])
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("delete",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and vRP.HasGroup(Passport,"Admin",2) then
		vRP.Update("characters/Delete",{ Passport = Message[1] })
		TriggerClientEvent("Notify",source,"Sucesso","Personagem <b>"..Message[1].."</b> deletado.","verde",5000)
		exports.discord:Embed("Delete","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..Message[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nc",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		TriggerClientEvent("admin:NoClip",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kick",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and parseInt(Message[1]) > 0 then
		local OtherPassport = Message[1]
		local OtherSource = vRP.Source(OtherPassport)
		if OtherSource then
			vRP.Kick(OtherSource,"Expulso da cidade")
			TriggerClientEvent("Notify",source,"Sucesso","Passaporte <b>"..OtherPassport.."</b> expulso.","verde",5000)
			exports.discord:Embed("Kick","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Banned(source,"Passaporte","Motivo",{ "Horas","Dias","Permanente" },"Quantidade")
		if Keyboard then
			local Mode = Keyboard[3]
			local Reason = Keyboard[2]
			local Amount = parseInt(Keyboard[4],true)
			local OtherPassport = parseInt(Keyboard[1])

			if vRP.Identity(OtherPassport) then
				vRP.SetBanned(OtherPassport,(Mode == "Permanente" and -1 or Amount),Mode,Reason)
				TriggerClientEvent("Notify",source,"Sucesso","Banimento aplicado ao passaporte <b>"..OtherPassport.."</b>.","verde",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("unban",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
		if Keyboard then
			local OtherPassport = parseInt(Keyboard[1])
			local Account = vRP.AccountOptimize(OtherPassport)
			if OtherPassport and Account then
				vRP.Update("hwid/All",{ Account = Account.id, Banned = 1 })
				vRP.Update("accounts/RemoveBanned",{ License = Account.License })
				TriggerClientEvent("Notify",source,"Sucesso","Revogado o banimento do passaporte <b>"..Keyboard[1].."</b>.","verde",5000)
				exports.discord:Embed("Ban","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..Keyboard[1].."\n**[MODO]:** Unban")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTCRON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("insertcron",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Skins(source,"Passaporte","Permissão","Hierarquia","Quantidade",{ "Horas","Dias" })
		if Keyboard then
			local Timer = 0
			local Mode = Keyboard[5]
			local Permission = Keyboard[2]
			local OtherPassport = Keyboard[1]
			local Amount = parseInt(Keyboard[4],true)
			local Hierarchy = parseInt(Keyboard[3],true)

			if not vRP.HasPermission(OtherPassport,Permission) then
				vRP.SetPermission(OtherPassport,Permission)
			end

			if Mode == "Horas" then
				Timer = Amount * 3600
			elseif Mode == "Dias" then
				Timer = Amount * 86400
			end

			exports.crons:Insert(OtherPassport,"RemovePermission",Timer,{ Permission = Permission, Level = Hierarchy })
			TriggerClientEvent("Notify",source,"Sucesso","Adição efetuada.","verde",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVECRON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("removecron",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Secondary(source,"Passaporte","Permissão")
		if Keyboard then
			exports.crons:Remove(Keyboard[1],"RemovePermission",Keyboard[2])
			TriggerClientEvent("Notify",source,"Sucesso","Remoção efetuada.","verde",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpcds",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Primary(source,"Cordenadas")
		if Keyboard then
			local Split = splitString(Keyboard[1],",")
			if Split[1] and Split[2] and Split[3] then
				vRP.Teleport(source,Split[1],Split[2],Split[3])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cds",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.DoesEntityExist(source) and vRP.HasGroup(Passport,"Admin") then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Heading = GetEntityHeading(Ped)

		vKEYBOARD.Copy(source,"Cordenadas",Optimize(Coords["x"])..","..Optimize(Coords["y"])..","..Optimize(Coords["z"])..","..Optimize(Heading))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("group",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[2] and vRP.HasGroup(Passport,"Admin",2) then
		local Permission = Message[2]
		local OtherPassport = Message[1]
		if Permission == "Admin" and vRP.HasPermission(Passport,Permission) >= 2 then
			return false
		end

		vRP.SetPermission(OtherPassport,Permission,Message[3])
		TriggerClientEvent("Notify",source,"Sucesso","Adicionado <b>"..Permission.."</b> ao passaporte <b>"..OtherPassport.."</b>.","verde",5000)
		exports.discord:Embed("Group","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport.."\n**[GRUPO]:** "..Permission.."\n**[Modo]:** Adicionou")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ungroup",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and Message[2] and vRP.HasGroup(Passport,"Admin",2) then
		local Permission = Message[2]
		local OtherPassport = Message[1]
		if Permission == "Admin" and vRP.HasPermission(Passport,Permission) >= 2 then
			return false
		end

		vRP.RemovePermission(OtherPassport,Permission)
		TriggerClientEvent("Notify",source,"Sucesso","Removido <b>"..Permission.."</b> ao passaporte <b>"..OtherPassport.."</b>.","verde",5000)
		exports.discord:Embed("Group","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport.."\n**[GRUPO]:** "..Permission.."\n**[Modo]:** Removeu")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tptome",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and vRP.HasGroup(Passport,"Admin") then
		local OtherPassport = parseInt(Message[1])
		local OtherSource = vRP.Source(OtherPassport)
		if OtherSource and vRP.DoesEntityExist(OtherSource) then
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)

			vRP.Teleport(OtherSource,Coords["x"],Coords["y"],Coords["z"])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpto",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and Message[1] and vRP.HasGroup(Passport,"Admin") then
		local OtherPassport = parseInt(Message[1])
		local OtherSource = vRP.Source(OtherPassport)
		if OtherSource and vRP.DoesEntityExist(OtherSource) then
			local Ped = GetPlayerPed(OtherSource)
			local Coords = GetEntityCoords(Ped)

			vRP.Teleport(source,Coords["x"],Coords["y"],Coords["z"])
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tpway",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		vCLIENT.teleportWay(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limbo",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.GetHealth(source) <= 100 then
		vCLIENT.teleportLimbo(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("tuning",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		TriggerClientEvent("admin:Tuning",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fix",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Vehicle,Network,Plate = vRPC.VehicleList(source)
		if Vehicle then
			local Players = vRPC.Players(source)
			for Passport,OtherSource in pairs(Players) do
				async(function()
					TriggerClientEvent("target:RollVehicle",OtherSource,Network)
					TriggerClientEvent("inventory:RepairAdmin",OtherSource,Network,Plate)
				end)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN:DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("admin:Doords")
AddEventHandler("admin:Doords",function(Coords,Model,Heading)
	vRP.Archive("coordenadas.txt","Coords = "..Coords..", Hash = "..Model..", Disabled = false, Lock = true, Distance = 1.75")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.buttonTxt()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and vRP.DoesEntityExist(source) and vRP.HasGroup(Passport,"Admin") then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Heading = GetEntityHeading(Ped)

		vRP.Archive(Passport..".txt",Optimize(Coords["x"])..","..Optimize(Coords["y"])..","..Optimize(Coords["z"])..","..Optimize(Heading))
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("announce",function(source,Message,History)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) then
		local Keyboard = vKEYBOARD.Announce(source,"Título","Mensagem","Segundos",{ "amarelo","verde","vermelho","fome","sede","default","sangue","policia" },{ "middle-left","middle-right","top-left","top-center","top-right","bottom-left","bottom-center","bottom-right" })
		if Keyboard then
			local Title = Keyboard[1]
			local Colors = Keyboard[4]
			local Message = Keyboard[2]
			local Direction = Keyboard[5]
			local Seconds = parseInt(Keyboard[3],true) * 1000

			TriggerClientEvent("Notify",-1,Title,Message,Colors,Seconds,Direction)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSOLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("console",function(source,Message,History)
	if source == 0 then
		TriggerClientEvent("Notify",-1,"Prefeitura",History:sub(8),"default",60000,"bottom-center")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin",1) then
			return
		end
	end

	TriggerClientEvent("sounds:playSound",-1,"Quake","earthquake",1.0,false)

	TriggerClientEvent("Notify",-1,"Prefeitura","Terremoto se aproxima em 3 minutos.","default",60000,"bottom-center")
	GlobalState["Weather"] = "RAIN"
	Wait(60000)

	TriggerClientEvent("Notify",-1,"Prefeitura","Terremoto se aproxima em 2 minutos.","default",60000,"bottom-center")
	Wait(60000)

	TriggerClientEvent("Notify",-1,"Prefeitura","Terremoto se aproxima em 1 minuto.","default",60000,"bottom-center")
	GlobalState["Weather"] = "THUNDER"
	Wait(60000)

	local List = vRP.Players()
	for _,OtherSource in pairs(List) do
		vRP.Kick(OtherSource,"Desconectado, a cidade reiniciou")
		Wait(100)
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kickall2",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin",1) then
			return
		end
	end

	local List = vRP.Players()
	for _,OtherSource in pairs(List) do
		vRP.Kick(OtherSource,"Desconectado, a cidade reiniciou")
		Wait(100)
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("save",function(source)
	if source ~= 0 then
		local Passport = vRP.Passport(source)
		if not vRP.HasGroup(Passport,"Admin",1) then
			return
		end
	end

	TriggerEvent("SaveServer",false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOGSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		Wait(10 * 60000)

		local Message = "**LISTAGEM DE JOGADORES**\n\n**[ PLAYERS ]:** "..GetNumPlayerIndices().."\n"
		for Permission in pairs(Groups) do
			Message = Message.."**[ "..string.upper(Permission).." ]:** "..vRP.AmountService(Permission).."\n"

			Wait(1000)
		end

		exports.discord:Embed("Permissions",Message)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACECONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RaceConfig(Left,Center,Right,Distance,Name)
	vRP.Archive(Name..".txt","{")

	vRP.Archive(Name..".txt","['Left'] = vec3("..Optimize(Left["x"])..","..Optimize(Left["y"])..","..Optimize(Left["z"]).."),")
	vRP.Archive(Name..".txt","['Center'] = vec3("..Optimize(Center["x"])..","..Optimize(Center["y"])..","..Optimize(Center["z"]).."),")
	vRP.Archive(Name..".txt","['Right'] = vec3("..Optimize(Right["x"])..","..Optimize(Right["y"])..","..Optimize(Right["z"]).."),")
	vRP.Archive(Name..".txt","['Distance'] = "..Distance)

	vRP.Archive(Name..".txt","},")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPECTATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("spectate",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		if Spectate[Passport] then
			local Ped = GetPlayerPed(Spectate[Passport])
			if DoesEntityExist(Ped) then
				SetEntityDistanceCullingRadius(Ped,0.0)
			end

			TriggerClientEvent("admin:resetSpectate",source)
			Spectate[Passport] = nil
		else
			local OtherPassport = Message[1]
			local OtherSource = vRP.Source(OtherPassport)
			if OtherSource then
				local Ped = GetPlayerPed(OtherSource)
				if DoesEntityExist(Ped) then
					SetEntityDistanceCullingRadius(Ped,999999999.0)
					Wait(1000)
					TriggerClientEvent("admin:initSpectate",source,OtherSource)
					Spectate[Passport] = OtherSource
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUAKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("quake",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",1) then
		TriggerClientEvent("Notify",-1,"Terromoto","Os geólogos informaram para nossa unidade governamental que foi encontrado um abalo de magnitude <b>60</b> na <b>Escala Richter</b>, encontrem abrigo até que o mesmo passe.","amarelo",60000)
		TriggerClientEvent("sounds:playSound",-1,"Quake","earthquake",1.0,false)
		GlobalState["Quake"] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("limparea",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Ped = GetPlayerPed(source)
		local Coords = GetEntityCoords(Ped)
		local Players = vRPC.Players(source)
		for Passport,Sources in pairs(Players) do
			async(function()
				vCLIENT.Limparea(Sources,Coords)
			end)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VIDEO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("video",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Instagram(source,{ "Passporte","Permissão","Area","Global","Fechar" })
		if Keyboard then
			if Keyboard[1] == "Passporte" then
				local Keyboard = vKEYBOARD.Secondary(source,"Passaporte","Código Vimeo")
				if Keyboard then
					local OtherPassport = parseInt(Keyboard[1])
					local OtherSource = vRP.Source(OtherPassport)
					if OtherSource then
						TriggerClientEvent("hud:Video",OtherSource,Keyboard[2])
						TriggerClientEvent("Notify",source,"Sucesso","Vídeo executado com sucesso.","verde",5000)
					end
				end
			elseif Keyboard[1] == "Global" then
				local Keyboard = vKEYBOARD.Primary(source,"Código Vimeo")
				if Keyboard then
					TriggerClientEvent("hud:Video",-1,Keyboard[1])
				end
			elseif Keyboard[1] == "Permissão" then
				local Permissions = {}
				for Permission in pairs(Groups) do
					table.insert(Permissions,Permission)
				end

				table.sort(Permissions,function(a,b) return a < b end)
				local Keyboard = vKEYBOARD.Options(source,"Código Vimeo",Permissions)
				if Keyboard then
					local Service = vRP.NumPermission(Keyboard[2])
					for Passports,Sources in pairs(Service) do
						async(function()
							TriggerClientEvent("hud:Video",Sources,Keyboard[1])
						end)
					end

					TriggerClientEvent("Notify",source,"Sucesso","Vídeo executado com sucesso.","verde",5000)
				end
			elseif Keyboard[1] == "Area" then
				local Keyboard = vKEYBOARD.Secondary(source,"Distância","Código Vimeo")
				if Keyboard then
					local PlayerList = GetPlayers()
					local Coords = vRP.GetEntityCoords(source)

					for _,OtherSource in ipairs(PlayerList) do
						async(function()
							local OtherSource = parseInt(OtherSource)
							local OtherCoords = vRP.GetEntityCoords(OtherSource)

							if OtherCoords and #(Coords - OtherCoords) <= parseInt(Keyboard[1]) then
								TriggerClientEvent("hud:Video",OtherSource,Keyboard[2])
							end
						end)
					end

					TriggerClientEvent("Notify",source,"Sucesso","Vídeo executado com sucesso.","verde",5000)
				end
			elseif Keyboard[1] == "Fechar" then
				TriggerClientEvent("hud:Video",-1)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENAME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rename",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin") then
		return false
	end

	local Keyboard = vKEYBOARD.Tertiary(source,"Passaporte","Nome","Sobrenome")
	if not Keyboard then
		return false
	end

	local Name = Keyboard[2]
	local Lastname = Keyboard[3]
	local OtherPassport = parseInt(Keyboard[1])

	local Identity = vRP.Identity(OtherPassport)
	if not Identity then
		TriggerClientEvent("Notify",source,"Erro","Passaporte inválido.","vermelho",5000)
		return false
	end

	vRP.UpgradeNames(OtherPassport,Name,Lastname)
	TriggerClientEvent("Notify",source,"Sucesso","Nome atualizado.","verde",5000)

	local Account = vRP.Account(Identity.License)
	if Account and Account.Discord then
		exports.discord:Content("Rename",account.Discord.." #"..OtherPassport.." "..Name.." "..Lastname)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("addcar",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin",1) then
		return false
	end

	local Keyboard = vKEYBOARD.Vehicle(source,"Passaporte","Modelo",{ "Mensal","Permanente","Dias" },"Dias",{ "Sim","Não" })
	if not Keyboard then return end

	local Mode = Keyboard[3]
	local Model = Keyboard[2]
	local Block = Keyboard[5] == "Sim"
	local Days = parseInt(Keyboard[4],true)
	local OtherPassport = parseInt(Keyboard[1],true)

	if not VehicleExist(Model) then
		TriggerClientEvent("Notify",source,"Erro","Modelo de veículo inválido.","vermelho",5000)
		return false
	end

	local Rental,Tax = nil,nil
	local CurrentTimer = os.time()
	local Plate = vRP.GeneratePlate()
	local Weight = VehicleWeight(Model)
	local Work = VehicleMode(Model) == "Work"

	if Mode == "Mensal" then
		Rental = CurrentTimer + 30 * 24 * 60 * 60
		Tax = Rental
	elseif Mode == "Dias" then
		Rental = CurrentTimer + (86400 * Days)
		Tax = Rental
	elseif Mode == "Permanente" then
		Tax = CurrentTimer + 30 * 24 * 60 * 60
	end

	exports.oxmysql:query_async("INSERT IGNORE INTO vehicles (Passport,Vehicle,Plate,Weight,Work,Rental,Tax,Block) VALUES (@Passport,@Vehicle,@Plate,@Weight,@Work,@Rental,@Tax,@Block)",{ Passport = OtherPassport, Vehicle = Model, Plate = Plate, Weight = Weight, Work = Work, Rental = Rental, Tax = Tax, Block = Block })
	exports.discord:Embed("AddCar","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport.."\n**[MODEL]:** "..Model.."\n**[TIPO]:** "..Mode)
	TriggerClientEvent("Notify",source,"Sucesso","Veículo <b>"..VehicleName(Model).."</b> entregue.","verde",5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("remcar",function(source)
	local Passport = vRP.Passport(source)
	if not Passport or not vRP.HasGroup(Passport,"Admin",1) then
		return false
	end

	local Keyboard = vKEYBOARD.Primary(source,"Passaporte")
	if not Keyboard then
		return false
	end

	local OtherPassport = parseInt(Keyboard[1])
	local UserVehicles = vRP.Query("vehicles/UserVehicles",{ Passport = OtherPassport })
	if not UserVehicles or #UserVehicles == 0 then
		TriggerClientEvent("Notify",source,"Erro","Este usuário não possui veículos.","vermelho",5000)
		return false
	end

	local VehicleList = {}
	for _,v in ipairs(UserVehicles) do
		VehicleList[#VehicleList + 1] = v.Vehicle
	end

	local Keyboard = vKEYBOARD.Instagram(source,VehicleList)
	if not Keyboard then
		return false
	end

	local Selected = Keyboard[1]
	local Vehicle = vRP.SelectVehicle(OtherPassport,Selected)
	if Vehicle then
		vRP.RemSrvData("LsCustoms:"..Vehicle.id..":"..Vehicle.Vehicle)
		vRP.RemSrvData("Trunkchest:"..OtherPassport..":"..Selected)
		vRP.Query("vehicles/removeVehicles",{ Passport = OtherPassport, Vehicle = Selected })
		TriggerClientEvent("Notify",source,"Sucesso","Veículo <b>"..VehicleName(Selected).."</b> removido.","verde",5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NITRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("nitro",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and vRP.InsideVehicle(source) then
		local Vehicle,Network,Plate = vRPC.VehicleList(source)
		if Vehicle then
			local Networked = NetworkGetEntityFromNetworkId(Network)
			if DoesEntityExist(Networked) then
				Entity(Networked)["state"]:set("Nitro",2000,true)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("fuel",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") and vRP.InsideVehicle(source) then
		TriggerClientEvent("engine:FuelAdmin",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KILL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kill",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin",2) and Message[1] and parseInt(Message[1]) > 0 then
		local ClosestPed = vRP.Source(Message[1])
		if ClosestPed then
			vRPC.SetHealth(ClosestPed,100)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("cure",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		if Message[1] then
			local OtherPassport = parseInt(Message[1])
			local OtherSource = vRP.Source(OtherPassport)
			if OtherSource then
				TriggerEvent("health:AdminCure",OtherSource,source)

				exports.discord:Embed("Cure","**[ADMIN]:** "..Passport.."\n**[PASSAPORTE]:** "..OtherPassport)
			end
		else
			TriggerEvent("health:AdminCure",source,source)

			exports.discord:Embed("Cure","**[ADMIN]:** "..Passport)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("prescription",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local List = { "medkit","ritmoneury","sinkalmy","analgesic","antipyretic","intoxication","complaint","antiinfection" }

		local DisplayList = {}
		for _,item in ipairs(List) do
			table.insert(DisplayList, ItemName(item))
		end

		local Keyboard = vKEYBOARD.Options(source,"Passaporte",DisplayList)
		if Keyboard then
			local SelectedPassport = Keyboard[1]
			local SelectedName = Keyboard[2]
			local SelectedId

			for i,name in ipairs(DisplayList) do
				if name == SelectedName then
					SelectedId = List[i]
					break
				end
			end

			if SelectedId then
				if vRP.Source(SelectedPassport) then
					vRP.GiveItem(SelectedPassport,"prescription-"..os.time().."-"..SelectedId.."-"..SelectedPassport,1,true)
					TriggerClientEvent("Notify",source,"Sucesso","Você receitou <b>1x "..SelectedName.."</b> para <b>"..vRP.FullName(SelectedPassport).."</b>.","verde",5000)
				else
					TriggerClientEvent("Notify",source,"Aviso","<b>"..vRP.FullName(SelectedPassport).."</b> não se encontra na cidade.","vermelho",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("removewl",function(source,Message)
	if source == 0 then
		for _,v in pairs(vRP.Query("accounts/Minimals")) do
			vRP.Update("accounts/Clean",{ License = v["License"] })
			exports.discord:Content("Roles",v["Discord"].." 720476376871731241 Remover")

			Wait(1000)
		end

		print("Processo de remoção das allowlists finalizada.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("removeveh",function(source,Message)
	if source == 0 then
		for _,v in pairs(vRP.Query("vehicles/Minimals")) do
			vRP.Query("entitydata/RemoveData",{ Name = "Mods:"..v["Passport"]..":"..v["Vehicle"] })
			vRP.Query("vehicles/removeVehicles",{ Passport = v["Passport"], Vehicle = v["Vehicle"] })
			vRP.Query("entitydata/RemoveData",{ Name = "Trunkchest:"..v["Passport"]..":"..v["Vehicle"] })

			Wait(1000)
		end

		print("Processo de remoção dos veículos finalizado.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEPROP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("removeprop",function(source,Message)
	if source == 0 then
		for _,v in pairs(vRP.Query("propertys/Minimals")) do
			vRP.RemSrvData("Vault:"..v["Name"])
			vRP.RemSrvData("Fridge:"..v["Name"])
			vRP.Query("propertys/Sell",{ Name = v["Name"] })

			Wait(1000)
		end

		print("Processo de remoção das propriedades finalizada.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	local Consult = vRP.GetSrvData("Offline:"..Passport,true)
	if Consult and next(Consult) then
		for _,v in ipairs(Consult) do
			vRP.GenerateItem(Passport,v.Item,v.Amount,true)
		end

		vRP.RemSrvData("Offline:"..Passport)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport,source)
	if Spectate[Passport] then
		local Ped = GetPlayerPed(Spectate[Passport])
		if Ped and DoesEntityExist(Ped) then
			SetEntityDistanceCullingRadius(Ped,0.0)
		end

		Spectate[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLACKOUT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("blackout",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		GlobalState["Blackout"] = not GlobalState["Blackout"]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NEWCODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("newcode",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Secondary(source,"Código","Tipo (money/gemstone/item)")
		if Keyboard then
			local Code = Keyboard[1]
			local Type = Keyboard[2]

			if not Code or not Type then
				return TriggerClientEvent("Notify",source,"Atenção","Preencha todos os campos.","amarelo",5000)
			end

			if Type ~= "money" and Type ~= "gemstone" and Type ~= "item" then
				return TriggerClientEvent("Notify",source,"Atenção","Tipo inválido. Use: money, gemstone ou item.","amarelo",5000)
			end

			local Keyboard2 = vKEYBOARD.Secondary(source,"Quantidade","Máximo de Usos")
			if Keyboard2 then
				local Amount = parseInt(Keyboard2[1])
				local MaxUses = parseInt(Keyboard2[2])

				if not Amount or not MaxUses or Amount <= 0 or MaxUses <= 0 then
					return TriggerClientEvent("Notify",source,"Atenção","Quantidade e máximo de usos devem ser números positivos.","amarelo",5000)
				end

				local Keyboard3 = vKEYBOARD.Primary(source,"Dias para Expirar (0 = sem expiração)")
				if Keyboard3 then
					local ExpireDays = parseInt(Keyboard3[1]) or 0

					local Rewards = {}
					if Type == "money" then
						table.insert(Rewards, { Type = "money", Amount = Amount })
					elseif Type == "gemstone" then
						table.insert(Rewards, { Type = "gemstone", Amount = Amount })
					elseif Type == "item" then
						table.insert(Rewards, { Type = "item", Item = Amount, Amount = 1 }) -- Amount vira o nome do item
					end

					local ExpireTime = ExpireDays > 0 and (ExpireDays * 86400) or 0

					local Success,Message = vRP.CreateRedeemCode(Code, json.encode(Rewards), MaxUses, ExpireTime)
					if Success then
						TriggerClientEvent("Notify",source,"Sucesso","Código '" .. Code .. "' criado com sucesso!","verde",5000)
					else
						TriggerClientEvent("Notify",source,"Erro",Message or "Erro ao criar código","vermelho",5000)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATECODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("createcode",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Secondary(source,"Código","Máximo de Usos")
		if Keyboard then
			local Code = Keyboard[1]
			local MaxUses = parseInt(Keyboard[2])

			if not Code or not MaxUses or MaxUses <= 0 then
				return TriggerClientEvent("Notify",source,"Atenção","Preencha todos os campos corretamente.","amarelo",5000)
			end

			local Keyboard2 = vKEYBOARD.Secondary(source,"Dias para Expirar (0 = sem expiração)","Recompensas JSON")
			if Keyboard2 then
				local ExpireDays = parseInt(Keyboard2[1]) or 0
				local RewardsJson = Keyboard2[2]

				if not RewardsJson then
					return TriggerClientEvent("Notify",source,"Atenção","JSON de recompensas é obrigatório.","amarelo",5000)
				end

				local ExpireTime = ExpireDays > 0 and (ExpireDays * 86400) or 0

				local Success,Message = vRP.CreateRedeemCode(Code, RewardsJson, MaxUses, ExpireTime)
				if Success then
					TriggerClientEvent("Notify",source,"Sucesso","Código '" .. Code .. "' criado com sucesso!","verde",5000)
				else
					TriggerClientEvent("Notify",source,"Erro",Message or "Erro ao criar código","vermelho",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEACTIVATECODE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("deactivatecode",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Keyboard = vKEYBOARD.Primary(source,"Código para Desativar")
		if Keyboard then
			local Code = Keyboard[1]
			if not Code then
				return TriggerClientEvent("Notify",source,"Atenção","Digite o código.","amarelo",5000)
			end

			local Success = vRP.DeactivateRedeemCode(Code)
			if Success then
				TriggerClientEvent("Notify",source,"Sucesso","Código '" .. Code .. "' desativado com sucesso!","verde",5000)
			else
				TriggerClientEvent("Notify",source,"Erro","Erro ao desativar código","vermelho",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LISTCODES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("listcodes",function(source)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local Codes = vRP.GetAllRedeemCodes()
		if #Codes == 0 then
			return TriggerClientEvent("Notify",source,"Info","Nenhum código ativo encontrado.","azul",5000)
		end

		local Message = "Códigos Ativos:\n"
		for i, CodeData in pairs(Codes) do
			if i <= 10 then -- Limitar a 10 códigos para não sobrecarregar
				local ExpireInfo = CodeData.Expires > 0 and os.date("%d/%m/%Y", CodeData.Expires) or "Sem expiração"
				Message = Message .. CodeData.Code .. " (" .. CodeData.Uses .. "/" .. CodeData.MaxUses .. ") - " .. ExpireInfo .. "\n"
			end
		end

		TriggerClientEvent("Notify",source,"Códigos Ativos",Message,"azul",15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("debug",function(source)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.HasGroup(Passport,"Admin") then
			TriggerClientEvent("ToggleDebug",source)
		end
	end
end)
