local localTrails = {}
local lastTrailPositions = {}
local lastStationaryTrailTime = {}
local activeEvents = {}
local activeScenarios = {}
local activeAnimations = {}
local activeWrithe = nil

local function GetParticleData(itemType, config)
    local preset = nil
    if config.preset then
        preset = Config.presets[config.preset]
        if not preset then
            if Config.Debug then
                print("^1[smells] Aviso: Preset '" .. tostring(config.preset) .. "' não encontrado para " .. itemType)
            end
            return nil
        end
    end

    local function isEmpty(value)
        return value == nil or value == ''
    end

    if not preset then
        if isEmpty(config.dict) then
            if Config.Debug then
                print("^1[smells] Erro: Nenhum preset especificado e dict ausente para " .. itemType)
            end
            return nil
        end
        if isEmpty(config.particle) then
            if Config.Debug then
                print("^1[smells] Erro: Nenhum preset especificado e particle ausente para " .. itemType)
            end
            return nil
        end
        if not config.color then
            if Config.Debug then
                print("^1[smells] Erro: Nenhum preset especificado e color ausente para " .. itemType)
            end
            return nil
        end
    end

    local function getValue(configVal, presetVal)
        if not isEmpty(configVal) then
            return configVal
        elseif preset and presetVal then
            return presetVal
        else
            return nil
        end
    end

    return {
        dict = getValue(config.dict, preset and preset.dict or nil),
        particle = getValue(config.particle, preset and preset.particle or nil),
        color = config.color or (preset and preset.color or nil),
        scale = config.scale or (preset and preset.scale or nil),
        ttl = config.ttl or (preset and preset.ttl or 5000),
        alpha = config.alpha ~= nil and config.alpha or (preset and preset.alpha or nil),
        offset = config.offset
    }
end

local function CreateTrailPoint(sourceId, itemType, coords, particleData)
    if not localTrails[sourceId] then
        localTrails[sourceId] = {}
    end

    if not localTrails[sourceId][itemType] then
        localTrails[sourceId][itemType] = {
            points = {}
        }
    end

    local timestamp = GetGameTimer()
    local trailPoint = {
        coords = coords,
        timestamp = timestamp,
        expiryTime = timestamp + particleData.ttl,
        particleData = particleData,
        particleHandle = nil,
        active = false
    }

    table.insert(localTrails[sourceId][itemType].points, trailPoint)
    return trailPoint
end

local function ShouldCreateTrailPoint(sourceId, itemType, currentCoords)
    local lastPos = lastTrailPositions[sourceId] and lastTrailPositions[sourceId][itemType]

    if not lastPos then
        return true
    end

    local dx = currentCoords.x - lastPos.x
    local dy = currentCoords.y - lastPos.y
    local dz = currentCoords.z - lastPos.z
    local distanceSq = dx*dx + dy*dy + dz*dz

    local config = Config.smelly_items[itemType]
        or Config.smelly_props[itemType]
        or Config.events[itemType]
        or Config.scenarios[itemType]
        or Config.animations[itemType]
        or (itemType == 'writhe' and Config.writhe or nil)

    local distanceThreshold = Config.global.trailUpdateDistance
    local distanceThresholdSq = distanceThreshold * distanceThreshold
    local stationaryThresholdSq = 4.0

    if distanceSq >= distanceThresholdSq then
        return true
    end

    if distanceSq < stationaryThresholdSq then
        local currentTime = GetGameTimer()
        local lastStationaryTime = lastStationaryTrailTime[sourceId] and lastStationaryTrailTime[sourceId][itemType]

        if not lastStationaryTime then
            if not lastStationaryTrailTime[sourceId] then
                lastStationaryTrailTime[sourceId] = {}
            end
            lastStationaryTrailTime[sourceId][itemType] = currentTime
            return true
        end

        if currentTime - lastStationaryTime >= 5000 then
            lastStationaryTrailTime[sourceId][itemType] = currentTime
            return true
        end
    end

    return false
end

local function UpdateLastPosition(sourceId, itemType, coords)
    if not lastTrailPositions[sourceId] then
        lastTrailPositions[sourceId] = {}
    end

    local lastPos = lastTrailPositions[sourceId][itemType]
    local distanceSq = math.huge
    if lastPos then
        local dx = coords.x - lastPos.x
        local dy = coords.y - lastPos.y
        local dz = coords.z - lastPos.z
        distanceSq = dx*dx + dy*dy + dz*dz
    end

    lastTrailPositions[sourceId][itemType] = coords

    if distanceSq > 4.0 then
        if lastStationaryTrailTime[sourceId] then
            lastStationaryTrailTime[sourceId][itemType] = nil
        end
    end
end

function AddItemTrail(itemType, coords)
    local config = Config.smelly_items[itemType]
    if not config then
        return
    end

    -- Prevent duplicate trails if an animation smell for this item is already active
    for animKey, _ in pairs(activeAnimations) do
        if string.find(animKey, itemType) then
            return
        end
    end

    local sourceId = GetPlayerServerId(PlayerId())

    if not ShouldCreateTrailPoint(sourceId, itemType, coords) then
        return
    end

    local particleData = GetParticleData(itemType, config)
    if not particleData then
        return
    end

    CreateTrailPoint(sourceId, itemType, coords, particleData)
    UpdateLastPosition(sourceId, itemType, coords)
end

function AddPropTrail(propModel, entity, coords)
    local config = Config.smelly_props[propModel]
    if not config then
        return
    end

    local velocity = GetEntityVelocity(entity)
    local speed = math.sqrt(velocity.x*velocity.x + velocity.y*velocity.y + velocity.z*velocity.z)
    local isMoving = speed > Config.global.motionThreshold

    if isMoving and not config.emitWhenMoving then
        return
    end
    if not isMoving and not config.emitWhenStationary then
        return
    end

    local sourceId = "prop_" .. tostring(GetEntityModel(entity)) .. "_" .. tostring(entity)

    if not ShouldCreateTrailPoint(sourceId, propModel, coords) then
        return
    end

    local particleData = GetParticleData(propModel, config)
    if not particleData then
        return
    end

    CreateTrailPoint(sourceId, propModel, coords, particleData)
    UpdateLastPosition(sourceId, propModel, coords)
end

function AddEventTrail(eventName, playerPed)
    local config = Config.events[eventName]
    if not config or not config.attachToPlayer then
        return
    end

    local coords = GetEntityCoords(playerPed)
    local sourceId = GetPlayerServerId(PlayerId())

    local particleData = GetParticleData(eventName, config)
    if not particleData then
        return
    end

    if not ShouldCreateTrailPoint(sourceId, eventName, coords) then
        return
    end

    CreateTrailPoint(sourceId, eventName, coords, particleData)
    UpdateLastPosition(sourceId, eventName, coords)
    
    local currentTime = GetGameTimer()
    activeEvents[eventName] = {
        expiryTime = currentTime + particleData.ttl,
        config = config,
        particleData = particleData,
        lastTrailTime = currentTime
    }
end

function AddScenarioTrail(scenarioName, playerPed)
    local config = Config.scenarios[scenarioName]
    if not config then
        return
    end

    local coords = GetEntityCoords(playerPed)
    local sourceId = GetPlayerServerId(PlayerId())

    local particleData = GetParticleData(scenarioName, config)
    if not particleData then
        return
    end

    if not ShouldCreateTrailPoint(sourceId, scenarioName, coords) then
        return
    end

    CreateTrailPoint(sourceId, scenarioName, coords, particleData)
    UpdateLastPosition(sourceId, scenarioName, coords)
    
    local currentTime = GetGameTimer()
    if not activeScenarios[scenarioName] then
        activeScenarios[scenarioName] = {
            expiryTime = currentTime + particleData.ttl,
            config = config,
            particleData = particleData,
            lastTrailTime = currentTime
        }
    else
        activeScenarios[scenarioName].expiryTime = currentTime + particleData.ttl
        activeScenarios[scenarioName].lastTrailTime = currentTime
    end
end

function RemoveActiveScenario(scenarioName)
    activeScenarios[scenarioName] = nil
end

function AddAnimationTrail(animationKey, playerPed, customTTL)
    local config = Config.animations[animationKey]
    if not config then
        return
    end

    local coords = GetEntityCoords(playerPed)
    local sourceId = GetPlayerServerId(PlayerId())

    local particleData = GetParticleData(animationKey, config)
    if not particleData then
        return
    end

    -- Use custom TTL if provided
    if customTTL then
        particleData.ttl = customTTL
    end

    local currentTime = GetGameTimer()
    local animationData = activeAnimations[animationKey]

    -- If already active, just update expiry time and only create point if interval passed
    if animationData then
        animationData.expiryTime = currentTime + particleData.ttl
        
        if currentTime - animationData.lastTrailTime >= Config.global.trailUpdateInterval then
            if ShouldCreateTrailPoint(sourceId, animationKey, coords) then
                CreateTrailPoint(sourceId, animationKey, coords, particleData)
                UpdateLastPosition(sourceId, animationKey, coords)
                animationData.lastTrailTime = currentTime
            end
        end
    else
        -- First time, create immediately
        if ShouldCreateTrailPoint(sourceId, animationKey, coords) then
            CreateTrailPoint(sourceId, animationKey, coords, particleData)
            UpdateLastPosition(sourceId, animationKey, coords)
        end
        
        activeAnimations[animationKey] = {
            expiryTime = currentTime + particleData.ttl,
            config = config,
            particleData = particleData,
            lastTrailTime = currentTime
        }
    end
end

function RemoveActiveAnimation(animationKey)
    activeAnimations[animationKey] = nil
end

function StopDrugSmell(type)
    local sourceId = GetPlayerServerId(PlayerId())
    if not type then
        -- Limpa apenas os cheiros de animações (itens)
        for animKey, _ in pairs(activeAnimations) do
            if localTrails[sourceId] and localTrails[sourceId][animKey] then
                localTrails[sourceId][animKey] = nil
            end
        end
        activeAnimations = {}
        return
    end

    local found = false
    for animKey, _ in pairs(activeAnimations) do
        if string.find(animKey, type) then
            activeAnimations[animKey] = nil
            if localTrails[sourceId] and localTrails[sourceId][animKey] then
                localTrails[sourceId][animKey] = nil
            end
            found = true
        end
    end
end

function AddWritheTrail(playerPed)
    local config = Config.writhe
    if not config or not config.enabled or not config.attachToPlayer then
        return
    end

    local coords = GetEntityCoords(playerPed)
    local sourceId = GetPlayerServerId(PlayerId())
    local itemType = 'writhe'

    local particleData = GetParticleData(itemType, config)
    if not particleData then
        return
    end

    if not ShouldCreateTrailPoint(sourceId, itemType, coords) then
        return
    end

    CreateTrailPoint(sourceId, itemType, coords, particleData)
    UpdateLastPosition(sourceId, itemType, coords)
    
    local currentTime = GetGameTimer()
    if not activeWrithe then
        activeWrithe = {
            expiryTime = currentTime + particleData.ttl,
            config = config,
            particleData = particleData,
            lastTrailTime = currentTime
        }
    else
        activeWrithe.expiryTime = currentTime + particleData.ttl
        activeWrithe.lastTrailTime = currentTime
    end
end

function RemoveActiveWrithe()
    activeWrithe = nil
end

function IsWritheActive()
    return activeWrithe ~= nil
end

function ClearAllTrails()
    localTrails = {}
    lastTrailPositions = {}
    lastStationaryTrailTime = {}
    activeEvents = {}
    activeScenarios = {}
    activeAnimations = {}
    activeWrithe = nil
end

function UpdateActiveEvents()
    local currentTime = GetGameTimer()
    local playerPed = PlayerPedId()
    local sourceId = GetPlayerServerId(PlayerId())
    local trailUpdateInterval = Config.global.trailUpdateInterval
    for eventName, eventData in pairs(activeEvents) do
        if currentTime >= eventData.expiryTime then
            activeEvents[eventName] = nil
        else
            if currentTime - eventData.lastTrailTime >= trailUpdateInterval then
                local coords = GetEntityCoords(playerPed)
                CreateTrailPoint(sourceId, eventName, coords, eventData.particleData)
                UpdateLastPosition(sourceId, eventName, coords)
                eventData.lastTrailTime = currentTime
            end
        end
    end
end

function UpdateActiveScenarios()
    local currentTime = GetGameTimer()
    local playerPed = PlayerPedId()
    local sourceId = GetPlayerServerId(PlayerId())
    local trailUpdateInterval = Config.global.trailUpdateInterval
    
    for scenarioName, scenarioData in pairs(activeScenarios) do
        if currentTime >= scenarioData.expiryTime then
            activeScenarios[scenarioName] = nil
        else
            if currentTime - scenarioData.lastTrailTime >= trailUpdateInterval then
                local coords = GetEntityCoords(playerPed)
                CreateTrailPoint(sourceId, scenarioName, coords, scenarioData.particleData)
                UpdateLastPosition(sourceId, scenarioName, coords)
                scenarioData.lastTrailTime = currentTime
            end
        end
    end
end

function UpdateActiveAnimations()
    local currentTime = GetGameTimer()
    local playerPed = PlayerPedId()
    local sourceId = GetPlayerServerId(PlayerId())
    local trailUpdateInterval = Config.global.trailUpdateInterval

    for animationKey, animationData in pairs(activeAnimations) do
        if currentTime >= animationData.expiryTime then
            activeAnimations[animationKey] = nil
        else
            if currentTime - animationData.lastTrailTime >= trailUpdateInterval then
                local coords = GetEntityCoords(playerPed)
                CreateTrailPoint(sourceId, animationKey, coords, animationData.particleData)
                UpdateLastPosition(sourceId, animationKey, coords)
                animationData.lastTrailTime = currentTime
            end
        end
    end
end

function UpdateActiveWrithe()
    if not activeWrithe then
        return
    end

    local currentTime = GetGameTimer()
    local playerPed = PlayerPedId()
    local sourceId = GetPlayerServerId(PlayerId())
    local trailUpdateInterval = Config.global.trailUpdateInterval

    if currentTime >= activeWrithe.expiryTime then
        activeWrithe = nil
    else
        if currentTime - activeWrithe.lastTrailTime >= trailUpdateInterval then
            local coords = GetEntityCoords(playerPed)
            CreateTrailPoint(sourceId, 'writhe', coords, activeWrithe.particleData)
            UpdateLastPosition(sourceId, 'writhe', coords)
            activeWrithe.lastTrailTime = currentTime
        end
    end
end

function GetActiveTrails()
    local activeTrails = {}
    local currentTime = GetGameTimer()

    for sourceId, sourceData in pairs(localTrails) do
        for itemType, itemData in pairs(sourceData) do
            local activePoints = {}

            for _, point in ipairs(itemData.points) do
                if currentTime < point.expiryTime then
                    table.insert(activePoints, {
                        coords = point.coords,
                        timestamp = point.timestamp,
                        particleData = point.particleData
                    })
                end
            end

            if #activePoints > 0 then
                if not activeTrails[sourceId] then
                    activeTrails[sourceId] = {}
                end
                activeTrails[sourceId][itemType] = activePoints
            end
        end
    end
    return activeTrails
end

function CleanupExpiredTrails()
    local currentTime = GetGameTimer()
    local cleaned = false

    for sourceId, sourceData in pairs(localTrails) do
        for itemType, itemData in pairs(sourceData) do
            local newPoints = {}

            for _, point in ipairs(itemData.points) do
                if currentTime < point.expiryTime then
                    table.insert(newPoints, point)
                else
                    if point.particleHandle then
                        StopParticleFxLooped(point.particleHandle, false)
                        point.particleHandle = nil
                    end
                    cleaned = true
                end
            end

            itemData.points = newPoints

            if #newPoints == 0 then
                sourceData[itemType] = nil
            end
        end

        local hasData = false
        for _ in pairs(sourceData) do
            hasData = true
            break
        end
        if not hasData then
            localTrails[sourceId] = nil
        end
    end

    return cleaned
end

function GetLocalTrails()
    return localTrails
end

Citizen.CreateThread(function()
    local trailUpdateInterval = Config.global.trailUpdateInterval
    
    while true do
        UpdateActiveEvents()
        UpdateActiveScenarios()
        UpdateActiveAnimations()
        UpdateActiveWrithe()
        Citizen.Wait(trailUpdateInterval)
    end
end)

Citizen.CreateThread(function()
    local decayCheckInterval = Config.global.decayCheckInterval or 1000
    while true do
        CleanupExpiredTrails()
        Citizen.Wait(decayCheckInterval)
    end
end)

function AddCustomTrail(coords, particleData, options)
    options = options or {}
    local sourceId = options.sourceId or GetPlayerServerId(PlayerId())
    local itemType = options.itemType or 'custom_trail_' .. GetGameTimer()
    local checkDistance = options.checkDistance ~= false

    if checkDistance and not ShouldCreateTrailPoint(sourceId, itemType, coords) then
        return false
    end

    local finalParticleData = {
        dict = particleData.dict,
        particle = particleData.particle,
        color = particleData.color,
        scale = particleData.scale or 0.3,
        ttl = particleData.ttl or 5000,
        alpha = particleData.alpha,
        offset = particleData.offset
    }

    if not finalParticleData.dict or not finalParticleData.particle or not finalParticleData.color then
        if Config.Debug then
            print("^1[smells] Erro: Trail personalizado requer dict, particle e color")
        end
        return false
    end

    CreateTrailPoint(sourceId, itemType, coords, finalParticleData)

    if checkDistance then
        UpdateLastPosition(sourceId, itemType, coords)
    end

    return true
end

function AddCustomPropTrail(propEntity, particleData, options)
    options = options or {}
    local coords = GetEntityCoords(propEntity)

    local velocity = GetEntityVelocity(propEntity)
    local speed = math.sqrt(velocity.x*velocity.x + velocity.y*velocity.y + velocity.z*velocity.z)
    local isMoving = speed > (options.motionThreshold or Config.global.motionThreshold)

    if options.emitWhenMoving == false and isMoving then
        return false
    end
    if options.emitWhenStationary == false and not isMoving then
        return false
    end

    local sourceId = options.sourceId or ("prop_" .. tostring(GetEntityModel(propEntity)) .. "_" .. tostring(propEntity))
    local itemType = options.itemType or 'custom_prop_' .. GetGameTimer()

    return AddCustomTrail(coords, particleData, {
        sourceId = sourceId,
        itemType = itemType,
        checkDistance = options.checkDistance
    })
end

exports('AddItemTrail', AddItemTrail)
exports('AddPropTrail', AddPropTrail)
exports('AddEventTrail', AddEventTrail)
exports('AddScenarioTrail', AddScenarioTrail)
exports('RemoveActiveScenario', RemoveActiveScenario)
exports('AddAnimationTrail', AddAnimationTrail)
exports('RemoveActiveAnimation', RemoveActiveAnimation)
exports('AddWritheTrail', AddWritheTrail)
exports('AddCustomTrail', AddCustomTrail)
exports('AddCustomPropTrail', AddCustomPropTrail)
