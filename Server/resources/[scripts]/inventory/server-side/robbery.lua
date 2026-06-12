-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
-- Last: Utilizado apenas em roubos globais e exclusivos para indicar a última ocorrência.
--        Valor padrão: 1

-- Delay: Tempo de espera antes de permitir um novo roubo, usado apenas se diferente do padrão.
--        Valor padrão: 3600 segundos

-- Timer: Duração total do roubo, utilizado somente quando o tempo for diferente do padrão.
--        Valor padrão: 30 segundos

-- Wanted: Duração do estado de procurado após o roubo, aplicado somente se for diferente do padrão.
--        Valor padrão: 60 segundos

-- Cooldown: Define o tipo de cooldown do roubo.
--           Se for uma tabela, o roubo terá múltiplos cooldowns (multiplicador).
--           Se for um timestamp (os.time()), o cooldown será único.

-- Percentage: Probabilidade, em milésimos, de chamar a polícia durante o roubo.

-- Police: Quantidade mínima de policiais em serviço necessária para iniciar o roubo.
--         Utilizado somente quando essa restrição for necessária.

-- Explosion: Flag que indica se o roubo envolve explosões.
--            Utilizado somente quando aplicável.

-- Residual: Tipo de resíduo deixado após o roubo, usado apenas se diferente do padrão.
--           Valor padrão: "Resquício de Línter"

-- Need: Item(s) obrigatório(s) que o jogador deve possuir para iniciar o roubo.
--       Utilizado apenas quando houver essa exigência.
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG
-----------------------------------------------------------------------------------------------------------------------------------------
local Config = {
	Laundromat = {
		Police = 4,
		Timer = 300,
		Wanted = 1800,
		Delay = 3600,
		Cooldown = {},
		Title = "Lavanderia",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "wetdollar", Chance = 100, Min = 25000, Max = 65000 }
			}
		},
		Need = {
			Item = "lockpick",
			Amount = 1,
			Consume = true
		},
		Animation = {
			Dict = "mini@safe_cracking",
			Name = "dial_turn_anti_fast_1"
		}
	},
	Ammunation = {
		Police = 6,
		Timer = 300,
		Wanted = 1800,
		Delay = 3600,
		Cooldown = {},
		Title = "Loja de Armamentos",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "dirtydollar", Chance = 100, Min = 50000, Max = 75000 }
			}
		},
		Need = {
			Item = "lockpick",
			Amount = 1,
			Consume = true
		},
		Animation = {
			Dict = "mini@safe_cracking",
			Name = "dial_turn_anti_fast_1"
		}
	},
	Department = {
		Police = 8,
		Timer = 300,
		Wanted = 1800,
		Delay = 3600,
		Cooldown = {},
		Title = "Loja de Departamento",
		Residual = "Resquício de Línter",
		Payment = {
			Multiplier = { Min = 1, Max = 1 },
			List = {
				{ Item = "dirtydollar", Chance = 100, Min = 75000, Max = 100000 }
			}
		},
		Need = {
			Item = "lockpick",
			Amount = 1,
			Consume = true
		},
		Animation = {
			Dict = "mini@safe_cracking",
			Name = "dial_turn_anti_fast_1"
		}
	},
	Register = {
		Timer = 15,
		Cooldown = {},
		Safecrack = true,
		Percentage = 750,
		Title = "Roubo a Registradora",
		Payment = {
			Money = { Item = "dirtydollar", Min = 325, Max = 375 }
		},
		Animation = {
			Dict = "oddjobs@shop_robbery@rob_till",
			Name = "loop"
		}
	},
	Container = {
		Wanted = 120,
		Cooldown = {},
		Percentage = 750,
		Title = "Roubo a Container",
		Payment = {
			Multiplier = { Min = 1, Max = 2 },
			Money = { Item = "dirtydollar", Min = 325, Max = 375 },
			List = {
				{ Item = "water", Chance = 100, Min = 1, Max = 2 },
				{ Item = "bandage", Chance = 100, Min = 1, Max = 2 },
				{ Item = "weedclone", Chance = 100, Min = 1, Max = 2 },
				{ Item = "laundromataccess", Chance = 50, Min = 1, Max = 2 }
			}
		},
		Animation = {
			Dict = "oddjobs@shop_robbery@rob_till",
			Name = "loop"
		}
	},
	Eletronic = {
		Police = 5,
		Delay = 300,
		Wanted = 600,
		Cooldown = {},
		Explosion = true,
		Title = "Caixa Eletrônico",
		Need = {
			Item = "explosives",
			Amount = 1,
			Consume = true
		},
		Payment = {
			Money = { Item = "dirtydollar", Min = 325, Max = 375 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERYACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:RobberyActive",function(Mode,Number)
	local Configuration = Config[Mode]
	if not Configuration then return end

	local Delay = Configuration.Delay or 3600

	if type(Configuration.Cooldown) == "table" then
		Configuration.Cooldown[Number] = os.time() + Delay
	else
		Configuration.Last = Number
		Configuration.Cooldown = os.time() + Delay
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:ROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Robbery")
AddEventHandler("inventory:Robbery",function(Number,Mode)
	local source = source
	local Passport = vRP.Passport(source)
	local Configuration = Config[Mode]

	if not Passport or Active[Passport] or not Configuration then
		return
	end

	if Configuration.Police and vRP.AmountService("Police") < Configuration.Police then
		TriggerClientEvent("Notify",source,"Atenção","Contingente indisponível.","amarelo",5000)
		return
	end

	if Configuration.Need then
		if not vRP.ConsultItem(Passport,Configuration.Need.Item,Configuration.Need.Amount) then
			TriggerClientEvent("Notify",source,"Atenção","Precisa de <b>"..Configuration.Need.Amount.."x "..ItemName(Configuration.Need.Item).."</b>.","amarelo",5000)
			return
		end
	end

	if Configuration.Safecrack then
		local TaskResult = vRP.Safecrack(source,1)
		if not TaskResult then
			TriggerClientEvent("Notify",source,"Atenção","Você fracassou.","amarelo",5000)
			return
		end
	end

	local Now = os.time()
	local Type = type(Configuration.Cooldown)
	local Cooldown = Type == "table" and (Configuration.Cooldown[Number] or 0) or (Configuration.Cooldown or 0)

	if Now < Cooldown then
		TriggerClientEvent("Notify",source,"Atenção","Aguarde "..CompleteTimers(Cooldown - Now)..".","amarelo",5000)
		return
	end

	local Delay = Configuration.Delay or 3600
	if Type == "table" then
		Configuration.Cooldown[Number] = Now + Delay
	else
		Configuration.Last = Number
		Configuration.Cooldown = Now + Delay
	end

	Player(source).state.Buttons = true
	Robberys[Passport] = { Mode = Mode, Number = Number }
	Active[Passport] = Now + (Configuration.Timer or 30)

	TriggerClientEvent("Progress",source,"Roubando",(Configuration.Timer or 30) * 1000)
	TriggerClientEvent("player:Residual",source,Configuration.Residual or "Resquício de Línter")

	if Configuration.Explosion then
		vRPC.playAnim(source,false,{ "anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer" },true)
		SetTimeout(5000,function()
			vRPC.Destroy(source)
		end)
	elseif Configuration.Animation then
		vRPC.playAnim(source,false,{ Configuration.Animation.Dict, Configuration.Animation.Name },true)
	end

	exports.vrp:CallPolice({
		Source = source,
		Passport = Passport,
		Permission = "Police",
		Title = Configuration.Title,
		Percentage = Configuration.Percentage,
		Wanted = Configuration.Wanted or 60,
		Code = 31,
		Color = 22
	})

	CreateThread(function()
		while Active[Passport] and os.time() < Active[Passport] do
			Wait(100)
		end

		vRPC.Destroy(source)
		Player(source).state.Buttons = false
		Robberys[Passport] = nil

		if not Active[Passport] then return end
		Active[Passport] = nil

		if Configuration.Need and Configuration.Need.Consume then
			vRP.TakeItem(Passport,Configuration.Need.Item,Configuration.Need.Amount,true)
		end

		local Valuation = math.random(Configuration.Payment.Money.Min,Configuration.Payment.Money.Max)

		if exports.party:DoesExist(Passport,2) then
			Valuation = Valuation * 1.1
		end

		if exports.inventory:Buffs("Dexterity",Passport) then
			Valuation = Valuation * 1.1
		end

		for Permission,Multiplier in pairs({
			Ouro = 0.10,
			Prata = 0.075,
			Bronze = 0.05
		}) do
			if vRP.HasService(Passport,Permission) then
				Valuation = Valuation * (1 + Multiplier)
			end
		end

		Valuation = math.floor(Valuation)

		if Mode == "Register" then
			vRP.GenerateItem(Passport,Configuration.Payment.Money.Item,Valuation,true)
		elseif Configuration.Explosion then
			local Coords = Robbery[Number] and Robbery[Number].Coords or GetEntityCoords(GetPlayerPed(source))

			for _,PlayerSource in pairs(vRPC.Players(source)) do
				async(function()
					TriggerClientEvent("inventory:Explosion",PlayerSource,Coords)
				end)
			end

			exports.inventory:Drops(Passport,source,Configuration.Payment.Money.Item,Valuation,false,Coords)
		else
			local Multiplier = math.random(Configuration.Payment.Multiplier.Min,Configuration.Payment.Multiplier.Max)
			vRP.MountContainer(Passport,Mode..":"..Number,Configuration.Payment.List,Multiplier,false)

			TriggerClientEvent("chest:Open",source,Mode..":"..Number,"Custom",false,true)
		end
	end)
end)