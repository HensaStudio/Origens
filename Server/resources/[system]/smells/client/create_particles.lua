local activeParticleHandles = {}

local function IsNighttime()
    local currentHour = GetClockHours()
    return currentHour >= Config.global.nighttimeStartHour or currentHour < Config.global.nighttimeEndHour
end

local function GetBaseAlpha()
    local baseAlpha = Config.global.baseAlpha
    if IsNighttime() then
        baseAlpha = math.min(1.0, baseAlpha + Config.global.nighttimeAlphaIncrease)
    end
    return baseAlpha
end

local function CreateTrailParticle(trailPoint)
    local particleData = trailPoint.particleData
    local baseCoords = trailPoint.coords

    local coords
    if particleData.offset then
        local ox = particleData.offset.x or 0.0
        local oy = particleData.offset.y or 0.0
        local oz = particleData.offset.z or 0.0
        coords = vec3(
            baseCoords.x + ox,
            baseCoords.y + oy,
            baseCoords.z + oz
        )
    else
        coords = baseCoords
    end
    
    RequestNamedPtfxAsset(particleData.dict)
    
    local waitCount = 0
    while not HasNamedPtfxAssetLoaded(particleData.dict) do
        Citizen.Wait(0)
        waitCount = waitCount + 1
        if waitCount > 50 then
            if Config.Debug then
                print('^1[smells] Falha ao carregar o dicionário de partículas: ' .. particleData.dict)
            end
            return nil
        end
    end
    
    UseParticleFxAssetNextCall(particleData.dict)
    
    local particleHandle = StartParticleFxLoopedAtCoord(
        particleData.particle,
        coords.x,
        coords.y,
        coords.z,
        0.0, 0.0, 0.0,
        particleData.scale,
        false, false, false,
        false
    )
    if not particleHandle or particleHandle == 0 then
        if Config.Debug then
            print('^1[smells] Falha ao criar partícula: ' .. particleData.particle .. ' do dict: ' .. particleData.dict)
        end
        return nil
    end
    
    if particleData.color then
        SetParticleFxLoopedColour(
            particleHandle,
            (particleData.color.r or 1.0) + 0.0,
            (particleData.color.g or 1.0) + 0.0,
            (particleData.color.b or 1.0) + 0.0,
            false
        )
    end

    local alpha
    if particleData.alpha ~= nil then
        alpha = particleData.alpha
        if IsNighttime() then
            alpha = math.min(1.0, alpha + Config.global.nighttimeAlphaIncrease)
        end
    else
        alpha = GetBaseAlpha()
    end
    
    SetParticleFxLoopedAlpha(particleHandle, alpha)
    RemoveNamedPtfxAsset(particleData.dict)

    return particleHandle
end

local function RenderLocalTrails()
    local localTrails = GetLocalTrails()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local px, py, pz = playerCoords.x, playerCoords.y, playerCoords.z
    local globalViewDistance = Config.global.viewDistance

    for sourceId, sourceData in pairs(localTrails) do
        for itemType, itemData in pairs(sourceData) do
            local config = Config.smelly_items[itemType] or Config.smelly_props[itemType] or Config.events[itemType]
            local viewDistance = (config and config.viewDistance) or globalViewDistance
            local viewDistanceSq = viewDistance * viewDistance

            for _, point in ipairs(itemData.points) do
                local dx = point.coords.x - px
                local dy = point.coords.y - py
                local dz = point.coords.z - pz
                local distanceSq = dx*dx + dy*dy + dz*dz

                local handleId = sourceId .. "_" .. itemType .. "_" .. point.timestamp

                if distanceSq > viewDistanceSq then
                    if point.particleHandle then
                        StopParticleFxLooped(point.particleHandle, false)
                        point.particleHandle = nil
                        point.active = false
                    end
                    activeParticleHandles[handleId] = nil
                else
                    if not point.particleHandle and not point.active then
                        point.particleHandle = CreateTrailParticle(point)
                        if point.particleHandle then
                            point.active = true
                            activeParticleHandles[handleId] = point
                        end
                    end
                end
            end
        end
    end
end

local function RenderStateBagTrails()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local players = GetActivePlayers()
    local localPlayerId = GetPlayerServerId(PlayerId())
    local globalViewDistance = Config.global.viewDistance

    for _, player in ipairs(players) do
        local playerId = GetPlayerServerId(player)
        if playerId ~= localPlayerId then
            local otherPlayerPed = GetPlayerPed(player)
            local playerStateBag = Entity(otherPlayerPed).state
            if playerStateBag.smell_trails then
                local trails = playerStateBag.smell_trails

                for itemType, points in pairs(trails) do
                    local config = Config.smelly_items[itemType] or Config.smelly_props[itemType] or Config.events[itemType]
                    local viewDistance = (config and config.viewDistance) or globalViewDistance
                    local viewDistanceSq = viewDistance * viewDistance

                    for _, pointData in ipairs(points) do
                        local coords = pointData.coords
                        local distance = #(playerCoords - coords)

                        local pointId = playerId .. "_" .. itemType .. "_" .. pointData.timestamp

                        if distance <= viewDistanceSq then
                            if not activeParticleHandles[pointId] then
                            local trailPoint = {
                                coords = vec3(coords.x, coords.y, coords.z),
                                particleData = pointData.particleData,
                                particleHandle = nil,
                                active = false,
                                timestamp = pointData.timestamp
                            }

                                local handle = CreateTrailParticle(trailPoint)
                                if handle then
                                    trailPoint.particleHandle = handle
                                    trailPoint.active = true
                                    activeParticleHandles[pointId] = trailPoint
                                end
                            end
                        else
                            if activeParticleHandles[pointId] then
                                local trailPoint = activeParticleHandles[pointId]
                                if trailPoint.particleHandle then
                                    StopParticleFxLooped(trailPoint.particleHandle, false)
                                end
                                activeParticleHandles[pointId] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end

local function CleanupLocalTrailParticles()
    local localTrails = GetLocalTrails()
    local validLocalIds = {}

    for sourceId, sourceData in pairs(localTrails) do
        for itemType, itemData in pairs(sourceData) do
            for _, point in ipairs(itemData.points) do
                local handleId = sourceId .. "_" .. itemType .. "_" .. point.timestamp
                validLocalIds[handleId] = true
            end
        end
    end

    for handleId, trailPoint in pairs(activeParticleHandles) do
        if not string.match(handleId, "^(%d+)_") and not validLocalIds[handleId] then
            if trailPoint.particleHandle then
                StopParticleFxLooped(trailPoint.particleHandle, false)
            end
            activeParticleHandles[handleId] = nil
        end
    end
end

local function CleanupStateBagParticles()
    local players = GetActivePlayers()
    local validPointIds = {}
    local localPlayerId = GetPlayerServerId(PlayerId())

    for _, player in ipairs(players) do
        local playerId = GetPlayerServerId(player)
        if playerId ~= localPlayerId then
            local playerPed = GetPlayerPed(player)
            local playerStateBag = Entity(playerPed).state

            if playerStateBag.smell_trails then
                local trails = playerStateBag.smell_trails
                for itemType, points in pairs(trails) do
                    for _, pointData in ipairs(points) do
                        local pointId = playerId .. "_" .. itemType .. "_" .. pointData.timestamp
                        validPointIds[pointId] = true
                    end
                end
            end
        end
    end

    for pointId, trailPoint in pairs(activeParticleHandles) do
        local match = string.match(pointId, "^(%d+)_")
        if match then
            local sourcePlayerId = tonumber(match)
            if sourcePlayerId and sourcePlayerId ~= localPlayerId then
                if not validPointIds[pointId] then
                    if trailPoint.particleHandle then
                        StopParticleFxLooped(trailPoint.particleHandle, false)
                    end
                    activeParticleHandles[pointId] = nil
                end
            end
        end
    end
end

function GetActiveParticleHandles()
    return activeParticleHandles
end

function GetBaseAlphaValue()
    return GetBaseAlpha()
end

exports('GetActiveParticleHandles', GetActiveParticleHandles)
exports('GetBaseAlphaValue', GetBaseAlphaValue)

Citizen.CreateThread(function()
    local lastNighttimeState = nil

    while true do
        local isNight = IsNighttime()

        if lastNighttimeState ~= nil and lastNighttimeState ~= isNight then
            for _, trailPoint in pairs(activeParticleHandles) do
                if trailPoint.particleHandle and trailPoint.particleData then
                    local alpha
                    if trailPoint.particleData.alpha ~= nil then
                        alpha = trailPoint.particleData.alpha
                        if isNight then
                            alpha = math.min(1.0, alpha + Config.global.nighttimeAlphaIncrease)
                        end
                    else
                        alpha = GetBaseAlpha()
                    end
                    SetParticleFxLoopedAlpha(trailPoint.particleHandle, alpha)
                end
            end
        end

        lastNighttimeState = isNight
        Citizen.Wait(2000)
    end
end)

Citizen.CreateThread(function()
    while true do
        RenderLocalTrails()
        RenderStateBagTrails()
        CleanupLocalTrailParticles()
        CleanupStateBagParticles()
        Citizen.Wait(500)
    end
end)