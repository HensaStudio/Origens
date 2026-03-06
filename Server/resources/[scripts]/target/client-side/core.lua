-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("target")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Zones = {}
local Models = {}
local Focus = false
local Selected = {}
local Sucess = false
local Actived = false
local DismantleWaypoints = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE
-----------------------------------------------------------------------------------------------------------------------------------------
local Dismantle = {
	vec3(943.23,-1497.87,30.11),
	vec3(-1172.57,-2037.65,13.75),
	vec3(-524.94,-1680.63,19.21),
	vec3(1358.14,-2095.41,52.0),
	vec3(602.47,-437.82,24.75),
	vec3(-413.86,-2179.29,10.31),
	vec3(146.51,320.62,112.14),
	vec3(520.91,169.14,99.36),
	vec3(1137.99,-794.32,57.59),
	vec3(-93.07,-2549.6,6.0),
	vec3(820.07,-488.43,30.46),
	vec3(1078.62,-2325.56,30.25),
	vec3(1204.69,-3116.71,5.50)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOWEDSOUTH
-----------------------------------------------------------------------------------------------------------------------------------------
local TowedSouth = PolyZone:Create({
	vec2(-215.62368774414,-1174.2673339844),
	vec2(-215.59094238281,-1163.8527832031),
	vec2(-202.86952209473,-1163.8685302734),
	vec2(-202.85743713379,-1174.3098144531)
},{ name = "TowedSouth" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- TYRES
-----------------------------------------------------------------------------------------------------------------------------------------
local Tyres = {
	{ Bone = "wheel_lf", Index = 0 },
	{ Bone = "wheel_rf", Index = 1 },
	{ Bone = "wheel_lm", Index = 2 },
	{ Bone = "wheel_rm", Index = 3 },
	{ Bone = "wheel_lr", Index = 4 },
	{ Bone = "wheel_rr", Index = 5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUELS
-----------------------------------------------------------------------------------------------------------------------------------------
local Fuels = {
	-- 247, LTD, Oil, Xero, Globe

	-- Posto de Combustível 1
	{ Coords = vec3(274.07,-1268.58,29.58), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(274.12,-1260.95,29.13), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(274.12,-1253.12,29.14), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(265.35,-1268.29,29.13), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(265.35,-1260.95,29.14), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(265.35,-1253.12,29.14), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(256.72,-1268.29,29.13), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(256.72,-1260.95,29.14), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(256.72,-1253.12,29.14), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 2
	{ Coords = vec3(810.42,-1026.60,26.31), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(810.41,-1031.29,26.29), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(818.70,-1026.59,26.30), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(818.70,-1031.29,26.29), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(827.01,-1026.59,26.50), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(827.01,-1031.29,26.50), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 3
	{ Coords = vec3(1210.51,-1406.85,35.25), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(1213.38,-1403.99,35.24), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(1204.65,-1400.98,35.24), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(1207.51,-1398.12,35.25), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 4
	{ Coords = vec3(1179.35,-339.77,69.22), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1186.78,-338.46,69.21), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1177.85,-331.24,69.17), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1185.28,-329.92,69.18), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1176.10,-322.52,69.24), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1183.51,-321.22,69.22), Type = "Normal", Brand = "LTD" },

	-- Posto de Combustível 5
	{ Coords = vec3(612.15,263.49,103.12), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(612.14,273.61,103.12), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(620.71,263.49,103.11), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(620.70,273.63,103.12), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(629.35,263.49,103.11), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(629.35,273.63,103.11), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 6
	{ Coords = vec3(2588.70,358.89,108.51), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(2588.95,364.39,108.49), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(2581.24,359.22,108.49), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(2581.47,364.71,108.50), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(2573.84,359.54,108.50), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(2574.08,365.04,108.49), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 7
	{ Coords = vec3(175.42,-1568.41,29.19), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(182.25,-1561.93,29.18), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(169.74,-1562.22,29.18), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(176.47,-1555.87,29.18), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 8
	{ Coords = vec3(-314.85,-1462.60,30.57), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(-309.78,-1471.36,30.57), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(-322.26,-1466.87,30.56), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(-317.19,-1475.65,30.57), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(-324.67,-1479.97,30.57), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(-329.74,-1471.20,30.57), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 9
	{ Coords = vec3(49.26,2779.25,58.41), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(49.90,2778.78,58.39), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 10
	{ Coords = vec3(263.05,2607.01,45.08), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(265.02,2606.96,45.09), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 11
	{ Coords = vec3(1043.22,2674.22,39.81), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1035.45,2674.21,39.80), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1035.44,2667.68,39.81), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1043.23,2667.69,39.80), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 12
	{ Coords = vec3(1206.05,2662.21,37.99), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1208.67,2659.58,38.00), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1209.74,2658.51,38.00), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 13
	{ Coords = vec3(2539.58,2594.73,38.060), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 14
	{ Coords = vec3(2680.66,3265.93,55.75), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(2678.83,3262.75,55.74), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 15
	{ Coords = vec3(2008.86,3776.49,32.75), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(2005.77,3774.65,32.75), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(2004.36,3773.78,32.75), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(2002.02,3772.41,32.75), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 16
	{ Coords = vec3(1690.32,4928.21,42.60), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(1684.93,4932.04,42.58), Type = "Normal", Brand = "LTD" },

	-- Posto de Combustível 17
	{ Coords = vec3(1705.92,6414.20,32.61), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1701.92,6416.08,32.61), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1697.95,6417.94,32.62), Type = "Normal", Brand = "Globe" },

	-- Posto de Combustível 18
	{ Coords = vec3(172.56,6604.01,31.92), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(179.89,6605.32,31.91), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(187.19,6606.60,31.91), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 19
	{ Coords = vec3(-96.74,6417.16,32.00), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-91.68,6422.23,31.99), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 20
	{ Coords = vec3(-2551.75,2327.38,33.10), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-2558.37,2326.97,33.11), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-2552.97,2334.73,33.11), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-2558.85,2334.40,33.10), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-2552.76,2342.15,33.06), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-2559.13,2341.75,33.06), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 21
	{ Coords = vec3(-1803.65,794.84,138.54), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-1808.74,800.40,138.54), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-1797.24,800.99,138.51), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-1802.33,806.55,138.50), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-1790.85,806.84,138.55), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-1795.96,812.41,138.55), Type = "Normal", Brand = "LTD" },

	-- Posto de Combustível 22
	{ Coords = vec3(-1444.51,-273.79,46.25), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-1435.52,-284.24,46.25), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-1438.07,-269.15,46.25), Type = "Normal", Brand = "Oil" },
	{ Coords = vec3(-1429.07,-279.60,46.26), Type = "Normal", Brand = "Oil" },

	-- Posto de Combustível 23
	{ Coords = vec3(-2104.22,-310.71,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2105.08,-318.90,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2105.75,-325.27,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2097.16,-326.17,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2096.50,-319.81,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2095.78,-311.60,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2086.90,-312.51,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2087.77,-320.72,13.01), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-2088.44,-327.08,13.01), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 24
	{ Coords = vec3(-732.36,-938.98,19.07), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-732.36,-932.18,19.06), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-723.72,-938.97,19.06), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-723.72,-932.17,19.07), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-715.15,-938.98,19.07), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-715.15,-932.17,19.07), Type = "Normal", Brand = "LTD" },

	-- Posto de Combustível 25
	{ Coords = vec3(-522.43,-1217.02,18.17), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-525.11,-1215.75,18.18), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-529.71,-1213.56,18.18), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-532.47,-1212.32,18.19), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-528.38,-1205.20,18.18), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-525.62,-1206.45,18.18), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-521.02,-1208.64,18.18), Type = "Normal", Brand = "Xero" },
	{ Coords = vec3(-518.35,-1209.90,18.18), Type = "Normal", Brand = "Xero" },

	-- Posto de Combustível 26
	{ Coords = vec3(-79.79,-1761.91,29.65), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-77.21,-1754.83,29.66), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-69.07,-1757.80,29.39), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-71.65,-1764.89,29.37), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-63.23,-1767.72,29.11), Type = "Normal", Brand = "LTD" },
	{ Coords = vec3(-60.65,-1760.63,29.15), Type = "Normal", Brand = "LTD" },

	-- Posto de Combustível 27
	{ Coords = vec3(1785.89,3329.74,41.51), Type = "Normal", Brand = "Globe" },
	{ Coords = vec3(1785.23,3331.59,41.44), Type = "Normal", Brand = "Globe" },

	-- Posto de Recarga 1
	{ Coords = vec3(-972.35,-2105.73,10.00), Type = "Electric" },
	{ Coords = vec3(-970.07,-2103.41,9.99), Type = "Electric" },
	{ Coords = vec3(-967.65,-2101.02,9.99), Type = "Electric" },

	-- Posto de Recarga 2
	{ Coords = vec3(-1689.35,-949.67,8.25), Type = "Electric" },
	{ Coords = vec3(-1692.18,-948.87,8.26), Type = "Electric" },
	{ Coords = vec3(-1695.17,-947.97,8.26), Type = "Electric" },

	-- Posto de Recarga 3
	{ Coords = vec3(-464.21,-610.29,31.90), Type = "Electric" },
	{ Coords = vec3(-460.60,-610.32,31.91), Type = "Electric" },
	{ Coords = vec3(-456.92,-610.32,31.90), Type = "Electric" },

	-- Posto de Recarga 4
	{ Coords = vec3(584.66,2718.04,42.65), Type = "Electric" },
	{ Coords = vec3(581.40,2717.84,42.66), Type = "Electric" },

	-- Posto de Recarga 5
	{ Coords = vec3(-748.75,-1079.17,12.46), Type = "Electric" },
	{ Coords = vec3(-752.88,-1081.56,12.46), Type = "Electric" },
	{ Coords = vec3(-756.92,-1083.87,12.47), Type = "Electric" },

	-- Posto de Recarga 6
	{ Coords = vec3(-2190.71,4244.93,48.74), Type = "Electric" },
	{ Coords = vec3(-2192.95,4243.13,48.66), Type = "Electric" },
	{ Coords = vec3(-2195.58,4241.25,48.68), Type = "Electric" },

	-- Posto de Recarga 7
	{ Coords = vec3(-143.72,6276.27,32.07), Type = "Electric" },
	{ Coords = vec3(-141.04,6278.94,32.07), Type = "Electric" },
	{ Coords = vec3(-138.69,6281.28,32.06), Type = "Electric" },

	-- Posto de Recarga 8
	{ Coords = vec3(867.08,-3148.24,6.49), Type = "Electric" },
	{ Coords = vec3(863.01,-3148.23,6.49), Type = "Electric" },
	{ Coords = vec3(858.85,-3148.28,6.49), Type = "Electric" },

	-- Posto de Recarga 9
	{ Coords = vec3(-1679.67,69.93,64.68), Type = "Electric" },
	{ Coords = vec3(-1682.47,72.39,64.80), Type = "Electric" },
	{ Coords = vec3(-1685.05,74.74,64.96), Type = "Electric" },

	-- Posto de Recarga 10
	{ Coords = vec3(-981.76,-182.85,38.66), Type = "Electric" },
	{ Coords = vec3(-978.50,-181.10,38.61), Type = "Electric" },
	{ Coords = vec3(-975.27,-179.51,38.59), Type = "Electric" },

	-- Posto de Recarga 11
	{ Coords = vec3(2583.38,435.83,109.03), Type = "Electric" },
	{ Coords = vec3(2579.51,435.82,109.04), Type = "Electric" },
	{ Coords = vec3(2575.83,435.84,109.04), Type = "Electric" },

	-- Posto de Recarga 12
	{ Coords = vec3(688.59,238.12,94.05), Type = "Electric" },

	-- Posto de Recarga 13
	{ Coords = vec3(2780.98,3495.38,55.67), Type = "Electric" },
	{ Coords = vec3(2779.48,3491.80,55.74), Type = "Electric" },
	{ Coords = vec3(2777.81,3487.91,55.83), Type = "Electric" },

	-- Posto de Recarga 14
	{ Coords = vec3(1731.99,6407.08,35.06), Type = "Electric" },
	{ Coords = vec3(1734.87,6405.56,35.28), Type = "Electric" },

	-- Posto de Recarga 15
	{ Coords = vec3(-759.31,5551.72,34.18), Type = "Electric" },
	{ Coords = vec3(-755.82,5551.70,34.19), Type = "Electric" },
	{ Coords = vec3(-752.28,5551.65,34.19), Type = "Electric" },

	-- Posto de Recarga 16
	{ Coords = vec3(-2528.49,2350.71,33.64), Type = "Electric" },

	-- Posto de Recarga 17
	{ Coords = vec3(1954.84,3758.15,32.81), Type = "Electric" },
	{ Coords = vec3(1951.34,3756.12,32.78), Type = "Electric" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE:WAYPOINT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dismantle:Waypoint")
AddEventHandler("dismantle:Waypoint",function()
	if next(DismantleWaypoints) then
		for _,id in pairs(DismantleWaypoints) do
			exports["waypoints"]:RemoveWaypoint(id)
		end

		DismantleWaypoints = {}
	end

	local RandomDismantle = Dismantle[math.random(#Dismantle)]
	DismantleWaypoints[1] = exports["waypoints"]:AddWaypoint(RandomDismantle,{ label = "Desmanche", color = Theme["main"], autoRemove = true })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVERSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	RegisterCommand("+entityTarget",TargetEnable)
	RegisterCommand("-entityTarget",TargetDisable)
	RegisterKeyMapping("+entityTarget","Interação auricular.","keyboard","LMENU")

	AddCircleZone("Trees",vec3(1964.6,5184.16,47.97),0.55,{
		name = "Trees",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.55,
		options = {
			{
				event = "farmer:Trees",
				label = "Localizar Árvores",
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Weeds",vec3(1532.32,1721.92,110.30),0.55,{
		name = "Weeds",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.55,
		options = {
			{
				event = "inventory:BuyBasket",
				label = "Comprar Cesta",
				tunnel = "server"
			}, {
				event = "farmer:Weeds",
				label = "Localizar Brotos",
				tunnel = "client"
			}
		}
	})

	AddCircleZone("Pillbox",vec3(307.52,-595.30,43.12),0.25,{
		name = "Pillbox",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.25,
		options = {
			{
				event = "paramedic:TakeMedicament",
				label = "Pegar Medicamento",
				tunnel = "server"
			},{
				event = "paramedic:NeedAttention",
				label = "Solicitar Atendimento",
				tunnel = "server"
			}
		}
	})

	AddTargetModel({ 1281992692 },{
		options = {
			{
				event = "player:Call",
				label = "Usar",
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -1940238623,2108567945 },{
		options = {
			{
				event = "inventory:Parknmeter",
				label = "Sabotar",
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddCircleZone("Trash:01",vec3(-330.36,-1564.11,25.47),0.25,{
		name = "Trash:01",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.25,
		shop = "Trasher",
		options = {
			{
				event = "inventory:Products",
				label = "Despejar Lixo",
				tunnel = "server"
			}
		}
	})

	AddCircleZone("Trash:02",vec3(12.99,6501.61,31.84),0.25,{
		name = "Trash:02",
		heading = 0.0,
		useZ = true
	},{
		Distance = 1.25,
		shop = "Trasher",
		options = {
			{
				event = "inventory:Products",
				label = "Despejar Lixo",
				tunnel = "server"
			}
		}
	})

	AddTargetModel({ 654385216,161343630,-430989390,1096374064,-1519644200,-1932041857,207578973,-487222358 },{
		options = {
			{
				event = "slotmachine:Init",
				label = "Sentar",
				tunnel = "client"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ -1667301416,-1561916159,51789996 },{
		options = {
			{
				event = "inventory:Animals",
				label = "Interagir",
				tunnel = "server"
			}
		},
		Distance = 1.5
	})

	AddTargetModel({ -832573324,-1430839454,1457690978,1682622302,402729631,-664053099,1794449327,307287994,-1323586730,111281960,-541762431,-745300483,-417505688 },{
		options = {
			{
				event = "inventory:Animals",
				label = "Esfolar",
				tunnel = "server"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -206690185,666561306,218085040,-58485588,1511880420,682791951 },{
		options = {
			{
				event = "player:enterTrash",
				label = "Esconder",
				tunnel = "client"
			},{
				event = "player:checkTrash",
				label = "Verificar",
				tunnel = "server"
			},{
				event = "chest:Open",
				label = "Abrir",
				tunnel = "entity",
				service = "Trash"
			}
		},
		Distance = 1.0
	})

	AddTargetModel({ -1691644768,-742198632 },{
		options = {
			{
				event = "inventory:Drink",
				label = "Beber",
				tunnel = "server"
			},{
				event = "inventory:RefillGallon",
				label = "Encher Galão",
				tunnel = "server"
			},{
				event = "inventory:RefillBottle",
				label = "Encher Garrafa",
				tunnel = "server"
			}
		},
		Distance = 0.75
	})

	AddTargetModel({ 690372739 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Coffee"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -654402915,1421582485 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Donut"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 992069095,1114264700 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Soda"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 1129053052 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Hamburger"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -1581502570 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Hotdog"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 73774428 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Cigarette"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -272361894 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Chihuahua"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ 1099892058 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Water"
			}
		},
		Distance = 1.25
	})

	AddTargetModel({ -2007231801,1339433404,1694452750,1933174915,-462817101,-469694731,-164877493,486135101 },{
		options = {
			{
				event = "shops:Open",
				label = "Abrir",
				tunnel = "products",
				service = "Fuel"
			}
		},
		Distance = 1.25
	})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLEACTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function DisableActions()
	if Focus then
		DisableControlAction(0,1,true)
		DisableControlAction(0,2,true)
	end

	for _,v in ipairs({ 18,55,76,22,23,24,25,75,140,141,142,143,243,257,263,311,102,179,203 }) do
		DisableControlAction(0,v,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETENABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetEnable()
	local Ped = PlayerPedId()
	if LocalPlayer.state.Cancel or LocalPlayer.state.ItemCamera or LocalPlayer.state.Freecam or LocalPlayer.state.Carry or not LocalPlayer.state.Active or LocalPlayer.state.Buttons or LocalPlayer.state.Commands or LocalPlayer.state.Handcuff or IsPauseMenuActive() or not MumbleIsConnected() or Sucess or IsPedInAnyVehicle(Ped) then
		return false
	end

	Actived = true
	SendNUIMessage({ Action = "Open" })

	while Actived do
		DisableActions()

		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local HitCoords,Entitys,EntityHit = RayCastGamePlayCamera()

		for Index,v in pairs(Zones) do
			if #(Coords - Zones[Index].center) <= 5 then
				SetDrawOrigin(Zones[Index].center.x,Zones[Index].center.y,Zones[Index].center.z)
				DrawSprite("Textures","Normal",0.0,0.0,0.0185,0.0185 * GetAspectRatio(false),0.0,255,255,255,255)
				ClearDrawOrigin()
			end

			if Zones[Index]:isPointInside(HitCoords) and #(Coords - Zones[Index].center) <= v.targetoptions.Distance then
				if v.targetoptions.shop then
					Selected = v.targetoptions.shop
				end

				SendNUIMessage({ Action = "Valid", Payload = Zones[Index].targetoptions.options })

				Sucess = true
				while Sucess do
					SetDrawOrigin(Zones[Index].center.x,Zones[Index].center.y,Zones[Index].center.z)
					DrawSprite("Textures","Selected",0.0,0.0,0.0185,0.0185 * GetAspectRatio(false),0.0,255,255,255,255)
					ClearDrawOrigin()
					DisableActions()

					if IsDisabledControlJustReleased(1,24) then
						SetCursorLocation(0.5,0.5)
						SetNuiFocus(true,true)
						Focus = true
					end

					local Ped = PlayerPedId()
					local OtherCoords = RayCastGamePlayCamera()
					if not Zones[Index]:isPointInside(OtherCoords) or #(GetEntityCoords(Ped) - Zones[Index].center) > v.targetoptions.Distance then
						if Focus then
							SendNUIMessage({ Action = "Close" })
							SetNuiFocus(false,false)
							Actived = false
							Focus = false
						else
							SendNUIMessage({ Action = "Left" })
						end

						Sucess = false
					end

					Wait(1)
				end
			end
		end

		if EntityHit and GetEntityType(Entitys) ~= 0 then
			if LocalPlayer.state.Admin and IsControlJustPressed(1,38) then
				TriggerServerEvent("admin:Doords",GetEntityCoords(Entitys),GetEntityModel(Entitys),GetEntityHeading(Entitys))
			end

			local Menu = {}
			if IsEntityAVehicle(Entitys) and GetEntityHealth(Ped) > 100 and #(Coords - HitCoords) <= 1.0 then
				local Network = nil
				local Vehicle = GetLastDrivenVehicle()

				SetEntityAsMissionEntity(Entitys,true,true)
				if NetworkGetEntityIsNetworked(Entitys) then
					Network = NetworkGetNetworkIdFromEntity(Entitys)
				end

				Selected = { GetVehicleNumberPlateText(Entitys),GetEntityArchetypeName(Entitys),Entitys,Network,GetEntityModel(Entitys),false,false }

				for _,v in pairs(Fuels) do
					if #(Coords - v.Coords) <= 2.5 then
						if v.Type == "Normal" then
							table.insert(Menu,{ event = "engine:Supply", label = "Abastecer", tunnel = "client", service = v.Brand })
						elseif v.Type == "Electric" then
							table.insert(Menu,{ event = "engine:Recharge", label = "Recarregar", tunnel = "client" })
						end

						break
					end
				end

				if #Menu <= 0 then
					if GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_PETROLCAN") then
						Selected[6] = true
						table.insert(Menu,{ event = "engine:Supply", label = "Abastecer", tunnel = "client" })
					else
						if TowedSouth:isPointInside(HitCoords) and not Entity(Entitys).state.Tow then
							table.insert(Menu,{ event = "towed:Payment", label = "Entregar", tunnel = "paramedic" })
						else
							local Lockpick = Entity(Entitys).state.Lockpick
							if Lockpick then
								table.insert(Menu,{ event = "engine:Vehrify", label = "Verificar", tunnel = "client" })

								if GetVehicleDoorLockStatus(Entitys) <= 1 and GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_WRENCH") then
									for Index = 1,#Tyres do
										local BoneIndex = GetEntityBoneIndexByName(Entitys,Tyres[Index].Bone)
										local TyreCoords = GetWorldPositionOfEntityBone(Vehicle,BoneIndex)
										if #(Coords - TyreCoords) <= 1.0 then
											Selected[6] = Tyres[Index].Index
											table.insert(Menu,{ event = "inventory:RemoveTyres", label = "Retirar Pneu", tunnel = "server" })
										end
									end
								end

								if not IsPedArmed(Ped,7) and GetVehicleDoorLockStatus(Entitys) <= 1 then
									if VehicleWeight(Selected[2]) > 0 then
										table.insert(Menu,{ event = "trunkchest:openTrunk", label = "Abrir Porta-Malas", tunnel = "server" })
									end

									table.insert(Menu,{ event = "inventory:ChangePlate", label = "Trocar Placa", tunnel = "server" })
								end

								table.insert(Menu,{ event = "garages:Key", label = "Chave Reserva", tunnel = "server" })
							else
								if GetEntityBoneIndexByName(Entitys,"boot") ~= -1 and IsVehicleSeatFree(Entitys,-1) and GetSelectedPedWeapon(Ped) == GetHashKey("WEAPON_CROWBAR") then
									table.insert(Menu,{ event = "inventory:StealTrunk", label = "Arrombar Porta-Malas", tunnel = "server" })
								end

								if Selected[2] == "stockade" then
									table.insert(Menu,{ event = "inventory:Stockade", label = "Vasculhar", tunnel = "server" })
								end
							end

							if not IsThisModelABike(Selected[5]) then
								local Rolling = GetEntityRoll(Entitys)
								if Rolling > 75.0 or Rolling < -75.0 then
									table.insert(Menu,{ event = "player:RollVehicle", label = "Desvirar", tunnel = "server" })
								end

								if GetEntityBoneIndexByName(Entitys,"boot") ~= -1 and not IsPedArmed(Ped,7) and GetVehicleDoorLockStatus(Entitys) <= 1 then
									table.insert(Menu,{ event = "player:checkTrunk", label = "Checar Porta-Malas", tunnel = "server" })
									table.insert(Menu,{ event = "player:enterTrunk", label = "Entrar no Porta-Malas", tunnel = "client" })
								end
							end

							if GetEntityArchetypeName(Vehicle) == "flatbed" and Selected[2] ~= "flatbed" then
								table.insert(Menu,{ event = "inventory:Tow", label = "Rebocar", tunnel = "client" })
							end

							if CheckPolice() then
								table.insert(Menu,{ event = "towed:Impound", label = "Impound", tunnel = "server" })

								if GetResourceState("mdt") == "started" then
									table.insert(Menu,{ event = "mdt:Vehicle", label = "Apreender", tunnel = "server" })
								else
									table.insert(Menu,{ event = "prison:Vehicle", label = "Apreender", tunnel = "server" })
								end
							else
								for _,v in pairs(Dismantle) do
									if #(Coords - v) <= 15 then
										table.insert(Menu,{ event = "inventory:Dismantle", label = "Desmanchar", tunnel = "server" })
										break
									end
								end
							end
						end
					end
				end

				if #Menu >= 1 then
					SendNUIMessage({ Action = "Valid", Payload = Menu })

					Sucess = true
					while Sucess do
						DisableActions()

						if IsDisabledControlJustReleased(1,24) then
							SetCursorLocation(0.5,0.5)
							SetNuiFocus(true,true)
							Focus = true
						end

						local Ped = PlayerPedId()
						local OtherCoords,OtherEntity = RayCastGamePlayCamera()
						if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 2.0 then
							if Focus then
								SendNUIMessage({ Action = "Close" })
								SetNuiFocus(false,false)
								Actived = false
								Focus = false
							else
								SendNUIMessage({ Action = "Left" })
							end

							Sucess = false
						end

						Wait(1)
					end
				end
			elseif IsPedAPlayer(Entitys) and GetEntityHealth(Ped) > 100 and #(Coords - HitCoords) <= 2.0 then
				local Index = NetworkGetPlayerIndexFromPed(Entitys)
				local source = GetPlayerServerId(Index)

				Selected = { source }

				table.insert(Menu,{ event = "inspect:Player", label = "Revistar", tunnel = "paramedic" })

				if GetEntityHealth(Entitys) <= 100 then
					if Player(source).state.Crawl then
						table.insert(Menu,{ event = "paramedic:Adrenaline", label = "Ajudar", tunnel = "paramedic" })
					end

					if LocalPlayer.state.Paramedic then
						table.insert(Menu,{ event = "paramedic:Revive", label = "Reanimar", tunnel = "paramedic" })
					end
				else
					table.insert(Menu,{ event = "player:Demand", label = "Cobrança", tunnel = "paramedic" })
					table.insert(Menu,{ event = "marriage:Request", label = "Relacionamento", tunnel = "paramedic" })

					if IsEntityPlayingAnim(Entitys,"random@mugging3","handsup_standing_base",3) then
						table.insert(Menu,{ event = "player:checkShoes", label = "Roubar Sapatos", tunnel = "paramedic" })
					end

					if LocalPlayer.state.Paramedic then
						table.insert(Menu,{ event = "paramedic:Diagnostic", label = "Diagnóstico", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:Treatment", label = "Tratamento", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:Prescription", label = "Receitar Medicamento", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:Bandage", label = "Passar Ataduras", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:presetBurn", label = "Roupa de Queimadura", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:presetPlaster", label = "Colocar Gesso", tunnel = "paramedic" })
						table.insert(Menu,{ event = "paramedic:extractBlood", label = "Extrair Sangue", tunnel = "paramedic" })
						table.insert(Menu,{ event = "target:Repose", label = "Repouso", tunnel = "paramedic" })
					end
				end

				if CheckPolice() then
					table.insert(Menu,{ event = "prison:Itens", label = "Apreender", tunnel = "paramedic" })
				end

				if #Menu >= 1 then
					SendNUIMessage({ Action = "Valid", Payload = Menu })

					Sucess = true
					while Sucess do
						DisableActions()

						if IsDisabledControlJustReleased(1,24) then
							SetCursorLocation(0.5,0.5)
							SetNuiFocus(true,true)
							Focus = true
						end

						local Ped = PlayerPedId()
						local OtherCoords,OtherEntity = RayCastGamePlayCamera()
						if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 2.0 then
							if Focus then
								SendNUIMessage({ Action = "Close" })
								SetNuiFocus(false,false)
								Actived = false
								Focus = false
							else
								SendNUIMessage({ Action = "Left" })
							end

							Sucess = false
						end

						Wait(1)
					end
				end
			elseif IsEntityAPed(Entitys) and not DecorGetBool(Entitys,"CREATIVE_PED") and not IsPedAPlayer(Entitys) and #(Coords - HitCoords) <= 2.0 then
				Selected = { NetworkGetNetworkIdFromEntity(Entitys) }

				if LocalPlayer.state.Admin then
					table.insert(Menu,{ event = "DeletePed", label = "Deletar", tunnel = "paramedic" })
				end

				if #Menu >= 1 then
					SendNUIMessage({ Action = "Valid", Payload = Menu })

					Sucess = true
					while Sucess do
						DisableActions()

						if IsDisabledControlJustReleased(1,24) then
							SetCursorLocation(0.5,0.5)
							SetNuiFocus(true,true)
							Focus = true
						end

						local Ped = PlayerPedId()
						local OtherCoords,OtherEntity = RayCastGamePlayCamera()
						if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 2.0 then
							if Focus then
								SendNUIMessage({ Action = "Close" })
								SetNuiFocus(false,false)
								Actived = false
								Focus = false
							else
								SendNUIMessage({ Action = "Left" })
							end

							Sucess = false
						end

						Wait(1)
					end
				end
			else
				for Index in pairs(Models) do
					if DoesEntityExist(Entitys) and Index == GetEntityModel(Entitys) then
						local OtherCoords = GetEntityCoords(Entitys)
						if #(Coords - OtherCoords) <= 5 then
							SetDrawOrigin(OtherCoords.x,OtherCoords.y,OtherCoords.z + 1)
							DrawSprite("Textures","Normal",0.0,0.0,0.0185,0.0185 * GetAspectRatio(false),0.0,255,255,255,255)
							ClearDrawOrigin()
						end

						if #(Coords - HitCoords) <= Models[Index].Distance then
							if not IsEntityAMissionEntity(Entitys) then
								SetEntityAsMissionEntity(Entitys,true,true)
							end

							local Network = nil
							if NetworkGetEntityIsNetworked(Entitys) then
								Network = NetworkGetNetworkIdFromEntity(Entitys)
							end

							Selected = { Entitys,Index,Network,GetEntityCoords(Entitys),IsEntityDead(Entitys) }

							SendNUIMessage({ Action = "Valid", Payload = Models[Index].options })

							Sucess = true
							while Sucess do
								local EntityCoords = GetEntityCoords(Entitys)

								SetDrawOrigin(EntityCoords.x,EntityCoords.y,EntityCoords.z + 1)
								DrawSprite("Textures","Selected",0.0,0.0,0.0185,0.0185 * GetAspectRatio(false),0.0,255,255,255,255)
								ClearDrawOrigin()
								DisableActions()

								if IsDisabledControlJustReleased(1,24) then
									SetCursorLocation(0.5,0.5)
									SetNuiFocus(true,true)
									Focus = true
								end

								local Ped = PlayerPedId()
								local OtherCoords,OtherEntity = RayCastGamePlayCamera()
								if GetEntityType(OtherEntity) == 0 or #(GetEntityCoords(Ped) - OtherCoords) > 2.0 then
									if Focus then
										SendNUIMessage({ Action = "Close" })
										SetNuiFocus(false,false)
										Actived = false
										Focus = false
									else
										SendNUIMessage({ Action = "Left" })
									end

									Sucess = false
								end

								Wait(1)
							end
						end
					end
				end
			end
		end

		Wait(1)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGET:ROLLVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:RollVehicle")
AddEventHandler("target:RollVehicle",function(Network)
	if NetworkDoesNetworkIdExist(Network) then
		local Vehicle = NetToEnt(Network)
		if DoesEntityExist(Vehicle) then
			SetVehicleOnGroundProperly(Vehicle)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TARGETDISABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function TargetDisable()
	if Focus or not Actived then
		return false
	end

	TriggerEvent("target:Debug")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Select",function(Data,Callback)
	TriggerEvent("target:Debug")

	if not LocalPlayer.state.Cancel then
		if Data.tunnel == "client" then
			TriggerEvent(Data.event,Selected,Data.service)
		elseif Data.tunnel == "entity" then
			TriggerEvent(Data.event,Selected[1],Data.service)
		elseif Data.tunnel == "products" then
			TriggerEvent(Data.event,Data.service)
		elseif Data.tunnel == "server" then
			TriggerServerEvent(Data.event,Selected,Data.service)
		elseif Data.tunnel == "paramedic" then
			TriggerServerEvent(Data.event,Selected[1],Data.service)
		elseif Data.tunnel == "proserver" then
			TriggerServerEvent(Data.event,Data.service)
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Close",function(Data,Callback)
	TriggerEvent("target:Debug")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Debug")
AddEventHandler("target:Debug",function()
	Focus = false
	Sucess = false
	Actived = false
	SetNuiFocus(false,false)
	SendNUIMessage({ Action = "Close" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCOORDSFROMCAM
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCoordsFromCam(Distance,Coords)
	local Rotation = GetGameplayCamRot()
	local Adjuste = vec3((math.pi / 180) * Rotation.x,(math.pi / 180) * Rotation.y,(math.pi / 180) * Rotation.z)
	local Direction = vec3(-math.sin(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.cos(Adjuste[3]) * math.abs(math.cos(Adjuste[1])),math.sin(Adjuste[1]))

	return vec3(Coords[1] + Direction[1] * Distance, Coords[2] + Direction[2] * Distance, Coords[3] + Direction[3] * Distance)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RAYCASTGAMEPLAYCAMERA
-----------------------------------------------------------------------------------------------------------------------------------------
function RayCastGamePlayCamera()
	local Ped = PlayerPedId()
	local Cam = GetGameplayCamCoord()
	local Cam2 = GetCoordsFromCam(10.0,Cam)
	local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam,Cam2,-1,Ped,4)
	local Hit,__,Coords,_,Entitys = GetShapeTestResult(Handle)

	return Coords,Entitys,Hit
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddCircleZone(Name,Center,Radius,Options,Target)
	Zones[Name] = CircleZone:Create(Center,Radius,Options)
	Zones[Name].targetoptions = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCIRCLEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function RemCircleZone(Name)
	if Zones[Name] then
		Zones[Name]:destroy()
		Zones[Name] = nil
	end

	if Sucess then
		TriggerEvent("target:Debug")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDTARGETMODEL
-----------------------------------------------------------------------------------------------------------------------------------------
function AddTargetModel(Model,Options)
	for _,v in pairs(Model) do
		Models[v] = Options
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelText(Name,Text)
	if Zones[Name] then
		Zones[Name].targetoptions.options[1].label = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LABELOPTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function LabelOptions(Name,Text)
	if Zones[Name] then
		Zones[Name].targetoptions.options = Text
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBOXZONE
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBoxZone(Name,Center,Length,Width,Options,Target)
	Zones[Name] = BoxZone:Create(Center,Length,Width,Options)
	Zones[Name].targetoptions = Target
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("LabelText",LabelText)
exports("AddBoxZone",AddBoxZone)
exports("LabelOptions",LabelOptions)
exports("RemCircleZone",RemCircleZone)
exports("AddCircleZone",AddCircleZone)
exports("AddTargetModel",AddTargetModel)