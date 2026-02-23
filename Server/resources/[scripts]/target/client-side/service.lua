-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Services = {
	{
		Permission = "LSPD",
		Coords = vec3(441.80,-982.06,30.84),
		Distance = 1.5,
		Weight = 0.1
	},{
		Permission = "PRPD",
		Coords = vec3(385.44,794.43,187.48),
		Distance = 1.5,
		Weight = 0.1
	},{
		Permission = "Paramedic",
		Coords = vec3(311.83,-593.33,43.09),
		Distance = 1.5,
		Weight = 0.1
	},{
		Permission = "Mechanic",
		Coords = vec3(952.02,-968.35,39.33),
		Distance = 1.5,
		Weight = 0.1
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(Services) do
		exports.target:AddCircleZone("Service:"..Index,v.Coords,v.Weight,{
			name = "Service:"..Index,
			heading = 0.0,
			useZ = true
		},{
			Distance = v.Distance,
			options = {
				{
					event = "target:Service",
					label = "Iniciar Expediente",
					service = v.Permission,
					tunnel = "proserver"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:CLIENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("service:Client")
AddEventHandler("service:Client",function(Permission,Status)
	for Index,v in pairs(Services) do
		if Permission == v.Permission then
			exports.target:LabelText("Service:"..Index,(Status and "Finalizar Expediente" or "Iniciar Expediente"))
		end
	end
end)