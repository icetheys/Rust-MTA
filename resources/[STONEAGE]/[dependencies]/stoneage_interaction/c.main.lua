Interaction = {
    Casting = false,
    ShowingUI = false,
    SelectedObject = false,
    DisplayOptions = {},
    DisplayQuantity = false,
    Fonts = {
        Header = dxCreateFont('assets/fonts/regular2.ttf', sH * 0.0175),
        Header2 = dxCreateFont('assets/fonts/regular2.ttf', sH * 0.012),
        Description = dxCreateFont('assets/fonts/regular2.ttf', sH * 0.01475),
    },
}

KEEP_FIRE_CONTROL = false

ToggleCast = function(state)
    if state then
        if Interaction.Casting then
            return
        end
        addEventHandler('onClientRender', root, CastAim)
    else
        if not Interaction.Casting then
            return
        end
        
        RemoveHoverElement()
        ToggleInteractionUI(false)
        
        removeEventHandler('onClientRender', root, CastAim)
    end
    Interaction.Casting = state
end

bindKey('mouse2', 'both', function(key, state)
    ToggleCast(state == 'down')
end)

hideMenu = function()
    ToggleCast(false)
end
addEventHandler('rust:onClientPlayerEquipItem', localPlayer, hideMenu, false, 'high+')
addEventHandler('rust:onClientPlayerDisequipItem', localPlayer, hideMenu, false, 'high+')
addEventHandler('onClientPlayerVehicleEnter', localPlayer, hideMenu, false, 'high+')

CastAim = function()
    if not CanHandleMenu() then
        RemoveHoverElement()
        ToggleInteractionUI(false)
        return false
    end
    
    local allowed_slots = {
        [0] = true,
        [1] = true
    }

    if allowed_slots[getPedWeaponSlot(localPlayer)] then
        dxDrawCircle(CENTER_X - 1, CENTER_Y - 1, 2)
    end
    
    local x1, y1, z1 = getWorldFromScreenPosition(CENTER_X, CENTER_Y, 0)
    local x2, y2, z2 = getWorldFromScreenPosition(CENTER_X, CENTER_Y, DETECT_DIST)
    
    local hit, hitX, hitY, hitZ, hitElement = processLineOfSight(x1, y1, z1, x2, y2, z2, true, true, true, true, true, false, false, false,
        localPlayer)
    
    local px, py, pz = getElementPosition(localPlayer)
    if hit then
        if not isLineOfSightClear(px, py, pz, hitX, hitY, hitZ, true, true, true, true, false, false, false, hitElement) then
            hit = false
        end
    end

    local disallowedTypes = {
        ['medicament'] = true,
        ['food'] = true,
        ['drink'] = true,
    }

    local equipped = getElementData(localPlayer, 'equippedItem')

    local GAMEMODE = exports['gamemode']

    if equipped and (disallowedTypes[GAMEMODE:getItemType(equipped)]) then
        hit = false
    end

    if hit and isElement(hitElement) and getDistanceBetweenPoints3D(px, py, pz, hitX, hitY, hitZ) <= 3.5 then
        if (hitElement ~= Interaction.SelectedObject) then
            local elemType = getElementType(hitElement)
            if ((elemType == 'object') and getElementData(hitElement, 'obName')) or (elemType == 'player') or (elemType == 'vehicle') or (elemType == 'ped') then
                SetHoverElement(hitElement, {
                    hitPos = {hitX, hitY, hitZ},
                })
            end
        end
    else
        local equippedItem = getElementData(localPlayer, 'equippedItem')
        if equippedItem then
            if (localPlayer ~= Interaction.SelectedObject) then
                SetHoverElement(localPlayer, nil)
            end
        else
            ToggleInteractionUI(false)
            RemoveHoverElement()
        end
    end
end

SetHoverElement = function(element, optionalArgs)
    exports['stoneage_highlight']:highlightObject(element, {255, 0, 0, 255})
    Interaction.SelectedObject = element
    
    Interaction.HitPos = (optionalArgs and optionalArgs.hitPos) or nil
    
    ToggleInteractionUI(false)
    ResetOptions()
    CheckOptionsToDisplay(optionalArgs)
end

RemoveHoverElement = function()
    ToggleInteractionUI(false)
    ResetOptions()
    if Interaction.SelectedObject then
        exports['stoneage_highlight']:highlightObject(false)
        Interaction.SelectedObject = false
    end
end

ToggleInteractionUI = function(state)
    if state then
        if Interaction.ShowingUI then
            return
        end
        
        Interaction.SelectedOptionID = 1
        Interaction.DisplayQuantity = #Interaction.DisplayOptions
        Interaction.LastChangeTick = getTickCount()
        Interaction.RequestedObjectInfo = nil
        
        addEventHandler('onClientRender', root, RenderInteractionUI)
        
        bindKey('fire', 'down', OnKeyDown)
        bindKey('next_weapon', 'down', OnKeyDown)
        bindKey('previous_weapon', 'down', OnKeyDown)
        
        toggleControl('fire', KEEP_FIRE_CONTROL)
        
        if isTimer(Interaction.TimerRestoreControl) then
            killTimer(Interaction.TimerRestoreControl)
        end
    
    else
        if not Interaction.ShowingUI then
            return
        end
        
        KEEP_FIRE_CONTROL = false
        
        setInteractionHeader()
        
        unbindKey('fire', 'down', OnKeyDown)
        unbindKey('next_weapon', 'down', OnKeyDown)
        unbindKey('previous_weapon', 'down', OnKeyDown)
        
        removeEventHandler('onClientRender', root, RenderInteractionUI)
        
        Interaction.TimerRestoreControl = setTimer(function()
            if CanHandleMenu() then
                toggleControl('fire', true)
            end
        end, 500, 1)
    
    end
    -- showCursor(state)
    Interaction.ShowingUI = state
end
local importantDatas = {
    ['health'] = true,
    ['Wood'] = true,
    ['Stone'] = true,
    ['Apple'] = true,
    ['Pure Iron'] = true,
    ['Sulphur'] = true,
    ['fire'] = true,
    ['poço:water'] = true,
}

function onSelectedObjectDataChange(key)
    if (source == Interaction.SelectedObject) and importantDatas[key] then
        ToggleCast(false)
        ResetCastAfterDelay(50)
    end
end
addEventHandler('onClientElementDataChange', root, onSelectedObjectDataChange)

OnKeyDown = function(key)
    if (key == 'fire') then
        local selectedOptions = Interaction.DisplayOptions[Interaction.SelectedOptionID]
        if selectedOptions then
            selectedOptions.callBack()
            Interaction.LastChangeTick = getTickCount()
            if (not Interaction.SubTable) then
                RemoveHoverElement()
                ToggleCast(false)
                ResetCastAfterDelay(750)
            else
                local sound = playSound('assets/click.wav')
                setSoundVolume(sound, 0.1)
            end
        end
    elseif (key == 'next_weapon' or key == 'previous_weapon') then
        local new = Interaction.SelectedOptionID + (key == 'next_weapon' and 1 or -1)
        if new <= 0 then
            new = Interaction.DisplayQuantity
        elseif new > Interaction.DisplayQuantity then
            new = 1
        end
        local sound = playSound('assets/click.wav')
        setSoundVolume(sound, 0.1)
        Interaction.SelectedOptionID = new
        Interaction.LastChangeTick = getTickCount()
    end
end

ResetCastAfterDelay = function(tick)
    setTimer(function()
        if getKeyState('mouse2') then
            ToggleCast(true)
        end
    end, tick, 1)
end
