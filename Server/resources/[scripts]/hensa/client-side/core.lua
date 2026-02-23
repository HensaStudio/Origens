-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local CreatedBlips = {}
local CreatedRadiusBlips = {}
local CONTROLS = { 37,204,211,349,192,157,158,159,160,161,162,163,164,165 }
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBLIP
-----------------------------------------------------------------------------------------------------------------------------------------
local function CreateBlip(blipData)
	local Blip = AddBlipForCoord(blipData.Coords.x, blipData.Coords.y, blipData.Coords.z)

	if not DoesBlipExist(Blip) then
		return nil
	end

	SetBlipSprite(Blip, blipData.Sprite)
	SetBlipDisplay(Blip, 4)
	SetBlipAsShortRange(Blip, true)
	SetBlipColour(Blip, blipData.Color)
	SetBlipScale(Blip, blipData.Scale)

	local BlipName = blipData.Name or "Sem Nome"
	if string.len(BlipName) > 99 then
		BlipName = string.sub(BlipName, 1, 96) .. "..."
	end

	BlipName = string.gsub(BlipName, "~", "")
	BlipName = string.gsub(BlipName, ":", " -")

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName(BlipName)
	EndTextCommandSetBlipName(Blip)

	return Blip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEBLIPRADIUS
-----------------------------------------------------------------------------------------------------------------------------------------
local function CreateBlipRadius(alphaData)
	local Coords = alphaData.Coords or alphaData[1]
	local Alpha = alphaData.Alpha or alphaData[2]
	local Color = alphaData.Color or alphaData[3]
	local Radius = alphaData.Radius or alphaData[4]

	local Blip = AddBlipForRadius(Coords.x, Coords.y, Coords.z, Radius)

	if not DoesBlipExist(Blip) then
		return nil
	end

	SetBlipAlpha(Blip, Alpha)
	SetBlipColour(Blip, Color)

	return Blip
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLIPS
-----------------------------------------------------------------------------------------------------------------------------------------
local BLIPS = {
	{ Coords = vec3(300.44,-585.01,43.29), Sprite = 428, Color = 42, Name = "Hospital", Scale = 0.6 },

	{ Coords = vec3(945.74,-984.64,39.5), Sprite = 402, Color = 35, Name = "Mecânica", Scale = 0.8 },

	{ Coords = vec3(-1184.41,-884.87,13.8), Sprite = 457, Color = 49, Name = "BurgerShot", Scale = 0.7 },

	{ Coords = vec3(-1741.52,-219.85,56.14), Sprite = 429, Color = 62, Name = "Cemitério", Scale = 0.6 },

	{ Coords = vec3(436.08,-981.87,30.68), Sprite = 60, Color = 64, Name = "Departamento Policial: LSPD", Scale = 0.6 },
	{ Coords = vec3(386.87,793.51,187.45), Sprite = 60, Color = 25, Name = "Departamento Policial: PRPD", Scale = 0.6 },

	{ Coords = vec3(1849.95,2586.06,45.67), Sprite = 438, Color = 22, Name = "Penitenciária de Bolingbroke", Scale = 0.6 },

	{ Coords = vec3(265.01,-1261.14,29.28), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(818.8,-1027.92,26.4), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1208.61,-1402.43,35.23), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1181.48,-330.26,69.32), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(621.01,268.68,103.09), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(2581.09,361.79,108.47), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(175.08,-1562.12,29.27), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-319.76,-1471.63,30.55), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(49.42,2778.8,58.05), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(264.09,2606.56,44.99), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1039.38,2671.28,39.56), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1207.4,2659.93,37.9), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(2539.19,2594.47,37.95), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(2679.95,3264.18,55.25), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(2005.03,3774.43,32.41), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1687.07,4929.53,42.08), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1701.53,6415.99,32.77), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(180.1,6602.88,31.87), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-94.46,6419.59,31.48), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-2555.17,2334.23,33.08), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-1800.09,803.54,138.72), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-1437.0,-276.8,46.21), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-2096.3,-320.17,13.17), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-724.56,-935.97,19.22), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-525.26,-1211.19,18.19), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(-70.96,-1762.21,29.54), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },
	{ Coords = vec3(1785.41,3330.36,41.38), Sprite = 361, Color = 65, Name = "Posto de Combustível", Scale = 0.6 },

	{ Coords = vec3(-969.82,-2103.53,9.3), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-1692.18,-948.58,7.67), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-460.56,-610.57,31.32), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(583.02,2717.7,42.09), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-753.03,-1081.23,11.71), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-2193.11,4243.34,48.04), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-140.82,6278.8,31.34), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(863.0,-3147.94,5.9), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-1682.24,72.51,64.21), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-978.38,-181.33,38.03), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(2579.4,436.07,108.45), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(688.45,237.9,93.47), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(2779.23,3491.91,55.18), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(1733.68,6406.37,34.76), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-755.84,5551.38,33.48), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(-2528.37,2350.46,33.21), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },
	{ Coords = vec3(1952.93,3757.09,32.2), Sprite = 354, Color = 60, Name = "Posto de Recarga", Scale = 1.0 },

	{ Coords = vec3(149.64,-1041.36,29.59), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(313.95,-279.74,54.39), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(-351.2,-50.57,49.26), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(-2961.85,482.87,15.92), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(1175.09,2707.53,38.31), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(-1212.37,-331.37,38.0), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },
	{ Coords = vec3(-112.86,6470.46,31.85), Sprite = 108, Color = 25, Name = "Banco", Scale = 0.7 },

	{ Coords = vec3(55.43,-876.19,30.66), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(598.04,2741.27,42.07), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-139.91,6365.12,31.51), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(275.23,-345.54,45.17), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(596.40,90.65,93.12), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-340.76,265.97,85.67), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-2030.01,-465.97,11.60), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-1184.92,-1510.00,4.64), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(214.02,-808.44,31.01), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-348.88,-874.02,31.31), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(67.74,12.27,69.21), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(361.90,297.81,103.88), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(1035.89,-763.89,57.99), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-796.63,-2022.77,9.16), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(453.27,-1146.76,29.52), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(528.66,-146.3,58.38), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-1159.48,-739.32,19.89), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(101.22,-1073.68,29.38), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(1725.21,4711.77,42.11), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(1416.26,3607.9,35.0), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(-73.35,-2004.6,18.27), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },
	{ Coords = vec3(1200.52,-1276.06,35.22), Sprite = 357, Color = 2, Name = "Garagem", Scale = 0.6 },

	{ Coords = vec3(1331.48,4271.61,31.49), Sprite = 356, Color = 2, Name = "Embarcações", Scale = 0.6 },

	{ Coords = vec3(2003.91,4230.95,29.93), Sprite = 1, Color = 53, Name = "Área de Pesca", Scale = 0.6 },
	{ Coords = vec3(1038.35,3938.64,31.27), Sprite = 1, Color = 53, Name = "Área de Pesca", Scale = 0.6 },
	{ Coords = vec3(210.77,4032.24,30.72), Sprite = 1, Color = 53, Name = "Área de Pesca", Scale = 0.6 },

	{ Coords = vec3(29.2,-1351.89,29.34), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(2561.74,385.22,108.61), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1160.21,-329.4,69.03), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-711.99,-919.96,19.01), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-54.56,-1758.56,29.05), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(375.87,320.04,103.42), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-3237.48,1004.72,12.45), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1730.64,6409.67,35.0), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(543.51,2676.85,42.14), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1966.53,3737.95,32.18), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(2684.73,3281.2,55.23), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1696.12,4931.56,42.07), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-1820.18,785.69,137.98), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1395.35,3596.6,34.86), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-2977.14,391.22,15.03), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-3034.99,590.77,7.8), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1144.46,-980.74,46.19), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(1166.06,2698.17,37.95), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-1493.12,-385.55,39.87), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-1228.6,-899.7,12.27), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },
	{ Coords = vec3(-160.54,6320.95,31.59), Sprite = 52, Color = 36, Name = "Loja de Departamento", Scale = 0.7 },

	{ Coords = vec3(1692.27,3760.91,34.69), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(253.8,-50.47,69.94), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(842.54,-1035.25,28.19), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(-331.67,6084.86,31.46), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(-662.37,-933.58,21.82), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(-1304.12,-394.56,36.7), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(-1118.98,2699.73,18.55), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(2567.98,292.62,108.73), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(-3173.51,1088.35,20.84), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(22.53,-1105.52,29.79), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },
	{ Coords = vec3(810.22,-2158.99,29.62), Sprite = 76, Color = 6, Name = "Loja de Armas", Scale = 0.5 },

	{ Coords = vec3(-815.12,-184.15,37.57), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(139.56,-1704.12,29.05), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(-1278.11,-1116.66,6.75), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(1928.89,3734.04,32.6), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(1217.05,-473.45,65.96), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(-34.08,-157.01,56.83), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },
	{ Coords = vec3(-274.5,6225.27,31.45), Sprite = 71, Color = 12, Name = "Barbearia", Scale = 0.7 },

	{ Coords = vec3(86.06,-1391.64,29.23), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-719.94,-158.18,37.0), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-152.79,-306.79,38.67), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-816.39,-1081.22,11.12), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-1206.51,-781.5,17.12), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-1458.26,-229.79,49.2), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-2.41,6518.29,31.48), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(1682.59,4819.98,42.04), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(129.46,-205.18,54.51), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(618.49,2745.54,42.01), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(1197.93,2698.21,37.96), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-3165.74,1061.29,20.84), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(-1093.76,2703.99,19.04), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },
	{ Coords = vec3(414.86,-807.57,29.34), Sprite = 366, Color = 41, Name = "Loja de Roupas", Scale = 0.6 },

	{ Coords = vec3(356.42,274.61,103.14), Sprite = 67, Color = 25, Name = "Transportador", Scale = 0.6 },

	{ Coords = vec3(375.3,-829.75,29.28), Sprite = 403, Color = 5, Name = "Farmácia", Scale = 0.7 },
	{ Coords = vec3(1654.0,4874.14,42.11), Sprite = 403, Color = 5, Name = "Farmácia", Scale = 0.7 },

	{ Coords = vec3(-339.89,-1560.35,25.22), Sprite = 318, Color = 62, Name = "Lixeiro", Scale = 0.6 },
	{ Coords = vec3(19.19,6505.68,31.49), Sprite = 318, Color = 62, Name = "Lixeiro", Scale = 0.6 },

	{ Coords = vec3(-191.36,-1161.28,23.67), Sprite = 477, Color = 51, Name = "Reboque", Scale = 0.6 },

	{ Coords = vec3(966.47,-1914.76,31.14), Sprite = 467, Color = 11, Name = "Recicladora", Scale = 0.8 },
	{ Coords = vec3(-178.19,6261.09,31.49), Sprite = 467, Color = 11, Name = "Recicladora", Scale = 0.8 },
	{ Coords = vec3(270.14,2858.27,43.64), Sprite = 467, Color = 11, Name = "Recicladora", Scale = 0.8 },

	{ Coords = vec3(1110.8,-2008.75,31.43), Sprite = 78, Color = 11, Name = "Metalúrgica", Scale = 0.7 },

	{ Coords = vec3(1327.98,-1654.78,52.03), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },
	{ Coords = vec3(-1149.04,-1428.64,4.71), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },
	{ Coords = vec3(322.01,186.24,103.34), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },
	{ Coords = vec3(-3175.64,1075.54,20.58), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },
	{ Coords = vec3(1866.01,3748.07,32.79), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },
	{ Coords = vec3(-295.51,6199.21,31.24), Sprite = 75, Color = 66, Name = "Loja de Tatuagem", Scale = 0.7 },

	{ Coords = vec3(1532.56,1721.97,109.98), Sprite = 140, Color = 2, Name = "Colheita", Scale = 0.6 },

	{ Coords = vec3(-36.18,-1105.51,26.42), Sprite = 225, Color = 75, Name = "Concessionária", Scale = 0.6 },

	{ Coords = vec3(1274.71,-1720.99,54.68), Sprite = 77, Color = 1, Name = "Lester", Scale = 0.6 },

	{ Coords = vec3(-773.02,5600.14,33.75), Sprite = 141, Color = 16, Name = "Caçador", Scale = 0.8 },

	{ Coords = vec3(454.73,-600.83,28.56), Sprite = 513, Color = 54, Name = "Motorista de Ônibus", Scale = 0.6 },

	{ Coords = vec3(-607.05,-925.7,23.86), Sprite = 501, Color = 51, Name = "Jornaleiro", Scale = 0.7 },

	{ Coords = vec3(910.9,-177.32,74.27), Sprite = 198, Color = 5, Name = "Taxista", Scale = 0.6 },

	{ Coords = vec3(963.13,-2215.33,30.55), Sprite = 77, Color = 21, Name = "Leiteiro", Scale = 0.6 },

	{ Coords = vec3(59.74,101.11,79.01), Sprite = 478, Color = 49, Name = "Grime", Scale = 0.6 },

	{ Coords = vec3(-1816.64,-1193.73,14.31), Sprite = 68, Color = 53, Name = "Pescador", Scale = 0.6 },

	{ Coords = vec3(1961.61,5179.26,47.94), Sprite = 285, Color = 56, Name = "Lenhador", Scale = 0.6 },

	{ Coords = vec3(2953.93,2787.49,41.5), Sprite = 617, Color = 84, Name = "Minerador", Scale = 0.6 },

	{ Coords = vec3(1239.87,-3257.2,7.09), Sprite = 67, Color = 62, Name = "Caminhoneiro", Scale = 0.6 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT
-----------------------------------------------------------------------------------------------------------------------------------------
local TELEPORT = {
	{ vec3(357.96,-1408.7,32.42),vec3(335.11,-1432.36,46.51) },
	{ vec3(335.11,-1432.36,46.51),vec3(357.96,-1408.7,32.42) },

	{ vec3(-741.07,5593.13,41.66),vec3(446.19,5568.79,781.19) },
	{ vec3(446.19,5568.79,781.19),vec3(-741.07,5593.13,41.66) },

	{ vec3(-740.78,5597.04,41.66),vec3(446.37,5575.02,781.19) },
	{ vec3(446.37,5575.02,781.19),vec3(-740.78,5597.04,41.66) },

	{ vec3(-71.05,-801.01,44.23),vec3(-75.0,-824.54,321.29) },
	{ vec3(-75.0,-824.54,321.29),vec3(-71.05,-801.01,44.23) },

	{ vec3(254.06,225.28,101.87),vec3(252.32,220.21,101.67) },
	{ vec3(252.32,220.21,101.67),vec3(254.06,225.28,101.87) }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALPHAS
-----------------------------------------------------------------------------------------------------------------------------------------
local ALPHAS = {
	{ Coords = vec3(2003.91,4230.95,29.93), Alpha = 100, Color = 53, Radius = 150.0 },
	{ Coords = vec3(1038.35,3938.64,31.27), Alpha = 100, Color = 53, Radius = 150.0 },
	{ Coords = vec3(210.77,4032.24,30.72), Alpha = 100, Color = 53, Radius = 150.0 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISLAND
-----------------------------------------------------------------------------------------------------------------------------------------
local ISLAND = {
	"h4_islandairstrip",
	"h4_islandairstrip_props",
	"h4_islandx_mansion",
	"h4_islandx_mansion_props",
	"h4_islandx_props",
	"h4_islandxdock",
	"h4_islandxdock_props",
	"h4_islandxdock_props_2",
	"h4_islandxtower",
	"h4_islandx_maindock",
	"h4_islandx_maindock_props",
	"h4_islandx_maindock_props_2",
	"h4_IslandX_Mansion_Vault",
	"h4_islandairstrip_propsb",
	"h4_beach",
	"h4_beach_props",
	"h4_beach_bar_props",
	"h4_islandx_barrack_props",
	"h4_islandx_checkpoint",
	"h4_islandx_checkpoint_props",
	"h4_islandx_Mansion_Office",
	"h4_islandx_Mansion_LockUp_01",
	"h4_islandx_Mansion_LockUp_02",
	"h4_islandx_Mansion_LockUp_03",
	"h4_islandairstrip_hangar_props",
	"h4_IslandX_Mansion_B",
	"h4_islandairstrip_doorsclosed",
	"h4_Underwater_Gate_Closed",
	"h4_mansion_gate_closed",
	"h4_aa_guns",
	"h4_IslandX_Mansion_GuardFence",
	"h4_IslandX_Mansion_Entrance_Fence",
	"h4_IslandX_Mansion_B_Side_Fence",
	"h4_IslandX_Mansion_Lights",
	"h4_islandxcanal_props",
	"h4_beach_props_party",
	"h4_islandX_Terrain_props_06_a",
	"h4_islandX_Terrain_props_06_b",
	"h4_islandX_Terrain_props_06_c",
	"h4_islandX_Terrain_props_05_a",
	"h4_islandX_Terrain_props_05_b",
	"h4_islandX_Terrain_props_05_c",
	"h4_islandX_Terrain_props_05_d",
	"h4_islandX_Terrain_props_05_e",
	"h4_islandX_Terrain_props_05_f",
	"h4_islandx_terrain_01",
	"h4_islandx_terrain_02",
	"h4_islandx_terrain_03",
	"h4_islandx_terrain_04",
	"h4_islandx_terrain_05",
	"h4_islandx_terrain_06",
	"h4_ne_ipl_00",
	"h4_ne_ipl_01",
	"h4_ne_ipl_02",
	"h4_ne_ipl_03",
	"h4_ne_ipl_04",
	"h4_ne_ipl_05",
	"h4_ne_ipl_06",
	"h4_ne_ipl_07",
	"h4_ne_ipl_08",
	"h4_ne_ipl_09",
	"h4_nw_ipl_00",
	"h4_nw_ipl_01",
	"h4_nw_ipl_02",
	"h4_nw_ipl_03",
	"h4_nw_ipl_04",
	"h4_nw_ipl_05",
	"h4_nw_ipl_06",
	"h4_nw_ipl_07",
	"h4_nw_ipl_08",
	"h4_nw_ipl_09",
	"h4_se_ipl_00",
	"h4_se_ipl_01",
	"h4_se_ipl_02",
	"h4_se_ipl_03",
	"h4_se_ipl_04",
	"h4_se_ipl_05",
	"h4_se_ipl_06",
	"h4_se_ipl_07",
	"h4_se_ipl_08",
	"h4_se_ipl_09",
	"h4_sw_ipl_00",
	"h4_sw_ipl_01",
	"h4_sw_ipl_02",
	"h4_sw_ipl_03",
	"h4_sw_ipl_04",
	"h4_sw_ipl_05",
	"h4_sw_ipl_06",
	"h4_sw_ipl_07",
	"h4_sw_ipl_08",
	"h4_sw_ipl_09",
	"h4_islandx_mansion",
	"h4_islandxtower_veg",
	"h4_islandx_sea_mines",
	"h4_islandx",
	"h4_islandx_barrack_hatch",
	"h4_islandxdock_water_hatch",
	"h4_beach_party",
	"h4_mph4_terrain_01_grass_0",
	"h4_mph4_terrain_01_grass_1",
	"h4_mph4_terrain_02_grass_0",
	"h4_mph4_terrain_02_grass_1",
	"h4_mph4_terrain_02_grass_2",
	"h4_mph4_terrain_02_grass_3",
	"h4_mph4_terrain_04_grass_0",
	"h4_mph4_terrain_04_grass_1",
	"h4_mph4_terrain_04_grass_2",
	"h4_mph4_terrain_04_grass_3",
	"h4_mph4_terrain_05_grass_0",
	"h4_mph4_terrain_06_grass_0",
	"h4_mph4_airstrip_interior_0_airstrip_hanger"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- IPL_LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local IPL_LIST = {
	{
		Props = {
			"swap_clean_apt",
			"layer_debra_pic",
			"layer_whiskey",
			"swap_sofa_A"
		},
		Coords = vec3(-1150.70,-1520.70,10.60)
	},{
		Props = {
			"csr_beforeMission",
			"csr_inMission"
		},
		Coords = vec3(-47.10,-1115.30,26.50)
	},{
		Props = {
			"V_Michael_bed_tidy",
			"V_Michael_M_items",
			"V_Michael_D_items",
			"V_Michael_S_items",
			"V_Michael_L_Items"
		},
		Coords = vec3(-802.30,175.00,72.80)
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Blackout",nil,function(Name,Key,Value)
	SetArtificialLightsState(Value)
	SetArtificialLightsStateAffectsVehicles(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	AddTextEntryByHash(0x4B7B2734,"Ace Jones Dr")
	AddTextEntryByHash(0x7EC39AE2,"Algonquin Blvd")
	AddTextEntryByHash(0x92E1C090,"Alhambra Dr")
	AddTextEntryByHash(0xD39FE932,"Armadillo Ave")
	AddTextEntryByHash(0xB76E170F,"Calafia Rd")
	AddTextEntryByHash(0x5AA123E0,"Cassidy Trail")
	AddTextEntryByHash(0x261C80DB,"Cascabel Ave")
	AddTextEntryByHash(0xEA41FBE8,"Cat-Claw Ave")
	AddTextEntryByHash(0xEF17EFC8,"Chianski Passage")
	AddTextEntryByHash(0xF5196793,"Cholla Rd")
	AddTextEntryByHash(0x36A6BE4B,"Cholla Springs Ave")
	AddTextEntryByHash(0x8A00A702,"Duluoz Ave")
	AddTextEntryByHash(0x953094ED,"East Joshua Road")
	AddTextEntryByHash(0xCB000216,"El Gordo Dr")
	AddTextEntryByHash(0xF641831C,"Fort Zancudo Approach Rd")
	AddTextEntryByHash(0x4DCE72D8,"Grapeseed Ave")
	AddTextEntryByHash(0x3132B9A5,"Grapeseed Main St")
	AddTextEntryByHash(0xCD357E0E,"Ineseno Road")
	AddTextEntryByHash(0x8F9D12E7,"Joad Ln")
	AddTextEntryByHash(0x0A5BFF42,"Joshua Rd")
	AddTextEntryByHash(0xDE37DA0C,"Lesbos Ln")
	AddTextEntryByHash(0x5C483E1D,"Lolita Ave")
	AddTextEntryByHash(0x32D92D45,"Marina Dr")
	AddTextEntryByHash(0x594944F9,"Meringue Ln")
	AddTextEntryByHash(0x906B3D92,"Mountain View Dr")
	AddTextEntryByHash(0x63F44C25,"Niland Ave")
	AddTextEntryByHash(0x269FDEE5,"North Calafia Way")
	AddTextEntryByHash(0x245499BF,"Nowhere Rd")
	AddTextEntryByHash(0xF8D909E5,"Paleto Blvd")
	AddTextEntryByHash(0x155FBE2B,"Panorama Dr")
	AddTextEntryByHash(0x9A95814F,"Procopio Dr")
	AddTextEntryByHash(0x8F7BEC48,"Procopio Promenade")
	AddTextEntryByHash(0xED13B4BC,"Pyrite Ave")
	AddTextEntryByHash(0xBF442E1F,"Raton Pass")
	AddTextEntryByHash(0xF5C37F6E,"Route 68")
	AddTextEntryByHash(0x38E0429C,"Seaview Rd")
	AddTextEntryByHash(0x538A9910,"Smoke Tree Rd")
	AddTextEntryByHash(0x98F59B29,"Union Rd")
	AddTextEntryByHash(0x21CFAEFC,"Zancudo Ave")
	AddTextEntryByHash(0x6398B275,"Zancudo Grande Valley")
	AddTextEntryByHash(0x8CD2E019,"Abattoir Ave")
	AddTextEntryByHash(0xDDCBDC74,"Abe Milton Pkwy")
	AddTextEntryByHash(0x40D0731C,"Adam's Apple Blvd")
	AddTextEntryByHash(0x8CCFEA79,"Aguja St")
	AddTextEntryByHash(0x08B9CC73,"Alta St")
	AddTextEntryByHash(0x1EA69437,"Amarillo Vista")
	AddTextEntryByHash(0x29E328A9,"Amarillo Way")
	AddTextEntryByHash(0xBA0E09C7,"Americano Way")
	AddTextEntryByHash(0x80CBFBCF,"South Arsenal St")
	AddTextEntryByHash(0x34627A5F,"Atlee St")
	AddTextEntryByHash(0x96B2B85F,"Autopia Pkwy")
	AddTextEntryByHash(0x78905544,"Bait St")
	AddTextEntryByHash(0x15E466FD,"Banham Canyon Dr")
	AddTextEntryByHash(0x26944B16,"Barbareno Rd")
	AddTextEntryByHash(0x6F927644,"Bay City Ave")
	AddTextEntryByHash(0xEDC3B8F4,"Bay City Incline")
	AddTextEntryByHash(0xF5EFE777,"Baytree Canyon Rd")
	AddTextEntryByHash(0xB7229694,"Boulevard Del Perro")
	AddTextEntryByHash(0x22198C67,"Bridge St")
	AddTextEntryByHash(0x5F27252E,"Brouge Ave")
	AddTextEntryByHash(0xCED31768,"Buccaneer Way")
	AddTextEntryByHash(0x80323559,"Buen Vino Rd")
	AddTextEntryByHash(0x8519F0E9,"Caesars Place")
	AddTextEntryByHash(0x46EC8CF6,"Calais Ave")
	AddTextEntryByHash(0x131DF79C,"Capital Blvd")
	AddTextEntryByHash(0x40468D03,"Carcer Way")
	AddTextEntryByHash(0x56F28308,"Carson Ave")
	AddTextEntryByHash(0x29DDB334,"Chum St")
	AddTextEntryByHash(0x3A82547D,"Chupacabra St")
	AddTextEntryByHash(0xE657DF40,"Clinton Ave")
	AddTextEntryByHash(0x9ACC3D68,"Cockingend Dr")
	AddTextEntryByHash(0x7E8446DD,"Conquistador St")
	AddTextEntryByHash(0x09A04736,"Cortes St")
	AddTextEntryByHash(0x186A32D2,"Cougar Ave")
	AddTextEntryByHash(0xBEA2B02D,"Covenant Ave")
	AddTextEntryByHash(0x7BD54361,"Cox Way")
	AddTextEntryByHash(0xE10C41BE,"Crusade Rd")
	AddTextEntryByHash(0x45B1CA3D,"Davis Ave")
	AddTextEntryByHash(0x072580D7,"Decker St")
	AddTextEntryByHash(0x6D5EEFEC,"Dorset Dr")
	AddTextEntryByHash(0x6705124C,"Dorset Pl")
	AddTextEntryByHash(0x75E5EA92,"Dry Dock St")
	AddTextEntryByHash(0xCABEF9A8,"Dunstable Dr")
	AddTextEntryByHash(0xE0D4A5CB,"Dunstable Ln")
	AddTextEntryByHash(0x6635C142,"Dutch London St")
	AddTextEntryByHash(0xEDEB73E4,"East Galileo Ave")
	AddTextEntryByHash(0x6CC8B86E,"East Mirror Dr")
	AddTextEntryByHash(0x410A49CD,"Eastbourne Way")
	AddTextEntryByHash(0x6418F6FE,"Eclipse Blvd")
	AddTextEntryByHash(0xD0B11243,"Edwood Way")
	AddTextEntryByHash(0xB44C8E74,"El Burro Blvd")
	AddTextEntryByHash(0x7FADF1B2,"El Rancho Blvd")
	AddTextEntryByHash(0x0798837A,"Elgin Ave")
	AddTextEntryByHash(0x2C72B469,"Equality Way")
	AddTextEntryByHash(0x4E853514,"Exceptionalists Way")
	AddTextEntryByHash(0x90963D6A,"Fantastic Pl")
	AddTextEntryByHash(0xF3B2BE94,"Fenwell Pl")
	AddTextEntryByHash(0xE94A6DDC,"Forum Dr")
	AddTextEntryByHash(0xD9B72921,"Fudge Ln")
	AddTextEntryByHash(0x85F5588B,"Galileo Rd")
	AddTextEntryByHash(0xD5A607F8,"Gentry Lane")
	AddTextEntryByHash(0x534D8027,"Ginger St")
	AddTextEntryByHash(0xC431BCEE,"Glory Way")
	AddTextEntryByHash(0x7F84CC28,"Goma St")
	AddTextEntryByHash(0x4C9260C4,"Greenwich Pkwy")
	AddTextEntryByHash(0xD72068C5,"Greenwich Way")
	AddTextEntryByHash(0x00CC5CA0,"Grove St")
	AddTextEntryByHash(0x897BB935,"Hanger Way")
	AddTextEntryByHash(0x5E315A37,"Hardy Way")
	AddTextEntryByHash(0x605D416C,"Hawick Ave")
	AddTextEntryByHash(0xDB0C8D26,"Heritage Way")
	AddTextEntryByHash(0x65BCFFA3,"Hillcrest Ave")
	AddTextEntryByHash(0xA1F822A2,"Hillcrest Ridge Access Rd")
	AddTextEntryByHash(0xC4A300EF,"Imagination Court")
	AddTextEntryByHash(0x434CC15C,"Integrity Way")
	AddTextEntryByHash(0x4B5B59A7,"Innocence Blvd")
	AddTextEntryByHash(0x5FEE2991,"Invention Court")
	AddTextEntryByHash(0x661AA779,"Jamestown St")
	AddTextEntryByHash(0xFB90B746,"Kimble Hill Dr")
	AddTextEntryByHash(0xCC628804,"Kortz Dr")
	AddTextEntryByHash(0x98295423,"Labor Pl")
	AddTextEntryByHash(0x973B8B6,"Laguna Pl")
	AddTextEntryByHash(0x5E4F2EE7,"Lake Vinewood Dr")
	AddTextEntryByHash(0xF0089E63,"Las Lagunas Blvd")
	AddTextEntryByHash(0x2F26BBD7,"Liberty St")
	AddTextEntryByHash(0xFF521E51,"Lindsay Circus")
	AddTextEntryByHash(0x9DB39520,"Little Bighorn Ave")
	AddTextEntryByHash(0x64306156,"Macdonald St")
	AddTextEntryByHash(0xFF357E7B,"Mad Wayne Thunder Dr")
	AddTextEntryByHash(0xCF1A660B,"Magellan Ave")
	AddTextEntryByHash(0xE7073C86,"Marathon Ave")
	AddTextEntryByHash(0x4A3712C2,"Marlowe Dr")
	AddTextEntryByHash(0x7EFD9AFE,"Melanoma St")
	AddTextEntryByHash(0x639007F6,"Meteor St")
	AddTextEntryByHash(0xBDB7B4F7,"Milton Rd")
	AddTextEntryByHash(0x1FA2C931,"Mirror Park Blvd")
	AddTextEntryByHash(0x0CC8AAE6,"Mirror Pl")
	AddTextEntryByHash(0xC122D85F,"Morningwood Blvd")
	AddTextEntryByHash(0xD3CD9C6E,"Mt Haan Dr")
	AddTextEntryByHash(0x946FDCC9,"Mt Haan Rd")
	AddTextEntryByHash(0x5EBC827B,"Mt Vinewood Dr")
	AddTextEntryByHash(0x9117E6AD,"Movie Star Way")
	AddTextEntryByHash(0x5C033D11,"Mutiny Rd")
	AddTextEntryByHash(0x07AB9391,"Nikola Ave")
	AddTextEntryByHash(0x7D92FF5A,"Nikola Pl")
	AddTextEntryByHash(0x995C30AA,"Normandy Dr")
	AddTextEntryByHash(0xDE65DFA8,"North Archer Ave")
	AddTextEntryByHash(0xA2F6CA31,"North Conker Ave")
	AddTextEntryByHash(0xB74C0D46,"North Sheldon Ave")
	AddTextEntryByHash(0x59920DAD,"North Rockford Dr")
	AddTextEntryByHash(0x20101F69,"Occupation Ave")
	AddTextEntryByHash(0xB87FAA60,"Orchardville Ave")
	AddTextEntryByHash(0x520BFB49,"Palomino Ave")
	AddTextEntryByHash(0xA5883BDE,"Peaceful St")
	AddTextEntryByHash(0x909B5591,"Perth St")
	AddTextEntryByHash(0x1919AEB5,"Picture Perfect Drive")
	AddTextEntryByHash(0x7C7282C1,"Plaice Pl")
	AddTextEntryByHash(0x66006A97,"Playa Vista")
	AddTextEntryByHash(0xCCD0D983,"Popular St")
	AddTextEntryByHash(0x7D75C728,"Portola Dr")
	AddTextEntryByHash(0xF959D26E,"Power St")
	AddTextEntryByHash(0x0D5F14E6,"Prosperity St")
	AddTextEntryByHash(0x4C0674B7,"Prosperity Street Promenade")
	AddTextEntryByHash(0x05EFF99A,"Red Desert Ave")
	AddTextEntryByHash(0x284CD97B,"Richman St")
	AddTextEntryByHash(0x159B0DF9,"Rockford Dr")
	AddTextEntryByHash(0xD631D46B,"Roy Lowenstein Blvd")
	AddTextEntryByHash(0x9735407C,"Rub St")
	AddTextEntryByHash(0xB4A79707,"Sam Austin Dr")
	AddTextEntryByHash(0xF2C73716,"San Andreas Ave")
	AddTextEntryByHash(0xDA9DCCFB,"San Vitus Blvd")
	AddTextEntryByHash(0x502503F,"Sandcastle Way")
	AddTextEntryByHash(0x003F6701,"Senora Rd")
	AddTextEntryByHash(0xC7A93BB0,"Senora Way")
	AddTextEntryByHash(0xD529ED93,"Shank St")
	AddTextEntryByHash(0x7727141A,"Signal St")
	AddTextEntryByHash(0x5C3E7D79,"Sinner St")
	AddTextEntryByHash(0x73F8ADE1,"South Boulevard Del Perro")
	AddTextEntryByHash(0xCDF48F9E,"South Mo Milton Dr")
	AddTextEntryByHash(0x01D80573,"South Rockford Dr")
	AddTextEntryByHash(0xC5438966,"South Shambles St")
	AddTextEntryByHash(0x917FD2AB,"Spanish Ave")
	AddTextEntryByHash(0xBED67F35,"Steele Way")
	AddTextEntryByHash(0x3FD7E083,"Strangeways Dr")
	AddTextEntryByHash(0x68DF3909,"Strawberry Ave")
	AddTextEntryByHash(0x101C10C8,"Supply St")
	AddTextEntryByHash(0xA6761DA3,"Sustancia Rd")
	AddTextEntryByHash(0x4F69F80D,"Swiss St")
	AddTextEntryByHash(0x24349A67,"Tackle St")
	AddTextEntryByHash(0x3D7A8076,"Tangerine St")
	AddTextEntryByHash(0x1EBDEABC,"Tongva Dr")
	AddTextEntryByHash(0x44A9B903,"Tower Way")
	AddTextEntryByHash(0x332A2A65,"Tug St")
	AddTextEntryByHash(0x85F57AFA,"O'Neil Way")
	AddTextEntryByHash(0xD7C3E89F,"Utopia Gardens")
	AddTextEntryByHash(0x84B5FCB9,"Vespucci Blvd")
	AddTextEntryByHash(0xC527457D,"Vinewood Blvd")
	AddTextEntryByHash(0xD513F002,"Vinewood Park Dr")
	AddTextEntryByHash(0x43CE38FF,"Vitus St")
	AddTextEntryByHash(0x75723A2C,"Voodoo Place")
	AddTextEntryByHash(0x983A7D65,"West Eclipse Blvd")
	AddTextEntryByHash(0xB23474,"West Mirror Drive")
	AddTextEntryByHash(0xFFFC76B4,"Whispymound Dr")
	AddTextEntryByHash(0xB4BB47B3,"Wild Oats Dr")
	AddTextEntryByHash(0xCE9D4092,"York St")
	AddTextEntryByHash(0x0F020961,"Zancudo Barranca")
	AddTextEntryByHash(0x96B41893,"Zancudo Rd")
	AddTextEntryByHash(0x12057A99,"Del Perro Fwy")
	AddTextEntryByHash(0xC8690C80,"Del Perro Fwy")
	AddTextEntryByHash(0x2E49B265,"Elysian Fields Fwy")
	AddTextEntryByHash(0x4DFC3A0B,"La Puerta Fwy")
	AddTextEntryByHash(0xAC9F694E,"Los Santos Freeway")
	AddTextEntryByHash(0x192E8516,"Olympic Fwy")
	AddTextEntryByHash(0x9B01C923,"Senora Fwy")
	AddTextEntryByHash(0xF83C4076,"Palomino Freeway")
	AddTextEntryByHash(0xF5DE6511,"Palomino Fwy")
	AddTextEntryByHash(0xE7932A4B,"Great Ocean Hwy")
	AddTextEntryByHash(0x73F16A64,"Cavalry Blvd")
	AddTextEntryByHash(0xF5BF6BDD,"Runway1")
	AddTextEntryByHash(0x7999837,"Route 68")

	if GlobalState.Blackout then
		SetArtificialLightsState(true)
		SetArtificialLightsStateAffectsVehicles(false)
	end

	while true do
		local Pid = PlayerId()
		local Ped = PlayerPedId()
		if IsPedInAnyVehicle(Ped) then
			DisableControlAction(0,345,true)

			local Vehicle = GetVehiclePedIsUsing(Ped)
			if not GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,true)
			end

			if GetPedInVehicleSeat(Vehicle,0) == Ped and GetIsTaskActive(Ped,165) then
				SetPedIntoVehicle(Ped,Vehicle,0)
			end

			if IsPedInAnyHeli(Ped) and IsControlJustPressed(1,154) and not IsAnyPedRappellingFromHeli(Vehicle) and (GetPedInVehicleSeat(Vehicle,1) == Ped or GetPedInVehicleSeat(Vehicle,2) == Ped) then
				TaskRappelFromHeli(Ped,1)
			end
		else
			if GetPedConfigFlag(Ped,184,true) then
				SetPedConfigFlag(Ped,184,false)
			end
		end

		for Number = 1,22 do
			if Number ~= 14 and Number ~= 16 then
				HideHudComponentThisFrame(Number)
			end
		end

		for _,control in ipairs(CONTROLS) do
			DisableControlAction(0,control,true)
		end

		DisableVehicleDistantlights(true)
		SetAllVehicleGeneratorsActive()
		CancelCurrentPoliceReport()
		BlockWeaponWheelThisFrame()
		SetCreateRandomCops(false)
		SetPoliceRadarBlips(false)
		DistantCopCarSirens(false)
		SetPauseMenuActive(false)

		SetVehicleDensityMultiplierThisFrame(1.0)
		SetRandomVehicleDensityMultiplierThisFrame(1.0)
		SetParkedVehicleDensityMultiplierThisFrame(1.0)
		SetScenarioPedDensityMultiplierThisFrame(1.0,1.0)
		SetPedDensityMultiplierThisFrame(1.0)

		if IsPedArmed(Ped,6) then
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
		end

		if IsPedUsingActionMode(Ped) then
			SetPedUsingActionMode(Ped,-1,-1,1)
		end

		SetPlayerTargetingMode(3)
		DisablePlayerVehicleRewards(Pid)
		SetPlayerLockonRangeOverride(Pid,0.0)
		SetCreateRandomCopsOnScenarios(false)
		SetCreateRandomCopsNotOnScenarios(false)
		SetPedInfiniteAmmoClip(Ped,false)

		if IsPlayerWantedLevelGreater(Pid,0) then
			ClearPlayerWantedLevel(Pid)
		end

		if LocalPlayer.state.Active then
			NetworkOverrideClockTime(GlobalState.Hours,GlobalState.Minutes,0)

			SetWeatherTypeNowPersist(GlobalState.Weather)
			SetOverrideWeather(GlobalState.Weather)
			SetWeatherTypeNow(GlobalState.Weather)
		else
			NetworkOverrideClockTime(12,0,0)

			SetWeatherTypeNow("EXTRASUNNY")
			SetOverrideWeather("EXTRASUNNY")
			SetWeatherTypeNowPersist("EXTRASUNNY")
		end

		Wait(0)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local mapZoomData = {
		{ 0,0.96,0.9,0.08,0.0,0.0 },
		{ 1,1.6,0.9,0.08,0.0,0.0 },
		{ 2,8.6,0.9,0.08,0.0,0.0 },
		{ 3,12.3,0.9,0.08,0.0,0.0 },
		{ 4,22.3,0.9,0.08,0.0,0.0 }
	}

	for _,zoomData in ipairs(mapZoomData) do
		SetMapZoomDataLevel(zoomData[1],zoomData[2],zoomData[3],zoomData[4],zoomData[5],zoomData[6])
	end

	for _,v in pairs(IPL_LIST) do
		local Interior = GetInteriorAtCoords(v["Coords"])
		LoadInterior(Interior)

		if v["Props"] then
			for _,Index in pairs(v["Props"]) do
				EnableInteriorProp(Interior,Index)
			end
		end

		RefreshInterior(Interior)
	end

	for index, alphaData in ipairs(ALPHAS) do
		local Blip = CreateBlipRadius(alphaData)
		
		if Blip then
			CreatedRadiusBlips[index] = Blip
			Wait(0)
		end
	end

	for index, blipData in ipairs(BLIPS) do
		local Blip = CreateBlip(blipData)
		
		if Blip then
			CreatedBlips[index] = Blip
			Wait(0)
		end
	end

	local teleportData = {}
	for _,v in ipairs(TELEPORT) do
		table.insert(teleportData,{ v[1],2.5,"E","Pressione","para acessar" })
	end

	TriggerEvent("hoverfy:Insert",teleportData)

	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not IsPedInAnyVehicle(Ped) then
			local Coords = GetEntityCoords(Ped)

			for Number = 1,#TELEPORT do
				if #(Coords - TELEPORT[Number][1]) <= 1.0 then
					TimeDistance = 1

					if IsControlJustPressed(1,38) then
						SetEntityCoords(Ped,TELEPORT[Number][2])
					end
				end
			end
		end

		InvalidateVehicleIdleCam()
		InvalidateIdleCam()

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	local IslandLoaded = false
	for _,v in pairs(ISLAND) do
		RequestIpl(v)
	end

	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		if #(Coords - vec3(4840.57,-5174.42,2.0)) <= 2000 then
			if not IslandLoaded then
				IslandLoaded = true
				SetIslandHopperEnabled("HeistIsland",true)
				SetAiGlobalPathNodesType(1)
				SetDeepOceanScaler(0.0)
				LoadGlobalWaterType(1)
			end
		else
			if IslandLoaded then
				IslandLoaded = false
				SetIslandHopperEnabled("HeistIsland",false)
				SetAiGlobalPathNodesType(0)
				SetDeepOceanScaler(1.0)
				LoadGlobalWaterType(0)
			end
		end

		for _,Entity in pairs(GetGamePool("CPed")) do
			if (NetworkGetEntityOwner(Entity) == -1 or NetworkGetEntityOwner(Entity) == PlayerId()) and not DecorGetBool(Entity,"CREATIVE_PED") and not NetworkGetEntityIsNetworked(Entity) then
				if IsPedInAnyVehicle(Entity) then
					local Vehicle = GetVehiclePedIsUsing(Entity)
					if NetworkGetEntityIsNetworked(Vehicle) then
						TriggerServerEvent("garages:Delete",NetworkGetNetworkIdFromEntity(Vehicle),GetVehicleNumberPlateText(Vehicle))
					else
						DeleteEntity(Vehicle)
					end
				else
					DeleteEntity(Entity)
				end
			end
		end

		for _,Vehicle in pairs(GetGamePool("CVehicle")) do
			if (NetworkGetEntityOwner(Vehicle) == -1 or NetworkGetEntityOwner(Vehicle) == PlayerId()) and not NetworkGetEntityIsNetworked(Vehicle) and GetVehicleNumberPlateText(Vehicle) ~= "PDMSPORT" then
				DeleteEntity(Vehicle)
			end
		end

		for Number = 1,121 do
			EnableDispatchService(Number,false)
		end

		Wait(100)
	end
end)