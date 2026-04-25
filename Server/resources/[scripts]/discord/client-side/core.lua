-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function(Passport,Name)
	SetDiscordAppId(1448715044333424782)
	SetDiscordRichPresenceAsset("hensa")
	SetRichPresence("#"..Passport.." "..Name)
	SetDiscordRichPresenceAssetText("hensa")
	SetDiscordRichPresenceAssetSmall("hensa")
	SetDiscordRichPresenceAssetSmallText("hensa")
	SetDiscordRichPresenceAction(0,"Site","https://hensa.site")
end)