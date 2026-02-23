-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("races", Creative)
vCLIENT = Tunnel.getInterface("races")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lobbies = {}
local Payments = {}
local Cooldowns = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Information()
	local source = source
	local Passport = vRP.Passport(source)
	local Avatars = exports.oxmysql:single_async("SELECT Image FROM avatars WHERE Passport = ?", { Passport })
	local Avatar = Avatars and Avatars.Image or exports.discord:Avatar(Passport) or ("nui://%s/web-side/images/user.svg"):format(GetCurrentResourceName())
	local Experience, Level = vRP.GetExperience(Passport,"Race")

	return Avatar, { Xp = Experience, Levels = TableLevel() }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINISH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Finish(Mode,Route,Points)
	local source = source
	local Passport = vRP.Passport(source)
	local VehicleName = vRPC.VehicleName(source)

	local RaceKey = Mode..":"..Route
	Points = Points and Points > 1000 and math.floor(Points / 1000) or 0

	if Lobbies[RaceKey] and Lobbies[RaceKey].ActiveRaces and Lobbies[RaceKey].ActiveRaces[Passport] then
		Lobbies[RaceKey].ActiveRaces[Passport] = nil
		if next(Lobbies[RaceKey].ActiveRaces) == nil then
			GlobalState["Races:"..RaceKey] = nil
			Lobbies[RaceKey] = nil
		end
	end

	if Payments[Passport] then
		Payments[Passport] = nil

		local RouteData = Races[Mode]["Routes"][Route]
		if not RouteData then return end

		local Query = vRP.Query("Races/User", { Mode = Mode, Race = Route, Passport = Passport })
		local Action = Query[1] and "Update" or "Insert"

		if Points > 0 then
			vRP.Query("Races/"..Action, { Mode = Mode, Race = Route, Passport = Passport, Vehicle = VehicleName, Points = parseInt(Points) })
		end

		vRP.PutExperience(Passport,"Race",8)
		vRP.GenerateItem(Passport,ExchangeItem,RouteData["Payment"],true)
		exports.markers:Exit(source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- START
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Start(Mode,Route)
	local source = source
	local Passport = vRP.Passport(source)
	local RaceKey = Mode..":"..Route

	Cooldowns[RaceKey] = Cooldowns[RaceKey] or {}

	if Cooldowns[RaceKey][Passport] and (os.time() < Cooldowns[RaceKey][Passport]) then
		return TriggerClientEvent("Notify",source,"Atenção",("Aguarde <b>%s</b> para participar novamente."):format(CompleteTimers(Cooldowns[RaceKey][Passport] - os.time())),"amarelo",5000)
	end

	local Consult = vRP.ConsultItem(Passport,"racesticket")
	if type(Consult) == "table" and Consult.Amount > 0 and vRP.TakeItem(Passport,Consult.Item,1,true,Consult.Slot) then
		Cooldowns[RaceKey] = Cooldowns[RaceKey] or {}
		Cooldowns[RaceKey][Passport] = os.time() + 60
		Payments[Passport] = true

		if not Lobbies[RaceKey] then
			Lobbies[RaceKey] = { ActiveRaces = {}, Participants = {}, Creator = Passport, Started = false, MaxRunners = Routes[Route] and Routes[Route].Runners or 1 }
		end

		if Lobbies[RaceKey].Started then
			Payments[Passport] = nil
			Cooldowns[RaceKey][Passport] = nil
			return false
		end

		local Racers = 0
		for _ in pairs(Lobbies[RaceKey].ActiveRaces) do
			Racers = Racers + 1
		end
		
		if Racers >= Lobbies[RaceKey].MaxRunners then
			Payments[Passport] = nil
			Cooldowns[RaceKey][Passport] = nil
			return false
		end

		Lobbies[RaceKey].ActiveRaces[Passport] = true
		Lobbies[RaceKey].Participants[Passport] = { Checkpoint = 1, Distance = 0 }

		if Races[Mode] and Races[Mode]["Global"] then
			GlobalState["Races:"..RaceKey] = false
		end

		vCLIENT.UpdatePosition(source, 1, {})
		local RouteData = Races[Mode].Routes[Route]
		return RouteData and RouteData.Time or 60
	else	
		TriggerClientEvent("Notify",source,"Atenção","Você precisa de <b>1x "..ItemName("racesticket").."</b>.","amarelo",5000)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UpdatePosition(Mode,Route,Checkpoint,Distance)
	local source = source
	local Passport = vRP.Passport(source)

	local RaceKey = Mode .. ":" .. Route

	-- CORREÇÃO: Permitir updates mesmo antes da corrida começar oficialmente
	if not Lobbies[RaceKey] then return end

	if Lobbies[RaceKey].Participants[Passport] then
		Lobbies[RaceKey].Participants[Passport] = { Checkpoint = Checkpoint, Distance = Distance }
	end

	local List = {}
	for Id, Data in pairs(Lobbies[RaceKey].Participants) do
		table.insert(List, { Passport = Id, Name = vRP.FullName(Id), Checkpoint = Data.Checkpoint, Distance = Data.Distance })
	end

	table.sort(List, function(a, b)
		if a.Checkpoint == b.Checkpoint then
			return a.Distance < b.Distance
		else
			return a.Checkpoint > b.Checkpoint
		end
	end)

	local Runners = {}
	local Position = 1
	for Index, Data in ipairs(List) do
		table.insert(Runners, { Passport = Data.Passport, Name = Data.Name, Checkpoint = Data.Checkpoint, Distance = Data.Distance })
		if Data.Passport == Passport then Position = Index end
	end

	vCLIENT.UpdatePosition(source, Position, Runners)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RUNNERS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Runners(Mode,Route)
	local RaceKey = Mode..":"..Route

	if Lobbies[RaceKey] then
		local Racers = 0

		for _ in pairs(Lobbies[RaceKey].ActiveRaces) do
			Racers = Racers + 1
		end

		return Racers < Lobbies[RaceKey].MaxRunners
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Ranking(Mode,Route)
	local Query = vRP.Query("Races/Consult", { Mode = Mode, Race = Route, Count = RankingTablet })
	local Ranking = { {}, false }

	if #Query > 0 then
		Ranking[2] = {}
		for k, v in ipairs(Query) do
			table.insert(Ranking[1], { Name = vRP.FullName(v["Passport"]), Time = tonumber(Dotted(v["Points"])), Vehicle = VehicleName(v["Vehicle"]) })

			if k == 1 then
				Ranking[2] = { Name = vRP.FullName(v["Passport"]), Position = v["Race"], Time = tonumber(Dotted(v["Points"])), Vehicle = VehicleName(v["Vehicle"]) }
			end
		end
	end

	return Ranking
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANKINGGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RankingGlobal()
	local Ranking = {}

	local Query = exports.oxmysql:query_async("SELECT * FROM races")

	for k, v in ipairs(Query) do
		Ranking[#Ranking + 1] = { Index = v["id"], Name = vRP.FullName(v["Passport"]), Passport = v["Passport"], Points = v["Points"] }
	end

	return Ranking or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLESHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.VehicleShop()
	local source = source
	local Passport = vRP.Passport(source)
	local ItemAmount, ItemName, ItemSlot = table.unpack(vRP.InventoryItemAmount(Passport,ExchangeItem))
	local Vehicles = {}
	for Index,v in pairs(VehicleList()) do
		if VehicleClass(Index) == "Races" then
			Vehicles[Index] = { Name = v["Name"], Price = v["Price"], Stock = v["Stock"] - vRP.Scalar("vehicles/Count",{ Vehicle = Index }) }
		end
	end

	return { ItemAmount, Vehicles }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RENTALVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.RentalVehicle(Name)
	local source = source
	local Passport = vRP.Passport(source)
	if Passport and Name and VehicleExist(Name) then
		if vRP.SelectVehicle(Passport,Name) then
			TriggerClientEvent("races:Notify",source,"Aviso","Já possui um <b>"..VehicleName(Name).."</b>.","amarelo")
		else
			local StockVehicle = VehicleStock(Name)
			local VehiclePrice = VehicleGemstone(Name)
			if StockVehicle and vRP.Scalar("vehicles/Count",{ Vehicle = Name }) >= StockVehicle then
				TriggerClientEvent("races:Notify",source,"Aviso","Estoque insuficiente.","amarelo")
				return true
			end

			if VehiclePrice and vRP.TakeItem(Passport,ExchangeItem,VehiclePrice) then
				vRP.Query("vehicles/rentalVehicles",{ Passport = Passport, Vehicle = Name, Plate = vRP.GeneratePlate(), Days = VehicleDuration / (60 * 60 * 24), Weight = VehicleWeight(Name), Work = 0 })
				TriggerClientEvent("races:Notify",source,"Sucesso","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.","verde")

				return true
			else
				TriggerClientEvent("races:Notify",source,"Aviso","Platina insuficiente.","amarelo")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.GlobalState(Mode,Route)
	local source = source
	local Passport = vRP.Passport(source)
	local RaceKey = Mode..":"..Route

	if Races[Mode] and Races[Mode]["Global"] and Lobbies[RaceKey] and Lobbies[RaceKey].Creator == Passport and not Lobbies[RaceKey].Started then
		Lobbies[RaceKey].Started = true

		GlobalState["Races:"..RaceKey] = true

		local List = {}
		for Passport in pairs(Lobbies[RaceKey].ActiveRaces) do
			table.insert(List, Passport)
		end

		table.sort(List)

		local Positions = {}
		for index, Passport in ipairs(List) do
			Positions[Passport] = index
		end

		SetTimeout(100, function()
			for Passport in pairs(Lobbies[RaceKey].ActiveRaces) do
				local Player = vRP.Source(Passport)
				if Player then
					vCLIENT.UpdatePosition(Player, Positions[Passport], {})
					TriggerClientEvent('races:Start', Player, Mode, Route)
				end
			end
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Cancel(source,Passport)
	local source = source
	local Passport = Passport or vRP.Passport(source)

	for RaceKey, Lobby in pairs(Lobbies) do
		if Lobby.ActiveRaces[Passport] then
			Lobby.ActiveRaces[Passport] = nil
			Lobby.Participants[Passport] = nil

			if Lobby.Creator == Passport and not Lobby.Started then
				for Racer in pairs(Lobby.ActiveRaces) do
					local Participant = vRP.Source(Racer)
					if Participant then
						TriggerClientEvent("races:Notify",Participant,"Aviso","O criador da corrida cancelou o lobby.","amarelo",5000)
						vCLIENT.StopCircuit(Participant, true)
					end
				end

				GlobalState["Races:"..RaceKey] = nil
				Lobbies[RaceKey] = nil
			elseif next(Lobby.ActiveRaces) == nil then
				GlobalState["Races:"..RaceKey] = nil
				Lobbies[RaceKey] = nil
			end

			break
		end
	end

	Payments[Passport] = nil
	exports.markers:Exit(source)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport,source)
	Creative.Cancel(source,Passport)
end)