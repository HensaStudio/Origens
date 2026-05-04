local smellyPropModels = {}

for modelName, _ in pairs(Config.smelly_props) do
    smellyPropModels[modelName] = true
end

local DETECTION_DISTANCE = 10.0

local irrelevantPropsCache = {}
local CACHE_DURATION = 30000

Citizen.CreateThread(function()
    local trailUpdateInterval = Config.global.trailUpdateInterval

    while true do
        local currentTime = GetGameTimer()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local objects = GetGamePool('CObject')

        for _, entity in ipairs(objects) do
            if DoesEntityExist(entity) then
                local cachedExpiration = irrelevantPropsCache[entity]
                if cachedExpiration and cachedExpiration > currentTime then
                    goto continue
                end

                local modelName = GetEntityArchetypeName(entity)
                if modelName and smellyPropModels[modelName] then
                    local entityCoords = GetEntityCoords(entity)
                    local distance = #(playerCoords - entityCoords)

                    if distance < DETECTION_DISTANCE then
                        AddPropTrail(modelName, entity, entityCoords)
                    end
                else
                    irrelevantPropsCache[entity] = currentTime + CACHE_DURATION
                end
            end

            ::continue::
        end

        for entity, expirationTime in pairs(irrelevantPropsCache) do
            if expirationTime <= currentTime or not DoesEntityExist(entity) then
                irrelevantPropsCache[entity] = nil
            end
        end

        Citizen.Wait(trailUpdateInterval)
    end
end)
