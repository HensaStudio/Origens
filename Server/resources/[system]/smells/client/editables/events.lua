local delay = 2000
local accepting_events = true

local function SetTimeout()
    accepting_events = false
    local timeout = GetGameTimer() + delay
    Citizen.CreateThread(function ()
        while true do
            if GetGameTimer() > timeout then
                accepting_events = true
                return
            end
            Citizen.Wait(100)
        end    
    end)
end

AddEventHandler('gameEventTriggered', function (name, args)
    if Config.events[name] and accepting_events and tonumber(args[1]) == PlayerPedId() then
        local config = Config.events[name]
        if Config.Debug then
            print('evento registrado')
        end
        if config.attachToPlayer then
            SetTimeout()
            local playerPed = PlayerPedId()
            AddEventTrail(name, playerPed)
        end
    end
end)

RegisterNetEvent("smells:startJointSmell")
AddEventHandler("smells:startJointSmell", function()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        AddAnimationTrail("joint_smoking", playerPed)
    end
end)

RegisterNetEvent("smells:startDrugSmell")
AddEventHandler("smells:startDrugSmell", function(type, customTTL)
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        if type == "meth" then AddAnimationTrail("meth_inhaling", playerPed, customTTL)
        elseif type == "heroin" then AddAnimationTrail("heroin_taking", playerPed, customTTL)
        elseif type == "crack" then AddAnimationTrail("crack_smoking", playerPed, customTTL)
        elseif type == "cocaine" then AddAnimationTrail("cocaine_snorting", playerPed, customTTL)
        elseif type == "vape" then AddAnimationTrail("vape_using", playerPed, customTTL)
        elseif type == "cigarette" then AddAnimationTrail("cigarette_smoking", playerPed, customTTL)
        elseif type == "metadone" then AddAnimationTrail("metadone_taking", playerPed, customTTL)
        elseif type == "joint" or type == "weed" then AddAnimationTrail("joint_smoking", playerPed, customTTL)
        end
    end
end)

RegisterNetEvent("smells:stopDrugSmell")
AddEventHandler("smells:stopDrugSmell", function(type)
    StopDrugSmell(type)
end)

RegisterNetEvent("smells:startAlcoholSmell")
AddEventHandler("smells:startAlcoholSmell", function()
    local playerPed = PlayerPedId()
    if DoesEntityExist(playerPed) then
        AddAnimationTrail("drinking_alcohol", playerPed)
    end
end)