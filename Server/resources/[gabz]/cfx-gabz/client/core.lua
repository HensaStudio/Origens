-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERIORS
-----------------------------------------------------------------------------------------------------------------------------------------
local Interiors = {
	{
		ipl = "gabz_imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_",
		coords = { x = 941.00840000, y = -972.66450000, z = 39.14678000 },
		entitySets = {
			{ name = "basic_style_set", enable = false },
			{ name = "urban_style_set", enable = false },
			{ name = "branded_style_set", enable = true },
			{ name = "car_floor_hatch", enable = true },
		}
	},
	{
		ipl = "gabz_pillbox_milo_",
		coords = { x = 311.2546, y = -592.4204, z = 42.32737 },
		entitySets = {
			{ name = "rc12b_fixed", enable = false },
			{ name = "rc12b_destroyed", enable = false },
			{ name = "rc12b_default", enable = false },
			{ name = "rc12b_hospitalinterior_lod", enable = false },
			{ name = "rc12b_hospitalinterior", enable = false },
		}
	},
	{
		ipl = "gabz_mrpd_milo_",
		coords = { x = 451.0129, y = -993.3741, z = 29.1718 },
		entitySets = {
			{ name = "v_gabz_mrpd_rm1" , enable = true },
			{ name = "v_gabz_mrpd_rm2" , enable = true },
			{ name = "v_gabz_mrpd_rm3" , enable = true },
			{ name = "v_gabz_mrpd_rm4" , enable = true },
			{ name = "v_gabz_mrpd_rm5" , enable = true },
			{ name = "v_gabz_mrpd_rm6" , enable = true },
			{ name = "v_gabz_mrpd_rm7" , enable = true },
			{ name = "v_gabz_mrpd_rm8" , enable = true },
			{ name = "v_gabz_mrpd_rm9" , enable = true },
			{ name = "v_gabz_mrpd_rm10", enable = true },
			{ name = "v_gabz_mrpd_rm11", enable = true },
			{ name = "v_gabz_mrpd_rm12", enable = true },
			{ name = "v_gabz_mrpd_rm13", enable = true },
			{ name = "v_gabz_mrpd_rm14", enable = true },
			{ name = "v_gabz_mrpd_rm15", enable = true },
			{ name = "v_gabz_mrpd_rm16", enable = true },
			{ name = "v_gabz_mrpd_rm17", enable = true },
			{ name = "v_gabz_mrpd_rm18", enable = true },
			{ name = "v_gabz_mrpd_rm19", enable = true },
			{ name = "v_gabz_mrpd_rm20", enable = true },
			{ name = "v_gabz_mrpd_rm21", enable = true },
			{ name = "v_gabz_mrpd_rm22", enable = true },
			{ name = "v_gabz_mrpd_rm23", enable = true },
			{ name = "v_gabz_mrpd_rm24", enable = true },
			{ name = "v_gabz_mrpd_rm25", enable = true },
			{ name = "v_gabz_mrpd_rm26", enable = true },
			{ name = "v_gabz_mrpd_rm27", enable = true },
			{ name = "v_gabz_mrpd_rm28", enable = true },
			{ name = "v_gabz_mrpd_rm29", enable = true },
			{ name = "v_gabz_mrpd_rm30", enable = true },
			{ name = "v_gabz_mrpd_rm31", enable = true },
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INTERIORSTHREAD
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for i = 1, #Interiors do
		local interior = Interiors[i]
		local entitySets = interior.entitySets
		if not interior.ipl or not interior.coords or not entitySets then
			print("^5[GABZ]^7 ^1Error while loading Interiors.^7")
			return
		end

		RequestIpl(interior.ipl)
		local interiorID = GetInteriorAtCoords(interior.coords.x, interior.coords.y, interior.coords.z)
		if IsValidInterior(interiorID) then
			for k = 1, #entitySets do
				local entitySet = entitySets[k]
				if entitySet.enable then
					EnableInteriorProp(interiorID, entitySet.name)
					if entitySet.color then
						SetInteriorPropColor(interiorID, entitySet.name, entitySet.color)
					end
				else
					DisableInteriorProp(interiorID, entitySet.name)
				end
			end
			RefreshInterior(interiorID)
		end

		local exterior_ipl = interior.exterior_ipl
		if exterior_ipl then
			for j = 1, #exterior_ipl do
				local ext_ipl = exterior_ipl[j]
				RequestIpl(ext_ipl)
			end
		end
	end

	print("^5[GABZ]^7 Interior data loaded.")
end)