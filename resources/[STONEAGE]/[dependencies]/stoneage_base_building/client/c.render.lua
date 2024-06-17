local Font2 = dxCreateFont('assets/regular2.ttf', sH * 0.025)

Craft.Render = function()
    if Craft.DrawingUI then
        Craft.DrawUI()
    else
        if Craft.SavingTick then
            Craft.DrawSaveProgress()
        else
            Craft.SyncObjectPosition()
        end
    end
end

Craft.DrawUI = function()
    local cx, cy = _getCursorPosition(true)
    if cx then
        if getDistanceBetweenPoints2D(cx, cy, sW / 2, sH / 2) >= sH * 0.21 then
            local section = findSection(cx, cy, Craft.DisplayQuant)
            if section ~= Craft.SelectedOptionID then
                playSound('assets/click.wav')
                Craft.lastChangeTick = getTickCount()
                if Craft.Object then
                    local obName = ('%s de Palito'):format(Craft.DisplayOrder[section].name)
                    local model = exports['gamemode']:getObModel(obName)
                    if model then
                        setElementModel(Craft.Object, model)
                        highlightObject2(Craft.Object, 255, 0, 0, 200)

                        Craft.ObjectName = obName
                        Craft.ObjectType = exports['gamemode']:getObjectDataSetting(obName, 'Type')
                        Craft.TranslatedObjectName = exports['stoneage_translations']:translate(obName, 'name')
                        Craft.CustoString = exports['gamemode']:getObjectCustoString(obName, 1, localPlayer)
                        Craft.Limit = exports['gamemode']:getObjectLimit(obName, localPlayer)
                    end
                    Craft.SelectedOptionID = section
                end
            end
        end

        local selectedID = Craft.SelectedOptionID - 3

        local x, y = sW / 2, sH / 2
        -- borders
        dxDrawCircle(x, y, sH * 0.32, 0, 360, tocolor(210, 175, 200), tocolor(210, 175, 200), 64)

        local larg = interpolateBetween(floor(sH * 0.295), 0, 0, floor(sH * 0.33), 0, 0, (getTickCount() - (Craft.lastChangeTick or 0)) / 150,
                                        'OutBounce')

        local scale = 360 / Craft.DisplayQuant

        -- selected part
        dxDrawCircle(x, y, larg, selectedID * scale - scale, selectedID * scale, tocolor(200, 35, 35), tocolor(200, 35, 35), 64)

        -- center background
        dxDrawCircle(x, y, sH * 0.22, 0, 360, tocolor(40, 40, 40), tocolor(40, 40, 40), 64)

        for i = 1, Craft.DisplayQuant do
            local radius = sH * 0.27
            local radAngle = rad((Craft.Lambda * i) - 90)
            local dx = radius * cos(radAngle)
            local dy = radius * sin(radAngle)

            local w = pixels(85)

            local x = (sW / 2) + dx - (w / 2)
            local y = (sH / 2) + dy - (w / 2)

            local icon = getTexture(Craft.DisplayOrder[i].icon)
            if i == Craft.SelectedOptionID then
                local offset = pixels(30)
                w = w + offset
                x = x - offset / 2
                y = y - offset / 2

                local topY = sH / 2 - sH * 0.1
                local bottomY = sH / 2 + sH * 0.2
                local leftX = sW / 2 - sH * 0.15
                local rightX = sW / 2 + sH * 0.15

                local displayNameW, displayNameH = dxGetTextSize(Craft.TranslatedObjectName, rightX - leftX, 1, 1, Font2, true)

                if (type(displayNameW) == 'table') then
                    displayNameW, displayNameH = unpack(displayNameW)
                end

                dxDrawText(Craft.TranslatedObjectName, leftX, topY, rightX, bottomY, tocolor(210, 190, 175, 200), 1, Font2, 'center', 'top', true,
                           true)

                dxDrawImage(sW / 2 - w / 2, topY + displayNameH, w, w, icon, 0, 0, 0, tocolor(210, 190, 175, 200))

                local atual = getElementData(localPlayer, 'baseItems') or 0
                local desc = ('%s\n(%i/%i)'):format(Craft.CustoString, atual, Craft.Limit)
                dxDrawText(desc, leftX, topY + displayNameH + w, rightX, bottomY, tocolor(210, 190, 175, 200), 1.5, 'default-bold', 'center',
                           'center', true, true)

                dxDrawImage(x, y, w, w, icon, 0, 0, 0, tocolor(210, 175, 200, 200))
            else
                dxDrawImage(x, y, w, w, icon, 0, 0, 0, tocolor(200, 35, 35, 250))
            end
        end
    end
end

Craft.DrawSaveProgress = function()
    if isElement(Craft.Object) then
        local x, y, z = getElementPosition(Craft.Object)
        x, y = getScreenFromWorldPosition(x, y, z)
        if x then
            local h = pixels(150)
            dxDrawRing(x, y, h, pixels(35), 90, 1, tocolor(255, 255, 255, 15))

            local percent = (getTickCount() - Craft.SavingTick) / TIME_TO_SAVE_CRAFT
            dxDrawRing(x, y, h, pixels(35), 90, percent, tocolor(106, 127, 62, 200))
        end
    end
end
