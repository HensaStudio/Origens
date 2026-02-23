-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Radio = {
	["911"] = "Police",
	["912"] = "Police",
	["913"] = "Police",
	["914"] = "Police",
	["915"] = "Police",
	["916"] = "Police",
	["917"] = "Police",
	["918"] = "Police",
	["919"] = "Police",
	["920"] = "Police",
	["112"] = "Paramedic",
	["113"] = "Paramedic",
	["114"] = "Paramedic"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FREQUENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Frequency(Number)
	local source = source
	local Number = tostring(Number)
	local Passport = vRP.Passport(source)
	if Passport and Radio[Number] and not vRP.HasService(Passport,Radio[Number]) then
		TriggerClientEvent("Notify",source,"Atenção","Necessário permissão para efetuar conexão.","amarelo",5000)

		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINITSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local Consult = vRP.GetSrvData("Radio",true)
	if Consult then
		for Number,Permission in pairs(Consult) do
			Radio[Number] = Permission
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
exports("RadioExist",function(Number)
	return Radio[Number]
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOADD
-----------------------------------------------------------------------------------------------------------------------------------------
exports("RadioAdd",function(Number,Permission)
	local Consult = vRP.GetSrvData("Radio",true)
	if Consult then
		Radio[Number] = Permission
		Consult[Number] = Permission

		vRP.SetSrvData("Radio",Consult,true)
	end
end)