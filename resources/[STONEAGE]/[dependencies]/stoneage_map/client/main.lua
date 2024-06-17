Map = {
    DrawingMap = false,
    Targets = {},
    Bounds = 4096,
    Styles = {
        ['FullScreen'] = {
            Size = math.min(sW, sH),
            Zoom = 0,
            Pos = {
                x = 0,
                y = 0,
            },
        },
        ['GPS'] = {
            Size = math.min(sW, sH) * 0.25,
            Zoom = 1,
        },
    },
}

InitMap = function()
    local myBlips = exports['stoneage_settings']:getConfig('customBlips', toJSON({}))
    myBlips = myBlips and fromJSON(myBlips)
    if myBlips then
        for k, v in ipairs(myBlips) do
            local worldX, worldY = unpack(v)

            local found = false
            for k, v in ipairs(Map.Targets) do
                local x, y, z = getElementPosition(v)
                if getDistanceBetweenPoints3D(worldX, worldY, 0, x, y, z) <= 200 then
                    table.remove(Map.Targets, k)
                    destroyElement(v)
                    found = true
                end
            end

            if (not found) and (#Map.Targets < 3) then
                local blip = createBlip(worldX, worldY, 0, 41)
                table.insert(Map.Targets, blip)
            end
        end
    end

    Map.MaskShader = dxCreateShader('assets/mask.fx')
    dxSetShaderValue(Map.MaskShader, 'sMaskTexture', GetTexture('assets/circle.png'))

    Map.MaskShaderBG = dxCreateShader('assets/mask.fx')
    dxSetShaderValue(Map.MaskShaderBG, 'sMaskTexture', GetTexture('assets/circle.png'))

    ToggleMap('GPS', true)

    bindKey('F11', 'down', ToggleF11)
    toggleControl('radar', false)

end
addEventHandler('onClientResourceStart', resourceRoot, InitMap)

ToggleF11 = function(key, state)
    if (Map.DrawingMap == 'FullScreen') then
        ToggleMap('FullScreen', false)
        ToggleMap('GPS', true)
    else
        if (getElementData(localPlayer, 'Map') or 0) > 0 then
            ToggleMap('GPS', false)
            ToggleMap('FullScreen', true)
        else
            local str = exports['stoneage_translations']:translate('Você não tem um mapa.')
            exports['stoneage_notifications']:CreateNotification(str, 'error')
        end
    end
end

ToggleMap = function(mapType, state)
    if state then
        if Map.DrawingMap then
            return
        end

        Map.DrawingMap = mapType

        if (Map.DrawingMap == 'FullScreen') then
            addEventHandler('onClientRender', root, RenderF11)
            addEventHandler('onClientKey', root, OnKey)
            showCursor(true)

        elseif (Map.DrawingMap == 'GPS') then
            addEventHandler('onClientRender', root, RenderGPS)
            Map.RenderTarget = dxCreateRenderTarget(Map.Styles['GPS'].Size, Map.Styles['GPS'].Size, true)
            dxSetShaderValue(Map.MaskShader, 'sPicTexture', Map.RenderTarget)

            Map.RenderTargetBG = dxCreateRenderTarget(Map.Styles['GPS'].Size, Map.Styles['GPS'].Size, true)
            dxSetShaderValue(Map.MaskShaderBG, 'sPicTexture', Map.RenderTargetBG)

        end

    else
        if (not Map.DrawingMap) then
            return
        end

        if (Map.DrawingMap == 'FullScreen') then
            removeEventHandler('onClientRender', root, RenderF11)
            removeEventHandler('onClientKey', root, OnKey)
            showCursor(false)

        elseif (Map.DrawingMap == 'GPS') then
            removeEventHandler('onClientRender', root, RenderGPS)
            if isElement(Map.RenderTarget) then
                destroyElement(Map.RenderTarget)
                Map.RenderTarget = false
            end
            if isElement(Map.RenderTargetBG) then
                destroyElement(Map.RenderTargetBG)
                Map.RenderTargetBG = false
            end

        end

        Map.DrawingMap = false

    end
end

OnKey = function(key, state)
    local cx, cy = getCursorPosition()

    if (not cx) then
        return
    end

    cx, cy = cx * sW, cy * sH

    local CurrentMapSetting = Map.Styles['FullScreen']
    local Speed = 0.1
    if getKeyState('lshift') then
        Speed = 0.2
    elseif getKeyState('lctrl') then
        Speed = 0.05
    end

    if (key == 'mouse_wheel_up') then
        Map.Styles['FullScreen'].Zoom = math.min(1, CurrentMapSetting.Zoom + Speed)
    elseif (key == 'mouse_wheel_down') then
        Map.Styles['FullScreen'].Zoom = math.max(-0.5, CurrentMapSetting.Zoom - Speed)

    elseif (key == 'mouse1') then
        if state then

            Map.Styles['FullScreen'].Moving = {
                x = cx + Map.Styles['FullScreen']['Pos'].x,
                y = cy + Map.Styles['FullScreen']['Pos'].y,
            }

        else
            Map.Styles['FullScreen'].Moving = false

        end

    elseif (key == 'mouse2') and state then

        local posX = Map.Styles['FullScreen']['Pos'].x
        local posY = Map.Styles['FullScreen']['Pos'].y

        local Zoom = Map.Styles['FullScreen']['Zoom']
        local MapSize = Map.Styles['FullScreen']['Size']

        local Sx = (sW - MapSize) / 2
        local Sy = (sH - MapSize) / 2

        local MapX = (Sx - posX) - (MapSize * Zoom) / 2
        local MapY = (Sy - posY) - (MapSize * Zoom) / 2

        local worldX = ReMap(cx, MapX, MapX + MapSize + (MapSize * Zoom), -Map.Bounds, Map.Bounds)
        local worldY = ReMap(cy, MapY, MapY + MapSize + (MapSize * Zoom), Map.Bounds, -Map.Bounds)

        local found = false
        for k, v in ipairs(Map.Targets) do
            local x, y, z = getElementPosition(v)
            if getDistanceBetweenPoints3D(worldX, worldY, 0, x, y, z) <= 200 then
                table.remove(Map.Targets, k)
                destroyElement(v)
                found = true
            end
        end

        if found or (#Map.Targets >= 3) then
            return
        end

        local blip = createBlip(worldX, worldY, 0, 41)
        table.insert(Map.Targets, blip)

    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    local myPositions = {}
    for k, v in ipairs(Map.Targets) do
        local x, y = getElementPosition(v)
        table.insert(myPositions, {x, y})
    end
    exports['stoneage_settings']:setConfig('customBlips', toJSON(myPositions))
end)
