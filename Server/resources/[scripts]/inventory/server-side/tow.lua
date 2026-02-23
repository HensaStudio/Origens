-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:TOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Tow")
AddEventHandler("inventory:Tow",function(Vehicle,Selected,Mode)
	local source = source
	local Players = vRPC.Players(source)
	for Passport,PlayerSource in pairs(Players) do
		async(function()
			TriggerClientEvent("inventory:ClientTow",PlayerSource,Vehicle,Selected,Mode)
		end)
	end
end)