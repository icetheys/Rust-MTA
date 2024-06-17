Ship = {
    RenderingSmoke = false,
    Effects = {},
}

local Init = function()
    triggerServerEvent('RequestShip', localPlayer)
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

addEvent('ReceiveShip', true)
addEventHandler('ReceiveShip', localPlayer, function(ship)
    if (not isElement(ship)) then
        return
    end
    
    for k, v in pairs(Ship.Effects) do
        if isElement(v.Effect) then
            destroyElement(v.Effect)
        end
    end

    local x, y, z = getElementPosition(ship)
    
    Ship.Effects = {
        {
            Effect = createEffect('smoke50lit', x, y, z),
            Position = {-34, 0, 20}
        },
        {
            Effect = createEffect('smoke30m', x, y, z),
            Position = {-34, 2, 23.5}
        },
        {
            Effect = createEffect('smoke50lit', x, y, z),
            Position = {-34, 0, 25}
        },
        {
            Effect = createEffect('smoke30m', x, y, z),
            Position = {-34, -2, 23.5}
        },
    }
    
    Ship.Element = ship
    
    if (not Ship.RenderingSmoke) then
        Ship.RenderingSmoke = true
        addEventHandler('onClientRender', root, Render)
    end
end)

Render = function()
    for k, v in pairs(Ship.Effects) do
        if isElement(v.Effect) then
            if isElement(Ship.Element) then
                local x, y, z = GetPositionFromElementOffset(Ship.Element, unpack(v.Position))
                setElementPosition(v.Effect, x, y, z)
            else
                destroyElement(v.Effect)    
            end
        end
    end
end

PlayHorn = function()
    if isElement(Ship.Element) then
        local horn = playSound3D('assets/horn.mp3', getElementPosition(Ship.Element))
        setSoundMaxDistance(horn, 1000)
        setSoundVolume(horn, 2)
        attachElements(horn, Ship.Element)
    end
end
addEvent('PlayShipHorn', true)
addEventHandler('PlayShipHorn', localPlayer, PlayHorn)
