SQL = exports['stoneage_sql']

AvailableToSpawn = {}
VehicleQuantity = 0

local Init = function()
    -- SQL:Exec('DROP TABLE `Vehicles`')
    
    SQL:Exec(
        'CREATE TABLE IF NOT EXISTS `Vehicles` (`VehicleID` INT, `Position` TEXT, `ModelID` INT, `Fuel` INT, `Engine` INT, `Tires` INT, `Parts` INT, `Battery` INT, `Health` INT, `invOrder` TEXT)')
    
    for k, v in pairs(vehicleConfigs) do
        AvailableToSpawn[k] = v.maxInServer
    end
    
    local Query = SQL:Query('SELECT `VehicleID` FROM `Vehicles` ORDER BY (SELECT CAST(`VehicleID` as integer)) DESC LIMIT 1')
    if Query[1] then
        VehicleQuantity = Query[1].VehicleID
    end
    
    local Query = SQL:Query('SELECT * FROM `Vehicles`')
    Async:foreach(Query, function(data, k)
        local position = fromJSON(data.Position)
        if position then
            local x, y, z, rx, ry, rz = unpack(position)
            local model = data.ModelID
            if model and vehicleConfigs[model] and (data.Health > 250) then
                local datas = {
                    engine = data.Engine,
                    fuel = data.Fuel,
                    tires = data.Tires,
                    battery = data.Battery,
                    health = data.Health,
                    invOrder = data.invOrder,
                    VehicleID = data.VehicleID,
                }
                SpawnVehicle(model, {x, y, z, rx, ry, rz}, true, datas)
            end
        end
    end, function()
        for model, quantity in pairs(AvailableToSpawn) do
            for i = 1, quantity do
                local settings = getVehicleSettingInfo(model)
                if settings then
                    local x, y, z = getSpawnPosition(settings.spawnType)
                    if (x and y and z) then
                        local settings = getVehicleSettingInfo(model)
                        SpawnVehicle(model, {x, y, z}, false, {
                            fuel = math.random(0, settings['maxFuel'] or 0),
                            engine = math.random(0, settings['maxEngine'] or 0),
                            tires = math.random(0, settings['maxTire'] or 0),
                            battery = math.random(0, settings['maxBattery'] or 0),
                        })
                    end
                end
            end
        end
        setTimer(SaveVehicles, 500, 1)
        setTimer(DecreaseFuel, 500, 1)
    end)
    for k, v in ipairs(getElementsByType('player')) do
        bindKey(v, 'k', 'down', setEngineStateByPlayer)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)

SpawnVehicle = function(model, position, fromDataBase, elementDatas)
    local x, y, z, rx, ry, rz = unpack(position)
    
    local veh = createVehicle(model, x, y, z, rx or 0, ry or 0, rz or math.random(360))
    
    AvailableToSpawn[model] = AvailableToSpawn[model] - 1
    
    local settings = getVehicleSettingInfo(model)
    setElementData(veh, 'maxSlots', (settings and settings.maxSlots) or 7)
    setElementData(veh, 'obName', getVehicleName(veh))
    
    addEventHandler('onElementDataChange', veh, onVehicleDataChange)

    if elementDatas then
        for k, v in pairs(elementDatas) do
            local json = fromJSON(v)
            if json then
                v = fixJSONTable(json)
            elseif (v == 'true') then
                v = true
            elseif (v == 'false') then
                v = false
            end
            if (k == 'health') then
                setElementHealth(veh, v)
            elseif (k == 'invOrder') then
                for k, v in pairs(v) do
                    setElementData(veh, v.itemName, (getElementData(veh, v.itemName) or 0) + v.quantity)
                end
            elseif (k == 'health' and v <= 0) then
                blowVehicle(veh)
            end
            setElementData(veh, k, v)
        end
    end
    
    if (not fromDataBase) then
        AddVehicleToDatabase(veh)
    end
    
    addEventHandler('onElementDestroy', veh, function()
        RemoveVehicleFromDatabase(source)
    end)

    return veh
end

onVehicleDataChange = function(key, old, new, veh)
    veh = veh or source
    if (key == 'tires') then
        if (getVehicleType(veh) == 'Automobile') then
            if (new == 0) then
                setVehicleWheelStates(veh, 2, 2, 2, 2)
            elseif (new == 1) then
                setVehicleWheelStates(veh, 0, 2, 2, 2)
            elseif (new == 2) then
                setVehicleWheelStates(veh, 0, 0, 2, 2)
            elseif (new == 3) then
                setVehicleWheelStates(veh, 0, 2, 0, 0)
            elseif (new >= 4) then
                setVehicleWheelStates(veh, 0, 0, 0, 0)
            end
        end
    elseif (key == 'engine') or (key == 'battery') then
        if ((new or 0) <= 0) then
            setVehicleEngineState(veh, false)
        end
    end
end

hasEnoughDataToWork = function(veh)
    local model = getElementModel(veh)
    local vehicleSettings = getVehicleSettingInfo(model)
    
    if vehicleSettings then
        local requiredDatas = {
            ['engine'] = vehicleSettings['maxEngine'],
            ['battery'] = vehicleSettings['maxBattery'],
            ['fuel'] = 1,
        }
        for k, v in pairs(requiredDatas) do
            if (getElementData(veh, k) or 0) < v then
                return false
            end
        end
    else
        return false
    end
    return true
end

setEngineStateByPlayer = function(p)
    local veh = getPedOccupiedVehicle(p)
    if veh then
        
        local x, y, z = getElementPosition(p)
        if not hasEnoughDataToWork(veh) then
            exports['stoneage_sound3D']:play3DSound(':stoneage_vehicles/assets/fail.mp3', {x, y, z})
            return
        end
        
        local state = getVehicleEngineState(veh)
        
        setVehicleEngineState(veh, not state)
        
        exports['stoneage_sound3D']:play3DSound((':stoneage_vehicles/assets/%s.mp3'):format(not state and 'ligando' or 'desligando'), {x, y, z})
    end
end

addEventHandler('onPlayerJoin', root, function()
    bindKey(source, 'k', 'down', setEngineStateByPlayer)
end)

addEventHandler('onVehicleExit', resourceRoot, function(player, seat)
    if seat == 0 then
        setVehicleEngineState(source, false)
        local x, y, z = getElementPosition(source)
        exports['stoneage_sound3D']:play3DSound(':stoneage_vehicles/assets/desligando.mp3', {x, y, z})
    end
end)

addEventHandler('onVehicleEnter', resourceRoot, function(player, seat)
    if seat == 0 then
        if hasEnoughDataToWork(source) then
            setVehicleEngineState(source, true)
            local x, y, z = getElementPosition(source)
            exports['stoneage_sound3D']:play3DSound(':stoneage_vehicles/assets/ligando.mp3', {x, y, z})
        else
            setVehicleEngineState(source, false)
        end
    end
end)

addEventHandler('onVehicleExplode', root, function()
    if getElementData(source, 'HeliDrop') then
        return false
    end
    setTimer(function(veh)
        if isElement(veh) then
            destroyElement(veh)
        end
    end, 5000, 1, source)
end)

addEvent('changeVehicleDatas', true)
addEventHandler('changeVehicleDatas', root, function(veh, slotID, dataName, quantity, itemName, itemToCheck)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    if not isElement(veh) then
        return
    end

    local order = getElementData(source, 'keybarOrder')
    if (not getElementData(source, 'staffRole')) and ((not order) or (not order[slotID]) or (itemToCheck and (order[slotID].itemName ~= itemToCheck))) then
        local NOTIFICATION = exports['stoneage_notifications']
        local TRANSLATIONS = exports['stoneage_translations']
        local str = TRANSLATIONS:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATIONS:translate(source, itemToCheck, 'name'))
        return NOTIFICATION:CreateNotification(source, str, 'error')
    end
    
    if (quantity > 0) then
        if (not getElementData(source, 'staffRole')) then
            if (dataName == 'fuel') then
                order[slotID].itemName = 'Empty Gallon'
                exports['gamemode']:onPlayerDisequipItem(slotID, source)
                triggerClientEvent(source, 'inv:disequipCurrentKeybarItem', source)
                setElementData(source, 'keybarOrder', order)
            else
                order[slotID].quantity = order[slotID].quantity - 1
                if (order[slotID].quantity <= 0) then
                    order[slotID] = nil
                    exports['gamemode']:onPlayerDisequipItem(slotID, source)
                    triggerClientEvent(source, 'inv:disequipCurrentKeybarItem', source)
                end
            end
        end
    else
        local quantity = math.abs(quantity)

        if (((getElementData(veh, dataName) or 0) - quantity) < 0) then
            return false
        end

        if itemName then
            local x, y, z = getElementPosition(source)
            exports['stoneage_pickups']:createSack(x + math.random(), y + math.random(), z, {{itemName, quantity}})
        end
    end
    
    setElementData(source, 'keybarOrder', order)
    
    setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)
    setElementData(veh, dataName, (getElementData(veh, dataName) or 0) + quantity)
end)

SpawnNewRandomVehicle = function()
    local indexedAvailable = {}
    for modelID, quantity in pairs(AvailableToSpawn) do
        if (quantity > 0) then
            table.insert(indexedAvailable, modelID)
        end
    end
    if (#indexedAvailable > 0) then
        local model = getRandomValueInTable(indexedAvailable)
        if model then
            local settings = getVehicleSettingInfo(model)
            if settings then
                local x, y, z = getSpawnPosition(settings.spawnType)
                if (x and y and z) then
                    SpawnVehicle(model, {x, y, z}, false, {
                        fuel = math.random(0, settings['maxFuel'] or 0),
                        engine = math.random(0, settings['maxEngine'] or 0),
                        tires = math.random(0, settings['maxTire'] or 0),
                        battery = math.random(0, settings['maxBattery'] or 0),
                    })
                end
            end
        end
    end
end

wipeVehicles = function()
    local oldTime = exports['stoneage_settings']:getConfig('Tempo pra respawnar veiculos', 5)
    exports['stoneage_settings']:setConfig('Tempo pra respawnar veiculos', 0.1)
    for k, v in ipairs(getElementsByType('vehicle')) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    exports['stoneage_settings']:setConfig('Tempo pra respawnar veiculos', oldTime)
end

DecreaseFuel = function()
    Async:foreach(getElementsByType('vehicle', resourceRoot), function(veh)
        if isElement(veh) and getVehicleEngineState(veh) then
            local fuel = getElementData(veh, 'fuel') or 0
            if (fuel > 0) then
                setElementData(veh, 'fuel', fuel - 0.25)
            end
            if (getElementData(veh, 'fuel') or 0) <= 0 then
                setVehicleEngineState(veh, false)
            end
        end
    end, function()
        setTimer(DecreaseFuel, 1800, 1)
    end)
end
