Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        
        if Config.writhe and Config.writhe.enabled then
            if IsPedInWrithe(player) or IsPedRagdoll(player) then
                AddWritheTrail(player)
            else
                if IsWritheActive() then
                    RemoveActiveWrithe()
                end
            end
        end
        
        Citizen.Wait(Config.global.trailUpdateInterval)
    end
end)

