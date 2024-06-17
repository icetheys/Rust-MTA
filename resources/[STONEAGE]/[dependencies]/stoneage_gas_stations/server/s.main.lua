-- //------------------- GAS STATIONS -------------------\\--
for k, v in ipairs({3465, 1686, 1676}) do
    removeWorldModel(v, 10000, 0, 0, 0)
end

local GasStations = {}

addEventHandler('onResourceStart', resourceRoot, function()
    Async:foreach(getGasStationPositions(), function(v, k)
        local x, y, z, rot = unpack(v)
        local ob = createObject(1686, x, y, z, 0, 0, rot)
        setElementData(ob, 'obName', 'gas_station')
        setElementData(ob, 'gasoline', math.random(50, 200))
        GasStations[ob] = true
    end)
    setTimer(RefuelGasStations, 18000000, 0)
end)

RefuelGasStations = function()
    for k in pairs(GasStations) do
        if isElement(k) then
            setElementData(k, 'gasoline', math.random(100, 200))
        end
    end
end

addEvent('rust:fillGallon', true)
addEventHandler('rust:fillGallon', root, function(ob, slotID)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    if not isElement(ob) then
        return
    end

    local fuel = getElementData(ob, 'gasoline') or 0
    if fuel <= 0 then
        return
    end

    local order = getElementData(source, 'keybarOrder')
    if (not order) or (not order[slotID]) or (order[slotID].itemName ~= 'Empty Gallon') then
        local NOTIFICATIONS = exports['stoneage_notifications']
        local TRANSLATION = exports['stoneage_translations']
        local str = TRANSLATION:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATION:translate(source, 'Empty Gallon', 'name'))
        return NOTIFICATIONS:CreateNotification(source, str, 'error')
    end

    local toTake = 20
    if fuel < toTake then
        toTake = fuel
    end

    setElementData(ob, 'gasoline', fuel - toTake)

    order[slotID].itemName = 'Gallon'

    exports['gamemode']:onPlayerDisequipItem(slotID, source)

    setElementData(source, 'keybarOrder', order)
    
    triggerClientEvent(source, 'playerUseItem', source, 'Gallon', slotID)

    setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)
end)
-- //------------------- GAS STATIONS -------------------\\--
