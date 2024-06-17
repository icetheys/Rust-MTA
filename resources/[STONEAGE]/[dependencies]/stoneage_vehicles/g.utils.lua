function randomizeTable(arr)
    local shuffled = {}
    for i, v in ipairs(arr) do
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, v)
    end
    return shuffled
end

function getRandomValueInTable(arr)
    arr = randomizeTable(arr)
    return #arr > 0 and arr[math.random(#arr)] or false
end

getVehicleSettingInfo = function(modelID)
    return vehicleConfigs[modelID]
end

getSpawnPosition = function(spawnType)
    if (not vehicleSpawns[spawnType]) then
        return false
    end

    local arr = randomizeTable(vehicleSpawns[spawnType])

    for k, v in ipairs(arr) do
        local x, y, z = unpack(v)
        if (#getElementsWithinRange(x, y, z, 50, 'vehicle') == 0) then
            return x, y, z
        end
    end

    return false
end

fixJSONTable = function(table)
    local temp = {}
    for k, v in pairs(table) do
        if tonumber(k) then
            temp[tonumber(k)] = v
        else
            temp[k] = v
        end
    end
    return temp
end
