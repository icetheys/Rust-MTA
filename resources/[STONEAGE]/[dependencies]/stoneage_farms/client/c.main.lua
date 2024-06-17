function getPossibleFarms()
    return FarmConfigs.possibleFarmDrops
end

local damaged = {}
function damageFarm(ob, what)
    if isElement(ob) and not damaged[ob] then
        damaged[ob] = true

        triggerServerEvent('farm:onHitObject', localPlayer, ob, what)

        setTimer(function(ob)
            damaged[ob] = nil
        end, 500, 1, ob)
    end
end

addEventHandler('onClientObjectDamage', resourceRoot, function(loss, attacker)
    if attacker == localPlayer and getElementData(source, 'obName') == 'farmObject' then
        local equippedItem = getElementData(localPlayer, 'equippedItem')
        if equippedItem then
            if exports['gamemode']:isWeapon(equippedItem) then
                local itemType = exports['gamemode']:getItemType(equippedItem)
                if itemType == 'weapon-primary' or itemType == 'weapon-secondary' then
                    return
                end
            end
        end
        for k, v in ipairs(getPossibleFarms()) do
            if (getElementData(source, v) or 0) > 0 then
                damageFarm(source, v)
                break
            end
        end
    end
end)

local Init = function()
    local file = fileCreate('debugged.lua')
    fileWrite(file, 'farmSpawns = {\n')

    Async:setPriority(50, 100);
    Async:foreach(farmSpawns, function(v)
        local x, y, z = v[1], v[2], v[3]
        setElementPosition(localPlayer, x, y, z)
        if not testLineAgainstWater(x, y, z + 100, x, y, z) then
            fileWrite(file, ('    {%s, %s, %s},\n'):format(x, y, z))
        else
            print(x, y, z)
        end
    end)
    fileWrite(file, '}')
    fileClose(file)
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    for type, arr in pairs(farms) do
        for k, v in pairs(arr.variants) do
            engineSetModelLODDistance(v.model, 1000)
        end
    end
end)

addEventHandler('onClientElementStreamIn', resourceRoot, function()
    if (getElementType(source) == 'object') then
        setObjectBreakable(source, false)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    for k, v in pairs(farms) do
        for _, arr in pairs(v.variants) do
            removeWorldModel(arr.model, 3000, 0, 0, 0)
        end
    end
end)
