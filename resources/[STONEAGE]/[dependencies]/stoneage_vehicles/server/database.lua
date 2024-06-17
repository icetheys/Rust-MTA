AddVehicleToDatabase = function(vehicle)
    if isElement(vehicle) then
        local newID = getNewVehicleID()

        local x, y, z = getElementPosition(vehicle)
        local rx, ry, rz = getElementRotation(vehicle)
        local position = toJSON({x, y, z, rx, ry, rz})

        local fuel = getElementData(vehicle, 'fuel') or nil
        local engine = getElementData(vehicle, 'engine') or nil
        local tires = getElementData(vehicle, 'tires') or nil
        local parts = getElementData(vehicle, 'parts') or nil
        local battery = getElementData(vehicle, 'battery') or nil
        local order = toJSON(getElementData(vehicle, 'invOrder') or {})

        setElementData(vehicle, 'VehicleID', newID)

        SQL:Exec('INSERT INTO `Vehicles` VALUES(?,?,?,?,?,?,?,?,?,?)', newID, position, getElementModel(vehicle), fuel, engine, tires, parts, battery,
                 1000, order)
    end
end

getNewVehicleID = function()
    VehicleQuantity = VehicleQuantity + 1
    return VehicleQuantity
end

RemoveVehicleFromDatabase = function(vehicle)
    if isElement(vehicle) then
        local VehicleID = getElementData(vehicle, 'VehicleID')
        if VehicleID then
            SQL:Exec('DELETE FROM `Vehicles` WHERE `VehicleID`=?', VehicleID)
        end

        local model = getElementModel(vehicle)
        AvailableToSpawn[model] = AvailableToSpawn[model] + 1
        
        setTimer(SpawnNewRandomVehicle, exports['stoneage_settings']:getConfig('Tempo pra respawnar veiculos', 5) * 60000, 1)
    end
end

SaveVehicles = function()
    Async:setPriority('low')
    Async:foreach(getElementsByType('vehicle', resourceRoot), function(vehicle)
        if isElement(vehicle) then
            local VehicleID = getElementData(vehicle, 'VehicleID')
            if VehicleID then
                local x, y, z = getElementPosition(vehicle)
                local rx, ry, rz = getElementRotation(vehicle)
                local position = toJSON({x, y, z, rx, ry, rz})

                local fuel = getElementData(vehicle, 'fuel') or nil
                local engine = getElementData(vehicle, 'engine') or nil
                local tires = getElementData(vehicle, 'tires') or nil
                local parts = getElementData(vehicle, 'parts') or nil
                local battery = getElementData(vehicle, 'battery') or nil
                local order = toJSON(getElementData(vehicle, 'invOrder') or {})

                SQL:Exec(
                    'UPDATE `Vehicles` SET `Position`=?, `Fuel`=?, `Engine`=?, `Tires`=?, `Parts`=?, `Battery`=?, `Health`=?, `invOrder`=? WHERE `VehicleID`=?',
                    position, fuel, engine, tires, parts, battery, getElementHealth(vehicle), order, VehicleID)

                if isElementInWater(vehicle) and (getVehicleType(vehicle) ~= 'Boat') then
                    setTimer(function(veh)
                        if isElement(veh) then
                            destroyElement(veh)
                        end
                    end, 5000, 1, vehicle)
                end
            end
        end
    end, function()
        setTimer(SaveVehicles, 30000, 1)
    end)
end
