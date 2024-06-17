sW, sH = guiGetScreenSize()

LoadScreen = {
    state = 'downloading',
    fonts = {
        ['cancel'] = dxCreateFont('assets/fonts/kommom.otf', sH * 0.015, true),
        ['cancel_2'] = dxCreateFont('assets/fonts/kommom.otf', sH * 0.0155, true),
        ['info'] = dxCreateFont('assets/fonts/kommom.otf', sH * 0.015, true),
        ['loading'] = dxCreateFont('assets/fonts/kommom.otf', sH * 0.03, true),
    },
    background = {
        [1] = {
            img = math.random(4),
            tick = getTickCount(),
            fade = 'in',
        },
        [2] = {},
    },
    header = 'Carregando arquivos',
    info = false,
    hover = false,
    rot = 0,
}

timeBetweenScreens = 10000
animSpeed = 3500

local Init = function()
    if (not getElementData(localPlayer, 'account')) then
        toggleLoadScreen(true)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, Init)

getNextBG = function()
    local actualImg = LoadScreen.background[1].img
    LoadScreen.background[1].fade = LoadScreen.background[1].fade == 'in' and 'out' or 'in'
    LoadScreen.background[1].tick = getTickCount()
    LoadScreen.background[1].img = LoadScreen.background[2].img or actualImg

    LoadScreen.background[2].tick = getTickCount()
    LoadScreen.background[2].fade = LoadScreen.background[2].fade == 'in' and 'out' or 'in'
    LoadScreen.background[2].img = actualImg + 1 > 4 and 1 or actualImg + 1

    LoadScreen.LastChangeTick = getTickCount()

    local newID = LoadScreen.InfoMessage + 1
    if (newID > #POSSIBLE_MESSAGES) then
        newID = 1
    end
    LoadScreen.InfoMessage = newID
end

table.shuffle = function(x)
    local shuffled = {}
    for i, v in ipairs(x) do
        local pos = math.random(1, #shuffled + 1)
        table.insert(shuffled, pos, v)
    end
    return shuffled
end

toggleLoadScreen = function(state)
    if state then
        addEventHandler('onClientRender', root, drawLoadScreen)
        addEventHandler('onClientClick', root, onClick)
        LoadScreen.timerChangeBG = setTimer(getNextBG, timeBetweenScreens, 0)

        LoadScreen.LastChangeTick = getTickCount()
        POSSIBLE_MESSAGES = table.shuffle(POSSIBLE_MESSAGES)
        LoadScreen.InfoMessage = 1
        showCursor(true)
        showChat(false)
    else
        showChat(true)
        showCursor(false)
        if isTimer(LoadScreen.timerChangeBG) then
            killTimer(LoadScreen.timerChangeBG)
        end
        removeEventHandler('onClientRender', root, drawLoadScreen)
        removeEventHandler('onClientClick', root, onClick)
    end
end

drawLoadScreen = function()
    LoadScreen.hover = nil

    LoadScreen.background[1].alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - LoadScreen.background[1].tick) / animSpeed, 'Linear')

    if LoadScreen.background[1].fade == 'out' then
        LoadScreen.background[1].alpha = 255 - LoadScreen.background[1].alpha
    end
    dxDrawImage(0, 0, sW, sH, getTexture(('background_%s'):format(LoadScreen.background[1].img)), 0, 0, 0,
                tocolor(255, 255, 255, LoadScreen.background[1].alpha), true)

    if LoadScreen.background[2].img then
        LoadScreen.background[2].alpha =
            interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - LoadScreen.background[2].tick) / animSpeed, 'Linear')
        if LoadScreen.background[2].fade == 'out' then
            LoadScreen.background[2].alpha = 255 - LoadScreen.background[2].alpha
        end
        dxDrawImage(0, 0, sW, sH, getTexture(('background_%s'):format(LoadScreen.background[2].img)), 0, 0, 0,
                    tocolor(255, 255, 255, LoadScreen.background[2].alpha), true)
    end

    dxDrawRectangle(0, 0, sW, sH, tocolor(35, 33, 27, 200), true)

    dxDrawImage((sW - 604) / 2, sH * 0.05, 604, 116, 'assets/img/discord.png', 0,0,0, tocolor(255, 255, 255, 150), true)

    local str = POSSIBLE_MESSAGES[LoadScreen.InfoMessage]
    local width, height = dxGetTextSize(str, sW * 0.75, 1, 1, LoadScreen.fonts['cancel'], true, true)

    if (type(width) == 'table') then
        width, height = unpack(width)
    end

    local offset = sH * 0.01
    dxDrawRectangle(sW * 0.01, sH * 0.2 - offset, sW * 0.0035, height + offset * 2, tocolor(191, 185, 175, 150), true)
    dxDrawText(str, sW * 0.01 + sW * 0.01, sH * 0.2, sW, sH * 0.7, tocolor(191, 185, 175, 150), 1, LoadScreen.fonts['cancel'], 'left', 'top', true,
               true, true, true)

    local w, h = sW * 0.3, sH * 0.125
    local x, y = sW / 2 - w / 2 - h * 1.15, sH * 0.7
    dxDrawImage(x, y, w, h, getTexture('shadow'), 0, 0, 0, tocolor(255, 255, 255, 15), true)

    local hover = isHover(x + w, y, h * 1.15, h)
    local color, font = tocolor(138, 46, 27), LoadScreen.fonts['cancel']
    if hover then
        color, font = tocolor(138, 55, 27), LoadScreen.fonts['cancel_2']
        LoadScreen.hover = 'Cancel'
    end
    dxDrawRectangle(x + w, y, h * 1.15, h, color, true)
    dxDrawText('CANCELAR', x + w, y, x + w + h * 1.15, y + h, tocolor(208, 91, 37, 150), 1, font, 'center', 'center', false, false, true)

    if LoadScreen.info then
        dxDrawText(LoadScreen.header, x, y, x + w - 10, y + h * 0.7, tocolor(191, 185, 175, 150), 1, LoadScreen.fonts['loading'], 'right', 'bottom',
                   false, false, true)
        dxDrawText(LoadScreen.info, x, y + h * 0.7, x + w - 10, y + h, tocolor(191, 185, 175, 50), 1, LoadScreen.fonts['info'], 'right', 'top', false,
                   false, true)
    else
        dxDrawText(LoadScreen.header, x, y, x + w - 10, y + h, tocolor(191, 185, 175, 150), 1, LoadScreen.fonts['loading'], 'right', 'center', false,
                   false, true)
    end

    do
        local w = sH * 0.08
        local x = (sW - w) / 2
        local y = y + h * 1.3

        LoadScreen.rot = LoadScreen.rot + 5
        dxDrawImage(x, y, w, w, getTexture('loading'), LoadScreen.rot, 0, 0, tocolor(255, 255, 255, 15), true)

        local height = sH * 0.01
        local percent = interpolateBetween(0, 0, 0, sW, 0, 0, (getTickCount() - LoadScreen.LastChangeTick) / timeBetweenScreens, 'Linear')
        dxDrawRectangle(0, sH - height, percent, height, tocolor(138, 46, 27), true)
    end
end

setHeader = function(header)
    LoadScreen.header = header
end

setInfo = function(info)
    LoadScreen.info = info
end

onClick = function(btn, state)
    if btn == 'left' and state == 'down' then
        if LoadScreen.hover == 'Cancel' then
            triggerServerEvent('rust:customKick', localPlayer, 'Cancel loading')
        end
    end
end

local textures = {}
function getTexture(str)
    str = str and ('assets/img/%s.png'):format(str)
    if str then
        if textures[str] ~= nil then
            return textures[str]
        else
            local file = str and fileExists(str)
            if file then
                local tex = dxCreateTexture(str, 'argb', true, 'clamp')
                if tex then
                    textures[str] = tex
                    return textures[str]
                end
            end
        end
    end
    textures[str] = false
    return textures[str]
end

function _getCursorPosition(absolute)
    if not isCursorShowing() then
        return false
    end
    local x, y, worldx, worldy, worldz = getCursorPosition()
    if absolute then
        x = x * sW
        y = y * sH
    end
    return x, y, worldx, worldy, worldz
end

function isHover(x, y, w, h)
    if not isCursorShowing() then
        return false
    end
    local mx, my = _getCursorPosition(true)
    return (mx >= x and mx <= x + w) and (my >= y and my <= y + h)
end
