addEvent('Spec:ToggleFollowingCamera', true)
addEventHandler('Spec:ToggleFollowingCamera', root, function(target, state)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    triggerClientEvent(target, 'Spec:ToggleFollowingCamera', target, state and client or nil)
end)

addEvent('Spec:SendCameraPosition', true)
addEventHandler('Spec:SendCameraPosition', root, function(spectator, cx, cy, cz, lx, ly, lz, roll, fov)
    if (client ~= source and source ~= resourceRoot) then
        exports['stoneage_ac']:KickForCallingUnauthorizedEvent(client, eventName)
        return
    end
    triggerClientEvent(spectator, 'Spec:ReceiveCameraPosition', spectator, cx, cy, cz, lx, ly, lz, roll, fov)
end)
