Admin.Fly = {
    State = false,
    Controls = {'sprint', 'forwards', 'backwards', 'left', 'right', 'jump'},
    Actions = {},
    Speed = {
        Move = 3,
        SlowerMult = 0.1,
        FasterMult = 2,
    },
}

toggleFly = function(state)
    if state then
        if  (not getElementData(localPlayer, 'staffRole')) then
            return
        end

        if  (not hasEnoughPermission('fly', true)) then
            return
        end
        
        if Admin.Fly.State then
            return
        end

        addEventHandler('onClientPreRender', root, Admin.Fly.update)

        setElementData(localPlayer, 'Flying', true)
        
        setElementFrozen(localPlayer, true)
        
        for k, v in ipairs(Admin.Fly.Controls) do
            bindKey(v, 'both', Admin.Fly.toggleControlState)
        end
    else
        if not Admin.Fly.State then
            return
        end
        
        Admin.Fly.Actions = {}
        removeEventHandler('onClientPreRender', root, Admin.Fly.update)
        setElementData(localPlayer, 'Flying', false)

        setElementFrozen(localPlayer, false)

        for k, v in ipairs(Admin.Fly.Controls) do
            unbindKey(v, 'both', Admin.Fly.toggleControlState)
        end
    end
    triggerServerEvent('togglePlayerAlpha', localPlayer, state)
    Admin.Fly.State = state
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    toggleFly(false)
end)

Admin.Fly.toggleControlState = function(key, state)
    Admin.Fly.Actions[key] = state == 'down' and true or nil
end

Admin.Fly.update = function(delta)
    local px, py, pz = getElementPosition(localPlayer)

    local targetX, targetY, targetZ = px, py, pz

    local Speed = Admin.Fly.Speed.Move

    if Admin.Fly.Actions['sprint'] then
        Speed = Speed * Admin.Fly.Speed.FasterMult

    elseif Admin.Fly.Actions['jump'] then
        Speed = Speed * Admin.Fly.Speed.SlowerMult

    end

    local offx, offy, offz = 0, 0, 0

    if Admin.Fly.Actions['forwards'] then
        offy = offy + Speed
    end

    if Admin.Fly.Actions['backwards'] then
        offy = offy - Speed
    end

    if Admin.Fly.Actions['left'] then
        offx = offx - Speed
    end

    if Admin.Fly.Actions['right'] then
        offx = offx + Speed
    end

    targetX, targetY, targetZ = getPositionFromElementOffset(localPlayer, offx, offy, offz)
    setElementPosition(localPlayer, targetX, targetY, targetZ)

    local x, y, z = getWorldFromScreenPosition(sW / 2, sH / 2, 20)
    local rx, ry, rz = findRotation3D(targetX, targetY, targetZ, x, y, z)
    setElementRotation(localPlayer, -rx, -ry, -rz)
end

function getPositionFromElementOffset(element, offX, offY, offZ)
    local m = getElementMatrix(element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end

function findRotation3D(x1, y1, z1, x2, y2, z2)
    local rotx = math.atan2(z2 - z1, getDistanceBetweenPoints2D(x2, y2, x1, y1))
    rotx = math.deg(rotx)
    local rotz = -math.deg(math.atan2(x2 - x1, y2 - y1))
    rotz = rotz < 0 and rotz + 360 or rotz
    return rotx, 0, rotz
end
