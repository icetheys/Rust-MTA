local fly = {}

fly.tick = getTickCount()

fly.timer = false
fly.toggle = true

fly.linesColision = {}

fly.getPositionFromElementOffset = function(element, offX, offY, offZ) 
    local m = getElementMatrix(element)

    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]

    return x, y, z;
end

fly.drawPlayerHitBox = function(index, element, startX, startY, startZ, endX, endY, endZ)

    local lineStartX, lineStartY, lineStartZ = fly.getPositionFromElementOffset(element, startX, startY, startZ)
    local lineEndX, lineEndY, lineEndZ = fly.getPositionFromElementOffset(element, endX, endY, endZ)

    fly.linesColision[index] = isLineOfSightClear(lineStartX, lineStartY, lineStartZ, lineEndX, lineEndY, lineEndZ, true, true, true, true, true, true)

    -- if (localPlayer:getSerial() == '2BE2249E891E52A1EB2A5E1446A99F41') then 
    --     dxDrawLine3D(lineStartX, lineStartY, lineStartZ, lineEndX, lineEndY, lineEndZ, (fly.linesColision[index] and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255)))
    -- end

    return fly.linesColision[index]
end

fly.isGround = function(results)
    for k, v in pairs(results) do 
        if (not v) then 
            return true 
        end
    end

    return false
end

fly.getHitBoxResults = function(element)
    local results = {fly.drawPlayerHitBox(1, element, - 0.45, 0.40, 1.25, - 0.45, 0.40, - 1.75), fly.drawPlayerHitBox(2, element, - 0.25, 0.07, 1.25, - 0.25, 0.07, - 1.75), fly.drawPlayerHitBox(3, element, - 0.45, - 0.45, 1.25, - 0.45, - 0.45, - 1.75), fly.drawPlayerHitBox(4, element, - 0.25, - 0.07, 1.25, - 0.25, - 0.07, - 1.75), fly.drawPlayerHitBox(5, element, 0.0, 0.0, 1.25, 0.0, 0.0, - 1.75), fly.drawPlayerHitBox(6, element, 0.45, 0.40, 1.25, 0.45, 0.40, - 1.75), fly.drawPlayerHitBox(7, element, 0.25, 0.07, 1.25, 0.25, 0.07, - 1.75), fly.drawPlayerHitBox(8, element, 0.45, - 0.45, 1.25, 0.45, - 0.45, - 1.75), fly.drawPlayerHitBox(9, element, 0.25, - 0.07, 1.25, 0.25, - 0.07, - 1.75)}

    return results
end

fly.getSpeed = function(theElement, unit)
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(theElement:getVelocity()) * mult).length
end

fly.isPedJumping = function(element)
    return (element:getTask('primary', 3) == 'TASK_COMPLEX_JUMP' and true or false)
end

fly.isPedLand = function(element)
    local task = element:getTask('primary', 1)

    if (task == 'TASK_COMPLEX_IN_AIR_AND_LAND') or (task == 'TASK_COMPLEX_STUCK_IN_AIR') then 
        return true 
    end

    return false
end

fly.isPedOnFoot = function(element)
    return (element:getTask('primary', 4) == 'TASK_SIMPLE_PLAYER_ON_FOOT' and true or false)
end

fly.isPedOnStill = function(element)
    return (getPedSimplestTask(element) == 'TASK_SIMPLE_STAND_STILL' and true or false)
end

fly.lowSpeed = function(element)
    return (fly.getSpeed() > 0 and true or false)
end

fly.isInWater = function(element)
    if (isElementInWater(element)) then
        return true
    end

    local x, y, z = getElementPosition(element)

    return testLineAgainstWater(x, y, z - 1, x, y, z + 1)
end

local toggleScreen = true
fly.takePlayerScreenshot = function(element, reason)
    if (not toggleScreen) then 
        return 
    end

    toggleScreen = false

    triggerServerEvent('EQJ1UJ3U1MDU1MD81J7J1EM1D', resourceRoot, reason, false, getPedSimplestTask(element))
end

addEventHandler('onClientRender', root, function()
    
    if (not getElementData(localPlayer, 'logedin')) then
        return
    end

    if getElementData(localPlayer, 'staffRole') then
        return
    end

    if getElementData(localPlayer, 'isDead') then 
        return 
    end

    if getElementData(localPlayer, 'editingObj') then 

        fly.toggle = false

        if isTimer(fly.timer) then
            killTimer(fly.timer)
        end

        fly.timer = Timer(function()
            fly.toggle = true
        end, 1000, 1)

        fly.tick = getTickCount()

        return 
    end

    if (fly.isPedOnStill(localPlayer)) then
        fly.toggle = false

        if isTimer(fly.timer) then
            killTimer(fly.timer)
        end

        fly.timer = Timer(function()
            fly.toggle = true
        end, 2000, 1)

        fly.tick = getTickCount()

        return 
    end

    if (not fly.toggle) then 

        fly.tick = getTickCount()

        return 
    end

    if fly.isGround(fly.getHitBoxResults(localPlayer)) then 

        fly.tick = getTickCount()

        return 
    end

    if fly.isPedJumping(localPlayer) then 

        fly.tick = getTickCount()

        return 
    end

    if fly.isPedLand(localPlayer) then 

        fly.tick = getTickCount()

        return 
    end

    if (not fly.isPedOnFoot(localPlayer)) then 

        fly.tick = getTickCount()

        return 
    end

    if (not fly.lowSpeed) then 
        
        fly.tick = getTickCount()
        
        return
    end

    if (fly.isInWater(localPlayer)) then 
        
        fly.tick = getTickCount()
        
        return
    end

    if (getTickCount() - fly.tick > 50) then 

        fly.takePlayerScreenshot(localPlayer, 'Fly')

    end
end)

addEventHandler('onClientPlayerSpawn', localPlayer, function()
    fly.toggle = false

    if isTimer(fly.timer) then
        resetTimer(fly.timer)
    end

    fly.timer = Timer(function()
        fly.toggle = true
    end, 1000, 1)
end)

local lastSprintPress = 0
local sprintCooldown = 400  -- Tempo em milissegundos

addEventHandler('onClientKey', root, function(key, state)
    local sprintKey = getBoundKeys('sprint')

    if (not sprintKey[key]) then 
        return 
    end

    if (not state) then 
        return 
    end

    if isElementInWater(localPlayer) then 
        return
    end

    local currentTime = getTickCount()

    if (currentTime - lastSprintPress < sprintCooldown) then 
        cancelEvent()
    else
        lastSprintPress = currentTime
    end
end)
