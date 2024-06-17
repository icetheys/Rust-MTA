local last_time_on_ground
local handled = false

addEventHandler('onClientPlayerSpawn', localPlayer, function()
    setTimer(function()
        last_time_on_ground = getTickCount()
    end, 5000, 1)
end)

addEventHandler('onClientRender', root, function()
    if (not getElementData(localPlayer, 'logedin')) then
        return false
    end

    if getElementData(localPlayer, 'staffRole') then
        return false
    end

    local allowed = {
        ['TASK_SIMPLE_IN_AIR'] = true,
        ['TASK_SIMPLE_LAND'] = true,
        ['TASK_SIMPLE_FALL'] = true,
        ['TASK_SIMPLE_GET_UP'] = true,
        ['TASK_SIMPLE_NAMED_ANIM'] = true,
        ['TASK_SIMPLE_CLIMB'] = true,
        ['TASK_SIMPLE_STAND_STILL'] = true,
    }

    if allowed[getPedSimplestTask(localPlayer)] then
        last_time_on_ground = getTickCount()
        return false
    end

    if isPedOnGround(localPlayer) then
        last_time_on_ground = getTickCount()
        return false
    end

    if (not last_time_on_ground) then
        return false
    end

    if ((getTickCount() - last_time_on_ground) < 3000) then
        return false
    end

    local x, y, z = getElementPosition(localPlayer)

    if (not isLineOfSightClear(x, y, z + 1, x, y, z - 5, true, true, false, true, true, false, false, localPlayer)) then
        last_time_on_ground = getTickCount()
        return false
    end

    if isElementInWater(localPlayer) or testLineAgainstWater(x, y, z + 1, x, y, z - 5) then
        last_time_on_ground = getTickCount()
        return false
    end

    if handled then
        return false
    end

    handled = true

    triggerServerEvent('addSelfBan', localPlayer, 'Anti-cheat (#1) [' .. getPedSimplestTask(localPlayer) .. ']')

    setTimer(function()
        handled = false
    end, 500, 1)

    -- local str = inspect({
    --     task = getPedSimplestTask(localPlayer),
    --     passed = getTickCount() - last_time_on_ground,
    -- })

    -- dxDrawText(str, 200, 500)
end)

addEventHandler("onClientRender", root, function()
    setPedAnimationSpeed(localPlayer, "sprint_civi", 1)
    setPedAnimationSpeed(localPlayer, "sprint_panic", 1)
    setPedAnimationSpeed(localPlayer, "sprint_wuzi", 1)
end, false, "low+5")