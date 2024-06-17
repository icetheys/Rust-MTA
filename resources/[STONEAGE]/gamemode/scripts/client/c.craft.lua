local crafting = {
    state,
    ob,
    doing,
    obName,
    rotAxis = 'z',
    movingMode = 'cursor',
    savingTick,
    distanceArmario = 20,
}

local timeToSave = 500 -- how much m/s player should keep mouse1 pressed to save object (default: 3500)

function startCraftingObject(obName)
    if not isPedOnGround(localPlayer) and (not getPedContactElement(localPlayer)) then
        return
    end
    
    if getElementData(localPlayer, 'editingObj') then
        return
    end
    
    local model = getObModel(obName)
    toggleInventory(false)
    
    if model then
        local x, y, z = UTILS:getPositionFromElementOffset(localPlayer, 0, 3, -1)
        local sw, sh = getScreenFromWorldPosition(x, y, z)
        if sw then
            setCursorPosition(sw, sh)
        end
        
        local ob = createObject(model, x, y, z)
        setElementCollisionsEnabled(ob, false)
        
        if crafting.movingMode == 'cursor' then
            showCursor(true)
        end
        
        crafting.obName = obName
        crafting.ob = ob
        crafting.doing = 'crafting'
        showGridlines(ob)
        
        toggleHandlers(true)
        crafting.state = true
        
        setElementData(localPlayer, 'editingObj', true, false)
    end
    return false
end
addEvent('startCraftingObject', true)
addEventHandler('startCraftingObject', localPlayer, startCraftingObject)

function startMovingObject(ob)
    if isElement(ob) then
        
        if getElementData(localPlayer, 'editingObj') then
            return
        end
        
        local canChangeMethod = not getObjectDataSetting(obName, 'moveOnlyWithCursor')
        
        crafting.movingMode = canChangeMethod and 'cursor' or 'keyboard'
        crafting.ob = ob
        crafting.doing = 'moving'
        crafting.obName = getElementData(ob, 'obName')
        
        local x, y, z = getElementPosition(ob)
        local rx, ry, rz = getElementRotation(ob)
        
        crafting.initialObjectPosition = {x, y, z, rx, ry, rz}
        
        addEventHandler('onClientElementDestroy', ob, cancelMoveWhenPreviewIsDestroyed)
        
        showGridlines(ob)
        
        toggleHandlers(true)
        crafting.state = true
        
        setElementData(localPlayer, 'editingObj', true, false)
    end
end
loadEvent('craft:startMovingObject', localPlayer, startMovingObject)

function cancelCraftingObject()
    if not crafting.state then
        return
    end
    destroyCraftPreview()
    toggleHandlers(false)
    setElementData(localPlayer, 'editingObj', nil, false)
end
addEventHandler('rust:onClientPlayerDie', localPlayer, cancelCraftingObject)

function destroyCraftPreview()
    local ob = crafting.ob
    if ob and isElement(ob) then
        showGridlines(nil)
        
        if crafting.doing == 'moving' then
            
            triggerServerEvent('craft:stopMovingObject', localPlayer, ob)
            
            if not crafting.saved then
                local x, y, z, rx, ry, rz = unpack(crafting.initialObjectPosition)
                setElementPosition(ob, x, y, z)
                setElementRotation(ob, rx, ry, rz)
                
                removeEventHandler('onClientElementDestroy', ob, cancelMoveWhenPreviewIsDestroyed)
            end
        else
            destroyElement(ob)
        end
    end
    
    if crafting.movingMode == 'cursor' then
        showCursor(false)
    end
    
    crafting.ob = nil
    crafting.obName = nil
    crafting.state = nil
    crafting.doing = nil
    crafting.savingTick = nil
    crafting.initialObjectPosition = nil
    crafting.savingTimer = nil
    crafting.saved = nil
end

function cancelMoveWhenPreviewIsDestroyed()
    if crafting.ob == source then
        cancelCraftingObject()
    end
end

function toggleHandlers(state)
    if state then
        addEventHandler('onClientRender', root, syncObjectPos)
        addEventHandler('onClientKey', root, rotateObject)
        bindKey('space', 'down', changeMovingMode)
        bindKey('mouse1', 'both', startSaving)
        bindKey('mouse2', 'both', toggleCursor)
        bindKey('mouse3', 'down', cancelCraftingObject)
    else
        removeEventHandler('onClientRender', root, syncObjectPos)
        removeEventHandler('onClientKey', root, rotateObject)
        unbindKey('space', 'down', changeMovingMode)
        unbindKey('mouse1', 'both', startSaving)
        unbindKey('mouse2', 'both', toggleCursor)
        unbindKey('mouse3', 'down', cancelCraftingObject)
    end
    
    HIGHLIGHT:highlightObject(state and crafting.ob, {255, 255, 0, 200})
    
    triggerServerEvent('craft:togglePedAnimation', localPlayer, state)
    inv.allowToUseControls(not state)
end

function startSaving(key, state)
    if state == 'down' then
        if not canPutHere(crafting.ob, crafting.doing, crafting.obName) then
            return
        end
        crafting.savingTick = getTickCount()
        crafting.savingTimer = setTimer(function()
            local ob = crafting.ob
            if ob and isElement(ob) then
                local x, y, z = getElementPosition(ob)
                local rx, ry, rz = getElementRotation(ob)
                crafting.savingTimer = nil
                crafting.savingTick = nil
                
                if crafting.doing == 'crafting' then
                    if getElementData(localPlayer, 'WaitingResponse') then
                        return false
                    end
                    local custo = getObjectDataSetting(crafting.obName, 'craftingCusto')
                    if custo then
                        setElementData(localPlayer, 'WaitingResponse', true)
                        triggerServerEvent('OnCraftObject', localPlayer, crafting.obName, {x, y, z, rx, ry, rz})
                    end
                
                elseif crafting.doing == 'moving' then
                    triggerServerEvent('craft:saveObjectPosition', localPlayer, ob, x, y, z, rx, ry, rz)
                    removeEventHandler('onClientElementDestroy', ob, cancelMoveWhenPreviewIsDestroyed)
                    crafting.saved = true
                end
                cancelCraftingObject()
            end
        end, timeToSave, 1)
    
    else
        crafting.savingTick = nil
        
        if crafting.savingTimer and isTimer(crafting.savingTimer) then
            killTimer(crafting.savingTimer)
        end
        crafting.savingTimer = nil
    end
end

local _whitelistToRot = {}

function rotateObject(btn, state)
    local ob = crafting.ob
    if ob and isElement(ob) then
        if crafting.savingTick then
            return
        end
        local speed = 5
        if getKeyState('lshift') then
            speed = 15
        elseif getKeyState('lctrl') then
            speed = 1
        end
        
        if btn == 'arrow_u' or button == 'arrow_d' then
            crafting.rotAxis = state and 'y' or 'z'
        elseif btn == 'arrow_r' or btn == 'arrow_l' then
            crafting.rotAxis = state and 'x' or 'z'
        end
        
        if state then
            local rx, ry, rz = getElementRotation(ob)
            
            if btn == 'mouse_wheel_up' or btn == 'mouse_wheel_down' or btn == 'pgup' or btn == 'pgdn' then
                if crafting.movingMode == 'keyboard' and (btn == 'pgup' or btn == 'pgdn') then
                    return
                end
                if btn == 'mouse_wheel_down' or btn == 'pgdn' then
                    speed = -speed
                end
                
                if crafting.rotAxis == 'z' then
                    setElementRotation(ob, rx, ry, rz + speed)
                
                elseif crafting.rotAxis == 'y' then
                    local newRY = findRot(ry + speed)
                    if not canRotate(newRY) and not _whitelistToRot[getElementModel(ob)] then
                        return
                    end
                    setElementRotation(ob, rx, newRY, rz);
                
                elseif crafting.rotAxis == 'x' then
                    local newRX = findRot(rx + speed)
                    if not canRotate(newRX) and not _whitelistToRot[getElementModel(ob)] then
                        return
                    end
                    setElementRotation(ob, newRX, ry, rz);
                end
            end
        end
    end
end

function findRot(t)
    return t < 0 and t + 360 or t
end

function canRotate(n)
    local way = (n >= 330 and n < 360) and 'up' or 'down'
    if n == 0 or n >= 359 then
        way = nil
    end
    if way == 'down' and n >= 35 then
        return false
    end
    if way == 'up' and n <= 320 then
        return false
    end
    return true
end

function changeMovingMode()
    local obName = crafting.obName
    if obName then
        if getObjectDataSetting(obName, 'moveOnlyWithCursor') then
            return
        end
    end
    crafting.movingMode = crafting.movingMode == 'cursor' and 'keyboard' or 'cursor'
    showCursor(crafting.movingMode == 'cursor')
end

function toggleCursor(key, state)
    if crafting.movingMode == 'keyboard' then
        return
    end
    showCursor(not isCursorShowing())
end

local lastCheckCanCraft = 0
local cacheCanCraft = {false, 'loading'}

function syncObjectPos()
    local ob = crafting.ob
    if ob and isElement(ob) then
        local can, reason = cacheCanCraft[1], cacheCanCraft[2]
        
        if (getTickCount() - lastCheckCanCraft > 100) then
            can, reason = canPutHere(ob, crafting.doing, crafting.obName)
            
            cacheCanCraft = {can, reason}
            lastCheckCanCraft = getTickCount()
        end
        
        if not can then
            local x, y, z = getElementPosition(ob)
            local sx, sy = getScreenFromWorldPosition(x, y, z)
            if sx then
                local w, h = dxGetTextSize(reason, 0, 1, 1, font('franklin'), false)
                if (type(w) == 'table') then
                    w, h = unpack(w)
                end
                dxDrawBorderedText(reason, sx - w / 2, sy + 10, sx - w / 2 + w, sy + h + 10, tocolor(255, 255, 255, 200), 1, font('franklin'),
                    'center', 'center', false, true)
            end
            
            HIGHLIGHT:highlightObject(ob, {255, 0, 0, 200})
        
        else
            HIGHLIGHT:highlightObject(ob, {255, 255, 0, 200})
        end
        
        if crafting.savingTick then
            drawSavingProgress()
        else
            if crafting.movingMode == 'cursor' then
                syncObjectWithCursor(ob)
            elseif crafting.movingMode == 'keyboard' then
                syncObjectWithKeyBoard(ob)
            end
            drawHelp()
        end
    end
end

function drawSavingProgress()
    local ob = crafting.ob
    if ob and isElement(ob) then
        local x, y, z = getElementPosition(ob)
        x, y = getScreenFromWorldPosition(x, y, z)
        if x then
            local h = pixels(150)
            dxDrawRing(x, y, h, pixels(35), 90, 1, tocolor(255, 255, 255, 15))
            
            local percent = (getTickCount() - crafting.savingTick) / timeToSave
            dxDrawRing(x, y, h, pixels(35), 90, percent, tocolor(106, 127, 62, 200))
        end
    end
end

function syncObjectWithCursor(ob)
    if ob and isElement(ob) then
        local cx, cy = _getCursorPosition(true)
        if not cx or cx == sW * 0.5 then
            return
        end
        
        local x, y, z = getWorldFromScreenPosition(cx, cy, 0)
        if not x then
            return
        end
        
        local wx, wy, wz = getWorldFromScreenPosition(cx, cy, 10)
        if not wx then
            return
        end
        
        local hit, hitx, hity, hitz = processLineOfSight(x, y, z, wx, wy, wz, true, false, false, true, false, true, false, false, ob)
        
        if hit then
            setElementPosition(ob, hitx, hity, hitz + getElementDistanceFromCentreOfMassToBaseOfModel(ob))
        end
    end
end

local mathcos = math.cos
local mathsin = math.sin
function syncObjectWithKeyBoard(ob)
    if ob and isElement(ob) then --
        local x, y, z = getElementPosition(ob)
        local tempX, tempY, tempZ = x, y, z
        local _, _, camRotZ = getCameraRotation()
        camRotZ = camRotZ % 360
        camRotZ = math.rad(camRotZ)
        
        local speed = 0.025
        if getKeyState('lctrl') then
            speed = 0.005
        end
        if getKeyState('lshift') then
            speed = 0.05
        end
        
        local distX = speed * mathcos(camRotZ)
        local distY = speed * mathsin(camRotZ)
        
        if getKeyState('num_6') then -- direita
            tempX = tempX + distX
            tempY = tempY - distY
        end
        if getKeyState('num_4') then -- esquerda
            tempX = tempX - distX
            tempY = tempY + distY
        end
        if getKeyState('num_8') then -- frente
            tempX = tempX + distY
            tempY = tempY + distX
        end
        if getKeyState('num_2') then -- tras
            tempX = tempX - distY
            tempY = tempY - distX
        end
        if getKeyState('pgup') then -- cima
            tempZ = tempZ + speed
        end
        if getKeyState('pgdn') then -- baixo
            tempZ = tempZ - speed
        end
        
        if tempX ~= x or tempY ~= y or tempZ ~= z then
            x, y, z = tempX, tempY, tempZ
            local px, py, pz = getElementPosition(localPlayer)
            if getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 10 then
                setElementPosition(ob, x, y, z)
            end
        end
    end
end

local helps = {
    ['cursor'] = {{'save', {'mouse1', 'cursor_left.png'}}, {'change method.cursor', {'space', 'spacebar.png'}},
        {'rotate', {'', 'cursor_middle_r.png'}}, {'cancel', {'mouse3', 'cursor_middle.png'}},
        {'hide cursor', {'mouse2', 'cursor_right.png'}}, {'speeddown.cursor', {'lctrl', 'ctrl.png'}},
        {'speedup.cursor', {'lshift', 'shift.png'}},
        {'change rotation method', {'arrow_u', 'arrow_u.png'}, {'arrow_l', 'arrow_l.png'}, {'arrow_r', 'arrow_r.png'},
            {'arrow_d', 'arrow_d.png'}}},
    ['keyboard'] = {{'save', {'mouse1', 'cursor_left.png'}}, {'change method.keyboard', {'space', 'spacebar.png'}},
        {'rotate', {'', 'cursor_middle_r.png'}}, {'cancel', {'mouse3', 'cursor_middle.png'}}, {'speeddown', {'lctrl', 'ctrl.png'}},
        {'speedup', {'lshift', 'shift.png'}},
        {'change rotation method', {'arrow_u', 'arrow_u.png'}, {'arrow_l', 'arrow_l.png'}, {'arrow_r', 'arrow_r.png'},
            {'arrow_d', 'arrow_d.png'}}, {'Move', {'num_8', '8.png'}, {'num_4', '4.png'}, {'num_6', '6.png'}, {'num_2', '2.png'}}},
}

function drawHelp()
    local margin = pixels(5)
    local w, h = pixels(320), pixels(400)
    local x, y = sW - w - margin, sH * 0.23
    
    local iconW = pixels(32)
    
    local editMode = crafting.movingMode
    
    local obName = crafting.obName
    local canChangeMethod = not getObjectDataSetting(obName, 'moveOnlyWithCursor')
    if not canChangeMethod then
        h = h * (#helps[editMode] - 1) * 0.081
    else
        h = h * (#helps[editMode]) * 0.081
    end
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 200))
    
    y = y + 2
    
    local back = 0
    for i, help in ipairs(helps[editMode]) do
        if string.find(help[1], 'change method.') and not canChangeMethod then
            back = back + 1
        else
            local stack = #help
            local y = y + (i - 1 - back) * iconW
            for d = 2, stack do
                local color = (help[d][1] and getKeyState(help[d][1])) and tocolor(255, 0, 0, 255) or tocolor(255, 255, 255, 255)
                local icon = ('ui/keys/%s'):format(help[d][2] or '')
                dxDrawImage(x + ((d - 2) * iconW), y, iconW, iconW, getTexture(icon), 0, 0, 0, color)
            end
            
            dxDrawText(translate(help[1]), x + (stack - 1) * iconW, y, x + w - 2, y + iconW, tocolor(255, 255, 255, 255), 1, font('franklin'), 'left',
                'center', true)
        end
    end
end

local blockedZones = {
    ['los santos international'] = true,
    ['el corona'] = true,
    ['willowfield'] = true,
    ['ocean docks'] = true,
    ['ganton'] = true,
    ['playa del seville'] = true,
    ['restricted area'] = true,
    ['battery point'] = true,
    ['paradiso'] = true,
    ['palisades'] = true,
    ['santa flora'] = true,
    ['juniper hill'] = true,
    ['china town'] = true,
    ['calton heights'] = true,
    ['financial'] = true,
    ['esplanade north'] = true,
    ['esplanade east'] = true,
    ['downtown'] = true,
    ['kings'] = true,
    ['queens'] = true,
    ['city hall'] = true,
    ['ocean flats'] = true,
    ['garcia'] = true,
    ['cranberry station'] = true,
    ['easter basin'] = true,
    ['unknown'] = true,
}

local manuallyCoords = {
    {2845, -2462, 28, 300},
    {905.55700683594, -3675.6145019531, 28.73348236084, 500},
}

-- addEventHandler('onClientRender', root, function()
--     local x,y,z = getElementPosition(localPlayer)
--     dxDrawText(inspect{
--         getZoneName(x,y,z, tue)
--     }, 1200, 200)
-- end)
function nearToBlockedZone(x, y, z)
    for k, v in ipairs(getElementsByType('recycler')) do
        local xx, yy, zz = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, xx, yy, zz) <= 75 then
            return true
        end
    end
    for k, v in ipairs(manuallyCoords) do
        local xx, yy, zz, dist = unpack(v)
        if getDistanceBetweenPoints3D(x, y, z, xx, yy, zz) <= dist then
            return true
        end
    end
    return blockedZones[getZoneName(x, y, z):lower()]
end

function nearToTunnel(x, y, z)
    return not isLineOfSightClear(x, y, z + 1, x, y, z + 100, true, false, false, false, false, false, false)
end

function isFlying(x, y, z, ob)
    return isLineOfSightClear(x, y, z + 1, x, y, z - 8, true, false, false, true, false, false, false, ob)
end

function isAboveWater(x, y, z)
    return testLineAgainstWater(x, y, z + 1, x, y, z - 100, true, false, false, false, false, false, false)
end

function nearToHospitalSpawn(x, y, z)
    for k, v in ipairs(getElementsByType('hospitalPack')) do
        local xx, yy, zz = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, xx, yy, zz) <= 30 then
            return true
        end
    end
    return false
end

function nearToVehicleSpawn(x, y, z)
    for k, v in ipairs(getElementsByType('vehicleSpawn')) do
        local xx, yy, zz = getElementPosition(v)
        if getDistanceBetweenPoints3D(x, y, z, xx, yy, zz) <= 30 then
            return true
        end
    end
    return false
end

function nearToPlayerSpawn(x, y, z)
    for k, v in ipairs(getElementsByType('playerSpawn')) do
        if getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= 30 then
            return true
        end
    end
    return false
end

isTooHight = function(ob)
    local x, y, z = getElementPosition(ob)
    return isLineOfSightClear(x, y, z + 0.5, x, y, z - 27, true, false, false, false, false, false, false)
end

local radiations = {
    {-1535.0975341797, 365.3522644043, 7.1875},
    {1178.0183105469, -2038.5067138672, 69.0078125},
    {2613.9624023438, 2734.0798339844, 36.538604736328},
    {178.23657226563, 1902.8526611328, 18.037378311157},
    {3111.8088378906, -582.64276123047, 8.7373447418213},
}

function nearToRadiation(x, y, z)
    for k, v in ipairs(radiations) do
        local x, y, z = unpack(v)
        if getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) <= 400 then
            return true
        end
    end
    return false
end

checkNearWardrobes = function(object)
    local x, y, z = getElementPosition(object)
    
    for k, v in ipairs(getElementsByType('object', resourceRoot, true)) do
        if (not isElementLowLOD(v)) and (v ~= object) then
            if (getDistanceBetweenPoints3D(x, y, z, getElementPosition(v)) <= (crafting.distanceArmario * 2)) then
                if (getElementData(v, 'obName') == 'Wardrobe') then
                    if (not isFriendly(v)) then
                        return false, translate('Zona proibida', nil, translate('Near to enemy'))
                    end
                end
            end
        end
    end

    return true
end

function canPutHere(ob, doing, obName)
    if ob and isElement(ob) then
        if isTooHight(ob) then
            return false, translate('muito alto')
        end
        
        if isAdmin(localPlayer) then
            return true
        end
        
        if isBaseItem(obName) then
            obName = 'baseItems'
        end

        if doing == 'crafting' and ((getElementData(localPlayer, obName) or 0) >= getObjectLimit(obName, localPlayer)) then
            if (obName == 'baseItems') and ((getElementData(localPlayer, 'Wardrobe') or 0) <= 0) then
                return false, translate('Atingiu limite de %s2', nil, translate(obName, 'name'))
            end
            return false, translate('Atingiu limite de %s', nil, translate(obName, 'name'))
        end
        
        local a, b = checkNearWardrobes(ob)
        if not a then
            return false, b
        end
        
        local x, y, z = getElementPosition(ob)
        if nearToPlayerSpawn(x, y, z) then
            local error = translate('Zona proibida', nil, translate('Player Spawn'))
            return false, error
        end
        
        if nearToVehicleSpawn(x, y, z) then
            local error = translate('Zona proibida', nil, translate('Vehicle Spawn'))
            cache = {false, error}
            return false, error
        end
        if nearToHospitalSpawn(x, y, z) then
            local error = translate('Zona proibida', nil, translate('Hospital Spawn'))
            return false, error
        end
        if nearToTunnel(x, y, z) then
            local error = translate('Zona proibida', nil, '?')
            return false, error
        end
        if isFlying(x, y, z, ob) then
            local error = translate('Zona proibida', nil, translate('Voando'))
            return false, error
        end
        if nearToRadiation(x, y, z) then
            local error = translate('Zona proibida', nil, translate('Radiação'))
            return false, error
        end
        if nearToBlockedZone(x, y, z) then
            local error = translate('Zona proibida', nil, translate('Bloqueado manualmente pela staff'))
            return false, error
        end
        return true
    end
    return false, 'Unknown error (#OXASCASP)'
end

function isFriendly(ob)
    if ob and isElement(ob) then
        local myAcc = getElementData(localPlayer, 'account')
        if myAcc then
            local owner = getElementData(ob, 'owner')
            if (owner == myAcc) then
                return true
            end
            if owner then
                local wardrobe = getElementByID(('wardrobe:%s'):format(owner))
                if wardrobe then
                    local permissions = getElementData(wardrobe, 'wardrobe:permissions')
                    if permissions and type(permissions) == 'table' then
                        return permissions[myAcc]
                    end
                end
            end
        end
    end
    return false
end

function isCreator(ob)
    if ob and isElement(ob) then
        local owner = getElementData(ob, 'owner')
        return (owner and owner == getElementData(localPlayer, 'account')) or false
    end
    return false
end

function isPlayerCrafting()
    return crafting.state
end
