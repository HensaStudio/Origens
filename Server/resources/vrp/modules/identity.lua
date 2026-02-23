-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.Identity(Passport)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)

	return Characters[source] or vRP.SingleQuery("characters/Person",{ Passport = Passport })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FULLNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.FullName(Passport)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)

	return Identity and (Identity.Name.." "..Identity.Lastname) or NameDefault
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOWERNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.LowerName(Passport)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)

	return Identity and Identity.Name or SplitOne(NameDefault," ")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AVATAR
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Avatar", function(Passport,Permission)
	if not Passport then
		return ""
	end

	local Query, Params

	if Permission then
		Query = [[
			SELECT Image 
			FROM avatars 
			WHERE Passport = ? AND Permission = ? 
			LIMIT 1
		]]
		Params = { Passport, Permission }
	else
		Query = [[
			SELECT Image 
			FROM avatars 
			WHERE Passport = ? 
			ORDER BY id DESC 
			LIMIT 1
		]]
		Params = { Passport }
	end

	local Result = exports.oxmysql:single_async(Query, Params)

	if not Result or not Result.Image then
		return ""
	end

	return Result.Image
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LICENSE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.License(Passport)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)

	return Identity and Identity.License or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSERTPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.InsertPrison(Passport,Amount)
	local Amount = parseInt(Amount)
	local Passport = parseInt(Passport)

	if Amount > 0 then
		vRP.Query("characters/InsertPrison",{ Passport = Passport, Prison = Amount })

		local source = vRP.Source(Passport)
		if source and Characters[source] then
			Characters[source].Prison = (Characters[source].Prison or 0) + Amount
			Player(source).state.Prison = true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpdatePrison(Passport,Amount)
	local Passport = parseInt(Passport)
	local Amount = parseInt(Amount)
	if Passport <= 0 or Amount <= 0 then return end

	local source = vRP.Source(Passport)

	local Current = 0
	if source and Characters[source] then
		Current = Characters[source].Prison or 0
	else
		local Query = vRP.Query("characters/Person",{ Passport = Passport })
		if Query[1] then
			Current = parseInt(Query[1].Prison)
		end
	end

	if Current <= 0 then return end

	local Reduce = math.min(Current,Amount)
	local Remaining = Current - Reduce

	vRP.Query("characters/ReducePrison",{ Passport = Passport, Prison = Reduce })

	if source and Characters[source] then
		Characters[source].Prison = Remaining
		Player(source).state.Prison = Remaining > 0

		if Remaining > 0 then
			TriggerClientEvent("Notify", source, "Penitenciária de Bolingbroke", "Você reduziu <b>"..Dotted(Reduce).." Serviço</b>.", "policia", 5000)
		else
			Player(source).state.Prison = false
			TriggerClientEvent("Notify", source, "Penitenciária de Bolingbroke", "Você ganhou a liberdade da prisão.", "policia", 10000)

			vRP.Teleport(source, PrisonOutside)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEANPRISON
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.CleanPrison(Passport,Silenced)
	local Passport = parseInt(Passport)
	if Passport <= 0 then return end

	vRP.Query("characters/CleanPrison",{ Passport = Passport })

	local source = vRP.Source(Passport)
	if source and Characters[source] then
		Characters[source].Prison = 0
		Player(source).state.Prison = false

		if not Silenced then
			TriggerClientEvent("Notify", source, "Penitenciária de Bolingbroke", "Você ganhou a liberdade da prisão.", "policia", 10000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADECHARACTERS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeCharacters(source)
	if Characters[source] then
		vRP.Query("accounts/UpdateCharacters",{ License = Characters[source].License })
		Characters[source].Characters = Characters[source].Characters + 1
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UserGemstone(License)
	return vRP.Account(License).Gemstone or 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeGemstone(Passport,Amount,SendLicense)
	local Amount = parseInt(Amount)
	local Passport = parseInt(Passport)
	local Identity = vRP.Identity(Passport)
	if Amount > 0 and Identity then
		vRP.Query("accounts/AddGemstone",{ License = Identity.License, Gemstone = Amount })

		if DiscordBot and SendLicense then
			local Account = vRP.Account(Identity.License)
			exports.discord:Content("Gemstone",Account.Discord.." Obrigado por sua contribuição ao **"..ServerName.."**, seus **"..Dotted(Amount).."x Diamantes** foram creditados em sua conta.")
		end

		local source = vRP.Source(Passport)
		if Characters[source] then
			TriggerClientEvent("hud:AddGemstone",source,Amount)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEGEMSTONE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GiveGemstone(Passport,Amount)
	Amount = parseInt(Amount)
	Passport = parseInt(Passport)

	if Amount <= 0 then
		return false
	end

	local Identity = vRP.Identity(Passport)
	if not Identity then
		return false
	end

	vRP.UpgradeGemstone(Passport,Amount,false)

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADENAMES
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.UpgradeNames(Passport,Name,Lastname)
	local Passport = parseInt(Passport)
	local source = vRP.Source(Passport)

	if Characters[source] then
		Characters[source].Name = Name
		Characters[source].Lastname = Lastname
	end

	vRP.Query("characters/UpdateName",{ Name = Name, Lastname = Lastname, Passport = Passport })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORTPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.PassportPlate(Plate)
	local Consult = vRP.SingleQuery("vehicles/plateVehicles",{ Plate = Plate })
	return Consult and Consult.Passport or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEPLATE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GeneratePlate()
	repeat
		Plate = GenerateString("DDLLLDDD")
	until Plate and not vRP.PassportPlate(Plate)

	return Plate
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATETOKEN
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateToken()
	repeat
		Token = GenerateString("DDDDDDD")
	until Token and not vRP.SingleQuery("accounts/Token",{ Token = Token })

	return Token
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEHASH
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.GenerateHash(Index)
	repeat
		Hash = GenerateString("DDLLDDLL")
	until Hash and not vRP.SingleQuery("entitydata/GetData",{ Name = Index..":"..Hash })

	return Hash
end