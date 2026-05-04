Citizen.CreateThread(function()
    local syncInterval = Config.global.syncInterval

    while true do
        local activeTrails = GetActiveTrails()

        if next(activeTrails) ~= nil then
            TriggerServerEvent('smells:updateTrails', activeTrails)
        end

        Citizen.Wait(syncInterval)
    end
end)

