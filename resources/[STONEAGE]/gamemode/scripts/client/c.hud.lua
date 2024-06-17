local hud = {}

local cpuUsage = {
    lastCheck,
    value = 0,
}

local topBarDisplay = {
    ['FPS'] = function()
        return ('%.2f'):format(getPlayerFPS())
    end,
    ['PING'] = function()
        return getPlayerPing(localPlayer)
    end,
    ['LOSS'] = function()
        return getNetworkStats()['packetlossLastSecond']
    end,
    ['VRAM'] = function()
        local stats = dxGetStatus()
        local total = stats.VideoCardRAM
        local atual = stats.VideoMemoryFreeForMTA
        local free = total - atual
        local percent = free * 100 / total
        return ('%s/%s (%i%%)'):format(free, total, percent)
    end,
    ['CPU'] = function()
        local now = getTickCount()
        local lastCheck = cpuUsage.lastCheck
        local value = cpuUsage.value

        if not lastCheck or (now - 5000 >= lastCheck) then
            local _, rows = getPerformanceStats('Lua timing')
            local tempValue = 0
            for i = 1, #rows do
                local thisValue = rows[i][2]
                if thisValue then
                    thisValue = utf8.gsub(thisValue, '%%', '')
                    if thisValue and tonumber(thisValue) then
                        tempValue = tempValue + tonumber(thisValue)
                    end
                end
            end
            cpuUsage.lastCheck = now
            cpuUsage.value = tempValue
        end
        return ('%.2f%%'):format(value)
    end,
}

local personalHUDDisplay = {
    {
        type = 'fome',
        display = 'horizontal',
        icon = 'ui/fome.png',
        draw = function(x, y, w, h, bg)
            hud.stats.fome.progress = UI:CreateProgressBar(x, y, w, h, 100, false, bg, {
                bgColor = {0, 0, 0, 0},
                hoverBgColor = {0, 0, 0, 0},
                hoverProgressColor = {168, 95, 43, 200},
                progressColor = {168, 95, 43, 200},
            })
            hud.stats.fome.text = UI:createText(x + 5, y, w - 10, h, '', false, bg, {
                ['text-align-x'] = 'left',
                font = cfont('futura'),
            })
            guiSetAlpha(hud.stats.fome.text, 0.65)
        end,
        update = function()
            local myPercent = getElementData(localPlayer, 'fome') or 0
            local str = ('%i%%'):format(myPercent, myPercent)
            guiSetText(hud.stats.fome.text, str)
            UI:setProgress(hud.stats.fome.progress, myPercent)
        end,
    },
    {
        type = 'sede',
        display = 'horizontal',
        icon = 'ui/sede.png',
        draw = function(x, y, w, h, bg)
            hud.stats.sede.progress = UI:CreateProgressBar(x, y, w, h, 100, false, bg, {
                bgColor = {0, 0, 0, 0},
                hoverBgColor = {0, 0, 0, 0},
                hoverProgressColor = {35, 95, 130, 200},
                progressColor = {35, 95, 130, 200},
            })
            hud.stats.sede.text = UI:createText(x + 5, y, w - 10, h, '', false, bg, {
                ['text-align-x'] = 'left',
                font = cfont('futura'),
            })
            guiSetAlpha(hud.stats.sede.text, 0.65)
        end,
        update = function()
            local myPercent = getElementData(localPlayer, 'sede') or 0
            local str = ('%i%%'):format(myPercent, myPercent)
            guiSetText(hud.stats.sede.text, str)
            UI:setProgress(hud.stats.sede.progress, myPercent)
        end,
    },
    {
        type = 'blood',
        display = 'horizontal',
        icon = 'ui/blood.png',

        draw = function(x, y, w, h, bg)
            hud.stats.blood.progress = UI:CreateProgressBar(x, y, w, h, 100, false, bg, {
                bgColor = {0, 0, 0, 0},
                hoverBgColor = {0, 0, 0, 0},
                hoverProgressColor = {106, 125, 65, 200},
                progressColor = {106, 125, 65, 200},
            })
            hud.stats.blood.text = UI:createText(x + 5, y, w - 10, h, '', false, bg, {
                ['text-align-x'] = 'left',
                font = cfont('futura'),
            })
            guiSetAlpha(hud.stats.blood.text, 0.65)
        end,

        update = function()
            local maxBlood = getPlayerDataSetting('blood', 'max')
            local myBlood = getElementData(localPlayer, 'blood') or maxBlood
            local percent = myBlood * 100 / maxBlood
            local str = ('%i'):format(myBlood)
            guiSetText(hud.stats.blood.text, str)
            UI:setProgress(hud.stats.blood.progress, percent)
        end,
    },
    {
        type = 'weapon',
        display = 'horizontal',
        icon = 'ui/arma.png',
        draw = function(x, y, w, h, bg)
            hud.stats.weapon.text = UI:createText(x + 5, y, w - 10, h, '', false, bg, {
                ['text-align-x'] = 'left',
                font = cfont('futura'),
            })
        end,
        update = function()
            local str = ''
            local myWeapon = getPedWeapon(localPlayer)
            local equippedWeapon = getElementData(localPlayer, 'equippedItem')
            if equippedWeapon then
                local weaponName = translate(equippedWeapon, 'name')

                local weaponAmmo = getPedAmmoInClip(localPlayer)
                local maxAmmo = getWeaponProperty(myWeapon, 'pro', 'maximum_clip_ammo')
                if maxAmmo then
                    str = ('%s (%i/%i)'):format(weaponName, weaponAmmo, maxAmmo)
                else
                    str = ('%s'):format(weaponName)
                end

            end
            guiSetText(hud.stats.weapon.text, str)
        end,
    },
    {
        type = 'exp',
        display = 'vertical',
        draw = function(x, y, w, h, bg)
            hud.stats.exp.progress = UI:CreateProgressBar(x, y, w, h, 100, false, bg, {
                bgColor = {0, 0, 0, 0},
                hoverBgColor = {0, 0, 0, 0},
                hoverProgressColor = {150, 150, 255, 200},
                progressColor = {150, 150, 255, 200},
                progressAlign = 'vertical',
            })
            hud.stats.exp.needed = UI:createText(0, 2, w, h - 2, '', false, bg, {
                ['text-align-y'] = 'top',
                font = cfont('futura'),
            })
            hud.stats.exp.atual = UI:createText(0, 2, w, h - 4, '', false, bg, {
                ['text-align-y'] = 'bottom',
                font = cfont('futura'),
            })
        end,
        update = function()
            local myExp = getElementData(localPlayer, 'Exp') or 0
            local myLevel = getElementData(localPlayer, 'Level') or 0
            local neededExp = getExpNeeded(myLevel)
            local percent = (myExp / neededExp) * 100
            UI:setProgress(hud.stats.exp.progress, percent)
            guiSetText(hud.stats.exp.needed, neededExp)
            guiSetText(hud.stats.exp.atual, ('%i'):format(myExp, percent))
        end,
    },
    stacks = {
        horizontal = 0,
        vertical = 0,
    },
}

local drawing = false
function toggleHUD(state)
    for k, v in ipairs(personalHUDDisplay) do
        if hud.stats then
            if hud.stats[v.type].bg then
                guiSetVisible(hud.stats[v.type].bg, state)
            end
        end
    end
    if state then
        if not drawing then
            addEventHandler('onClientRender', root, drawChangeData)
            drawing = true
        end
    else
        if drawing then
            removeEventHandler('onClientRender', root, drawChangeData)
            drawing = false
        end
    end
end

addCommandHandler('hud', function()
    toggleHUD(not drawing)
end)

addEventHandler('rust:onClientPlayerSpawn', localPlayer, function()
    toggleHUD(true)
end)

addEventHandler('onPlayerToggleInv', localPlayer, function(state)
    toggleHUD(not state)
end)

addEventHandler('rust:onClientPlayerDie', localPlayer, function()
    toggleHUD(false)
end)

function initHUD()
    hud.topBar = UI:createText(0, 0, sW, pixels(20), '', false, nil, {
        ['text-align-x'] = 'right',
        ['text-align-y'] = 'top',
        font = cfont('franklin'),
        textColor = {255, 255, 255, 255},
    })
    guiSetProperty(hud.topBar, 'AlwaysOnTop', 'True')

    hud.stats = {}
    for i = 1, #personalHUDDisplay do
        local w, h = math.floor(sW * 0.15), math.floor(sH * 0.04)
        local margin = 3

        local arr = personalHUDDisplay[i]
        local display = arr.display
        local icon = arr.icon
        local tipo = arr.type
        local drawFunc = arr.draw
        personalHUDDisplay.stacks[display] = personalHUDDisplay.stacks[display] + 1

        local x, y
        if display == 'horizontal' then
            x = sW - w - margin
            y = sH - pixels(20) - personalHUDDisplay.stacks.horizontal * (h + 2)
        else
            local tempW = pixels(50)
            x = sW - w - 5 - (tempW * personalHUDDisplay.stacks[display]) - personalHUDDisplay.stacks[display]
            y = sH - pixels(20) - personalHUDDisplay.stacks.horizontal * (h + 2)
            w, h = tempW, personalHUDDisplay.stacks.horizontal * (h + 2) - 2
        end

        local bg = UI:CreateRectangle(x, y, w, h, false, nil, {
            bgColor = {0, 0, 0, 200},
        })

        guiSetVisible(bg, false)

        if icon then
            UI:CreateImageWithBG(0, 0, h, h, (':gamemode/files/images/%s'):format(icon), false, bg, {
                bgColor = {0, 0, 0, 0},
                imgColor = {255, 255, 255, 100},
            })
        end

        hud.stats[tipo] = {
            bg = bg,
        }
        if drawFunc and type(drawFunc) == 'function' then
            if display == 'horizontal' then
                drawFunc(h, 0, w - h - 2, h - 2, bg)
            elseif display == 'vertical' then
                drawFunc(1, 1, w - 2, h - 2, bg)
            end
        end
    end
end

function updateHUD()
    local str = '| '
    for info, func in pairs(topBarDisplay) do
        str = ('%s%s: %s | '):format(str, info, func())
    end
    if not isElement(hud.topBar) then
        return killTimer(sourceTimer)
    end
    guiSetText(hud.topBar, str)
    for k, v in ipairs(personalHUDDisplay) do
        if v.update then
            v.update()
        end
    end
end

local changedData = {}
function addChangeDataMsg(text, r, g, b)
    if text and r and g and b then
        if #changedData > 50 then
            table.remove(changedData, 1)
        end
        table.insert(changedData, {
            text = text,
            r = r,
            g = g,
            b = b,
            initTick = getTickCount(),
        })
    end
end

local otherDataToShow = {
    ['blood'] = true,
}

addEventHandler('onClientElementDataChange', localPlayer, function(key, old, new)
    if getElementData(localPlayer, 'account') then
        if isItemOfInventory(key) or otherDataToShow[key] then
            if not tonumber(old) then
                old = false
            end
            key = translate(key, 'name')
            if new and tonumber(new) then
                if new > (old or 0) then
                    addChangeDataMsg(('+%s %s'):format(new - (old or 0), key), 110, 125, 65)
                else
                    addChangeDataMsg(('-%s %s'):format((old or 0) - new, key), 200, 20, 20)
                end
            else
                if old and tonumber(old) then
                    addChangeDataMsg(('-%s %s'):format(old, key), 200, 20, 20)
                end
            end
        end
    end
end)

function drawChangeData()
    local w = math.floor(sW * 0.15)
    local margin = 3
    local endX = sW - w - margin
    local originalY = sH - pixels(20) - personalHUDDisplay.stacks.horizontal * (math.floor(sH * 0.04) + 2)

    local h = pixels(25)

    for i = #changedData, 1, -1 do
        local data = changedData[i]
        local y = originalY - (h + 1) * i
        local x, alpha

        local now = getTickCount()
        local passed = now - data.initTick

        local animSpeed = 1000
        if passed <= animSpeed then
            local progress = passed / animSpeed
            y = interpolateBetween(originalY, 0, 0, y, 0, 0, progress, 'OutQuad')
            alpha = interpolateBetween(0, 0, 0, 255, 0, 0, progress, 'Linear')
            x = endX

        elseif passed >= 4000 then
            local progress = ((data.initTick + 5000) - now) / 500
            x = interpolateBetween(sW, 0, 0, endX, 0, 0, progress, 'InBounce')
            alpha = interpolateBetween(0, 0, 0, 200, 0, 0, progress, 'Linear')
        else
            x = endX
            alpha = 200
        end

        dxDrawRectangle(x, y, w, h, tocolor(data.r, data.g, data.b, alpha))
        dxDrawText(data.text, x, y, x + w, y + h, tocolor(255, 255, 255, 200), 1, font('franklin'), 'center', 'center')

        if passed > 5000 then
            table.remove(changedData, i)
        end
    end

    if getElementData(localPlayer, 'brokenbone') then
        local zoom = math.sin(getTickCount() / 500) * 0.1
        local x, y, z = getPedBonePosition(localPlayer, 8)
        z = z + 0.35 + zoom / 2

        local radius = 0.2 + zoom
        dxDrawMaterialLine3D(x, y, z + radius * 0.75, x, y, z - radius * 0.75, getTexture('ui/brokenbone.png'), radius, tocolor(255, 255, 255, 255));
    end
    guiSetInputMode('no_binds_when_editing')
end

local HitMarker = {}

addHitMarker = function(hitIcon, damage, hitx, hity, hitz)
    table.insert(HitMarker, {
        hitIcon = hitIcon,
        damage = damage,
        initTick = getTickCount(),
        hitx = hitx,
        hity = hity,
        hitz = hitz,
    })
    if #HitMarker == 1 then
        addEventHandler('onClientRender', root, drawHitMarker)
    end
end

addEvent('AddHitMarker', true)
addEventHandler('AddHitMarker', localPlayer, addHitMarker)

drawHitMarker = function()
    local x, y = sW * 0.6, sH * 0.3
    for k, v in ipairs(HitMarker) do
        if (getTickCount() - v.initTick) <= 4000 then
            y = y + 25
            local x = x
            if v.hitIcon then
                if (v.hitIcon == 'fodase') then
                    dxDrawImage(x, y, 20, 20, ('files/images/UI/headshot.png'):format(v.hitIcon))
                    x = x + 22
                    dxDrawImage(x, y, 20, 20, ('files/images/UI/die.png'):format(v.hitIcon))
                else
                    dxDrawImage(x, y, 20, 20, ('files/images/UI/%s'):format(v.hitIcon))
                end
            end
            if v.damage then
                dxDrawBorderedText(('-%s'):format(v.damage), x + 25, y, 0, y + 20, 0xFFFF0000, 1, font('franklin:little'), 'left', 'center')
            end

            if (getTickCount() - v.initTick) <= 200 then
                if (v.hitx and v.hity and v.hitz) then
                    local x, y = getScreenFromWorldPosition(v.hitx, v.hity, v.hitz)
                    if (x and y) then
                        local w = pixels(32)
                        dxDrawImage(x - w / 2, y - w / 2, w, w, 'files/images/UI/hitmarker.png')
                    end
                end
            end

        else
            table.remove(HitMarker, k)
            if #HitMarker == 0 then
                removeEventHandler('onClientRender', root, drawHitMarker)
            end
        end
    end
end

-- local KillFeed = {}

-- addKillFeed = function(reason, weapon)
--     table.insert(KillFeed, {
--         str = 'str',
--         initTick = getTickCount(),
--     })

--     if #KillFeed == 1 then
--         addEventHandler('onClientRender', root, drawKillFeed)
--     end
-- end

-- drawKillFeed = function()
--     local x, y = sW * 0.625, sH

--     local w = sH*0.3

--     for i = #KillFeed, 1, -1 do
--         local v = KillFeed[i]
--         if (getTickCount() - v.initTick) <= 3000 then
--             y = y - 25

--             dxDrawRectangle(x, y, pixels(460), pixels(25))
--             -- dxDrawBorderedText(v.str, x, y, 0, y + 20, 0xFFFF0000, 1, font('franklin'), 'left', 'center')
--         else
--             table.remove(KillFeed, i)
--             if #KillFeed == 0 then
--                 removeEventHandler('onClientRender', root, drawKillFeed)
--             end
--         end
--     end
-- end

-- for i = 1, 50 do
--     setTimer(function()
--         addKillFeed('asd', '123')
--     end, 500 * i, 1)
-- end
