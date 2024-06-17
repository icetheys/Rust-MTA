local Spectate = {
    Target = false,
    AngleX = 0,
    AngleZ = 30,
    Offset = 9,
    FollowCamera = false,
    Spectator = nil,
}

ToggleSpectate = function(state, player)
    if state then
        if (not isElement(player)) then
            return
        end

        Spectate.Target = player

        bindKey('mouse_wheel_up', 'down', Spectate.MoveOffset, -1)
        bindKey('mouse_wheel_down', 'down', Spectate.MoveOffset, 1)
        bindKey('enter', 'down', Spectate.Cancel)
        bindKey('v', 'down', Spectate.ToggleFollowCamera)

        addEventHandler('onClientCursorMove', root, Spectate.CursorMove)
        addEventHandler('onClientPreRender', root, Spectate.Update)
        addEventHandler('onClientPlayerQuit', root, Spectate.OnQuit)

        NOTIFICATION:CreateNotification('Pressione "Enter" a qualquer momento caso queira parar de spectar', 'info')
    else

        unbindKey('mouse_wheel_up', 'down', Spectate.MoveOffset, -1)
        unbindKey('mouse_wheel_down', 'down', Spectate.MoveOffset, 1)
        unbindKey('enter', 'down', Spectate.Cancel)
        unbindKey('v', 'down', Spectate.ToggleFollowCamera)

        removeEventHandler('onClientCursorMove', root, Spectate.CursorMove)
        removeEventHandler('onClientPreRender', root, Spectate.Update)
        removeEventHandler('onClientPlayerQuit', root, Spectate.OnQuit)

        setCameraTarget(localPlayer)
        if Spectate.FollowCamera then
            Spectate.ToggleFollowCamera(false)
        end

        Spectate.Target = nil
    end

    setElementFrozen(localPlayer, state)
    toggleControl('fire', not state)
    toggleControl('aim_weapon', not state)
end

addEvent('Spec:ReceiveCameraPosition', true)
addEventHandler('Spec:ReceiveCameraPosition', root, function(cx, cy, cz, lx, ly, lz, roll, fov)
    Spectate.TargetCameraPosition = {cx, cy, cz, lx, ly, lz, roll, fov}
end)

addEvent('Spec:ToggleFollowingCamera', true)
addEventHandler('Spec:ToggleFollowingCamera', root, function(spectator)
    Spectate.Spectator = spectator
    if spectator then
        Spectate.Timer = setTimer(SendCameraInfo, 50, 1)
    end
end)

SendCameraInfo = function()
    if (not isElement(Spectate.Spectator)) then
        return
    end

    local cx, cy, cz, lx, ly, lz, roll, fov = getCameraMatrix()

    triggerServerEvent('Spec:SendCameraPosition', localPlayer, Spectate.Spectator, cx, cy, cz, lx, ly, lz, roll, fov)

    Spectate.Timer = setTimer(SendCameraInfo, 40, 1)
end

Spectate.ToggleFollowCamera = function()
    Spectate.FollowCamera = not Spectate.FollowCamera
    triggerServerEvent('Spec:ToggleFollowingCamera', localPlayer, Spectate.Target, Spectate.FollowCamera)
end

Spectate.Cancel = function()
    ToggleSpectate(false)
end
addEventHandler('onClientResourceStop', resourceRoot, Spectate.Cancel)

Spectate.CursorMove = function(_, _, x, y)
    if (not isCursorShowing()) then
        Spectate.AngleX = (Spectate.AngleX + (x - sW / 2) / 10) % 360
        Spectate.AngleZ = (Spectate.AngleZ + (y - sH / 2) / 10) % 360
        if (Spectate.AngleZ > 180) then
            if (Spectate.AngleZ < 315) then
                Spectate.AngleZ = 315
            end
        else
            if (Spectate.AngleZ > 45) then
                Spectate.AngleZ = 45
            end
        end
    end
end

Spectate.Update = function()
    if (not isElement(Spectate.Target)) then
        return
    end

    local x, y, z = getElementPosition(Spectate.Target)

    local ox, oy, oz
    ox = x - math.sin(math.rad(Spectate.AngleX)) * Spectate.Offset
    oy = y - math.cos(math.rad(Spectate.AngleX)) * Spectate.Offset
    oz = z + math.tan(math.rad(Spectate.AngleZ)) * Spectate.Offset

    if Spectate.FollowCamera then
        local aimx, aimy, aimz = Spectate.RenderAim(Spectate.Target)

        if aimx and aimy and aimz then
            local x1, y1, z1 = GetPositionFromOffset(Spectate.Target, 0.425, -2, 0.75)
            local x2, y2, z2 = GetPositionFromOffset(Spectate.Target, 0.425, 2, 0.75)
            setCameraMatrix(x1, y1, z1, x2, y2, z2)
        elseif Spectate.TargetCameraPosition then
            local x, y, z, lx, ly, lz, roll, fov = unpack(Spectate.TargetCameraPosition)
            setCameraMatrix(x, y, z, lx, ly, lz, roll, fov)
        else
            setCameraMatrix(ox, oy, oz, x, y, z)
        end
    else
        setCameraMatrix(ox, oy, oz, x, y, z)
    end

    local str = ('Você está espectando o jogador %s.\nPressione "Enter" a qualquer momento para cancelar.\nPressione "v" para seguir a camera do jogador.'):format(getPlayerName(Spectate.Target))

    dxDrawText(str, 0, 0, sW, sH * 0.8, white, 1, 'default-bold', 'center', 'bottom')
end

Spectate.RenderAim = function(player)
    local endx, endy, endz

    if (not getPedControlState(player, 'aim_weapon')) then
        return
    end

    endx, endy, endz = getPedTargetCollision(player)

    if (not endx) then
        endx, endy, endz = getPedTargetEnd(player)
    end

    if (not endx) or (not endy) or (not endz) then
        return
    end

    local sx, sy = getScreenFromWorldPosition(endx, endy, endz)

    if (not sx) then
        return
    end

    dxDrawCircle(sx, sy, 5, 0, 360, tocolor(math.random(255), math.random(255), math.random(255), 255), tocolor(0, 0, 0, 0))

    return endx, endy, endz
end

Spectate.MoveOffset = function(key, state, add)
    if (not isCursorShowing()) then
        if getKeyState('lshift') then
            add = add * 2
        elseif getKeyState('lctrl') then
            add = add / 2
        end
        Spectate.Offset = math.max(0, math.min(70, Spectate.Offset + add))
    end
end

Spectate.OnQuit = function()
    if (source == Spectate.Target) then
        local str = ('O jogador no qual você estava spectando "%s" acabou de desconectar.'):format(getPlayerName(source))
        NOTIFICATION:CreateNotification(str, 'error')
        ToggleSpectate(false)
    end
end

function getPointFromDistanceRotation(x, y, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a)
    local dy = math.sin(a)
    return x + dx, y + dy;
end

GetPositionFromOffset = function(element, x, y, z)
    local matrix = getElementMatrix(element)
    local offX = x * matrix[1][1] + y * matrix[2][1] + z * matrix[3][1] + matrix[4][1]
    local offY = x * matrix[1][2] + y * matrix[2][2] + z * matrix[3][2] + matrix[4][2]
    local offZ = x * matrix[1][3] + y * matrix[2][3] + z * matrix[3][3] + matrix[4][3]
    return offX, offY, offZ
end
