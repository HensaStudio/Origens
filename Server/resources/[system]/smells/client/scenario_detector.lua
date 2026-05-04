Citizen.CreateThread(function ()
    while true do
        local player = PlayerPedId()
        
        if IsPedUsingAnyScenario(player) then
            for scenarioName, _ in pairs(Config.scenarios) do
                if IsPedUsingScenario(player, scenarioName) then
                    AddScenarioTrail(scenarioName, player)
                end
            end
        end

        Citizen.Wait(Config.global.trailUpdateInterval)
    end
end)