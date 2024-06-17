addEventHandler('onClientResourceStart', resourceRoot, function()
    CheckScreenShot()
    setOcclusionsEnabled(false)
end)

CheckScreenShot = function()
    if (not dxGetStatus()['AllowScreenUpload']) then
        triggerServerEvent('rust:customKick', localPlayer, 'You should allow screen upload (game settings - multiplayer tab)')
    else
        setTimer(CheckScreenShot, 500, 1)
    end
end

addEventHandler('onClientRender', root, function()
    dxDrawText(getPlayerSerial():sub(1, 10), 6, 4, 0, 0, tocolor(0, 0, 0), 1, 'default-bold', 'left', 'top', false, false, true)
    dxDrawText(getPlayerSerial():sub(1, 10), 5, 3, 0, 0, tocolor(255, 255, 255), 1, 'default-bold', 'left', 'top', false, false, true)
end)

local MapBounds = {
    x = {
        max = 4000,
        min = -4000,
    },
    y = {
        max = 4000,
        min = -4000,
    }
}

local lastSafePosition = {getElementPosition(localPlayer)}
local lastSafeTick = 0

KeepPlayerInBounds = function()
    if ((getTickCount() - lastSafeTick) <= 200) then
        return false
    end
    
    if getElementData(localPlayer, 'staffRole') then
        return false
    end
    
    local x, y = getElementPosition(localPlayer)
    
    if (x < MapBounds.x.min) or (x > MapBounds.x.max) or (y < MapBounds.y.min) or (y > MapBounds.y.max) then
        local elem = localPlayer
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh and (getVehicleOccupant(veh) == localPlayer) then
            elem = veh
        end
        setElementPosition(elem, unpack(lastSafePosition))
    end
    
    lastSafeTick = getTickCount()
    lastSafePosition = {getElementPosition(localPlayer)}
end
addEventHandler('onClientRender', root, KeepPlayerInBounds)

addCommandHandler('inventory', function()
    local current_state = exports['gamemode']:isShowingInventory()
    exports['gamemode']:toggleInventory(not current_state)
end)

addEventHandler('onClientKey', root, function(key)
    local keys_forwards = getBoundKeys('forwards')
    local keys_backwards = getBoundKeys('backwards')

    if (not keys_forwards[key]) and (not keys_backwards[key]) then
        return false
    end

    if (not getPedControlState(localPlayer, 'sprint')) then
        return false
    end

    if (not getPedControlState(localPlayer, 'jump')) then
        return false
    end

    cancelEvent()

    setPedControlState(localPlayer, 'jump', false)
    setPedControlState(localPlayer, 'sprint', false)

    return true
end)