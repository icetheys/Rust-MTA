local settings = {
    offsetSlots = { -- slot offsets
        [1] = {0, 0, 0.5},
        [2] = {1.2, 0, 0.5},
        [3] = {-1.2, 0, 0.5},
    },
    plantSettings = {
        ['Seed Corn'] = {
            modelID = 2247,
            receive = 'Corn',
        },
        ['Seed Pumpkin'] = {
            modelID = 2250,
            receive = 'Pumpkin',
        },
        ['Seed Potato'] = {
            modelID = 2249,
            receive = 'Potato',
        },
    },
}

local plants = {}
local plantTimers = {}
local PLANT_MAX_SIZE = 2

-- //------------------- LOAD PLANTS FOR OBJECT -------------------\\--
function loadPlants(ob)
    if not isElement(ob) then
        return
    end

    local obName = getElementData(ob, 'obName')
    if obName ~= 'Planter' then
        return
    end

    local obPlants = getElementData(ob, 'planter:plants')

    if obPlants then
        for id, arr in pairs(obPlants) do
            local plant = createPlant(ob, id, arr.itemName, arr.progress)

            if plant then
                if not plants[ob] then
                    plants[ob] = {}
                end
                table.insert(plants[ob], id, plant)

                if arr.progress < 100 then
                    plantTimers[ob] = setTimer(function(ob, id)
                        updatePlantProgress(ob, id)
                    end, getGamePlayConfig('time to plants grow up'), (100 - arr.progress) / 10, ob, id)
                end
            end
        end
    end
end
-- //------------------- LOAD PLANTS FOR OBJECT -------------------\\--

-- //------------------- ON PLAYER PLANT -------------------\\--
loadEvent('planter:onPlayerPlant', root, function(ob, itemName)
    if not isElement(ob) or not isElement(source) then
        return
    end

    if (getElementData(source, 'equippedItem') ~= 'Shovel') then
        return exports['stoneage_notifications']:CreateNotification(source, translate(source, 'Precisa ter %s em mãos', nil, translate(source, 'Shovel', 'name')), 'error')
    end

    if (getElementData(source, itemName) or 0) <= 0 then
        return
    end

    local plantsHere = getElementData(ob, 'planter:plants')
    if not plantsHere then
        plantsHere = {}
    end

    local usedSlot = getFreeSlotForPlant(plantsHere)
    if usedSlot then

        local plant = createPlant(ob, usedSlot, itemName, 10)

        table.insert(plantsHere, usedSlot, {
            itemName = itemName,
            progress = 10,
        })

        if not plants[ob] then
            plants[ob] = {}
        end

        table.insert(plants[ob], usedSlot, plant)
        setElementData(ob, 'planter:plants', plantsHere)

        setTimer(function(ob, id)
            updatePlantProgress(ob, id)
        end, getGamePlayConfig('time to plants grow up'), 10, ob, usedSlot)

        setElementData(source, itemName, (getElementData(source, itemName) or 0) - 1)
        setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false, 250, true)

        addEventHandler('onElementDestroy', ob, function()
            if plantTimers[source] then
                if isTimer(plantTimers[source]) then
                    killTimer(plantTimers[source])
                end
                plantTimers[source] = nil
            end
            if plants[source] then
                plants[source] = nil
            end
        end)
    end
end)
-- //------------------- ON PLAYER PLANT -------------------\\--

-- //------------------- ON PLAYER PICK PLANT -------------------\\--
loadEvent('planter:onPlayerPickPlant', root, function(ob, plantName)
    if not isElement(ob) or not isElement(source) then
        return
    end
    local plantsHere = getElementData(ob, 'planter:plants')
    if not plantsHere then
        return
    end
    for k, v in pairs(plantsHere) do
        if v.itemName == plantName and v.progress == 100 then
            if plants[ob] and plants[ob][k] and isElement(plants[ob][k]) then
                destroyElement(plants[ob][k])

                local receive = getPlantSetting(v.itemName, 'receive')
                if receive then
                    setElementData(source, receive, (getElementData(source, receive) or 0) + 1)
                end

                plantsHere[k] = nil
                setElementData(ob, 'planter:plants', plantsHere)

                setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false, 250, true)
                break
            end
        end
    end
end)
-- //------------------- ON PLAYER PICK PLANT -------------------\\--

-- //------------------- UPDATE PROGRESS -------------------\\--
function updatePlantProgress(ob, slot)
    if isElement(ob) then
        local plantsHere = getElementData(ob, 'planter:plants')
        local arr = plantsHere and plantsHere[slot]
        if arr then
            if plants[ob] and isElement(plants[ob][slot]) then
                if arr.progress + 10 <= 100 then
                    plantsHere[slot].progress = arr.progress + 10
                    setObjectScale(plants[ob][slot], (plantsHere[slot].progress / 100) * PLANT_MAX_SIZE)
                    setElementData(ob, 'planter:plants', plantsHere)
                end
            end

            local foundIncomplete
            for k, v in pairs(getElementData(ob, 'planter:plants')) do
                if v.progress < 100 then
                    foundIncomplete = true
                    break
                end
            end

            if not foundIncomplete then
                if plantTimers[ob] then
                    if isTimer(plantTimers[ob]) then
                        killTimer(plantTimers[ob])
                    end
                    plantTimers[ob] = nil
                end
            end
        end
    else
        if sourceTimer and isTimer(sourceTimer) then
            killTimer(sourceTimer)
        end
    end
end
-- //------------------- UPDATE PROGRESS -------------------\\--

-- addCommandHandler('resetplants', function()
--     for k, v in pairs(plants) do
--         setElementData(k, 'planter:plants', nil)
--     end
-- end)

-- //------------------- CREATE PLANT -------------------\\--
function createPlant(ob, slot, plantName, progress)
    local modelID = getPlantSetting(plantName, 'modelID')
    local offx, offy, offz = getPlantOffsets(slot)
    if modelID and offx then
        local x, y, z = getElementPosition(ob)
        local plant = createObject(modelID, x + offx, y + offy, z + offz)

        attachElements(plant, ob, offx, offy, offz, 0, 0, math.random(360))
        setElementCollisionsEnabled(plant, false)
        setElementParent(plant, ob)

        local size = (progress / 100) * PLANT_MAX_SIZE

        setObjectScale(plant, size)
        return plant
    end
    return false
end
-- //------------------- CREATE PLANT -------------------\\--

-- //------------------- UTILS -------------------\\--
getFreeSlotForPlant = function(arr)
    for i = 1, 3 do
        if not arr[i] then
            return i
        end
    end
    return false
end

getPlantSetting = function(plantName, settingName)
    if settings.plantSettings[plantName] then
        return settings.plantSettings[plantName][settingName] or false
    end
    return false
end

getPlantOffsets = function(id)
    if settings.offsetSlots[id] then
        return unpack(settings.offsetSlots[id])
    end
    return false
end
-- //------------------- UTILS -------------------\\--
