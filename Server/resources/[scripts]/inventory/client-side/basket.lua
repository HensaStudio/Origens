-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
Basket = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BASKETREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:BasketRemove")
AddEventHandler("inventory:BasketRemove",function()
	if Basket and DoesEntityExist(Basket) then
		TriggerServerEvent("DeleteObject",NetworkGetNetworkIdFromEntity(Basket))
		Basket = nil

		LocalPlayer["state"]:set("Basket",false,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BASKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Basket")
AddEventHandler("inventory:Basket",function()
	if Basket then
		TriggerEvent("inventory:BasketRemove")
	else
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)

		local Networked = vRPS.CreateObject("prop_fruit_basket",Coords.x,Coords.y,Coords.z)
		if not Networked then return end

		Basket = LoadNetwork(Networked)
		while not DoesEntityExist(Basket) do
			Wait(100)
		end

		AttachEntityToEntity(Basket,Ped,GetPedBoneIndex(Ped,18905),0.38,0.03,-0.02,-90.0,0.0,90.0,true,true,false,true,2,true)

		SetEntityLodDist(Basket,0xFFFF)

		LocalPlayer["state"]:set("Basket",true,true)
	end
end)