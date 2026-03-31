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
Tunnel.bindInterface("lscustoms",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Networked = {}
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(First,Second,Third)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false,"nopermission"
	end

	local Index
	local Model
	local Plate

	if Third ~= nil then
		Index = First
		Model = Second
		Plate = Third
	elseif Second ~= nil then
		Model = First
		Plate = Second
	else
		Index = First
	end

	if Index then
		local Location = Locations[Index]
		if not Location or (Location.Permission and not vRP.HasService(Passport,Location.Permission)) then
			return false,"nopermission"
		end

		if exports.bank:CheckTaxes(Passport) or exports.bank:CheckFines(Passport) then
			return false,"nopermission"
		end
	end

	if Model and Plate then
		Model = string.lower(Model)
		local VehicleData = vRP.SingleQuery("vehicles/plateVehicles",{ Plate = Plate })
		if not VehicleData or VehicleData.Vehicle ~= Model then
			return false,"novehicle"
		end
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Save(Model,Plate,Initial)
	local source = source
	local Passport = vRP.Passport(source)
	Model = string.lower(Model)
	local Price = Calculate(Initial,Model)
	if not Passport or (Price > 0 and not vRP.PaymentFull(Passport,Price,true)) then
		return false
	end

	local VehicleData = vRP.SingleQuery("vehicles/plateVehicles",{ Plate = Plate })
	if not VehicleData or VehicleData.Vehicle ~= Model then
		return false
	end

	local Key = "LsCustoms:"..VehicleData.id..":"..VehicleData.Vehicle
	local Consult = vRP.GetSrvData(Key,true)
	for Index,v in pairs(Initial) do
		if Index == "VehicleExtras" then
			for Type,Data in pairs(v) do
				if Data.Installed ~= Data.Selected then
					Consult.VehicleExtras = Consult.VehicleExtras or {}
					Consult.VehicleExtras[Type] = Data.Selected
				end
			end
		elseif Index == "Respray" then
			Consult.Respray = {
				PrimaryColour = {
					Type = v.PrimaryColour.Selected.Type,
					Color = v.PrimaryColour.Selected.Color
				},
				SecondaryColour = {
					Type = v.SecondaryColour.Selected.Type,
					Color = v.SecondaryColour.Selected.Color
				},
				PearlescentColour = v.PearlescentColour.Selected,
				WheelColour = v.WheelColour.Selected,
				DashboardColour = v.DashboardColour.Selected,
				InteriorColour = v.InteriorColour.Selected
			}
		elseif Index == "Wheels" then
			for Type,Data in pairs(v) do
				if Data.Installed ~= Data.Selected then
					if Consult[Index] then
						if Type == "TyreSmoke" then
							Consult[Index].TyreSmoke = Initial[Index].TyreSmoke.Selected
						elseif Type == "CustomTyres" then
							Consult[Index].CustomTyres = Initial[Index].CustomTyres.Selected
						else
							Consult[Index].Category = Type
							Consult[Index].Value = Data.Selected
						end
					else
						if Type == "TyreSmoke" then
							Consult[Index] = {
								TyreSmoke = Initial[Index].TyreSmoke.Selected
							}
						elseif Type == "CustomTyres" then
							Consult[Index] = {
								CustomTyres = Initial[Index].CustomTyres.Selected
							}
						else
							Consult[Index] = {
								Category = Type,
								Value = Data.Selected
							}
						end
					end
				end
			end
		elseif v.Installed ~= v.Selected then
			Consult[Index] = v.Selected
		end
	end

	vRP.SetSrvData(Key,Consult,true)

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LSCUSTOMS:NETWORK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("lscustoms:Network")
AddEventHandler("lscustoms:Network",function(Network,Plate)
	local source = source
	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	if Network then
		Networked[Passport] = { Network,Plate }
	else
		Networked[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if not Networked[Passport] then
		return false
	end

	SetTimeout(2500,function()
		local Network,Plate = table.unpack(Networked[Passport])
		TriggerEvent("garages:Deleted",Network,Plate)
		Networked[Passport] = nil
	end)
end)
