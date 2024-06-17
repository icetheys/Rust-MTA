local repairTimer = {}
addEvent('startRepairingVehicle', true)
addEventHandler('startRepairingVehicle', root, function(veh)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    if isElement(veh) then

        local NOTIFICATION = exports['stoneage_notifications']
        local TRANSLATIONS = exports['stoneage_translations']

        local equippedID = isElement(source) and getElementData(source, 'equippedSlotID')
        if (not equippedID) then
            local str = TRANSLATIONS:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATIONS:translate(source, 'Toolbox', 'name'))
            return NOTIFICATION:CreateNotification(source, str, 'error')
        end

        local order = getElementData(source, 'keybarOrder')
        if (not order) or (not order[equippedID]) or (order[equippedID].itemName ~= 'Toolbox') then
            local str = TRANSLATIONS:translate(source, 'Precisa ter %s em mãos', nil, TRANSLATIONS:translate(source, 'Toolbox', 'name'))
            return NOTIFICATION:CreateNotification(source, str, 'error')
        end

        if (not repairTimer[veh]) then
            toggleControl(source, 'enter_exit', false)
            setElementFrozen(veh, true)
            setElementData(veh, 'repairer', source, false)
            setElementData(source, 'repairingvehicle', veh)
            bindKey(source, 'space', 'down', manuallyStop)
            fixVeh(veh, source)
            repairTimer[veh] = setTimer(fixVeh, 1000, 0, veh, source)
        end
    end
end)

function fixVeh(veh, player)
    if isElement(veh) and isElement(player) then
        if getElementData(veh, 'repairer') then
            setElementHealth(veh, getElementHealth(veh) + 10)
            setPedAnimation(player, 'scratching', 'sclng_r', nil, false, false)
        end
        if (getElementHealth(veh) >= 1000) then
            fixVehicle(veh)
            onVehicleDataChange('tires', nil, getElementData(veh, 'tires') or 0, veh)
            stopRepair(player, veh)
        end
    end
end

function manuallyStop(player, key, state)
    stopRepair(player, getElementData(player, 'repairingvehicle'))
end

function stopRepair(player, veh)
    if isElement(player) then
        setPedAnimation(player, false)
        setElementData(player, 'repairingvehicle', nil)
        toggleControl(player, 'enter_exit', true)
        unbindKey(player, 'space', 'down', manuallyStop)
        -- triggerClientEvent(player, 'onClientPlayerStartRepairing', player, false)
    end
    if isElement(veh) then
        setElementFrozen(veh, false)
        setElementData(veh, 'repairer', nil, false)
    end
    if isTimer(repairTimer[veh]) then
        killTimer(repairTimer[veh])
    end
    repairTimer[veh] = nil
end

addEventHandler('onPlayerQuit', root, function()
    local veh = getElementData(source, 'repairingvehicle')
    if veh then
        stopRepair(source, veh)
    end
end)
