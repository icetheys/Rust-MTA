local Placas = {}

local Init = function()
    Async:foreach(getElementsByType('object', root, true), function(ob)
        if getElementData(ob, 'obName') == 'Placa' then
            createPlateRenderTarget(ob)
        end
    end)

    addEventHandler('onClientRender', root, drawTexts)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

createPlateRenderTarget = function(ob)
    if isElement(ob) then
        if Placas[ob] then
            handleObject(ob)
        end

        local w, h = 300, 200
        local rT = dxCreateRenderTarget(w, h, true)

        local text = getElementData(ob, 'placa:text')
        dxSetRenderTarget(rT, true)
        dxSetBlendMode('add')

        dxDrawBorderedText(tostring(text), 5, 0, w - 10, h, tocolor(100, 100, 100, 255), 1.5, 'default-bold', 'center', 'center', false, true)
        dxSetBlendMode('blend')
        dxSetRenderTarget()

        Placas[ob] = rT

        addEventHandler('onClientElementDataChange', ob, refreshPlateText)
    end
end

refreshPlateText = function(key, old, new)
    if key == 'placa:text' then
        handleObject(source)
        createPlateRenderTarget(source)
    end
end

handleObject = function(ob)
    if ob then
        source = ob
    end
    if getElementType(source) == 'object' and getElementData(source, 'obName') == 'Placa' then
        if eventName == 'onClientElementStreamIn' then
            createPlateRenderTarget(source)
        else
            if isElement(Placas[source]) then
                destroyElement(Placas[source])
            end
            if isElement(source) then
                removeEventHandler('onClientElementDataChange', source, refreshPlateText)
            end
            Placas[source] = nil
        end
    end
end
addEventHandler('onClientElementStreamIn', root, handleObject)
addEventHandler('onClientElementStreamOut', root, handleObject)

drawTexts = function()
    local maxDist = 15
    for ob, renderTarget in pairs(Placas) do
        if isElement(ob) and isElement(renderTarget) then
            local fx, fy, fz = getPositionFromElementOffset(ob, 0, 0.065, 1.68)

            local x, y, z = getElementPosition(localPlayer)
            local dist = getDistanceBetweenPoints3D(x, y, z, fx, fy, fz)
            if dist <= maxDist then
                local alpha = 255 - (dist * 255 / maxDist)

                local fx2, fy2, fz2 = getPositionFromElementOffset(ob, 0, 1, 2)

                local h = 0.275
                local w = 1.2

                dxDrawMaterialLine3D(fx, fy, fz + h, fx, fy, fz - h, renderTarget, w, tocolor(255, 255, 255, alpha), false, fx2, fy2, fz2)
            end
        end
    end
end
