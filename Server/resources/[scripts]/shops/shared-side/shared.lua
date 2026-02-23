-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
ItemList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTARTSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Shop,v in pairs(List) do
		ItemList[Shop] = ItemList[Shop] or {}

		for Key,Amount in pairs(v.List) do
			table.insert(ItemList[Shop],{ price = Amount, key = Key })
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
Location = {
	{
		Coords = vec3(954.73,-967.78,39.5),
		Mode = "Mechanic"
	},{
		Coords = vec3(24.51,-1346.75,29.49),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(2556.77,380.87,108.61),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1164.81,-323.61,69.2),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-706.16,-914.55,19.21),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-47.35,-1758.59,29.42),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(372.7,326.89,103.56),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-3242.7,1000.05,12.82),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1728.08,6415.6,35.03),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(549.09,2670.89,42.16),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1959.87,3740.44,32.33),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(2677.65,3279.66,55.23),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1697.32,4923.46,42.06),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-1819.52,793.48,138.08),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1391.62,3605.95,34.98),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-2966.41,391.52,15.05),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-3039.42,584.42,7.9),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1134.32,-983.09,46.4),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(1165.32,2710.79,38.15),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-1486.72,-377.61,40.15),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-1221.48,-907.93,12.32),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-160.54,6320.95,31.59),
		Mode = "Departament",
		Sound = true
	},{
		Coords = vec3(-1816.64,-1193.73,14.31),
		Mode = "Fishing"
	},{
		Coords = vec3(-773.55,5604.48,34.06),
		Mode = "HuntingSell",
		Name = "Vender"
	},{
		Coords = vec3(-775.93,5602.92,34.06),
		Mode = "HuntingBuy",
		Name = "Comprar"
	},{
		Coords = vec3(375.55,-829.73,29.61),
		Mode = "Pharmacy"
	},{
		Coords = vec3(1650.11,4871.61,42.11),
		Mode = "Pharmacy"
	},{
		Coords = vec3(487.93,-996.99,30.49),
		Mode = "LSPD",
		Circle = 0.1
	},{
		Coords = vec3(-628.79,-238.7,38.05),
		Mode = "Miners"
	},{
		Coords = vec3(179.9,2779.98,45.7),
		Mode = "Clandestine"
	},{
		Coords = vec3(1692.27,3760.91,34.69),
		Mode = "Ammunation"
	},{
		Coords = vec3(253.80,-50.47,69.94),
		Mode = "Ammunation"
	},{
		Coords = vec3(842.54,-1035.25,28.19),
		Mode = "Ammunation"
	},{
		Coords = vec3(-331.67,6084.86,31.46),
		Mode = "Ammunation"
	},{
		Coords = vec3(-662.37,-933.58,21.82),
		Mode = "Ammunation"
	},{
		Coords = vec3(-1304.12,-394.56,36.7),
		Mode = "Ammunation"
	},{
		Coords = vec3(-1118.98,2699.73,18.55),
		Mode = "Ammunation"
	},{
		Coords = vec3(2567.98,292.62,108.73),
		Mode = "Ammunation"
	},{
		Coords = vec3(-3173.51,1088.35,20.84),
		Mode = "Ammunation"
	},{
		Coords = vec3(22.53,-1105.52,29.79),
		Mode = "Ammunation"
	},{
		Coords = vec3(810.22,-2158.99,29.62),
		Mode = "Ammunation"
	},{
		Coords = vec3(2340.7,3126.49,48.21),
		Mode = "Dismantle"
	},

	-- Loja de Roupas
	{
		Coords = vec3(73.97,-1393.06,29.37),
		Mode = "Skinshop"
	},{
		Coords = vec3(-708.96,-151.8,37.41),
		Mode = "Skinshop"
	},{
		Coords = vec3(-164.92,-303.0,39.73),
		Mode = "Skinshop"
	},{
		Coords = vec3(-823.27,-1072.45,11.32),
		Mode = "Skinshop"
	},{
		Coords = vec3(-1194.55,-767.52,17.3),
		Mode = "Skinshop"
	},{
		Coords = vec3(-1448.95,-238.03,49.81),
		Mode = "Skinshop"
	},{
		Coords = vec3(5.95,6511.59,31.88),
		Mode = "Skinshop"
	},{
		Coords = vec3(1695.28,4823.2,42.06),
		Mode = "Skinshop"
	},{
		Coords = vec3(127.23,-223.35,54.56),
		Mode = "Skinshop"
	},{
		Coords = vec3(613.07,2761.8,42.09),
		Mode = "Skinshop"
	},{
		Coords = vec3(1196.54,2711.62,38.22),
		Mode = "Skinshop"
	},{
		Coords = vec3(-3169.1,1044.03,20.86),
		Mode = "Skinshop"
	},{
		Coords = vec3(-1102.56,2711.48,19.11),
		Mode = "Skinshop"
	},{
		Coords = vec3(426.98,-806.09,29.49),
		Mode = "Skinshop"
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
List = {
	Mechanic = {
		Mode = "Buy",
		Type = "Cash",
		Permission = "Mechanic",
		List = {
			graphite01 = 3,
			graphite02 = 3,
			graphite03 = 3
		}
	},
	Ammunation = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			WEAPON_HATCHET = 975,
			WEAPON_BAT = 975,
			WEAPON_BATTLEAXE = 975,
			WEAPON_CROWBAR = 975,
			WEAPON_SWITCHBLADE = 975,
			WEAPON_GOLFCLUB = 975,
			WEAPON_HAMMER = 975,
			WEAPON_MACHETE = 975,
			WEAPON_POOLCUE = 975,
			WEAPON_STONE_HATCHET = 975,
			WEAPON_WRENCH = 975,
			WEAPON_KNUCKLE = 975,
			WEAPON_FLASHLIGHT = 975
		}
	},
	Departament = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			postit = 20,
			cigarette = 15,
			lighter = 225,
			emptybottle = 15,
			sugarbox = 35,
			condensedmilk = 25,
			mayonnaise = 20,
			ryebread = 20,
			ricebag = 105,
			radio = 975,
			vape = 4750,
			cellphone = 725,
			camera = 425,
			binoculars = 425,
			notepad = 10,
			WEAPON_BRICK = 25,
			alliance = 525,
			axe = 1225,
			pickaxe = 1225,
			fishingrod = 1225,
			emptypurifiedwater = 1275
		}
	},
	Skinshop = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			umbrella = 155,
			rope = 925,
			scuba = 975,
			WEAPON_SHOES = 25,
			GADGET_PARACHUTE = 225,
			suitcase = 275
		}
	},
	Dismantle = {
		Mode = "Buy",
		Type = "Consume",
		Item = "ironfilings",
		List = {
			plastic = 30,
			glass = 30,
			rubber = 30,
			aluminum = 50,
			copper = 50
		}
	},
	Clandestine = {
		Mode = "Sell",
		Type = "Consume",
		Item = "dirtydollar",
		List = {
			scotchtape = 45,
			insulatingtape = 55,
			rammemory = 375,
			powersupply = 475,
			processorfan = 325,
			processor = 725,
			screws = 45,
			screwnuts = 45,
			videocard = 4225,
			ssddrive = 525,
			safependrive = 3225,
			powercable = 225,
			weaponparts = 125,
			electroniccomponents = 375,
			batteryaa = 225,
			batteryaaplus = 275,
			goldnecklace = 625,
			silverchain = 425,
			horsefigurine = 2425,
			toothpaste = 175,
			techtrash = 95,
			tarp = 65,
			sheetmetal = 65,
			roadsigns = 65,
			explosives = 105,
			sulfuric = 75,
			racesticket = 425,
			pistolbody = 275,
			smgbody = 525,
			riflebody = 975,
			pager = 425
		}
	},
	Coffee = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			coffeecup = 20
		}
	},
	Soda = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			cola = 20,
			soda = 20,
			water = 35
		}
	},
	Donut = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			donut = 15,
			chocolate = 20
		}
	},
	Hamburger = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			hamburger = 25
		}
	},
	Hotdog = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			hotdog = 20
		}
	},
	Chihuahua = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			hotdog = 20,
			hamburger = 25,
			cola = 20,
			soda = 20,
			water = 35
		}
	},
	Water = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			water = 35
		}
	},
	Cigarette = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			cigarette = 15,
			lighter = 225
		}
	},
	Fuel = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			WEAPON_PETROLCAN = 325
		}
	},
	Hospital = {
		Mode = "Buy",
		Type = "Cash",
		Permission = "Paramedic",
		List = {
			syringe01 = 45,
			syringe02 = 45,
			syringe03 = 45,
			syringe04 = 45,
			bandage = 115,
			gauze = 75,
			gdtkit = 25,
			medkit = 285,
			sinkalmy = 185,
			analgesic = 65,
			ritmoneury = 235,
			medicbag = 725,
			adrenaline = 3225,
			antipyretic = 185,
			intoxication = 350,
			complaint = 140,
			antiinfection = 295
		}
	},
	Pharmacy = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			bandage = 135,
			gauze = 90,
			medkit = 345,
			sinkalmy = 215,
			analgesic = 78,
			ritmoneury = 280,
			antipyretic = 225,
			intoxication = 420,
			complaint = 170,
			antiinfection = 355
		}
	},
	HuntingSell = {
		Mode = "Sell",
		Type = "Cash",
		List = {
			boar1star = 275,
			boar2star = 300,
			boar3star = 325,
			deer1star = 275,
			deer2star = 300,
			deer3star = 325,
			coyote1star = 275,
			coyote2star = 300,
			coyote3star = 325,
			mtlion1star = 275,
			mtlion2star = 300,
			mtlion3star = 325
		}
	},
	HuntingBuy = {
		Mode = "Buy",
		Type = "Cash",
		List = {
			ration = 125,
			WEAPON_MUSKET = 4225,
			WEAPON_MUSKET_AMMO = 10
		}
	},
	Fishing = {
		Mode = "Sell",
		Type = "Cash",
		List = {
			sardine = 65,
			smalltrout = 65,
			orangeroughy = 65,
			anchovy = 70,
			catfish = 70,
			herring = 75,
			yellowperch = 75,
			salmon = 125,
			smallshark = 250
		}
	},
	Miners = {
		Mode = "Sell",
		Type = "Cash",
		List = {
			tin_pure = 40,
			lead_pure = 40,
			copper_pure = 42,
			iron_pure = 45,
			gold_pure = 50,
			diamond_pure = 50,
			ruby_pure = 60,
			sapphire_pure = 60,
			emerald_pure = 75
		}
	},
	LSPD = {
		Mode = "Buy",
		Type = "Cash",
		Permission = "Police",
		List = {
			gsrkit = 25,
			gdtkit = 25,
			barrier = 25,
			handcuff = 125,
			spikestrips = 275
		}
	}
}