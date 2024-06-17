addEvent('saveOpenInventoryLogs', true)
addEventHandler('saveOpenInventoryLogs', root, function(ob)
    local owner = isElement(ob) and getElementData(ob, 'owner')
    local obName = isElement(ob) and getElementData(ob, 'obName')
    if owner and obName then
        local str = ('%s ("%s") acabou de abrir um(a) "%s" de "%s"')
        str = str:format(getPlayerName(source), getPlayerSerial(source), obName, owner)
        saveLog('inventory-open', str, true)
    end
end)

addEvent('saveTakeItemFromInventory', true)
addEventHandler('saveTakeItemFromInventory', root, function(ob, itemName, quantity)
    if itemName and quantity then
        local owner = isElement(ob) and getElementData(ob, 'owner')
        local obName = isElement(ob) and getElementData(ob, 'obName')
        if owner and obName then
            local x, y, z = getElementPosition(ob)
            local str =
                ('%s ("%s") acabou de pegar %s "%s" de um "%s" que pertence a "%s" (%s - %s [%.6f, %.6f, %.6f])')
            str = str:format(getPlayerName(source), getPlayerSerial(source), quantity, itemName, obName, owner,
                      getZoneName(x, y, z), getZoneName(x, y, z, true), x, y, z)
            saveLog('inventory-take', str, true)
        end
    end
end)
