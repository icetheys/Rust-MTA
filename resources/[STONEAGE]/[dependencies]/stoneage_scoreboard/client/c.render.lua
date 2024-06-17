Font1 = 'default-bold'
Font2 = 'default-bold'

Render = function()
    local w, h = getScoreBoardSize()
    local x, y = (sW - w) / 2, (sH - h) / 2

    local alpha = interpolateBetween(0, 0, 0, 150, 0, 0, (getTickCount() - OpenTick) / 550, 'Linear')

    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 150))
    dxDrawRectangle(x, y, w, 20, tocolor(0, 0, 0, 150))

    dxDrawText(Scoreboard.ServerName, x, y, x + w, y + 20, tocolor(200, 200, 200, alpha), 1, Font1, 'center', 'center', true, true)

    dxDrawRectangle(x, y + h - 20, w, 20, tocolor(0, 0, 0, 150))

    local str = ('%s/%s'):format(#getElementsByType('player'), Scoreboard.MaxPlayers)
    dxDrawText(str, x, y, x + w - 5, y + 20, tocolor(200, 200, 200, alpha), 1, Font1, 'right', 'center', true, true)

    dxDrawText(Scoreboard.Info, x, y + h - 20, x + w, y + h, tocolor(200, 200, 200, alpha), 1, Font1, 'center', 'center', true, true)

    do
        local x = x
        local mainY = y

        for k, v in ipairs(Scoreboard.Columns) do
            local width = (w * v.Width)
            local y = y + 20 + 20

            dxDrawText(v.Header, x, y - 20, x + width, y, tocolor(200, 200, 200, alpha), 1.2, Font2, 'center', 'center', false, false)
            dxDrawLine(x, y, x + width, y, tocolor(200, 200, 200, 20))

            -- dxDrawLine(x+width, 0, x + width, sH)
            -- dxDrawLine(x, 0, x, sH)

            local displayQuantity = 0

            local Display = getDisplayItems()
            local total = #Display
            Scoreboard.RenderingLast = false

            for id, values in ipairs(Display) do
                local displayY = y + 20 * (id - Scoreboard.Scroll - 1)
                if (displayY >= y) then
                    local displayText = values.Values[v.Header][1]
                    local colored = values.Values[v.Header][2]

                    if (values.Player == localPlayer) then
                        dxDrawRectangle(x, displayY, width, 20, tocolor(0, 0, 0, 200))
                    end

                    local str = (v.Header == '#' and id or displayText)
                    dxDrawText(str, x, displayY, x + width, displayY + 20, tocolor(200, 200, 200, alpha), 1, 'default-bold', 'center', 'center', true,
                               false, false, colored)

                    dxDrawLine(x, displayY + 20, x + width, displayY + 20, tocolor(200, 200, 200, 20))

                    displayQuantity = displayQuantity + 1
                end

                if id == total then
                    Scoreboard.RenderingLast = true
                end

                if (displayY > (mainY + h - 60)) then
                    break
                end
            end
            x = x + width
        end
    end
end

