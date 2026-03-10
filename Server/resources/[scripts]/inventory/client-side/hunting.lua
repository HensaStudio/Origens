-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Model = nil
local Entity = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
local Animals = {
	"deer","boar","mtlion","coyote"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRATION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CheckRation()
	if not Entity or not DoesEntityExist(Entity) then
		return false
	end

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMALS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Animals()
	return Entity,Model
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNTINGAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.HuntingArea()
	local HUNTINGS = exports.hensa:GetHuntingAreas()
	local playerCoords = GetEntityCoords(PlayerPedId())

	for _, area in pairs(HUNTINGS) do
		if #(playerCoords - area.Coords) <= area.Radius then
			return true
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:RATION
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Ration")
AddEventHandler("inventory:Ration",function(Coords)
	local HUNTINGS = exports.hensa:GetHuntingAreas()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local currentArea = nil

    for _, area in pairs(HUNTINGS) do
        if #(playerCoords - area.Coords) <= area.Radius then
            currentArea = area
            break
        end
    end

    if not currentArea then
        return
    end

    local possibleAnimals = {}
    for _, animal in ipairs(currentArea.animals) do
        table.insert(possibleAnimals, animal)
    end

    local hour = GlobalState["Hours"] or 12
    if hour >= 20 or hour <= 6 then
        if currentArea.name == "Deserto" then
            table.insert(possibleAnimals, "coyote")
        elseif currentArea.name == "Montanha" then
            table.insert(possibleAnimals, "mtlion")
        end
    end

    if GlobalState["Weather"] == "RAIN" or GlobalState["Weather"] == "THUNDER" then
        if currentArea.name == "Floresta" then
            table.insert(possibleAnimals, "boar")
        end
    end

	local Cooldown = 0
	local FoundSafe = false
	local Ped = PlayerPedId()
	local SpawnPosition = nil
	local Coords = GetEntityCoords(Ped)

	repeat
		Cooldown = Cooldown + 1
		local x = Coords.x + math.random(-75,75)
		local y = Coords.y + math.random(-75,75)
		local z = Coords.z

		local Hitz,Groundz = GetGroundZFor_3dCoord(x,y,z,true)
		local SafeHitz,SafeCoords = GetSafeCoordForPed(x,y,Groundz,false,16)

		if Hitz and SafeHitz then
			FoundSafe = true
			SpawnPosition = SafeCoords
		end
	until FoundSafe or Cooldown >= 100

	if FoundSafe and SpawnPosition then
		Model = possibleAnimals[math.random(#possibleAnimals)]
		local Network = vRPS.CreateModels("a_c_"..Model,SpawnPosition.x,SpawnPosition.y,SpawnPosition.z,5)
		if not Network then return end

		Entity,AnimalNet = LoadNetwork(Network)
		while not DoesEntityExist(Entity) do
			Wait(100)
		end

		SetPedAlertness(Entity,3)
		SetPedPathAvoidFire(Entity,1)
		SetPedSeeingRange(Entity,250.0)
		SetPedHearingRange(Entity,250.0)
		DisablePedPainAudio(Entity,true)
		SetPedFleeAttributes(Entity,0,0)
		SetPedPathCanUseLadders(Entity,1)
		SetPedDiesWhenInjured(Entity,true)
		SetPedPathCanUseClimbovers(Entity,1)
		SetPedPathCanDropFromHeight(Entity,1)
		SetPedCombatAttributes(Entity,5,true)
		SetPedCombatAttributes(Entity,2,true)
		SetPedCombatAttributes(Entity,1,true)
		SetPedCombatAttributes(Entity,16,true)
		SetPedCombatAttributes(Entity,46,true)
		SetPedCombatAttributes(Entity,26,true)
		SetPedCombatAttributes(Entity,3,false)
		SetCanAttackFriendly(Entity,false,true)
		SetPedSuffersCriticalHits(Entity,false)
		SetPedEnableWeaponBlocking(Entity,true)
		SetPedDropsWeaponsWhenDead(Entity,false)
		DecorSetBool(Entity,"CREATIVE_PED",true)
		SetEntityAsMissionEntity(Entity,true,true)
		SetBlockingOfNonTemporaryEvents(Entity,true)

		TaskGoStraightToCoord(Entity,Coords.x,Coords.y,Coords.z,1.0,-1,0.0,0.0)

		local Blip = AddBlipForEntity(Entity)
		SetBlipSprite(Blip,141)
		SetBlipAsShortRange(Blip,true)

		if math.random(100) <= 25 then
			local protectorModels = { "s_m_y_mountaineer_01", "a_m_m_hillbilly_01" }
			local protectorWeapons = { "WEAPON_PUMPSHOTGUN", "WEAPON_MUSKET" }
			local protectorModel = protectorModels[math.random(#protectorModels)]
			local protectorWeapon = protectorWeapons[math.random(#protectorWeapons)]

			local spawnOffset = vec3(math.random(-15, 15), math.random(-15, 15), 0)
			local protectorSpawn = GetEntityCoords(Entity) + spawnOffset

			local Networked = vRPS.CreateModels(protectorModel, protectorSpawn.x, protectorSpawn.y, protectorSpawn.z)
			if Networked then
				local protectorPed = LoadNetwork(Networked)
				while not DoesEntityExist(protectorPed) do
					Wait(50)
				end

				SetPedArmour(protectorPed, 100)
				SetPedAccuracy(protectorPed, 70)
				SetPedMaxHealth(protectorPed, 300)
				SetEntityHealth(protectorPed, 300)

				SetPedCombatAttributes(protectorPed, 46, true)
				SetPedCombatAttributes(protectorPed, 5, true)

				SetPedFleeAttributes(protectorPed, 0, false)
				SetPedCombatRange(protectorPed, 2)
				SetPedCombatAbility(protectorPed, 2)
				SetPedCombatMovement(protectorPed, 1)
				SetPedSeeingRange(protectorPed, 100.0)
				SetPedHearingRange(protectorPed, 100.0)
				SetPedRelationshipGroupHash(protectorPed, GetHashKey("HATES_PLAYER"))

				GiveWeaponToPed(protectorPed, GetHashKey(protectorWeapon), 50, false, true)
				SetCurrentPedWeapon(protectorPed, GetHashKey(protectorWeapon), true)
				SetPedInfiniteAmmo(protectorPed, true, GetHashKey(protectorWeapon))

				TaskCombatPed(protectorPed, PlayerPedId(), 0, 16)

				TriggerEvent("Notify", "Aviso", "Um protetor dos animais flagrou você caçando.", "vermelho", 5000)
			end
		end
	end
end)