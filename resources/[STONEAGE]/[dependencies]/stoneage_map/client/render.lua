RenderF11 = function()

    if ((not getElementData(localPlayer, 'account')) or getElementData(localPlayer, 'isDead')) then
        return
    end

    local PostGUI = true

    local Zoom = Map.Styles['FullScreen']['Zoom']
    local MapSize = Map.Styles['FullScreen']['Size']

    local BlipSize = 12
    BlipSize = BlipSize * (Zoom + 1)

    local Sx = (sW - MapSize) / 2
    local Sy = (sH - MapSize) / 2

    dxDrawRectangle(0, 0, sW, sH, tocolor(110, 158, 204), PostGUI)

    if (Map.Styles['FullScreen']['Moving']) then
        local cx, cy = getCursorPosition()
        cx, cy = cx * sW, cy * sH

        local newX = Map.Styles['FullScreen']['Moving'].x - cx
        local newY = Map.Styles['FullScreen']['Moving'].y - cy

        Map.Styles['FullScreen']['Pos'].x = math.min(MapSize / 2, math.max(newX, -MapSize / 2))
        Map.Styles['FullScreen']['Pos'].y = math.min(MapSize / 2, math.max(newY, -MapSize / 2))
    end

    local posX = Map.Styles['FullScreen']['Pos'].x
    local posY = Map.Styles['FullScreen']['Pos'].y

    local MapX = (Sx - posX) - (MapSize * Zoom) / 2
    local MapY = (Sy - posY) - (MapSize * Zoom) / 2

    dxDrawImage(MapX, MapY, MapSize + (MapSize * Zoom), MapSize + (MapSize * Zoom), GetTexture('assets/map.png'), 0, 0, 0, tocolor(255, 255, 255),
                true)

    for k, v in ipairs(getElementsByType('blip')) do
        local x, y, z = getElementPosition(v)
        local BlipIcon = getBlipIcon(v)

        local BlipSize = (BlipIcon == 0 and getBlipSize(v) <= 1 and 6) or 12

        if CustomBlipSizes[BlipIcon] then
            BlipSize = CustomBlipSizes[BlipIcon] + 4
        end

        BlipSize = BlipSize * (Zoom + 1)

        local r, g, b, a = 255, 255, 255, 255

        x = ReMap(x, -Map.Bounds, Map.Bounds, MapX, MapX + MapSize + (MapSize * Zoom))
        y = ReMap(y, Map.Bounds, -Map.Bounds, MapY, MapY + MapSize + (MapSize * Zoom))

        if (BlipIcon == 0) then
            local _, _, pz = getElementPosition(localPlayer)
            if (pz - z < -5) then
                BlipIcon = 'assets/blips/down.png'
            elseif (pz - z >= 5) then
                BlipIcon = 'assets/blips/up.png'
            else
                BlipIcon = 'assets/blips/square.png'
            end
            r, g, b, a = getBlipColor(v)
        else
            BlipIcon = ('assets/blips/%02d.png'):format(BlipIcon)
        end

        if getElementData(v, 'piscar') then
            a = (getTickCount() % 2550) / 10 
        end

        dxDrawImage(x - BlipSize / 2, y - BlipSize / 2, BlipSize, BlipSize, GetTexture(BlipIcon), 0, 0, 0, tocolor(r, g, b, a), PostGUI)

        local str = GetBlipHeader(v)
        if str then
            local w = dxGetTextWidth(str, 1, 'default-bold')
            local TextX = (x - w / 2)
            local TextY = y - BlipSize * 2
            dxDrawText(str, TextX + 2, TextY + 2, TextX + w, y, tocolor(0, 0, 0), 1, 'default-bold', 'center', 'center', false, false, true)
            dxDrawText(str, TextX, TextY, TextX + w, y, tocolor(r, g, b), 1, 'default-bold', 'center', 'center', false, false, true)
        end
    end

    local x, y = getElementPosition(localPlayer)
    local _, _, rot = getElementRotation(localPlayer)
    x = ReMap(x, -Map.Bounds, Map.Bounds, MapX, MapX + MapSize + (MapSize * Zoom))
    y = ReMap(y, Map.Bounds, -Map.Bounds, MapY, MapY + MapSize + (MapSize * Zoom))

    dxDrawImage(x - BlipSize / 2, y - BlipSize / 2, BlipSize, BlipSize, GetTexture('assets/blips/02.png'), -rot, 0, 0, tocolor(255, 255, 255), PostGUI)
end

GetBlipHeader = function(blip)
    if (getElementType(blip) == 'blip') then
        local customText = getElementData(blip, 'BlipName')
        if customText then 
            return customText
        else
            local Attached = getElementAttachedTo(blip)
            if isElement(Attached) then
                if getElementType(Attached) == 'player' then
                    return getPlayerName(Attached)
                elseif getElementType(Attached) == 'vehicle' then
                    return getVehicleName(Attached)
                end
            end
        end
    end
    return false
end

CustomBlipSizes = {
    [6] = 16,
    [19] = 16,
}

local lastRefresh = 0
RenderGPS = function()
    if ((not getElementData(localPlayer, 'account')) or getElementData(localPlayer, 'isDead')) then
        return
    end

    local PostGUI = false
    
    local Zoom = Map.Styles['GPS']['Zoom']
    local MapSize = Map.Bounds / Zoom

    local px, py = getElementPosition(localPlayer)

    local DrawX = 5
    local DrawSize = Map.Styles['GPS']['Size']
    local DrawY = sH - DrawX - DrawSize

    local MapX = -(ReMap(px, -Map.Bounds, Map.Bounds, 0, MapSize) - DrawSize / 2)
    local MapY = -(ReMap(py, Map.Bounds, -Map.Bounds, 0, MapSize) - DrawSize / 2)

    local CameraX, CameraY, _, LookX, LookY = getCameraMatrix()
    local RotationX = FindRotation(CameraX, CameraY, LookX, LookY)
    local RotationY = ((-MapSize / 2) - MapX) + (DrawSize / 2)
    local RotationZ = ((-MapSize / 2) - MapY) + (DrawSize / 2)

    local BlipSize = 8

    local px, py, pz = getElementPosition(localPlayer)

    BlipSize = BlipSize * (Zoom + 1)

    if (getTickCount() - lastRefresh) >= 10 then
        lastRefresh = getTickCount()
        dxSetRenderTarget(Map.RenderTarget, true)
        dxDrawImage(MapX, MapY, MapSize, MapSize, GetTexture('assets/map.png'), RotationX, RotationY, RotationZ)

        for k, v in ipairs(getElementsByType('blip', root, true)) do
            local x, y, z = getElementPosition(v)
            local MapDistance = getDistanceBetweenPoints2D(px, py, x, y)

            if (MapDistance <= DrawSize * 2) then
                local Distance = MapDistance / (Map.Bounds*2 / MapSize)

                local BlipRotation = FindRotation(x, y, px, py) - RotationX;
                local BlipX, BlipY = GetPointFromDistanceRotation(DrawSize / 2, DrawSize / 2, min(Distance, DrawSize * 2), BlipRotation)
                local BlipIcon = getBlipIcon(v)

                local BlipSize = (BlipIcon == 0 and getBlipSize(v) <= 1 and 4) or 8
               
                if CustomBlipSizes[BlipIcon] then
                    BlipSize = CustomBlipSizes[BlipIcon]
                end

                BlipSize = BlipSize * (Zoom + 1)

                local r, g, b, a = 255, 255, 255, 255
                if (BlipIcon == 0) then
                    if (pz - z < -5) then
                        BlipIcon = 'assets/blips/down.png'
                    elseif (pz - z >= 5) then
                        BlipIcon = 'assets/blips/up.png'
                    else
                        BlipIcon = 'assets/blips/square.png'
                    end
                    r, g, b, a = getBlipColor(v)
                else
                    BlipIcon = ('assets/blips/%02d.png'):format(BlipIcon)
                end
                
                if getElementData(v, 'piscar') then
                    a = (getTickCount() % 2550) / 10 
                end

                dxDrawImage(BlipX - BlipSize / 2, BlipY - BlipSize / 2, BlipSize, BlipSize, GetTexture(BlipIcon), 0, 0, 0, tocolor(r, g, b, a))
            end
        end

        dxDrawImage((DrawSize - BlipSize) / 2, (DrawSize - BlipSize) / 2, BlipSize, BlipSize, GetTexture('assets/blips/02.png'))
        dxSetRenderTarget()
    end

    dxSetRenderTarget(Map.RenderTargetBG)
    dxDrawRectangle(0, 0, DrawSize, DrawSize, tocolor(110, 158, 204), PostGUI)
    dxSetRenderTarget()

    dxDrawImage(DrawX, DrawY, DrawSize, DrawSize, Map.MaskShaderBG)
    dxDrawImage(DrawX, DrawY, DrawSize, DrawSize, Map.MaskShader)
end

addEventHandler('onClientRender', root, function()
    local px, py, pz = getElementPosition(localPlayer)
    if (getElementData(localPlayer, 'Map') or 0) > 0 then
        for k, v in ipairs(Map.Targets) do
            local x, y, z = getElementPosition(v)
            local groundZ = getGroundPosition(x, y, 500)
            if groundZ then
                z = groundZ + 1
            else
                z = pz
            end
            local sx, sy = getScreenFromWorldPosition(x, y, z)
            if (sx and sy) then
                local str = ('%im'):format(getDistanceBetweenPoints3D(x, y, z, px, py, pz))
                dxDrawBorderedText(str, sx, sy, 0, 0, tocolor(200, 200, 200), 1, 'default-bold')
            end
        end
    end
end)

