addEvent('EnterVehicle:WarpPedToVehicle', true)
addEventHandler('EnterVehicle:WarpPedToVehicle', root, function(vehicle, seat, x, y, z)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    if (not isElement(client)) or (not isElement(vehicle)) then
        return false
    end

    local occupant = getVehicleOccupant(vehicle, seat)

    if occupant then
        removePedFromVehicle(occupant)
        setElementPosition(occupant, x, y, z)
    end

    warpPedIntoVehicle(client, vehicle, seat)

end)

addEvent('EnterVehicle:RemovePedFromVehicle', true)
addEventHandler('EnterVehicle:RemovePedFromVehicle', root, function(x, y, z)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end

    if (not isElement(client)) then
        return false
    end

    removePedFromVehicle(client)
    setElementPosition(client, x, y, z)
end)

addEventHandler('onVehicleStartExit', root, function(player, seat)
    cancelEvent(true)
    triggerClientEvent(player, 'EnterVehicle:CheckLeaveVehicle', player, source, seat)
end)
