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
Tunnel.bindInterface("hud",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANDOMWEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
local function RandomWeather()
	local Chance = 0
	for _,List in pairs(Config["Weather"]) do
		Chance = Chance + List.Chance
	end

	local Random = math.random() * Chance
	local Result = 0

	for _,List in pairs(Config["Weather"]) do
		Result = Result + List.Chance
		if Random <= Result then
			return List.Weather
		end
	end

	return "CLEAR"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Work"] = 0
GlobalState["Hours"] = 10
GlobalState["Players"] = 0
GlobalState["Minutes"] = 0
GlobalState["Weather"] = RandomWeather()
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		GlobalState["Work"] = (GlobalState["Work"] or 0) + 1
		GlobalState["Minutes"] = (GlobalState["Minutes"] or 0) + 1

		if GlobalState["Minutes"] >= 60 then
			GlobalState["Minutes"] = 0
			GlobalState["Hours"] = (GlobalState["Hours"] or 0) + 1

			if GlobalState["Hours"] >= 24 then
				GlobalState["Hours"] = 0
				GlobalState["Weather"] = RandomWeather()
			end
		end

		Wait(10000)
	end
end)