TIME_TO_ENTER = 500
TIME_TO_STEAL_SOMEONE_ELSE_CAR = 2000
MIN_SPEED_TO_LEAVE_VEHICLE = 50
MIN_DISTANCE_TO_ENTER = 3.5

local rendering = false
local startTick = 0
local targetSeat, targetVehicle, targetControl, targetAction, targetTime
local targetX, targetY, targetZ
local timer

ToggleAnimation = function(state)
    if (state == rendering) then
        return false
    end

    rendering = state

    if isTimer(timer) then
        killTimer(timer)
    end

    if rendering then
        startTick = getTickCount()
        timer = setTimer(PlayerCompleteAnimation, targetTime, 1)
    end

    _G[rendering and 'addEventHandler' or 'removeEventHandler']('onClientRender', root, RenderAnimation)

    setElementFrozen(localPlayer, rendering)

    return true
end

RenderAnimation = function()
    local found = false

    for key in pairs(getBoundKeys(targetControl)) do
        if getKeyState(key) then
            found = true
            break
        end
    end

    if (targetAction == 'leave') then
        for key in pairs(getBoundKeys('enter_passenger')) do
            if getKeyState(key) then
                found = true
                break
            end
        end
    end

    if (not found) or (not CheckIfCanProceedAnimation(targetVehicle)) then
        ToggleAnimation(false)
        return false
    end

    local x, y, z = getElementPosition(targetVehicle)

    local sx, sy = getScreenFromWorldPosition(x, y, z)

    if (not sx) or (not sy) then
        return false
    end

    local h = pixels(75)
    dxDrawRing(sx, sy, h, pixels(25), 90, 1, tocolor(255, 255, 255, 15))

    local percent = (getTickCount() - startTick) / targetTime
    dxDrawRing(sx, sy, h, pixels(25), 90, percent, tocolor(106, 127, 62, 200))

    return true
end

TryToEnterVehicle = function(vehicle, seat)
    if (not isElement(vehicle)) then
        return false
    end

    if (not getVehicleOccupant(vehicle) and (seat ~= 0)) then
        return false
    end

    targetSeat = seat
    targetVehicle = vehicle
    targetControl = (seat == 0) and 'enter_exit' or 'enter_passenger'
    targetAction = 'enter'

    if (getVehicleType(vehicle) == 'Bike') and (seat ~= 0) then
        targetSeat = 1
    end

    targetTime = TIME_TO_ENTER

    if getVehicleOccupant(targetVehicle) and (targetSeat == 0) then
        targetTime = TIME_TO_STEAL_SOMEONE_ELSE_CAR
    end

    if (not CheckIfCanProceedAnimation(vehicle)) then
        return false
    end

    ToggleAnimation(true)
end

TryToLeaveVehicle = function(vehicle, seat)
    if (not isElement(vehicle)) then
        return false
    end

    if (not CheckIfCanProceedAnimation(vehicle)) then
        return false
    end

    targetSeat = seat
    targetVehicle = vehicle
    targetControl = 'enter_exit'
    targetAction = 'leave'
    targetTime = TIME_TO_ENTER

    ToggleAnimation(true)
end

CheckIfCanProceedAnimation = function(vehicle)
    local x, y, z = getElementPosition(vehicle)
    local px, py, pz = getElementPosition(localPlayer)

    if (getDistanceBetweenPoints3D(x, y, z, px, py, pz) >= MIN_DISTANCE_TO_ENTER) then
        return false
    end

    if (targetAction == 'enter') then
        if (not isLineOfSightClear(x, y, z, px, py, pz, true, true, false, true, true, false, false, vehicle)) then
            return false
        end
    end

    local dist = 2.5
    local lines = 9

    local found = false

    for i = 1, lines do
        local xx, yy, zz = GetPointFromDistanceRotation(x, y, z, dist, 360 * (i / lines))
        -- dxDrawLine3D(xx, yy, zz, x,y,z)
        if isLineOfSightClear(x, y, z, xx, yy, zz, true, true, true, true, true, false, false, vehicle) then
            targetX, targetY, targetZ = xx, yy, zz
            found = true
            break
        end
    end

    if (not found) then
        return false
    end

    local speedx, speedy, speedz = getElementVelocity(vehicle)
    local actualspeed = (speedx ^ 2 + speedy ^ 2 + speedz ^ 2) ^ (0.5)
    if ((actualspeed * 180) > MIN_SPEED_TO_LEAVE_VEHICLE) then
        return false
    end

    return true
end

PlayerCompleteAnimation = function()
    if (not CheckIfCanProceedAnimation(targetVehicle)) then
        return false
    end

    if (targetAction == 'enter') then
        triggerServerEvent('EnterVehicle:WarpPedToVehicle', localPlayer, targetVehicle, targetSeat, targetX, targetY, targetZ)
    else
        triggerServerEvent('EnterVehicle:RemovePedFromVehicle', localPlayer, targetX, targetY, targetZ)
    end

    ToggleAnimation(false)
end

addEventHandler('onClientVehicleStartEnter', root, function(player, seat)
    if (player ~= localPlayer) then
        return false
    end

    cancelEvent()
    TryToEnterVehicle(source, seat)
end)

addEvent('EnterVehicle:CheckLeaveVehicle', true)
addEventHandler('EnterVehicle:CheckLeaveVehicle', localPlayer, function(vehicle, seat)
    TryToLeaveVehicle(vehicle, seat)
end)
