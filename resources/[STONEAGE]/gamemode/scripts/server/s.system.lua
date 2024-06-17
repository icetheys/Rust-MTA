loadEvent('rust:customKick', root, function(customMsg)
    kickPlayer(source, customMsg)
end)

loadEvent('rust:createGreandeLauncherExplosion', root, function(x, y, z)
    createExplosion(x, y, z, 12, source)
end)

-- //------------------- LEVEL UP SYSTEM -------------------\\--
addEventHandler('onElementDataChange', root, function(key, old, new)
    if getElementType(source) == 'player' and tonumber(new) and tonumber(old) then
        if key == 'Exp' then
            local level = getElementData(source, 'Level') or 0
            if (new > old) and (new >= getExpNeeded(level)) then
                setElementData(source, 'Exp', 0)
                setElementData(source, 'Level', level + 1)
                exports['stoneage_notifications']:CreateNotification(source, '+1 Level', 'info')
            end
        elseif key == 'Level' then
            if new >= 5 and new < 10 then
                setPedFightingStyle(source, 7)
            elseif new >= 10 and new < 15 then
                setPedFightingStyle(source, 5)
            elseif new >= 15 then
                setPedFightingStyle(source, 6)
            end
        end
    end
end)
-- //------------------- LEVEL UP SYSTEM -------------------\\--

-- //------------------- Fill bottle from menu -------------------\\--
loadEvent('rust:fillBottleFromMenu', root, function(slotID)
    if not isElement(source) then
        return
    end

    local order = getElementData(source, 'keybarOrder')
    if not order or not order[slotID] or order[slotID].itemName ~= 'Empty Bottle' then
        return
    end

    onPlayerDisequipItem(slotID, source)

    order[slotID].itemName = 'Water'
    setElementData(source, 'keybarOrder', order)

    triggerClientEvent(source, 'playerUseItem', source, 'Water', slotID)
end)
-- //------------------- Fill bottle from menu -------------------\\--

-- //------------------- LEARN BLUEPRINT -------------------\\--
loadEvent('rust:learnBlueprint', root, function(slotID, itemName)
    if not isElement(source) then
        return
    end

    local order = getElementData(source, 'keybarOrder')
    if not order or not order[slotID] or order[slotID].itemName ~= itemName then
        return
    end

    local alreadyLearned = getElementData(source, 'learnedBlueprint') or {}

    if alreadyLearned[itemName] then
        exports['stoneage_notifications']:CreateNotification(source, translate(source, 'já aprendeu blueprint'))
        return
    end

    alreadyLearned[itemName] = true
    setElementData(source, 'learnedBlueprint', alreadyLearned)

    local str = translate(source, 'acabou de aprender blueprint', nil, translate(source, itemName:gsub(':BLUEPRINT', ''), 'name'))
    exports['stoneage_notifications']:CreateNotification(source, str, 'info')

    order[slotID].quantity = order[slotID].quantity - 1
    onPlayerDisequipItem(slotID, source)

    if order[slotID].quantity <= 0 then
        order[slotID] = nil
    end

    setElementData(source, 'keybarOrder', order)
end)

loadEvent('rust:learnBlueprintFromInv', root, function(_, id)
    if not isElement(source) then
        return
    end

    local inventory = getElementData(source, 'invOrder') or {}

    local itemName = inventory[id] and inventory[id].itemName

    if (not itemName) then
        return false
    end

    if (getItemType(itemName) ~= 'blueprint') then
        return false
    end

    local alreadyLearned = getElementData(source, 'learnedBlueprint') or {}

    if alreadyLearned[itemName] then
        exports['stoneage_notifications']:CreateNotification(source, translate(source, 'já aprendeu blueprint'))
        return
    end

    alreadyLearned[itemName] = true
    setElementData(source, 'learnedBlueprint', alreadyLearned)

    setPreference(source, id, itemName, 1)
    setElementData(source, itemName, (getElementData(source, itemName) or 0) - 1)

    local str = translate(source, 'acabou de aprender blueprint', nil, translate(source, itemName:gsub(':BLUEPRINT', ''), 'name'))
    exports['stoneage_notifications']:CreateNotification(source, str, 'info')
end)
-- //------------------- LEARN BLUEPRINT -------------------\\--
