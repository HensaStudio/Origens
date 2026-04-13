-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local ResourceName = GetCurrentResourceName()
local CurrentVersion = GetResourceMetadata(ResourceName,"version",0)
local CheckVersion = "https://raw.githubusercontent.com/OiSouHen/Versions/refs/heads/main/Origens.txt?v=1"
-----------------------------------------------------------------------------------------------------------------------------------------
-- VERSIONTOTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function VersionToTable(Version)
	local t = {}
	for num in Version:gmatch("%d+") do
		table.insert(t, tonumber(num))
	end

	return t
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ISOUTDATED
-----------------------------------------------------------------------------------------------------------------------------------------
local function IsOutdated(Current,Latest)
	local c = VersionToTable(Current)
	local l = VersionToTable(Latest)

	for i = 1, math.max(#c, #l) do
		local cv = c[i] or 0
		local lv = l[i] or 0

		if cv < lv then return true end
		if cv > lv then return false end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERFORMHTTPREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
PerformHttpRequest(CheckVersion, function(err,text,headers)
	if err ~= 200 then
		print("^1[HENSA VRP]^0 Erro ao verificar versão.")
		return
	end

	local LatestVersion = text:gsub("%s+", "")
	local Status = "^2Atualizado^0"

	if not CurrentVersion then
		print("^1[HENSA VRP]^0 Versão não definida no fxmanifest!")
		return
	end

	if IsOutdated(CurrentVersion,LatestVersion) then
		Status = "^1Desatualizado^0"
	end

	local Message = string.format("^3[HENSA VRP]^0 Status: %s | Atual: %s | Última: %s",Status,CurrentVersion,LatestVersion)
	print(Message)
end)