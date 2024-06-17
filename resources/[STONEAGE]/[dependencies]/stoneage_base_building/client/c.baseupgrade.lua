BaseUpgrade = {}

local Font = dxCreateFont('assets/regular2.ttf', sH * 0.05)
local Font2 = dxCreateFont('assets/regular2.ttf', sH * 0.025)

ToggleBaseUpgrade = function(state, ob, possibleEvolves)
    if state then
        if (not isElement(ob)) or (type(possibleEvolves) ~= 'table') then
            return false
        end

        BaseUpgrade.DisplayItems = {}

        for k, v in ipairs(possibleEvolves) do
            table.insert(BaseUpgrade.DisplayItems, {
                ItemName = v,
                Translated = exports['stoneage_translations']:translate(v, 'name'),
                Cost = exports['gamemode']:getObjectCustoString(v, 0.5, localPlayer),
                Level = (exports['gamemode']:getObjectDataSetting(v, 'objLevel') or 1)
            })
        end

        table.insert(BaseUpgrade.DisplayItems, 'Cancelar')

        BaseUpgrade.DisplayQuant = #BaseUpgrade.DisplayItems
        BaseUpgrade.SelectedOptionID = 1
        BaseUpgrade.Object = ob
        BaseUpgrade.ObjectName = obName
        BaseUpgrade.lastChangeTick = getTickCount()
        BaseUpgrade.OpeningTick = getTickCount()
        BaseUpgrade.Lambda = 360 / BaseUpgrade.DisplayQuant

        showCursor(true)
        setCursorPosition(sW / 2, sH / 2)

        addEventHandler('onClientRender', root, renderBaseUpgrade)
        addEventHandler('onClientClick', root, BaseUpgrade.onClick)

    else

        showCursor(false)
        removeEventHandler('onClientRender', root, renderBaseUpgrade)
        removeEventHandler('onClientClick', root, BaseUpgrade.onClick)

    end
end

BaseUpgrade.onClick = function(key, state)
    if (key ~= 'left') or (state ~= 'down') then
        return
    end

    if (getTickCount() - BaseUpgrade.OpeningTick <= 500) then
        return
    end

    local selectedID = BaseUpgrade.SelectedOptionID
    
    if selectedID then
        local itemInList = BaseUpgrade.DisplayItems[selectedID]
        
        local newItemName = itemInList and itemInList.ItemName
        if newItemName then
            if getElementData(localPlayer, 'WaitingResponse') then
                return
            end

            setElementData(localPlayer, 'WaitingResponse', true)
            
            triggerServerEvent('craft:evolveObject', localPlayer, BaseUpgrade.Object, newItemName)
            ToggleBaseUpgrade(false)
        end
    end
end

renderBaseUpgrade = function()
    -- dxDrawBorderedText(inspect(BaseUpgrade), 1400, 400, 0, 0)

    local cx, cy = _getCursorPosition(true)
    if cx then
        if getDistanceBetweenPoints2D(cx, cy, sW / 2, sH / 2) >= sH * 0.2 then
            local section = findSection(cx, cy, BaseUpgrade.DisplayQuant)
            if section ~= BaseUpgrade.SelectedOptionID then
                if section == BaseUpgrade.DisplayQuant then
                    playSound('assets/click.wav')
                    ToggleBaseUpgrade(false)
                else
                    BaseUpgrade.SelectedOptionID = section
                    BaseUpgrade.lastChangeTick = getTickCount()
                end
            end
        end

        local selectedID = BaseUpgrade.SelectedOptionID

        local larg = interpolateBetween(floor(sH * 0.29), 0, 0, floor(sH * 0.305), 0, 0, (getTickCount() - BaseUpgrade.lastChangeTick) / 150,
                         'OutBounce')

        local scale = (360 / BaseUpgrade.DisplayQuant)

        local x, y = sW / 2, sH / 2

        -- borders
        dxDrawCircle(x, y, sH * 0.3, 0, 360, tocolor(210, 175, 200), tocolor(210, 175, 200), 128)

        -- selected part
        local startAngle = 270 + (selectedID * scale) - (scale / 2)
        local endAngle = startAngle + scale
        dxDrawCircle(x, y, larg, startAngle, endAngle, tocolor(200, 35, 35), tocolor(200, 35, 35), 128)

        -- center background
        dxDrawCircle(x, y, sH * 0.2, 0, 360, tocolor(40, 40, 40), tocolor(40, 40, 40), 128)

        for i = 1, BaseUpgrade.DisplayQuant do
            local radius = sH * 0.25
            local radAngle = rad((scale * i) - 90)
            local dx = radius * cos(radAngle)
            local dy = radius * sin(radAngle)

            local w = pixels(85)

            local x = (sW / 2) + dx - (w / 2)
            local y = (sH / 2) + dy - (w / 2)

            local selectedSetting = BaseUpgrade.DisplayItems[i]

            local icon = selectedSetting.Level and getTexture('assets/images/upgrades/' .. selectedSetting.Level .. '.png')

            if i == BaseUpgrade.SelectedOptionID then

                local offset = pixels(30)
                w = w + offset
                x = x - offset / 2
                y = y - offset / 2

                local topY = sH / 2 - sH * 0.1
                local bottomY = sH / 2 + sH * 0.2
                local leftX = sW / 2 - sH * 0.15
                local rightX = sW / 2 + sH * 0.15

                local displayNameW, displayNameH = dxGetTextSize(selectedSetting.Translated, rightX - leftX, 1, 1, Font2, true)

                if (type(displayNameW) == 'table') then
                    displayNameW, displayNameH = unpack(displayNameW)
                end

                dxDrawText(selectedSetting.Translated, leftX, topY, rightX, bottomY, tocolor(210, 175, 200), 1, Font2, 'center', 'top', true, true)

                dxDrawImage(sW / 2 - w / 2, topY + displayNameH, w, w, icon, 0, 0, 0, tocolor(210, 175, 200))

                dxDrawText(selectedSetting.Cost, leftX, topY + displayNameH + w, rightX, bottomY, tocolor(210, 175, 200), 1.5, 'default-bold',
                    'center', 'center', true, true)

                dxDrawImage(x, y, w, w, icon, 0, 0, 0, tocolor(210, 175, 200))

            else
                if i == BaseUpgrade.DisplayQuant then
                    dxDrawText('X', x, y, x + w, y + w, tocolor(200, 35, 35), 1, Font, 'center', 'center', true, true)
                else
                    dxDrawImage(x, y, w, w, icon, 0, 0, 0, tocolor(200, 35, 35))
                end
            end
        end
    end
end

local Init = function()
    local x, y, z = getElementPosition(localPlayer)
    ToggleBaseUpgrade(true, getElementsWithinRange(x, y, z, 2, 'object')[1])
end
addEventHandler('onClientResourceStart', resourceRoot, Init)
