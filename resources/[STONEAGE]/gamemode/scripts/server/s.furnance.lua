local Furnances = {}

initFurnance = function(ob)
    addEventHandler('onElementDataChange', ob, onFurnanceDataChange)
end

addEventHandler('onElementDestroy', resourceRoot, function()
    if Furnances[source] then
        if isTimer(Furnances[source].timer) then
            killTimer(Furnances[source].timer)
        end
        Furnances[source] = nil
    end
end)

checkCanKeepFurnance = function(ob)
    if getElementData(ob, 'furnance:firing') then
        return
    end
    local order = isElement(ob) and getElementData(ob, 'invOrder')
    if not order then
        return
    end
    for k, v in pairs(order) do
        local settings = getItemFurnanceSettings(v.itemName)
        if settings and (v.quantity >= settings.needed) then
            initFurnanceProgress(ob, v.itemName, k)
            break
        end
    end
end

initFurnanceProgress = function(ob, itemName, slotID)
    local settings = getItemFurnanceSettings(itemName)
    if settings then
        if ((getElementData(ob, itemName) or 0) <= 0) then
            return false
        end

        if not Furnances[ob] then
            Furnances[ob] = {}
        end

        if isTimer(Furnances[ob].timer) then
            killTimer(Furnances[ob].timer)
        end

        setElementData(ob, 'furnance:progress', 0)
        setElementData(ob, 'furnance:firing', itemName)
        setElementData(ob, 'furnance:firingSlot', slotID)

        Furnances[ob].timer = setTimer(function(ob, itemName)
            local _, execsRemaining = getTimerDetails(sourceTimer)

            if isElement(ob) then
                if ((getElementData(ob, itemName) or 0) <= 0) then
                    if isTimer(Furnances[ob].timer) then
                        killTimer(Furnances[ob].timer)
                    end
                    Furnances[ob] = nil
                    return false
                end
                setElementData(ob, 'furnance:progress', 101 - execsRemaining)
            end

            if execsRemaining == 1 then
                local settings = getItemFurnanceSettings(itemName)
                if settings then
                    local receive = settings.receive
                    setElementData(ob, itemName, (getElementData(ob, itemName) or 0) - settings.needed)
                    setElementData(ob, receive[1], (getElementData(ob, receive[1]) or 0) + receive[2])
                end

                removeElementData(ob, 'furnance:progress')
                removeElementData(ob, 'furnance:firing')
                removeElementData(ob, 'furnance:firingSlot')

                Furnances[ob] = nil

                checkCanKeepFurnance(ob)
            end
        end, settings.speed, 100, ob, itemName)

        return true
    end
    return false
end

function onFurnanceDataChange(key, old, new)
    if key == 'invOrder' then
        if getElementData(source, 'fire') then
            checkCanKeepFurnance(source)
        end

    elseif key == 'fire' then
        local x, y, z = getElementPosition(source)
        if new then
            checkCanKeepFurnance(source)
            exports['stoneage_sound3D']:play3DSound(':gamemode/files/sounds/fornalha_ligar.mp3', {x, y, z}, 1, 150)
        else
            exports['stoneage_sound3D']:play3DSound(':gamemode/files/sounds/fornalha_desligar.mp3', {x, y, z}, 1, 150)
            removeElementData(source, 'furnance:progress')
            removeElementData(source, 'furnance:firing')
            removeElementData(source, 'furnance:firingSlot')
            if Furnances[source] then
                if isTimer(Furnances[source].timer) then
                    killTimer(Furnances[source].timer)
                end
                Furnances[source] = nil
            end
        end
    end
end
