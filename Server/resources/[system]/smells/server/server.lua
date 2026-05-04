local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent('smells:updateTrails', function(trails)
    local src = source
    local playerPed = GetPlayerPed(src)
    
    if not playerPed or playerPed == 0 then
        return
    end
    
    local stateBag = Entity(playerPed).state
    local stateBagTrails = {}
    
    for sourceId, sourceData in pairs(trails) do
        for itemType, points in pairs(sourceData) do
            if not stateBagTrails[itemType] then
                stateBagTrails[itemType] = {}
            end
            
            for _, point in ipairs(points) do
                table.insert(stateBagTrails[itemType], {
                    coords = point.coords,
                    timestamp = point.timestamp,
                    particleData = point.particleData
                })
            end
        end
    end
    
    stateBag:set('smell_trails', stateBagTrails, true)
end)

AddEventHandler('playerDropped', function()
    local src = source
    local playerPed = GetPlayerPed(src)
    
    if playerPed and playerPed ~= 0 then
        local stateBag = Entity(playerPed).state
        stateBag:set('smell_trails', nil, true)
    end
end)

for _, playerId in ipairs(GetPlayers()) do
    local playerPed = GetPlayerPed(playerId)
    if playerPed and playerPed ~= 0 then
        local stateBag = Entity(playerPed).state
        stateBag:set('smell_trails', nil, true)
    end
end

Citizen.CreateThread(function()
    while true do
        for _, playerId in ipairs(GetPlayers()) do
            local Passport = vRP.Passport(playerId)
            if Passport then
                local smellyItems = {}
                for itemName, _ in pairs(Config.smelly_items) do
                    if vRP.ConsultItem(Passport, itemName, 1) then
                        smellyItems[itemName] = true
                    end
                end
                local playerPed = GetPlayerPed(playerId)
                if playerPed and playerPed ~= 0 then
                    Entity(playerPed).state:set('smelly_items', smellyItems, true)
                end
            end
        end
        Citizen.Wait(2000)
    end
end)

