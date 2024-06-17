TIME_TO_SAVE_CRAFT = 500

Craft = {
    SelectedOptionID = 1,
    FrontToPlayer = true,
    Offset = {
        z = 0,
        rz = 0,
    },
    Action = nil,
    Object = nil,
    CanSave = nil,
    SavingTimer = nil,
    DrawingUI = nil,
}

local timerRestoreControls

Craft.Toggle = function(state, a)
    if state then
        if getElementData(localPlayer, 'editingObj') then
            return false
        end
        
        local obName = ('%s de Palito'):format(Craft.DisplayOrder[Craft.SelectedOptionID].name)
        local model = exports['gamemode']:getObModel(obName)
        if not model then
            return
        end
        
        local x, y, z = getPositionFromElementOffset(localPlayer, 0, 2, -0.95)
        local ob = createObject(model, x, y, z)
        setElementCollisionsEnabled(ob, false)
        highlightObject2(ob, 255, 0, 0, 200)
        
        Craft.Action = 'Craft'
        Craft.Object = ob
        Craft.ObjectName = obName
        Craft.ObjectType = exports['gamemode']:getObjectDataSetting(obName, 'Type')
        Craft.TranslatedObjectName = exports['stoneage_translations']:translate(obName, 'name')
        Craft.FlyingString = exports['stoneage_translations']:translate('Fundacao apenas chao')
        Craft.PosicaoInvalida = exports['stoneage_translations']:translate('Sem Tocar')
        Craft.CustoString = exports['gamemode']:getObjectCustoString(obName, 1, localPlayer)
        Craft.Limit = exports['gamemode']:getObjectLimit(obName, localPlayer)
        
        addEventHandler('onClientRender', root, Craft.Render)
        addEventHandler('onClientKey', root, Craft.onKey)
        
        setElementData(localPlayer, 'editingObj', true, false)
        
        if isTimer(timerRestoreControls) then
            killTimer(timerRestoreControls)
        end
        
        setPedControlState(localPlayer, 'fire', false)
        toggleControl('fire', false)
        toggleControl('jump', false)
    
    else
        setElementData(localPlayer, 'editingObj', false, false)
        
        removeEventHandler('onClientRender', root, Craft.Render)
        removeEventHandler('onClientKey', root, Craft.onKey)
        
        if isElement(Craft.Object) then
            destroyElement(Craft.Object)
        end
        
        if isTimer(Craft.SavingTimer) then
            killTimer(Craft.SavingTimer)
        end
        
        Craft.Action = nil
        Craft.Object = nil
        Craft.ObjectName = nil
        Craft.ObjectType = nil
        Craft.TranslatedObjectName = nil
        Craft.CustoString = nil
        Craft.Limit = nil
        Craft.SavingTick = nil
        Craft.SavingTimer = nil
        
        setPedControlState(localPlayer, 'fire', false)
        timerRestoreControls = setTimer(toggleControl, 1000, 1, 'fire', true)
        toggleControl('jump', true)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
    -- Craft.Toggle(true)
    end)

Craft.ToggleMoving = function(state, ob, saveOnCancel)
    if state then
        if isElement(ob) then
            Craft.Action = 'Edit'
            Craft.Object = ob
            Craft.ObjectName = getElementData(ob, 'obName')
            Craft.ObjectType = exports['gamemode']:getObjectDataSetting(Craft.ObjectName, 'Type')
            Craft.InitEditPos = {getElementPosition(ob)}
            Craft.InitEditRot = {getElementRotation(ob)}
            
            Craft.PosicaoInvalida = exports['stoneage_translations']:translate('Sem Tocar')
            
            highlightObject2(Craft.Object, 255, 0, 0, 200)
            
            addEventHandler('onClientRender', root, Craft.Render)
            addEventHandler('onClientKey', root, Craft.onKey)
            
            setPedControlState(localPlayer, 'fire', false)
            toggleControl('fire', false)
            toggleControl('jump', false)
            
            setElementData(localPlayer, 'editingObj', true, false)

            triggerServerEvent('craft:togglePedAnimation', localPlayer, state, false)
            
        end
    else
        setPedControlState(localPlayer, 'fire', false)
        toggleControl('fire', true)
        toggleControl('jump', true)
        
        triggerServerEvent('craft:togglePedAnimation', localPlayer, state, false)
        triggerServerEvent('craft:stopMovingObject', localPlayer, Craft.Object)
        
        highlightObject2(false)
        
        removeEventHandler('onClientRender', root, Craft.Render)
        removeEventHandler('onClientKey', root, Craft.onKey)
        
        if isElement(Craft.Object) and not saveOnCancel then
            local x, y, z = unpack(Craft.InitEditPos)
            local rx, ry, rz = unpack(Craft.InitEditRot)
            setElementPosition(Craft.Object, x, y, z)
            setElementRotation(Craft.Object, rx, ry, rz)
        end
        
        setElementData(localPlayer, 'editingObj', false, false)
        
        Craft.Action = nil
        Craft.Object = nil
        Craft.ObjectName = nil
        Craft.ObjectType = nil
        Craft.InitEditPos = nil
        Craft.InitEditRot = nil
        
        if isTimer(Craft.SavingTimer) then
            killTimer(Craft.SavingTimer)
        end
        
        Craft.TranslatedObjectName = nil
        Craft.CustoString = nil
        Craft.Limit = nil
        Craft.SavingTimer = nil
        Craft.SavingTick = nil
    
    end
end

addEvent('base:startMovingObject', true)
addEventHandler('base:startMovingObject', localPlayer, function(ob)
    Craft.ToggleMoving(true, ob)
end)

Craft.onKey = function(key, state)
    if key == 'mouse1' then
        Craft.ToggleSave(state)
    
    elseif key == 'mouse2' and Craft.Action == 'Craft' then
        Craft.ToggleUI(state)
    
    elseif key == 'space' and state and Craft.Action == 'Edit' then
        Craft.ToggleMoving(false)
    
    elseif key == 'r' and state then
        Craft.FrontToPlayer = not Craft.FrontToPlayer
    
    elseif key == 'mouse_wheel_up' or key == 'mouse_wheel_down' then
        local speed = 5
        if getKeyState('lctrl') then
            speed = 1
        elseif getKeyState('lshift') then
            speed = 10
        end
        if key == 'mouse_wheel_down' then
            speed = -speed
        end
        
        Craft.Offset.rz = Craft.Offset.rz + speed
    
    elseif key == 'pgup' or key == 'pgdn' then
        local speed = 0.05
        if getKeyState('lctrl') then
            speed = 0.02
        elseif getKeyState('lshift') then
            speed = 0.5
        end
        if key == 'pgdn' then
            speed = -speed
        end
        Craft.Offset.z = math.max(0, math.min(Craft.Offset.z + speed, 3))
        
        setTimer(function()
            if getKeyState(key) then
                Craft.onKey(key, state)
            end
        end, 50, 1)
    end
end

Craft.ToggleUI = function(state)
    if state then
        if Craft.SavingTick then
            return
        elseif (getPedSimplestTask(localPlayer) ~= 'TASK_SIMPLE_PLAYER_ON_FOOT') then
            return
        end
    end
    showCursor(state)
    Craft.DrawingUI = state
    setCursorPosition(sW / 2, sH / 2)
    triggerServerEvent('craft:togglePedAnimation', localPlayer, state, true)
end

addEventHandler('rust:onClientPlayerDie', localPlayer, function(reason, weaponUsed)
    Craft.Toggle(false)
end)

addEvent('onPlayerEquipItem', true)
addEventHandler('onPlayerEquipItem', localPlayer, function(state, itemName, slotID)
    if itemName == 'Planner' then
        Craft.Toggle(state)
    elseif itemName == 'Hammer' and not state then
        if Craft.Action == 'Edit' then
            Craft.ToggleMoving(false)
        end
    end
end)

Craft.ToggleSave = function(state)
    if state then
        if Craft.CanSave then
            Craft.SavingTick = getTickCount()
            Craft.SavingTimer = setTimer(function()
                if isElement(Craft.Object) then
                    local x, y, z = getElementPosition(Craft.Object)
                    local rx, ry, rz = getElementRotation(Craft.Object)
                    
                    if Craft.Action == 'Craft' then
                        if getElementData(localPlayer, 'WaitingResponse') then
                            return false
                        end
                        local can = exports['gamemode']:canPutHere(Craft.Object, 'crafting', Craft.ObjectName)
                        if can then
                            local custo = exports['gamemode']:getObjectDataSetting(Craft.ObjectName, 'craftingCusto')
                            if custo then
                                Craft.SavingTick = nil
                                Craft.SavingTimer = nil
                                setElementData(localPlayer, 'WaitingResponse', true)
                                triggerServerEvent('OnCraftObject', localPlayer, Craft.ObjectName, {x, y, z, rx, ry, rz})
                                exports['gamemode']:disequipCurrentKeybarItem()
                            end
                        end
                    elseif Craft.Action == 'Edit' then
                        local x, y, z = getElementPosition(Craft.Object)
                        local rx, ry, rz = getElementRotation(Craft.Object)
                        triggerServerEvent('craft:saveObjectPosition', localPlayer, Craft.Object, x, y, z, rx, ry, rz)
                        Craft.ToggleMoving(false, Craft.Object, true)
                        Craft.Toggle(false)
                    end
                end
            end, TIME_TO_SAVE_CRAFT, 1)
        end
    else
        Craft.SavingTick = nil
        if Craft.SavingTimer and isTimer(Craft.SavingTimer) then
            killTimer(Craft.SavingTimer)
        end
        Craft.SavingTimer = nil
    end
end
