-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MARRIAGE:REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("marriage:Request")
AddEventHandler("marriage:Request",function(OtherSource)
    local source = source
    local Passport = vRP.Passport(source)
    local OtherPassport = vRP.Passport(OtherSource)
    if Passport and OtherPassport then
		local Price = 2575
        local Model = vRP.ModelPlayer(source)
        local Sex = (Model == "mp_f_freemode_01") and "F" or "M"

        local OtherModel = vRP.ModelPlayer(OtherSource)
        local OtherSex = (OtherModel == "mp_f_freemode_01") and "F" or "M"

        vRPC.playAnim(source,false,{"ultra@propose","propose"},true)
        vRPC.CreateObjects(source,"","","ultra_ringcase",49,28422,0.08,0.01,-0.055,0.0,180.0,-90.0)

        if vRP.Request(OtherSource,"Casamento","Aceita se casar com <b>"..vRP.FullName(Passport).."</b>?") then
			-- if vRP.PaymentFull(Passport,Price,true) then
				vRP.GenerateItem(Passport,"alliance-"..OtherPassport.."-"..vRP.FullName(OtherPassport),1,true)
				vRP.GenerateItem(OtherPassport,"alliance-"..Passport.."-"..vRP.FullName(Passport),1,true)

				TriggerClientEvent("marriage:Accept",source,OtherSex,vRP.FullName(OtherPassport))
				TriggerClientEvent("marriage:Accept",OtherSource,Sex,vRP.FullName(Passport))

				TriggerEvent("chat:ServerImportant",vRP.FullName(Passport).." se casou com "..vRP.FullName(OtherPassport))
			-- else
				-- TriggerClientEvent("Notify",source,"Aviso","Dinheiro insuficiente.","amarelo",5000)
			-- end
        else
            TriggerClientEvent("marriage:Reject",source,vRP.FullName(OtherPassport))
        end
    end
end)