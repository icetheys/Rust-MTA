local insideCol = false

local Init = function()
    for k, v in ipairs(getRadiationZones()) do
        local x, y, z = unpack(v)

        -- createEffect('teargasAD', x, y, z)
        -- createEffect('heli_dust', x, y, z)

        local colshape = createColSphere(x, y, z, 25)
        setElementData(colshape, 'radiation', true, false)

        addEventHandler('onClientColShapeHit', colshape, onColshapeHit)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

function onColshapeHit(player, sameDim)
    if (player == localPlayer) and sameDim and (not insideCol) then
        decreaseHealth(source)
    end
end

function decreaseHealth(colshape)
    if isElement(colshape) and getElementData(localPlayer, 'account') and (not getElementData(localPlayer, 'isDead')) and (not getElementData(localPlayer, 'staffRole')) then
        local bloodLoss = 300

        if (getElementModel(localPlayer) == 73) then
            bloodLoss = math.random(30, 50)

        elseif getElementData(localPlayer, 'Mask_used') then
            bloodLoss = 150

        end

        setElementData(localPlayer, 'blood', (getElementData(localPlayer, 'blood') or 0) - bloodLoss)

        if getElementData(localPlayer, 'blood') <= 0 then
            triggerServerEvent('player:onDie', localPlayer, {reason = 'Radiation'})
        end

        if isInsideColShape(colshape, getElementPosition(localPlayer)) then
            insideCol = true
            setTimer(decreaseHealth, 2000, 1, colshape)
        else
            insideCol = false
        end
    else
        insideCol = false
    end
end
