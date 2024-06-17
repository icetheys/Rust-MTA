local death = {lastAliveTime, reason, weaponUsed, cama}

local deathHover = nil
local onClick

function toggleDeathScreen(state, options)
    if state then
        addEventHandler('onClientRender', root, drawDeathScreen)
        addEventHandler('onClientClick', root, onClick)
        death = options
        fadeCamera(false, 0)
        deathHover = nil
        setElementData(localPlayer, 'bleeding', 0)
        activeUI = true
    else
        activeUI = nil
        removeEventHandler('onClientRender', root, drawDeathScreen)
        removeEventHandler('onClientClick', root, onClick)
        setElementData(localPlayer, 'blood', math.random(12000, 15000))
        death = nil
        fadeCamera(true)
    end
    showChat(not state)
    showCursor(state)
end

function drawDeathScreen()
    local heightBars = pixels(150)

    -- TOP
    dxDrawRectangle(0, 0, sW, heightBars, predefinedColor('death:color1'))
    local iconW = heightBars * 0.75
    dxDrawRectangle(heightBars / 2, heightBars / 2 - iconW / 2, iconW, iconW, predefinedColor('menu:color1'))
    dxDrawImage(heightBars / 2, heightBars / 2 - iconW / 2, iconW, iconW, getTexture('logo.png'))
    dxDrawText('MORTO', iconW + heightBars / 1.5, 0, sW, heightBars, predefinedColor('menu:color2'), 1, font('franklin:big'), 'left', 'center')

    local toShow = {{
        what = death.lastAliveTime,
        header = 'VOCE ESTAVA VIVO POR',
        color = predefinedColor('death:color2'),
    }, {
        what = death.reason,
        header = 'E ENTAO FOI MORTO POR',
        color = predefinedColor('death:color3'),
    }, {
        what = death.weaponUsed,
        header = 'UTILIZANDO',
        color = predefinedColor('death:color4'),
    }}

    local w, h
    local x = pixels(500)

    for i = 1, #toShow do
        local arr = toShow[i]
        if arr.what then
            local dist = pixels(100)

            if i > 1 then
                dxDrawLine(x - dist * 0.75, y + h / 2, x - dist * 0.25, y + h / 2, tocolor(255, 255, 255, 255), pixels(1))
            end

            local headerW, headerH = dxGetTextSize(arr.header, 0, 1.5, 1, font('franklin'))
            
            if (type(headerW) == 'table') then
                headerW, headerH = unpack(headerW)
            end

            local textW, textH = dxGetTextSize(arr.what, 0, 1, 1, font('franklin:medium'))
            
            if (type(textW) == 'table') then
                textW, textH = unpack(textW)
            end

            w, h = math.max(headerW, textW), textH
            y = (heightBars / 2) - (h / 2) + (headerH / 2)
            dxDrawText(arr.header, x, y - headerH, w, h, predefinedColor('menu:color2'), 1, font('franklin'), 'left', 'top')
            dxDrawRectangle(x, y, w, h, arr.color)
            dxDrawText(arr.what, x, y, x + w, y + h, predefinedColor('menu:color2'), 1, font('franklin:medium'), 'center', 'center')

            x = x + w + dist
        end
    end

    -- MAP IN THE MIDDLE
    local imgWidth = sH - heightBars * 2

    local imgX = sW / 2 - imgWidth / 2
    local imgY = sH / 2 - imgWidth / 2

    dxDrawRectangle(0, heightBars, sW, sH - heightBars, tocolor(102, 170, 213, 255))
    dxDrawImage(imgX, imgY, imgWidth, imgWidth, getTexture('ui/map-low-res.png'), 0, 0, 0, tocolor(255, 255, 255, 200))

    local x, y = unpack(death.position)

    x = imgX + (x + 3000) * imgWidth / 6000
    y = imgY + (3000 - y) * imgWidth / 6000

    local blipSize = pixels(5)
    dxDrawCircle(x, y, blipSize + pixels(2), 0, 360, predefinedColor('menu:color1'), predefinedColor('menu:color2'), 24)
    dxDrawBorderedText('Você morreu aqui', x, y, 0, 0, predefinedColor('menu:color2'), 1, font('franklin'), 'left', 'top', clip, wordBreak, postGUI,
                       colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY, predefinedColor('menu:color1'))

    dxDrawRectangle(0, sH - heightBars, sW, heightBars, predefinedColor('death:color1'))

    local now = getTickCount()
    local initial = death.startTick
    local passed = now - initial
    local restante = getGamePlayConfig('deadTime') - passed

    if restante >= 0 then
        local str = ('Aguarde %i segundos para respawnar'):format(restante / 1000)
        dxDrawText(str, 0, sH - heightBars, sW, sH, predefinedColor('menu:color2'), 1, font('franklin:big'), 'center', 'center')
    else
        local w, h = pixels(275), pixels(85)
        local padding = 0

        -- VIP SPAWNS
        if isVIP(localPlayer) then
            local spawnPositions = getAllAvaliablePlayerSpawns()
            for i = 1, #spawnPositions do
                local x = sW - (heightBars / 2) - w
                local y = heightBars + pixels(5) + (h * (i - 1))
                padding = 0
                local spawnName = spawnPositions[i].name

                if isHover(x, y, w, h) then
                    padding = pixels(2)

                    local spawns = spawnPositions[i].positions
                    for i = 1, #spawns do
                        local x, y = unpack(spawns[i])
                        x = imgX + (x + 3000) * imgWidth / 6000
                        y = imgY + (3000 - y) * imgWidth / 6000

                        local blipSize = pixels(5)
                        dxDrawCircle(x, y, blipSize + pixels(2), 0, 360, predefinedColor('menu:color2'), predefinedColor('menu:color1'), 24)
                    end
                    deathHover = spawnName
                else
                    if deathHover == spawnName then
                        deathHover = nil
                    end
                end
                drawRespawnButton(x + padding / 2, y + padding / 2, w - padding, h - padding, spawnPositions[i].name,
                                  'Spawn customizado exclusivo para VIPS', getTexture('ui/vip.png'), predefinedColor('menu:color1'))
            end
        end

        -- BOTTOM BUTTONS
        local y = sH - (heightBars / 2) - h / 2
        local x = sW - (heightBars / 2) - w
        padding = 0
        if isHover(x, y, w, h) then
            padding = pixels(2)
            deathHover = 'random spawn'
        else
            if deathHover == 'random spawn' then
                deathHover = nil
            end
        end
        drawRespawnButton(x + padding / 2, y + padding / 2, w - padding, h - padding, 'RESPAWN', 'VOCÊ IRÁ RESPAWNAR EM UM LOCAL ALEATÓRIO',
                          getTexture('ui/reload.png'), predefinedColor('death:color2'))

        local x = (heightBars / 2)
        padding = 0

        local header = 'CAMA'

        if isHover(x, y, w, h) then
            padding = pixels(2)
            deathHover = 'spawn cama'
        else
            if deathHover == 'spawn cama' then
                deathHover = nil
            end
        end

        drawRespawnButton(x + padding / 2, y + padding / 2, w - padding, h - padding, header, 'VOCÊ PODE RESPAWNAR UMA VEZ A CADA 10 MINUTOS',
                          getTexture('objects/cama.png'), predefinedColor('death:color2'))

    end
end

function drawRespawnButton(x, y, w, h, header, text, icon, color)
    dxDrawRectangle(x, y, w, h, color)
    dxDrawRectangleBorders(x, y, w, h, predefinedColor('menu:color2'))
    local circleWidth = h / 2 - pixels(10)
    local circleY = y + h / 2
    local circleX = x + circleWidth / 2

    dxDrawCircle(circleX, circleY, circleWidth + pixels(2), 0, 360, predefinedColor('menu:color2'), predefinedColor('menu:color2'), 32)
    dxDrawCircle(circleX, circleY, circleWidth, 0, 360, color, color, 32)

    dxDrawImage(circleX - circleWidth, circleY - circleWidth, circleWidth * 2, circleWidth * 2, icon, 0, 0, 0, tocolor(255, 255, 255, 200))

    local headerW, headerH = dxGetTextSize(header, 0, 1, 0.8, font('franklin:medium'))
    
    if (type(headerW) == 'table') then
        headerW, headerH = unpack(headerW)
    end

    dxDrawText(header, circleX + circleWidth + pixels(3), y, x + w, 0, predefinedColor('menu:color2'), 1, font('franklin:medium'), 'center', 'top')
    dxDrawText(text, circleX + circleWidth + pixels(3), y + headerH, x + w, y + h, predefinedColor('menu:color2'), 1, font('franklin'), 'center',
               'top', true, true)
end

local lastClick = 0
function onClick(btn, state)
    if btn == 'left' and state == 'down' then
        local where = deathHover
        if where and death then
            if ((getTickCount() - lastClick) <= 1000) then
                return
            end
            lastClick = getTickCount()
            local x, y, z = getRandomSpawnPos(where)
            if (where == 'spawn cama') then
                triggerServerEvent('onPlayerSpawnAtBed', localPlayer, cama)
            else
                toggleDeathScreen(false)
                triggerServerEvent('player:onSpawn', localPlayer, x, y, z, getElementModel(localPlayer))
            end
        end
    end
end

addEventHandler('rust:onClientPlayerDie', localPlayer, function(reason, weaponUsed, alivetime, cama)
    setTimer(function()
        local options = {
            lastAliveTime = ('%02d minutos'):format(alivetime or 0),
            reason = reason,
            weaponUsed = weaponUsed,
            position = {getElementPosition(localPlayer)},
            startTick = getTickCount(),
        }
        toggleDeathScreen(true, options)
    end, 1500, 1)
end)

HideDeathScreen = function()
    toggleDeathScreen(false)
end
loadEvent('HideDeathScreen', localPlayer, HideDeathScreen)
