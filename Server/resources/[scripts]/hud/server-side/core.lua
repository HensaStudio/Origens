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
-- WEATHERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local WeatherList = {
	{ Weather = "EXTRASUNNY", Chance = 20 },
	{ Weather = "CLEAR", Chance = 20 },
	{ Weather = "CLOUDS", Chance = 15 },
	{ Weather = "OVERCAST", Chance = 10 },
	{ Weather = "FOGGY", Chance = 5 },
	{ Weather = "RAIN", Chance = 10 },
	{ Weather = "THUNDER", Chance = 5 },
	{ Weather = "CLEARING", Chance = 15 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RANDOMWEATHER
-----------------------------------------------------------------------------------------------------------------------------------------
local function RandomWeather()
	local Chance = 0
	for _,List in pairs(WeatherList) do
		Chance = Chance + List.Chance
	end

	local Random = math.random() * Chance
	local Result = 0

	for _,List in pairs(WeatherList) do
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
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("timeset",function(source,Message)
	local Passport = vRP.Passport(source)
	if Passport and vRP.HasGroup(Passport,"Admin") then
		local List = { "EXTRASUNNY","CLEAR","NEUTRAL","SMOG","FOGGY","OVERCAST","CLOUDS","CLEARING","RAIN","THUNDER","SNOW","BLIZZARD","SNOWLIGHT","XMAS","HALLOWEEN" }

		local Keyboard = vKEYBOARD.Timeset(source,"Hora","Minuto",List)
		if Keyboard then
			local Hours = parseInt(Keyboard[1])
			local Minutes = parseInt(Keyboard[2])

			if Hours >= 24 or Hours <= 0 then
				Hours = 0
			end

			if Minutes >= 60 or Minutes <= 0 then
				Minutes = 0
			end

			GlobalState["Hours"] = Hours
			GlobalState["Minutes"] = Minutes
			GlobalState["Weather"] = Keyboard[3]

			TriggerClientEvent("Notify",source,ServerName,WeatherWarning.." <b>"..WeathersType(Keyboard[3]).."</b>.","weather",10000,"bottom-center")
		else
			TriggerClientEvent("Notify",source,"Atenção","Você não pode deixar campos vazios.","amarelo",5000)
		end
	end
end)