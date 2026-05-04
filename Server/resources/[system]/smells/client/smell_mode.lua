local isSmellModeActive = false
local smellModeEndTime = 0
local lastSmellModeUse = 0
local baseAlphaValues = {}

local function GetActiveParticleHandles()
    return exports[GetCurrentResourceName()]:GetActiveParticleHandles()
end

local function GetBaseAlphaValue()
    return exports[GetCurrentResourceName()]:GetBaseAlphaValue() or 0.3
end

local function SetParticleAlpha(handle, alpha)
    if handle and handle ~= 0 then
        SetParticleFxLoopedAlpha(handle, alpha)
    end
end
local function ActivateSmellMode()
    local currentTime = GetGameTimer()
    isSmellModeActive = true
    smellModeEndTime = currentTime + Config.smellMode.duration
end

RegisterCommand(Config.smellMode.command, function()
    ActivateSmellMode()
end, false)

RegisterKeyMapping(Config.smellMode.command, 'Enables smell mode', 'keyboard', 'i')

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        local currentTime = GetGameTimer()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if isSmellModeActive then
            sleep = 400
            if currentTime >= smellModeEndTime then
                isSmellModeActive = false
                local activeHandles = GetActiveParticleHandles()
                if activeHandles then
                    for pointId, trailPoint in pairs(activeHandles) do
                        if trailPoint.particleHandle and baseAlphaValues[pointId] then
                            SetParticleAlpha(trailPoint.particleHandle, baseAlphaValues[pointId])
                        end
                    end
                end
                baseAlphaValues = {}
            else
                local activeHandles = GetActiveParticleHandles()
                if activeHandles then
                    local viewDistance = Config.global.viewDistance
                    local processedPointIds = {}
                    
                    for pointId, trailPoint in pairs(activeHandles) do
                        processedPointIds[pointId] = true
                        
                        if trailPoint.particleHandle and trailPoint.coords then
                            local distance = #(playerCoords - trailPoint.coords)
                            
                            if distance <= viewDistance then
                                if not baseAlphaValues[pointId] then
                                    baseAlphaValues[pointId] = GetBaseAlphaValue()
                                end
                                
                                local newAlpha = math.min(1.0, baseAlphaValues[pointId] + Config.smellMode.alphaIncrease)
                                SetParticleAlpha(trailPoint.particleHandle, newAlpha)
                            else
                                if baseAlphaValues[pointId] then
                                    SetParticleAlpha(trailPoint.particleHandle, baseAlphaValues[pointId])
                                end
                            end
                        end
                    end
                    
                    for pointId, _ in pairs(baseAlphaValues) do
                        if not processedPointIds[pointId] then
                            baseAlphaValues[pointId] = nil
                        end
                    end
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

local nearbySmellyProps = {}
local lastPropScanTime = 0
local PROP_SCAN_INTERVAL = 500

local smellyPropModels = {}
for modelName, _ in pairs(Config.smelly_props) do
    smellyPropModels[modelName] = true
end

local function UpdateNearbySmellyProps()
    local currentTime = GetGameTimer()

    if currentTime - lastPropScanTime < PROP_SCAN_INTERVAL then
        return
    end

    lastPropScanTime = currentTime
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local checkDistance = Config.global.viewDistance or 5.0
    local checkDistanceSq = checkDistance * checkDistance

    nearbySmellyProps = {}

    local objects = GetGamePool('CObject')

    for _, entity in ipairs(objects) do
        if DoesEntityExist(entity) then
            local entityCoords = GetEntityCoords(entity)
            local dx = entityCoords.x - playerCoords.x
            local dy = entityCoords.y - playerCoords.y
            local dz = entityCoords.z - playerCoords.z
            local distanceSq = dx*dx + dy*dy + dz*dz

            if distanceSq <= checkDistanceSq then
                local modelName = GetEntityArchetypeName(entity)

                if modelName and smellyPropModels[modelName] then
                    local config = Config.smelly_props[modelName]

                    nearbySmellyProps[entity] = {
                        modelName = modelName,
                        config = config,
                        coords = entityCoords,
                        text = config.label or modelName,
                        offset = config.offset or vec3(0, 0, 1)
                    }
                end
            end
        end
    end
end

Citizen.CreateThread(function()
    while true do
        if isSmellModeActive then
            UpdateNearbySmellyProps()
            Citizen.Wait(PROP_SCAN_INTERVAL)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isSmellModeActive then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local checkDistance = Config.global.viewDistance or 5.0

            local drawnLabels = {}

            for entity, propData in pairs(nearbySmellyProps) do
                if DoesEntityExist(entity) then
                    local distance = #(playerCoords - propData.coords)

                    if distance <= checkDistance and not drawnLabels[propData.text] then
                        drawnLabels[propData.text] = true
                        local textCoords = propData.coords + propData.offset + vec3(0,0, 1)
                        Draw3DText(textCoords.x, textCoords.y, textCoords.z, propData.text, 4, 0.05, 0.05)
                    end
                else
                    nearbySmellyProps[entity] = nil
                end
            end

            local activeHandles = GetActiveParticleHandles()
            if activeHandles and Config.animations then
                for pointId, trailPoint in pairs(activeHandles) do
                    if trailPoint.coords then
                        local _, itemType = string.match(pointId, "^(.-)_(.-)_%d+$")
                        if itemType then
                            if Config.animations[itemType] then
                                local animConfig = Config.animations[itemType]
                                local label = animConfig.label or animConfig.preset or itemType
                                local offset = animConfig.offset or vec3(0, 0, 0.7)

                                local distance = #(playerCoords - trailPoint.coords)
                                if distance <= checkDistance and not drawnLabels[label] then
                                    drawnLabels[label] = true
                                    local textCoords = trailPoint.coords + offset
                                    Draw3DText(textCoords.x, textCoords.y, textCoords.z, label, 4, 0.05, 0.05)
                                end
                            elseif itemType == 'writhe' and Config.writhe and Config.writhe.enabled then
                                local writheConfig = Config.writhe
                                local label = writheConfig.label or 'Blood smell'
                                local offset = writheConfig.offset or vec3(0, 0, 0.7)

                                local distance = #(playerCoords - trailPoint.coords)
                                if distance <= checkDistance and not drawnLabels[label] then
                                    drawnLabels[label] = true
                                    local textCoords = trailPoint.coords + offset
                                    Draw3DText(textCoords.x, textCoords.y, textCoords.z, label, 4, 0.05, 0.05)
                                end
                            end
                        end
                    end
                end
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

