-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MaxRepair = 1 -- Máximo de reparos em um item
MinimumWeight = 15 -- Peso mínimo padrão que todo jogador tem no inventário
NotifyLogin = true -- Envia notificação de login
NotifyWeather = true -- Envia notificação de mudança de clima
GroupsSetCooldown = 259200 -- Tempo em segundos (3 dias) para trocar de emprego/grupo do tipo Work
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
Banned = {
	Mute = true, -- Deixa sem poder falar
	Route = 9999998, -- Dimensão
	Leave = vec3(242.71,-392.01,46.30) -- Coordenada de saída
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDS
-----------------------------------------------------------------------------------------------------------------------------------------
CreatorCoords = vec4(-2006.95,2960.77,31.81,305.82) -- Localização onde o personagem é Criado
PrisonInside = vec3(1691.54,2566.08,45.56) -- Localização de Dentro da Prisão
PrisonOutside = vec3(1849.95,2586.06,45.67) -- Localização de Fora da Prisão
-----------------------------------------------------------------------------------------------------------------------------------------
-- BATTLEPASS
-----------------------------------------------------------------------------------------------------------------------------------------
BATTLEPASS_POINTS = 500 -- Pontos necessários para liberar recompensas
BATTLEPASS_PRICE = 10000 -- Preço do passe de batalha
BATTLEPASS_START = 1744165448 -- Timestamp de início do passe
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "$" -- Símbolo da moeda
BaseMode = "steam" -- Identificador principal (pode ser "steam" ou "rockstar")
LiberationMode = "Token" -- Método usado na whitelist (Token ou id)
Whitelisted = true -- Ativa whitelist
DisconnectReason = 30
SalaryCooldowns = 1800 -- Tempo em segundos entre pagamentos de salário
NameDefault = "Indivíduo Indigente" -- Nome padrão se o jogador não tiver identidade
VehicleSpeed = 3.6 -- Múltiplicador de velocidade dos veículos (3.6 = Km/h)
ShakeVehicleCamera = true -- Balançar a câmera do personagem quando bater o veículo
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
ServerLink = "https://hensa.site" -- Link exibido na whitelist
ServerName = "Hensa" -- Nome do servidor
ServerAvatar = "https://i.ibb.co/Jwp4Z2f8/Hensa2.png" -- Avatar padrão do servidor
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADAPTIVECARDS
-----------------------------------------------------------------------------------------------------------------------------------------
AdaptiveCardsEnabled = true -- Ativo em geral
AdaptiveCardsLicense = true -- Mostrado em caso de erro na License
AdaptiveCardsAccount = true -- Mostrado em caso de erro na Account
AdaptiveCardsMaintenance = true -- Mostrado em caso de Manutenção
AdaptiveCardsBan = true -- Mostrado em caso de Banimento
AdaptiveCardsWhitelist = true -- Mostrado em caso de Whitelist
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
MaintenanceEnabled = false -- Ativa manutenção do servidor
Maintenance = {
	["28072000"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTS
-----------------------------------------------------------------------------------------------------------------------------------------
WeatherWarning = "O clima atual está em:"
LoginWarning = "<b>Ficamos felizes em ter você aqui!</b> Aproveite bastante, mas sempre com responsabilidade. Não se esqueça de curtir com cautela e respeitar as regras da cidade."
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
DiscordBot = false -- Ativa integração com bot do Discord
DiscordToken = "" -- Token do bot
-----------------------------------------------------------------------------------------------------------------------------------------
-- CELLPHONE
-----------------------------------------------------------------------------------------------------------------------------------------
UsingLB = false -- Ativa integração com o LB Phone
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnCoords = {
	vec3(895.48,-179.38,73.7) -- Coordenadas de spawn inicial
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTUREPACK
-----------------------------------------------------------------------------------------------------------------------------------------
TexturePack = {
	{ Width = 19, Height = 20, Image = "E" },
	{ Width = 19, Height = 20, Image = "H" },
	{ Width = 72, Height = 72, Image = "Drop" },
	{ Width = 43, Height = 67, Image = "Races" },
	{ Width = 72, Height = 72, Image = "Normal" },
	{ Width = 102, Height = 20, Image = "EPress" },
	{ Width = 102, Height = 20, Image = "HPress" },
	{ Width = 72, Height = 72, Image = "Selected" },
	{ Width = 72, Height = 72, Image = "Marker" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	-- STAFF
	Admin = {
		Permission = {
			Admin = true
		},
		Hierarchy = { "Administrador","Diretor","Moderador","Suporte","Ajudante" },
		Name = "Adminstradores",
		Service = true,
		Chat = true,
		Max = 30
	},

	-- PREMIUMS
	Ouro = {
		Permission = {
			Ouro = true
		},
		Hierarchy = { "Membro" },
		Salary = { 3750 },
		Backpack = { 25 },
		Service = true,
		Block = true
	},
	Prata = {
		Permission = {
			Prata = true
		},
		Hierarchy = { "Membro" },
		Salary = { 2500 },
		Backpack = { 15 },
		Service = true,
		Block = true
	},
	Bronze = {
		Permission = {
			Bronze = true
		},
		Hierarchy = { "Membro" },
		Salary = { 1250 },
		Backpack = { 5 },
		Service = true,
		Block = true
	},

	-- SERVIÇOS
	LSPD = {
		Permission = {
			LSPD = true
		},
		Hierarchy = { "Comandante","Capitão","Tenente","Sargento","Oficial","Cadete" },
		Salary = { 2500,2250,2000,1750,1500,1500 },
		Name = "Los Santos Police Department",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 26,
		Banned = true,
		Chat = true
	},
	PRPD = {
		Permission = {
			PRPD = true
		},
		Hierarchy = { "Chefe","Fiscal","Sargento","Patrulheiro","Aspirante","Estagiário" },
		Salary = { 2500,2250,2000,1750,1500,1500 },
		Name = "Park Ranger Police Department",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 15,
		Banned = true,
		Chat = true
	},
	Paramedic = {
		Permission = {
			Paramedic = true
		},
		Hierarchy = { "Chefe","Médico","Enfermeiro","Residente" },
		Salary = { 3750,3625,3500,3375 },
		Name = "Hospital Pillbox",
		Service = true,
		Type = "Work",
		Markers = 34,
		Banned = true,
		Chat = true
	},
	Mechanic = {
		Permission = {
			Mechanic = true
		},
		Hierarchy = { "Líder","Membro","Recruta" },
		Salary = { 3750,3625,3500 },
		Name = "Mecânica Auto Care",
		Service = true,
		Type = "Work",
		Markers = 34,
		Banned = true,
		Chat = true
	},

	-- GANGS
	Ballas = {
		Permission = {
			Ballas = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = true,
		Chest = true,
		Type = "Work"
	},
	Vagos = {
		Permission = {
			Vagos = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = true,
		Chest = true,
		Type = "Work"
	},
	Families = {
		Permission = {
			Families = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = true,
		Chest = true,
		Type = "Work"
	},

	-- RESTAURANTE
	BurgerShot = {
		Permission = {
			BurgerShot = true
		},
		Hierarchy = { "Dono","Sócio","Gerente","Maitré","Especialista","Cozinheiro Sênior","Cozinheiro Pleno","Cozinheiro Júnior","Ajudante de Cozinha","Estagiário de Cozinha" },
		Salary = { 4000,3750,3500,3250,3000,2750,2500,2250,2000,1750 },
		Service = true,
		Chest = true,
		Type = "Work"
	},

	-- GRUPOS
	Police = {
		Permission = {
			LSPD = true,
			PRPD = true
		},
		Hierarchy = { "Membro" },
		Service = {},
		Block = true
	},
	Emergency = {
		Permission = {
			LSPD = true,
			PRPD = true,
			Paramedic = true
		},
		Hierarchy = { "Membro" },
		Service = {},
		Block = true
	},

	-- DOMINATION
	Lester = {
		Permission = {
			Lester = true
		},
		Hierarchy = { "Chefe","Subchefe","Membro" },
		Service = true
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = { -- Itens dados ao criar personagem
	identity = 1
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	treasurebox = { -- Caixa de tesouro
		Multiplier = { Min = 1, Max = 1 },
		List = {
			{ Item = "dollar", Chance = 100, Min = 4250, Max = 6250 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPPERLEVEL
-----------------------------------------------------------------------------------------------------------------------------------------
UpperLevel = {
	Trucker = { -- Experiência do emprego
		["2"] = { -- Nível que vai receber a recompensa
			{ Item = "bandage", Min = 1, Max = 2 },
			{ Item = "advtoolbox", Min = 1, Max = 1 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
SkinshopInit = { -- Define roupas iniciais para personagens masculinos e femininos
	mp_m_freemode_01 = {
		pants = { item = 4, texture = 1 },
		arms = { item = 0, texture = 0 },
		tshirt = { item = 15, texture = 0 },
		torso = { item = 273, texture = 0 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	},
	mp_f_freemode_01 = {
		pants = { item = 4, texture = 1 },
		arms = { item = 14, texture = 0 },
		tshirt = { item = 3, texture = 0 },
		torso = { item = 338, texture = 2 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = { -- Define cabelo, barba, maquiagem etc. iniciais
	mp_m_freemode_01 = { 13,25,0,3,0,-1,-1,-1,-1,13,38,38,0,0,0,0,0.5,0,0,1,0,10,1,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 },
	mp_f_freemode_01 = { 13,25,1,3,0,-1,-1,-1,-1,1,38,38,0,0,0,0,1,0,0,1,0,0,0,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = { -- Configurações de tema do HUD, menus, notificações e chat
	shadow = true,
	main = "#588b16",
	mainText = "#ffffff",
	currency = Currency,
	items = ListItem,
	groups = Groups,

	common = "#588b16",
	rare = "#6ac6c5",
	epic = "#c66a75",
	legendary = "#c6986a",
	accept = {
		letter = "#dcffe9",
		background = "#588b16"
	},
	reject = {
		letter = "#ffe8e8",
		background = "#ad4443"
	},
	loading = {
		mode = "dark", -- [ Opções disponíveis: dark,light ],
		model = 2, -- [ Opções disponíveis: 1,2 ],
		progress = true -- [ Opções disponíveis: true, false ],
	},
	chat = {
		Importante = {
			background = "#9d194e",
			letter = "#f7c1d6"
		},
		LSPD = {
			background = "#16468b",
			letter = "#ffffff"
		},
		PRPD = {
			background = "#2d402d",
			letter = "#ffffff"
		},
		Paramedic = {
			background = "#9f1918",
			letter = "#ffffff"
		},
		Mechanic = {
			background = "FF854802",
			letter = "#ffffff"
		},
		Families = {
			background = "#4d7a06",
			letter = "#ffffff"
		},
		Ballas = {
			background = "#430d8e",
			letter = "#ffffff"
		},
		Vagos = {
			background = "#948209",
			letter = "#ffffff"
		}
	},
	hud = {
		modes = {
			info = 3, -- [ Opções disponíveis: 1,2,3 ],
			icon = "fill", -- [ Opções disponíveis: fill,line ],
			status = 10, -- [ Opções disponíveis: 1 a 12 ],
			vehicle = 3 -- [ Opções disponíveis: 1,2,3 ]
		},
		logo = 75, -- tamanho da logo
		percentage = true,
		icons = "#FFFFFF",
		nitro = "#f69d2a",
		rpm = "#FFFFFF",
		fuel = "#f94c54",
		engine = "#ff4c55",
		health = "#588b16",
		armor = "#A66FED",
		hunger = "#F4B266",
		thirst = "#7FC8F8",
		oxygen = "#38F8F8",
		stress = "#E287C9",
		luck = "#F18A7C",
		dexterity = "#E4E76E",
		repose = "#7FCCC7",
		pointer = "#ef4444",
		progress = {
			background = "#FFFFFF",
			circle = "#588b16",
			letter = "#FFFFFF"
		}
	},
	notifyitem = {
		add = {
			letter = "#dcffe9",
			background = "#3fa466"
		},
		remove = {
			letter = "#ffe8e8",
			background = "#ad4443"
		}
	},
	pause = {
		premium = true,
		propertys = true,
		store = true,
		battlepass = true,
		boxes = true,
		marketplace = true,
		skinweapon = true,
		ranking = true,
		statistics = true,
		daily = true,
		code = true,
		map = true,
		settings = true,
		hud = true,
		disconnect = true
	},
	scripts = {
		taximeter = {
			main = "#efcf2f",
			mainText = "#120b02"
		}
	},
	eyeColorAtBarbershop = true
}
