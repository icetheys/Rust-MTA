RenderInteractionUI = function()
    local x, y = CENTER_X, CENTER_Y
    if (Interaction.SelectedObject == localPlayer) then
        x, y = getScreenFromWorldPosition(getPedBonePosition(localPlayer, 25))
    end

    if (not x) or (not y) then
        x, y = CENTER_X, CENTER_Y
    end

    if (Interaction.DisplayQuantity > 0) then
        local scale = 360 / Interaction.DisplayQuantity

        local larg = interpolateBetween(CIRCLE_RADIUS * 0.95, 0, 0, CIRCLE_RADIUS * 1.02, 0, 0,
                                        (getTickCount() - (Interaction.LastChangeTick or 0)) / 250, 'OutBounce')

        local Radius = interpolateBetween(CIRCLE_RADIUS * 0.98, 0, 0, CIRCLE_RADIUS, 0, 0, (getTickCount() - (Interaction.LastChangeTick or 0)) / 150,
                                          'OutBounce')
        -- borders
        dxDrawCircle(x, y, Radius, 0, 360, tocolor(210, 175, 200), tocolor(210, 175, 200, 0), 128)

        -- selected part
        local startAngle = 270 + ((Interaction.SelectedOptionID - 1) * scale) - (scale / 2)
        local endAngle = startAngle + scale
        dxDrawCircle(x, y, larg, startAngle, endAngle, tocolor(200, 35, 35), tocolor(200, 35, 35, 0), 128)

        -- center background
        dxDrawCircle(x, y, Radius * BORDER_RADIUS, 0, 360, tocolor(40, 40, 40), tocolor(40, 40, 40, 0), 128)

        for i = 1, Interaction.DisplayQuantity do
            local w = (Radius - (Radius * BORDER_RADIUS)) * 0.75

            local radius = math.min(larg, CIRCLE_RADIUS) - w * 0.7

            local radAngle = rad((scale * (i - 1)) - 90)
            local dx = radius * cos(radAngle)
            local dy = radius * sin(radAngle)

            local posX = x + dx - (w / 2)
            local posY = y + dy - (w / 2)

            local optionSettings = Interaction.DisplayOptions[i].options

            local icon = getTexture(optionSettings.Icon)

            if i == Interaction.SelectedOptionID then
                do
                    local w = (CIRCLE_RADIUS * BORDER_RADIUS) * 1.5
                    local x = x - w / 2
                    local y = y - w / 2

                    local fontSize = interpolateBetween(0.98, 0, 0, 1, 0, 0, (getTickCount() - (Interaction.LastChangeTick or 0)) / 250, 'OutBounce')

                    if Interaction.Header then
                        local www, h = dxGetTextSize(Interaction.Header, w, fontSize, fontSize, Interaction.Fonts.Header, true)

                        if (type(www) == 'table') then
                            www, h = unpack(www)
                        end

                        dxDrawText(Interaction.Header, x, y, x + w, y + h, tocolor(210, 175, 200), fontSize, Interaction.Fonts.Header, 'center',
                                   'bottom', true, true)

                        dxDrawText(optionSettings.Name, x + 5, y + h, x + w, y + w - 5, tocolor(210, 175, 200), fontSize,
                                   Interaction.Fonts.Description, 'center', 'bottom', true, true)

                    else
                        dxDrawText(optionSettings.Name, x, y, x + w, y + w, tocolor(210, 175, 200), fontSize, Interaction.Fonts.Description, 'center',
                                   'bottom', true, true)
                    end
                end

                dxDrawImage(posX, posY, w, w, icon, 0, 0, 0, tocolor(210, 175, 200))
            else
                dxDrawImage(posX, posY, w, w, icon, 0, 0, 0, tocolor(200, 35, 35))
            end
        end
    else
        local allowed_slots = {
            [0] = true,
            [1] = true
        }
        if Interaction.Header and allowed_slots[getPedWeaponSlot(localPlayer)] then
            local textW = dxGetTextWidth(Interaction.Header, 1, Interaction.Fonts.Header)
            -- dxDrawText(Interaction.Header, x - textW + 2, y + 6, x + textW - 1, 0, tocolor(250, 30, 30, 100), 1, Interaction.Fonts.Header2, 'center')
            dxDrawText(Interaction.Header, x - textW, y + 5, x + textW, 0, tocolor(210, 175, 200), 1, Interaction.Fonts.Header2, 'center')
        end
    end
end
