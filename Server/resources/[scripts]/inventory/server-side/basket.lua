-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
BasketPrice = 375
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUYBASKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:BuyBasket")
AddEventHandler("inventory:BuyBasket",function()
	local source = source
	local Passport = vRP.Passport(source)
	if Passport then
		if vRP.Request(source,"Plantações","Deseja realmente comprar <b>1x "..ItemName("basket").."</b> por <b>"..Currency..""..Dotted(BasketPrice).."</b>?") then
			if vRP.PaymentFull(Passport,BasketPrice,true) then
				vRP.GenerateItem(Passport,"basket",1,true)
			else
				TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
			end
		end
	end
end)