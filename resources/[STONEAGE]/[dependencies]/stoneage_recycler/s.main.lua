Recycler = {
    inUse = {},
}

local Init = function()
    for k, v in ipairs(RECYCLER_LOCATIONS) do
        local x, y, z, r = unpack(v)
        local ob = createObject(1918, x, y, z - 1, 0, 0, r or 0)

        setElementData(ob, 'obName', 'Recycler')
        setElementData(ob, 'maxSlots', 14)

        local dummy = createElement('recycler')
        setElementPosition(dummy, x, y, z)
    end
end
addEventHandler('onResourceStart', resourceRoot, Init)

addEvent('runRecycler', true)
addEventHandler('runRecycler', root, function(ob)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    if isElement(ob) and not Recycler.inUse[ob] then

        local order = getElementData(ob, 'invOrder')
        if order and type(order) == 'table' then
            local items = {}
            for i = 1, 7 do
                if order[i] then
                    local itemName = order[i].itemName
                    local quantity = order[i].quantity or 0
                    if quantity > 0 then
                        local receive = itemName and exports['gamemode']:getPlayerDataSetting(itemName, 'recycler')
                        if type(receive) == 'table' then
                            local receiveOnCraft = exports['gamemode']:getReceiveOnCraftQuant(itemName)
                            local percent = quantity / receiveOnCraft
                            for k, v in pairs(receive) do
                                items[v[1]] = (items[v[1]] or 0) + math.floor(v[2] * percent)
                            end
                            exports['gamemode']:setPreference(ob, i, itemName, quantity)
                            setElementData(ob, itemName, (getElementData(ob, itemName) or 0) - quantity)
                        end
                    end
                end
            end

            if table.size(items) > 0 then
                Recycler.inUse[ob] = true

                exports['stoneage_sound3D']:play3DSound(':stoneage_recycler/assets/sfx.mp3', {getElementPosition(ob)}, 2, 100)

                setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)

                setTimer(function(ob, items)
                    if isElement(ob) then
                        local order = getElementData(ob, 'invOrder')
                        if order and type(order) == 'table' then
                            local freeSlots = {}

                            for i = 8, 14 do
                                if not order[i] then
                                    table.insert(freeSlots, i)
                                end
                            end

                            for itemName, quantity in pairs(items) do
                                if (#freeSlots) > 0 then
                                    local slotID = freeSlots[1]
                                    table.remove(freeSlots, 1)

                                    exports['gamemode']:setPreference(ob, slotID, itemName, quantity)
                                    setElementData(ob, itemName, (getElementData(ob, itemName) or 0) + quantity)
                                else
                                    local x, y, z = getElementPosition(ob)

                                    local UTILS = exports['stoneage_utils']

                                    exports['stoneage_pickups']:createSack(x + UTILS:randomFloatNumber(-2, 2), y + UTILS:randomFloatNumber(-2, 2), z + 0.5, {{itemName, quantity}})
                                end
                            end
                        end
                    end
                    Recycler.inUse[ob] = nil
                end, 12000, 1, ob, items)
            end

            items = nil
        end
    end
    removeElementData(source, 'WaitingResponse')
end)

table.size = function(arr)
    local q = 0
    for k in pairs(arr) do
        q = q + 1
    end
    return q
end
