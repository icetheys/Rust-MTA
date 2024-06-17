loadEvent('runResearchTable', root, function(ob)
    local order = getElementData(ob, 'invOrder')
    if order then
        local itemName = order[1] and order[1].itemName
        local quantity = order[1] and order[1].quantity
        local price = getPlayerDataSetting(itemName, 'researchTableNeeds')
        if price then
            local needed = price * quantity
            local onSlotQuantity = order[2] and order[2].quantity
            local onSlotItemName = order[2] and order[2].itemName
            if onSlotItemName == 'Scrap Metal' then
                if onSlotQuantity >= needed then
                    
                    setPreference(ob, 2, onSlotItemName, needed)
                    setElementData(ob, onSlotItemName, (getElementData(ob, onSlotItemName) or 0) - needed)
                    
                    setPreference(ob, 1, itemName, quantity)
                    setElementData(ob, itemName, (getElementData(ob, itemName) or 0) - quantity)

                    local receiveName = ('%s:BLUEPRINT'):format(itemName)
                    setPreference(ob, 1, receiveName, 1)
                    setElementData(ob, receiveName, (getElementData(ob, receiveName) or 0) + 1)
                    
                end
            end
        end
    end
    removeElementData(source, 'WaitingResponse')
end)
