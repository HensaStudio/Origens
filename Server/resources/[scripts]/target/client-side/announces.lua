-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Announces) do
		exports.target:AddCircleZone("Announces:"..Number,v.Coords,0.45,{
			name = "Announces:"..Number,
			heading = 0.0,
			useZ = true
		},{
			shop = Number,
			Distance = 1.25,
			options = {
				{
					event = "target:Announces",
					tunnel = "proserver",
					label = "Anúnciar",
					service = v.Service
				}
			}
		})
	end
end)