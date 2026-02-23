-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES:SOURCES
-----------------------------------------------------------------------------------------------------------------------------------------
Sources = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES:PLAYING
-----------------------------------------------------------------------------------------------------------------------------------------
Playing = {}
Playing.Online = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLE:CHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
Characters = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCEISLICENSEFORMATVALID
-----------------------------------------------------------------------------------------------------------------------------------------
local function MaintenanceIsLicenseFormatValid(License)
	if type(License) ~= "string" then
		return false
	end

	if BaseMode == "steam" then
		return License:match("^[0-9a-fA-F]+$") ~= nil
	end

	if BaseMode == "rockstar" then
		return License:match("^%d+$") ~= nil
	end

	return License ~= ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCECANACCESS
-----------------------------------------------------------------------------------------------------------------------------------------
local function MaintenanceCanAccess(License)
	if not MaintenanceEnabled then
		return true
	end

	if not MaintenanceIsLicenseFormatValid(License) then
		return false
	end

	if type(Maintenance) ~= "table" then
		return false
	end

	if Maintenance[License] then
		return true
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLE:PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
local Prepare = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Prepare(Name,Query)
	Prepare[Name] = Query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Query(Name,Params)
	return exports.oxmysql:query_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Update(Name,Params)
    return exports.oxmysql:update_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SINGLEQUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SingleQuery(Name,Params)
    return exports.oxmysql:single_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SCALAR
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Scalar(Name,Params)
	return exports.oxmysql:scalar_async(Prepare[Name],Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identities(source)
	local Identities = GetPlayerIdentifierByType(source,BaseMode)

	return Identities and SplitTwo(Identities,":") or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Archive(Archive,Text)
	local Message = LoadResourceFile("archives",Archive)
	SaveResourceFile("archives",Archive,(Message or "")..Text.."\n",-1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Account(License)
	return vRP.SingleQuery("accounts/Account",{ License = License })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Discord(Discord)
	return vRP.SingleQuery("accounts/Discord",{ Discord = Discord })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTINFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AccountInformation(Passport,Mode)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)
	if not Identity then return false end

	local Account = vRP.Account(Identity.License)
	return Account and Account[Mode] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTOPTIMIZE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.AccountOptimize(Passport)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)

	return Identity and vRP.Account(Identity.License) or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserData(Passport,Key)
	local Consult = vRP.SingleQuery("playerdata/GetData",{ Passport = Passport, Name = Key })

	return Consult and json.decode(Consult.Information) or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIMPLEDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SimpleData(Passport,Key)
	local Consult = vRP.SingleQuery("playerdata/GetData",{ Passport = Passport, Name = Key })

	return Consult and json.decode(Consult.Information) or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsidePropertys(Passport,Coords)
	local Datatable = vRP.Datatable(Passport)
	if Datatable then
		Datatable.Pos = Coords
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Inventory(Passport)
	local Datatable = vRP.Datatable(Passport)

	return Datatable and (Datatable.Inventory or {}) or {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.SkinCharacter(Passport,Hash)
	vRP.Query("characters/SetSkin",{ Passport = Passport, Skin = Hash })

	local source = vRP.Source(Passport)
	if Characters[source] then
		Characters[source].Skin = Hash
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Passport(source)
	return Characters[source] and Characters[source].id or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Players()
	return Sources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERSOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Source(Passport)
	return Sources[parseInt(Passport)] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Datatable(Passport)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)

	if Characters[source] then
		return Characters[source].Datatable
	else
		return vRP.UserData(Passport,"Datatable")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLEINFORMATION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.DatatableInformation(Passport,Mode)
	local Passport = parseInt(Passport)

	return vRP.Datatable(Passport)[Mode] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEDATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdateDatatable(Passport,Mode,Value)
	local source = vRP.Source(Passport)
	local Datatable = Characters[source] and vRP.Datatable(Passport) or vRP.UserData(Passport,"Datatable")

	Datatable[Mode] = Value

	if not Characters[source] then
		vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Kick(source,Reason)
	if Disconnect(source,Reason) then
		DropPlayer(source,Reason)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(Reason)
	Disconnect(source,Reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Disconnect(source,Reason)
	local Armour = 0
	local Health = 100
	local Coords = SpawnCoords[1]
	local Ped = GetPlayerPed(source)

	if DoesEntityExist(Ped) then
		Armour = GetPedArmour(Ped)
		Health = GetEntityHealth(Ped)
		Coords = GetEntityCoords(Ped)
	end

	local Passport = vRP.Passport(source)
	if not Passport then
		return false
	end

	local Datatable = vRP.Datatable(Passport)
	if not Datatable then
		return false
	end

	Datatable.Armour = Armour
	Datatable.Health = Health
	Datatable.Pos = Coords
	
	if DisconnectReason then
		exports.chat:Postit(Passport,Coords,Reason,DisconnectReason)
	end

	local License = vRP.Identities(source)
	TriggerEvent("Disconnect",Passport,source,License)
	vRP.Query("characters/LastLogin",{ Passport = Passport })
	vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Datatable", Information = json.encode(Datatable) })
	exports["discord"]:Embed("Disconnect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[VIDA]:** "..Datatable.Health.."\n**[COLETE]:** "..Datatable.Armour.."\n**[COORDS]:** "..Datatable.Pos.."\n**[MOTIVO]:** "..Reason)

	if Characters[source] then
		Characters[source] = nil
	end

	if Sources[Passport] then
		Sources[Passport] = nil
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERCONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerConnecting",function(_,__,deferrals)
	deferrals.defer()

	local Source = source
	deferrals.update("Validando identificação...")

	local License = vRP.Identities(Source)
	if not License then
		deferrals.done("\n\nNão foi possível efetuar conexão com a Steam.")
		return
	end

	local function Present(Card,Fallback,UseCard)
		if UseCard and AdaptiveCardsEnabled and deferrals.presentCard then
			deferrals.presentCard(Card,function()
				deferrals.done()
			end)
		else
			deferrals.done(Fallback)
		end
	end

	local function Generate(Body,Actions)
		return json.encode({
			["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
			type = "AdaptiveCard",
			version = "1.6",
			body = Body,
			actions = Actions
		})
	end

	deferrals.update("Verificando conta...")

	local Account = vRP.Account(License)
	if not Account then
		vRP.Query("accounts/NewAccount",{ License = License, Token = vRP.GenerateToken() })

		Account = vRP.Account(License)
	end

	if not Account then
		deferrals.done("\n\nNão foi possível carregar sua conta.")
		return
	end

	deferrals.update("Verificando manutenção...")

	if not MaintenanceCanAccess(License) then
		local Card = Generate({
			{
				type = "TextBlock",
				text = "O servidor encontra-se em manutenção.",
				size = "Medium",
				weight = "Bolder",
				wrap = true
			},
			{
				type = "TextBlock",
				text = "Para mais informações, acesse: "..ServerLink,
				size = "Small",
				wrap = true
			}
		},nil)

		Present(Card,"\n\nServidor em manutenção.\nAcesse: "..ServerLink,AdaptiveCardsMaintenance)
		return
	end

	deferrals.update("Verificando penalidades...")

	local CurrentTime = os.time()
	local BanTime = tonumber(Account.Banned or 0)

	if BanTime and BanTime ~= 0 then
		if BanTime == -1 then
			local Reason = Account.Reason or "Banimento administrativo"

			deferrals.done("\n\nVocê está banido permanentemente.\nMotivo: "..Reason)
			return
		end

		if BanTime > CurrentTime then
			local Remaining = BanTime - CurrentTime
			local Days = math.floor(Remaining / 86400)
			local Hours = math.floor((Remaining % 86400) / 3600)
			local Minutes = math.floor((Remaining % 3600) / 60)

			local Reason = Account.Reason or "Banimento administrativo"

			deferrals.done("\n\nVocê está banido.\nTempo restante: "..Days.."d "..Hours.."h "..Minutes.."m\nMotivo: "..Reason)
			return
		end

		if BanTime < CurrentTime then
			vRP.Query("accounts/Unban",{ License = License })
		end
	end

	deferrals.update("Verificando liberação...")

	if Whitelisted and not Account.Whitelist then
		local Code = tostring(Account[LiberationMode] or "")

		local Card = Generate({
			{
				type = "TextBlock",
				text = "Efetue sua liberação enviando o código abaixo:",
				wrap = true,
				size = "Medium"
			},
			{
				type = "TextBlock",
				text = Code,
				weight = "Bolder",
				size = "Large",
				wrap = true
			}
		},{
			{
				type = "Action.OpenUrl",
				title = "Abrir Discord",
				url = ServerLink
			}
		})

		Present(Card,"\n\nEfetue sua liberação enviando o código "..Code.." em "..ServerLink,AdaptiveCardsWhitelist)
		return
	end

	vRP.Query("accounts/LastLogin",{ License = License })
	deferrals.update("Conectando ao servidor...")
	deferrals.done()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CharacterChosen(source,Passport,Model)
	Sources[Passport] = source

	if not Characters[source] then
		vRP.Query("characters/LastLogin",{ Passport = Passport })

		local License = vRP.Identities(source)
		local Account = vRP.Account(License)
		local Character = vRP.SingleQuery("characters/Person",{ Passport = Passport })

		Characters[source] = { Datatable = vRP.UserData(Passport,"Datatable") }

		for Index,v in pairs(Account) do
			Characters[source][Index] = v
		end

		for Index,v in pairs(Character) do
			Characters[source][Index] = v
		end

		if Model then
			Characters[source].Datatable.Inventory = {}

			for Item,Amount in pairs(CharacterItens) do
				vRP.GenerateItem(Passport,Item,Amount,false)
			end

			local Table = {
				{ Name = "Barbershop", Information = json.encode(BarbershopInit[Model]) },
				{ Name = "Clothings", Information = json.encode(SkinshopInit[Model]) },
				{ Name = "Tattooshop", Information = json.encode({}) },
				{ Name = "Datatable", Information = json.encode({}) }
			}

			for _,v in ipairs(Table) do
				vRP.Query("playerdata/SetData",{ Passport = Passport, Name = v.Name, Information = v.Information })
			end
		end

		if Account.Gemstone > 0 then
			TriggerClientEvent("hud:AddGemstone",source,Account.Gemstone)
		end

		exports["discord"]:Embed("Connect","**[SOURCE]:** "..source.."\n**[PASSAPORTE]:** "..Passport.."\n**[ADDRESS]:** "..GetPlayerEndpoint(source).."\n**[LICENSE]:** "..Account.License.."\n**[discord:** <@"..Account.Discord..">")

		if DiscordBot then
			exports["discord"]:Content("Rename",Account.Discord.." #"..Passport.." "..Character.Name.." "..Character.Lastname)
		end

		TriggerEvent("CharacterChosen",Passport,source,Model ~= nil)
	else
		DropPlayer(source,"Desconectado")
	end
end
