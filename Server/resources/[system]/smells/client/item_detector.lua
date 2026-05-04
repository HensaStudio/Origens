local enabledItems = {}
for itemType, config in pairs(Config.smelly_items) do
    enabledItems[itemType] = true
end

Citizen.CreateThread(function()
    local trailUpdateInterval = Config.global.trailUpdateInterval

    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for itemType, _ in pairs(enabledItems) do
            if IsPlayerCarryingItem(itemType) then
                AddItemTrail(itemType, playerCoords)
            end
        end

        Citizen.Wait(trailUpdateInterval)
    end
end)

