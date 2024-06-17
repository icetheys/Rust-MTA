addEvent('onPlayerFaint', true)
addEvent('onSavePlayer', true)

--[[
    todo:
    remover keybar e nao deixar usar os itens
]]

Faint = {}
Saving = {}

toggleFaint = function(state)
    if state then
        if Faint[source] then
            return
        end

        Faint[source] = {
            BeingSaved = false,
        }

        setPedAnimation(source, 'sweet', 'sweet_injuredloop', -1, true, false, false, false)
        setElementData(source, 'desmaiado', true)
    else
        if not Faint[source] then
            return
        end
        removeElementData(source, 'desmaiado')
        setPedAnimation(source)
        Faint[source] = nil
    end
    triggerClientEvent(source, 'onClientPlayerFaint', source, state)
end
addEventHandler('onPlayerFaint', root, toggleFaint)

savePlayer = function(player, state, slotID)
    if (not Faint[player]) then
        return
    end

    if state then
        if Faint[player].BeingSaved then
            return
        end

        local order = getElementData(source, 'keybarOrder')
        if (not order) or (not order[slotID]) or (order[slotID].itemName ~= 'Bandage') then
            local NOTIFICATIONS = exports['stoneage_notifications']
            local TRANSLATION = exports['stoneage_translations']
            local str = TRANSLATION:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATION:translate(source, 'Bandage', 'name'))
            return NOTIFICATIONS:CreateNotification(source, str, 'error')
        end

        order[slotID].quantity = order[slotID].quantity - 1
        if order[slotID].quantity <= 0 then
            exports['gamemode']:onPlayerDisequipItem(slotID, source)
            order[slotID] = nil
        end
        setElementData(source, 'keybarOrder', order)

        setPedAnimation(source, 'bomber', 'bom_plant', -1, false, false, false, false)

        setTimer(function(source)
            if isElement(source) then
                setPedAnimation(source)
            end
        end, 7500, 1, source)

        local x, y, z = getElementPosition(player)
        triggerEvent('rust:play3DSound', source, ':gamemode/files/sounds/bandage.ogg', {x, y, z})

        setElementData(player, 'bleeding', 0)

        Faint[player].BeingSaved = source

    else
        if not Faint[player].BeingSaved then
            return
        end

        Faint[player].BeingSaved = nil

    end
    triggerClientEvent(player, 'onClientPlayerGetsSaved', player, state, source)
end
addEventHandler('onSavePlayer', root, savePlayer)

addEventHandler('onPlayerQuit', root, function()
    if Faint[source] then
        Faint[source] = nil
    end
end)
