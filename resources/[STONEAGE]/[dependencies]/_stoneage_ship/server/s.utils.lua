GetShipSpawnPosition = function(x, y, z)
    if (x and y and z) then
        local nearestIndex, nearestDist = 0, 9999999
        for k, v in pairs(SpawnsPositions) do
            local dist = getDistanceBetweenPoints3D(x, y, z, unpack(v))
            if (dist <= nearestDist) then
                nearestIndex = k
                nearestDist = dist
            end
        end
        return unpack(SpawnsPositions[nearestIndex])
    else
        return unpack(SpawnsPositions[math.random(#SpawnsPositions)])
    end
end

GetPositionFromElementOffset = function(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

FindRotation = function(x1, y1, x2, y2)
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end

FindRotation3D = function(x1, y1, z1, x2, y2, z2)
    local rotx = math.atan2(z2 - z1, getDistanceBetweenPoints2D(x2, y2, x1, y1))
    rotx = math.deg(rotx)
    local rotz = -math.deg(math.atan2(x2 - x1, y2 - y1))
    rotz = rotz < 0 and rotz + 360 or rotz
    return rotx, 0, rotz
end

AssignLOD = function(elem)
    if (not isElement(elem)) then
        return false
    end
    local x, y, z = getElementPosition(elem)
    local rx, ry, rz = getElementRotation(elem)
    local lod = createObject(getElementModel(elem), x, y, z, rx, ry, rz, true)
    setElementParent(lod, elem)
    setLowLODElement(elem, lod)
    attachElements(lod, elem)
    return lod
end

GenerateLootBox = function(id)
    local offX, offY, offZ = unpack(LootBoxesSpawns[id].Offsets)
    local x, y, z = GetPositionFromElementOffset(Ship.Element, offX, offY, offZ)
    local ob = createObject(2919, x, y, z)
    setElementFrozen(ob, true)
    setElementData(ob, 'obName', 'Airdrop')
    setElementData(ob, 'maxSlots', 21)

    attachElements(ob, Ship.Element, offX, offY, offZ)

    SetLoot(ob)

    Ship.LootBoxes[id] = ob
end

DestroyLootBox = function(id)
    if isElement(Ship.LootBoxes[id]) then
        destroyElement(Ship.LootBoxes[id])
    end
end

GenerateLootBoxes = function()
    DestroyLootBoxes()
    for k, v in pairs(LootBoxesSpawns) do
        if (math.random(100) <= v.Chance) then
            GenerateLootBox(k)
        end
    end
end

DestroyLootBoxes = function()
    for k, v in pairs(Ship.LootBoxes) do
        DestroyLootBox(k)
    end
    Ship.LootBoxes = {}
end

local possibleLoots = {{'M249', 3}, {'AK', 4}, {'AK Ammo:BLUEPRINT', 4}, {'AK:BLUEPRINT', 4}, {'LR-300', 4}, {'Bolt', 6}, {'Grenade Launcher', 8},
                       {'Grenade Launcher Ammo', 4}, {'Custom SMG', 15}, {'MP5', 10}, {'Thompson', 15}, {'Spas', 15},
                       {'C4', 1}, {'M39', 8}, {'L96', 3}, {'Camera', 15}, {'Revolver', 10}, {'Scrap Metal', 100}, {'Vest', 15}, {'Helmet', 15}, {'Radial', 15}}

SetLoot = function(ob)
    if isElement(ob) then
        for i, data in ipairs(possibleLoots) do
            local itemName, chance = data[1], data[2]
            if itemName and chance then
                if math.random(100) <= chance then

                    local quantity = exports['gamemode']:getItemMaxSpawnQuantity(itemName) or 0
                    if quantity > 1 then
                        quantity = math.random(quantity / 2, quantity)
                    end

                    setElementData(ob, itemName, (getElementData(ob, itemName) or 0) + quantity)

                    local ammo = exports['gamemode']:getPlayerDataSetting(itemName, 'ammo')
                    if ammo then
                        local quantity = math.random(ammo.magSize / 2, ammo.magSize)
                        setElementData(ob, ammo.name, (getElementData(ob, ammo.name) or 0) + quantity)
                    end

                    local ammo, quantity = exports['gamemode']:getPlayerDataSetting(itemName)
                    if ammo then
                        local quantity = math.random(quantity * 0.5, quantity * 1.5)
                        setElementData(ob, ammo, (getElementData(ob, ammo) or 0) + math.floor(quantity))
                    end

                end
            end
        end
    end
end
